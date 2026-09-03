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

Idea dell'utente: durante il Backlog Refinement (e l'Iteration Planning) il
team resta a guardare lo schermo mentre la sweep di apertura — passo 2 di
`backlog-refinement`, "si apre guardando indietro" — gira **rigorosamente
in sequenza**: `nsm-watch` → `measurement-watch` → `mandate-watch` →
`deadline-watch` → `rice-watch` → `jira-sync` (riconciliazione). Ogni watch
fa da sola il ciclo completo `pull → scansiona tutte le idea.yaml →
calcola → scrive diretto → commit + push`, quindi il tempo di attesa =
**somma di 6 cicli**, con rilettura ripetuta delle stesse `idea.yaml` (3
watch su 6 le toccano tutte) e 6 commit separati.

**Perché "6 agenti autonomi in parallelo" non basta.** Se ogni watch gira
come subagent che fa il proprio ciclo completo, si rompono tre invarianti:
(a) git è un punto di serializzazione a scrittore singolo — 6
`governance-sync.sh push` concorrenti danno push non-fast-forward, proprio
il conflitto che il playbook vieta di risolvere in automatico; (b)
`mandate-watch`/`deadline-watch`/`rice-watch` scrivono campi diversi della
**stessa** `idea.yaml` → `Edit` paralleli si sovrascrivono; (c) ordine di
commit e narrazione non deterministici infrangono la promessa "dry-run
ripetibile identica". In più la cerimonia è una riunione dal vivo: l'ordine
fisso (`nsm-watch` per prima) è una scelta narrativa deliberata, e output
interlacciato da più agenti è peggio per chi segue.

**Decomposizione proposta — fan-out del calcolo, scrittura serializzata:**

- **Fase A (parallelizzabile) — calcolo.** Ogni watch in *modalità
  compute-only*: `pull`, scansiona, calcola i campi che dovrebbe cambiare,
  restituisce `{diff proposti, riepilogo per la stanza}`. Nessun `Edit`,
  nessun `push`.
- **Fase B (seriale, scrittore singolo) — scrittura.** L'orchestratore
  (`backlog-refinement`/`iteration-planning`) applica tutti i diff
  calcolati in un solo passaggio, **un commit, un push**, ordine
  deterministico.
- **Fase C (seriale, ordine voluto) — narrazione.** Presenta i riepiloghi
  alla stanza nell'ordine canonico — veloce, sta solo renderizzando
  risultati già pronti.

Wall-clock atteso: da `somma(6 watch) + 6 commit` a circa `max(watch) + 1
commit`. Tutti gli invarianti restano (git single-writer, merge
deterministico di campi disgiunti, dry-run riproducibile — la Fase A non
scrive comunque).

**Cosa resta seriale e va lasciato così:** walk di `pending-approval`
(passo 3, interattivo voce per voce), assegnazione `short_ref` (passo 4, è
*esplicitamente* il punto di serializzazione a scrittore singolo),
rilevamento reprioritizzazioni (passo 6), `jira-sync` in push (side-effect
esterni + dedup JQL).

**Due modi di implementare la Fase A (da decidere quando diventa lavoro
attivo):**

- *Consigliato:* una skill `watch-sweep` unica, un solo passaggio sulle
  `idea.yaml` — legge ogni file una volta, calcola i fatti di
  mandate/deadline/rice (+ nsm/measurement sui loro file) in quel
  passaggio, restituisce tutti i diff. Niente subagent. Prende ~80% del
  guadagno (leggi-una-volta / scrivi-una-volta / commit-una-volta) con la
  massima semplicità e determinismo. Le watch standalone restano com'sono
  per l'uso fuori cerimonia.
- Subagent paralleli veri solo per la watch il cui costo è realmente alto e
  indipendente — in pratica **solo `jira-sync`** (rete): isolarla in un
  subagent che gira mentre l'orchestratore fa il resto, raccoglierne il
  risultato alla fine.

**Costo del cambiamento:** tocca il playbook (le watch acquisiscono un
contratto documentato "compute-only" vs. "standalone"), i `SKILL.md` di 5
watch (separare "cosa calcola" da "come persiste"), il passo 2 di
`backlog-refinement` e `iteration-planning`. Una o due PR sul canonico.
Discusso in sessione 2026-09-03, fuori scope adesso.

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
