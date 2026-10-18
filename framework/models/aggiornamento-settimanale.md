---
id: aggiornamento-settimanale
kind: update
title: "Aggiornamento settimanale agli stakeholder"
origin: framework
original_ref: null
extends: null
audience_default: "stakeholder di business"
cadence_default: weekly
period_format: "YYYY-Www"
horizon: "la settimana appena pianificata, rispetto a quella prima"

options:
  include_alerts: true      # include allarmi NSM e mandate a rischio

sources:
  - "product/roadmap/iterations/{settimana}.yaml"
  - "product/ideas/*/idea.yaml"
  - "product/reference/nsm-tracking.yaml"

fields:
  - field: "Obiettivo della settimana"
    source: "iteration_goal del Piano di Iterazione approvato"
  - field: "Cosa è cambiato"
    source: "changes_since_last del Piano: completed, advanced, slipped, new"
    rule: "slipped con la sua note e da quante settimane è fermo (weeks_stuck); dropped (con reason) solo se il PM lo vuole comunicare"
  - field: "Consegnato"
    source: "idee con conclusion_notices kind delivered in stato sent/waived nella settimana"
  - field: "Attenzione"
    source: "nsm_alerts attivi, mandate due_soon/overdue"
    rule: "solo se include_alerts"

gaps: []
---

# Aggiornamento settimanale — {periodo}

## Scopo

Una mail breve che gli stakeholder leggono in due minuti: cosa fa il
team questa settimana, cosa è cambiato rispetto alla scorsa, cosa
richiede attenzione. Sostituisce le richieste sparse "a che punto siamo
con…?".

## Scheletro

```markdown
Oggetto: Prodotto — aggiornamento {periodo}

**Obiettivo della settimana:** {iteration_goal}

**Cosa è cambiato**
- Completato: {short_ref} · {summary}
- Avanzato: {short_ref} · {summary} — {da bucket → a bucket}
- Fermo: {short_ref} · {summary} — da {weeks_stuck} settimane, {note}
- Nuovo in lavorazione: {short_ref} · {summary}

**Consegnato in produzione**
- {short_ref} · {summary}

**Attenzione**
- {NSM in allarme / mandate a rischio}

Roadmap completa: {link alla vista roadmap, se dichiarata}
```

## Regole di composizione

- Si genera solo da un Piano di Iterazione **approvato**: una proposta in
  `pending/` non è ancora una decisione da comunicare.
- Il "Consegnato" non duplica gli avvisi di conclusione: li riassume in
  una riga. Chi ha già ricevuto l'avviso dedicato lo ritrova qui, non
  riceve una seconda comunicazione diversa.
- Una sezione vuota si omette, non si riempie con "nessuna novità".
