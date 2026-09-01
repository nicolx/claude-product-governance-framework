---
name: measurement-watch
description: Scansiona le iniziative già rilasciate (idea status "done") e verifica se le loro KPI stanno mostrando gli impatti attesi, chiedendo al PM le letture correnti quando è passata la finestra di misurazione. Gestisce anche iniziative senza KPI di business (es. compliance) e l'atto di chiusura/accettazione che chiude il cantiere di misurazione. Usala periodicamente e sempre all'apertura del Backlog Refinement.
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
- **Richiamata da `log-ceremony`**, e idealmente **in apertura** del
  Backlog Refinement (playbook, sezione "Product Backlog Refinement"):
  prima di guardare cosa entra in agenda, si guarda cosa è già stato
  rilasciato e se sta rendendo — è tracciare le metriche su Git, nel
  tempo, che permette di capire dove veicolare gli investimenti futuri.

## Passi

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)") prima di scansionare le
   iniziative rilasciate.

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
     - `automated` — se l'istanza ha una vera integrazione configurata
       localmente (vedi `framework/docs/future-work.md` — non esiste
       ancora nel framework di base), tenta la lettura da lì; **se non
       esiste**, comportati esattamente come `manual` e chiedi al PM —
       non bloccare né inventare un valore solo perché il PRD dichiara
       "automated" come intento. In entrambi i casi, quando ottieni un
       valore (dal PM o da un'integrazione reale), **mostralo sempre nel
       riepilogo del run prima/al momento di scriverlo** — è
       trasparenza, non un gate di approvazione: non serve una conferma
       aggiuntiva per una lettura automatica riuscita.
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

   Anche questa è cattura di una decisione già presa in conversazione,
   non passa da `product/approvals/pending/`. Da questo momento,
   `measurement-watch` non segnala più questa iniziativa nei run
   successivi (passo 1).

6. **Presenta un riepilogo ordinato per urgenza** (`check_due` e
   `at_risk`/`invalidated` prima, poi le iniziative senza KPI ancora da
   accettare, poi `on_track`; le iniziative appena chiuse in questo run
   vanno menzionate una volta, non ripetute): per ciascuna, `idea_id`,
   nome della KPI (o "nessuna KPI" per il caso compliance), settimane da
   `done_at`, ultimo valore noto vs. baseline/target. **Solo
   segnalazione** per ciò che resta aperto — nessuna comunicazione o
   escalation automatica, stesso principio di `mandate-watch`.

7. Se chiamata da `log-ceremony`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa in
   `decisions.yaml`, è compito di `log-ceremony`.

8. **Sincronizza il repo**: se i passi 1-5 hanno scritto almeno un
   `idea.yaml`/`measurement*.yaml`, esegui
   `bash .claude/hooks/governance-sync.sh push "measurement-watch: aggiornate misurazioni" product/ideas/ product/prds/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)") — anche se
   richiamata da `log-ceremony`.

## Cosa NON fare

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
- Non impostare `closure.closed: true` senza una decisione esplicita del
  PM in questa conversazione — nemmeno per le iniziative senza KPI:
  "non c'è nulla da misurare" non equivale a "possiamo chiuderla senza
  chiedere".
- Non simulare o inventare una lettura "automatica" quando
  `data_source.mode: automated` ma non esiste ancora un'integrazione
  reale configurata — è esattamente il tipo di dato inventato che questo
  framework vieta ovunque. Se l'integrazione non c'è, chiedi al PM come
  faresti in modalità manuale.
