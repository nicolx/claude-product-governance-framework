---
name: backlog-refinement
description: Conduce e registra il Product Backlog Refinement settimanale — si apre "guardando indietro" (NSM, impatti, scadenze, idee senza RICE, aggiornamenti del contesto aziendale via context-watch), svuota la coda di approvazione RICE, presenta il backlog ordinato come base della prioritizzazione, compone il Piano di Iterazione della settimana (la board a quattro bucket, output primario, proposto in pending/) rilevando le reprioritizzazioni fuori-RICE e verificando con un capacity check che stia nella capacità reale del team per competenza, poi delega a log-ceremony per la registrazione. Punto d'ingresso dedicato: fissa ceremony_type e periodo. Usala per la cerimonia settimanale di team.
---

# backlog-refinement

Punto d'ingresso per il **Product Backlog Refinement** (playbook, sezione
omonima). Esiste perché questa cerimonia ha un `ceremony_type` e una
cadenza fissi (settimanale): averla come skill a sé evita di doverli
rispecificare ogni volta e tiene insieme, in un unico posto, la sequenza
"si apre guardando indietro, poi si prioritizza".

> **Dry-run.** Se l'utente chiede la simulazione (`dry-run`, "simula la
> cerimonia"), propaga l'argomento a `log-ceremony` e `pending-approval`:
> nessuna scrittura (nemmeno l'assegnazione di `short_ref`, nessuna
> approvazione applicata, nessuna proposta `iteration_plan` scritta in
> `pending/`, **nessuna azione di checkpoint applicata** — archiviazioni,
> pulizie di scadenza, `closure` restano mostrate come testo), nessun
> commit, chiusura con `🔍 DRY-RUN`. Vedi playbook, "Modalità dry-run
> (simulazione)". `governance-dump.sh` gira comunque (è sola lettura), e
> la riconciliazione Jira in background è comunque sola lettura;
> `delivery-watch` in dry-run legge e classifica ma non scrive la coda né
> crea idee di backfill. In
> dry-run i checkpoint del passo 2 si eseguono comunque (mostri le
> tabelle, raccogli i commenti del PM, dici cosa *scriveresti* al commit
> unico di fine sweep). Al passo 3 elenca comunque cosa c'è in coda,
> al passo 5 mostra sia il ranking ufficiale sia quello che risulterebbe
> approvando le proposte in `pending/`, e al passo 6 mostra comunque per
> intero la board a quattro bucket del Piano di Iterazione che *avresti*
> proposto, incluso il diff `changes_since_last` da `based_on` — è la
> parte più utile della simulazione. Se il run è già stato fatto per
> errore senza dry-run: `rollback-ceremony`.

## Cosa fa

Registra la cerimonia tramite `log-ceremony` con `ceremony_type:
backlog-refinement` (fisso) e `periodo` = settimana ISO corrente
(`YYYY-Www`), salvo l'utente indichi una settimana diversa. Segue tutti i
passi comuni di `log-ceremony` (cattura `base_sha`, cartella cerimonia,
`.run-meta.yaml`, `source/`, `decisions.yaml`, "proponi non applicare",
sincronizzazione) e, in aggiunta, i passi specifici di questa cerimonia
descritti sotto.

La cerimonia non si limita a **registrare** cosa il team ha deciso: gli
mette davanti le **opzioni** da cui decidere. Un backlog ordinato che
nessuno vede — perché gli score sono fermi in `product/approvals/pending/`
— non serve a prioritizzare. Per questo i passi 3 e 5 svuotano la coda di
approvazione e presentano la lista ordinata, prima che si discuta cosa
entra in iterazione.

**L'output primario della cerimonia è il Piano di Iterazione** (passo 6):
`product/roadmap/iterations/{settimana}.yaml`, la board team-facing a
quattro bucket costruita come diff dal piano della settimana precedente.
Senza, la cerimonia registra decisioni e segnalazioni ma non lascia in
mano al team il documento su cui lavora nei giorni successivi — vedi
playbook, "Product Backlog Refinement". Come lo snapshot di roadmap, il
piano passa **sempre** da `product/approvals/pending/`
(`type: iteration_plan`) e non viene applicato nella camminata.

## Passi specifici del Backlog Refinement

1. **Sincronizza da `origin`** — **un solo** `governance-sync.sh pull`
   per l'intera sweep (non uno per watch), prima di leggere lo stato.

