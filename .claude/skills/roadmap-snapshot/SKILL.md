---
name: roadmap-snapshot
description: Genera la proposta di snapshot settimanale della roadmap (il rollup strategico per MBR/MTR) a partire dalle cerimonie loggate e dallo stato Jira, inclusi allarmi sulle NSM in degrado, capacità del team per competenza (calcolata da team.yaml) con la quota protetta per il debito tecnico (platform), slot delle iniziative nel trimestre dentro la capacità reale, iniziative mandatarie a rischio, scadenze in avvicinamento su idee normali, idee senza RICE e stato delle misurazioni. Referenzia il Piano di Iterazione della settimana (iteration_plan_ref) invece di ricostruire una propria lista di iniziative. Scrive in product/approvals/pending/, mai direttamente in product/roadmap/snapshots/.
---

# roadmap-snapshot

Genera la proposta di snapshot settimanale della roadmap, tipicamente
subito dopo che Backlog Refinement e Roadmap/Iteration Planning sono
stati loggati con `backlog-refinement` / `iteration-planning`. Segue il
playbook (sezione "Product Backlog Refinement" / "Roadmap update &
Iteration planning").

## Regola fondamentale

**Non scrive mai direttamente** in
`product/roadmap/snapshots/{YYYY-Www}.yaml`. Scrive sempre una proposta
in `product/approvals/pending/` con `type: roadmap_snapshot`. Solo dopo
approvazione (skill `pending-approval`) il file di snapshot viene
creato/aggiornato.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** creare la
> proposta in `product/approvals/pending/`, **non** invocare
> `governance-sync.sh push`, mostra come testo lo snapshot completo (YAML)
> che avresti scritto, e chiudi con `🔍 DRY-RUN — nessun file scritto,
> nessun commit, nessun push.` **Propaga il dry-run** a `nsm-watch`,
> `mandate-watch`, `deadline-watch`, `rice-watch`, `measurement-watch` se
> le richiami.

0. **Sincronizza e leggi in blocco**: `bash
   .claude/hooks/governance-sync.sh pull` (uno snapshot su stato vecchio
   omette iniziative e proposte già scritte dai colleghi; se l'helper
   segnala un non-fast-forward, fermati e riferiscilo), poi `bash
   .claude/hooks/governance-dump.sh sweep` — lo stesso quadro completo
   che serve alla sweep di apertura (idee, misurazioni, NSM, piani di
   iterazione, coda `pending/`) in una tool call.

1. Determina la settimana ISO di riferimento (`YYYY-Www`).

2. Raccogli input da:
   - `product/ceremonies/backlog-refinement/{settimana}/decisions.yaml`
     e `product/ceremonies/roadmap-iteration-planning/{settimana}/decisions.yaml`,
     se presenti — inclusi i riepiloghi di `nsm-watch`, `measurement-watch`,
     `mandate-watch`, `rice-watch` se `backlog-refinement` li ha loggati lì.
   - Stato Jira delle iniziative già collegate (vedi skill `jira-sync` —
     se lo stato non è stato aggiornato di recente, suggerisci di
     lanciare un pull prima di generare lo snapshot, per non proporre
     dati stantii).
   - **Il Piano di Iterazione della settimana**
     (`product/roadmap/iterations/{settimana}.yaml` approvato, o la
     proposta `type: iteration_plan` ancora in `pending/` se non ancora
     approvata) — è la fonte di `iteration_goal` e, quando serve, della
     lista `initiatives`. Se manca del tutto, `iteration_plan_ref` resta
     `null` e lo si segnala: il Backlog Refinement non ha prodotto il
     piano.
   - `product/reference/team.yaml` — l'offerta di
     capacità per competenza su cui si calcolano `capacity_allocation` e
     `slot_plan` — e lo `slot_plan` dello snapshot precedente, da cui le
     iniziative in sviluppo ereditano il loro slot (entrambi già nel dump
     `sweep`).
   - Se i riepiloghi delle cerimonie non coprono già lo stato più
     recente, richiama direttamente `nsm-watch`, `mandate-watch`,
     `deadline-watch`, `rice-watch` e `measurement-watch` prima di
     comporre lo snapshot — le sezioni sotto non vanno mai lasciate vuote
     solo perché la cerimonia non le ha toccate quella settimana.

3. Componi il contenuto secondo
   `framework/schema/roadmap-snapshot.template.yaml`:
   - `nsm_alerts` **per primo**: tutte le NSM con `alert.status` diverso
     da `none` in `product/reference/nsm-tracking.yaml` (non solo quelle
     rilevate questa settimana — un allarme resta finché non è
     `resolved`), leggendo `trend_status`/`alert` già calcolati da
     `nsm-watch`. È il segnale più strategico dello snapshot, va in cima
     al documento, non in coda dopo tutto il resto.
   - `iteration_plan_ref` (path del Piano di Iterazione della settimana),
     `iteration_goal` **copiato da quel piano**, `ceremony_refs` (link
     alle cartelle cerimonia usate come fonte), `retro_notes` se
     disponibili dal Backlog Refinement.
   - `initiatives` è **derivata/opzionale**: NON ricostruirla da
     `idea.status`. Compilala solo se un MBR/MTR chiede l'elenco piatto
     delle iniziative in lavorazione — in quel caso leggi i quattro
     bucket del Piano di Iterazione (`analysis_todo`,
     `analysis_in_progress`, `in_development`, `urgent_priority`) e per
     ciascuna voce riporta `idea_id`, `prd_id`, `jira_card_id`, `status`,
     `completion_pct`, `iteration_bucket`. Altrimenti lasciala vuota: il
     dettaglio operativo vive nel piano referenziato.
   - `slot_plan` **prima** di `capacity_allocation` (che ne legge la
     prima settimana). Applica lo slotting del playbook ("Capacità del
     team e slot della roadmap") sulle prossime `horizon_weeks` (default
     13): offerta settimana per settimana e per competenza da
     `product/reference/team.yaml` (per squad, se l'istanza ne ha), poi
     le iniziative dimensionate in ordine di priorità — in sviluppo
     (tengono lo slot dello snapshot precedente, salvo nuova stima),
     `urgent_priority` + mandate/deadline da chiudere entro la scadenza,
     platform, analisi del piano per RICE, resto del backlog con stima
     per RICE. Ogni iniziativa prende il primo inizio in cui il suo
     carico settimanale sta nella capacità residua di ogni sua
     competenza per tutta la durata; `delayed_by` se è slittata per
     capacità, `at_risk` se finisce oltre la sua `due_date`. Quelle che
     non si possono collocare vanno in `unslotted` con il motivo — mai
     omesse. **Mostra il calcolo** (offerta per competenza, ordine,
     slot risultanti) nel checkpoint: è aritmetica che il PM deve poter
     verificare, non una scatola nera. Le stime `rough` restano tali
     (`estimate_basis`) e le viste le marcano.
   - `capacity_allocation`: per la settimana dello snapshot, dalla prima
     colonna dello `slot_plan`. `total_capacity_weeks` = offerta
     calcolata da `team.yaml` (`basis: computed`); `roadmap_weeks` /
     `platform_weeks` = somma dei carichi settimanali degli slot attivi
     questa settimana (idea / strategic_exception / mandate vs.
     platform); `by_competency` con saturazione e stato; se una
     competenza è `over`, `over_capacity_ref` punta al Piano di
     Iterazione che ha registrato la decisione di sforamento — se il
     piano non ce l'ha, **segnalalo** (sforamento non deciso). **NON**
     usare la `entanglement_score` del RICE: è un footprint 1-10, non
     settimane. Le iniziative in iterazione senza stima vanno in
     `undimensioned_ideas`, i membri senza `fte` in `unsized_members` —
     non stimati d'ufficio né ignorati in silenzio.
     Se `team.yaml` non ha ancora dati di capacità (nessun membro con
     `capacity.fte`), `basis: declared`: **chiedi**
     `total_capacity_weeks` al team tech come prima (non presumerlo, non
     dedurlo dal lavoro pianificato), salta `slot_plan` (`slots: []`,
     motivo in `note`) e rimanda a `team-roster`. Calcola `platform_pct`
     solo se `total_capacity_weeks` è noto.
   - `mandates_status`: **tutte** le idee `classification: mandate` con
     `status` diverso da `done`/`aborted` (non solo quelle già in
     `initiatives`), leggendo `escalation_status`/`analysis_start_by`
     già calcolati da `mandate-watch` — non ricalcolarli qui.
   - `deadline_alerts`: le idee `classification: idea`/`strategic_exception`
     (mai `mandate`) con `deadline.escalation_status` a `due_soon`,
     `at_risk` o `overdue` (con `escalation_basis` e la fine stimata dallo
     `slot_plan`), leggendo il valore già calcolato da `deadline-watch` —
     non ricalcolarlo qui. Stesso principio di `mandates_status`: vanno
     rese visibili anche se non ancora in `initiatives`.
   - `unscored_ideas`: idee `classification: idea` con `rice_history`
     vuoto, leggendo `rice_status` già calcolato da `rice-watch` —
     incluso il `summary` dell'idea e, per quelle con
     `rice_status.deep_dive.needed`, lo stato `needs_deep_dive:{richiedente}`
     con da quanto il meeting è in sospeso.
   - `measurements_status`: KPI (o assenza di KPI) delle iniziative con
     `status: done` e `closure.closed: false`, leggendo
     `measurement_status` già calcolato da `measurement-watch`.
   - Se una di queste sezioni (`mandates_status`, `deadline_alerts`,
     `unscored_ideas`, `measurements_status`) risulta vuota, verifica che
     sia davvero perché non c'è nulla da segnalare, non perché la relativa
     skill non è mai stata richiamata in questo ciclo.

4. Crea la proposta in
   `product/approvals/pending/{YYYY-Www}-roadmap-snapshot.yaml`
   (`framework/schema/approval.template.yaml`, `type: roadmap_snapshot`,
   `payload` = contenuto completo dello snapshot, `target_file` =
   `product/roadmap/snapshots/{YYYY-Www}.yaml`).

5. Se questo è anche il momento di preparare la comunicazione settimanale
   agli stakeholder (mail o report), **non generarla come parte di questa
   skill**: prepara una proposta separata con `type: outbound_comm` nella
   coda di approvazione, così le due decisioni (pubblicare lo snapshot
   internamente / comunicarlo all'esterno) restano approvabili
   indipendentemente. La forma di quella comunicazione la dà il modello
   di reporting dichiarato in `product/reference/reporting-models.yaml`:
   dopo l'approvazione dello snapshot, è **`report-render`** a generare le
   viste (roadmap trimestrale, Now/Next/Later, aggiornamento settimanale o
   un formato aziendale) e a preparare l'`outbound_comm` — non
   improvvisarne il formato qui (playbook, "Modelli di reporting").
   L'**aggiornamento settimanale** non va nemmeno chiesto: se l'istanza
   lo dichiara, lo prepara `pending-approval` subito dopo aver approvato
   questo snapshot, con le consegne stimate dallo `slot_plan` e ciò che
   si è spostato rispetto allo snapshot precedente. Per questo `slot_plan`
   e `capacity_allocation` vanno compilati per intero anche quando la
   settimana sembra tranquilla: sono la fonte di "Quando arriva".
   Lo snapshot **non** riproduce gli eventi di delivery per-card (bug
   risolto, blocco, consegna): quelle sono comunicazioni verso
   stakeholder gestite da `delivery-watch`, non il rollup strategico. Al
   più, cita quante voci restano `pending` nella sua coda di triage.

6. Mostra la proposta e ricorda che resta pending finché non approvata
   esplicitamente.

7. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "roadmap-snapshot: proposta <YYYY-Www>" product/approvals/pending/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se l'helper
   segnala un push fallito, riferiscilo all'utente.
