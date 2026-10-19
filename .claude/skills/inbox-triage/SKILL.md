---
name: inbox-triage
description: Svuota product/inbox/ classificando ogni elemento grezzo che il PM ci ha buttato dentro (email, thread, trascrizioni, allegati, immagini) — idea nuova, aggiornamento di un'idea/PRD esistente, bug, strategic exception, mandate/iniziativa mandataria, platform/debito tecnico, scarto al triage (declined) se non è roba da fare, o materiale troppo ambiguo da richiedere un chiarimento al mittente. Prepara una bozza di risposta per ogni elemento con un mittente che non è il PM — qualunque esito, anche bug, mandate, platform e aggiornamenti di idee/PRD esistenti — così nessuno stakeholder resta appeso. È il punto d'ingresso raccomandato per il materiale grezzo non ancora ordinato.
---

# inbox-triage

`product/inbox/` è il raccoglitore universale: il PM ci butta dentro
qualsiasi cosa arrivi a casaccio — una mail, un thread, un export Slack,
la trascrizione di un workshop, immagini, allegati — senza doverla
pre-classificare. Questa skill la analizza e la smista, poi **la
svuota**: alla fine di un run, `product/inbox/` deve contenere solo
`.gitkeep` (o cose che il run corrente non è riuscito a processare, mai
lasciate silenziosamente).

`product/inbox/` non è tracciata da git (vedi `.gitignore` — dimensioni
imprevedibili: email intere, registrazioni, allegati). Tutto quello che
deve sopravvivere passa da qui a una cartella tracciata come parte di
questo processo.

**Questa skill non è un passaggio obbligato.** È una comodità per il
materiale che arriva disordinato. Un PM può sempre, in alternativa:
creare/modificare file sotto `product/ideas/` o `product/prds/` a mano,
o chiedere direttamente a `idea-intake`/`prd-draft` di processare del
materiale senza mai passare da `product/inbox/`. Non presumere mai che
tutto debba transitare da qui.

## Principio guida: garantista, non produttivista

**Meglio una domanda in più che un'idea scritta male.** Questa skill non
è misurata su quante cartelle crea per run, ma su quanto è affidabile
quello che scrive. Un'idea o un aggiornamento pieno di dati inferiti o
indovinati è **peggio** di non averlo ancora creato: qualcuno ci lavorerà
sopra, prioritizzerà su basi sbagliate, e l'errore si scopre solo dopo
aver bruciato tempo reale. Se non basta rileggere il materiale una
seconda volta per essere ragionevolmente sicuri, non indovinare — chiedi.

Ci sono **due livelli di dubbio**, e vanno trattati diversamente:

1. **Dubbio che il PM davanti a te può risolvere subito, in conversazione**
   (es. "questa email sembra riferirsi alla Product Line A o B, quale
   delle due?", "questo materiale è un aggiornamento dell'idea
   `2026-01-08-xyz` o è scollegato?", "il proponente è lo stesso Mario
   Rossi di Operations dell'idea già registrata, o un omonimo?"). **Fai la
   domanda subito, nella conversazione corrente**, prima di scrivere
   qualunque file — non serve creare un record `needs_clarification` per
   questo, il PM ha l'informazione a portata di mano.

2. **Dubbio che solo chi ha mandato il materiale originale può risolvere**
   (dati mancanti che il PM stesso non conosce: un numero, un dettaglio
   del problema, chi sia davvero il beneficiario coinvolto). Questo è il
   caso che diventa `status: needs_clarification` (vedi passo 5 sotto) —
   con domande specifiche pronte per essere rispedite al mittente.

In entrambi i casi, la regola è la stessa: **non scrivere un campo con un
valore inventato o indovinato solo per completare lo schema.** Se un dato
non è nel materiale e nessuno dei due livelli sopra lo risolve subito,
lascialo esplicitamente vuoto/null con una nota, non riempirlo a caso.

Non vale solo per la classificazione: vale anche per numeri, nomi,
percentuali, product line, e per l'ipotesi che un elemento sia collegato
a un'idea/PRD già esistente (passo 4).

## Caso speciale: intake storico bulk

Se quello che c'è in `product/inbox/` è un **backlog storico** (mesi di
idee esportate da Aha!/Jira/foglio di calcolo) e/o una **roadmap già
decisa da leadership** prima che il framework esistesse (iniziative con
GO/NO GO/POSTPONED già assegnati), applica prima la sezione **"Intake
storico e roadmap pre-esistente"** del playbook, che i passi qui sotto da
soli non coprono. In sintesi:

- `created_at` di ogni elemento = **data di creazione originale**, non
  quella dell'intake — le watch skill contano il tempo trascorso da lì.
- Iniziativa pre-esistente **GO** → `classification: strategic_exception`,
  `invoked_at_stage: intake`, `approved_by` = il PM che fa l'intake (unico
  caso in cui non è un livello CEO/CPO-CTO), `reason` = motivazione
  originale. Se è una direttiva con scadenza fissa, valuta
  `classification: mandate`.
- **POSTPONED** → idea normale in bucket, RICE ancora da fare.
- **NO GO** → `classification: idea`, `status: aborted` (record storico).
  Il gate dell'avviso di conclusione vale anche qui: chiedi al PM se
  l'esito era stato comunicato a suo tempo — se sì, voce
  `conclusion_notices` `kind: aborted` `waived` con il suo motivo; se no,
  bozza `drafted` e l'idea resta in bucket finché non è `sent`
  (playbook, "Avvisare gli stakeholder della conclusione").
- Dopo il run, esegui una volta `rice-watch` e `mandate-watch` per
  fotografare lo stato di partenza.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** scrivere su
> `product/`/`context/`/`.governance/` (nemmeno spostando file da
> `product/inbox/`), **non** invocare `governance-sync.sh push`, **non**
> creare ticket sul tracker di esecuzione (per un bug, mostra come testo il
> ticket che avresti aperto), mostra come testo l'output completo che
> avresti prodotto, e chiudi con `🔍 DRY-RUN — nessun file scritto, nessun
> commit, nessun push, nessun ticket creato.`

