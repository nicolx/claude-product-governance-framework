---
id: roadmap-now-next-later
kind: roadmap
title: "Roadmap Now / Next / Later"
origin: framework
original_ref: null
extends: null
audience_default: "stakeholder di business, leadership"
cadence_default: monthly
period_format: "YYYY-MM"
horizon: "cosa facciamo ora, cosa viene dopo (entro il trimestre, dentro la capacità del team), cosa è in coda — senza date promesse"

options:
  show_scores: false        # true = mostra il RICE score accanto alle voci di Next/Later (utile con chi chiede "perché la mia idea non è in cima")
  later_limit: 10           # quante idee in coda mostrare in Later, per Product Line
  recently_done_weeks: 4    # finestra della sezione "Rilasciato di recente" (0 = sezione omessa)
  show_start_month: false   # true = accanto alle voci di Next il mese di inizio previsto dallo slot_plan, marcato "stima" (default: nessuna data)

sources:
  - "product/roadmap/iterations/{ultima settimana approvata}.yaml"
  - "product/roadmap/snapshots/{ultima settimana approvata}.yaml (slot_plan, capacity_allocation.by_competency)"
  - "product/ideas/*/idea.yaml"
  - "product/reference/product-lines.yaml"

fields:
  - field: "Now"
    source: "Piano di Iterazione approvato più recente: in_development + urgent_priority + analysis_in_progress"
    rule: "una riga per idea: short_ref, summary, stato in chiaro (in sviluppo / in analisi / priorità d'urgenza)"
  - field: "Next"
    source: "slot_plan.slots dell'ultimo snapshot approvato non già in Now (iniziano entro l'orizzonte, dentro la capacità del team); più analysis_todo del piano senza slot (in analisi da avviare, non ancora dimensionate)"
    rule: "ordinate per start_week; 'slitta per {competenza}' se delayed_by, '⚠ a rischio sulla scadenza' se at_risk; 'da dimensionare' per le analysis_todo senza slot; i mandate mostrano la due_date. Senza slot_plan: analysis_todo del piano + mandate due_soon/overdue fuori dal piano, nell'ordine del piano"
  - field: "Later"
    source: "idee con rice_history non vuoto, status bucket/prioritized, né in Now né in Next; motivo da slot_plan.unslotted"
    rule: "prima le beyond_horizon ('oltre il trimestre con il team attuale'), poi le altre per ultimo RICE score decrescente ('non ancora dimensionata'); le infeasible con 'non fattibile col team attuale'; prime later_limit per Product Line"
  - field: "Colli di bottiglia"
    source: "slot_plan.slots[].delayed_by e capacity_allocation.by_competency (status over) dell'ultimo snapshot approvato"
    rule: "una riga in testa: le competenze che fanno slittare voci di Next, con quante voci; omessa se nessuna"
  - field: "Rilasciato di recente"
    source: "idee status: done con done_at negli ultimi recently_done_weeks"
    rule: "solo quelle con avviso di conclusione sent/waived (le altre non sono ancora state comunicate)"
  - field: "Product Line"
    source: "idea.product_line → product-lines.yaml"
    rule: "una sezione per Product Line (filtrabile da filters.product_lines); platform senza product_line in una sezione 'Piattaforma'"

gaps: []
---

# Roadmap Now / Next / Later — {periodo}

## Scopo

Dire a chi non partecipa alle cerimonie **su cosa sta lavorando il
team, cosa viene dopo e cosa è in coda**, senza promettere date che il
team non ha stimato. È il formato più semplice e più onesto per un
progetto nascente: un ordine di priorità, non un calendario.

Il confine tra Next e Later non è arbitrario: **Next è ciò che il team
riesce a iniziare nel trimestre con la capacità che ha** (lo `slot_plan`
dello snapshot, playbook "Capacità del team e slot della roadmap"); Later
è ciò che, nell'ordine attuale, non ci sta ancora. Così "perché la mia
idea è in Later?" ha una risposta concreta — la priorità, o la capacità
di una competenza — senza bisogno di promettere date.

## Scheletro

```markdown
# Roadmap — {periodo}
_Aggiornata al {data}, dal Piano di Iterazione {settimana} e dallo snapshot {settimana}._
{Colli di bottiglia: {competenza} — fa slittare {N} iniziative in Next.}

## {Product Line}
**North Star:** {nsm}

### Now — ci stiamo lavorando
- {short_ref} · {summary} — {in sviluppo | in analisi | priorità d'urgenza}

### Next — i prossimi a partire, entro il trimestre
- {short_ref} · {summary}{ — scadenza {due_date} se mandate}{ — da {mese} (stima) se show_start_month}{ — slitta per {competenza}}{ — da dimensionare}

### Later — in coda, nell'ordine attuale
- {short_ref} · {summary} — {oltre il trimestre con il team attuale | non ancora dimensionata | non fattibile col team attuale}{ (RICE {score}) se show_scores}

### Rilasciato di recente
- {short_ref} · {summary} — in produzione dal {done_at}

---
Come leggere questa roadmap: l'ordine segue la prioritizzazione RICE ed
è rivisto ogni settimana nel Backlog Refinement; Next è ciò che il team
riesce a iniziare nel trimestre con la capacità che ha. Non sono date di
consegna.
```

## Regole di composizione

- La fonte di Now è **solo il Piano di Iterazione approvato**
  (`product/roadmap/iterations/`), quella di Next/Later lo `slot_plan`
  **dell'ultimo snapshot approvato** — mai `idea.status` letto a occhio,
  mai una proposta ancora in `pending/`. Se piano o snapshot hanno più di
  2 settimane, dillo in testa al documento.
- **Non si ricalcola lo slotting qui.** Se lo `slot_plan` è vuoto
  (`team.yaml` senza capacità, o snapshot precedente allo schema), Next e
  Later seguono la regola di ripiego (Next = `analysis_todo` + mandate
  `due_soon`/`overdue` fuori dal piano; Later = il resto per RICE) e una
  riga in testa dice che il confine non tiene conto della capacità del
  team — rimandando a `team-roster`.
- Nessuna data in Now/Next/Later, tranne la `due_date` dei mandate e la
  `deadline.due_date` dichiarata di un'idea (fatti dichiarati, non stime).
  Unica eccezione opzionale: con `show_start_month: true`, il mese di
  inizio dello slot accanto alle voci di Next, sempre marcato "stima"
  ("stima grezza" se `estimate_basis: rough`). Mai una data di fine.
- Una voce compare una volta sola: se è in Now non si ripete in Next,
  anche se ha uno slot.
- Escludi `declined`, `aborted`, `needs_clarification`, i bug e le idee
  con `backfill_review_needed: true`.
- Un'idea in Later senza RICE non compare: compare in Later solo ciò che
  è stato prioritizzato.
- Le Strategic Exception in `urgent_priority` si mostrano come tali
  ("priorità d'urgenza"), senza nominare chi le ha approvate: quel dato
  resta nel repo.
