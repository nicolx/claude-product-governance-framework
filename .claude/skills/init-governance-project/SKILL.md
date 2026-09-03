---
name: init-governance-project
description: Inizializza questo fork come istanza operativa del framework di Product Governance — intervista il PM, collega i repository applicativi come submodule, scaffolda apps/ e product/, scrive .governance/config.yaml. Da lanciare una sola volta, subito dopo bootstrap.sh.
---

# init-governance-project

Inizializza un fork del framework come istanza operativa per un progetto
reale. Va eseguita **una sola volta** per istanza, dopo che l'utente ha
già lanciato `./bootstrap.sh` (verifica che `origin` non sia il repo
canonico, attiva gli hook, aggiunge il remote `upstream`).

## Prerequisiti da verificare prima di iniziare

1. Controlla che `.governance/config.yaml` **non** esista già. Se esiste,
   ferma tutto e informa l'utente che questa istanza è già inizializzata —
   non sovrascrivere silenziosamente. Se l'utente vuole comunque
   rieseguire alcuni passaggi (es. aggiungere un submodule), fallo in modo
   mirato, non ripartendo da zero.
2. Controlla che `framework/canonical-remote.txt` non contenga più il
   placeholder `PLACEHOLDER-ORG`. Se lo contiene ancora, avvisa l'utente
   che il legame con l'upstream non è verificabile finché non viene
   aggiornato, ma procedi comunque con l'intervista se lo chiede
   esplicitamente.

## L'intervista

Conduci una conversazione naturale (non un questionario rigido a caselle)
per raccogliere:

1. **Nome del progetto/istanza** — usato in `.governance/config.yaml` e
   nel titolo del README locale.
2. **PM assegnati** — nome ed email di ciascuno. Se più PM, chiedi se
   presidiano Product Line diverse.
3. **Product Line** — nome, descrizione, North Star Metric + eventuali
   altri KPI, stakeholder di riferimento. Se l'utente ha già una tabella
   pronta (es. incollata da un documento), usala direttamente invece di
   richiederla campo per campo. Popola `product/reference/product-lines.yaml`
   a partire da `framework/schema/product-lines.template.yaml`. Per ogni
   Product Line, chiedi esplicitamente il denominatore Reach (valore,
   fonte, owner) — se l'utente non lo sa ancora, lascialo `null` con nota,
   **non inventarlo**: il playbook è esplicito che un Reach non
   formalizzato resta un'approssimazione.