0. **Sincronizza da `origin` prima di leggere lo stato**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)"). Il dedup del passo 4 —
   "questa idea esiste già?" — funziona solo se vedi le idee che i
   colleghi hanno creato. Se l'helper segnala un disallineamento
   non-fast-forward, **fermati e riferiscilo all'utente** prima di
   processare l'inbox.

   Subito dopo, **porta il codice di `apps/` all'ultima versione**:
   `bash .claude/hooks/governance-sync.sh apps` (ogni submodule all'ultimo
   commit del suo branch remoto; vedi playbook, "Sincronizzazione
   dell'istanza (`origin`)", sottosezione "Codice applicativo (`apps/`)").
   La diagnosi del passo 5 — è davvero un bug? è già stato risolto? è
   debito tecnico o una feature mancante? quale area tocca? — vale solo se
   legge il codice corrente, non quello fermo al puntatore registrato
   all'init. L'helper non blocca mai: per ogni submodule non aggiornato
   (modifiche locali, fetch fallito, accesso negato) **riportalo nel
   riepilogo** (passo 7) e tieni conto che le diagnosi su quell'app si
   basano su codice potenzialmente vecchio. Vale anche in dry-run: non
   scrive sotto `product/`/`context/`/`.governance/`.

1. **Elenca tutto ciò che c'è in `product/inbox/`.** Non assumere che sia
   un solo elemento: possono esserci più file/oggetti scollegati tra loro
   in un colpo solo (es. tre email diverse buttate lì nello stesso
   giorno). Trattali come elementi indipendenti fin dall'inizio.

2. **Per ciascun elemento, leggi il contenuto** (testo, trascrizione,
   metadati di eventuali immagini/allegati) prima di decidere qualunque
   cosa.

3. **Decomponi ogni elemento se mescola più richieste indipendenti.**
   Una singola mail o trascrizione può contenere più idee distinte,
   ciascuna con la propria priorità futura — ogni idea ha il proprio
   RICE, quindi non vanno bundlate solo perché arrivate insieme.
   **Criterio pratico** (stesso di `idea-intake`): se a due parti del
   contenuto assegneresti un RICE score indipendente e scollegato, sono
   due unità separate, non una. Da qui in poi, i passi 4-5 (verifica
   collegamenti + classificazione) vanno ripetuti **per ciascuna unità
   risultante**, indipendentemente — un singolo elemento può produrre in
   output una combinazione qualsiasi di nuova idea / aggiornamento /
   bug / needs_clarification, non solo "più idee nuove". Se il contenuto
   è coeso (un solo problema descritto da più angolazioni), resta
   un'unica unità.

   **Regola per il materiale grezzo condiviso**: quando un elemento si
   decompone in più unità, il materiale grezzo va copiato per intero
   (mai spezzettato in estratti parziali) in ciascuna delle destinazioni
   che le unità genereranno — chi apre una cartella deve poter leggere
   il contesto completo senza risalire alle altre. Aggiungi in cima a
   ogni copia una riga di nota che indichi le altre destinazioni
   generate dalla stessa fonte. L'elemento lascia `product/inbox/` solo
   dopo che tutte le unità generate sono state scritte nella loro
   destinazione finale — se un'unica email genera 3 record, esce
   dall'inbox solo quando tutti e 3 esistono, non dopo il primo.

   **Registro dei punti chiave**: per ogni elemento ricco (trascrizione,
   workshop, thread a più voci, oltre ~400 parole) estrai
   `source/key-points.yaml` in ciascuna destinazione generata, con la
   stessa regola di `idea-intake` (passo "Salva il materiale grezzo"): punti
   pertinenti a quell'unità, `other_units_from_same_source` per gli altri, e
   **nessun punto della fonte orfano** — ogni punto finisce in almeno
   un'unità o è dichiarato non pertinente con un motivo. Un esempio con
   numeri si conserva come `illustrative` (narrativa), non si scarta.

4. **Per ciascuna unità, prima di classificarla come "nuova idea", cerca
   se esiste già qualcosa di collegato**: leggi titoli/contesto di
   `product/ideas/*/idea.yaml` e frontmatter di `product/prds/*/prd.md`
   (Why/What, non serve leggere tutto il corpo per uno screening
   iniziale). Se il contenuto sembra riferirsi chiaramente a un'idea o
   PRD già esistente, tratta l'unità come **aggiornamento**, non come
   nuova idea. Se il collegamento è plausibile ma non certo, è un dubbio
   di **livello 1** (vedi sopra): chiedi conferma al PM nella
   conversazione, subito, invece di decidere da solo — un falso
   collegamento è peggio di una domanda in più.

5. **Classifica** ogni unità in uno di questi esiti. Prima di scegliere
   idea/bug/strategic_exception/mandate/platform/aggiornamento (cioè prima di
   scartare `needs_clarification`), verifica di poter rispondere, **solo dal
   materiale a disposizione o da una domanda di livello 1 già fatta al
   PM**, a queste domande minime:
   - Chi è il proponente (o almeno un canale/fonte identificabile)?
   - Qual è il problema o la richiesta, in termini comprensibili?
   - Perché sembra rilevante, anche minimamente?

   Se anche una sola di queste tre resta senza risposta dopo aver provato
   il livello 1, non forzare la classificazione: vai su
   `needs_clarification` (livello 2, sotto).

   **Verifica nel codice prima di classificare.** Se l'unità riguarda il
   comportamento di un'applicazione collegata in `apps/` (un
   malfunzionamento, un limite, una richiesta che presuppone come funziona
   oggi il sistema), leggi il codice pertinente — aggiornato al passo 0 —
   invece di classificare dal solo testo del mittente: un "bug" può essere
   il comportamento voluto (→ idea), una richiesta può essere già
   implementata (→ scarto o risposta al richiedente), un problema può
   essere debito tecnico (→ platform). Riporta l'esito nelle `notes`
   dell'idea con il riferimento verificabile (`apps/<slug>` @ commit,
   file/percorso), e proponilo al PM come ipotesi insieme alla
   classificazione — il codice informa la diagnosi, non sostituisce la
   conferma del PM. Se `apps/` è vuota o non pertinente, procedi senza.

   - **Nuova idea** — segui gli stessi passi della skill `idea-intake`
     per struttura della cartella, naming dello slug, classificazione
     idea/bug/strategic_exception/mandate/platform, **il campo `summary`**
     (una riga leggibile su cosa c'è da fare), l'eventuale
     `deadline`/`tech_reference` (ipotesi, solo su segnale esplicito e con
     `team.yaml` popolato — mai presunti, vedi `idea-intake` passo 4) e
     **la bozza di risposta al richiedente** (`requester_reply` — vedi
     `idea-intake` passo 8 e playbook, "Chiudere il loop col
     richiedente") e **i path da monitorare** applicati senza conferma
     se c'è una fonte analytics collegata (`idea-intake` passo 8b, skill
     `path-watch`). Materiale grezzo: vedi la regola sul condiviso al
     passo 3 se questa unità è una tra più generate dallo stesso elemento.

   - **Non è un'idea (scarto al triage)** — se l'elemento non è qualcosa
     su cui il team di prodotto può o deve lavorare (richiesta di
     supporto, tema fuori perimetro, già coperto altrove, "non è roba da
     fare"). Non scartarlo in silenzio: crea comunque la cartella
     (archivio/audit), `status: declined`, `decline_reason` in una riga.
     **Chiedi conferma esplicita al PM prima di scrivere `declined`** —
     tu proponi, il PM conferma. Prepara `requester_reply` con
     `kind: decline` (spiega con rispetto perché il team non può aiutare,
     indirizza altrove se sensato). Il materiale grezzo va comunque in
     `source/`.

   - **Aggiornamento di un'idea esistente** — sposta il materiale in
     `product/ideas/{slug-esistente}/source/` (nome file che non collida
     con quelli già presenti). Non modificare `rice_history` o `status`
     da solo: segnala all'utente cosa è arrivato e perché potrebbe
     essere rilevante (es. "questo materiale sembra invalidare la stima
     di Reach fatta il 12/01 — vuoi che lanci rice-update?"). Applica lo
     stesso principio del RICE: proponi, non decidere. **Eccezione**: se
     il materiale rivela una scadenza esterna prima non nota per
     un'idea `classification: idea`/`strategic_exception`, chiedi conferma
     al PM e compila il blocco `deadline` (`due_date`/`note`) — è cattura
     di un fatto dichiarato, non una decisione di priorità, quindi
     scrittura diretta (vedi playbook, "Scadenze su idee normali").
     **Bozza di risposta al mittente**: aggiungi una voce a
     `followup_replies` sull'idea (`kind: update_ack`, `reply_status:
     drafted`, `about: idea`, `source_file`, `from`, `received_at`) —
     ricevuto e collegato a {ID/titolo}, dov'è oggi l'iniziativa in
     linguaggio piano, cosa succede al materiale ("verrà valutato se
     cambia la stima" — mai anticipare l'esito di un `rice-update`).
     Nessuna data, nessuna promessa. Salta solo se il mittente è il PM
     stesso (`reply_status: not_needed`).

   - **Aggiornamento/integrazione di un PRD esistente** — sposta il
     materiale in `product/prds/{slug}/source/` (nome file che non
     collida con quelli già presenti). **Non riscrivere il PRD da solo**
     — l'authoring del PRD resta un atto deliberato (skill `prd-draft`).
     Segnala che è arrivato nuovo materiale rilevante e in cosa potrebbe
     impattare (Why/What/Metriche/Rischi). **Bozza di risposta al
     mittente**: come per l'aggiornamento di un'idea, una voce di
     `followup_replies` sull'idea indicata dall'`idea_id` del PRD, con
     `about: prd:<slug>` — "confluirà nella prossima revisione del PRD",
     senza anticipare cosa cambierà.

   - **Bug** — stessa regola di `idea-intake`: **crea comunque la cartella
     idea** (`classification: bug`, `rice_history` che resta `[]` per
     sempre — un bug non passa mai dal RICE) per non perdere il materiale
     e avere un record archiviato. Il materiale grezzo si sposta comunque
     in `source/` — mai lasciato solo nel testo del ticket.
     **Appena il PM conferma che è un bug, apri il ticket sul tracker di
     esecuzione subito** — non chiedere un secondo assenso (vedi playbook,
     "Alimentazione del bucket delle idee", punto a, e `idea-intake` bullet
     Bug per la procedura completa): dedup prima (cerca un ticket
     esistente se il connettore permette la ricerca, mostra i candidati al
     PM), poi crea con **impatto stimato**, popola
     `jira.card_id`/`jira.url`/`jira.status` e porta `status: in_jira`
     (fatto, scrittura diretta, niente `pending/`). Se il connettore è
     `manuale` o non risponde, consegna il testo pronto e riportalo nel
     riepilogo (passo 7) come **AZIONE NON COMPLETATA** con il promemoria
     di rilanciare `jira-sync` — mai come "fatto". Prepara
     `requester_reply` con `kind: bug_ack` (vedi `idea-intake` passo 8).

   - **Strategic Exception** — crea comunque la cartella idea (per
     traccia), `classification: strategic_exception`, e aggiungi una voce
     a `strategic_exceptions` con `invoked_at_stage: intake` —
     `approved_by`/`reason` restano da confermare esplicitamente, non
     presumere l'approvazione solo perché il mittente ha un ruolo senior.
     (Questo è distinto dal caso in cui un'idea normale salta la coda più
     avanti, in Backlog Refinement — vedi skill `backlog-refinement`.)
     Se dietro l'eccezione c'è una scadenza reale, compila anche il
     blocco `deadline` (`due_date`/`note`, mai presunti) — rende la
     motivazione verificabile nel tempo e la mette sotto `deadline-watch`.
     Prepara `requester_reply` con `kind: strategic_exception_ack`:
     "accolta su canale privilegiato, **in attesa di conferma** da
     {autorità}" — mai "approvata" finché non lo è — + impegno a
     restituire feedback sull'esito.

   - **Mandate (iniziativa mandataria)** — stessa regola di
     `idea-intake`: iniziativa imposta dall'alto, "critical" per
     leadership, o con scadenza esterna fissa (playbook, "Iniziative
     Mandatarie"). `classification: mandate` — salta solo il RICE, non
     l'analisi. `mandated_by`/`rationale` sempre chiesti esplicitamente,
     mai presunti (nessun vincolo di ruolo su chi può dichiararlo, quindi
     la disciplina nel chiedere conta di più). Se c'è una `due_date`,
     chiedi anche una prima stima di `lead_time_weeks` (da validare poi
     con un referente tecnico — se non disponibile, lascia `null` con
     nota, non bloccare). Mai compilare `analysis_start_by`/
     `escalation_status` — li calcola `mandate-watch`. Prepara
     `requester_reply` con `kind: mandate_ack`.

   - **Platform (debito tecnico/devops puro)** — stessa regola di
     `idea-intake`: non è un bug né un'idea di business, è manutenzione o
     debito tecnico che il team tech giudica necessario. `classification:
     platform` — salta solo il RICE, non necessariamente l'analisi (le
     iniziative importanti sì, quelle piccole possono saltare
     direttamente a `in_jira`). `rationale` sempre chiesto
     esplicitamente, mai presunto solo perché arriva dal team tech. Se la
     propone qualcuno che non è il PM, prepara `requester_reply` con
     `kind: platform_ack`.

   - **Troppo ambiguo per classificare (dubbio di livello 2)** — **non
     forzare una classificazione indovinando**. Crea comunque
     `product/ideas/{data}-{slug-provvisorio}/` con:
     - `status: needs_clarification`
     - `classification` lasciata come miglior tentativo provvisorio (può
       restare vuota se non hai nemmeno un'ipotesi)
     - `clarification.needed: true`, `clarification.questions` con le
       domande specifiche che servono per sbloccare la classificazione
       (non domande generiche tipo "puoi spiegare meglio?" — punta al
       dato mancante preciso: chi è il beneficiario, che numero c'è
       dietro, quale prodotto è coinvolto, ecc.)
     - `clarification.draft_message`: una bozza di messaggio pronta,
       nel tono giusto per essere rispedita a chi ha mandato il
       materiale originale, che ponga quelle domande
     - `requester_reply.needed: true`, `reply_status: drafted`,
       `requester_reply.kind: clarification_request` (il testo è già in
       `clarification.draft_message` — non duplicarlo)
     Il materiale grezzo si sposta comunque in `source/` — non resta in
     `product/inbox/`, e non va perso.
     **Non inviare mai il messaggio di chiarimento in automatico.**
     Mostralo all'utente e chiedi se vuole inviarlo lui, o se c'è
     un'integrazione disponibile (es. email) chiedi esplicitamente
     conferma prima di usarla.

5b. **Nessun mittente resta appeso.** Vale per tutti gli esiti sopra:
   ogni elemento con un mittente che non è il PM stesso produce una bozza
   di risposta — `requester_reply` sulle unità nuove, `followup_replies`
   sugli aggiornamenti — secondo le regole di `idea-intake` passo 8
   (`kind` per classificazione, `reply_status: drafted`, `recipients`,
   canale non noto = bozza comunque). **Un mittente, una risposta**: se
   un elemento ha generato più unità (anche miste, nuova idea +
   aggiornamento), il mittente riceve un solo messaggio che copre tutti
   gli esiti; la bozza vive nella prima unità creata (o, se non ne nasce
   nessuna nuova, nella voce `followup_replies` della prima idea
   aggiornata), le altre portano `reply_status: consolidated` +
   `consolidated_in`. Playbook, "Chiudere il loop col richiedente".

6. **Se un elemento rivela contesto aziendale rilevante (non di
   prodotto)** — un dato finanziario, una riorganizzazione, un cambio di
   strategia dichiarato — **non scriverlo tu in `context/`**: segnalalo
   nel riepilogo finale e proponi di richiamare `context-intake` su
   quell'elemento. Vale indipendentemente dalla classificazione scelta
   sopra (può capitare anche per un elemento che diventa una nuova idea).

6b. **Credenziali e utenti di prova.** Se un elemento contiene password,
   token, codici o link di accesso, applica la regola di `idea-intake`
   (passo 6, eccezione sulle credenziali): nella copia in `source/` il
   valore diventa `[credenziale rimossa → registro utenti di prova]`, mai
   copiato altrove; se riguarda un utente di prova (tipico: un collega
   tech scrive "ho creato l'utente admin su stg"), proponi di registrarlo
   con `test-accounts` — se nel registro c'era già come `wanted`, è
   proprio il momento in cui il framework diventa capace di usarlo. Un
   elemento che parla **solo** di un utente di prova non è un'idea: non
   creare cartelle in `product/ideas/`, passa a `test-accounts` e, a
   registrazione fatta, rimuovi l'elemento da `product/inbox/` (con il
   valore ancora dentro, non deve restare in giro). Credenziali di un
   utente reale: non si registrano, si rimuovono e si segnala al PM.
   Per i **bug**, dopo il filing vale la stessa proposta facoltativa di
   riproduzione con `app-test` di `idea-intake`.

7. **Chiudi il run con un riepilogo**, non solo con le scritture fatte:
   quanti elementi processati, in quante unità si sono decomposti, quante
   nuove idee / aggiornamenti / bug / strategic exception / mandate /
   platform / needs_clarification / **scartati (declined)** ne sono
   derivati — **raggruppa nel riepilogo le unità nate dallo stesso
   elemento**, non elencarle come se fossero scollegate. **Per ogni
   elemento, la sua bozza di risposta** (`requester_reply` o
   `followup_replies`, qualunque esito: idea, bug, SE, mandate, platform,
   decline, clarification, aggiornamento) pronta per la revisione e
   l'invio manuale del PM, con i destinatari, mostrata **per intero** in
   testo semplice pronto da incollare nel client di posta (playbook, "Testi che il PM manda a mano: visibili e pronti da copiare") e calibrata sul destinatario — identikit in `product/reference/stakeholders.yaml` × rapporto locale in `.governance/stakeholder-relationships.local.yaml` (senza voce vale `new`), forma e distanza mai la sostanza, riga `Calibrazione: …` solo in conversazione; proposta di identikit per i mittenti ricorrenti che non ce l'hanno (playbook, "L'identikit degli stakeholder e il rapporto individuale") — oppure il motivo esplicito
   per cui non c'è nessuno da avvisare, o "canale da trovare". Nessun
   elemento senza né l'una né l'altro. Non inviarne nessuna in
   automatico. Riporta il recap dei **path da
   monitorare** applicati alle nuove idee (attivi con baseline, da
   strumentare, rimandati se il connettore metriche era giù). **Per ogni bug**, di' se il ticket è
   stato aperto (con `card_id`/URL) o se resta un'**AZIONE NON COMPLETATA**
   (connettore giù/`manuale`): in quel caso metti in evidenza il testo
   pronto e il promemoria di rilanciare `jira-sync`. Indica su quale
   commit di ogni app pertinente si sono basate le diagnosi, e segnala le
   app che il passo 0 non è riuscito ad aggiornare. Se qualcosa non è
   stato processato per un problema tecnico (file illeggibile, formato non
   gestito) dillo esplicitamente e lascialo in `product/inbox/` piuttosto
   che farlo sparire silenziosamente.

8. **Verifica che `product/inbox/` sia vuota** (a parte `.gitkeep` e gli
   eventuali elementi non processabili segnalati al passo 7) prima di
   considerare il run concluso.

9. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "inbox-triage: processati N elementi" product/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). `product/inbox/`
   è gitignorata, quindi il commit cattura solo le destinazioni tracciate
   in cui gli elementi sono stati smistati. Se l'helper segnala un push
   fallito, riferiscilo nel riepilogo.

## Cosa NON fare

- Non inventare o indovinare un valore per completare uno schema — nel
  dubbio, chiedi (livello 1 o 2, vedi sopra) o lascia il campo vuoto con
  una nota. Meglio un record incompleto e onesto che uno completo e
  sbagliato.
- Non creare mai voci di `rice_history` da questa skill — è compito di
  `rice-update`, con la sua propria coda di approvazione.
- Non riscrivere PRD esistenti — è compito di `prd-draft`, su richiesta
  esplicita.
- Non inviare comunicazioni (email, Slack) senza conferma esplicita per
  ogni singolo invio. Questo vale per le comunicazioni verso **persone** —
  **non** per l'apertura del ticket di un bug confermato, che è obbligatoria
  e immediata (l'unica conferma è quella sulla classificazione).
- Non lasciare materiale "a metà": o finisce in una cartella tracciata
  (idea/PRD, anche come needs_clarification), o resta visibilmente in
  `product/inbox/` con una spiegazione del perché.
