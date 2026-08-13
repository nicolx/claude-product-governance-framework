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
  `due_soon`/`overdue`/`pending_review` da `mandate-watch`. Oggi questi
  controlli esistono solo come skill Claude Code richiamate
  manualmente/durante il Backlog Refinement — un livello applicativo
  potrebbe renderli proattivi invece che "pull" (il PM deve chiedere).
  Nota: questo è un cambio di categoria rispetto alla decisione presa in
  sessione per `mandate-watch` ("solo segnalazione, nessuna
  comunicazione automatica") — lì la scelta è stata deliberata per le
  skill Claude Code interattive; se in futuro si costruisce un livello
  batch/email automatico, va ridiscussa esplicitamente, non ereditata
  per default.

## Integrazione DB/analytics in lettura per measurement-watch

Idea dell'utente: dare al sistema, a livello di configurazione, accesso
in autonomia (in lettura) a DB/tool di analytics, per controllare le
metriche delle iniziative senza dover chiedere ogni volta al PM. Lo
schema è già pronto ad accoglierlo (`measurement.yaml`, campo
`data_source.mode: manual | automated` per KPI, dichiarato nel PRD —
vedi `prd-draft`/`measurement-watch`), ma il connettore vero e proprio
**non esiste**: ogni istanza avrà uno stack diverso (DataBricks, altro,
niente), quindi non è qualcosa che il repo canonico può implementare in
modo agnostico. Discusso in sessione, punti fermi già decisi (da
rispettare quando si progetta il connettore reale):

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

**Ancora da capire (la "giusta astrazione"):** come si dichiara/configura
concretamente un'integrazione per istanza — un file locale con endpoint
dichiarati? Un MCP tool dedicato che l'istanza collega? Un contratto
minimo (query in ingresso, valore aggregato in uscita) che qualunque
connettore deve rispettare, indipendente dallo stack sottostante? Da
decidere quando si affronta il lavoro attivo, non ora.
