---
name: roadmap-snapshot
description: Genera la proposta di snapshot settimanale della roadmap a partire dalle cerimonie loggate e dallo stato Jira, inclusi capacità protetta per il debito tecnico (platform), iniziative mandatarie a rischio, idee senza RICE e stato delle misurazioni — scrivendola in product/approvals/pending/, mai direttamente in product/roadmap/snapshots/.
---

# roadmap-snapshot

Genera la proposta di snapshot settimanale della roadmap, tipicamente
subito dopo che Backlog Refinement e Roadmap/Iteration Planning sono
stati loggati con `log-ceremony`. Segue il playbook (sezione "Product
Backlog Refinement" / "Roadmap update & Iteration planning").

## Regola fondamentale

**Non scrive mai direttamente** in
`product/roadmap/snapshots/{YYYY-Www}.yaml`. Scrive sempre una proposta
in `product/approvals/pending/` con `type: roadmap_snapshot`. Solo dopo
approvazione (skill `pending-approval`) il file di snapshot viene
creato/aggiornato.

## Passi

1. Determina la settimana ISO di riferimento (`YYYY-Www`).

2. Raccogli input da:
   - `product/ceremonies/backlog-refinement/{settimana}/decisions.yaml`
     e `product/ceremonies/roadmap-iteration-planning/{settimana}/decisions.yaml`,
     se presenti — inclusi i riepiloghi di `measurement-watch`,
     `mandate-watch`, `rice-watch` se `log-ceremony` li ha loggati lì.
   - Stato Jira delle iniziative già collegate (vedi skill `jira-sync` —
     se lo stato non è stato aggiornato di recente, suggerisci di
     lanciare un pull prima di generare lo snapshot, per non proporre
     dati stantii).
   - `product/ideas/*/idea.yaml` con `status` in `in_roadmap` o
     `in_jira`, per popolare la lista `initiatives`.
   - Se i riepiloghi delle cerimonie non coprono già lo stato più
     recente, richiama direttamente `mandate-watch`, `rice-watch` e
     `measurement-watch` prima di comporre lo snapshot — le sezioni sotto
     non vanno mai lasciate vuote solo perché la cerimonia non le ha
     toccate quella settimana.

3. Componi il contenuto secondo
   `framework/schema/roadmap-snapshot.template.yaml`:
   - `iteration_goal`, `ceremony_refs` (link alle cartelle cerimonia
     usate come fonte), `initiatives` (idea_id, prd_id, jira_card_id,
     status, completion_pct), `retro_notes` se disponibili dal Backlog
     Refinement.
   - `capacity_allocation`: somma `platform.estimated_effort_weeks`
     delle iniziative `classification: platform` presenti in
     `initiatives` questa settimana (→ `platform_weeks`) e
     `rice_history[-1].effort_weeks` delle iniziative `classification:
     idea` (→ `roadmap_weeks`). **Chiedi sempre** `total_capacity_weeks`
     al team tech (non presumerlo, non dedurlo da `platform_weeks +
     roadmap_weeks` — la capacità reale del team può essere diversa dal
     lavoro effettivamente pianificato). Calcola `platform_pct` solo se
     `total_capacity_weeks` è noto.
   - `mandates_status`: **tutte** le idee `classification: mandate` con
     `status` diverso da `done`/`aborted` (non solo quelle già in
     `initiatives`), leggendo `escalation_status`/`analysis_start_by`
     già calcolati da `mandate-watch` — non ricalcolarli qui.
   - `unscored_ideas`: idee `classification: idea` con `rice_history`
     vuoto, leggendo `rice_status` già calcolato da `rice-watch`.
   - `measurements_status`: KPI (o assenza di KPI) delle iniziative con
     `status: done` e `closure.closed: false`, leggendo
     `measurement_status` già calcolato da `measurement-watch`.
   - Se una di queste tre sezioni risulta vuota, verifica che sia
     davvero perché non c'è nulla da segnalare, non perché la relativa
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
