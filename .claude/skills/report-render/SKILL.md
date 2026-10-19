---
name: report-render
description: Genera le viste per gli stakeholder (roadmap di lavoro, Now/Next/Later o trimestrale, scorecard delle metriche, aggiornamento settimanale, o un formato aziendale trascritto) a partire dai modelli di reporting dichiarati in product/reference/reporting-models.yaml. Scrive il report derivato in product/reports/ e, per un pubblico fuori dal team, prepara la comunicazione in product/approvals/pending/ (outbound_comm) — non pubblica né invia mai nulla. In modalità setup aggiunge, modifica o rimuove una vista, o trascrive un modello aziendale (slide, pagina Confluence, foglio) mappandone i campi sui dati del framework — tempi e capacità solo sullo slot plan e sulla capacità per competenza o squad dello snapshot, mai date a mano né carico per persona; avvisa se la capacità del team non è ancora dichiarata. Le viste con cadenza per_ceremony (la roadmap aggiornata dell'istanza, nel formato standard o in quello aziendale) le rigenera da sola alla fine di ogni cerimonia e a ogni approvazione che tocca la roadmap, richiamata da log-ceremony e pending-approval. Usala a mano quando un report è in scadenza o per configurare i modelli.
---

# report-render

Trasforma i dati già decisi dell'istanza in **viste per un pubblico**,
secondo un modello di reporting. Fonte normativa: playbook, "Modelli di
reporting" — leggila prima di generare.

Due modalità:

- **render** (default) — genera una o più viste dichiarate.
- **ceremony** — rigenerazione automatica delle viste `cadence:
  per_ceremony`, richiamata da `log-ceremony` (chiusura di una
  cerimonia) e da `pending-approval` (approvazioni che toccano la
  roadmap). Stessi passi del render, con le differenze descritte nella
  sezione "Modalità ceremony" sotto.
- **setup** — crea `product/reference/reporting-models.yaml` se manca,
  aggiunge/modifica/rimuove una vista, trascrive un modello aziendale.

> **Dry-run.** Se invocata in simulazione (argomento `dry-run`, o
> `dry_run: true` in `.governance/config.yaml`), applica il contratto
> della sezione "Modalità dry-run (simulazione)" del playbook: leggi e
> componi normalmente, **non** scrivere in `product/` (né report, né
> proposte, né `reporting-models.yaml`, né modelli aziendali), **non**
> invocare `governance-sync.sh push`, mostra come testo ciò che avresti
> scritto, e chiudi con `🔍 DRY-RUN — nessun file scritto, nessun commit,
> nessun push.`

## Modalità render

0. **Sincronizza e leggi in blocco**: `bash
   .claude/hooks/governance-sync.sh pull` (fermati e riferisci se segnala
   un non-fast-forward), poi `bash .claude/hooks/governance-dump.sh
   reports` — viste dichiarate, ultimi report generati, idee, piani,
   ultimo snapshot, misurazioni, NSM, registro delle ultime cerimonie
   (`decisions.yaml`) e l'indice delle proposte in `pending/` in una tool
   call.

1. **Quali viste.** Se l'utente ne nomina una (per `name`), quella. Se
   dice "quelle in scadenza", le viste con `cadence` diversa da
   `on_demand` e da `per_ceremony` il cui ultimo report in
   `product/reports/<name>/` copre un periodo precedente a quello
   corrente (o che non hanno ancora un report). Le viste `per_ceremony`
   non sono mai "in scadenza": si rigenerano alla fine di ogni cerimonia
   (modalità ceremony); a mano si rigenerano solo se nominate. Se `reporting-models.yaml` non esiste, **non inventare
   viste**: proponi di passare alla modalità setup.

2. **Carica il modello** di ciascuna vista:
   - `framework:<id>` → `framework/models/<id>.md`;
   - `company:<id>` → `product/reference/models/<id>.md` (se ha
     `extends: framework:<id>`, leggi anche il modello di base: il modello
     aziendale ne sovrascrive solo ciò che dichiara).
   Unisci le `options`: quelle della vista vincono su quelle del modello.
   Se il file del modello non esiste, fermati su quella vista e dillo.

3. **Verifica la freschezza delle fonti** prima di comporre, con le
   soglie del modello. Tipicamente: ultimo Piano di Iterazione approvato,
   ultimo snapshot approvato, data dell'ultima lettura di ogni NSM/KPI. Se
   una fonte è vecchia, **dillo e chiedi** se procedere o aggiornare
   prima (`roadmap-snapshot`, `nsm-watch`, `measurement-watch`) — mai un
   report che sembra aggiornato e non lo è. Le proposte ancora in
   `pending/` **non** sono fonti: si usa solo ciò che è approvato.

4. **Componi** seguendo lo `Scheletro` e le `Regole di composizione` del
   modello, campo per campo secondo `fields`, applicando
   `filters.product_lines`. Per ogni voce in `gaps`:
   - `ask_pm` → chiedi il valore al PM in conversazione; se non lo dà,
     scrivi "da compilare" in modo visibile;
   - `leave_blank` → "da compilare" visibile;
   - `omit` → togli il campo.
   Mai un valore stimato o dedotto per riempire una lacuna. Ogni elenco
   porta l'identificatore in prima colonna (`short_ref` o slug — playbook,
   "Ogni elenco prodotto dal sistema è indirizzabile") seguito dal
   `summary`. Il dettaglio R·I·C·E/RICE in un report per gli stakeholder
   lo decide il modello (es. `show_scores`), non la regola delle viste
   interne (playbook, "Ogni riga che parla di un'idea si capisce da
   sola", Ambito).

5. **Scrivi il report** in `product/reports/<name>/<periodo>.md`
   (`periodo` nel `period_format` del modello). In testa, un blocco di
   provenienza:

   ```markdown
   <!-- report-render · vista: <name> · modello: <model> · generato: <data>
        fonti: <path del piano/snapshot usati> · NON modificare a mano:
        correggi la fonte e rigenera -->
   ```

   Se il file del periodo esiste già, rigeneralo (è derivato): mostra al
   PM cosa cambia rispetto alla versione precedente prima di
   sovrascrivere.

6. **Distribuzione.** Se `audience` è `team`, fermati qui: il report è
   interno. Altrimenti prepara una proposta
   `product/approvals/pending/{data}-report-<name>-<periodo>.yaml`
   (`framework/schema/approval.template.yaml`, `type: outbound_comm`,
   `proposed_by: report-render`, `target_file: null`) con `payload`:
   `report_ref` (il path del report), `view` e `period`, `sources` (i
   path del piano/snapshot usati, gli stessi del blocco di provenienza),
   `recipients`, `destination`,
   `subject` e il corpo pronto all'invio/pubblicazione. Il corpo è per
   un pubblico, non per una persona: si calibra sull'identikit
   (`product/reference/stakeholders.yaml`) solo per ciò che vale per
   tutto il pubblico (formato, cosa mettere in testa); se tra i
   `recipients` c'è uno stakeholder con punti di attenzione rilevanti
   per questo contenuto, dillo al PM in conversazione (riga
   `Calibrazione: …`, mai nel `payload`) e suggerisci un passaggio 1:1
   prima della distribuzione (playbook, "L'identikit degli stakeholder e
   il rapporto individuale"). Il framework
   **non pubblica né invia**: dopo l'approvazione è il PM a mandare la
   mail o aggiornare la pagina/il deck.

7. Mostra il report (o un estratto, se lungo), le lacune rimaste "da
   compilare" e le proposte create.

8. **Sincronizza il repo**:
   `bash .claude/hooks/governance-sync.sh push "report-render: <viste> <periodo>" product/reports/ product/approvals/pending/`.
   Se l'helper segnala un push fallito, riferiscilo.

## Modalità ceremony (rigenerazione automatica)

È il meccanismo per cui **la roadmap è sempre quella dopo l'ultima
cerimonia**, senza che nessuno debba ricordarsi di rigenerarla. Fonte
normativa: playbook, "Modelli di reporting", "La roadmap si aggiorna da
sola". Non si invoca a mano: la richiamano

- `log-ceremony`, prima di chiudere `.run-meta.yaml` (quindi a fine
  Backlog Refinement, Iteration Planning e di ogni cerimonia ad-hoc), con
  `trigger: ceremony` e il `ceremony_ref` appena registrato;
- `pending-approval`, una volta per giro di approvazioni, se ha applicato
  almeno un `iteration_plan`, `rice_diff`, `strategic_exception_flag`,
  `mandate_update`, `mandate_reclassification` o `roadmap_snapshot`, con
  `trigger: approval` e l'elenco delle voci approvate.

Il dry-run del chiamante si propaga: in simulazione mostra il report che
scriverebbe e non scrive nulla.

Passi del render, con queste differenze:

- **Niente `pull`** al passo 0: il chiamante l'ha già fatto all'inizio
  del proprio run, e i file della cerimonia possono essere ancora non
  committati. Il dump sì.
- **Viste**: tutte e sole quelle con `cadence: per_ceremony` (dichiarata
  nella vista o, se la vista non la dichiara, `cadence_default` del
  modello). Il formato è quello della vista — standard o aziendale: la
  modalità non presuppone `roadmap-di-lavoro`. Se nessuna vista è
  `per_ceremony` (o `reporting-models.yaml` non esiste), **non generare
  niente e non inventare viste**: restituisci al chiamante una riga per
  il riepilogo — *"nessuna roadmap a rigenerazione automatica dichiarata
  — `report-render` setup per aggiungerne una (default:
  `framework:roadmap-di-lavoro`, o il formato di roadmap aziendale)"*.
- **Fonti in `pending/`**: non bloccare e non chiedere. Componi
  dall'approvato e metti in testa al report il banner del modello (o, se
  il modello non lo prevede, una riga *"In attesa di approvazione: …"*)
  con le proposte in coda che toccherebbero la roadmap. Alla loro
  approvazione `pending-approval` rigenera e il banner sparisce.
- **Freschezza**: una fonte vecchia non ferma la rigenerazione — va
  dichiarata in testa al report, come prevede il modello.
- **Commenti**: se il modello ha un campo che cita le cerimonie (es.
  "Commenti" di `roadmap-di-lavoro`), la cerimonia appena registrata è
  già nel dump (`decisions.yaml` scritto da `log-ceremony` al passo 4) ed
  è la fonte più recente.
- **Lacune `ask_pm`**: una sola domanda al PM con tutte le lacune
  insieme, non una per campo; senza risposta, "da compilare" visibile.
- **Periodo**: quello del `period_format` del modello alla data della
  cerimonia/approvazione. Se il report del periodo esiste già (seconda
  cerimonia della stessa settimana, approvazione dopo la cerimonia), si
  **sovrascrive senza chiedere** — è derivato — e nel riepilogo al PM si
  dice cosa è cambiato rispetto alla versione precedente (voci
  entrate/uscite/spostate, RICE e scadenze cambiate, commenti nuovi).
- **Distribuzione**: come al passo 6. Se esiste già in `pending/` un
  `outbound_comm` per la stessa vista e lo stesso periodo, **aggiornalo**
  invece di crearne un secondo (una sola comunicazione per vista e
  periodo in coda).
- **Sync**: con `trigger: ceremony` **non** fare push tu — il chiamante
  (`log-ceremony`) include `product/reports/` nel commit di chiusura della
  cerimonia, così la roadmap rigenerata appartiene al run (e
  `rollback-ceremony`, revertandolo, ripristina la versione precedente).
  Con `trigger: approval` fai il push del passo 8, in un commit separato
  da quello atomico dell'approvazione:
  `governance-sync.sh push "report-render: roadmap dopo approvazione <voci>" product/reports/ product/approvals/pending/`.
- **Riepilogo**: restituisci al chiamante path dei report rigenerati, cosa
  è cambiato, lacune rimaste, eventuali `outbound_comm` create o
  aggiornate — lo mostra lui nel proprio riepilogo, non un secondo
  riepilogo a parte.

## Modalità setup

Riusa le domande del passo "Modelli di reporting" di
`init-governance-project` — è lo stesso dialogo, per un'istanza già
inizializzata o per aggiungere viste dopo.

- **Nessun `reporting-models.yaml`**: chiedi se l'azienda ha già formati
  propri. Se no, proponi il set minimo standard (`roadmap-di-lavoro` con
  `cadence: per_ceremony` + `metriche-scorecard`, catalogo in
  `framework/models/README.md`) e
  chiedi per ciascuna vista pubblico, destinatari, cadenza, destinazione,
  Product Line. Crea il file da
  `framework/schema/reporting-models.template.yaml` **solo su conferma
  del PM** della lista finale.
- **Aggiungi / modifica / rimuovi una vista**: scrittura diretta su
  conferma. Rimuovere una vista non cancella i report già in
  `product/reports/<name>/` (sono storico).
- **Controllo di capacità**, ogni volta che dichiari o modifichi una
  vista che mostra **tempi o carico** (roadmap di lavoro, trimestrale,
  Now/Next/Later, aggiornamento settimanale, scorecard con "Impatti in
  arrivo", o un modello aziendale con campi mappati sullo `slot_plan`):
  leggi `product/reference/team.yaml`. Se manca il catalogo
  `competencies` o nessun membro ha `capacity.fte`, dillo prima di
  confermare: quelle colonne usciranno "slot non disponibili" finché la
  capacità non è dichiarata — proponi `team-roster` (playbook, "Capacità
  del team e slot della roadmap"). Non bloccare la vista. Se l'istanza ha
  `squads`, chiedi se la vista va divisa anche per squad (oltre che per
  Product Line): è un `filters`/raggruppamento della vista, non un
  modello nuovo.
- **Trascrivi un modello aziendale.** Il PM fornisce il formato che
  l'azienda usa (file droppato, link a una pagina o a una cartella di un
  connettore dichiarato, o una descrizione):
  1. leggilo (se è un file droppato, trattalo come in `context-intake`:
     non resta nel repo dopo la trascrizione; se è un link, va in
     `original_ref`);
  2. scrivi `product/reference/models/<id>.md` da
     `framework/schema/report-model.template.md`, `origin: company`,
     con lo `Scheletro` che riproduce **sezioni e ordine** del formato
     aziendale (non lo stile grafico);
  3. **mappa ogni campo** su un dato del framework (`fields`). I campi che
     il framework non tiene vanno in `gaps` con la gestione scelta dal
     PM — chiedila, non presumerla. Mostra la mappatura completa al PM
     prima di scrivere;
  4. se il formato aziendale è un modello standard con varianti, usa
     `extends: framework:<id>` e dichiara solo le differenze;
  5. dichiara la vista che lo usa (`model: company:<id>`). Se è il
     formato di **roadmap** dell'azienda, chiedi se deve essere la
     roadmap aggiornata a ogni cerimonia (`cadence: per_ceremony`): in
     quel caso prende il posto di `framework:roadmap-di-lavoro` — chiedi
     se tenere anche quella (es. per il team) o toglierla. Se il formato
     ha campi per scadenze, RICE o commenti, mappali sulle stesse fonti
     di `roadmap-di-lavoro` (`fields`), non su fonti nuove.
  6. **Tempi e capacità del formato aziendale.** I formati di roadmap
     aziendali chiedono quasi sempre *quando* (Gantt, inizio/fine,
     trimestre di rilascio, sprint) e a volte *quanto* (FTE allocati,
     utilizzo del team, swimlane per team). Mappali così, mai su date
     scritte a mano:
     - **inizio / fine / periodo di rilascio** → `slot_plan.slots`
       (`start_week`/`end_week`) dell'ultimo snapshot approvato,
       convertiti nella granularità del formato (mese, trimestre,
       sprint — chiedi la durata e la settimana di partenza degli sprint
       se il formato li usa) e sempre marcati "stima" ("stima grezza" se
       `estimate_basis: rough`). Le voci senza slot vanno nel campo del
       formato per "non pianificato/backlog" con il motivo da
       `unslotted`, o in `gaps` se il formato non ne ha uno;
     - **una data esatta di consegna** che il formato pretende come
       impegno → non esiste nel framework (le uniche date esatte sono le
       scadenze dichiarate): `gaps`, e dillo al PM — è una conversazione
       su cosa l'azienda chiama "data di rilascio", non un campo da
       riempire;
     - **capacità / utilizzo / FTE** → `capacity_allocation`
       (`total_capacity_weeks`, `by_competency`) e
       `slot_plan.saturation_by_month`, per competenza o per squad.
       **Mai per persona**: `team.yaml` è descrittivo e non valutativo,
       un report per gli stakeholder non mostra il carico o l'utilizzo
       dei singoli. Se il formato lo chiede, proponi la stessa colonna
       per competenza o per squad; se il PM insiste, è un `gaps`;
     - **quota sul debito tecnico** → `capacity_allocation.platform_pct`;
     - **swimlane per team** → `delivery.squad` / `team.yaml squads[].label`
       (o `platform.squad`); senza squad dichiarate, la swimlane è la
       Product Line;
     - **"owner" / "assegnatario" di un'iniziativa** → non è un dato di
       capacità: il framework ha solo il referente tecnico
       (`tech_reference`, chi valida l'How, non chi implementa —
       l'assegnazione vive nel tracker). Mappalo con questa etichetta,
       o in `gaps`: chiedi al PM.
     - **RAG / semaforo di stato** → si può derivare, se il PM approva la
       regola: verde = slot in linea e non `at_risk`, giallo =
       `delayed_by` o competenza `tight`, rosso = `at_risk` o
       `over_capacity`. Scrivi la regola nel `rule` del campo; senza
       accordo del PM, è un `gaps`.
     Mostra questa parte della mappatura a parte: è quella in cui un
     formato aziendale rischia di promettere più di quanto il team possa
     mantenere.
  Se più di un terzo dei campi finisce in `gaps`, dillo: il formato
  chiede dati che il processo non produce, ed è una conversazione da
  fare con chi lo ha imposto, non un buco da tappare a ogni report.

Chiudi con `governance-sync.sh push "report-render: setup <cosa>" product/reference/`.

## Cosa non fa

- Non modifica idee, piani, snapshot o metriche: se un report è
  sbagliato, si corregge la fonte (con la skill che la possiede) e si
  rigenera.
- Non legge le metriche dalla fonte di produzione: usa le letture
  registrate da `nsm-watch`/`measurement-watch`.
- Non produce file nel formato grafico aziendale (.pptx, pagina
  Confluence impaginata): produce il contenuto strutturato, nell'ordine
  del modello, pronto da incollare. Vedi `framework/docs/future-work.md`.
