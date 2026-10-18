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
horizon: "cosa facciamo ora, cosa viene dopo, cosa è in coda — senza date promesse"

options:
  show_scores: false        # true = mostra il RICE score accanto alle voci di Next/Later (utile con chi chiede "perché la mia idea non è in cima")
  later_limit: 10           # quante idee in coda mostrare in Later, per Product Line
  recently_done_weeks: 4    # finestra della sezione "Rilasciato di recente" (0 = sezione omessa)

sources:
  - "product/roadmap/iterations/{ultima settimana approvata}.yaml"
  - "product/ideas/*/idea.yaml"
  - "product/reference/product-lines.yaml"

fields:
  - field: "Now"
    source: "Piano di Iterazione approvato più recente: in_development + urgent_priority + analysis_in_progress"
    rule: "una riga per idea: short_ref, summary, stato in chiaro (in sviluppo / in analisi / priorità d'urgenza)"
  - field: "Next"
    source: "Piano di Iterazione: analysis_todo; più le idee classification: mandate con escalation_status due_soon/overdue non ancora nel piano"
    rule: "ordine del piano; i mandate mostrano la due_date (è una scadenza esterna dichiarata, non una promessa)"
  - field: "Later"
    source: "idee con rice_history non vuoto, status bucket/prioritized, fuori dal piano"
    rule: "ordinate per ultimo RICE score decrescente, prime later_limit per Product Line"
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

## Scheletro

```markdown
# Roadmap — {periodo}
_Aggiornata al {data}, dal Piano di Iterazione {settimana}._

## {Product Line}
**North Star:** {nsm}

### Now — ci stiamo lavorando
- {short_ref} · {summary} — {in sviluppo | in analisi | priorità d'urgenza}

### Next — i prossimi a partire
- {short_ref} · {summary}{ — scadenza {due_date} se mandate}

### Later — in coda, nell'ordine attuale
- {short_ref} · {summary}{ (RICE {score}) se show_scores}

### Rilasciato di recente
- {short_ref} · {summary} — in produzione dal {done_at}

---
Come leggere questa roadmap: l'ordine di Next e Later segue la
prioritizzazione RICE ed è rivisto ogni settimana nel Backlog
Refinement. Non sono date di consegna.
```

## Regole di composizione

- La fonte di Now/Next è **solo il Piano di Iterazione approvato**
  (`product/roadmap/iterations/`), mai `idea.status` letto a occhio, e
  mai una proposta ancora in `pending/`. Se l'ultimo piano approvato è
  più vecchio di 2 settimane, dillo in testa al documento.
- Nessuna data in Now/Next/Later, tranne la `due_date` dei mandate e la
  `deadline.due_date` dichiarata di un'idea (fatti dichiarati, non stime).
- Escludi `declined`, `aborted`, `needs_clarification`, i bug e le idee
  con `backfill_review_needed: true`.
- Un'idea in Later senza RICE non compare: compare in Later solo ciò che
  è stato prioritizzato.
- Le Strategic Exception in `urgent_priority` si mostrano come tali
  ("priorità d'urgenza"), senza nominare chi le ha approvate: quel dato
  resta nel repo.
