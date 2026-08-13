---
name: roadmap-snapshot
description: Genera la proposta di snapshot settimanale della roadmap a partire dalle cerimonie loggate e dallo stato Jira, scrivendola in product/approvals/pending/ — mai direttamente in product/roadmap/snapshots/.
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
     se presenti.
   - Stato Jira delle iniziative già collegate (vedi skill `jira-sync` —
     se lo stato non è stato aggiornato di recente, suggerisci di
     lanciare un pull prima di generare lo snapshot, per non proporre
     dati stantii).
   - `product/ideas/*/idea.yaml` con `status` in `in_roadmap` o
     `in_jira`, per popolare la lista `initiatives`.

3. Componi il contenuto secondo
   `framework/schema/roadmap-snapshot.template.yaml`: `iteration_goal`,
   `ceremony_refs` (link alle cartelle cerimonia usate come fonte),
   `initiatives` (idea_id, prd_id, jira_card_id, status, completion_pct),
   `retro_notes` se disponibili dal Backlog Refinement.

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
