---
name: roadmap-snapshot
description: Genera la proposta di snapshot settimanale della roadmap a partire dalle cerimonie loggate e dallo stato Jira, inclusi allarmi sulle NSM in degrado, capacità protetta per il debito tecnico (platform), iniziative mandatarie a rischio, scadenze in avvicinamento su idee normali, idee senza RICE e stato delle misurazioni — scrivendola in product/approvals/pending/, mai direttamente in product/roadmap/snapshots/.
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

0. **Sincronizza da `origin` prima di leggere lo stato**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)"). Uno snapshot generato su
   uno stato locale vecchio omette iniziative e proposte che i colleghi
   hanno già scritto. Se l'helper segnala un disallineamento
   non-fast-forward, fermati e riferiscilo all'utente.

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
   - `product/ideas/*/idea.yaml` con `status` in `in_roadmap` o
     `in_jira`, per popolare la lista `initiatives`.
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
   - `iteration_goal`, `ceremony_refs` (link alle cartelle cerimonia
     usate come fonte), `initiatives` (idea_id, prd_id, jira_card_id,
     status, completion_pct), `retro_notes` se disponibili dal Backlog
     Refinement.
   - `capacity_allocation`: somma `platform.estimated_effort_weeks`
     delle iniziative `classification: platform` presenti in
     `initiatives` questa settimana (→ `platform_weeks`) e
     `delivery.estimated_effort_weeks` delle iniziative `classification:
     idea` (→ `roadmap_weeks`). **NON** usare la `entanglement_score` del
     RICE per `roadmap_weeks`: è un footprint 1-10, non settimane. Le
     iniziative `idea` senza `delivery.estimated_effort_weeks` (non ancora
     passate da Iteration Planning) vanno in
     `capacity_allocation.undimensioned_ideas` (lista di `idea_id`), non
     stimate d'ufficio né ignorate silenziosamente. **Chiedi sempre**
     `total_capacity_weeks` al team tech (non presumerlo, non dedurlo da
     `platform_weeks + roadmap_weeks` — la capacità reale del team può
     essere diversa dal lavoro effettivamente pianificato). Calcola
     `platform_pct` solo se `total_capacity_weeks` è noto.
   - `mandates_status`: **tutte** le idee `classification: mandate` con
     `status` diverso da `done`/`aborted` (non solo quelle già in
     `initiatives`), leggendo `escalation_status`/`analysis_start_by`
     già calcolati da `mandate-watch` — non ricalcolarli qui.
   - `deadline_alerts`: le idee `classification: idea`/`strategic_exception`
     (mai `mandate`) con `deadline.escalation_status` a `due_soon` o
     `overdue`, leggendo il valore già calcolato da `deadline-watch` —
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
   indipendentemente.

6. Mostra la proposta e ricorda che resta pending finché non approvata
   esplicitamente.

7. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "roadmap-snapshot: proposta <YYYY-Www>" product/approvals/pending/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se l'helper
   segnala un push fallito, riferiscilo all'utente.
