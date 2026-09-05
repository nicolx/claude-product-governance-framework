# Note per lavoro futuro

Appunti su cose esplicitamente **fuori scope adesso**, catturati man
mano che emergono nelle sessioni di lavoro sul framework, per non
perderli — stesso principio per cui `rice-watch`/`mandate-watch`
esistono per le idee: meglio annotare e rivedere periodicamente che
fidarsi della memoria.

Non è un roadmap impegnativo: sono spunti, non design né commitment di
delivery. Quando uno di questi diventa lavoro attivo, va promosso a una
issue/PR/piano vero — questo file resta solo il posto dove non si perde
nel frattempo.

## Livello web / DB derivato

Già citato nel brief (`examples/epassi-ita/docs/vision-brief.md`) come
"livello derivato: applicazione con DB" — per la fruizione via web
(roadmap live, storico dei Gantt settimanali, impatto economico e
metriche per iniziativa), rigenerato dai file e mai editato
direttamente. Non ancora progettato né costruito.

- **Reminder periodici via email (batch) ai PM.** Quando esisterà
  un'applicazione web con un processo batch/cron, dovrebbe inviare
  reminder periodici ai PM quando ci sono processi in sospeso —
  candidati naturali: voci in `product/approvals/pending/` più vecchie
  di qualche giorno, idee `stale`/`blocked_on` da `rice-watch`, mandate
  `due_soon`/`overdue`/`pending_review` da `mandate-watch`, idee
  `due_soon`/`overdue` da `deadline-watch`. Oggi questi
  controlli esistono solo come skill Claude Code richiamate
  manualmente/durante il Backlog Refinement — un livello applicativo
  potrebbe renderli proattivi invece che "pull" (il PM deve chiedere).
  Nota: questo è un cambio di categoria rispetto alla decisione presa in
  sessione per `mandate-watch` ("solo segnalazione, nessuna
  comunicazione automatica") — lì la scelta è stata deliberata per le
  skill Claude Code interattive; se in futuro si costruisce un livello
  batch/email automatico, va ridiscussa esplicitamente, non ereditata
  per default.

## Estensioni di `demo-capture`

La skill `demo-capture` (evidenza visiva di delivery — playbook, "Product
Design, development and rollout") nasce deliberatamente ristretta. Fuori
scope adesso, da rivedere se emerge la domanda:

- **Emulatore mobile nativo.** v1 fa "mobile" con un viewport responsive
  del browser. Un emulatore iOS/Android vero (build dell'app, simulatore)
  è un'altra classe di infrastruttura — per-istanza, per-stack — e non
  qualcosa che il canonico può fornire in modo agnostico.
- **Allegato automatico alla card.** Oggi `demo-capture` non compie
  nessuna azione in uscita: il PM allega screenshot e nota a mano. Un
  allegato programmatico (via connettore Jira) sarebbe una comunicazione
  in uscita → andrebbe instradato da `product/approvals/pending/`
  (`type: outbound_comm`), non aggiunto come scrittura diretta. Decisione
  deliberata da riprendere esplicitamente, non da ereditare.
- **Cattura in CI al momento del merge/release.** Rigenerare gli
  screenshot come step di pipeline sul tag di release invece che su
  invocazione manuale della skill. Richiede che la recipe sia eseguibile
  headless senza un umano nel giro — sensato solo dopo che il pattern
  `recipe` si è stabilizzato su qualche istanza reale.

## Parallelizzazione della sweep di apertura delle cerimonie

**In gran parte FATTO** (2026-09-03). La sweep di apertura di
`backlog-refinement` non invoca più 6 watch in sequenza: fa un solo
`pull`, un solo dump dello stato (`.claude/hooks/governance-dump.sh
sweep`), calcola la logica delle watch **inline**, lancia la
riconciliazione Jira **in background**, e chiude con **un solo commit**.
Wall-clock da `somma(6 cicli) + 6 commit` a `≈ dump + calcolo + 1 commit`.
La parte "leggi-una-volta / scrivi-una-volta / un commit" della
decomposizione originale è quindi coperta.

**Cosa resta aperto (parallelismo multi-agente vero).** Serve quasi solo
se una singola watch diventa costosa e indipendente — in pratica **solo
`jira-sync`**, che ora è già in un task in background durante la sweep. Un
fan-out ulteriore (più subagent compute-only in parallelo, ognuno che
restituisce diff, orchestratore che serializza la scrittura) darebbe un
guadagno marginale a fronte di cold-start e non-determinismo — da
riprendere solo se il profiling di un run reale mostra che il *calcolo*
inline (non l'I/O, ormai risolto) è il collo di bottiglia.

## Skill `short-ref-remap`

Il framework ora vieta che `short_ref_prefix` coincida con
`jira.project_key` (guard in `init-governance-project` e
`backlog-refinement`) — ma un'istanza che ha già assegnato handle
collidenti (`EPITA-054` idea vs. `EPITA-121` card) deve rinominarli a
mano: `grep -rl` su `product/`, `sed`, più i titoli dei PRD e delle card
Jira. Se più istanze incappano nella stessa collisione, vale la pena una
skill `short-ref-remap` che: rilegge tutti gli `short_ref` di un'istanza,
li rimappa a un nuovo prefisso mantenendo i numeri, aggiorna
`idea.yaml`/PRD/`decisions.yaml`/snapshot/piani di iterazione in un unico
commit, e stampa la lista dei titoli Jira da correggere a mano (mai
un'azione in uscita automatica). Fuori scope finché è un caso isolato.

## Estensioni del pull di contesto da cartelle collegate

Il pull di `context-intake` da cartelle collegate (`connectors[].folders`
— dichiarato all'init) nasce deliberatamente minimale. Fuori scope
adesso, da rivedere se emerge la domanda:

- **Diff a livello di sezione.** Oggi un qualunque cambio di `revision`
  di un documento lo ri-propone **intero** per la ri-trascrizione. Un
  diff più fine (quali paragrafi/sezioni sono cambiati) eviterebbe di
  rileggere documenti lunghi per una modifica marginale — ma richiede di
  conservare abbastanza dello stato precedente da confrontare, cosa che
  `context/.sources-seen.yaml` di proposito non fa (tiene solo id +
  revisione, non il contenuto).
- **Sincronizzazione bidirezionale / push-back.** Il connettore è
  deliberatamente in sola lettura: `context-intake` non scrive mai nella
  cartella sorgente. Un flusso che ripubblichi la sintesi `context/*.md`
  verso Confluence/Drive sarebbe una comunicazione in uscita → andrebbe
  instradato da `product/approvals/pending/`, non aggiunto come scrittura
  diretta. Decisione da riprendere esplicitamente, non da ereditare.
- **Watch periodica.** Oggi il pull è "pull" (il PM lancia la skill). Un
  livello batch/cron che segnali "3 documenti nuovi nella cartella X
  dall'ultimo giro" sarebbe utile — stesso discorso dei reminder batch ai
  PM nella sezione "Livello web / DB derivato".

## Integrazione DB/analytics in lettura per NSM e measurement-watch

**Dichiarazione + verifica: FATTO** (2026-09-03). `.governance/config.yaml`
ha un blocco `metrics:` (`configured`/`integration`/`probe`/`reauth`/`note`)
e una lista aperta `connectors:` per qualunque altro sistema — la
disciplina è agnostica rispetto allo stack (MCP, CLI, API); `nsm-watch`,
`measurement-watch` e le cerimonie **verificano il connettore a inizio
processo** e applicano la regola "dichiarato ma irraggiungibile ≠ fallback
silenzioso" (playbook, "Connettori esterni…"); `check-connectors.sh` lo
ricorda a inizio sessione mostrando i comandi `reauth`. `measurement.yaml`
ha già `data_source.mode: manual | automated` per KPI.

**Cosa resta aperto: il contratto di query.** Come una richiesta KPI
("conversion funnel della Product Line X, ultimi 30 giorni") diventa una
query sullo stack dell'istanza e torna un **aggregato** — indipendente da
DataBricks/altro. Il connettore vero non esiste ancora: ogni istanza avrà
uno stack diverso, non è qualcosa che il canonico può implementare in modo
agnostico. Punti fermi già decisi (da rispettare quando si progetta):

- **Mai credenziali su Git.** Configurazione 100% locale per istanza
  (env, secret manager, o un file locale esplicitamente escluso da git)
  — mai in `.governance/config.yaml` o altrove nel repo tracciato.
- **"Read-only" non basta da solo a escludere il rischio.** I rischi
  reali non sono sulla scrittura verso il DB (che infatti resta in
  lettura): sono (a) dati letti che finiscono comunque in Git tramite
  `measurement.yaml`/`readings` — quindi vanno bene aggregati (es. "34%
  conversion"), mai dump di righe grezze; (b) le credenziali stesse,
  anche solo in lettura, restano un asset da proteggere; (c) un accesso
  DB ampio allarga il perimetro di ciò che un contenuto ingerito (via
  `inbox-triage`, non fidato per costruzione) potrebbe indurre l'agente a
  interrogare — un connettore stretto, mirato solo alle KPI dichiarate
  nel PRD (mai query libere, mai il DB di produzione OLTP diretto —
  preferire una vista/API sull'analytics warehouse), riduce questo
  perimetro invece di allargarlo.
- **La scelta manuale/automatizzata è del PM, per KPI, dichiarata nel
  PRD.** Se manuale: quella metrica non entra nell'osservazione
  automatica, `measurement-watch` continua a chiedere il valore come
  oggi. Se automatizzata: quando in futuro esisterà un connettore
  configurato localmente, `measurement-watch` può tentare la lettura
  automatica — ma mostra comunque il valore letto nel riepilogo del run
  (trasparenza, non un gate di approvazione: l'utente ha esplicitamente
  chiesto di non depotenziare l'automazione con un controllo ridondante
  per ogni singola lettura).

**Ancora da capire (la "giusta astrazione"):** il *contratto* — query in
ingresso (mirata a una KPI/NSM dichiarata, mai libera), aggregato in
uscita (mai righe grezze) — che qualunque connettore deve rispettare,
indipendente dallo stack. La *dichiarazione* del connettore
(`metrics.integration`) c'è già; manca la forma della richiesta e della
risposta. Da decidere quando si affronta il lavoro attivo, non ora.
