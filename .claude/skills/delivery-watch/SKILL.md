---
name: delivery-watch
description: Osserva il tracker di esecuzione per le transizioni di stato rilevanti per gli stakeholder (entrata in sviluppo, consegna in produzione, bug risolto, card bloccata, regressione) sulle iniziative con jira.card_id e su una board_jql configurata; annota ogni evento in una coda di triage in product/reference/delivery-watch.yaml che sopravvive tra le sessioni. Se trova attività su una card non collegata a un'idea, crea l'idea in automatico per recuperare il tracciamento. Nessun invio automatico — nel triage il PM decide per ciascun evento se preparare e mandare (a mano) una mail agli stakeholder. Usala periodicamente, come parte del Backlog Refinement, o via cron (/schedule).
---

# delivery-watch

`jira-sync` Pull risponde a "dov'è adesso questo ticket": denormalizza lo
stato corrente sull'idea (`jira.status`), ma non tiene memoria del valore
precedente e non legge il `changelog` della card. Tra una sessione e
l'altra il PM perde il fatto che una card si è bloccata, è andata in
produzione o è regredita — proprio l'informazione che serve per tenere
gli stakeholder nel ciclo.

`delivery-watch` è la watch che rende quel monitoraggio periodico e
**persistente**: rileva una tassonomia fissa di transizioni, le mette in
una coda di triage che sopravvive tra le sessioni, e — nel triage — il PM
decide per ciascuna se mandare una mail. Non invia mai nulla da sola.

Vedi playbook, sezione "Transizioni di delivery rilevanti per gli
stakeholder (`delivery-watch`)": è la fonte normativa della tassonomia e
del confine "segnala, non comunica".

## Quando usarla

- **Standalone — POLL + DETECT**: "controlla la delivery", "ci sono
  novità sui ticket collegati?". Rileva i cambi dall'ultimo giro e li
  accoda; recap al PM.
- **Standalone — TRIAGE**: "smarchiamo la coda di delivery" → cammina le
  voci `pending` una per una, decidendo per ciascuna se preparare una
  mail (che poi manda il PM), archiviarla, o lasciarla.
- **Durante il Backlog Refinement**: `backlog-refinement` la lancia come
  **task in background** nella sweep di apertura (come la riconciliazione
  Jira — la sweep dev'essere calcolo, non attesa di I/O; vedi playbook,
  "La sweep di apertura dev'essere calcolo, non attesa di I/O"). Non gira
  inline. Il recap confluisce nel `decisions.yaml` via `log-ceremony` —
  non scriverlo tu.
- **Via cron**: il PM può creare un cloud agent con `/schedule` che
  esegue `delivery-watch` in modalità detect. Il cron **non fa triage e
  non manda nulla**: rileva, accoda, committa. Il promemoria via hook
  (`check-delivery-queue.sh`) rende la coda visibile alla sessione
  interattiva successiva. Richiede l'MCP Atlassian connesso anche
  nell'ambiente cloud e `sync.auto_push` abilitato.

## Prerequisiti

Istanza inizializzata con `jira.configured: true` **e**
`delivery_watch.enabled: true` in `.governance/config.yaml`. Altrimenti
**no-op silenzioso**: l'istanza non ha attivato questa watch, non c'è
niente da controllare (non è un guasto).

## Perimetro

- **Default**: ogni idea con `jira.card_id` valorizzato e `status` non
  `done`/`aborted`/`declined`.
- **In più**, se `delivery_watch.board_jql` è configurata: le card
  restituite da quella JQL. Una card di `board_jql` **non collegata** a
  nessuna idea su cui scatta un evento → l'idea viene **creata in
  automatico** (passo 6).
- Override per-istanza (opzionali) in `.governance/config.yaml`,
  `delivery_watch:`: `blocked_status_names`, `regression_labels`,
  `default_product_line`. Se non dichiarati, la watch usa solo status
  category + flag Impediment + issuetype.

## Tassonomia degli eventi

