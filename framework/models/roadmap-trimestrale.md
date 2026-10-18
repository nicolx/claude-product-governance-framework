---
id: roadmap-trimestrale
kind: roadmap
title: "Roadmap trimestrale (timeline)"
origin: framework
original_ref: null
extends: null
audience_default: "leadership (MBR/MTR, board)"
cadence_default: quarterly
period_format: "YYYY-Qn"
horizon: "trimestre corrente, mese per mese, più gli impegni con scadenza nel trimestre successivo"

options:
  include_next_quarter_deadlines: true   # mostra in coda le scadenze (mandate/deadline) del trimestre successivo

sources:
  - "product/roadmap/snapshots/{ultima settimana approvata}.yaml"
  - "product/roadmap/iterations/{ultima settimana approvata}.yaml"
  - "product/ideas/*/idea.yaml"
  - "product/reference/nsm-tracking.yaml"
  - "product/reference/product-lines.yaml"

fields:
  - field: "Timeline"
    source: "idee nei bucket in_development/urgent_priority del Piano di Iterazione, con delivery.estimated_effort_weeks"
    rule: "finestra stimata = dalla settimana iteration.current per estimated_effort_weeks settimane; collocata nel mese in cui cade la fine, marcata 'stima'"
  - field: "Non dimensionate"
    source: "capacity_allocation.undimensioned_ideas dello snapshot"
    rule: "elencate a parte, mai collocate in un mese"
  - field: "Scadenze"
    source: "mandate (mandate.due_date, escalation_status) e idee con deadline.due_date nel trimestre"
    rule: "data esatta + stato di escalation; ordinate per data"
  - field: "Segnali"
    source: "snapshot: nsm_alerts, capacity_allocation (platform_pct), mandates_status a rischio"
    rule: "copiati dallo snapshot, non ricalcolati"

gaps: []
---

# Roadmap trimestrale — {periodo}

## Scopo

Dare alla leadership la vista per **mese** del trimestre: cosa dovrebbe
arrivare quando, quali scadenze esterne incombono, dove sono i rischi.
È la vista che un'azienda si aspetta in un MBR/MTR — ma costruita solo
su stime del team e scadenze dichiarate, mai su date inventate per
riempire una casella.

## Scheletro

```markdown
# Roadmap {periodo}
_Dallo snapshot {settimana} e dal Piano di Iterazione {settimana}._

## Segnali
- NSM in allarme: {product_line / name — trend}
- Capacità sul debito tecnico: {platform_pct}% ({platform_weeks} su {total_capacity_weeks} settimane)
- Iniziative mandatarie a rischio: {short_ref — due_date — escalation_status}

## Timeline
| Product Line | {mese 1} | {mese 2} | {mese 3} |
|---|---|---|---|
| {Product Line} | {short_ref} {summary} (stima) | … | … |

## Scadenze nel trimestre
| Data | Iniziativa | Tipo | Stato |
|---|---|---|---|
| {due_date} | {short_ref} · {summary} | mandate / scadenza | {escalation_status} |

## In lavorazione, non ancora dimensionate
- {short_ref} · {summary} — stima attesa dall'Iteration Planning

## Scadenze del trimestre successivo
- {due_date} · {short_ref} · {summary}
```

## Regole di composizione

- Una voce va in un mese **solo** se ha `delivery.estimated_effort_weeks`
  (stima del team tech dall'Iteration Planning). Tutte le altre vanno in
  "non ancora dimensionate": è un'informazione, non un buco da coprire.
- Ogni collocazione nella timeline porta la dicitura "stima". Le uniche
  date esatte sono le scadenze dichiarate (`mandate.due_date`,
  `deadline.due_date`).
- I segnali si copiano dallo snapshot approvato più recente. Se lo
  snapshot manca o ha più di 2 settimane, dillo in testa e suggerisci
  `roadmap-snapshot` prima di distribuire la vista.
- Se `total_capacity_weeks` non è stato dichiarato nello snapshot, la
  riga sulla capacità mostra le settimane senza percentuale — non si
  stima la capacità del team.
