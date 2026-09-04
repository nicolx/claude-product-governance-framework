---
name: jira-sync
description: Push - cerca un ticket già esistente (dedup JQL), poi crea/collega quello per un'idea o PRD prioritizzato e persiste l'ID; Pull - polling occasionale di stato/commenti dei ticket collegati; Riconciliazione - scova idee mai passate dal RICE il cui lavoro è già partito in Jira. Nessun sync realtime, Jira resta l'unica fonte di verità per l'esecuzione. Connettore consigliato: Atlassian Remote MCP Server ufficiale.
---

# jira-sync

Gestisce il collegamento (non la duplicazione) tra le idee/PRD di
questa istanza e Jira, secondo il brief: "Jira: sistema di verità per
l'esecuzione, non duplicato. Nessun sync in tempo reale."

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: **non** creare ticket Jira, **non** scrivere `jira.*`/`status`
> su `product/ideas/`, **non** invocare `governance-sync.sh push`; mostra
> come testo il ticket che avresti creato / gli aggiornamenti di stato che
> avresti scritto, e chiudi con `🔍 DRY-RUN — nessun file scritto, nessun
> ticket creato, nessun commit.` La ricerca JQL in lettura (dedup,
> riconciliazione) si può eseguire anche in dry-run — non muta nulla.

## Il connettore

Come questa istanza parla con Jira è dichiarato in
`.governance/config.yaml`, blocco `jira.integration`:

- **`atlassian-mcp`** (consigliato) — l'Atlassian Remote MCP Server
  ufficiale (OAuth 2.1). Setup una-tantum:
  `claude mcp add --transport http atlassian https://mcp.atlassian.com/v2/mcp`
  poi `/mcp` per il login. I tool compaiono col prefisso
  `mcp__atlassian__` — tipicamente `searchJiraIssuesUsingJql`,
  `createJiraIssue`, `editJiraIssue`, `transitionJiraIssue`,
  `addCommentToJiraIssue`, `getJiraIssue`, `getVisibleJiraProjects`,
  `getAccessibleAtlassianResources` (verifica i nomi esatti con
  `/mcp` — Atlassian li evolve). Molti tool vogliono il `cloud_id` da
  `jira.cloud_id`.
- **`cli:<nome>`** — una CLI Jira presente nell'ambiente. Fallback.
- **`manuale`** — nessun accesso programmatico: prepara sempre i testi
  pronti (ticket, JQL da lanciare a mano) e chiedi all'utente di
  agire lui, poi di riportare gli ID/risultati.

Se `jira.integration` è vuoto o assente, comportati come `manuale` e
segnala che conviene configurare il connettore (rende possibili dedup e
riconciliazione automatici — vedi sotto).

### Connettore dichiarato ma irraggiungibile — non è lo stesso di `manuale`

Caso specifico della regola generale del playbook, "Connettori esterni:
dichiarati, verificati a inizio processo, mai un fallback silenzioso".

Se `jira.integration` è `atlassian-mcp` o `cli:<nome>` ma **al momento
dell'uso** il connettore non risponde — tool `mcp__atlassian__*` non
disponibili perché `/mcp` non è loggato o la sessione OAuth è scaduta,
`ENOTFOUND`/timeout su `mcp.atlassian.com`, la CLI esce con errore — **non
degradare a `manuale` in silenzio e non saltare il passo**.

Dettagli specifici del connettore Jira (il resto è nella regola del
playbook):

- **Come rimetterlo su:** proponi il comando `jira.reauth` dichiarato in
  config. Per `atlassian-mcp` è tipicamente `/mcp` in sessione per
  ri-loggarsi (OAuth 2.1, login in browser); se è `ENOTFOUND`/timeout è
  rete o servizio giù, riprovare tra poco. Per `cli:<nome>` è il comando
  di login della CLI (verifica anche binario nel PATH).
- **Cosa resta rimandato** se il PM procede senza: il dedup del push, o
  l'intera Riconciliazione — gap esplicito nel riepilogo / nel
  `decisions.yaml` se in cerimonia, con promemoria di rilanciare
  `jira-sync` standalone quando il connettore torna su. Mai "non
  applicabile".

Vale in dry-run come a regime (la ricerca JQL è comunque una lettura).

## Modalità Push (idea/PRD → Jira)

