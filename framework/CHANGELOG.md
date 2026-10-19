# Changelog del framework

Cosa cambia per un'**istanza** a ogni evoluzione del metodo, e cosa va
fatto dopo l'aggiornamento. Lo legge `sync-framework-updates`: dopo il
merge da `upstream` prende le voci nuove rispetto all'ultima versione
integrata, verifica per ciascuna se l'istanza è già a posto, e propone
al PM solo ciò che resta da fare.

Un'istanza inizializzata **dopo** una voce non ne ha bisogno:
`init-governance-project` raccoglie già tutto ciò che serve allo stato
corrente del framework.

## Come si scrive una voce (per chi mantiene il canonico)

Ogni modifica che cambia uno schema, la config, le cartelle o i file di
istanza, i permessi, o che si attiva solo con un dato da raccogliere,
**aggiunge una voce in questo file nello stesso commit**. Le modifiche
che non chiedono niente all'istanza (testo del playbook, skill che fanno
meglio la stessa cosa) possono avere una voce `nessuna` se il PM deve
sapere che il comportamento è cambiato; altrimenti niente voce.

Voci in ordine dal più recente. Ogni voce:

```
### <id: YYYY-MM-DD-slug> · <titolo in linguaggio PM>

- **Impatto**: nessuna | setup | migrazione | migrazione-meccanica
- **Cosa cambia**: per il PM, non per chi legge il diff
- **Cosa fare nell'istanza**: passi e skill, in ordine
- **Già a posto se**: controllo verificabile sul repo dell'istanza
  (file presente, chiave in config, campo popolato) — permette di non
  riproporre ciò che è già fatto
```

L'`id` non cambia mai: è la chiave con cui `sync-framework-updates`
riconosce le voci nuove. Le voci ricostruite a ritroso dalla storia git
(prima di questo file) riportano anche il commit d'origine.

Tipi di impatto:

- **nessuna** — il comportamento cambia, nell'istanza non c'è nulla da
  fare. Va solo spiegato.
- **setup** — la funzione si attiva con una dichiarazione o un dato
  dell'istanza (un file di riferimento, un blocco di config, permessi).
  Senza, l'istanza si comporta come prima. Si **propone**, non si
  applica da soli, e non blocca nulla.
- **migrazione** — dati esistenti hanno la semantica vecchia e serve
  giudizio per portarli alla nuova (es. ri-stimare). Si propone un piano
  minimo; non si modificano in massa i file di istanza senza richiesta
  esplicita.
- **migrazione-meccanica** — conversione di formato senza giudizio.
  Applicabile da `sync-framework-updates` **su conferma esplicita** del
  PM, in un unico commit, mostrando prima/dopo.

---

### 2026-10-19-identikit-stakeholder · Le bozze si calibrano sullo stakeholder e sul tuo rapporto con lui

- **Impatto**: setup
- **Cosa cambia**: il framework tiene l'identikit degli stakeholder
  (ruolo, peso, cosa gli importa, come vuole ricevere le informazioni,
  punti di attenzione come comportamenti osservati, cosa funziona e
  cosa no) in `product/reference/stakeholders.yaml`, tracciato e
  condiviso tra i PM. In più ogni PM tiene il **suo** rapporto con
  ciascuno (familiarità, fiducia, tensioni, note franche) in
  `.governance/stakeholder-relationships.local.yaml`, locale e mai
  tracciato. Le bozze che il PM manda a mano (risposte all'intake,
  avvisi di conclusione, mail di `delivery-watch`, comunicazioni in
  uscita) si calibrano sui due livelli: chi è appena arrivato riceve
  bozze diverse da chi ci lavora da anni, soprattutto con uno
  stakeholder difficile. Accanto alla bozza, una riga `Calibrazione`
  (solo in conversazione) dice cosa è stato adattato. Nuova skill
  `stakeholder-profile`; nuova sezione del playbook "L'identikit degli
  stakeholder e il rapporto individuale". Senza identikit le bozze
  escono con tono neutro, come prima.
