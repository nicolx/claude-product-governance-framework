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