Da usare quando un'idea è stata prioritizzata ed è pronta a entrare nel
backlog di esecuzione (tipicamente dopo Backlog Refinement / Iteration
Planning).

> **Bug confermato all'intake.** Push serve anche il bug appena classificato:
> `idea-intake`/`inbox-triage` lo invocano **subito** dopo la conferma del PM
> sulla classificazione, senza gate di priorità e senza RICE (vedi playbook,
> "Alimentazione del bucket delle idee", punto a). In quel caso **il passo 1
> non si applica** — un bug non ha e non avrà mai un RICE approvato né un
> PRD. Tutti gli altri passi (dedup al passo 3, creazione, scrittura
> `jira.*`, `status: in_jira`, sync del repo) valgono identici. Il ticket
> porta un **impatto stimato**; un tema di security va marcato ASAP.

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)") — verifica che l'idea non
   sia già stata collegata a un ticket da un collega nel frattempo.
1. Verifica che l'idea abbia RICE approvato e, se serve un PRD per
   procedere, che esista in `product/prds/`.
2. Prepara il contenuto del ticket (titolo, descrizione sintetica, link
   al PRD e/o alla cartella idea nel repo — non copiare il contenuto
   integrale del PRD dentro Jira, linkalo). Se l'idea ha un `short_ref`,
   mettilo in testa al titolo del ticket (es. `[PG-042] …`) — è il
   cross-reference tra la governance e l'esecuzione. Funziona **proprio
   perché** `short_ref_prefix` è un namespace distinto da
   `jira.project_key`: `[PG-042] Titolo` nel ticket `EPITA-317` è
   leggibile; `[EPITA-042]` nel ticket `EPITA-317` è solo rumore. Se in
   `.governance/config.yaml` i due prefissi coincidono, segnalalo (è un
   errore di setup — vedi `init-governance-project`).
3. **Dedup contro Jira — prima di creare.** Il passo 0 verifica solo che
   *l'idea locale* non sia già linkata; non basta. Se il connettore
   permette la ricerca, lancia una JQL sul progetto configurato con le
   parole chiave di titolo/`summary`
   (`project = {jira.project_key} AND text ~ "<parole chiave>"`,
   eventualmente allargando a `summary ~` / `description ~`). Se emergono
   candidati plausibili, **presentali al PM** (chiave, titolo, status) e
   chiedi: è uno di questi, o è davvero nuovo?
   - Se il PM riconosce un match → **linka quello**: salta la creazione,
     vai al passo 5 col suo `card_id`/`url`. Se il ticket risulta già
     avanti nel workflow, segnalalo: è lavoro partito prima che l'idea
     passasse dalla governance.
   - Se è nuovo, o il connettore è `manuale` (consegna al PM la JQL da
     lanciare) → procedi al passo 4.
4. Crea il ticket via il connettore dichiarato (`jira.integration` — vedi
   sezione "Il connettore"; con `atlassian-mcp` è `createJiraIssue`). Se
   il connettore è `manuale`, prepara il testo pronto da incollare e
   chiedi all'utente di crearlo lui, poi chiedigli l'ID.
5. Scrivi `jira.card_id`, `jira.url`, `jira.last_polled_at` (= ora) in
   `product/ideas/{slug}/idea.yaml`. Questo campo NON passa dalla coda di
   approvazione (è un fatto — il ticket esiste o non esiste — non una
   proposta soggetta a revisione), ma segnalalo chiaramente all'utente.
6. Aggiorna `status` dell'idea a `in_jira`.
7. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "jira-sync: push <slug> -> <card_id>" product/ideas/{slug}`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)").

> **Vedi anche.** Quando l'iniziativa collegata ha prodotto UI visibile
> ed è "done", la skill `demo-capture` genera screenshot dimostrativi dal
> codice reale e prepara una bozza di nota per la card — che il PM allega
> a mano (`jira-sync` e `demo-capture` non pubblicano commenti/allegati
> in automatico).

## Modalità Pull (Jira → stato locale)

Da usare periodicamente (non in tempo reale) per aggiornare lo stato
locale, tipicamente prima di generare uno `roadmap-snapshot`.

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` prima di iniziare il
   polling, così non sovrascrivi con dati Jira uno stato locale già
   superato da un collega.
1. Per ogni idea con `jira.card_id` valorizzato, interroga stato e
   commenti recenti del ticket.