- **Cosa fare nell'istanza**:
  1. verifica che il `.gitignore` integrato escluda il file locale:
     `git check-ignore -q .governance/stakeholder-relationships.local.yaml`
     deve riuscire (lo fa il `.gitignore` di root, nessuna modifica
     d'istanza). Finché non riesce, `stakeholder-profile` rifiuta di
     scrivere il rapporto individuale;
  2. proponi `stakeholder-profile` in modalità semina per gli
     stakeholder ricorrenti (stakeholders delle linee, proposer
     frequenti, `who` del registro delle frizioni) — uno alla volta,
     mai in blocco. Il file condiviso si crea al primo uso;
  3. ogni PM dell'istanza, sul proprio clone, dichiara il suo rapporto
     con gli stakeholder che conosce già (altrimenti vale `new`).
- **Già a posto se**: esiste `product/reference/stakeholders.yaml` e
  `git check-ignore -q .governance/stakeholder-relationships.local.yaml`
  riesce.

### 2026-10-19-utenti-di-prova · Il framework naviga gli ambienti con utenti di prova

- **Impatto**: setup
- **Cosa cambia**: il framework può aprire gli ambienti delle app (dev,
  stg, prod, preview) via Chrome con utenti di prova, per riprodurre un
  bug, verificare una consegna, esplorare un flusso, fare debug e
  screenshot (skill `app-test`). Registro tracciato
  `product/reference/test-environments.yaml` con solo i riferimenti alle
  credenziali; i valori stanno nel password manager o nel file locale
  `.governance/test-credentials.local.env` (non tracciato). Gli utenti
  che servono ma non esistono restano `wanted`: quando qualcuno li crea,
  l'hook di sessione lo segnala e `test-accounts` li attiva. In
  produzione sola lettura, salvo conferma del PM azione per azione.
  Nuovo blocco `browser:` in config; `demo-capture` può prendere
  ambiente e utente dal registro; `idea-intake`/`inbox-triage` tolgono
  le credenziali dal materiale grezzo.
- **Cosa fare nell'istanza**:
  1. `test-accounts` (modalità setup) per dichiarare ambienti e utenti
     di prova esistenti — anche nessun utente, solo quelli `wanted`;
  2. il blocco `browser:` in `.governance/config.yaml` (scrittura solo
     su richiesta esplicita del PM) e, se lo vuole, le allow entries del
     driver in `.claude/settings.local.json` (vedi
     `init-governance-project`, "Cosa scrivere", punto 7);
  3. per le recipe `deployed` con credenziali in env var, il passaggio a
     `deployed.environment`/`account_ref` — le env var restano un
     ripiego valido.
  Se `.governance/test-credentials.local.env` esiste già, verifica con
  `git check-ignore` che sia escluso.
- **Già a posto se**: esiste `product/reference/test-environments.yaml`
  e `.governance/config.yaml` ha un blocco `browser:`.

### 2026-10-19-slot-plan-a-valle · Viste, watch e report leggono lo slot plan

- **Impatto**: nessuna
- **Cosa cambia**: dallo slot plan dello snapshot (voce
  `2026-10-19-capacita-e-slot`) ora leggono anche `backlog-list` e
  `iteration-board` (quando ogni idea può partire), il Now/Next/Later e
  l'aggiornamento settimanale (cosa arriva quando, scostamento dalla
  roadmap trimestrale distribuita), la scorecard (cosa si fa per le
  metriche in allarme), `iteration-planning` (anteprima di come le stime
  spostano gli slot), `deadline-watch` e `mandate-watch` (scadenze che
  non ci stanno con la capacità), `rice-watch` (idee senza RICE che
  consumano capacità), `measurement-watch` (misurazione pronta prima del
  rilascio), `delivery-watch` (inizio e consegna confrontati con lo slot
  previsto), `report-render` (formati aziendali mappati sugli slot).
  Commit `c193a2c`…`cf6f038`.
