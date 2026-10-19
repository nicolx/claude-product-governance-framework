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
  show_alert_response: true     # per ogni NSM in allarme: il focus di Discovery e le iniziative mirate, con il loro slot dallo snapshot
  upcoming_impact_weeks: 6      # finestra di "Impatti in arrivo": iniziative con KPI la cui fine stimata cade entro N settimane (0 = sezione omessa)

sources:
  - "product/reference/nsm-tracking.yaml"
  - "product/roadmap/snapshots/{ultima settimana approvata}.yaml (nsm_alerts, slot_plan, measurements_status)"
  - "product/reference/product-lines.yaml"
  - "product/prds/*/measurement*.yaml"
  - "product/ideas/*/idea.yaml"

fields:
  - field: "NSM"
    source: "nsm-tracking.yaml: metrics[] (baseline, target, unit, ultima lettura, trend_status, alert.status)"
    rule: "una riga per NSM, raggruppate per Product Line"
  - field: "Risposta agli allarmi"
    source: "snapshot: nsm_alerts (alert_status active, discovery_focus_confirmed) + idee con quella NSM in links.nsm_targeted, con il loro slot da slot_plan (o lo stato se già in sviluppo/done)"
    rule: "solo se show_alert_response; una riga per NSM in allarme: 'focus di Discovery non ancora deciso' se discovery_focus_confirmed è false; altrimenti le iniziative mirate con dove sono — 'in sviluppo, fine nov (stima)', 'oltre il trimestre (capacità {competenza})', 'da dimensionare', 'rilasciata, in misurazione'. Focus confermato e nessuna iniziativa mirata: 'nessuna iniziativa mirata ancora' — è il dato, non va addolcito"
  - field: "Impatti in arrivo"
    source: "slot_plan.slots dello snapshot con end_week entro upcoming_impact_weeks + measurement*.yaml dei PRD di quelle idee"
    rule: "una riga per KPI: {prd_id} · {kpi}, baseline, target, fine stimata del rilascio '{mese} (stima)', finestra di misurazione; le idee con slot ma senza measurement*.yaml compaiono con 'misurazione non preparata'"
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

## Risposta agli allarmi
| NSM in allarme | Focus di Discovery | Iniziative mirate |
|---|---|---|
| {product_line} / {name} | {confermato il {data} / non ancora deciso} | {short_ref} · {summary} — {dove è} |

## Impatti in arrivo (prossime {upcoming_impact_weeks} settimane)
| KPI | Baseline | Target | Rilascio stimato | Finestra di misurazione |
|---|---|---|---|---|
| {prd_id} · {kpi} | … | … | {mese} (stima) | {window} |

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
- **Il legame con la roadmap viene dallo snapshot approvato**, mai
  ricostruito qui: allarmi e focus da `nsm_alerts`, quando arriva
  un'iniziativa da `slot_plan`. È ciò che chiude il cerchio tra "la
  metrica peggiora" e "cosa stiamo facendo, e quando atterra, con il team
  che abbiamo". Un'iniziativa mirata a una NSM in allarme che slitta per
  capacità è un'informazione per la leadership (dove mettere capacità),
  non un dettaglio da nascondere.
- Se lo snapshot manca o ha più di 2 settimane, dillo in testa; se manca
  del tutto o il suo `slot_plan` è vuoto, "Risposta agli allarmi" mostra
  solo il focus (da `nsm-tracking.yaml`) e le iniziative mirate senza
  slot, e "Impatti in arrivo" si omette.
- Le letture delle metriche restano quelle di `nsm-tracking.yaml` e dei
  `measurement*.yaml` (più fresche dello snapshot): lo snapshot serve per
  il legame con la roadmap, non per i valori.
