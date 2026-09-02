---
name: demo-capture
description: Genera evidenza visiva di delivery per un'iniziativa con cambiamenti UI visibili — fa il rendering dell'applicazione reale in apps/ (deployment esistente o build di produzione in locale) su dati di seed, cattura gli screenshot dei flussi toccati e prepara una bozza di nota per la card del tracker di esecuzione. Non allega né condivide nulla in automatico: il momento in cui l'evidenza esce verso gli stakeholder è sempre un atto manuale del PM. Usala quando una card che ha prodotto UI visibile è "done" (o è su una preview environment) e serve mostrare "cosa si vede adesso".
---

# demo-capture

Una card è "Done" quando il codice è in produzione (playbook, "Product
Design, development and rollout") — ma una card che ha prodotto un
cambiamento **visibile** (una nuova schermata, un flusso rivisto, un
componente ridisegnato) chiude meglio il loop con gli stakeholder se alla
richiesta di partenza si può riagganciare *cosa si vede adesso*.
Descrivere a parole un cambiamento di interfaccia in una mail di
avanzamento è debole; un'immagine no.

Questa skill produce quell'evidenza partendo dal **codice reale**, non da
un mockup: fa il rendering dell'applicazione — la stessa che va (o è
andata) in produzione — su uno stato di dati controllato, e cattura gli
screenshot dei flussi che l'iniziativa ha toccato.

## Cosa è fedele e cosa no (dillo sempre, su ogni run)

- **Fedele è il rendering del codice.** Se si cattura dal commit/tag di
  release con un **build di produzione**, l'HTML/CSS/JS renderizzato è
  quello che vede l'utente: stessi componenti, stesso CSS compilato,
  stessa logica di stato (vuoto/errore/loading).
- **Non è fedele il dato**: seed/fixture sintetici, **mai** dati reali di
  clienti. L'evidenza dice "ecco la funzionalità", non "ecco il tuo
  account".
- **Non sono fedeli le zone con servizi terzi** (auth provider, iframe di
  pagamento, mappe, widget esterni): in modalità demo sono tipicamente
  stubbate.
- **Non è fedele l'ambiente di rendering**: versione del browser, font
  installati sulla macchina. Vanno fissati (vedi recipe), ma restano
  quelli della macchina di cattura, non di un utente reale.

Questi quattro punti vanno riportati nel `manifest.yaml` e nella bozza di
nota per la card — non nascosti.

## Prerequisiti

- L'istanza ha almeno un'applicazione collegata in `apps/` pertinente
  all'iniziativa. Se `apps/` è vuota, questa skill non è applicabile —
  segnalalo e fermati (non ripiegare su un mockup spacciandolo per
  cattura di codice reale).
- Esiste (o si scaffolda a questo run) una **demo recipe** per
  quell'app: `product/demos/recipes/<app-slug>.yaml` — vedi
  `framework/schema/demo-recipe.template.yaml`.
- Serve un driver browser: `claude-in-chrome` (skill omonima +
  `mcp__claude-in-chrome__*`), un server MCP Playwright, o operatività
  manuale. Dichiarato nella recipe (`capture.driver`).

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui lettura, bring-up e cattura normalmente (gli screenshot
> vivono in una cartella comunque esclusa da Git), ma **non** scrivere
> `product/demos/captures/*/manifest.yaml` né scaffoldare la recipe,
> **non** invocare `governance-sync.sh push`, mostra come testo il
> `manifest.yaml` e la bozza di nota che avresti prodotto, e chiudi con
> `🔍 DRY-RUN — nessun file tracciato scritto, nessun commit, nessun push.`

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)").

1. **Risolvi l'iniziativa.** Da slug o `short_ref`: leggi
   `product/ideas/{slug}/idea.yaml` (e i PRD in `links.prd_ids`).
   Conferma col PM che ha prodotto UI visibile degna di una cattura — se
   non è chiaro, chiedi, non presumere. Identifica **quale app** in
   `apps/` è stata toccata (dall'How del PRD, o chiedi al PM).

2. **Carica la recipe** `product/demos/recipes/<app-slug>.yaml`.
   - Se non esiste: **scaffoldala** da
     `framework/schema/demo-recipe.template.yaml`, compila quello che
     puoi ispezionando `apps/<app-slug>/` (comando di build/run, porta,
     framework), e chiedi al PM / al team tech di completare bring-up,
     seed e flussi. Se non hai abbastanza per portare su l'app, scrivi
     lo scaffold, spiega cosa manca, e fermati.
   - Nessun segreto nella recipe: credenziali ed endpoint sensibili
     stanno in variabili d'ambiente o in un file locale escluso da Git,
     mai nel repo tracciato (stesso vincolo dell'integrazione analytics
     — `framework/docs/future-work.md`). Se trovi un segreto scritto
     nella recipe, fermati e segnalalo.

3. **Scegli la modalità di cattura** (`capture.mode` nella recipe):
   - **`deployed`** (fedeltà massima, preferita): la recipe ha un
     `deployed.base_url` verso un deployment reale del codice — staging,
     o la preview environment per-PR. Pipeline e infrastruttura
     identiche alla produzione. Serve solo l'autenticazione (da env /
     file locale, mai dal repo).
   - **`local`** (ripiego): la recipe ha un blocco `local` con
     `bring_up`, `ready_check`, `seed`, `teardown`. Usala solo se non
     c'è un ambiente pre-esistente. Valgono tutti i caveat di fedeltà.

