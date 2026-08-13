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
| `bootstrap.sh`, `.githooks/`, `framework/`, `.claude/skills/`, `.gitignore` | Framework (upstream) | Solo PR sul canonico, mai un'istanza |
| `apps/` | Istanza | Solo `init-governance-project` (aggiunta submodule) |
| `product/inbox/` | Istanza, NON tracciata da git | `inbox-triage` la svuota spostando ogni elemento altrove; nessuna approvazione richiesta per lo spostamento in sé |
| `product/ideas/`, `product/prds/` (creazione) | Istanza | `idea-intake`, `inbox-triage`, `prd-draft` — creazione diretta, non passa da approvazione (non è ancora una decisione di priorità) |
| `product/ideas/*/rice_history`, `product/ideas/*/strategic_exceptions`, `product/ideas/*/mandate` (dopo la creazione), `product/roadmap/`, comunicazioni in uscita | Istanza | Solo tramite `product/approvals/pending/` — vedi regola sotto |
| `product/ideas/*/mandate.analysis_start_by`, `product/ideas/*/mandate.escalation_status` | Istanza | Solo `mandate-watch` — fatti calcolati, non decisioni, scrittura diretta senza approvazione (stesso principio di `jira.status`) |
| `product/ideas/*/rice_status` | Istanza | Solo `rice-watch` — `flagged_since` è un fatto osservato; `blocked_reason`/`waiting_on` sono cattura di contesto (chiesti al PM, mai presunti), non decisioni di priorità: nessuna delle due passa da approvazione |
| `product/prds/*/measurement*.yaml` (creazione) | Istanza | Solo `prd-draft`, contestualmente alla creazione del PRD — non passa da approvazione (stessa logica della creazione di idee/PRD) |
| `product/prds/*/measurement*.yaml` (readings, measurement_status, follow_up_needed) | Istanza | Solo `measurement-watch` — letture riportate dal PM (fatti osservati, non decisioni) e valutazioni calcolate dai dati; `concluded` solo su decisione esplicita del PM in conversazione. Nessuna delle due passa da approvazione |
| `.governance/config.yaml` | Istanza | Solo `init-governance-project`, in scrittura successiva solo su richiesta esplicita dell'utente |

Non spostare mai contenuto da `framework/` verso cartelle di istanza per
"personalizzarlo": se una regola del metodo va adattata a un progetto
specifico, va aggiunta come nota in `product/reference/`, referenziando la
regola generica — stessa logica dell'A3 Thinking sui PRD (non duplicare,
linkare).

## Regola non negoziabile: pending approval

Nessuna skill scrive mai direttamente in `product/ideas/`, `product/prds/`,
`product/roadmap/` o invia comunicazioni in uscita senza prima passare da
`product/approvals/pending/`. Questo vale per:

- Ogni diff di RICE proposto da nuova evidenza
- Ogni snapshot di roadmap generato da una cerimonia
- Ogni comunicazione in uscita (mail settimanale, roadmap trimestrale)
- Ogni Strategic Exception rilevata durante il Backlog Refinement quando
  un'iniziativa salta la coda rispetto al suo RICE score (vedi
  `log-ceremony` e `idea.template.yaml`, `strategic_exceptions`) — quelle
  invocate già all'intake seguono invece `idea-intake`/`inbox-triage` e
  non passano da qui, perché non c'è ancora un `target_file` esistente da
  modificare (l'idea nasce già così)
- Ogni modifica a `due_date`/`lead_time_weeks`/`mandated_by`/`rationale`/
  `is_critical` di un'iniziativa mandataria **dopo** la creazione (la
  creazione stessa non passa da qui, stessa logica delle idee normali) —
  vedi `idea.template.yaml`, blocco `mandate`, e skill `mandate-watch`

L'automazione propone (scrive in `pending/` con il diff/contenuto
proposto), un umano approva esplicitamente (la voce si sposta in
`decided/` e solo a quel punto il target file viene aggiornato). Questo
vale sia per motivi di qualità (falsi positivi/negativi nell'inferenza)
sia organizzativi (difendibilità delle decisioni in caso di revisione con
gli stakeholder) — vedi brief e playbook per il razionale completo.

## Convenzioni di naming

Cartella-per-iniziativa con slug parlante, non ID opachi: chi gestisce il
repo dal filesystem deve poter capire il contenuto dal nome della cartella.

- Idee: `product/ideas/{YYYY-MM-DD}-{slug-descrittivo}/`
- PRD: `product/prds/{slug-descrittivo}/` (con `prd-1-*.md`, `prd-2-*.md`
  dentro se l'iniziativa si spacca in più documenti)
- Cerimonie: `product/ceremonies/{tipo-cerimonia}/{YYYY-Www-o-data}/`

Lo slug non cambia più una volta creato, anche se il titolo dell'idea
evolve — chi linka alla cartella (Jira, altri PRD) non deve rompersi.

## Quando scrivi codice/script in questo repo

Vale comunque la guida globale dell'utente su qualità/coding standard.
Questo repo è prevalentemente Markdown/YAML/shell: niente framework
applicativi da introdurre, niente dipendenze non necessarie negli script
di bootstrap (devono restare eseguibili con solo bash + git + sed,
nessun requisito aggiuntivo).
