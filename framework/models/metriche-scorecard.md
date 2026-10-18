---
id: metriche-scorecard
kind: metrics
title: "Scorecard metriche (NSM + KPI delle iniziative)"
origin: framework
original_ref: null
extends: null
audience_default: "leadership, owner di Product Line"
cadence_default: monthly
period_format: "YYYY-MM"
horizon: "stato al momento del report, con trend dalle letture registrate"

options:
  stale_reading_days: 45    # oltre quanti giorni l'ultima lettura di una metrica è segnalata come vecchia
  show_closed_in_period: true

sources:
  - "product/reference/nsm-tracking.yaml"
  - "product/reference/product-lines.yaml"
  - "product/prds/*/measurement*.yaml"
  - "product/ideas/*/idea.yaml"

fields:
  - field: "NSM"
    source: "nsm-tracking.yaml: metrics[] (baseline, target, unit, ultima lettura, trend_status, alert.status)"
    rule: "una riga per NSM, raggruppate per Product Line"
  - field: "Iniziative in misurazione"
    source: "measurement*.yaml con closure.closed: false, idea status: done"
    rule: "una riga per KPI: {prd_id} · {kpi}, baseline, target, ultima lettura, measurement_status, settimane da done_at"
  - field: "Chiuse nel periodo"
    source: "measurement*.yaml con closure.closed: true e closure.closed_at nel periodo"
    rule: "closure.outcome + closure.note, senza riformularli"
  - field: "Dashboard dei path"
    source: "product-lines.yaml: analytics_dashboard.ref (skill path-watch)"
    rule: "un link per Product Line, solo se valorizzato; altrimenti la riga non compare"

gaps: []
---

# Scorecard metriche — {periodo}

## Scopo

Mostrare se il prodotto **sta muovendo le metriche che contano**: le
North Star di ogni Product Line e le KPI delle iniziative già rilasciate.
È il complemento della roadmap: la roadmap dice cosa facciamo, la
scorecard dice se sta servendo.

## Scheletro

```markdown
# Scorecard — {periodo}
_Letture registrate fino al {data ultima lettura}._

## North Star Metric
| Product Line / NSM | Baseline | Target | Ultima lettura (data) | Trend | Allarme |
|---|---|---|---|---|---|
| {product_line} / {name} | {baseline} {unit} | {target} {unit} | {value} ({date}) | {trend_status} | {alert.status} |

Dashboard dei path da monitorare: {product_line} → {analytics_dashboard.ref}

## Iniziative in misurazione
| KPI | Baseline | Target | Ultima lettura | Stato | Settimane dal rilascio |
|---|---|---|---|---|---|
| {prd_id} · {kpi} | … | … | … | {measurement_status} | {n} |

Senza KPI di business: {prd_id} — {not_applicable_reason}

## Chiuse nel periodo
- {prd_id} — {closure.outcome}: {closure.note}
```

## Regole di composizione

- Il report **non legge le metriche dalla fonte**: usa le letture già
  registrate da `nsm-watch`/`measurement-watch`. Se un'ultima lettura è
  più vecchia di `stale_reading_days`, marca la riga "lettura vecchia" e
  suggerisci di eseguire la watch prima di distribuire.
- La direzione attesa di una NSM segue il prefisso `+`/`-` del nome
  (convenzione di `product-lines.yaml`): un trend si chiama
  "miglioramento" o "peggioramento" solo con quella convenzione, mai
  presumendo "più alto è meglio".
- Una NSM senza baseline/target mostra "da definire", non zero.
- Le iniziative con `kpis: []` compaiono con il loro
  `not_applicable_reason`: sono iniziative in chiusura, non metriche
  mancanti.
