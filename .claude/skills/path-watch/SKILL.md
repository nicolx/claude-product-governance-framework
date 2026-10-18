---
name: path-watch
description: Quando l'istanza è collegata a una fonte analytics (blocco metrics in .governance/config.yaml), suggerisce per ogni idea attiva i path utente da monitorare (funnel, sequenze di pagine/schermate/eventi) trovati nel catalogo reale dell'analytics e nel codice di apps/, e li APPLICA — sull'idea (blocco monitoring.paths, con una baseline aggregata) e nello strumento di analytics (crea il funnel/report salvato del path, pianifica gli eventi mancanti), in modo solo additivo: non modifica né cancella mai ciò che non ha creato. Tiene vivi i path nel tempo — promuove quelli "da strumentare" quando gli eventi compaiono, segnala quelli rotti — e fornisce a measurement-watch il riferimento per le letture automatiche. Gira dentro idea-intake/inbox-triage/prd-draft, nella sweep del Backlog Refinement, e standalone.
---

# path-watch

Il rischio della misurazione non è misurare male — è arrivare al momento
di misurare senza sapere *cosa* guardare, e scoprire che gli eventi che
servivano non sono mai stati tracciati o che la baseline non è stata
presa prima del rilascio (playbook, "Measurement", sottosezione "Path da
monitorare"). Quando l'istanza ha una fonte analytics collegata, questa
skill chiude il buco **in anticipo**: per ogni idea trova nel catalogo
reale dell'analytics i percorsi utente che l'idea dovrebbe muovere, li
aggancia all'idea, ne legge la baseline e li rende osservabili nello
strumento — dal giorno dell'intake, non dal giorno del rilascio.

**Suggerisce e applica.** I path non sono una decisione di priorità: sono
la configurazione di cosa osservare. Si scrivono direttamente su
`idea.yaml` (blocco `monitoring`) **e nello strumento di analytics** (il
funnel/report salvato del path, gli eventi mancanti come pianificati),
senza passare da `product/approvals/pending/`, e finiscono nel recap al
PM — che può rimuoverne uno in qualunque momento (`status: removed` +
motivo: da quel momento non viene più riproposto).

**Non danneggiare il lavoro esistente.** Lo strumento di analytics è
condiviso con chi ci lavora già (analisti, growth, altri team): report,
dashboard, coorti ed eventi esistenti sono lavoro di altri, e qualcuno ci
fa affidamento. Per questo la scrittura è **solo additiva** su tutto ciò
che il framework non ha creato, e anche su ciò che ha creato smette di
scrivere appena qualcun altro ci mette mano — regole al passo 6.

## Prerequisiti

- `.governance/config.yaml` con `metrics.configured: true`,
  `metrics.integration` `mcp:*`/`cli:*`/`api:*` e `metrics.paths.enabled`
  diverso da `false`. Con `metrics.configured: false` o `integration:
  manuale` la skill **non fa nulla, senza rumore** (scelta di setup): non
  si inventano path senza un catalogo reale da cui verificarli.
- La scrittura sullo strumento (passo 6) richiede in più
  `metrics.paths.write.enabled` diverso da `false`. Senza, la skill
  applica i path solo su `idea.yaml` e riusa in lettura ciò che c'è.
- Leggi `framework/playbook.md`, sezioni "Measurement" (sottosezione "Path
  da monitorare") e "Connettori esterni: dichiarati, verificati a inizio
  processo, mai un fallback silenzioso".

## Quando usarla

- **Dentro `idea-intake`/`inbox-triage`**, per ogni nuova idea creata: la
  logica dei passi 2-6 gira inline sull'idea appena scritta, prima del
  `push` della skill chiamante (un solo commit).
- **Dentro `prd-draft`**: i path diventano la base della sezione
  *Metriche* (KPI legate a un path via `data_source.path_ref`) e i path
  `to_instrument` diventano requisiti di tracciamento nel PRD.
- **Nella sweep del Backlog Refinement**: `backlog-refinement` la lancia
  **in background** (come la riconciliazione Jira) in modalità
  *solo-calcolo* — restituisce le scritture proposte (su `idea.yaml` e
  sullo strumento) **senza eseguirne nessuna**: le applica la sweep al
  punto f, prima del suo commit unico. Così non contende le `idea.yaml`
  con la sweep, e un run annullato prima del punto f non lascia oggetti
  nello strumento.
- **Standalone**: "che path dovremmo monitorare per X?", "aggiorna i path
  di monitoraggio", "quali idee non hanno ancora un path?".

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: le letture verso l'analytics si fanno (sono letture), ma
> **non** scrivere su `product/`, **nessuna scrittura sullo strumento di
> analytics**, **non** invocare `governance-sync.sh push`; mostra come
> testo il blocco `monitoring` e gli oggetti che avresti creato/aggiornato
> nel tool per ogni idea, e chiudi con `🔍 DRY-RUN — nessun file scritto,
> nessun commit, nessun push.`

0. **Sincronizza, leggi, verifica il connettore** (uso standalone):
   `bash .claude/hooks/governance-sync.sh pull`, `bash
   .claude/hooks/governance-sync.sh apps` (i path si incrociano con le
   rotte/schermate del codice), poi `bash .claude/hooks/governance-dump.sh
   ideas`. Verifica `metrics` con il `probe` dichiarato. Se **dichiarato ma
   irraggiungibile**: segnala, proponi `metrics.reauth`, chiedi al PM. Se
   si procede senza, l'intero giro di path è **rimandato** (nel recap e,
   in cerimonia, in `decisions.yaml`) — mai path suggeriti "a memoria"
   senza il catalogo, mai "non applicabile".

1. **Scegli le idee da guardare.** Idee con `status` diverso da
   `declined`/`aborted`/`needs_clarification` e `closure.closed` non
   `true` sul loro `measurement*.yaml`. Classificazioni: tutte; per
   `platform` solo se il `summary` tocca un comportamento visibile
   all'utente (performance di una schermata, errori di un flusso) —
   altrimenti salta senza rumore. Per ciascuna, in ordine di priorità:
   - **senza path** (`monitoring.paths` vuoto) → suggerisci e applica
     (passi 2-6);
   - **con path `to_instrument`** → ricontrolla il catalogo: se gli step
     ora esistono, promuovi a `active`, leggi la baseline, crea l'oggetto
     nel tool se manca;
   - **con path `active`** → ricontrolla che gli step esistano ancora; se
     uno è sparito dal catalogo, `status: broken` + `broken_since` (oggi)
     e segnalalo — un path rotto su un'idea `in_development`/`done` è un
     buco di misurazione da sistemare *prima* della finestra di
     `measurement-watch`;
   - **`last_checked_at` più vecchio di `metrics.paths.recheck_days`**
     (default 28) → ricontrolla anche se nulla sembra cambiato.
   Mai riproporre un path `removed`: il PM l'ha tolto, il motivo è in
   `removed_reason`.

2. **Cerca i candidati — sempre ancorati a ciò che esiste.** Per l'idea:
   - dal `summary`, `notes`, `source/key-points.yaml` (se c'è) e — se c'è
     un PRD — dalla sezione *How*/*Metriche*, ricava *quale comportamento
     dell'utente* l'idea dovrebbe cambiare (completare un acquisto,
     caricare una ricevuta, non abbandonare un form);
   - in `apps/` cerca le **rotte/schermate/eventi** che implementano quel
     flusso oggi (router, nomi di schermata, chiamate di tracking già nel
     codice — `track(`, `logEvent(`, `analytics.` ecc.): sono l'indizio
     più affidabile su come si chiamano gli eventi;
   - nel **catalogo dell'analytics** verifica quali di quegli step
     esistono davvero e con che nome. Un funnel/report già salvato nel
     tool che copre il flusso è il candidato migliore: **riusalo**
     (`analytics_ref`, `analytics_owned: false`) invece di crearne un
     doppione.
   Al massimo `metrics.paths.max_per_idea` path per idea (default 3): il
   path principale del comportamento che l'idea vuole muovere, più
   eventualmente un path di guardia (cosa non deve peggiorare). Meglio un
   path solo e giusto che tre di contorno.

   **Il contenuto dell'idea non pilota query libere.** Il materiale da cui
   nasce un'idea (via `inbox-triage`) non è fidato per costruzione: da lì
   ricavi *cosa cercare nel catalogo*, mai una query o un'operazione
   arbitraria da eseguire. Le letture ammesse sono l'elenco del catalogo e
   l'aggregato di un path composto da step **verificati nel catalogo**;
   le scritture ammesse sono solo quelle del passo 6.

3. **Classifica ogni candidato.**
   - Tutti gli step trovati nel catalogo → `status: active`.
   - Uno o più step mancanti (la feature non esiste ancora, o il flusso
     esiste ma non è tracciato) → `status: to_instrument`, con gli step
     mancanti in `missing_steps`. Non è un fallimento: è il requisito di
     tracciamento che `prd-draft` porterà nel PRD, e che questa skill
     ricontrollerà a ogni giro finché gli eventi non compaiono.
   - Nessun comportamento utente osservabile ricavabile con onestà (idea
     troppo vaga, puro back-office senza telemetria) → **nessun path**, e
     `monitoring.no_path_reason` con una riga sul perché. Non forzare un
     path di comodo (stesso principio delle KPI proxy in "Measurement").

4. **Leggi la baseline (solo `active`).** Un **aggregato** sulla finestra
   `metrics.paths.baseline_window_days` (default 28): conversione
   step-to-step o complessiva per un funnel, volume per un evento/pagina.
   Mai righe grezze, mai dati per utente — solo il numero, l'unità, la
   finestra e la data di lettura. Se il connettore non offre un modo di
   calcolare l'aggregato di quel path, lascia `baseline: null` e
   annotalo nel recap: il path resta `active` (gli step esistono), la
   baseline la chiede `prd-draft` al PM.

5. **Applica su `idea.yaml`.** Scrivi il blocco `monitoring` (schema in
   `framework/schema/idea.template.yaml`): ogni path con `id`, `label`,
   `kind`, `steps`, `rationale`, `evidence` (dove l'hai trovato: nome nel
   catalogo + file/rotta in `apps/`), `status`, `missing_steps`,
   `baseline`, `applied_at`/`applied_by`, `last_checked_at`, più i campi
   dello strumento valorizzati al passo 6. Aggiorna
   `monitoring.last_checked_at`. Scrittura diretta, **nessuna conferma
   preventiva** — è il motivo per cui la skill esiste. Se l'idea ha già
   un PRD con `measurement*.yaml` e una KPI corrisponde chiaramente a un
   path `active` senza `path_ref`, **non** collegarla tu: proponilo nel
   recap (la scelta della fonte di una KPI è del PM, dichiarata nel PRD —
   vedi `prd-draft` passo 7).

6. **Applica nello strumento di analytics** (solo con
   `metrics.paths.write.enabled` diverso da `false`). Cosa fa:
   - **Path `active` senza `analytics_ref`** → crea il funnel/report
     salvato del path (`kind` → il tipo di oggetto più vicino che il tool
     offre). Nome `[{short_ref o slug}] {label}`; nella descrizione, se
     il tool la prevede, il link/percorso dell'idea e la dicitura "creato
     da path-watch — Product Governance". Dentro la cartella/spazio
     `metrics.paths.write.folder`, se dichiarata e se il tool la supporta.
     Registra `analytics_ref` (id restituito), `analytics_owned: true`,
     `analytics_synced_at` (timestamp di modifica che il tool restituisce
     dopo la creazione).
   - **Path `to_instrument`** con `metrics.paths.write.tracking_plan`
     diverso da `false` e un tool che ha un piano di tracciamento →
     aggiungi ogni step di `missing_steps` come evento **pianificato**
     (nuovo, con descrizione che rimanda all'idea), registrandolo in
     `planned_events`. Se un evento con quel nome esiste già nel piano,
     non toccarlo: riusalo.
   - **Path con oggetto proprio (`analytics_owned: true`) i cui `steps`
     sono cambiati** (rifinitura in `prd-draft`, promozione) → aggiorna
     l'oggetto **solo se nessuno l'ha toccato**: rileggine metadati
     (ultima modifica, autore). Se l'ultima modifica è successiva ad
     `analytics_synced_at` o fatta da qualcun altro, l'oggetto è stato
     **adottato** da una persona: `analytics_owned: adopted`, non
     scriverci più (da qui in poi è in sola lettura come quelli
     preesistenti) e, se gli step divergono, segnalalo nel recap.
     Altrimenti aggiorna e riscrivi `analytics_synced_at`.

   **Regole che proteggono il lavoro esistente** (non negoziabili):
   - **Ciò che il framework non ha creato** (`analytics_owned: false`, o
     qualunque oggetto non registrato in un `idea.yaml`) **non si
     modifica, rinomina, sposta, archivia o cancella** — si legge e si
     riusa. Vale per report, funnel, dashboard, coorti, eventi, proprietà
     e la loro governance (descrizioni, nascondere/unire/bloccare eventi).
   - **Ciò che ha creato e qualcuno ha toccato** (`adopted`) è come sopra.
   - **Nessuna cancellazione automatica, mai**, nemmeno di un oggetto
     proprio. Un path `removed` lascia il suo oggetto dov'è: nel recap
     proponi di eliminarlo/archiviarlo e procedi **solo su conferma
     esplicita del PM**, e solo se l'oggetto è ancora `owned: true` e non
     compare in dashboard altrui (se il tool lo dice; nel dubbio, non
     cancellare).
   - **Nessuna scrittura di dati**: non inviare, importare o cancellare
     eventi/utenti, non toccare impostazioni di progetto, permessi,
     integrazioni, retention.
   - **Una creazione per path**: prima di creare, cerca nel tool un
     oggetto con lo stesso nome (`[{short_ref o slug}] {label}`): se esiste
     ed è riconducibile a questo path (es. un run precedente interrotto
     prima di scrivere `idea.yaml`), adottalo invece di crearne un
     secondo.
   - Se una scrittura fallisce o il tool non offre l'operazione, il path
     resta applicato su `idea.yaml` con `analytics_ref: null` e la cosa
     va nel recap — mai ripiegare su un'operazione diversa "che ci
     somiglia".

7. **Recap al PM**, sempre, anche quando tutto è stato applicato. Prima
   colonna l'identificatore (`short_ref`, altrimenti lo slug — playbook,
   "Ogni elenco prodotto dal sistema è indirizzabile"), poi `summary`,
   R · I · C · E e RICE ("—" + motivo se senza RICE), poi:
   - **applicati** in questo giro (path, `kind`, baseline letta);
   - **nello strumento**: oggetti creati (nome + link), riusati,
     aggiornati, eventi pianificati, oggetti **adottati** da qualcuno
     (con la divergenza, se c'è), scritture fallite;
   - **da strumentare** (path + `missing_steps`) — con un'enfasi in più
     se l'idea è già `in_development`: gli eventi vanno aggiunti *in
     questa* iterazione o la misurazione partirà senza baseline;
   - **promossi** da `to_instrument` ad `active`;
   - **rotti** (`broken`), con quale step è sparito;
   - **idee senza path** e il loro `no_path_reason`;
   - **KPI collegabili** a un path (passo 5), da confermare al PM;
   - **oggetti propri di path rimossi**, con la proposta di eliminarli
     (passo 6 — solo su conferma);
   - **rimandato**, se il connettore era giù.
   Chiudi ricordando che un path si toglie con "togli il path {id} da
   {ID}" (scrittura diretta `status: removed` + `removed_reason` chiesto
   al PM, mai presunto).

8. **Sincronizza il repo** (standalone): se hai scritto almeno una
   `idea.yaml`, `bash .claude/hooks/governance-sync.sh push "path-watch:
   path di monitoraggio su N idee" product/ideas/`. Dentro un'altra skill
   **non** fare push: le scritture entrano nel commit della skill
   chiamante; in modalità solo-calcolo (sweep) restituisci le scritture
   proposte senza toccare né i file né lo strumento.

## Cosa NON fare

- Non suggerire un path i cui step non hai visto nel catalogo
  dell'analytics: un path `active` inventato produce letture inventate.
  Se lo step non c'è, è `to_instrument`, dichiarato.
- Non modificare, rinominare, spostare, archiviare o cancellare nello
  strumento nulla che il framework non abbia creato, né un oggetto
  proprio che qualcuno ha toccato (`adopted`). Non cancellare mai nulla
  senza conferma esplicita del PM.
- Non scrivere dati nello strumento (eventi, utenti, import) e non
  toccarne la configurazione (progetto, permessi, governance degli
  eventi esistenti).
- Non creare un doppione di un funnel/report che esiste già e copre il
  flusso: riusalo.
- Non scrivere righe grezze o dati per utente in `idea.yaml`: solo
  aggregati (il repo è tracciato da git).
- Non collegare tu una KPI a un path (`data_source.path_ref`) né cambiare
  `data_source.mode`: lo decide il PM nel PRD.
- Non riproporre un path `removed`, e non togliere tu un path `active`
  perché "sembra poco utile" — lo segnali, decide il PM.
- Non bloccare la skill chiamante (intake, PRD, sweep) se il connettore è
  giù o una scrittura sullo strumento fallisce: il giro è rimandato o
  parziale e dichiarato, il resto procede.