4. **Target annuale di riferimento per l'Impact** — serve per convertire
   un valore economico assoluto in punti Impact 1-10 (playbook, "Ideas
   prioritization"). Chiedi **esplicitamente l'incremento atteso**, non
   il totale a budget: "Qual è il **delta** di [EBITDA, o altra metrica
   economica che userete] atteso quest'anno rispetto all'anno
   precedente?" Un PM risponde naturalmente col totale a budget (es.
   "300k"): incalza per isolare l'incremento (es. "di cui 30k di crescita
   sull'anno precedente") — **il numero che serve è l'incremento**. Se ti
   dà solo il totale + una crescita %, calcola il delta e **fallo
   confermare**, non usarlo di iniziativa. Popola
   `product/reference/annual-target.yaml` da
   `framework/schema/annual-target.template.yaml`. Se il PM non lo sa
   ancora (BP/Budget dell'anno non ancora approvato), lascia `value:
   null` con nota — **non bloccare l'inizializzazione**, ma segnala che
   ogni Impact calcolato prima resta un'approssimazione qualitativa, non
   calibrata (stesso principio del denominatore Reach).
5. **Repository applicativi da collegare** — per ciascuno: URL git,
   nome/slug con cui va montato sotto `apps/`. Per ognuno esegui:
   `git submodule add <url> apps/<slug>`. Se l'utente non ha ancora repo
   da collegare, salta questo passo e nota in `.governance/config.yaml`
   che va fatto in seguito (non bloccare l'inizializzazione per questo).

   **Organizza `apps/` per dominio funzionale, non per org/repo
   sorgente.** Se i repository provengono da più organizzazioni o sorgenti
   (comune dopo un'acquisizione o un rebrand — un'org legacy + una nuova),
   non ricalcare quell'alberatura: raggruppa per dominio di prodotto
   (`apps/<dominio>/<repo>/`, es. `apps/employer/`, `apps/merchant/`)
   a prescindere da dove vive il codice. Un'alberatura per org di
   provenienza non riflette il dominio e rende più difficile a
   `idea-intake`/`prd-draft` orientarsi. Chiedi al PM quali domini usare
   se non è ovvio dai nomi dei repository.

   **Repository non ancora distribuito via git.** Se un sistema
   applicativo esiste ma il suo codice non è distribuito via git — es.
   recuperabile solo via CLI proprietaria o export locale (ERP, CRM
   legacy, un'org Salesforce), personale di chi lo esegue, non pinnato a
   un commit, non riproducibile con `git submodule update` — non forzare
   un submodule inesistente. Crea invece `apps/<slug>/` con:
   - un `.gitignore` annidato (`*` + `!.gitignore` + `!README.md`) che
     esclude da git lo snapshot locale ma tiene la cartella e la sua nota
     — vedi `CLAUDE.md`, "Esclusioni git locali a un'istanza";
   - un `README.md` che spiega come popolare la cartella (comando/CLI,
     credenziali necessarie) e i limiti: nessuna versione pinnata, ogni
     collega rigenera lo snapshot in locale;
   - una nota sotto `apps` in `.governance/config.yaml` che documenta
     l'eccezione.
   Sostituire con un vero submodule non appena il codice sarà distribuito
   via git.
6. **Jira** (o altro tracker di esecuzione) — project key, URL board, e
   **come l'istanza si connette** (blocco `jira` in
   `framework/schema/governance-config.template.yaml`). Nessun
   collegamento realtime va creato qui, ma vale la pena impostare subito
   l'accesso programmatico, perché serve a `jira-sync` per il dedup e la
   riconciliazione:
   - **Path consigliato — Atlassian Remote MCP Server ufficiale** (OAuth
     2.1, nessun token da gestire):
     `claude mcp add --transport http atlassian https://mcp.atlassian.com/v2/mcp`
     poi `/mcp` in sessione per il login in browser. Registra
     `integration: atlassian-mcp` e il `cloud_id` (lo restituisce il
     tool `getAccessibleAtlassianResources`).
   - **Fallback** — una CLI Jira già presente nell'ambiente:
     `integration: "cli:<nome>"`.
   - **Nessun accesso programmatico** — `integration: manuale`:
     `jira-sync` preparerà i testi e il PM agirà a mano. Va bene per
     partire, si può aggiungere l'MCP in seguito.
7. **Eventuali altre configurazioni rilevanti** — canale Slack/Teams per
   comunicazioni, link a strumenti di analytics (es. DataBricks), altro
   che l'utente ritenga utile avere a portata di mano nel config.
8. **Materiale di contesto aziendale già disponibile** — chiedi se il PM
   ha materiale (bilanci pubblici, slide, export Confluence, documenti
   strategici) utile a capire il business/l'azienda, non solo il
   prodotto. Se sì, non serve trascriverlo a mano ora: crea `context/`
   (vedi sotto) e invita il PM a droppare i file lì; a fine intervista
   richiama la skill `context-intake` per processarli. Se non ha ancora
   materiale pronto, va bene: `context/` resta popolabile in qualunque
   momento successivo, non è un blocco per l'inizializzazione.

Non forzare un ordine rigido se l'utente fornisce più informazioni insieme
(es. incolla una trascrizione di un meeting di kickoff): estrai tutto ciò
che serve da lì e chiedi solo quello che manca.

## Cosa scrivere

1. `.governance/config.yaml` (crea la cartella `.governance/` se non
   esiste) da `framework/schema/governance-config.template.yaml` —
   compila i campi noti dall'intervista: `project`, `initialized_at`,
   `pm_roster`, `framework.upstream_ref` (`git rev-parse upstream/main`
   se disponibile, altrimenti `HEAD`), il blocco `jira` (passo 6
   dell'intervista), `apps`.
   Il blocco `sync` (`auto_pull`/`auto_push`, default `true` entrambi) è
   ciò che attiva la sincronizzazione automatica con `origin` per tutte
   le skill successive (vedi playbook, "Sincronizzazione dell'istanza
   (`origin`)") — menziona all'utente che può spegnerle qui (per
   un'istanza mono-PM, o un setup git particolare) se non le vuole.
   Se questa istanza serve solo per training/demo (nessun dato reale da
   persistere), puoi aggiungere `dry_run: true`: ogni skill girerà in
   simulazione finché non la togli (vedi playbook, "Modalità dry-run
   (simulazione)"). Per un'istanza operativa normale **non** aggiungerla.
   `short_ref_prefix` (default `PG`): il prefisso degli handle corti
   delle idee di **governance** (`PG-042`), assegnati da
   `backlog-refinement`. **Non suggerire la sigla del prodotto o del
   progetto.** Il prefisso deve restare un namespace *distinto* da
   `jira.project_key` e dagli slug in `apps/`: `PG-042` (idea) e
   `EPITA-121` (card Jira) non devono potersi confondere in riunione.
   - Se il PM non ha preferenze: lascia `PG`, non scrivere la chiave.
   - Se ne vuole uno più parlante: accetta solo un token che dica
     "governance" (es. `GOV`, `PGOV`), **mai** uguale (case-insensitive)
     a `jira.project_key`. Se propone la project key o una sigla di
     prodotto, **rifiuta e spiega perché** (la confusione idea/ticket
     emersa proprio così su un'istanza reale).
2. `product/reference/product-lines.yaml` (da template).
3. `product/reference/annual-target.yaml` (da
   `framework/schema/annual-target.template.yaml`) — con l'incremento
   raccolto al passo 4 dell'intervista, o `value: null` con nota se non
   ancora noto.
4. `product/reference/friction-log.yaml` (da template, vuoto).
   Non creare qui `product/reference/nsm-tracking.yaml`: baseline e
   target delle NSM spesso richiedono un giro su DataBricks/analytics
   che non è pratico fare a metà di questa intervista — lo scaffolda la
   skill `nsm-watch` al suo primo run, quando il PM ha il tempo di
   recuperare i valori con calma.
5. Scaffold vuoto: `product/ideas/`, `product/prds/`,
   `product/roadmap/snapshots/`, `product/roadmap/iterations/`,
   `product/ceremonies/`,
   `product/approvals/pending/`, `product/approvals/decided/`,
   `product/demos/recipes/`, `product/demos/captures/`,
   `product/inbox/` (con `.gitkeep` dove servono, git non traccia
   cartelle vuote). `product/inbox/` è già coperta dal `.gitignore` di
   root (contenuto non tracciato — vedi skill `inbox-triage`): non
   toglierla dal `.gitignore` per questa istanza. `product/demos/` è
   tracciata (recipe e manifest); solo
   `product/demos/captures/*/screenshots/` è escluso dal `.gitignore` di
   root (artefatti binari — vedi skill `demo-capture`).
6. `context/` alla **radice del repository** (non sotto `product/`, vedi
   playbook sezione "Contesto aziendale") — con `.gitkeep` se resta
   vuota. A differenza di `product/inbox/`, **non va aggiunta al
   `.gitignore`**: il contenuto che ci finisce (via `context-intake`) è
   già la trascrizione tracciabile, non il materiale grezzo. Se il PM ha
   fornito materiale al passo 8 dell'intervista, droppalo qui e richiama
   `context-intake` prima di chiudere l'inizializzazione.

## Dopo l'inizializzazione

- Fai un commit dedicato, es. `Initialize governance instance: <nome
  progetto>`.
- **Sincronizza il repo**: esegui
  `bash .claude/hooks/governance-sync.sh push "init-governance-project: inizializzazione <nome progetto>" .governance/ product/ context/`
  (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Da questo
  momento in poi è quest'helper — richiamato da tutte le altre skill — a
  tenere allineati `origin` e i cloni del team.
- Riepiloga all'utente cosa è stato creato e cosa resta da fare (es.
  submodule non ancora collegati, denominatori Reach non ancora
  formalizzati, **target annuale di Impact non ancora dichiarato**
  (`product/reference/annual-target.yaml`, `value: null`), materiale di
  contesto aziendale non ancora fornito se `context/` è rimasta vuota).
- Ricorda che da questo momento in poi nessuna scrittura in `product/`
  deve avvenire senza passare da `product/approvals/pending/` — vedi
  `CLAUDE.md` e `framework/playbook.md`.
