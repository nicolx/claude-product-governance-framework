---
name: idea-intake
description: Trasforma materiale grezzo (email, trascrizione, segnalazione) in una nuova idea strutturata in product/ideas/, classificandola come idea/bug/strategic exception/mandate/platform — o scartandola al triage (declined) se non è roba da fare — secondo il playbook. Prepara sempre una bozza di risposta al richiedente. Usala quando l'utente allega o incolla materiale nuovo da valutare.
---

# idea-intake

Trasforma materiale grezzo — email, trascrizione di riunione, messaggio,
segnalazione — in un'idea strutturata, secondo il playbook (sezione
"Alimentazione del bucket delle idee").

Non richiede che il materiale sia passato da `product/inbox/` — è
utilizzabile direttamente su qualunque materiale grezzo l'utente fornisca
in conversazione (allegato, testo incollato, riferimento a un file). La
skill `inbox-triage` la richiama internamente per il caso "nuova idea",
ma non è l'unico modo di usarla.

## Prerequisiti

Richiede un'istanza inizializzata (`.governance/config.yaml` presente e
`product/reference/product-lines.yaml` popolato). Se mancano, ferma e
indirizza a `init-governance-project`.

## Principio guida: garantista, non produttivista

**Meglio una domanda in più che un'idea scritta male.** Un record con
dati inferiti o indovinati per completare lo schema è peggio di non
averlo ancora creato — qualcuno prioritizzerà o lavorerà su basi
sbagliate, e il costo si scopre solo dopo. Se manca un dato essenziale
(chi è il proponente, qual è davvero il problema, perché sembra
rilevante) e non è ricavabile con certezza dal materiale, **chiedi
all'utente prima di scrivere**, non riempire il campo a caso. Vale anche
per Product Line, per l'ipotesi che l'idea sia un duplicato di una già
esistente, e per qualunque numero o affermazione non letteralmente
presente nel materiale di origine.

**Garantista non vuol dire buttare via.** Un esempio con numeri detto dal
proponente ("il 5% dei dipendenti è stressato, il 3% ha trovato una
soluzione") non è un dato da usare come stima — ma è materiale prezioso per
chi scriverà e progetterà dopo. Non si scarta: si conserva marcato come
**illustrativo** (`info_kind: illustrative` nel registro dei punti chiave),
usabile come narrativa e mai come stima (RICE, baseline, target). Vedi
playbook, "Scrivere per il lettore", tabella "Tipi d'informazione".

## Modalità backfill (invocata da `delivery-watch`, non interattiva)

`delivery-watch` invoca questa skill in modalità **backfill** quando
intercetta attività su una card del tracker di esecuzione **non collegata**
a nessuna idea — lavoro partito dritto su Jira, fuori dalla governance
(precedente: `context-watch` → `context-intake` in auto-apply). Non è un
intake da materiale grezzo: la fonte è una card Jira già letta.

In questa modalità:

- **Nessuna conversazione, nessuna conferma per-elemento.** Si crea
  comunque la cartella idea subito — recuperare il tracciamento è il
  punto; la revisione avviene dopo.
- **Seed dalla card**: `title` = summary della card; `summary` = una riga
  dalla description (o dal summary se la description è vuota);
  `classification` inferita — `issuetype: Bug` → `bug`, altrimenti
  `idea`; `product_line` inferita dalla card se possibile, altrimenti
  `delivery_watch.default_product_line` da `.governance/config.yaml`,
  altrimenti `""`; `proposer` = reporter della card se disponibile,
  altrimenti `""`.
- `source.type: jira_backfill`, `source.ref` = chiave della card (es.
  `EPITA-317`). In `source/` salva un breve `source/jira-<key>.md` con i
  campi letti dalla card (summary, description, issuetype, status,
  reporter, URL) — non un intero export.
- `jira.card_id` / `jira.url` / `jira.status` popolati dalla card;
  `jira.last_polled_at` = ora. `status` dell'idea: `in_jira` (il lavoro è
  già sul tracker). `rice_history` vuoto, `short_ref: null` (li assegnano
  `rice-update`/`backlog-refinement` come sempre).
