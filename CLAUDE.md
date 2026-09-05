# Istruzioni di progetto — Claude Product Governance Framework

## Cos'è questo repository

Questo è il repo **canonico/astratto** del framework di Product Governance
basato su Claude Code. Non è un'istanza operativa: non contiene (e non deve
mai contenere) idee, PRD, roadmap o submodule applicativi reali di un
progetto specifico. Quelli vivono solo nei fork (istanze). Il dettaglio
completo dell'architettura è in `README.md`.

Se stai lavorando dentro un **fork già inizializzato** (esiste
`.governance/config.yaml`), questo file resta valido: le regole sotto si
applicano a qualunque istanza, non solo al canonico.

## Fonte normativa del metodo

`framework/playbook.md` è la fonte normativa dei processi (RICE, A3
Thinking, Definition of Done, cerimonie, gestione frizioni). Qualunque
skill in `.claude/skills/` deve leggerlo (o le sue sezioni pertinenti)
prima di generare o modificare un artefatto — non riassumerlo a memoria,
il playbook evolve.

Per un'istanza specifica, un `product/reference/` locale può contenere
personalizzazioni (product lines, denominatori Reach, glossario di
dominio) che si sommano al playbook generico senza sostituirlo.

## Confini di proprietà (per un merge pulito con l'upstream)

