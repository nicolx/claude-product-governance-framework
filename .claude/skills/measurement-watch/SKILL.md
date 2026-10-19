---
name: measurement-watch
description: Scansiona le iniziative già rilasciate (idea status "done") e verifica se le loro KPI stanno mostrando gli impatti attesi, chiedendo al PM le letture correnti quando è passata la finestra di misurazione. Gestisce anche iniziative senza KPI di business (es. compliance) e l'atto di chiusura/accettazione che chiude il cantiere di misurazione. Guarda anche avanti: dallo slot plan dello snapshot, verifica che le iniziative in rilascio nelle prossime settimane abbiano la misurazione pronta (baseline catturata, evento strumentato) prima che sia troppo tardi. Usala periodicamente e sempre all'apertura del Backlog Refinement.
---

# measurement-watch

Un'iniziativa rilasciata non finisce il suo ciclo con il deploy — la
Definition of Done risponde a "abbiamo consegnato?", non a "ha
funzionato?" (playbook, "Product Design, development and rollout" /
"Measurement"). Questa skill è il meccanismo che impedisce che la
domanda "ha funzionato?" resti senza risposta perché nessuno se n'è più
occupato: se un'iniziativa è in produzione da settimane, qualcuno deve
controllare le KPI dichiarate nel suo PRD e decidere se c'è un impatto,
serve ancora tempo, o l'ipotesi non ha retto — o, se l'iniziativa non ha
mai avuto una KPI di business (tipico delle richieste di mera
compliance), qualcuno deve comunque accettare esplicitamente di chiudere
il cantiere, invece di lasciarlo in un limbo indefinito.

## Quando usarla

- **Standalone**, in qualunque momento: "quali iniziative dovrebbero
  già mostrare impatti?", "controlliamo lo stato delle misurazioni",
  "possiamo chiudere il cantiere di misurazione di X?".