- **Cosa fare nell'istanza**: niente oltre alla voce
  `2026-10-19-capacita-e-slot`. Senza slot plan queste viste lo dicono
  in una riga e si comportano come prima.
- **Già a posto se**: sempre.

### 2026-10-19-capacita-e-slot · La roadmap si pianifica a slot dentro la capacità reale del team

- **Impatto**: setup
- **Cosa cambia**: catalogo `competencies`, `capacity` per membro e per
  team, `squads` in `team.yaml`; `effort_by_competency`/`squad`/
  `estimate_basis` nei blocchi `delivery` e `platform` dell'idea;
  `capacity_check` nel Piano di Iterazione; `capacity_allocation.by_competency`
  e `slot_plan` nello snapshot — playbook, "Capacità del team e slot
  della roadmap". Commit `8de3f95`.
- **Cosa fare nell'istanza**: tutti i campi nuovi sono opzionali; senza,
  capacity check `not_available`, `total_capacity_weeks` chiesto al team,
  slot plan vuoto con il motivo. Proponi, in quest'ordine e senza
  applicarlo da solo:
  1. `team-roster` per dichiarare catalogo delle competenze, `fte`,
     ripartizione e assenze — prerequisito di tutto il resto;
  2. al prossimo Iteration Planning, le stime `effort_by_competency` per
     le iniziative in iterazione: quelle con il solo
     `estimated_effort_weeks` restano valide come durata, ma senza
     ripartizione contano come non dimensionate. Non ripartire d'ufficio
     le stime vecchie;
  3. per le idee prioritizzate fuori dal piano con un PRD, una stima
     `rough` dal referente tecnico (`prd-draft` la chiede alla prossima
     revisione).
  Gli snapshot già approvati restano com'erano: il loro
  `total_capacity_weeks` era dichiarato (equivale a `basis: declared`) e
  `roadmap_weeks` sommava durate — non confrontabile 1:1 con i nuovi,
  dillo se il PM ne guarda la serie storica.
- **Già a posto se**: `product/reference/team.yaml` ha `competencies`
  non vuoto e almeno un membro con `fte` valorizzato.

### 2026-10-18-bozze-pronte-da-incollare · Le bozze da mandare a mano si vedono subito e si incollano senza ritocchi

- **Impatto**: nessuna
- **Cosa cambia**: risposte ai richiedenti, mail di `delivery-watch`,
  avvisi di conclusione si mostrano per intero e si copiano negli appunti
  (`.claude/hooks/copy-to-clipboard.sh`, già pre-autorizzato). Commit
  `95fbe07`.
- **Cosa fare nell'istanza**: niente.
- **Già a posto se**: sempre.

### 2026-10-18-ogni-movimento-jira · Ogni movimento di una card ha il suo aggiornamento allo stakeholder

- **Impatto**: setup
- **Cosa cambia**: `delivery-watch` rileva ogni cambio di stato (in
  sviluppo, in review, bloccata, in produzione, bug risolto, regressione)
  e per ciascuno prepara la bozza di mail. Nuove chiavi in
  `delivery_watch:` (`review_status_names`, `blocked_status_names`,
  `regression_labels`). Commit `2592f67`.
- **Cosa fare nell'istanza**: se `delivery_watch.enabled: true`, chiedi
  al PM come si chiamano sulla board gli stati di review e di blocco e le
  label di regressione, e proponi di aggiungerle alla config (vuote =
  default ragionevoli).
- **Già a posto se**: `delivery_watch.enabled` non è `true`, oppure la
  config ha `review_status_names`.

### 2026-10-18-roadmap-per-cerimonia · La roadmap si rigenera da sola a fine di ogni cerimonia

- **Impatto**: setup
- **Cosa cambia**: `log-ceremony` e `pending-approval` rigenerano le
  viste con `cadence: per_ceremony` di `reporting-models.yaml`. Modello
  standard `framework:roadmap-di-lavoro`. Commit `04798f3`.