`getJiraIssue(cloudId, key, expand:"changelog")` restituisce
`fields.status.statusCategory.key` (`new` / `indeterminate` / `done` —
universale su ogni board), `fields.assignee`, `fields.labels`,
`fields.issuetype.name`, il custom field "Flagged"/"Impediment", e
`changelog.histories[]` con `{created, author, items:[{field, fromString,
toString}]}`.

| `event_type` | Rilevazione | `suggested_framing` | `suggested_audience` |
|---|---|---|---|
| **`entered_development`** | `changelog` item `field:"assignee"` con `fromString` vuoto → valorizzato, **e** categoria corrente `new`/`indeterminate`. `to` = nome assegnatario. | `update` | Stakeholders della `product_line`. |
| **`delivered`** | `last_seen_category` ≠ `done` **e** categoria corrente = `done` **e** `issuetype` ≠ Bug. | `reassurance` | `idea.proposer` (se esterno) + stakeholders della `product_line`. Se UI visibile → suggerisci `demo-capture`. |
| **`bug_resolved`** | come `delivered` ma `issuetype` = Bug. | `reassurance` | Chi ha segnalato il bug (`idea.proposer`) + stakeholders della `product_line`. |
| **`blocked`** | custom field "Flagged" → `Impediment` (dal `changelog`), **oppure** status entrato in un nome di `delivery_watch.blocked_status_names`. | `criticality` | `idea.proposer` + stakeholders della `product_line`. |
| **`regression`** | `last_seen_category` = `done` **e** categoria corrente `indeterminate`/`new` (riapertura), **oppure** label in `delivery_watch.regression_labels` aggiunta. | `criticality` | `idea.proposer` + stakeholders della `product_line`. |

- **Prima vista di un ticket = baseline, non evento** (popola solo
  `tickets[]`).
- `suggested_audience` si deriva **sempre** da
  `product/reference/product-lines.yaml` (voce con `name ==
  idea.product_line` → `stakeholders: []`) + `idea.proposer` per i
  framing `reassurance`/`criticality`. È un **default**: il PM
  conferma/edita i destinatari nel triage.
- Dedup: `card_id` + `event_type` + `occurred_at`. Un evento già in
  `queue[]` (anche `sent`/`dismissed`) non si ri-accoda.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui `pull`, probe del connettore, poll dei ticket e la