4. **Determina il ref del codice.** Non catturare da un `HEAD`
   qualsiasi: usa il **tag/commit di release** dell'iniziativa (da Jira,
   dalla PR, o chiesto al PM). Registra lo SHA — finisce nel manifest e
   nel footer di ogni immagine. In modalità `deployed`, verifica con il
   PM quale ref è servito da quell'ambiente.

5. **Porta su l'app.**
   - `deployed`: nessun bring-up, usa `base_url` + autenticati.
   - `local`: esegui `local.bring_up`, attendi `local.ready_check`,
     esegui `local.seed`. **Build di produzione, non dev server**: se
     `bring_up` avvia un dev server, segnala la perdita di fedeltà (CSS
     non purgato, warning di sviluppo, asset URL diversi) e chiedi se
     esiste un target di build di produzione da usare.
   - In entrambi i casi assicura il caricamento dei web font dichiarati
     (`capture.fonts`) e usa la versione di browser fissata
     (`capture.browser`).

6. **Cattura i flussi.** Per ogni flow in `flows` collegato a questa
   iniziativa (`flows[].idea_refs` contiene lo slug/`short_ref`, o il PM
   ne sceglie un sottoinsieme): guida il browser col driver dichiarato
   (`capture.driver`) lungo gli `steps` (navigate/click/fill/wait),
   imposta ogni `viewport` richiesto (desktop e, per il "mobile", un
   viewport responsive — non un emulatore nativo in v1), attendi il
   settle di animazioni/caricamenti, e salva il PNG in
   `product/demos/captures/<idea-slug>/screenshots/`.
   - Se il driver permette l'iniezione DOM, aggiungi prima dello scatto
     un footer fisso e discreto con: app, SHA breve, ref
     iniziativa, `dati dimostrativi`, data. Altrimenti registra la
     stessa provenienza solo nel manifest e nella bozza di nota.

7. **Teardown** (`local`): esegui `local.teardown`. Non lasciare
   processi o container attivi.

8. **Scrivi `product/demos/captures/<idea-slug>/manifest.yaml`** (da
   `framework/schema/demo-recipe.template.yaml`, blocco `# --- manifest`):
   ref iniziativa, app slug, `mode`, commit SHA / release tag, driver,
   data, elenco screenshot (path, flow ref, viewport, didascalia), e i
   quattro caveat di fedeltà applicabili. È un **fatto osservato** (cosa
   è stato catturato e da dove), non una decisione di priorità: scrittura
   diretta, **non passa da `product/approvals/pending/`** (stessa logica
   di `jira.card_id`). Gli screenshot NON sono tracciati
   (`product/demos/captures/*/screenshots/` è escluso dal `.gitignore` di
   root): sono artefatti binari, restano nel clone locale.

9. **Prepara la bozza di nota per la card** (testo, **mai pubblicata**):
   cosa è stato consegnato in una riga, elenco degli screenshot con
   didascalia, la riga di provenienza (app + SHA + ambiente), e il
   disclaimer `dati dimostrativi / servizi terzi stubbati`. Presentala al
   PM: è lui che allega gli screenshot alla card e incolla la nota —
   `demo-capture` non fa nessuna azione in uscita (stessa logica di
   `requester_reply.draft` — playbook, "Chiudere il loop col
   richiedente"). Se l'iniziativa ha `jira.card_id`, cita la card nella
   bozza per comodità del PM.

10. **Sincronizza il repo**: se hai scritto il manifest o scaffoldato la
    recipe, esegui
    `bash .claude/hooks/governance-sync.sh push "demo-capture: <idea-slug>" product/demos/`
    (vedi playbook, "Sincronizzazione dell'istanza (`origin`)").

## Cosa NON fare

- **Non allegare a Jira, non condividere, non inviare niente.** La skill
  produce solo artefatti locali. L'uscita verso gli stakeholder è sempre
  un atto manuale del PM.
- **Non catturare da un ref arbitrario.** Serve il tag/commit di release
  (o conferma esplicita del PM su quale commit). Un'immagine "dal branch
  di sviluppo" non è evidenza di cosa è andato in produzione.
- **Non usare dati reali.** Solo seed/fixture sintetici. Se la recipe
  punta a un database con dati di clienti reali, fermati.
- **Non spacciare un mockup per codice reale.** Se non riesci a portare
  su l'applicazione, dillo e fermati — non sostituire silenziosamente
  l'output della skill `design` o un rendering statico.
- **Non nascondere i limiti di fedeltà.** Dev server invece di build di
  produzione, zone con servizi terzi stubbate, font di fallback: vanno
  segnalati nel manifest e nella nota, non lasciati intendere come
  produzione fedele.
- **Non scrivere segreti nella recipe** né nel manifest (che è tracciato).
- **Non committare gli screenshot.** Vivono solo in
  `product/demos/captures/*/screenshots/`, escluso da Git.
