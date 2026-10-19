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
| `product/ideas/`, `product/prds/` (creazione) | Istanza | `idea-intake`, `inbox-triage`, `prd-draft` — creazione diretta, non passa da approvazione (non è ancora una decisione di priorità). **In più** `delivery-watch` crea idee di **backfill** (solo via `idea-intake` in modalità backfill, quando `delivery_watch.board_jql` intercetta attività su una card non collegata a nessuna idea): stessa logica — creazione diretta, non una decisione di priorità — con `source.type: jira_backfill` e `backfill_review_needed: true` finché il PM non conferma classificazione/product_line al triage |
| `product/ceremonies/` (cartella cerimonia, `source/`, `decisions.yaml`, `.run-meta.yaml`) | Istanza | `backlog-refinement`, `iteration-planning`, `log-ceremony` — registrazione diretta di una riunione di team: trascrizione + esito qualitativo + metadati di esecuzione. Non passa da `pending/` (non è una decisione di priorità: gli impatti su RICE/roadmap che ne derivano, sì). `.run-meta.yaml` è metadato di esecuzione scritto dalla skill, mai a mano. `rollback-ceremony` può annullare un run (revert forward dei commit + cartella `-void` con la trascrizione), mai una decisione già approvata |
| `product/ideas/*/delivery` (`estimated_effort_weeks`, `effort_by_competency`, `squad`, `estimate_basis`, `estimated_at`) e gli stessi campi in `platform` | Istanza | `iteration-planning` (stima `committed`) e `prd-draft` (stima `rough` dal referente tecnico, mai sopra una `committed`) — stima del team tech, mai inventata: persona-settimane per competenza del catalogo di `team.yaml` + durata in tempo-calendario, per il capacity check del Piano di Iterazione e lo `slot_plan` dello snapshot. **Non** un input del RICE. Scrittura diretta, nessuna approvazione (stessa logica di `deadline`/`rice_status`) — vedi playbook, "Capacità del team e slot della roadmap" |
| `product/ideas/*/rice_history`, `product/ideas/*/strategic_exceptions`, `product/ideas/*/mandate` (dopo la creazione), `product/ideas/*/classification` (riclassificazione a `mandate`), `product/roadmap/`, comunicazioni in uscita | Istanza | Solo tramite `product/approvals/pending/` — vedi regola sotto |
| `product/roadmap/iterations/` | Istanza | Solo tramite `product/approvals/pending/` (`type: iteration_plan`) — output team-facing del Backlog Refinement (proposto da `backlog-refinement`, confermato/aggiustato da `iteration-planning`), applicato solo da `pending-approval` all'approvazione. Parte dal piano della settimana precedente (`based_on`). Serie append-only, un file per settimana ISO, mai sovrascritto (tranne la revisione da Iteration Planning sulla stessa settimana) |
| `product/ideas/*/iteration` (`current`, `bucket`) | Istanza | Solo `pending-approval` all'approvazione di un `iteration_plan` — puntatore denormalizzato del piano approvato, scrittura diretta senza approvazione a sé (stesso principio di `jira.status`). Azzerato quando l'idea esce da tutti i bucket di un piano successivo |
| `product/ideas/*/mandate.analysis_start_by`, `mandate.lead_time_basis`, `mandate.escalation_status`, `mandate.escalation_basis` | Istanza | Solo `mandate-watch` (dal lead time dichiarato, dalla durata stimata dal team e dallo `slot_plan` dell'ultimo snapshot approvato; il lead time dichiarato non lo tocca mai — si riallinea solo con una proposta `mandate_update`) — fatti calcolati, non decisioni, scrittura diretta senza approvazione (stesso principio di `jira.status`) |
| `product/ideas/*/rice_status` (incluso `deep_dive`) | Istanza | `rice-watch` (e `idea-intake`/`inbox-triage` per `deep_dive.needed`/`requested_at` all'origine) — `flagged_since` è un fatto osservato; `blocked_reason`/`waiting_on`/`deep_dive.*` sono cattura di contesto (chiesti al PM, mai presunti), non decisioni di priorità: nessuna passa da approvazione |
| `product/ideas/*/monitoring` (path da monitorare) | Istanza | Solo con una fonte analytics collegata (`metrics.configured: true`, `metrics.paths.enabled` non `false`). `path-watch` — inline in `idea-intake`/`inbox-triage`/`prd-draft`, in background (solo-calcolo) nella sweep del Backlog Refinement che li scrive nel suo commit unico, o standalone — **suggerisce e applica** i path utente (funnel, pagine/schermate/eventi) trovati nel catalogo reale dell'analytics e in `apps/`, con una baseline **aggregata** (mai righe grezze). Configurazione di cosa osservare, non una decisione di priorità: scrittura diretta senza conferma, mai da `pending/`, recap al PM. Il PM toglie un path con `status: removed` + `removed_reason` (mai più riproposto). Applica i path anche **nello strumento di analytics** (`metrics.paths.write`: funnel/report salvato creato o riusato e allineato, eventi mancanti come pianificati), **anche su oggetti creati da altri**, con un criterio di **reversibilità**: una modifica reversibile (stato precedente registrato in `analytics_changes` — versione del tool o definizione completa) si applica senza conferma, ma quelle sul lavoro di altri vanno nel recap con prima/dopo; ogni azione **irreversibile o che tocca i dati storici** (eliminazioni, merge/blocco/rinomina di eventi o proprietà, dati, impostazioni di progetto, o una modifica di cui non si è potuto salvare lo stato precedente) richiede una **conferma esplicita del PM prima**, per quella singola modifica — in conversazione, non da `pending/` (conferma operativa, non decisione di priorità); senza PM in conversazione non si esegue. Il legame KPI→path (`measurement*.yaml`, `data_source.path_ref`) resta una scelta del PM in `prd-draft` — vedi playbook, "Measurement", "Path da monitorare" |
| `product/reference/product-lines.yaml` → `analytics_dashboard` | Istanza | Solo `path-watch` (passo 6b), con `metrics.paths.write.dashboards.enabled` non `false`: riferimento alla dashboard per Product Line nello strumento di analytics (creata dal framework o una esistente indicata dal PM), elenco dei grafici che il framework gestisce (`managed_charts` — gli unici che tocca) e registro append-only delle modifiche con lo stato precedente (`changes`). Fatto di configurazione, scrittura diretta senza approvazione; stesse regole di reversibilità di `monitoring` (irreversibile → conferma esplicita prima). Il resto di `product-lines.yaml` resta di `init-governance-project`/richiesta esplicita |
| `product/ideas/*/summary`, `product/ideas/*/notes` | Istanza | `idea-intake`/`inbox-triage` all'origine, poi qualunque skill/PM in conversazione — descrizione e note di contesto, non decisioni di priorità, scrittura diretta |
| `product/ideas/*/tech_reference` (puntatore denormalizzato) e `product/prds/*/prd*.md` frontmatter `tech_reference` | Istanza | `idea-intake`/`inbox-triage` come **ipotesi** all'intake (solo con segnale tecnico + `team.yaml` popolato, confermata dal PM, mai presunta); `prd-draft` come **valore solido** alla stesura (matching di `team-fit` contro l'How, su conferma); poi `team-fit`/`iteration-planning`/PM in conversazione. Referente per validare l'How e prima scelta naturale in assegnazione — **non** l'assegnazione di implementazione (quella è in Iteration Planning + tracker). Non è una decisione di priorità: scrittura diretta, mai da `pending/` (stessa logica di `deadline`/`iteration.current`/`jira.status`). Il valore deve corrispondere a un `members[].name` di `team.yaml` |
| `product/ideas/*/jira.*` | Istanza | `jira-sync` (tutte le modalità), `idea-intake`/`inbox-triage` per i bug all'intake (e `idea-intake` in modalità backfill per una card intercettata da `delivery-watch`), e `delivery-watch` (rinfresco di `jira.status`/`jira.last_polled_at` al poll, stesso fatto osservato di `jira-sync` Pull) — fatto osservato (il ticket esiste / il suo stato), scrittura diretta senza approvazione (stessa logica di `jira.status`). Per un `classification: bug` il filing è **immediato e obbligatorio** appena il PM conferma la classificazione: il ticket si apre subito (con impatto stimato), mai rimandato a un secondo assenso — vedi playbook, "Alimentazione del bucket delle idee", punto a. Se il connettore è `manuale`/irraggiungibile resta un'azione aperta esplicita, mai un filing silenziosamente saltato |
| `product/ideas/*/short_ref` | Istanza | Solo `backlog-refinement`, assegnato pigramente (`{prefisso}-{NNN}`, `next = max+1`) al primo refinement che incontra l'idea senza handle. Il refinement è un punto di serializzazione a scrittore singolo → niente collisioni offline; nessun file contatore. Fatto di housekeeping, scrittura diretta, non passa da `pending/`. Una volta assegnato non cambia. `id`/nome cartella restano l'identificatore canonico |
| `product/ideas/*/requester_reply`, `product/ideas/*/followup_replies` | Istanza | `idea-intake`/`inbox-triage` — bozza di risposta a **chiunque** abbia mandato materiale all'intake (qualunque esito: idea, bug, SE, mandate, platform, scarto, chiarimento; `followup_replies` per materiale che aggiorna un'idea o un PRD esistente — per un PRD, sull'idea del suo `idea_id`), **mai inviata in automatico** (la manda il PM). Si salta solo se non c'è nessuno da avvisare (idea del PM, brainstorm interno, backfill). `reply_status` `sent`/`waived` lo scrive qualunque skill (tipicamente la sweep di `backlog-refinement`) o il PM in conversazione, su sua dichiarazione. Cortesia 1:1 con l'idea, non una decisione applicata a un target file: nessuna approvazione via `pending/`, stessa logica di `clarification.draft_message`. L'hook `check-requester-replies.sh` ricorda le bozze `drafted` — vedi playbook, "Chiudere il loop col richiedente" |
| `product/ideas/*/conclusion_notices` | Istanza | Chi rileva la conclusione: `delivery-watch` (triage di un `delivered`/`bug_resolved`), `jira-sync` (Pull/Riconciliazione, Done confermato dal PM), `measurement-watch` (atto di chiusura), `backlog-refinement`/qualunque skill o PM in conversazione (interruzione, o consegna dichiarata a mano). Bozza di avviso di conclusione agli stakeholder, **mai inviata in automatico** (la manda il PM) — stessa logica di `requester_reply`, scrittura diretta, append-only, non passa da `pending/`. È il **gate** di `status: done`/`aborted` e di `closure.closed: true`: quei valori si scrivono solo nello stesso passo in cui la voce arriva a `sent` o `waived` (motivo dato dal PM, mai presunto) — vedi playbook, "Avvisare gli stakeholder della conclusione" |
| `product/ideas/*/status: declined`/`aborted`, `product/ideas/*/decline_reason` | Istanza | `idea-intake`/`inbox-triage` propongono lo scarto al triage, **oppure** `backlog-refinement` a un checkpoint della sweep di apertura quando il PM decide che un'idea non ha più motivo di esistere (`declined` se non è mai partita, `aborted` se era in lavorazione). Sempre su conferma **in conversazione** (è un giudizio) — non passa dalla coda `pending/`, ma non è mai deciso dalla sola skill; l'azione va registrata in `decisions.yaml` della cerimonia |
| `product/ideas/*/deadline.due_date`, `product/ideas/*/deadline.note` | Istanza | Qualunque skill che la incontra in conversazione (tipicamente `idea-intake`/`inbox-triage` all'origine) — cattura di un fatto dichiarato dal PM, mai presunto; impostarlo non cambia la priorità, stessa logica di `rice_status`, nessuna approvazione |
| `product/ideas/*/deadline.escalation_status`, `deadline.escalation_basis`, `deadline.start_by` | Istanza | Solo `deadline-watch` (dal calendario, dalla durata stimata e dallo `slot_plan` dell'ultimo snapshot approvato) — fatto calcolato, scrittura diretta senza approvazione (stesso principio di `mandate.escalation_status`) |
| `product/prds/*/README.md` (brief d'iniziativa), `product/prds/*/allegato-*.md`, `product/prds/*/assets/` | Istanza | `prd-draft` (il brief anche in bozza dalla Preliminary analysis) — creazione diretta come i PRD, non passa da approvazione. Devono reggersi senza la sessione che li ha scritti (playbook, "Scrivere per il lettore", P7) |
| `product/prds/*/.reviews/` | Istanza, **tracciata da git** | Solo `prd-draft`: esito delle letture a freddo (chi ha letto cosa, lacune → correzioni, domande residue). Fatto osservato, scrittura diretta. Non scritto in dry-run |
| `product/ideas/*/source/key-points.yaml` | Istanza | `idea-intake`/`inbox-triage` all'origine; `prd-draft` aggiorna `status`/`covered_by`/`exclusion_reason` e aggiunge i punti nati dall'analisi o dalle decisioni del PM. Un'esclusione è confermata dal PM in conversazione. Scrittura diretta (registro del lavoro, non decisione di priorità) |
| `product/prds/*/measurement*.yaml` (creazione) | Istanza | Solo `prd-draft`, contestualmente alla creazione del PRD — non passa da approvazione (stessa logica della creazione di idee/PRD) |
| `product/prds/*/measurement*.yaml` (readings, measurement_status, follow_up_needed, closure) | Istanza | Solo `measurement-watch` — letture riportate dal PM e `closure` sono cattura di decisioni/fatti già espressi in conversazione (mai presunti, mai chiusi di iniziativa propria), `measurement_status` è calcolato dai dati. Nessuno di questi passa da approvazione |
| `product/demos/recipes/*.yaml` | Istanza, **tracciata da git** | `demo-capture` scaffolda al primo uso, PM/team tech completano — contratto tecnico per-app (come portare su l'app in modalità demo, quali flussi catturare), non una decisione di priorità: scrittura diretta, nessuna approvazione. **Mai segreti** dentro (env var per nome, non valori) — stesso vincolo di `framework/docs/future-work.md` |
| `product/demos/captures/*/manifest.yaml` | Istanza, **tracciata da git** | Solo `demo-capture` — record di audit di cosa è stato catturato, da quale commit, quando: fatto osservato, non decisione (stessa logica di `jira.card_id`), scrittura diretta senza approvazione |
| `product/demos/captures/*/screenshots/` | Istanza, **NON tracciata da git** (`.gitignore` di root) | Solo `demo-capture` — artefatti binari, mai committati. `demo-capture` non fa **nessuna azione in uscita**: è il PM ad allegarli alla card del tracker di esecuzione / al deck per gli stakeholder, a mano (stessa logica di `requester_reply`) |
| `product/reference/test-environments.yaml` | Istanza, **tracciata da git** | Creato da `init-governance-project` (passo 5b dell'intervista, anche solo con `accounts: []`); fatto evolvere da `test-accounts` (aggiunta, attivazione, verifica, rotazione, ritiro). `app-test` e `demo-capture` vi scrivono solo le voci `status: wanted` (un utente che serve e non c'è), `last_verified_at` e `status: broken`/`environments[].status`. Ambienti (dev/stg/prod/preview: URL, `allowed_hosts`, `tier`) e utenti di prova (persona, ruoli, login, MFA, owner, stato). **Mai credenziali**: solo riferimenti (`local:`/`env:`/`keychain:`/`op://`) risolti da `.claude/hooks/test-credentials.sh`, nessuno schema a comando. Dato di riferimento condiviso come `team.yaml`: scrittura diretta, non passa da approvazione — vedi playbook, "Ambienti e utenti di prova" |
| `.governance/test-credentials.local.env` | Istanza, **NON tracciata da git** (`.gitignore` di root: `.governance/*.local.env`) | Creato da `test-credentials.sh init-local` (permessi 600); i valori li inserisce il PM con un editor, o `test-accounts` se il PM li ha dati in conversazione. Archivio locale delle credenziali per i riferimenti `local:`, solo di questo clone. Mai letto da altro che dall'helper, mai copiato altrove |
| `product/tests/runs/*/run.yaml` | Istanza, **tracciata da git** | Solo `app-test` — record di un giro di navigazione con un utente di prova (ambiente, utente per id, passi, esito, errori di console/rete in sintesi, azioni confermate in produzione): fatto osservato, scrittura diretta senza approvazione. Mai credenziali |
| `product/tests/runs/*/screenshots/` | Istanza, **NON tracciata da git** (`.gitignore` di root) | Solo `app-test` — artefatti binari (in produzione possono contenere dati reali), mai committati, nessuna azione in uscita |
| `product/reference/nsm-tracking.yaml` | Istanza | Solo `nsm-watch` — creato lazy al primo run (non da `init-governance-project`), scritto direttamente: `readings`/`trend_status`/`alert.status` sono fatti/calcoli osservati, `discovery_focus_confirmed`/`resolved_*` sono cattura di decisioni già espresse dal PM in conversazione. Nessuno di questi passa da approvazione |
| `product/reference/delivery-watch.yaml` | Istanza, **tracciata da git** | Solo `delivery-watch` (poll+detect e triage) — creato lazy al primo run (non da `init-governance-project`, richiede `jira.configured: true` + `delivery_watch.enabled: true`). `last_watch`/`tickets` sono fatti osservati dal tracker; le voci `queue` (un evento per **ogni** movimento di una card) sono fatti osservati; le bozze di mail (`draft_*`) le prepara la watch al rilevamento per ogni evento (tranne le consegne, nel triage dopo il giudizio DoD del PM), il loro esito (`sent_at`, `dismiss_reason`) è cattura di decisioni già espresse dal PM (mai presunte). Nessuno passa da approvazione. Le mail non partono mai in automatico: bozza nella voce di coda, la manda il PM (stessa logica di `requester_reply`); il testo inviato resta come trail |
| `product/ideas/*/backfill_review_needed` | Istanza | `delivery-watch` lo mette a `true` alla creazione di un'idea di backfill; qualunque skill/PM lo azzera al triage dopo aver confermato classificazione/product_line (o archiviato l'idea). Fatto di provenienza, scrittura diretta, non passa da approvazione (stessa logica di `rice_status`) |
| `product/reference/annual-target.yaml` | Istanza | Creato da `init-governance-project` (passo 4 intervista); aggiornato in seguito solo su richiesta esplicita dell'utente (nuovo Budget/BP, override per Product Line). È l'incremento atteso, mai il totale a budget — `rice-update` lo legge per calibrare l'Impact. Non passa da approvazione (è un dato di riferimento condiviso, come il denominatore Reach) |
| `product/reference/team.yaml` | Istanza | Creato da `init-governance-project` (passo 10 intervista, anche solo scaffold vuoto); popolato e aggiornato in seguito da `team-roster` (aggiunta/rimozione/modifica di un membro) o su richiesta esplicita. Anagrafica del team di sviluppo (presidio `apps/`, competenze, disponibilità) e sua **capacità** (catalogo delle competenze, `fte` dedicato al prodotto, ripartizione per competenza, assenze solo come date, overhead, squad) — l'offerta da cui backlog-refinement/iteration-planning calcolano il capacity check del piano e `roadmap-snapshot` lo `slot_plan`. Capacità è tempo dedicato, mai produttività. Dato di riferimento condiviso come `product-lines.yaml`/`annual-target.yaml`, **descrittivo e non valutativo**, non passa da approvazione. `team-fit` lo legge per proporre candidati su un PRD (e, su conferma del PM, scrive il `tech_reference` del PRD — riga sopra); non assegna l'implementazione |
| `product/reference/stakeholders.yaml` | Istanza, **tracciata da git** | Creato vuoto da `init-governance-project` (o lazy); popolato da `stakeholder-profile` su conferma del PM in conversazione. **Identikit condiviso** degli stakeholder — ruolo, peso, cosa gli importa, come vogliono ricevere le informazioni, punti di forza e punti di attenzione, cosa funziona e cosa no, episodi append-only: la memoria comune dei PM, che chi arriva eredita. **Test del lettore**: solo comportamenti osservati con episodio (o `hypothesis` dichiarate), mai giudizi sul carattere, mai dati personali che non servono a comunicare sul lavoro. Lo leggono in sola lettura le skill che preparano bozze che il PM manda a mano, per calibrarle. Dato di riferimento condiviso: scrittura diretta, non passa da approvazione — vedi playbook, "L'identikit degli stakeholder e il rapporto individuale" |
| `.governance/stakeholder-relationships.local.yaml` | Istanza, **NON tracciata da git** (`.gitignore` di root: `.governance/*.local.yaml`) | Solo `stakeholder-profile`, su dichiarazione del PM (mai dedotto). **Rapporto individuale** tra il PM di questo clone e ogni stakeholder (familiarità, fiducia, tensioni, registro, note franche). Senza voce il rapporto vale `new`. Letto in sola lettura dalle skill che calibrano le bozze; il suo contenuto non entra mai in un file tracciato, in un commit, in una bozza o in `pending/` (la riga `Calibrazione` vive solo in conversazione). Nessun backup git: chi cambia macchina lo copia a mano |
| `product/reference/reporting-models.yaml`, `product/reference/models/` | Istanza, **tracciata da git** | Creati da `init-governance-project` (passo "Modelli di reporting" dell'intervista); aggiornati in seguito da `report-render` in modalità setup, su richiesta esplicita. Le viste che l'istanza produce (modello, pubblico, cadenza, destinazione) e i formati aziendali **trascritti** con la mappatura campo → dato del framework (il file grezzo non persiste, come in `context/`). Dato di riferimento condiviso come `product-lines.yaml`: scrittura diretta, non passa da approvazione. I modelli standard vivono in `framework/models/` (proprietà framework): un'istanza non li modifica, li estende con `extends: framework:<id>` |
| `product/reports/{vista}/{periodo}.md` | Istanza, **tracciata da git** | Solo `report-render` — report **derivato** dai soli dati approvati (piano, snapshot, idee, NSM, misurazioni) e dal registro delle cerimonie (commenti), rigenerabile, mai editato a mano: se è sbagliato si corregge la fonte e si rigenera. Scrittura diretta. Le viste `cadence: per_ceremony` (la roadmap aggiornata, nel formato dell'istanza — `framework:roadmap-di-lavoro` di default o un modello aziendale) si rigenerano **in automatico, senza conferma**: `log-ceremony` alla chiusura di ogni cerimonia (nel commit del run) e `pending-approval` a fine giro se ha approvato piano/RICE/SE/mandate/snapshot; con proposte ancora in `pending/` il report lo dichiara in testa, mai le mostra come decise. L'aggiornamento settimanale (`framework:aggiornamento-settimanale` o un modello che lo estende, `cadence: weekly`) lo prepara `pending-approval` subito dopo aver approvato lo snapshot della settimana, con le consegne stimate dal suo `slot_plan` Distribuirlo fuori dal team è invece una comunicazione in uscita: passa da `pending/` (`type: outbound_comm`), e lo invia/pubblica il PM a mano |
| `product/reference/glossary.yaml` | Istanza | Creato vuoto da `init-governance-project`; termini aggiunti da `prd-draft`/`idea-intake`/`inbox-triage` alla conferma del PM in conversazione. Dato di riferimento condiviso, scrittura diretta |
| `.governance/config.yaml` | Istanza | Solo `init-governance-project`, in scrittura successiva solo su richiesta esplicita dell'utente. Eccezione: `framework.upstream_ref` lo riscrive `sync-framework-updates` dopo ogni merge da `upstream` (fatto di sincronizzazione, non una scelta) |
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

Corollario: `app-test` e `test-accounts` non rientrano nella regola —
navigare un ambiente con un utente di prova e registrare cosa si è visto
sono fatti osservati, e non c'è comunicazione in uscita (stessa logica di
`demo-capture`). Il loro vincolo è un altro: in **produzione** ogni
azione che crea/modifica/cancella dati, invia messaggi, muove denaro o
tocca integrazioni esterne richiede la conferma esplicita del PM prima,
per quella singola azione, in conversazione (conferma operativa, non
decisione di priorità: non passa da `pending/`); e nessuna credenziale
entra mai nel repo tracciato — vedi playbook, "Ambienti e utenti di
prova".

Corollario: `delivery-watch` non rientra nella regola. Osserva il tracker
di esecuzione e mette **ogni movimento** delle card (in sviluppo, in
review, ogni altro cambio di stato, bloccata, in produzione, bug
risolto, regressione) in una coda di triage
(`product/reference/delivery-watch.yaml`) — fatti osservati, scrittura
diretta, come le altre watch. Non invia mai nulla: nel triage il PM
prepara una **bozza di mail** dentro la voce di coda e la **manda a
mano** (stessa logica di `requester_reply` — nessun `outbound_comm`,
nessun gate `pending/`; il testo inviato resta nella voce come trail). Il
**backfill** di un'idea da una card Jira non tracciata è creazione
diretta (stessa logica di `idea-intake`), non una decisione di priorità.

Corollario: l'**avviso di conclusione** agli stakeholder (consegna in
produzione, chiusura della misurazione, interruzione —
`conclusion_notices` sull'idea) non passa da `pending/`, ma è
**obbligatorio**: è il gate del cambio di stato (`status: done`/
`aborted`, `closure.closed: true`), che si scrive solo quando l'avviso è
`sent` (inviato a mano dal PM) o `waived` (esente, con motivo del PM).
Nessun invio automatico; nessun secondo assenso, perché rimandarlo
significa perderlo — vedi playbook, "Avvisare gli stakeholder della
conclusione".

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
come "read-critical" devono aprire con `governance-sync.sh pull`. Le skill
che ragionano sul codice (`inbox-triage`, `idea-intake`, `prd-draft`,
`rice-update`, `path-watch`) eseguono `governance-sync.sh apps` prima di leggerlo, che porta i submodule di `apps/` all'ultimo
commit remoto senza committare il puntatore. Vedi playbook, sezione
"Sincronizzazione dell'istanza (`origin`)".

Helper gemello per la **lettura in blocco**: `.claude/hooks/governance-dump.sh`
(`sweep`|`backlog`|`ideas`|`measurements`|`iterations`|`pending`|
`reference`|`delivery`) concatena in **una sola tool call** i file YAML rilevanti,
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
esterno — il framework non fissa quali: `jira:` (il tracker, lo usano
`jira-sync` e `delivery-watch`; Jira o altro), `metrics:` (la fonte di
NSM/KPI, la usano le watch di metriche), e `connectors:` (lista aperta
per il resto). Stessa
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
non tracciato). Il blocco `browser:` (driver con cui `app-test`/
`demo-capture` navigano gli ambienti con gli utenti di prova) segue la
stessa disciplina; `test-credentials.sh resolve` (l'unico sottocomando
che espone un valore) si pre-autorizza solo se il PM lo chiede. Restano interattivi solo le decisioni di priorità
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

## Changelog del framework (`framework/CHANGELOG.md`)

Ogni modifica al canonico che chiede qualcosa a un'istanza già
inizializzata — uno schema nuovo o cambiato, un blocco di config, una
cartella o un file di riferimento di istanza, permessi, un campo con un
significato nuovo, una funzione che si attiva solo con un dato da
raccogliere — **aggiunge una voce in `framework/CHANGELOG.md` nello
stesso commit**: `id` stabile, tipo di impatto (`nessuna` / `setup` /
`migrazione` / `migrazione-meccanica`), cosa cambia in linguaggio PM,
cosa fare nell'istanza, e un controllo "già a posto se". È ciò che
`sync-framework-updates` legge dopo il merge per proporre a ogni istanza
solo ciò che le manca; una modifica senza voce costringe a ricostruire
il setup dal diff, e la skill la segnala come difetto del canonico. Se
la funzione si raccoglie anche all'init, aggiorna anche
`init-governance-project`: l'init copre le istanze nuove, il changelog
quelle esistenti.

## Quando scrivi codice/script in questo repo

Vale comunque la guida globale dell'utente su qualità/coding standard.
Questo repo è prevalentemente Markdown/YAML/shell: niente framework
applicativi da introdurre, niente dipendenze non necessarie negli script
di bootstrap (devono restare eseguibili con solo bash + git + sed,
nessun requisito aggiuntivo).