2. **Apri "guardando indietro", non avanti** (playbook: "la riunione si
   apre guardando indietro") — la sweep di apertura, **in un solo
   passaggio**. Questa cerimonia blocca il tempo di molte persone in
   riunione: la sweep dev'essere *calcolo*, non attesa di I/O. **Non
   invocare le watch come skill separate** — ognuna rifarebbe `pull` +
   glob di tutte le `idea.yaml` + scritture + `push`, e le stesse idee
   verrebbero lette 3-4 volte. Invece:

   a. **Verifica i connettori esterni dichiarati** (playbook, "Connettori
      esterni: dichiarati, verificati a inizio processo, mai un fallback
      silenzioso") — *prima* di entrare nella sweep, con il `probe`
      dichiarato, così `nsm-watch`/`measurement-watch` inline non scoprono
      il guasto a metà. L'hook `check-connectors.sh` a inizio sessione ha
      già mostrato i comandi `reauth`:
      - **`metrics`** (`mcp:*`/`cli:*`): se dichiarato ma irraggiungibile,
        applica la regola del playbook — segnala, proponi il comando
        `metrics.reauth` dichiarato in config, chiedi al PM. Se si
        procede, le letture NSM/KPI del run le dà il PM a mano e i punti
        "lettura automatica saltata" vanno nel riepilogo come
        **rimandati** (insieme al giro di `path-watch`). Se risponde e
        `metrics.paths.enabled` non è `false`, **lancia come task in
        background** `path-watch` in modalità **solo-calcolo** sulle idee
        attive (catalogo analytics + `apps/` → path da applicare,
        promuovere, segnalare rotti, con le baseline): restituisce le
        scritture proposte e **non tocca i file** — le applica il punto f,
        nel commit unico. `manuale`/`configured: false` → nessun giro di
        path, senza rumore.
      - **`jira`** (`atlassian-mcp`/`cli:*`): idem. Se risponde, **lancia
        come task in background** (a) la riconciliazione Jira (`jira-sync`
        modalità Riconciliazione — idee mai passate dal RICE il cui lavoro
        è già partito in Jira) e (b), se `delivery_watch.enabled`,
        `delivery-watch` in modalità detect (transizioni di delivery da
        comunicare agli stakeholder + backfill di card non collegate).
        Prosegui subito con la sweep locale: ne raccogli l'esito al punto
        e. Se `jira.integration` è `manuale`/vuoto, salta la
        riconciliazione **senza rumore** (scelta di setup). Se dichiarato
        ma irraggiungibile e il PM sceglie di proseguire, riconciliazione
        e `delivery-watch` restano **rimandati** nel riepilogo, mai
        completati o non applicabili.

   b. **Un solo** `bash .claude/hooks/governance-dump.sh sweep` → tutto lo
      stato rilevante (idee attive, misurazioni, NSM, denominatori,
      target annuale, piani di iterazione, coda `pending/`) in un unico
      tool result.

   c. **Calcola inline, dal dump**, la logica di ogni watch — è aritmetica
      di date e soglie, non serve invocare la skill. **In quest'ordine:**
      1. `nsm-watch` — per prima, è il segnale più strategico: trend delle
         NSM dalle `readings` in `nsm-tracking.yaml`, `alert.status`.
      2. `measurement-watch` — KPI `check_due`/`at_risk`/`invalidated`
         delle iniziative `status: done` con `closure.closed: false`.
      3. `mandate-watch` — `escalation_status` dei `classification: mandate`
         da `analysis_start_by` vs oggi.
      4. `deadline-watch` — `escalation_status` delle idee con
         `deadline.due_date`; **push forte** a ≤ 4 settimane, non una riga
         tra le altre.
      5. `rice-watch` — idee `classification: idea` con `rice_history`
         vuoto: `stale`, `blocked_on`, `needs_deep_dive`.
      6. **Avvisi di conclusione in sospeso** — voci di
         `conclusion_notices` con `notice_status` `pending`/`drafted`:
         consegne, chiusure di misurazione e interruzioni **rilevate ma
         non ancora comunicate** (l'idea non è ancora `done`/`aborted`,
         la `closure` non è ancora scritta). Colonne: ID, `kind`, da
         quanti giorni (`detected_at`), destinatari. Al checkpoint il PM
         può dichiararne l'invio (`sent`) o esentarle con un motivo
         (`waived`) — e solo allora si scrive il cambio di stato
         corrispondente. Playbook, "Avvisare gli stakeholder della
         conclusione".
      7. **Risposte ai richiedenti in sospeso** — voci di
         `requester_reply` e `followup_replies` con `reply_status:
         drafted` (dal dump: idee attive + scarti `declined`/`aborted`
         con una risposta non inviata): bozze preparate all'intake e mai
         mandate, il richiedente è ancora al buio. Colonne: ID, `kind`,
         destinatari, da quanti giorni (`created_at` o `received_at`).
         Al checkpoint il PM le dichiara inviate (`reply_status: sent` +
         `sent_at`) o esentate con un motivo suo (`waived` +
         `waived_reason`). Se una bozza è invecchiata (lo stato dell'idea
         è cambiato da allora), proponi di aggiornarne il testo prima
         dell'invio. Playbook, "Chiudere il loop col richiedente".
      8. **Path da monitorare** (solo se il task `path-watch` del punto a
         è partito; lo raccogli qui, non al punto e) — il recap di
         `path-watch` passo 6: idee senza path, path applicati in questo
         giro con la baseline, **da strumentare** (in evidenza quelli su
         idee `in_development`: gli eventi vanno aggiunti in questa
         iterazione), promossi, **rotti**, KPI collegabili a un path,
         modifiche previste nello strumento (in evidenza quelle su
         oggetti creati da altri), e il **link alla dashboard di ogni
         Product Line** con i grafici che entrano/escono — è il quadro da
         tenere aperto durante la discussione delle priorità. I path e le modifiche reversibili si
         applicano senza conferma (playbook, "Path da monitorare"): al
         checkpoint il PM può toglierne uno ("togli il path {id} da {ID}"
         → `status: removed` + `removed_reason` chiesto a lui) e **deve
         confermare una per una le modifiche irreversibili** proposte
         (cosa cambia, cosa si perde, chi ne è toccato) — quelle non
         confermate non si eseguono al punto f.
      9. **Viste in scadenza** — dalle viste dichiarate in
         `product/reference/reporting-models.yaml` e dall'indice
         "ultimo report per vista" in fondo al dump: quelle con `cadence`
         diversa da `on_demand` e da `per_ceremony` senza un report per il
         periodo corrente. Colonne: `name`, modello, pubblico, ultimo
         periodo generato. Solo segnalazione: la generazione è un passo
         separato **dopo** la cerimonia (`report-render`, sui dati appena
         approvati), non qui. Le viste `per_ceremony` (la roadmap
         aggiornata) non si elencano: le rigenera `log-ceremony` in
         chiusura. Se nessuna vista è `per_ceremony`, una riga: *"la
         roadmap non si aggiorna da sola a fine cerimonia — `report-render`
         setup per dichiararne una"*. Se il file non esiste, una riga:
         *"nessun modello di reporting dichiarato — `report-render` in
         modalità setup"* (playbook, "Modelli di reporting").
      Le **formule sono quelle documentate nelle rispettive skill**
      (`nsm-watch`, `measurement-watch`, `mandate-watch`, `deadline-watch`,
      `rice-watch`, `path-watch`) — applicale, non reinventarle; se un caso
      è ambiguo apri quella skill.

   d. **Checkpoint dopo ogni blocco (diritto di parola).** Non calcolare
      tutti i blocchi e poi chiedere: dopo *ciascuno*, prima del
      successivo —
      1. mostra la sua tabella con l'**identificatore in prima colonna**
         (playbook, "Ogni elenco prodotto dal sistema è indirizzabile") e,
         per ogni riga che riguarda un'idea, subito dopo `summary`,
         R · I · C · E e RICE totale ("—" + motivo se senza RICE —
         playbook, "Ogni riga che parla di un'idea si capisce da sola");
      2. chiedi esplicitamente: *"Prima di procedere — vuoi commentare o
         agire su una di queste voci? Puoi riferirti a {ID}."* Azioni
         tipiche (playbook, "Diritto di parola dopo ogni passo"):
         archiviare un'idea che non serve più (`status: declined` +
         `decline_reason`, o `status: aborted` se era in lavorazione —
         **solo con conferma esplicita del PM**; per `aborted` vale il
         gate dell'avviso di conclusione: bozza in `conclusion_notices`
         `kind: aborted` — perché ci si ferma e cosa succede alla
         richiesta — e `status: aborted` solo se il PM la dichiara `sent`
         o la esenta con un motivo suo, altrimenti resta `drafted` e
         l'idea nel suo stato; playbook, "Avvisare gli stakeholder della
         conclusione"); svuotare una `deadline`
         non più rilevante; chiudere una misurazione (`closure`) o un
         allarme NSM (`alert.status: resolved`); annotare `notes`;
         dichiarare inviata o esentare una risposta a un richiedente
         (`reply_status: sent`/`waived`);
         rimandare una revisione di RICE a `rice-update` (che passa da
         `pending/`). Se non c'è nulla, un "procedi" e si va avanti;
      3. **accumula** le azioni concordate — non scrivere ancora: la
         scrittura è unica, al punto f.
      Le domande *interne* delle watch (deep-dive di `rice`, discovery
      focus di `nsm`, escalation forte di `deadline`, chiusura misurazioni
      di `measurement`) restano: falle inline qui, con le stesse regole
      garantiste. Sono cattura di contesto che serve alla watch; il
      checkpoint è il momento uniforme *in più*.

   e. **Raccogli** l'esito dei task in background lanciati al punto a: la
      riconciliazione Jira e, se attivo, `delivery-watch` (nuovi eventi
      accodati, idee create per backfill, coda `pending` totale).

   f. **Una sola scrittura, un solo commit.** Applica *tutti* i valori
      calcolati (`escalation_status`, `rice_status.*`, `alert.*`,
      `closure`, i blocchi `monitoring` e gli `analytics_dashboard`
      restituiti da `path-watch`) e *tutte* le azioni di checkpoint
      concordate. Le scritture di `path-watch` **nello strumento di
      analytics** (path e dashboard per Product Line) si eseguono qui,
      *prima* di scrivere `idea.yaml`/`product-lines.yaml`, perché id e
      stato precedente finiscono in `analytics_ref`/`analytics_changes`/
      `analytics_dashboard.changes`; la dashboard si riallinea **dopo**
      i path di quella linea, sui path finali: le **reversibili**
      direttamente, le **irreversibili** solo quelle che il PM ha
      confermato una per una al checkpoint del blocco 8 (le altre restano
      proposte nel recap); quelle fallite restano nel recap. Poi:
      `bash .claude/hooks/governance-sync.sh push "backlog-refinement: sweep di apertura <settimana>" product/`.
      Un commit per l'intera sweep, non uno per watch né uno per
      checkpoint.

   g. **Contesto: `context-watch`.** Se `.governance/config.yaml` ha
      almeno un connettore sorgente di contesto (`connectors:` con
      `folders:`), richiama `context-watch` — riusa il `pull` già fatto al
      punto 1. Applica gli **aggiornamenti di routine** (via
      `context-intake`) e accoda i **cambiamenti materiali** in
      `product/approvals/pending/` (`type: context_update`). Questo tocca
      `context/` e `product/approvals/`, **non** le `idea.yaml`: il suo
      commit è **distinto** da quello del punto f (helper con messaggio
      `context-watch: …`), non lo si accorpa. Il **recap** (routine
      applicati / materiali in coda / connettori rimandati) entra nel
      riepilogo della sweep. Se non ci sono connettori di contesto, salta
      senza rumore.

   h. **Delivery: `delivery-watch`.** Se `.governance/config.yaml` ha
      `jira.configured: true` e `delivery_watch.enabled: true`, raccogli
      il recap del task lanciato al punto a (eventi accodati, backfill,
      coda). `delivery-watch` scrive `product/reference/delivery-watch.yaml`
      e le eventuali idee di backfill, con un **commit distinto** (helper
      con messaggio `delivery-watch: …`) — non lo si accorpa a quello
      della sweep del punto f. Il recap (eventi nuovi / coda `pending` /
      backfill da rivedere / rimandato) entra nel riepilogo. La
      **camminata della coda di triage** non si fa qui: è un'azione
      separata del PM dopo la cerimonia. Se `delivery_watch` non è
      attivo, salta senza rumore.

   i. **Passa a `log-ceremony`** i riepiloghi consolidati (un blocco per
      watch, **più** il recap di `context-watch`, quello di
      `delivery-watch` e quello di `path-watch`), le azioni di checkpoint (una `decision`
      ciascuna, con `impacts.idea_ids`), e l'esito della riconciliazione
      Jira.

3. **Svuota la coda di approvazione — prima di guardare il backlog.**
   Elenca `product/approvals/pending/` (usa `pending-approval`, sezione
   "Elenco"): quando ci sono più voci verso un'idea, come **tabella** con
   le colonne descritte lì — identificativo idea (`short_ref` o `id`),
   `summary`, tipo, score proposto (col delta vs. quello corrente),
   scadenza con `escalation_status`, e la colonna **Bypass** che segnala
   le Strategic Exception *dichiarate ma non ancora approvate* e le
   iniziative mandatarie. I `rice_diff` in particolare: finché non sono
   approvati, i loro score non esistono per `backlog-list`, e la
   prioritizzazione al passo 6 gira su un ranking incompleto. **Cammina la
   coda con il PM / il team, voce per voce**: per ciascuna, il PM decide
   approva / rifiuta / rimanda (con motivo), e tu applichi la decisione
   via `pending-approval` (Approvazione o Rifiuto). Questo è il luogo previsto
   per rivedere i RICE — l'approvazione sollecitata qui **è** istruzione
   esplicita, resa voce per voce.
   - Per un **primo scoring di un intake storico bulk** (decine di
     proposte coerenti, tutte prima quotazione — playbook, "Intake
     storico e roadmap pre-esistente"), il PM può approvarle in blocco su
     sua esplicita indicazione ("approva tutte queste del batch del
     {data}, rivediamo insieme solo le N dubbie") — `pending-approval` le
     esegue comunque una per una, con log distinto.
   - Registra in `decisions.yaml` (via `log-ceremony`, campo
     `approvals_reviewed`) quali voci sono state approvate / rifiutate /
     rimandate in questa cerimonia.
   - Le proposte lasciate in coda vanno segnalate nel riepilogo finale —
     una coda che sopravvive alla cerimonia è un debito da rendere
     visibile, non da ignorare.

4. **Assegna `short_ref` alle idee che ne sono prive.** Per ogni idea in
   `product/ideas/*/idea.yaml` con `short_ref: null`, assegna il prossimo
   handle: `{prefisso}-{NNN}` dove `NNN = max(numeri short_ref esistenti
   in tutte le idee) + 1`, zero-padded a 3 cifre (parti da `001` se non
   ce n'è nessuno). Prefisso: `short_ref_prefix` da
   `.governance/config.yaml`, o `PG` se assente.
   - **Guard anti-collisione.** Se il prefisso risolto coincide
     (case-insensitive) con `jira.project_key` in `.governance/config.yaml`,
     **fermati e non assegnare**: i due namespace si confonderebbero
     (`{sigla}-42` idea vs. ticket — vedi playbook, "Ogni elenco prodotto
     dal sistema è indirizzabile", e `init-governance-project`). Segnala
     la collisione al PM e chiedi di correggere `short_ref_prefix` in
     config prima di procedere. Le idee restano senza handle per questo
     run — non è un errore bloccante per il resto della cerimonia. Il Backlog Refinement è
   il punto di serializzazione a scrittore singolo per cui questo non
   collide (hai appena fatto `pull` al passo 1). È un fatto di
   housekeeping — scrittura **diretta** su `idea.yaml`, non passa da
   `pending/` — e una volta assegnato non cambia più. Sincronizza subito
   queste scritture (non aspettare il commit finale della cerimonia):
   `bash .claude/hooks/governance-sync.sh push "backlog-refinement: assegnati short_ref" product/ideas/`.
   Non toccare le idee che un `short_ref` ce l'hanno già.

5. **Presenta il backlog ordinato — è la base della prioritizzazione.**
   Richiama `backlog-list` e mostra la sua vista: idee `classification:
   idea` ordinate per RICE score, iniziative fuori-RICE ancora aperte,
   idee senza RICE. Questa **non** è una formalità: è il materiale su cui
   il team decide cosa entra nell'iterazione — senza, la cerimonia
   registra decisioni senza aver mai mostrato le opzioni. Se dopo il
   passo 3 restano ancora proposte in `pending/` non approvate,
   `backlog-list` lo evidenzia (sezione "Proposte RICE non ancora
   approvate") — tienilo presente al passo 6.

6. **Componi il Piano di Iterazione, partendo da quello della settimana
   precedente.** È l'output primario della cerimonia
   (`framework/schema/iteration-plan.template.yaml`). Non scrivere mai il
   file direttamente: si genera una proposta `type: iteration_plan` in
   `pending/` (passo 6.7).

   1. **Carica il piano precedente.** Cerca il file di iterazione più
      recente in `product/roadmap/iterations/` con settimana `<` quella
      corrente → è `based_on`. Se non ne esiste nessuno (primo run
      dell'istanza): `based_on: null`, e costruisci i bucket dallo stato
      corrente — idee `status: in_analysis` → `analysis_in_progress`;
      idee con `jira.card_id` e stato dev attivo → `in_development`.
   2. **Riconcilia ogni voce del piano precedente con lo stato attuale**
      e popola `changes_since_last`:
      - idea ora `status: done` → `completed`, non riportarla nei bucket;
      - idea avanzata di stato (analisi → dev) → spostala di bucket,
        `carried_from` = settimana precedente, registrala in `advanced`;
      - idea ferma allo stesso punto → carry-over nel suo bucket,
        incrementa `weeks_in_bucket`; se supera una soglia indicativa di
        **3 iterazioni** senza avanzare, mettila in `slipped` e segnalala
        esplicitamente al PM (non annegarla nel riepilogo);
      - idea non più pertinente che il team decide di togliere →
        `dropped` con `reason`.
   3. **Presenta al PM la board carried-over** — i quattro bucket più il
      diff — prima di chiedere le aggiunte. Per ogni voce mostra il
      `tech_reference` (referente tecnico) accanto al `summary`; se una
      voce con un PRD non ce l'ha, segnalalo come gap (rimanda a
      `team-fit {slug}`).
   4. **Chiedi le aggiunte, bucket per bucket:**
      - `analysis_todo`: *dal ranking RICE del passo 5, quali idee
        `classification: idea` iniziano l'analisi questa settimana?* —
        **è la domanda centrale della riunione**, non una formalità. Per
        ciascuna registra `why_now`.
      - `in_development`: card nuove emerse nella riconciliazione Jira
        (passo 2, punto a) e non ancora nel piano.
      - `urgent_priority`: **questo assorbe il vecchio "rileva le
        reprioritizzazioni fuori-RICE".** Sono le iniziative
        `classification: idea` che entrano nell'iterazione **davanti a
        idee con RICE score più alto** ancora in backlog (dal ranking del
        passo 5), più le idee con `deadline`/`mandate` a `due_soon`/
        `overdue` che il team decide di forzare in analisi adesso. Per
        ciascuna, chiedi esplicitamente al PM se è una **Strategic
        Exception** (bypass autorizzato da uno stakeholder) o una
        **scelta qualitativa del team** dentro il processo normale:
        - se **Strategic Exception**: voce `urgent_priority` con
          `kind: strategic_exception`, `approved_by` **mai presunto**, e
          **in più** genera una proposta `strategic_exception_flag` in
          `pending/` (append a `strategic_exceptions` dell'idea +
          `pending-approval` aggiunge la riga a
          `product/reference/friction-log.yaml`) — esattamente come prima
          dell'introduzione del piano. È così che il framework intercetta
          il pattern "stessa persona che bypassa la priorità ogni
          settimana" (playbook, "Come gestire le frizioni" — Scenario 2);
        - se **scelta qualitativa del team**: la voce resta solo nel
          piano (`urgent_priority` o `analysis_todo` con `why_now`), e in
          `decisions.yaml` come `reprioritization` con
          `reason_type: qualitative_team_call` — nessuna proposta
          `strategic_exception_flag`.
   5. **Chiedi il `iteration_goal`** — una frase: focus della settimana /
      iniziativa o metrica che si cerca di impattare.
   6. **Capacity check, poi il PM conferma la board finale.** Prima della
      conferma, calcola `capacity_check` del piano (template, e playbook,
      "Capacità del team e slot della roadmap"): offerta della settimana
      per competenza da `product/reference/team.yaml`, domanda = carichi
      settimanali (`effort_by_competency` / `estimated_effort_weeks`,
      `delivery` o `platform`) delle voci che consumano capacità di
      sviluppo questa settimana — `in_development`, `urgent_priority` che
      entra in sviluppo, platform in lavorazione. Mostra la tabella
      competenza → offerta / domanda / saturazione, con le voci senza
      stima (`undimensioned`) e i membri senza `fte` (`unsized_members`):
      il check è parziale finché restano, dillo. Se `team.yaml` non ha
      dati di capacità, `basis: not_available` — segnalalo e rimanda a
      `team-roster`, non bloccare la cerimonia.
      Se una competenza è `over`, **non procedere in silenzio**: chiedi
      al PM se riequilibrare (spostare/togliere voci — torni ai punti
      sopra) o accettare lo sforamento. Se lo accetta, registra in
      `over_capacity_decision` motivazione e `decided_by` (**mai
      presunti**) e la stessa decisione in `decisions.yaml`
      (`capacity_overrides`). Se una competenza è satura e qualcuno la ha in
      `can_also`, proponilo come opzione — non riassegnare nessuno.
      Poi il PM conferma la board finale.

   Per ogni voce di **tutti e quattro** i bucket, popola `summary`,
   `rice_score` e `rice_components` (`reach`/`impact`/`confidence`/
   `entanglement` dall'ultima voce approvata di `rice_history`; `null` se
   senza RICE) denormalizzando da `idea.yaml` (già letto nella sweep del
   passo 2) — così `iteration-board` mostra ogni riga con summary e RICE
   senza riaprire le idee (playbook, "Ogni riga che parla di un'idea si capisce da sola"). Per le voci di
   `analysis_todo` / `analysis_in_progress` / `in_development` popola
   allo stesso modo `tech_reference` da `idea.tech_reference`. Scrittura
   solo dentro il `payload` della proposta, non su `idea.yaml`.
   7. **Genera la proposta** `type: iteration_plan` in
      `product/approvals/pending/{settimana}-iteration-plan.yaml`
      (`framework/schema/approval.template.yaml`, `payload` = piano
      completo, `target_file` =
      `product/roadmap/iterations/{settimana}.yaml`). **Non applicare** —
      resta pending, si approva separatamente (skill `pending-approval`,
      come `roadmap_snapshot`).
   8. Sincronizza `pending/`:
      `bash .claude/hooks/governance-sync.sh push "backlog-refinement: proposta Piano di Iterazione <settimana>" product/approvals/pending/`.

7. **`retro_notes`** — % completamento dell'iterazione precedente,
   impedimenti riscontrati, informazioni mancate — se presenti nella
   trascrizione.

8. Consegna tutto a `log-ceremony` per i passi comuni: estrazione delle
   decisioni atomiche, `decisions.yaml` (con `retro_notes`,
   `reprioritizations`, `approvals_reviewed` del passo 3 e
   `iteration_plan_ref` = path della proposta del passo 6.7 valorizzati),
   riepilogo al PM — aperto **sempre** dagli allarmi `nsm-watch` se
   presenti — chiusura di `.run-meta.yaml`, sincronizzazione.

## Dopo

- **`pending-approval`** per approvare la proposta di Piano di Iterazione
  del passo 6 (e le eventuali `strategic_exception_flag` generate): finché
  resta in `pending/`, `product/roadmap/iterations/{settimana}.yaml` non
  esiste ancora. La camminata della cerimonia **non** l'ha approvata.
- **`iteration-board`** per la vista "a colpo d'occhio" del piano (daily
  standup, mail settimanale, Confluence).
- **`delivery-watch`** in modalità triage per smarcare la coda delle
  transizioni di delivery accodate nella sweep: ogni movimento ha già la
  sua bozza di mail agli stakeholder, il PM la rivede e la manda a mano
  (o, per eccezione, la archivia con un motivo); e rivede le idee create per backfill
  (`backfill_review_needed: true`).
- Il passo naturale successivo è **`roadmap-snapshot`** — la proposta di
  snapshot settimanale della roadmap, che ora **referenzia** il Piano di
  Iterazione (`iteration_plan_ref`) invece di ricostruire una propria
  lista di iniziative, e legge i riepiloghi delle watch loggati qui.
- Qualche giorno dopo: **`iteration-planning`**, quando il team tech
  fissa l'agenda concreta di delivery e **conferma/aggiusta** il Piano di
  Iterazione (stime di delivery, valutazione 80/20).
- La **roadmap aggiornata** (viste `per_ceremony`) esce già alla
  chiusura della cerimonia (`log-ceremony`, passo 7), con il banner "in
  attesa di approvazione" finché il piano è in `pending/`; si rigenera da
  sola quando `pending-approval` approva il piano o i RICE.
- Dopo l'approvazione del piano (e dello snapshot): **`report-render`**
  per le altre viste segnalate in scadenza nella sweep (blocco 9) — roadmap,
  scorecard, aggiornamento settimanale secondo i modelli dichiarati in
  `product/reference/reporting-models.yaml`. Quelle per un pubblico fuori
  dal team passano da `pending/` come `outbound_comm`.