- **Durante il Backlog Refinement** la logica di questa skill gira
  **inline** nella sweep di apertura di `backlog-refinement` (un solo
  `pull`, un solo `governance-dump.sh sweep`, un solo commit per tutte le
  watch — vedi playbook, "La sweep di apertura dev'essere calcolo, non
  attesa di I/O"; l'apertura "guardando indietro" resta il principio).
  Non invocarla da lì. Questo file resta il punto d'ingresso
  **standalone** e la fonte normativa delle formule di seguito.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** scrivere su
> `product/` (nemmeno `readings`/`measurement_status`/`closure`), **non**
> invocare `governance-sync.sh push`, mostra come testo l'output completo
> che avresti prodotto, e chiudi con `🔍 DRY-RUN — nessun file scritto,
> nessun commit, nessun push.`

0. **Sincronizza, leggi in blocco, verifica il connettore metriche** (uso
   standalone): `bash .claude/hooks/governance-sync.sh pull`, poi `bash
   .claude/hooks/governance-dump.sh measurements` — i `measurement*.yaml`,
   le `idea.yaml` e l'ultimo snapshot approvato (lo `slot_plan`) in un
   colpo.
   - **Se `.governance/config.yaml` ha `metrics.integration` = `mcp:*` o
     `cli:*`**, verifica che il connettore risponda usando `metrics.probe`.
     Se **dichiarato ma irraggiungibile**, applica la regola del playbook,
     "Connettori esterni: dichiarati, verificati a inizio processo, mai un
     fallback silenzioso" — non degradare in silenzio all'inserimento
     manuale: segnala, proponi il comando `metrics.reauth` dichiarato in
     config, chiedi al PM; se procede, le letture di questo run le dà lui
     a mano e il gap va nel riepilogo come **rimandato**.
     `manuale`/`configured: false` → come sempre, nessuna segnalazione.

1. **Elenca le iniziative rilevanti**: idee con `status: done` e
   `done_at` valorizzato, che hanno almeno un PRD collegato (`links.prd_ids`
   non vuoto) con un `measurement.yaml` (o `measurement-N.yaml`) nella
   sua cartella, **e `closure.closed` ancora `false`** (le iniziative già
   chiuse non vanno riconsiderate — vedi passo 5). Se `status: done` ma
   `done_at` è `null`, chiedi al PM la data (**mai presumere "oggi"**) e
   scrivila su `idea.yaml` prima di procedere — è un fatto mancante, non
   una decisione, scrittura diretta.

2. **Se `kpis` è vuoto**, non trattarlo come un errore da correggere a
   tutti i costi: è il caso legittimo di un'iniziativa senza metrica di
   business attesa (tipico per `classification: mandate` con
   `rationale` di compliance normativa — vedi playbook, "Iniziative
   Mandatarie"). Se anche `not_applicable_reason` è vuoto, chiedi al PM
   se è corretto che non ci sia una KPI, e se sì fallo scrivere (mai
   presumere tu il motivo). Poi passa direttamente al passo 5 (l'atto di
   chiusura) per questa iniziativa — non ha senso continuare a
   segnalarla ad ogni run se non c'è nulla da misurare, ma resta comunque
   necessario un atto esplicito di accettazione prima di considerarla
   chiusa.

3. **Per ciascuna KPI in `kpis`** (quando non è vuoto), calcola le
   settimane trascorse da `done_at` e confrontale con
   `measurement_window_weeks`:
   - Se non ancora passata: `measurement_status: pending`, non serve
     fare nulla — non è ancora il momento di aspettarsi impatti.
   - Se passata e `readings` è vuoto: `measurement_status: check_due` —
     **questo è il caso centrale**. Guarda `data_source.mode`:
     - `manual` — chiedi al PM il valore attuale della metrica (ha
       accesso agli strumenti di analytics dell'istanza, per playbook).
     - `automated` — dipende da `metrics` in `.governance/config.yaml`
       (verificato al passo 0):
       - **`metrics.configured: true` e connettore raggiungibile** →
         se la KPI ha `data_source.path_ref`, leggi dal connettore
         l'**aggregato** del path con quell'`id` in `monitoring.paths`
         dell'idea (stessa forma della sua `baseline`: valore, unità,
         finestra) — è una query mirata a un path dichiarato e verificato,
         non una query libera (skill `path-watch`). Se il path è
         `broken`/`to_instrument`/`removed`, non leggere: segnalalo e
         chiedi al PM. Senza `path_ref` il *contratto di query* generale
         non esiste ancora (`framework/docs/future-work.md`): questo caso
         si riduce a "chiedi al PM il valore letto dal connettore".
       - **`metrics.configured: true` ma connettore irraggiungibile** →
         **non** è come `manual`: è il caso "dichiarato ma irraggiungibile"
         (playbook, "Connettori esterni…"). Segnalato già al passo 0; qui
         la lettura la dà il PM a mano per questo run e la mancata lettura
         automatica resta **rimandata** nel riepilogo.
       - **`metrics.configured: false`** → `automated` è solo un intento
         del PRD senza connettore: comportati come `manual` e chiedi al
         PM, nessuna segnalazione. Non bloccare né inventare un valore.
       In tutti i casi, quando ottieni un valore, **mostralo sempre nel
       riepilogo del run prima/al momento di scriverlo** — è trasparenza,
       non un gate di approvazione: non serve una conferma aggiuntiva per
       una lettura automatica riuscita.
     Se ottieni un valore, appendi una nuova voce a `readings` con
     `date`, `value`, `source`. Se resta senza valore, lascialo
     `check_due` e segnalalo comunque nel riepilogo — non è un errore, è
     un'informazione che manca.
   - Se passata e ci sono già `readings`: confronta l'ultima lettura con
     `baseline`/`target` (attenzione alla direzione attesa — un
     miglioramento può essere un aumento o una diminuzione a seconda
     della metrica, non presumere sempre "più alto è meglio") e imposta
     `measurement_status` tra `on_track`/`achieved`/`at_risk`/
     `invalidated`/`inconclusive`. Se il dato più recente ha più di
     `measurement_window_weeks` di anzianità, chiedi comunque al PM se
     c'è una lettura più fresca prima di dare per buono un giudizio
     stantio.

4. **Scrivi `measurement_status` direttamente** su ciascuna KPI — è una
   valutazione calcolata dai dati, non una decisione di priorità, **non
   passa da `product/approvals/pending/`** (stesso principio di
   `escalation_status` in `mandate-watch`). Per le KPI `at_risk` o
   `invalidated`, chiedi esplicitamente al PM se serve un follow-up: "I
   dati suggeriscono che l'ipotesi non sta reggendo — vuoi che prepari
   una nuova idea per iterare (via `idea-intake`), o consideriamo chiusa
   questa iniziativa così com'è?" Se conferma che serve un follow-up,
   imposta `follow_up_needed: true` e **suggerisci** `idea-intake` sul
   follow-up — **non creare tu stessa la nuova idea**.

5. **L'atto di chiusura (`closure`).** Distinto dallo stato delle
   singole KPI: è la decisione che chiude l'intero cantiere di
   misurazione per questa iniziativa, "si è mossa o non si è mossa come
   sperato, comunque smettiamo di seguirla" — nelle parole dell'utente.
   Proponilo esplicitamente al PM quando ha senso (KPI tutte
   `achieved`/`at_risk`/`invalidated` da un po', oppure kpis vuoto per il
   caso compliance del passo 2), **ma non chiuderlo mai di tua
   iniziativa**. Se il PM conferma, scrivi:
   - `closed: true`, `closed_at` (oggi), `closed_by` (chi lo conferma —
     chiesto, mai presunto)
   - `outcome`: `achieved` | `not_achieved_accepted` | `not_applicable`
     (per il caso senza KPI) | `inconclusive_accepted`
   - `note`: il perché in una riga, nelle parole del PM

   **Gate: la chiusura si comunica.** Prima di scrivere `closed: true`,
   apri sull'idea una voce `conclusion_notices` (`kind:
   measurement_closed`, `detected_by: measurement-watch`, `source_ref` =
   percorso del `measurement*.yaml`) con una bozza di avviso agli
   stakeholder: l'esito (`outcome`/`note` nelle parole del PM), cosa
   significa, l'eventuale follow-up. `recipients` = stakeholders della
   `product_line` + `proposer` (il PM conferma/edita). **Mostrala per
   intero, non inviarla** — testo semplice pronto da copiare nel client
   di posta (playbook, "Testi che il PM manda a mano: visibili e pronti da copiare"), calibrata sui destinatari (playbook, "L'identikit degli stakeholder e il rapporto individuale"). `closure` si scrive **nello stesso passo** in cui il PM
   dichiara l'avviso inviato (`notice_status: sent` + `sent_at`) o lo
   esenta con un motivo suo (`waived` + `waived_reason`). Se il PM
   rimanda l'invio, la voce resta `drafted` e `closure.closed` resta
   `false` — l'iniziativa continua a comparire, segnalata come "chiusura
   decisa, avviso da inviare" (playbook, "Avvisare gli stakeholder della
   conclusione").

   Anche questa è cattura di una decisione già presa in conversazione,
   non passa da `product/approvals/pending/`. Da questo momento,
   `measurement-watch` non segnala più questa iniziativa nei run
   successivi (passo 1).

5b. **Rilasci in arrivo: la misurazione è pronta?** Il resto di questa
   skill guarda indietro (iniziative già `done`); questo passo guarda
   avanti, perché alcune cose vanno fatte **prima** del rilascio o non si
   recuperano più. Dallo `slot_plan` dell'ultimo snapshot approvato
   (playbook, "Capacità del team e slot della roadmap"), prendi le idee
   non ancora `done` il cui slot finisce entro **6 settimane** e, per
   ciascuna, controlla — sola lettura, nessuna scrittura:
   - **c'è un `measurement*.yaml`?** Se l'idea ha un PRD ma nessun
     file di misurazione: "misurazione non preparata" (`prd-draft` la
     scaffolda). Se non ha nemmeno un PRD, dillo: sta per uscire
     un'iniziativa senza un documento che dica cosa doveva muovere;
   - **ogni KPI ha la `baseline`?** Una baseline `null` va catturata
     **adesso**: dopo il rilascio il dato di partenza è contaminato
     dall'iniziativa stessa. È il segnale più importante di questo passo;
   - **la fonte è pronta?** Per una KPI `data_source.mode: automated`
     con `path_ref`, se quel path in `monitoring.paths` dell'idea è
     `to_instrument` o `broken`, gli eventi mancanti vanno strumentati
     nello stesso rilascio — altrimenti la prima lettura automatica non
     ci sarà (requisito di tracciamento da portare al team, playbook
     "Path da monitorare");
   - **`kpis: []` senza `not_applicable_reason`**: chiedi ora se è
     davvero un'iniziativa senza metrica di business, invece di
     scoprirlo alla chiusura.
   Per ogni voce mostra la fine stimata dello slot ("fine nov (stima)",
   "stima grezza" se `rough`) e, se la misurazione è pronta, quando
   cadrà la **prima lettura attesa** (fine slot + `measurement_window_weeks`)
   — utile al PM per sapere quando servirà il dato. Se non c'è uno
   snapshot con `slot_plan`, salta il passo e dillo in una riga.

6. **Presenta un riepilogo ordinato per urgenza** (`check_due` e
   `at_risk`/`invalidated` prima, poi le iniziative senza KPI ancora da
   accettare, poi `on_track`; le iniziative appena chiuse in questo run
   vanno menzionate una volta, non ripetute). **Prima colonna:
   l'identificatore** — `short_ref` se assegnato, altrimenti lo slug
   `idea_id` (mai vuoto — vedi playbook, "Ogni elenco prodotto dal sistema
   è indirizzabile"), così il PM può riferirsi a una riga con "{ID}";
   per le righe di KPI, `{prd_id} · {kpi_name}`. Poi `summary`, R · I · C
   · E e RICE dell'idea ("—" e il motivo se senza RICE — playbook, "Ogni riga che parla di un'idea si capisce da sola"), nome della KPI (o
   "nessuna KPI" per il caso compliance), settimane da `done_at`, ultimo
   valore noto vs. baseline/target. **Solo segnalazione** per ciò che
   resta aperto — nessuna comunicazione o escalation automatica, stesso
   principio di `mandate-watch`. In coda, la sezione **Rilasci in
   arrivo** del passo 5b — prima le baseline mancanti, poi gli eventi da
   strumentare, poi le misurazioni non preparate.

7. Se chiamata da `backlog-refinement`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa in
   `decisions.yaml`, è compito di `log-ceremony`.

8. **Sincronizza il repo**: se i passi 1-5 hanno scritto almeno un
   `idea.yaml`/`measurement*.yaml`, esegui
   `bash .claude/hooks/governance-sync.sh push "measurement-watch: aggiornate misurazioni" product/ideas/ product/prds/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)") — anche se
   richiamata da `backlog-refinement`.

## Cosa NON fare

- Non scrivere nulla sulle iniziative del passo 5b: baseline, eventi e
  file di misurazione li prepara chi li possiede (`prd-draft`,
  `path-watch`, il PM che dà il valore) — la watch li segnala in tempo.
- Non inventare un valore di lettura per completare uno schema — se il
  PM non lo sa, resta `check_due`, non forzare un numero.
- Non inventare una KPI proxy per un'iniziativa che non ne ha (es.
  compliance) solo per non lasciare `kpis` vuoto — `not_applicable_reason`
  è la risposta corretta, non una metrica di comodo.
- Non decidere autonomamente che un'iniziativa è `achieved`/`invalidated`
  senza dati reali a supporto — un giudizio senza readings è
  `inconclusive`, non un esito positivo o negativo per default.
- Non creare una nuova idea di follow-up di tua iniziativa — proponilo,
  la creazione resta un passo esplicito del PM tramite `idea-intake`.
- Non impostare `closure.closed: true` senza una voce
  `conclusion_notices` `measurement_closed` `sent` o `waived` — la
  chiusura non comunicata non è una chiusura.
- Non impostare `closure.closed: true` senza una decisione esplicita del
  PM in questa conversazione — nemmeno per le iniziative senza KPI:
  "non c'è nulla da misurare" non equivale a "possiamo chiuderla senza
  chiedere".
- Non simulare o inventare una lettura "automatica" quando
  `data_source.mode: automated` ma non esiste ancora un'integrazione
  reale configurata — è esattamente il tipo di dato inventato che questo
  framework vieta ovunque. Se l'integrazione non c'è, chiedi al PM come
  faresti in modalità manuale.