- **Cosa fare nell'istanza**: senza una vista `per_ceremony` l'istanza
  si comporta come prima e la cerimonia lo ricorda in una riga. Proponi
  (senza applicarlo) di dichiararla con `report-render` setup — dando
  `per_ceremony` alla vista di roadmap che l'istanza già ha, se c'è (il
  suo formato resta il suo), o aggiungendo `framework:roadmap-di-lavoro`.
- **Già a posto se**: `product/reference/reporting-models.yaml` ha
  almeno una vista con `cadence: per_ceremony`.

### 2026-10-18-risposta-a-ogni-mittente · Ogni intake prepara una risposta per chi ha mandato il materiale

- **Impatto**: migrazione-meccanica
- **Cosa cambia**: bozza di risposta per qualunque esito (anche bug,
  mandate, platform, aggiornamenti di idee/PRD esistenti),
  `followup_replies`, `requester_reply.reply_status`; l'hook
  `check-requester-replies.sh` ricorda quelle `drafted`. Commit
  `1effc75`.
- **Cosa fare nell'istanza**: `requester_reply.reply_status` si
  ricava così — `needed: true` e `sent_at` valorizzato → `sent`;
  `needed: false` → `not_needed`; `needed: true` e `sent_at: null` →
  **chiedere al PM** (inviata a voce/fuori traccia → `sent` o `waived`,
  altrimenti `drafted`), mai presunto. Le prime due regole sono
  meccaniche: applicabili su conferma, un commit.
- **Già a posto se**: nessuna idea ha `requester_reply.needed`
  valorizzato senza `reply_status`.

### 2026-10-18-path-da-monitorare · Path da monitorare suggeriti e applicati, anche nell'analytics

- **Impatto**: setup
- **Cosa cambia**: con una fonte analytics collegata (`metrics.configured:
  true`), `path-watch` suggerisce e applica a ogni idea i percorsi utente
  da monitorare (blocco `monitoring`), li crea o allinea nello strumento
  (solo modifiche reversibili; quelle irreversibili chiedono conferma) e
  tiene una dashboard per Product Line (`analytics_dashboard` in
  `product-lines.yaml`). Sottoblocco `metrics.paths` in config, attivo di
  default. Commit `4f33877`, `9dc3405`, `98ab12c`, `f21b350`.
- **Cosa fare nell'istanza**: solo se `metrics.configured: true`.
  Spiega che è attivo di default e chiedi al PM se tenerlo
  (`metrics.paths.enabled`), se lo strumento va lasciato in sola lettura
  (`write.enabled: false`), la cartella dedicata (`write.folder`) e, per
  ogni Product Line, se usare una dashboard esistente. Aggiorna le allow
  entries della fonte metriche in `.claude/settings.local.json` (solo
  lettura + scritture reversibili — `init-governance-project`, punto 7).
- **Già a posto se**: `metrics.configured` non è `true`, oppure la
  config ha il sottoblocco `metrics.paths`.

### 2026-10-18-tabelle-indirizzabili · Ogni tabella di idee mostra ID, summary, R·I·C·E e RICE totale

- **Impatto**: nessuna
- **Cosa cambia**: tutte le viste di idee hanno le stesse colonne. Commit
  `b5a2e45`.
- **Cosa fare nell'istanza**: niente (il `summary` mancante si vede:
  vedi `2026-09-01-chiudere-il-loop`).
- **Già a posto se**: sempre.

### 2026-10-18-pull-di-apps · Il codice di apps/ si aggiorna prima delle diagnosi

- **Impatto**: nessuna
- **Cosa cambia**: `inbox-triage`, `idea-intake`, `prd-draft`,
  `rice-update` portano i submodule all'ultimo commit remoto prima di
  leggere il codice (`governance-sync.sh apps`). Chiave `sync.apps_pull`
  (default `true`). Commit `8d7ab6d`.