> classificazione degli eventi normalmente (sono tutte letture) — ma
> **non** scrivere `product/reference/delivery-watch.yaml`, **non**
> creare idee di backfill, **non** toccare `jira.*` sulle idee, **non**
> invocare `governance-sync.sh push`. Mostra come testo il recap completo
> (eventi che avresti accodato + idee che avresti creato) e chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`

### Modalità POLL + DETECT (default)

0. **Sincronizza e leggi in blocco** (uso standalone): `bash
   .claude/hooks/governance-sync.sh pull`, poi `bash
   .claude/hooks/governance-dump.sh delivery` —
   `product/reference/delivery-watch.yaml` + `product-lines.yaml` +
   tutte le `idea.yaml` in un colpo. Se richiamata da
   `backlog-refinement`, il `pull` unico della sweep è già stato fatto:
   non rifarlo.

1. **Verifica il connettore `jira`** con il `probe` dichiarato. "Dichiarato
   ma irraggiungibile ≠ `manuale`" (playbook, "Connettori esterni"):
   segnala *cosa* non risponde, proponi il comando `jira.reauth`, chiedi
   al PM se riautenticare e ritentare o procedere. Se si procede senza:
   **run rimandato**, nessuna scrittura, promemoria di rilanciare
   `delivery-watch` quando il connettore torna su. Con `jira.integration:
   manuale` (o `delivery_watch.fixture` valorizzato per il test): chiedi
   al PM di incollare, per ogni card nel perimetro, lo stato corrente e
   le transizioni dall'ultimo giro.

2. **Scaffolda `product/reference/delivery-watch.yaml`** da
   `framework/schema/delivery-watch.template.yaml` se non esiste.

3. **Costruisci la lista dei ticket** nel perimetro: le `jira.card_id`
   delle idee attive + i risultati di `delivery_watch.board_jql` via
   `searchJiraIssuesUsingJql` (se configurata).

4. **Per ogni ticket**: `getJiraIssue(cloudId, key, expand:"changelog")`.
   **SOLA LETTURA** — mai `transitionJiraIssue` / `editJiraIssue` /
   `addCommentToJiraIssue`.

5. **Confronta con l'entry in `tickets[]`** (assente = baseline, non
   evento) e classifica gli eventi secondo la tassonomia. Prendi
   `occurred_at` e `actor` dalla riga di `changelog.histories[]` che ha
   prodotto la transizione.

6. **Per ogni ticket di `board_jql` SENZA idea collegata su cui è
   scattato un evento**: invoca `idea-intake` in **modalità backfill**
   (non interattiva) passando la card. `idea-intake` crea
   `product/ideas/{data}-{slug}/` con `source.type: jira_backfill`,
   `source.ref` = chiave card, `jira.card_id`/`url`/`status` popolati,
   `classification` inferita (`issuetype: Bug` → `bug`, altrimenti
   `idea`), `product_line` inferita o `delivery_watch.default_product_line`
   o `null`, `backfill_review_needed: true`, `rice_history` vuoto.
   Associa l'evento all'idea nuova (`backfilled_idea: true`). Se
   `board_jql` non trova eventi su una card non collegata, **non creare
   nulla** — non si accoda un'idea per ogni card della board.

7. **Per ogni evento nuovo** (dedup su `card_id`+`event_type`+`occurred_at`,
   non già in `queue[]`): calcola `suggested_framing`,
   `suggested_audience`, `draft_headline` (una riga PM-facing). Append a
   `queue[]` con `triage_status: pending`, `id` =
   `{YYYY-MM-DD}-{card_id}-{event_type}`.

8. **Aggiorna `tickets[]`** con lo snapshot corrente di ogni ticket
   letto, e `last_watch` (`run_at`, `tickets_polled`, `connector_status`,
   `board_jql_status`).

9. **Se il connettore è raggiungibile**, rinfresca `jira.status` e
   `jira.last_polled_at` sulle `idea.yaml` toccate — fatto osservato,
   scrittura diretta, **non passa da `product/approvals/pending/`**
   (stessa esenzione di `jira-sync`). Non toccare altro sull'idea. Non
   giudicare la Definition of Done: "in produzione per Jira" si riporta,
   la valutazione è del PM.

10. **Recap al PM — SEMPRE**, anche se non c'è nulla:
    - **Eventi nuovi**: raggruppati per `event_type`, con l'`id` in
      **prima colonna** (playbook, "Ogni elenco prodotto dal sistema è
      indirizzabile"), `card_id`, `idea_ref`, `from → to`,
      `suggested_framing`.
    - **Idee create per backfill**: slug, card, classificazione
      abbozzata — ricorda al PM di rivederle al triage.
    - **Coda**: totale voci `pending` (comprese quelle dei run
      precedenti).
    - **Invariato**: quanti ticket saltati perché non cambiati (una
      riga, non l'elenco).
    - **Rimandato**: connettore/`board_jql` irraggiungibile non
      controllato.

11. Per un evento `delivered` su un'iniziativa con **UI visibile** →
    **suggerisci `demo-capture`** (non invocarla) per allegare "cosa si
    vede adesso" alla futura mail.

12. **Sincronizza il repo**: se hai scritto qualcosa, esegui
    `bash .claude/hooks/governance-sync.sh push "delivery-watch: <n> eventi, coda <m>, <k> backfill" product/reference/delivery-watch.yaml product/ideas/`
    (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se
    richiamata da `backlog-refinement`, questo commit è **distinto** da
    quello della sweep (tocca `product/reference/` e le eventuali idee di
    backfill, non le `idea.yaml` della sweep) — non lo si accorpa.
    L'auto-apply di `idea-intake` (backfill) potrebbe aver già fatto il
    suo commit; questo passo cattura il resto.

13. Se chiamata da `backlog-refinement`, **restituisci il recap** perché
    venga incluso nel log della cerimonia — non scrivere tu in
    `decisions.yaml`, è compito di `log-ceremony`.

### Modalità TRIAGE ("smarchiamo la coda di delivery")

0. `bash .claude/hooks/governance-sync.sh pull`; leggi
   `product/reference/delivery-watch.yaml`.

1. **Elenca le voci `queue[]` con `triage_status: pending`**, ordinate
   `criticality` > `reassurance` > `update`, poi per `occurred_at`.
   Tabella con l'`id` in prima colonna. Segnala **a parte** le idee con
   `backfill_review_needed: true`.

2. **Cammina OGNI voce** con il PM:
   - **(a) BOZZA MAIL** → componi `draft_subject` e `draft_body` dal
     `suggested_framing` della voce (aggiornamento / rassicurazione /
     criticità); `draft_recipients` da `suggested_audience` (il PM
     conferma/edita). Scrivi i tre campi nella voce di coda,
     `triage_status: drafted`. **Mostra la bozza al PM pronta da
     copiare — NON inviarla.** Quando il PM dice di averla mandata →
     `triage_status: sent`, `sent_at` (data dichiarata dal PM). Il testo
     resta nella voce come trail.
   - **(b) DISMISS** → `triage_status: dismissed`, `dismiss_reason`
     (chiedi il motivo, non lasciarlo vuoto — audit).
   - **(c) SALTA** → lascia `pending` (resta in coda; l'hook continua a
     ricordarla).

3. **Per ogni idea con `backfill_review_needed: true`** → il PM
   conferma/corregge `classification`, `product_line`, `summary`; se è
   lavoro spurio → `status: declined`/`aborted` + `decline_reason`. In
   ogni caso azzera `backfill_review_needed`.

4. **Sincronizza il repo**:
   `bash .claude/hooks/governance-sync.sh push "delivery-watch: triage — <k> bozze, <s> inviate, <j> dismiss" product/reference/delivery-watch.yaml product/ideas/`.

5. Ricorda al PM: le bozze **non partono da sole**. Le manda lui; il
   testo inviato resta nella voce di coda.

## Relazione con jira-sync

- `jira-sync` **Pull** denormalizza lo **stato corrente** del ticket
  sull'idea (`jira.status`), a beneficio di
  `backlog-list`/`roadmap-snapshot`.
- `jira-sync` **Riconciliazione** collega idee *già esistenti* (senza
  RICE, `jira.card_id: null`) a card Jira attive trovate per parole
  chiave.
- `delivery-watch` fa un **proprio read del `changelog`** (che Pull non
  legge) per rilevare i **cambi**, e **crea idee nuove** per card mai
  tracciate (che la Riconciliazione non fa).

Se `delivery-watch` e `jira-sync` Pull scrivono entrambe
`jira.status`/`jira.last_polled_at`, è lo **stesso fatto osservato**:
last-writer-wins è innocuo. Nessun sync realtime; Jira resta la fonte di
verità per l'esecuzione.

## Cosa NON fare

- **Mai inviare una comunicazione.** `delivery-watch` prepara bozze SOLO
  nel triage, su richiesta del PM voce per voce; l'invio è sempre
  manuale. Nessun percorso batch/cron che spedisce a persone.
- **Mai decidere che un evento è "chiuso" o irrilevante** — accoda, il
  PM smarca (stesso principio di `nsm-watch`/`mandate-watch`: segnala,
  non decide).
- **Mai silenziare una voce `pending`** solo perché è vecchia — resta in
  coda finché il PM non le dà un esito.
- **Mai scrivere in `product/ideas/`** oltre a
  `jira.status`/`jira.last_polled_at` e alla creazione di backfill (via
  `idea-intake`).
- **Mai dedurre la Definition of Done** — "in produzione per Jira" si
  segnala; la valutazione DoD è del PM.
- **Mai bloccare la sweep del Backlog Refinement** — connettore giù =
  run rimandato, la cerimonia prosegue.
- **Mai pollare in loop / realtime** dentro la skill — è una watch
  "pull".
- **Mai modificare la card su Jira** (nessun `transition`/`edit`/`comment`).