2. Aggiorna `jira.status` e `jira.last_polled_at`. Se lo stato Jira
   indica che il ticket è chiuso/in produzione, segnalalo esplicitamente
   — ma non decidere tu se questo significa "Done" secondo la Definition
   of Done dell'istanza (vedi playbook): riportalo, lascia la
   valutazione all'utente.
3. Questo aggiornamento è un fatto osservato (stato remoto), non una
   proposta: **non passa dalla coda di approvazione**. Se invece dal
   commento Jira emerge un'informazione che dovrebbe cambiare il RICE o
   la roadmap, quella è una proposta vera e propria — passala a
   `rice-update` o `roadmap-snapshot`, non applicarla qui direttamente.
4. Se molte idee sono collegate, fai il pull in batch e presenta un
   riepilogo unico invece di aggiornamenti sparsi uno per uno.
5. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "jira-sync: pull stato N idee" product/ideas/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se l'helper
   segnala un push fallito, riferiscilo nel riepilogo.

## Modalità Riconciliazione (idee ↔ ticket già in Jira)

Il dedup del passo 3 di Push agisce **una idea alla volta, al momento del
push**. Non copre il caso più insidioso: un'idea che qualcuno ha portato
avanti direttamente in Jira — magari mesi fa, magari prima ancora che
l'istanza esistesse — **senza mai passare dal RICE**. Il suo `idea.yaml`
locale resta con `rice_history: []` e `jira.card_id: null`, mentre il
ticket corrispondente è "In corso" o "Completata". È esattamente la falla
che il gate RICE dovrebbe chiudere, e senza questo controllo resta
silenziosa.

Da usare **periodicamente** (richiamata da `backlog-refinement` nella
sweep di apertura, se `jira.integration` permette la ricerca) o
**standalone** ("controlliamo se c'è lavoro Jira fuori governance").
Richiede un connettore con ricerca — con `manuale` (o `jira.integration`
vuoto) non è praticabile in automatico: segnalalo e fermati, è una scelta
di setup. Se invece il connettore con ricerca **è dichiarato ma non
risponde**, non fermarti in silenzio: applica "Connettore dichiarato ma
irraggiungibile" sopra — segnala il guasto, proponi di riattivarlo,
rimanda la riconciliazione se il PM sceglie di proseguire.

0. **Sincronizza da `origin`** (`governance-sync.sh pull`).
1. **Elenca le idee candidate**: `classification: idea` (i bug/mandate/
   strategic exception saltano il RICE per disegno — non sono una falla),
   `rice_history` vuoto, `jira.card_id: null`, `status` non `declined`/
   `aborted`.
2. **Per ciascuna, cerca su Jira** un ticket plausibile: JQL sulle parole
   chiave di titolo/`summary` nel progetto `jira.project_key`. Batch le
   ricerche, non una conversazione per idea.
3. **Segnala i match plausibili con status Jira "attivo"** (Ready for
   dev / In corso / In review / Deploy / Completata — adatta ai nomi
   colonna del progetto): per ciascuno, `short_ref`/`idea_id` locale +
   `summary`, chiave e status del ticket Jira. Ordina mettendo per primi
   i ticket più avanti nel workflow — sono i più costosi da aver perso.
   **Solo segnalazione**: non linkare né cambiare stato di iniziativa
   propria.
4. **Per ogni match che il PM conferma**, allinea il record locale:
   scrivi `jira.card_id`/`jira.url`/`jira.status`/`jira.last_polled_at`,
   porta `status` al valore coerente col ticket (`in_jira`, o `done` con
   `done_at` se il ticket è chiuso/in produzione — chiedi conferma, non
   presumere la Definition of Done). Scrittura diretta, non passa da
   `pending/` (stessa logica di Push/Pull). Se emerge che serve comunque
   un RICE retroattivo per capire se l'iniziativa valeva la pena,
   **suggerisci `rice-update`** — non forzarlo.
5. **Sincronizza il repo**: se hai scritto almeno un `idea.yaml`, esegui
   `bash .claude/hooks/governance-sync.sh push "jira-sync: riconciliazione N idee" product/ideas/`.
   Se richiamata da `backlog-refinement`, restituisci comunque il
   riepilogo perché venga incluso nel `decisions.yaml` della cerimonia.