| Cartella | Proprietà | Chi scrive |
|---|---|---|
| `bootstrap.sh`, `.githooks/`, `framework/`, `.claude/skills/`, `.claude/settings.json`, `.claude/hooks/`, `.gitignore` | Framework (upstream) | Solo PR sul canonico, mai un'istanza |
| `apps/` | Istanza | Solo `init-governance-project` (aggiunta submodule) |
| `context/` | Istanza, **tracciata da git** (a differenza di `product/inbox/`) | `context-intake` (drop manuale o pull da cartelle collegate) e `context-watch` (pull periodico). Due canali di ingresso: file grezzi droppati in `context/` (poi rimossi), e pull da cartelle documentali collegate (`.governance/config.yaml`, una o più voci `connectors:` con `folders:` — connettori in sola lettura). Regole di scrittura: un run avviato dal PM o dal drop chiede **sempre conferma in conversazione** (nessuna coda `pending/`); il pull periodico di `context-watch` **auto-applica** gli aggiornamenti di routine (recap al PM) e manda i **cambiamenti materiali** in `product/approvals/pending/` (`type: context_update`). Nessun file grezzo (PDF, slide, docx) vi persiste — vedi playbook, "Contesto aziendale", sottosezione "Aggiornamento di routine vs. cambiamento materiale" |
| `context/.sources-seen.yaml` | Istanza, **tracciata da git** | `context-watch` (stato del giro: `last_watch`, `materiality`, `pending_ref`), `context-intake` (voce per documento trascritto), `pending-approval` (all'esito di un `context_update`). Fatti di sync osservati, non decisioni: scrittura diretta, nessuna approvazione a sé. Creato da `init-governance-project` se il PM dichiara cartelle di contesto, altrimenti lazy al primo pull |
| `product/inbox/` | Istanza, NON tracciata da git | `inbox-triage` la svuota spostando ogni elemento altrove; nessuna approvazione richiesta per lo spostamento in sé |
| `product/ideas/`, `product/prds/` (creazione) | Istanza | `idea-intake`, `inbox-triage`, `prd-draft` — creazione diretta, non passa da approvazione (non è ancora una decisione di priorità) |
| `product/ceremonies/` (cartella cerimonia, `source/`, `decisions.yaml`, `.run-meta.yaml`) | Istanza | `backlog-refinement`, `iteration-planning`, `log-ceremony` — registrazione diretta di una riunione di team: trascrizione + esito qualitativo + metadati di esecuzione. Non passa da `pending/` (non è una decisione di priorità: gli impatti su RICE/roadmap che ne derivano, sì). `.run-meta.yaml` è metadato di esecuzione scritto dalla skill, mai a mano. `rollback-ceremony` può annullare un run (revert forward dei commit + cartella `-void` con la trascrizione), mai una decisione già approvata |
| `product/ideas/*/delivery.estimated_effort_weeks` | Istanza | Solo `iteration-planning` — stima di tempo-calendario dal team tech per la contabilità di capacità d'iterazione, **non** un input del RICE. Scrittura diretta, nessuna approvazione (stessa logica di `deadline`/`rice_status`) |
| `product/ideas/*/rice_history`, `product/ideas/*/strategic_exceptions`, `product/ideas/*/mandate` (dopo la creazione), `product/ideas/*/classification` (riclassificazione a `mandate`), `product/roadmap/`, comunicazioni in uscita | Istanza | Solo tramite `product/approvals/pending/` — vedi regola sotto |
| `product/roadmap/iterations/` | Istanza | Solo tramite `product/approvals/pending/` (`type: iteration_plan`) — output team-facing del Backlog Refinement (proposto da `backlog-refinement`, confermato/aggiustato da `iteration-planning`), applicato solo da `pending-approval` all'approvazione. Parte dal piano della settimana precedente (`based_on`). Serie append-only, un file per settimana ISO, mai sovrascritto (tranne la revisione da Iteration Planning sulla stessa settimana) |
| `product/ideas/*/iteration` (`current`, `bucket`) | Istanza | Solo `pending-approval` all'approvazione di un `iteration_plan` — puntatore denormalizzato del piano approvato, scrittura diretta senza approvazione a sé (stesso principio di `jira.status`). Azzerato quando l'idea esce da tutti i bucket di un piano successivo |
| `product/ideas/*/mandate.analysis_start_by`, `product/ideas/*/mandate.escalation_status` | Istanza | Solo `mandate-watch` — fatti calcolati, non decisioni, scrittura diretta senza approvazione (stesso principio di `jira.status`) |
| `product/ideas/*/rice_status` (incluso `deep_dive`) | Istanza | `rice-watch` (e `idea-intake`/`inbox-triage` per `deep_dive.needed`/`requested_at` all'origine) — `flagged_since` è un fatto osservato; `blocked_reason`/`waiting_on`/`deep_dive.*` sono cattura di contesto (chiesti al PM, mai presunti), non decisioni di priorità: nessuna passa da approvazione |
| `product/ideas/*/summary`, `product/ideas/*/notes` | Istanza | `idea-intake`/`inbox-triage` all'origine, poi qualunque skill/PM in conversazione — descrizione e note di contesto, non decisioni di priorità, scrittura diretta |
| `product/ideas/*/jira.*` | Istanza | `jira-sync` (tutte le modalità) e `idea-intake`/`inbox-triage` per i bug all'intake — fatto osservato (il ticket esiste), scrittura diretta senza approvazione (stessa logica di `jira.status`). Per un `classification: bug` il filing è **immediato e obbligatorio** appena il PM conferma la classificazione: il ticket si apre subito (con impatto stimato), mai rimandato a un secondo assenso — vedi playbook, "Alimentazione del bucket delle idee", punto a. Se il connettore è `manuale`/irraggiungibile resta un'azione aperta esplicita, mai un filing silenziosamente saltato |
| `product/ideas/*/short_ref` | Istanza | Solo `backlog-refinement`, assegnato pigramente (`{prefisso}-{NNN}`, `next = max+1`) al primo refinement che incontra l'idea senza handle. Il refinement è un punto di serializzazione a scrittore singolo → niente collisioni offline; nessun file contatore. Fatto di housekeeping, scrittura diretta, non passa da `pending/`. Una volta assegnato non cambia. `id`/nome cartella restano l'identificatore canonico |
| `product/ideas/*/requester_reply` | Istanza | `idea-intake`/`inbox-triage` — bozza di risposta al richiedente, **mai inviata in automatico** (la manda il PM). Cortesia 1:1 con l'idea, non una decisione applicata a un target file: nessuna approvazione via `pending/`, stessa logica di `clarification.draft_message` |
| `product/ideas/*/status: declined`/`aborted`, `product/ideas/*/decline_reason` | Istanza | `idea-intake`/`inbox-triage` propongono lo scarto al triage, **oppure** `backlog-refinement` a un checkpoint della sweep di apertura quando il PM decide che un'idea non ha più motivo di esistere (`declined` se non è mai partita, `aborted` se era in lavorazione). Sempre su conferma **in conversazione** (è un giudizio) — non passa dalla coda `pending/`, ma non è mai deciso dalla sola skill; l'azione va registrata in `decisions.yaml` della cerimonia |
| `product/ideas/*/deadline.due_date`, `product/ideas/*/deadline.note` | Istanza | Qualunque skill che la incontra in conversazione (tipicamente `idea-intake`/`inbox-triage` all'origine) — cattura di un fatto dichiarato dal PM, mai presunto; impostarlo non cambia la priorità, stessa logica di `rice_status`, nessuna approvazione |
| `product/ideas/*/deadline.escalation_status` | Istanza | Solo `deadline-watch` — fatto calcolato, scrittura diretta senza approvazione (stesso principio di `mandate.escalation_status`) |
| `product/prds/*/measurement*.yaml` (creazione) | Istanza | Solo `prd-draft`, contestualmente alla creazione del PRD — non passa da approvazione (stessa logica della creazione di idee/PRD) |
| `product/prds/*/measurement*.yaml` (readings, measurement_status, follow_up_needed, closure) | Istanza | Solo `measurement-watch` — letture riportate dal PM e `closure` sono cattura di decisioni/fatti già espressi in conversazione (mai presunti, mai chiusi di iniziativa propria), `measurement_status` è calcolato dai dati. Nessuno di questi passa da approvazione |
| `product/demos/recipes/*.yaml` | Istanza, **tracciata da git** | `demo-capture` scaffolda al primo uso, PM/team tech completano — contratto tecnico per-app (come portare su l'app in modalità demo, quali flussi catturare), non una decisione di priorità: scrittura diretta, nessuna approvazione. **Mai segreti** dentro (env var per nome, non valori) — stesso vincolo di `framework/docs/future-work.md` |
| `product/demos/captures/*/manifest.yaml` | Istanza, **tracciata da git** | Solo `demo-capture` — record di audit di cosa è stato catturato, da quale commit, quando: fatto osservato, non decisione (stessa logica di `jira.card_id`), scrittura diretta senza approvazione |
| `product/demos/captures/*/screenshots/` | Istanza, **NON tracciata da git** (`.gitignore` di root) | Solo `demo-capture` — artefatti binari, mai committati. `demo-capture` non fa **nessuna azione in uscita**: è il PM ad allegarli alla card del tracker di esecuzione / al deck per gli stakeholder, a mano (stessa logica di `requester_reply`) |
| `product/reference/nsm-tracking.yaml` | Istanza | Solo `nsm-watch` — creato lazy al primo run (non da `init-governance-project`), scritto direttamente: `readings`/`trend_status`/`alert.status` sono fatti/calcoli osservati, `discovery_focus_confirmed`/`resolved_*` sono cattura di decisioni già espresse dal PM in conversazione. Nessuno di questi passa da approvazione |
| `product/reference/annual-target.yaml` | Istanza | Creato da `init-governance-project` (passo 4 intervista); aggiornato in seguito solo su richiesta esplicita dell'utente (nuovo Budget/BP, override per Product Line). È l'incremento atteso, mai il totale a budget — `rice-update` lo legge per calibrare l'Impact. Non passa da approvazione (è un dato di riferimento condiviso, come il denominatore Reach) |
| `.governance/config.yaml` | Istanza | Solo `init-governance-project`, in scrittura successiva solo su richiesta esplicita dell'utente |
| `.claude/settings.local.json` | Istanza, **NON tracciata da git** | Solo `init-governance-project` (allow entries dei tool del connettore dichiarato — ricerca/lettura + creazione ticket, così le skill non chiedono permesso per i passi che il metodo impone: probe, dedup, filing immediato di un bug; per un connettore sorgente di contesto, **solo** i tool di lettura/elenco) e richiesta esplicita dell'utente. La parte stack-agnostica dei permessi sta invece in `.claude/settings.json` (proprietà framework) |

Non spostare mai contenuto da `framework/` verso cartelle di istanza per
"personalizzarlo": se una regola del metodo va adattata a un progetto
specifico, va aggiunta come nota in `product/reference/`, referenziando la
regola generica — stessa logica dell'A3 Thinking sui PRD (non duplicare,
linkare).

**Esclusioni git locali a un'istanza.** Il `.gitignore` di root è di
proprietà framework (tabella sopra): un'istanza non lo modifica mai. Se
un'istanza ha bisogno di escludere da git contenuto specifico dentro una
cartella di sua proprietà — es. uno snapshot locale non versionabile
sotto `apps/` (vedi `init-governance-project`, caso "repository non
ancora distribuito via git") — usa un `.gitignore` **annidato** nella
sottocartella interessata: git lo supporta nativamente e la cartella che
lo contiene è di proprietà istanza, quindi non serve una PR sul canonico.
Il pattern tipico è un `apps/<slug>/.gitignore` con `*` + `!.gitignore` +
`!README.md` (ignora tutto tranne se stesso e la nota che spiega come
popolare la cartella).

## Regola non negoziabile: pending approval

Nessuna skill scrive mai direttamente in `product/ideas/`, `product/prds/`,
`product/roadmap/`, non invia comunicazioni in uscita, e non scrive in
`context/` un **cambiamento materiale** rilevato automaticamente senza
prima passare da `product/approvals/pending/`. Questo vale per:

- Ogni diff di RICE proposto da nuova evidenza
- Ogni snapshot di roadmap generato da una cerimonia
- Ogni Piano di Iterazione generato da un Backlog Refinement (`type:
  iteration_plan`), e ogni sua revisione da Iteration Planning — proposto
  dalla cerimonia, approvato separatamente, mai auto-applicato nella
  camminata (interamente annullabile con `rollback-ceremony` finché resta
  in `pending/`)
- Ogni comunicazione in uscita (mail settimanale, roadmap trimestrale)
- Ogni Strategic Exception rilevata durante il Backlog Refinement quando
  un'iniziativa salta la coda rispetto al suo RICE score (vedi
  `backlog-refinement` e `idea.template.yaml`, `strategic_exceptions`) — quelle
  invocate già all'intake seguono invece `idea-intake`/`inbox-triage` e
  non passano da qui, perché non c'è ancora un `target_file` esistente da
  modificare (l'idea nasce già così)
- Ogni modifica a `due_date`/`lead_time_weeks`/`mandated_by`/`rationale`/
  `is_critical` di un'iniziativa mandataria **dopo** la creazione (la
  creazione stessa non passa da qui, stessa logica delle idee normali) —
  vedi `idea.template.yaml`, blocco `mandate`, e skill `mandate-watch`
- Ogni riclassificazione di un'idea `classification: idea`/
  `strategic_exception` a `mandate` quando una scadenza dichiarata in
  `deadline` (tipicamente segnalata da `deadline-watch`) si rivela
  soddisfare davvero la definizione di Iniziativa Mandataria (`type:
  mandate_reclassification`) — il `rice_history` esistente non si
  cancella, resta append-only come storico
- Ogni **cambiamento materiale** del contesto aziendale che `context-watch`
  rileva in un documento di una cartella collegata (`type: context_update`)
  — uno che cambierebbe come si scrivono i PRD / l'evoluzione del prodotto
  (pivot di business model, NSM ridefinita, vincolo regolatorio, riorg che
  sposta l'ownership di prodotto). Gli **aggiornamenti di routine**
  (rinfresco di dati senza cambiare le conclusioni) **non** passano da qui:
  `context-watch` li auto-applica via `context-intake` e li mette nel recap
  al PM. Un run di `context-intake` avviato dal PM (drop manuale, o pull
  esplicito) conferma sempre in conversazione, ma non passa da `pending/`.
  Vedi playbook, "Contesto aziendale", sottosezione "Aggiornamento di
  routine vs. cambiamento materiale"

L'automazione propone (scrive in `pending/` con il diff/contenuto
proposto), un umano approva esplicitamente (la voce si sposta in
`decided/` e solo a quel punto il target file viene aggiornato). Questo
vale sia per motivi di qualità (falsi positivi/negativi nell'inferenza)
sia organizzativi (difendibilità delle decisioni in caso di revisione con
gli stakeholder) — vedi brief e playbook per il razionale completo.

Corollario: una voce già in `decided/` con `decision: approved` è una
decisione umana definitiva. `rollback-ceremony`, quando annulla un run di
cerimonia, la **esclude** sempre — annullare una decisione approvata è
un'operazione separata e deliberata, mai un effetto collaterale.

Corollario: `demo-capture` non rientra nella regola perché **non compie
alcuna azione in uscita** — produce solo artefatti locali (screenshot
gitignorati + una bozza di nota per la card). Il momento in cui
l'evidenza esce verso gli stakeholder è sempre un atto manuale del PM
(stessa logica di `requester_reply`): non c'è comunicazione in uscita da
far passare da `pending/`.

Corollario: l'apertura del ticket di un **bug confermato** sul tracker di
esecuzione non passa da `pending/` — non è una decisione di priorità (un
bug bypassa il RICE per disegno) e rimandarla a un secondo assenso
significa perderla. Stessa esenzione di `jira-sync` Push, e per lo stesso
motivo: il ticket è un fatto, non una proposta. L'unica conferma richiesta
è quella del PM sulla classificazione (è davvero un bug?); superata quella,
`idea-intake`/`inbox-triage` filano subito — vedi playbook, "Alimentazione
del bucket delle idee", punto a.

## Sincronizzazione dell'istanza (`origin`)

Le skill che leggono o scrivono stato tracciato sincronizzano
automaticamente il remote `origin`: `pull --ff-only` prima di leggere il
quadro completo, `commit + push` subito dopo aver scritto — tramite
l'helper `.claude/hooks/governance-sync.sh` (richiamato anche dall'hook
`SessionStart`). Solo fast-forward, mai un merge automatico, non blocca
mai, no-op sul canonico. Ogni skill che scrive in `product/`/`context/`
deve chiudere con `governance-sync.sh push`; quelle elencate nel playbook
come "read-critical" devono aprire con `governance-sync.sh pull`. Vedi
playbook, sezione "Sincronizzazione dell'istanza (`origin`)".

Helper gemello per la **lettura in blocco**: `.claude/hooks/governance-dump.sh`
(`sweep`|`backlog`|`ideas`|`measurements`|`iterations`|`pending`|
`reference`) concatena in **una sola tool call** i file YAML rilevanti,
così una skill non fa glob-e-leggi-ognuna N volte. Sola lettura, no-op sul
canonico. La sweep di apertura del Backlog Refinement lo usa una volta e
calcola tutte le watch inline; le scritture risultanti
(`escalation_status`/`rice_status`/`alert`/`closure`) sono **un unico
commit** di fine sweep — resta il principio "commit subito dopo la
scrittura", solo che la scrittura è una.

Da non confondere con `sync-framework-updates`, che riguarda `upstream` (il
metodo), non i dati.

## Connettori esterni

`.governance/config.yaml` può dichiarare connettori a **qualunque** sistema
esterno — il framework non fissa quali: `jira:` (il tracker, lo usa
`jira-sync`; Jira o altro), `metrics:` (la fonte di NSM/KPI, la usano le
watch di metriche), e `connectors:` (lista aperta per il resto). Stessa
disciplina per tutti: dichiarati da `init-governance-project` (scrittura
successiva solo su richiesta esplicita), campi comuni
`integration`/`probe`/`reauth`, **verificati all'inizio dei processi
chiave** (cerimonie, watch standalone), e "dichiarato ma irraggiungibile"
non è mai un fallback silenzioso — vedi playbook, "Connettori esterni:
dichiarati, verificati a inizio processo, mai un fallback silenzioso".
L'hook `SessionStart` `check-connectors.sh` ricorda a inizio sessione quali
connettori la config dichiara e **mostra i comandi `reauth`** (utile per i
connettori il cui login scade a ogni sessione). Il *contratto di query*
della fonte `metrics` (come una richiesta KPI diventa una query e torna un
aggregato) non esiste ancora — vedi `framework/docs/future-work.md`.

Le azioni che il metodo impone non sono interattive: probe del connettore,
`pull`/`push` di `governance-sync.sh`, letture di `governance-dump.sh` e —
per un bug confermato — la creazione del ticket. Vanno pre-autorizzate nei
permessi: la parte stack-agnostica (helper, git read-only) è in
`.claude/settings.json` (framework); i tool del connettore dichiarato li
scrive `init-governance-project` in `.claude/settings.local.json` (istanza,
non tracciato). Restano interattivi solo le decisioni di priorità
(`pending/`), le comunicazioni verso persone, e la conferma di
classificazione del bug.

## Modalità dry-run (simulazione)

Ogni skill che scrive stato tracciato supporta un dry-run: eseguita in
simulazione, legge e analizza, mostra l'output completo che *produrrebbe*,
ma non scrive nulla sotto `product/`/`context/`/`.governance/` e non fa
alcun commit o push. Si attiva per singola invocazione (l'utente chiede
`dry-run`) o per l'intera istanza (`dry_run: true`, chiave top-level in
`.governance/config.yaml`). Serve a provare o addestrare una cerimonia
senza sporcare il repo, e a poterla rieseguire identica. Rete di
sicurezza: `governance-sync.sh push` è un no-op quando il dry-run è
attivo. Fonte normativa: playbook, sezione "Modalità dry-run
(simulazione)". Non è un rollback — per annullare un run *vero* c'è
`rollback-ceremony` (revert forward dei commit del run, mai reset/
force-push su storia pushata, mai una decisione già approvata). Fonte
normativa: playbook, "Annullare un run di cerimonia (`rollback-ceremony`)".

## Convenzioni di naming

Cartella-per-iniziativa con slug parlante, non ID opachi: chi gestisce il
repo dal filesystem deve poter capire il contenuto dal nome della cartella.

- Idee: `product/ideas/{YYYY-MM-DD}-{slug-descrittivo}/`
- PRD: `product/prds/{slug-descrittivo}/` (con `prd-1-*.md`, `prd-2-*.md`
  dentro se l'iniziativa si spacca in più documenti)
- Cerimonie: `product/ceremonies/{tipo-cerimonia}/{YYYY-Www-o-data}/`

Lo slug non cambia più una volta creato, anche se il titolo dell'idea
evolve — chi linka alla cartella (Jira, altri PRD) non deve rompersi.

Il campo `short_ref` di un'idea (`PG-042`) **non** contraddice questa
regola: è un handle corto *aggiuntivo* per la conversazione e i
cross-reference (Jira, PRD), non l'identificatore su filesystem. Il nome
cartella resta lo slug parlante. Vedi `idea.template.yaml`, campo
`short_ref`, e skill `backlog-refinement` (che lo assegna).

Il **prefisso** dello `short_ref` (`short_ref_prefix` in
`.governance/config.yaml`, default `PG` = Product Governance) è un
namespace di **governance**, deliberatamente distinto da
`jira.project_key`: `PG-042` (un'idea) e `EPITA-121` (una card del tracker
di esecuzione) non devono potersi confondere in riunione. Non usare mai la
sigla del prodotto o la project key di Jira come prefisso —
`init-governance-project` lo rifiuta all'intervista e `backlog-refinement`
si ferma se i due coincidono.

## Quando scrivi codice/script in questo repo

Vale comunque la guida globale dell'utente su qualità/coding standard.
Questo repo è prevalentemente Markdown/YAML/shell: niente framework
applicativi da introdurre, niente dipendenze non necessarie negli script
di bootstrap (devono restare eseguibili con solo bash + git + sed,
nessun requisito aggiuntivo).