- **`backfill_review_needed: true`** — è ciò che segnala a
  `delivery-watch` (triage) e a `backlog-refinement` che
  classificazione/product_line/summary sono abbozzati e vanno confermati
  dal PM (o l'idea archiviata come `declined`/`aborted` se è lavoro
  spurio).
- **NON** creare un nuovo ticket sul tracker (esiste già), **non**
  compilare `requester_reply`/`clarification`, **non** aprire un
  `deep_dive`.
- Restituisci a `delivery-watch` lo slug creato. Il `push` lo fa
  `delivery-watch` come parte del suo commit (o, se `idea-intake` gira
  come sotto-skill con il proprio sync, con messaggio
  `idea-intake: backfill <slug> da <key>`).

Fuori da questa modalità, la skill si comporta come descritto nei
"Passi" sotto.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** scrivere su
> `product/`/`context/`/`.governance/` (nemmeno spostando file), **non**
> invocare `governance-sync.sh push`, **non** creare ticket sul tracker di
> esecuzione (per un bug, mostra come testo il ticket che avresti aperto),
> mostra come testo l'output completo che avresti prodotto, e chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push, nessun
> ticket creato.`

1. **Leggi il materiale grezzo** fornito dall'utente (allegato, testo
   incollato, o riferimento a un file).

   Se l'istanza ha app collegate in `apps/`, **porta il codice
   all'ultima versione** prima di classificare:
   `bash .claude/hooks/governance-sync.sh apps` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)", sottosezione "Codice
   applicativo (`apps/`)"). La diagnosi del passo 3 vale solo sul codice
   corrente. L'helper non blocca mai: un'app non aggiornata (modifiche
   locali, fetch fallito) va segnalata al PM insieme alla classificazione
   proposta. Vale anche in dry-run; non serve in modalità backfill (non c'è
   diagnosi: la card esiste già sul tracker).

2. **Decomponi prima di classificare, se il materiale mescola più
   richieste indipendenti.** Una singola mail o trascrizione può
   contenere più idee distinte, ciascuna con la propria priorità futura.
   **Criterio pratico**: se a due parti del contenuto assegneresti un
   RICE score indipendente e scollegato (Reach/Impact/Confidence/Entanglement
   diversi, senza che l'uno dipenda dall'altro), sono due idee, non una
   — non forzarle in un'unica cartella solo perché sono arrivate insieme.
   Da qui in poi, ripeti i passi 3-8 **per ciascuna unità risultante**,
   in modo completamente indipendente (classificazione, slug, RICE
   futuro, bozza di risposta separati). Se invece il materiale è coeso
   (un solo problema descritto da più angolazioni), resta un'unica idea.

3. **Classifica** ogni unità risultante secondo il playbook.

   **Verifica nel codice prima di classificare.** Se l'unità riguarda il
   comportamento di un'applicazione collegata in `apps/`, leggi il codice
   pertinente (aggiornato al passo 1) invece di classificare dal solo testo
   del mittente: un "bug" può essere il comportamento voluto (→ idea), una
   richiesta può essere già implementata (→ scarto o risposta al
   richiedente), un problema può essere debito tecnico (→ platform).
   Riporta l'esito nelle `notes` dell'idea con il riferimento verificabile
   (`apps/<slug>` @ commit, file/percorso) e proponilo al PM come ipotesi
   — il codice informa la diagnosi, non sostituisce la sua conferma. Se
   `apps/` è vuota o non pertinente, procedi senza.

   - **Bug** — se descrive un output diverso da quanto atteso per errore
     di codice o interpretazione errata del requisito. **Crea comunque la
     cartella idea** (passi 4-6 sotto), con `classification: bug` — serve
     per non perdere il materiale grezzo e per avere un record archiviato
     e diffabile. La differenza rispetto a un'idea normale: **non passa
     mai dal RICE** (`rice_history` resta `[]` per sempre, non solo in
     questo passo) e non entra nel Backlog Refinement per priorità.

     **Appena il PM conferma che è un bug, il ticket sul tracker di
     esecuzione va aperto subito** — vedi playbook, "Alimentazione del
     bucket delle idee", punto a. Non chiedere un secondo assenso ("vuoi
     che prepari il testo?", "lo apro?"): la conferma sulla classificazione
     è l'unico gate. Dopo aver completato la cartella (passi 4-7):
     - **Dedup prima.** Se il connettore permette la ricerca
       (`jira.integration`), cerca un ticket già esistente per lo stesso
       bug — stesso dedup del passo 3 di `jira-sync` Push. Se emergono
       candidati plausibili, mostrali al PM e chiedi qual è (o "è nuovo");
       se è chiaramente nuovo, procedi.
     - **Crea (o linka) il ticket** via il connettore dichiarato,
       includendo un **impatto stimato** (chiedilo al PM se non ricavabile
       dal materiale; per un tema di security segnala che va gestito ASAP).
       Delega a `jira-sync` Push (passi 3-6) per i dettagli del connettore.
     - **Popola `jira.card_id`/`jira.url`/`jira.status`** sull'idea e porta
       `status: in_jira`. È un fatto (il ticket esiste), scrittura diretta,
       **non** passa da `product/approvals/pending/` — segnalalo all'utente.
     - **Connettore `manuale` o dichiarato ma irraggiungibile** (non
       risponde): il bug non è filabile in automatico. Applica la regola di
       `jira-sync`, "Connettore dichiarato ma irraggiungibile" — prepara il
       testo del ticket pronto da incollare e riportalo nel riepilogo
       finale (passo 9) come **AZIONE NON COMPLETATA** in evidenza, con il
       comando `jira.reauth` e il promemoria di rilanciare `jira-sync`
       standalone appena il connettore torna su. Mai chiudere il punto come
       se il bug fosse stato filato.
     - Prepara al passo 8 una bozza di risposta al richiedente
       (`requester_reply`, `kind: bug_ack`).
     - **Riproduzione (facoltativa, dopo il filing).** Se il registro
       `product/reference/test-environments.yaml` ha un ambiente e un
       utente adatti a riprodurlo, proponi al PM di lanciare `app-test`
       (`repro`): i passi minimi di riproduzione e l'ambiente in cui il
       bug c'è davvero sono il complemento più utile al ticket. Non
       ritarda mai l'apertura del ticket, che resta immediata.
   - **Strategic Exception** — se il proponente è a un livello che nel
     `product/reference/` (o dichiarato dall'utente) qualifica per bypass
     del RICE. Crea comunque la cartella idea (serve comunque traccia),
     ma imposta `classification: strategic_exception` e aggiungi una voce
     a `strategic_exceptions` con `invoked_at_stage: intake` —
     `approved_by`/`reason` restano da confermare con l'utente, **non
     assumere l'approvazione**, chiedila esplicitamente. Prepara al passo
     8 una bozza di risposta al richiedente (`requester_reply`,
     `kind: strategic_exception_ack`) che dice "accolta su canale
     privilegiato, **in attesa di conferma** da {autorità}" — mai
     "approvata" finché non lo è.
   - **Mandate (iniziativa mandataria)** — se l'iniziativa è imposta
     dall'alto (leadership/board), marcata "critical" indipendentemente
     dai numeri, o vincolata a una scadenza esterna fissa (compliance,
     contratto, evento) — playbook, sezione "Iniziative Mandatarie". A
     differenza di bug/strategic exception, **non salta l'analisi**: va
     comunque in `in_analysis`/`in_prd` come un'idea normale, salta solo
     il RICE. Imposta `classification: mandate` e compila il blocco
     `mandate`: `mandated_by` e `rationale` **vanno sempre chiesti
     esplicitamente**, mai presunti dal ruolo o dal tono del mittente —
     non c'è un vincolo di ruolo su chi può dichiarare un mandate, per
     questo la disciplina nel chiedere conta di più, non di meno. Se
     emerge una `due_date`, chiedi anche una prima stima di
     `lead_time_weeks` (segnala che andrebbe validata con un referente
     tecnico appena possibile — se non disponibile subito, lascia `null`
     con una nota, non bloccare la creazione). Non compilare mai
     `analysis_start_by`/`escalation_status` — sono calcolati dalla
     skill `mandate-watch`, non a mano. Prepara al passo 8 una bozza di
     risposta al richiedente (`requester_reply`, `kind: mandate_ack`).
   - **Platform (debito tecnico/devops puro)** — non è un bug (non
     produce un output sbagliato) né un'idea di business: è manutenzione,
     upgrade, gestione del debito tecnico o attività devops che il team
     tech giudica necessaria (playbook, "flusso di protezione del team").
     Può arrivare sia dal team tech direttamente sia mediata dal PM —
     nessun vincolo su chi la propone. Imposta `classification: platform`
     e compila il blocco `platform`: `rationale` sempre chiesto
     esplicitamente (perché serve — rischio, manutenibilità, ecc.), non
     dedotto dal fatto che "viene dal team tech quindi ovviamente serve".
     Se emerge una stima di sforzo, chiedi `estimated_effort_weeks`
     (segnala che andrebbe validata dal team tech se chi la propone non
     lo è già) — serve al calcolo della capacità protetta in
     `roadmap-snapshot`, non a un RICE (che questa classification non ha
     mai). Come `mandate`, **non salta l'analisi**: le iniziative
     importanti seguono comunque `in_analysis`/`in_prd`; quelle piccole
     possono saltare direttamente a `in_jira`, a giudizio del team tech.
     Se la propone qualcuno che non è il PM, prepara al passo 8 una bozza
     di risposta (`requester_reply`, `kind: platform_ack`).
   - **Non è un'idea (scarto al triage)** — se il materiale non descrive
     qualcosa su cui il team di prodotto può o deve lavorare: una
     richiesta di supporto tecnico, un tema fuori dal perimetro del team,
     qualcosa già coperto altrove, o semplicemente "non è roba da fare".
     **Non scartarlo in silenzio.** Crea comunque la cartella idea (per
     archivio/audit), imposta `status: declined` e compila
     `decline_reason` in una riga. **Chiedi conferma esplicita al PM
     prima di scrivere `declined`** — è un giudizio, non un fatto: tu
     proponi ("questo sembra fuori perimetro perché…, lo segno come
     scartato?"), il PM conferma. Prepara al passo 8 una bozza di
     risposta al richiedente (`requester_reply`, `kind: decline`) che
     spiega con tono rispettoso perché il team non può aiutare su questo,
     e — se sensato — indirizza altrove.

   - **Idea normale** — il caso di default. Prepara al passo 8 una bozza
     di risposta al richiedente (`requester_reply`, `kind:
     acknowledgement`).

4. **Determina titolo, `summary`, proponente, Product Line** (per la
   singola unità che stai processando). Per convenzione, se il materiale
   è un'email, usa l'oggetto come titolo — se l'email è stata decomposta
   in più unità, aggiungi un breve suffisso che distingua i titoli tra
   loro. **`summary`**: una riga in linguaggio piano che dica *cosa c'è
   da fare*, comprensibile senza aprire `source/` — il titolo-oggetto
   spesso non basta. È il campo mostrato nella lista ordinata del backlog
   (`backlog-list`). Se non riesci a scriverla con quello che hai, è un
   segnale che il materiale è troppo vago: valuta `needs_clarification`.
   Se la Product Line non è ovvia, chiedi — non indovinare tra le opzioni
   in `product/reference/product-lines.yaml`. Se questa idea nasce da un
   riorientamento di Discovery confermato dalla skill `nsm-watch` (una
   NSM in degrado), chiedi se va collegata in `links.nsm_targeted` — non
   presumerlo solo perché il contesto della conversazione lo suggerisce.

   **Scadenza esterna.** Se il materiale menziona una data entro cui
   qualcosa va fatto (un impegno con un cliente, un evento, una finestra
   commerciale) e **non** stai classificando l'unità come `mandate` o
   `bug`, chiedi conferma e compila il blocco `deadline` (`due_date`
   precisa + `note` sul perché) — vedi playbook, "Scadenze su idee
   normali (`deadline`)". Non presumerla e non trasformarla in un
   `mandate` da solo: registrarla rende la scadenza visibile a
   `deadline-watch`, la decisione se serve un bypass resta successiva e
   del PM.

   **Referente tecnico (ipotesi).** Se `product/reference/team.yaml`
   esiste ed è popolato **e** il materiale ha abbastanza segnale tecnico
   da indicare un'area o una competenza, proponi un `tech_reference` dal
   roster e **fallo confermare** — mai presunto, stessa disciplina di
   `deadline`. È un'ipotesi preliminare: `prd-draft` la rifinirà contro
   l'How reale (skill `team-fit`). Se il segnale non c'è o `team.yaml` è
   vuoto/assente, lascia `tech_reference: null` — non forzarlo. Vedi
   playbook, "Team di sviluppo, referente tecnico e staffing di un PRD".

5. **Genera lo slug e crea la cartella**
   `product/ideas/{YYYY-MM-DD}-{slug-descrittivo}/` (data odierna o data
   del materiale di origine, a scelta più sensata per il caso). Lo slug è
   un topic-slug leggibile (es. `ricevute-scontrino-solo-totale`), non un
   ID opaco. Una cartella per unità, anche se più unità condividono la
   stessa origine.

6. **Salva il materiale grezzo** in `source/` dentro la cartella (es.
   `source/email-originale.md`, `source/trascrizione.md`) — non
   parafrasarlo via, l'originale deve restare consultabile. **Se
   un'unica fonte ha generato più unità (idee/bug/ecc.), copia il
   materiale grezzo per intero in ognuna delle cartelle risultanti** —
   non spezzettarlo in estratti parziali: chi apre una cartella deve
   poter leggere il contesto completo senza dover risalire alle altre.
   In questo caso, aggiungi in cima al file copiato una riga tipo `<!--
   Questa fonte ha generato anche: {altri slug} -->` così chi la legge sa
   che esistono record collegati dalla stessa origine.
   **Unica eccezione al "non parafrasare": le credenziali.** Se il
   materiale contiene password, token, codici o link di accesso (tipico:
   "ho creato l'utente di test, la password è…", o una segnalazione di
   bug con le credenziali dell'utente con cui si riproduce), nella copia
   in `source/` sostituisci il valore con `[credenziale rimossa → registro
   utenti di prova]` e proponi al PM di registrare l'utente con
   `test-accounts` (il valore va solo nell'archivio locale o nel password
   manager — playbook, "Ambienti e utenti di prova"). Se sono le
   credenziali di un **utente reale** (un cliente che ha mandato la sua
   password), non registrarle affatto: rimuovile e segnala al PM che il
   mittente va invitato a cambiarla.

   **Registro dei punti chiave.** Se la fonte è ricca — trascrizione,
   workshop, thread con più interlocutori, o oltre ~400 parole — estrai
   anche `source/key-points.yaml` (schema
   `framework/schema/key-points.template.yaml`): problemi, scenari, attori
   (compresi quelli **indiretti**: chi va convinto, chi riceve l'output),
   catena di valore, esempi, ipotesi, decisioni, vincoli, domande aperte,
   ciascuno con il riferimento nella fonte (timestamp/paragrafo) e il tipo
   d'informazione (`fact`/`estimate`/`illustrative`/`intent`/`opinion`).
   Se la trascrizione automatica ha errori ricorrenti (nomi di prodotto
   storpiati), annotali in `transcription_notes`. Se l'unità è una tra più
   generate dalla stessa fonte, il registro contiene i soli punti
   pertinenti, e `other_units_from_same_source` dichiara gli altri slug:
   **ogni punto della fonte deve finire in almeno un'unità**, oppure essere
   dichiarato non pertinente con un motivo. Per una mail breve il registro è
   facoltativo (dillo nel riepilogo). Serve a `prd-draft` per dimostrare che
   nessun punto si è perso tra conversazione e specifica (playbook, P3).

7. **Scrivi `idea.yaml`** a partire da
   `framework/schema/idea.template.yaml`, compilando i campi noti. **Non
   compilare `rice_history`** in questo passo — quello è compito della
   skill `rice-update`, con la sua propria approvazione. Lascialo vuoto
   (`[]`). Lascia anche `short_ref: null` — lo assegna `backlog-refinement`
   al primo refinement, non l'intake (serializzazione a scrittore unico
   per evitare collisioni).

8. **Bozza di risposta al richiedente (chiudere il loop).** Vedi
   playbook, "Chiudere il loop col richiedente". **Ogni unità con un
   richiedente che non è il PM stesso riceve una bozza**, qualunque sia
   la classificazione: `requester_reply.needed: true`, `reply_status:
   drafted`, `recipients` (il proponente + chi nel materiale ha posto una
   domanda diretta — conferma col PM). `needed: false` / `reply_status:
   not_needed` **solo** se non c'è nessuno da avvisare (idea del PM
   stesso, brainstorm interno). Un canale non noto non è un motivo per
   saltare: scrivi la bozza e segnala nel riepilogo che il canale va
   trovato. Materiale inoltrato dal PM per conto di qualcuno: il
   richiedente è quel qualcuno.

   **Pronta da incollare nel client di posta** (playbook, "Testi che il PM manda a mano: visibili e pronti da copiare"):
   testo semplice (niente Markdown, un paragrafo per riga, nessun
   simbolo grafico, nessuna firma, `[DA COMPLETARE: …]` per un dato
   mancante), mostrata **per intero** nel riepilogo in blocchi `text`
   separati (A, eventuale Oggetto, Testo). Quando il PM la rivede per
   mandarla, copia il Testo negli appunti con `bash
   .claude/hooks/copy-to-clipboard.sh`.

   **Calibrata sul destinatario** (playbook, "L'identikit degli
   stakeholder e il rapporto individuale"): prima di scriverla cerca i
   destinatari in `product/reference/stakeholders.yaml` (per `id`,
   `aliases`, email) e nel rapporto locale
   `.governance/stakeholder-relationships.local.yaml` (senza voce vale
   `new`), adatta forma e distanza — mai la sostanza — e mostra accanto
   ai blocchi la riga `Calibrazione: …`, solo in conversazione. Se il
   richiedente non ha identikit e compare spesso, proponi di crearlo
   (`stakeholder-profile`); se il PM dà una versione finale diversa o
   racconta la reazione, proponi in una riga di registrarlo.

   **Un mittente, una risposta.** Se il passo 2 ha decomposto il
   materiale in più unità dallo stesso mittente, scrivi **una sola bozza**
   che copre tutti gli esiti (es. "delle tre richieste: la prima è presa
   in carico…, la seconda è un bug già in agenda…, la terza…") nella prima
   unità creata; nelle altre `reply_status: consolidated` e
   `consolidated_in: <slug della prima>`, `draft: null` — `kind` resta
   quello della singola unità.

   Il `kind` dipende dalla classificazione:
   - **`acknowledgement`** (idea normale): la bozza copre tre cose —
     (a) presa in carico; (b) **serve un meeting di approfondimento col
     richiedente per fare un RICE serio?** (dato che solo lui ha,
     problema da inquadrare meglio): se sì, `deep_dive_meeting_needed:
     true` e compila `rice_status.deep_dive` (`needed: true`,
     `requested_at:` oggi) — è così che `rice-watch` te lo ricorda finché
     non avviene; (c) **prima ipotesi onesta di quando potrebbe essere
     prioritizzata**: leggi il backlog ordinato (come fa `backlog-list`)
     e dai una forbice realistica ("con ~N idee davanti a RICE più alto e
     nessuna quotazione ancora, non prima di [trimestre/periodo]") — mai
     una data precisa, mai una promessa.
   - **`clarification_request`** (`status: needs_clarification`): la bozza
     coincide con `clarification.draft_message` — non duplicare il testo,
     valorizza solo `requester_reply.kind` qui.
   - **`decline`** (`status: declined`): spiega con rispetto perché il
     team non può aiutare, indirizza altrove se sensato.
   - **`strategic_exception_ack`**: accolta su canale privilegiato, **in
     attesa di conferma** da {autorità} — non "approvata" — + impegno a
     restituire feedback sull'esito.
   - **`bug_ack`**: confermato come bug, entra nell'agenda del team di
     sviluppo senza passare dalla prioritizzazione; riferimento al ticket
     (`jira.card_id`, o "in apertura" se il connettore era giù — aggiorna
     la bozza quando `jira-sync` lo apre) e impatto stimato; **mai una
     data di risoluzione**; verrà avvisato alla chiusura. Se la verifica
     nel codice (passo 3) ha mostrato che il "bug" è il comportamento
     voluto e l'unità è diventata un'idea, il `kind` è `acknowledgement`
     ma la bozza lo spiega con rispetto (com'è pensato oggi, e che la
     richiesta di cambiarlo entra nel backlog come miglioria).
   - **`mandate_ack`**: presa in carico come iniziativa mandataria (salta
     la prioritizzazione, non l'analisi); scadenza registrata e
     monitorata; quando partirà l'analisi come forbice dal
     `lead_time_weeks`, se noto — mai una promessa.
   - **`platform_ack`**: presa in carico, rientra nella capacità protetta
     per il debito tecnico, se ne parla in Iteration Planning.
   **Non inviare mai la bozza in automatico.** Mostrala all'utente nel
   riepilogo; se c'è un'integrazione (email) chiedi conferma esplicita
   per ogni singolo invio. Quando il PM dichiara di averla mandata,
   `reply_status: sent` + `sent_at`; se decide che non serve (es. ha già
   risposto a voce), `reply_status: waived` + `waived_reason` dato da
   lui.

8b. **Path da monitorare.** Se `.governance/config.yaml` ha
   `metrics.configured: true` (integrazione non `manuale`) e
   `metrics.paths.enabled` non è `false`, esegui **inline** la logica di
   `path-watch` (passi 2-5) su ogni unità appena creata — tranne
   `declined`/`needs_clarification` — e scrivi il blocco `monitoring` su
   `idea.yaml` **senza chiedere conferma**: i path si applicano, non si
   propongono (playbook, "Measurement", "Path da monitorare"). Verifica
   prima il connettore con `metrics.probe`; se è giù, il giro di path è
   **rimandato** (dillo nel riepilogo), l'intake procede. Con
   `configured: false`/`manuale`, salta senza rumore.

9. **Non serve passare da `product/approvals/pending/` per la creazione
   di una nuova idea** (a differenza degli aggiornamenti a idee/roadmap
   già esistenti): l'intake è la prima cattura, non ancora una decisione
   di priorità. Comunicalo comunque chiaramente all'utente e mostragli il
   contenuto creato — **se sono state create più unità dalla stessa
   fonte, elencale tutte insieme nel riepilogo finale**, non una alla
   volta senza collegarle — prima di considerare il passo concluso.
   Includi nel riepilogo **ogni unità con la sua bozza di
   `requester_reply`** (o il motivo per cui non c'è nessuno da avvisare,
   o "canale da trovare") — mai un'unità senza nessuna delle due — e il recap
   dei path applicati al passo 8b (attivi con baseline, da strumentare,
   rimandati). **Per ogni
   bug**, di' esplicitamente se il ticket è stato aperto (con `card_id`/URL)
   o se resta un'**AZIONE NON COMPLETATA** perché il connettore era
   giù/`manuale` — in quel caso metti in evidenza il testo pronto e il
   promemoria di rilanciare `jira-sync`.

10. **Sincronizza il repo**: come ultimo passo, esegui
    `bash .claude/hooks/governance-sync.sh push "idea-intake: <slug>[, +N unità]" product/ideas/ product/reference/product-lines.yaml`
    (`product-lines.yaml` cambia solo se il passo 8b ha riallineato una
    dashboard per Product Line; altrimenti l'helper lo ignora)
    (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se
    l'helper segnala un push fallito o un disallineamento, riferiscilo nel
    riepilogo — non ripetere le scritture.