- **Cosa fare nell'istanza**: niente; per spegnerlo `sync.apps_pull:
  false`.
- **Già a posto se**: sempre.

### 2026-10-18-modelli-di-reporting · Modelli di reporting: template standard e formati aziendali

- **Impatto**: setup
- **Cosa cambia**: `product/reference/reporting-models.yaml` dichiara le
  viste che l'istanza produce (modello, pubblico, cadenza, destinazione);
  formati aziendali trascritti in `product/reference/models/`;
  `report-render` le genera in `product/reports/`. Commit `a00c52c`.
- **Cosa fare nell'istanza**: proponi `report-render` in modalità setup —
  almeno una vista di roadmap e una di metriche. Senza, nessun report.
- **Già a posto se**: esiste `product/reference/reporting-models.yaml`.

### 2026-10-18-avviso-di-conclusione · La conclusione si chiude quando è comunicata

- **Impatto**: nessuna
- **Cosa cambia**: nuovo gate — `status: done`/`aborted` e
  `closure.closed` solo con un avviso agli stakeholder
  (`conclusion_notices`) `sent` o `waived`. Commit `6eaf771`.
- **Cosa fare nell'istanza**: il gate vale **in avanti**: idee già
  `done`/`aborted` e closure già scritte restano valide, nessun backfill.
  Solo se il PM lo chiede, proponi una voce per le consegne recenti mai
  comunicate.
- **Già a posto se**: sempre.

### 2026-10-12-scrivere-per-il-lettore · I PRD si scrivono per il loro lettore

- **Impatto**: setup
- **Cosa cambia**: brief d'iniziativa, `primary_reader`/`prd_kind` nel
  frontmatter, registro dei punti chiave (`source/key-points.yaml`),
  allegato dati, lettura a freddo, glossario — playbook, "Scrivere per
  il lettore". Commit `d29888b`.
- **Cosa fare nell'istanza**: i campi nuovi sono opzionali, i PRD
  esistenti restano validi.
  1. se manca `product/reference/glossary.yaml`, proponi di crearlo
     vuoto dal template;
  2. per i PRD `draft`/`in_review` che saranno letti fuori dalla
     sessione, proponi `prd-draft {slug} retrofit`. Non toccare i PRD
     `approved`/`superseded`.
- **Già a posto se**: esiste `product/reference/glossary.yaml`.

### 2026-09-10-tech-reference · Il referente tecnico emerge durante la stesura

- **Impatto**: nessuna
- **Cosa cambia**: `tech_reference` sull'idea e nel frontmatter del PRD,
  ipotizzato all'intake e fissato da `prd-draft`/`team-fit`. Commit
  `bbe9c66`.
- **Cosa fare nell'istanza**: niente; si popola alla prossima revisione
  dei PRD. Richiede `team.yaml` popolato (voce `2026-09-10-team-fit`).
- **Già a posto se**: sempre.

### 2026-09-10-team-fit · Anagrafica del team e proposta di staffing per un PRD

- **Impatto**: setup
- **Cosa cambia**: `product/reference/team.yaml` (chi c'è, cosa presidia,
  competenze), skill `team-roster` e `team-fit`. Commit `7444c83`.
- **Cosa fare nell'istanza**: proponi `team-roster` per popolarlo.
- **Già a posto se**: esiste `product/reference/team.yaml` con
  `members` non vuoto.

### 2026-09-07-delivery-watch · Monitoraggio delle transizioni di delivery

- **Impatto**: setup
- **Cosa cambia**: `delivery-watch` osserva il tracker e mette i
  movimenti delle card in una coda di triage
  (`product/reference/delivery-watch.yaml`) con le bozze per gli
  stakeholder; blocco `delivery_watch:` in config. Commit `ab8d61e`.
- **Cosa fare nell'istanza**: richiede `jira.configured: true`. Chiedi
  al PM se attivarlo e raccogli i campi del blocco
  (`init-governance-project`, passo 6). Nessun tool nuovo da
  allowlistare.
- **Già a posto se**: `jira.configured` non è `true`, oppure la config
  ha un blocco `delivery_watch:`.

### 2026-09-05-contesto-da-cartelle · Contesto aziendale da cartelle documentali collegate

- **Impatto**: setup
- **Cosa cambia**: voci `connectors:` con `folders:` (Drive,
  OneDrive/SharePoint, Confluence) da cui `context-intake` e
  `context-watch` pescano in sola lettura; stato in
  `context/.sources-seen.yaml`; cambiamenti materiali in `pending/`
  (`type: context_update`). Commit `5aecd40`, `e1473e0`.
- **Cosa fare nell'istanza**: chiedi quali cartelle condivise usa il
  team (`init-governance-project`, passo 9), registra le voci e
  allowlista **solo** i tool di lettura/elenco di ciascun connettore.
- **Già a posto se**: il PM ha detto che non ne usa, oppure la config
  ha almeno una voce `connectors:` con `folders:`.

### 2026-09-04-bug-filing-immediato · Un bug confermato si apre subito sul tracker

- **Impatto**: setup
- **Cosa cambia**: il ticket di un bug si apre appena il PM conferma la
  classificazione, senza secondo assenso; i tool del connettore vanno
  pre-autorizzati in `.claude/settings.local.json` (non tracciato).
  Commit `5450302`.
- **Cosa fare nell'istanza**: scrivi le allow entries del connettore
  dichiarato (ricerca/lettura + creazione ticket —
  `init-governance-project`, punto 7), mostrandole prima al PM. Ogni
  collega che clona lo rigenera.
- **Già a posto se**: `jira.integration` è `manuale`/vuoto, oppure
  `.claude/settings.local.json` contiene i tool del connettore.

### 2026-09-03-connettori · Connettori dichiarati, verificati a inizio processo

- **Impatto**: setup
- **Cosa cambia**: blocco `metrics:` e lista `connectors:` in config,
  campi `probe`/`reauth`; le skill verificano il connettore a inizio
  processo; l'hook `check-connectors.sh` mostra i comandi di ri-login.
  Commit `e4b32bd`…`b70f260`.
- **Cosa fare nell'istanza**: per ogni connettore già dichiarato
  aggiungi `probe` e `reauth` (chiedi se il login scade a ogni
  sessione); se c'è una fonte metriche programmatica, dichiarala in
  `metrics:` (`init-governance-project`, passo 7).
- **Già a posto se**: ogni connettore programmatico in config ha
  `probe` e `reauth` valorizzati.

### 2026-09-03-reach-1-10 · Reach del RICE passa da percentuale 0-100 a banda 1-10

- **Impatto**: migrazione-meccanica
- **Cosa cambia**: Reach si esprime su scala intera 1-10 come gli altri
  fattori. Commit `0ecf136`.
- **Cosa fare nell'istanza**: per **ogni** voce di `rice_history` di
  **ogni** idea con `reach_percent` valorizzato:
  - `reach_points = max(1, ceil(reach_percent / 10))`;
  - `score` ricalcolato = `reach_points * impact_points *
    confidence_score / entanglement_score`;
  - il vecchio valore va in `reach_absolute_note` (prependi
    "≈{reach_percent}% della popolazione → {reach_points}" se la nota ha
    già contenuto), poi rimuovi la chiave `reach_percent` (o lasciala a
    `null` — deprecata nello schema).
  Applicabile **su conferma esplicita**, idea per idea, un unico commit
  (`sync-framework-updates: migrazione Reach %→1-10`), poi
  `governance-sync.sh push`. Non passa da `pending/`: è un riscalamento
  di formato, non una revisione di priorità. Mostra la tabella prima/dopo
  degli `score`: qualche ranking può spostarsi ai confini di banda, è
  atteso.
- **Già a posto se**: nessuna voce di `rice_history` ha `reach_percent`
  valorizzato.

### 2026-09-03-short-ref-prefix · Il prefisso degli handle di governance è distinto dalla project key

- **Impatto**: migrazione
- **Cosa cambia**: `short_ref_prefix` non può coincidere con
  `jira.project_key`. Commit `2933d14`.
- **Cosa fare nell'istanza**: se `short_ref_prefix` (o il default `PG`)
  è uguale (case-insensitive) a `jira.project_key`, serve un
  rinominamento una-tantum degli `short_ref` già assegnati: manuale
  (`grep -rl` su `product/`, titoli dei PRD, note; i titoli delle card
  Jira a mano). Proponilo, non farlo tu.
- **Già a posto se**: i due valori sono diversi.

### 2026-09-03-piano-di-iterazione · Il Piano di Iterazione è l'output primario del Backlog Refinement

- **Impatto**: nessuna
- **Cosa cambia**: board a quattro bucket in
  `product/roadmap/iterations/{YYYY-Www}.yaml`, via `pending/` (`type:
  iteration_plan`); lo snapshot lo referenzia; skill `iteration-board`.
  Commit `fbfeacf`…`3ce3555`.
- **Cosa fare nell'istanza**: crea `product/roadmap/iterations/` (con
  `.gitkeep`) se manca; il primo piano esce dal prossimo Backlog
  Refinement.
- **Già a posto se**: esiste `product/roadmap/iterations/`.

### 2026-09-03-lettura-in-blocco · Cerimonie più rapide: sweep in un passaggio e lettura in blocco

- **Impatto**: nessuna
- **Cosa cambia**: `governance-dump.sh` legge lo stato in una tool call;
  la sweep di apertura calcola le watch inline e scrive un solo commit;
  checkpoint interattivo dopo ogni passo della cerimonia; elenchi
  numerati e indirizzabili. Commit `457ddc3`…`4a8738a`, `9319844`,
  `3a3970d`.
- **Cosa fare nell'istanza**: niente.
- **Già a posto se**: sempre.

### 2026-09-02-demo-capture · Evidenza visiva di delivery dal codice reale

- **Impatto**: setup
- **Cosa cambia**: `demo-capture` cattura screenshot dei flussi toccati
  da un'iniziativa; recipe per app in `product/demos/recipes/`, manifest
  tracciati, screenshot esclusi da git. Commit `1bb7038`.
- **Cosa fare nell'istanza**: crea `product/demos/recipes/` e
  `product/demos/captures/` se mancano; la recipe la scaffolda la skill
  al primo uso.
- **Già a posto se**: esiste `product/demos/`.

### 2026-09-02-jira-dedup · jira-sync con dedup e connettore MCP ufficiale

- **Impatto**: setup
- **Cosa cambia**: blocco `jira:` strutturato in config
  (`integration`, `cloud_id`…), dedup JQL prima di creare un ticket,
  Atlassian Remote MCP come connettore consigliato. Commit `9320150`.
- **Cosa fare nell'istanza**: se il tracker è Jira e non c'è accesso
  programmatico, proponi il Remote MCP
  (`init-governance-project`, passo 6) e completa il blocco `jira:`.
- **Già a posto se**: la config ha `jira.integration` valorizzato.

### 2026-09-02-cerimonie-dry-run-rollback · Skill dedicate per le cerimonie, dry-run, rollback, short_ref

- **Impatto**: nessuna
- **Cosa cambia**: `backlog-refinement` e `iteration-planning` come punti
  d'ingresso, `.run-meta.yaml` per ogni run, modalità dry-run
  (`dry_run: true` in config per un'istanza di training),
  `rollback-ceremony`, handle `short_ref` assegnato al primo refinement.
  Commit `8253b29`, `1a89c0d`, `0190b2e`, `edd9ff4`.
- **Cosa fare nell'istanza**: niente; gli `short_ref` li assegna il
  prossimo `backlog-refinement` alle idee che non li hanno.
- **Già a posto se**: sempre.

### 2026-09-01-chiudere-il-loop · Scarti motivati, bozze di risposta, meeting di approfondimento

- **Impatto**: setup
- **Cosa cambia**: campi opzionali `summary`, `notes`,
  `requester_reply`, `rice_status.deep_dive`, `status: declined`; vista
  `backlog-list`. Commit `5ceec49`.
- **Cosa fare nell'istanza**: le idee vecchie restano valide senza i
  campi nuovi. L'unico con valore a essere backfillato è `summary` (una
  riga per idea ancora attiva), perché `backlog-list` lo mostra —
  proponilo come lavoretto incrementale, non un blocco.
- **Già a posto se**: ogni idea attiva ha `summary` valorizzato.

### 2026-09-01-target-annuale · Target annuale di riferimento per l'Impact

- **Impatto**: setup
- **Cosa cambia**: `product/reference/annual-target.yaml` converte un
  valore economico assoluto in punti Impact. Commit `260ca05`.
- **Cosa fare nell'istanza**: proponi di crearlo dal template
  raccogliendo l'**incremento** annuo atteso, non il totale a budget.
  Finché manca, ogni Impact resta un'approssimazione qualitativa — dillo,
  senza bloccare.
- **Già a posto se**: esiste `product/reference/annual-target.yaml`.

### 2026-09-01-scadenze-su-idee · Scadenze su idee normali (deadline-watch)

- **Impatto**: nessuna
- **Cosa cambia**: blocco `deadline` sulle idee non mandatarie e skill
  `deadline-watch`. Commit `4ab7627`.
- **Cosa fare nell'istanza**: niente; le scadenze si catturano quando il
  PM le dichiara.
- **Già a posto se**: sempre.

### 2026-09-01-sync-con-origin · Sincronizzazione automatica dell'istanza con origin

- **Impatto**: setup
- **Cosa cambia**: ogni skill fa `pull --ff-only` prima di leggere e
  `commit + push` dopo aver scritto (`governance-sync.sh`); blocco
  `sync:` in config. Commit `6b0f50b`.
- **Cosa fare nell'istanza**: aggiungi il blocco `sync:` (default
  `auto_pull`/`auto_push` `true`) e chiedi al PM se vuole spegnere un
  lato.
- **Già a posto se**: la config ha un blocco `sync:`.

### 2026-09-01-rice-entanglement · La "E" del RICE passa da Effort a Entanglement

- **Impatto**: migrazione
- **Cosa cambia**: la "E" è passata da `effort_weeks` (settimane) a
  `entanglement_score` (footprint del cambiamento, 1-10). Commit
  `b005fce`.
- **Cosa fare nell'istanza**: le voci `rice_history` esistenti hanno la
  vecchia semantica e i loro `score` sono calcolati con la vecchia
  formula: restano valide come storico ma non confrontabili 1:1 con le
  nuove. Proponi (senza applicarlo) di ricalcolare l'Entanglement — via
  `rice-update`, con la sua coda di approvazione — per le idee ancora
  attive, lasciando intatte quelle chiuse. Segnala anche
  `delivery.estimated_effort_weeks`, che si popola in Iteration Planning.
- **Già a posto se**: nessuna idea attiva ha come ultima voce di
  `rice_history` una con `effort_weeks` e senza `entanglement_score`.

### 2026-08-14-contesto-aziendale · Contesto aziendale in context/

- **Impatto**: setup
- **Cosa cambia**: `context/` alla radice (tracciata) e skill
  `context-intake` che trascrive il materiale grezzo con citazione della
  fonte. Commit `ae91851`.
- **Cosa fare nell'istanza**: crea `context/` (con `.gitkeep`) se manca
  e chiedi al PM se ha materiale da trascrivere.
- **Già a posto se**: esiste `context/`.
