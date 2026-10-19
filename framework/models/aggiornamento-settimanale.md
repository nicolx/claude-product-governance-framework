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
  include_alerts: true          # include allarmi NSM, mandate e scadenze a rischio
  include_delivery_outlook: true  # include "Quando arriva": consegne stimate dallo slot_plan e cosa si è spostato
  slip_threshold_weeks: 2       # uno spostamento di fine stimata più piccolo di così non si comunica (rumore di stima)

sources:
  - "product/roadmap/iterations/{settimana}.yaml"
  - "product/roadmap/snapshots/{settimana}.yaml (approvato; altrimenti l'ultimo approvato, dichiarandolo)"
  - "product/roadmap/snapshots/{snapshot approvato precedente}.yaml (per il confronto degli slot)"
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
  - field: "Quando arriva"
    source: "slot_plan dello snapshot confrontato con quello dello snapshot precedente"
    rule: "solo se include_delivery_outlook. Tre elenchi: (1) in consegna nelle prossime 4 settimane — end_week nella finestra, come 'fine {mese} (stima)'; (2) spostate — end_week cambiata di almeno slip_threshold_weeks, 'da {mese} a {mese}' più il motivo: 'capacità {competenza}' se delayed_by, 'nuova stima' se la stima è cambiata, 'priorità' se è cambiato l'ordine; (3) entrate nel trimestre — slot nuovo rispetto allo snapshot precedente. Mai la settimana ISO: il mese, sempre con 'stima'"
  - field: "Attenzione"
    source: "snapshot: nsm_alerts, mandates_status a rischio, deadline_alerts, slot at_risk"
    rule: "solo se include_alerts; copiati dallo snapshot, non ricalcolati. Uno slot at_risk si dice come 'la consegna stimata cade dopo la scadenza del {due_date}'"

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

**Quando arriva** _(stime del team, sulla capacità attuale)_
- In consegna a breve: {short_ref} · {summary} — fine {mese} (stima)
- Spostato: {short_ref} · {summary} — da {mese} a {mese}, {capacità {competenza} | nuova stima | priorità}
- Entrato nel trimestre: {short_ref} · {summary} — fine {mese} (stima)

**Attenzione**
- {NSM in allarme / mandate o scadenza a rischio / consegna stimata dopo la scadenza}

Roadmap completa: {link alla vista roadmap, se dichiarata}
```

## Regole di composizione

- Si genera solo da un Piano di Iterazione e da uno snapshot
  **approvati**: una proposta in `pending/` non è ancora una decisione da
  comunicare. Di norma lo genera `pending-approval` subito dopo aver
  approvato lo snapshot della settimana (playbook, "Modelli di
  reporting").
- Se lo snapshot della settimana non è ancora approvato, usa l'ultimo
  approvato e dillo in testa ("stime dallo snapshot {settimana}"). Se
  manca del tutto, o il suo `slot_plan` è vuoto, ometti "Quando arriva" —
  non si stimano consegne a mano — e i segnali di "Attenzione" si leggono
  da `nsm-tracking.yaml` e dalle idee come prima.
- "Quando arriva" parla di **fine stimata**, mai di date promesse: mese e
  "stima", e solo per le voci con slot. Una stima `rough` si comunica
  solo se il PM lo vuole: di default resta fuori dalla mail (è ancora
  troppo grezza per uno stakeholder). Il confronto con lo snapshot
  precedente si fa voce per voce (`idea_id`); senza snapshot precedente
  l'elenco "Spostato" si omette.
- Il motivo di uno spostamento si comunica con il nome della competenza,
  mai di una persona.
- Il "Consegnato" non duplica gli avvisi di conclusione: li riassume in
  una riga. Chi ha già ricevuto l'avviso dedicato lo ritrova qui, non
  riceve una seconda comunicazione diversa.
- Una sezione vuota si omette, non si riempie con "nessuna novità".
