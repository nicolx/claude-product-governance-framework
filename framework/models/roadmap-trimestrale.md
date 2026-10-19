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
    source: "slot_plan.slots dello snapshot (start_week, end_week, estimate_basis, delayed_by, at_risk)"
    rule: "barra dal mese di start_week al mese di end_week, marcata 'stima' ('stima grezza' se estimate_basis: rough); 'slitta per {competenza}' se delayed_by; 'a rischio' se at_risk"
  - field: "Capacità per competenza"
    source: "slot_plan.saturation_by_month dello snapshot"
    rule: "una riga per competenza, saturazione per mese; evidenziate le celle > 100%"
  - field: "Non collocate"
    source: "slot_plan.unslotted e capacity_allocation.undimensioned_ideas dello snapshot"
    rule: "elencate a parte con il motivo (non dimensionata / oltre il trimestre / non fattibile), mai collocate in un mese"
  - field: "Scadenze"
    source: "mandate (mandate.due_date, escalation_status) e idee con deadline.due_date nel trimestre"
    rule: "data esatta + stato di escalation; ordinate per data"
  - field: "Segnali"
    source: "snapshot: nsm_alerts, capacity_allocation (platform_pct, by_competency over), mandates_status a rischio, slot at_risk"
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
- Capacità sul debito tecnico: {platform_pct}% ({platform_weeks} su {total_capacity_weeks} persona-settimane)
- Colli di bottiglia: {competenza — saturazione — iniziative slittate per lei}
- Iniziative mandatarie a rischio: {short_ref — due_date — escalation_status}

## Timeline
| Product Line | {mese 1} | {mese 2} | {mese 3} |
|---|---|---|---|
| {Product Line} | {short_ref} {summary} (stima){ · slitta per {competenza}}{ · ⚠ oltre la scadenza} | … | … |

## Capacità per competenza
| Competenza | {mese 1} | {mese 2} | {mese 3} |
|---|---|---|---|
| {competenza} | {saturation_pct}% | … | … |

## Scadenze nel trimestre
| Data | Iniziativa | Tipo | Stato |
|---|---|---|---|
| {due_date} | {short_ref} · {summary} | mandate / scadenza | {escalation_status} |

## Non collocate nel trimestre
- {short_ref} · {summary} — {non dimensionata: stima attesa dal team tech | oltre il trimestre: Later | non fattibile con il team attuale}

## Scadenze del trimestre successivo
- {due_date} · {short_ref} · {summary}
```

## Regole di composizione

- Una voce va in un mese **solo** se ha uno slot nello `slot_plan` dello
  snapshot (inizio e fine ricavati dalla capacità del team, playbook
  "Capacità del team e slot della roadmap"). Tutte le altre vanno in
  "Non collocate nel trimestre" con il motivo: è un'informazione, non un
  buco da coprire. Non si ricalcola lo slotting qui: se non piace, si
  cambia l'ordine o la stima, e si rigenera lo snapshot.
- Ogni collocazione nella timeline porta la dicitura "stima" ("stima
  grezza" se `estimate_basis: rough`). Le uniche
  date esatte sono le scadenze dichiarate (`mandate.due_date`,
  `deadline.due_date`).
- I segnali si copiano dallo snapshot approvato più recente. Se lo
  snapshot manca o ha più di 2 settimane, dillo in testa e suggerisci
  `roadmap-snapshot` prima di distribuire la vista.
- Se `total_capacity_weeks` non è stato dichiarato nello snapshot, la
  riga sulla capacità mostra le settimane senza percentuale — non si
  stima la capacità del team. Se lo `slot_plan` è vuoto (`team.yaml`
  senza capacità), la timeline lo dice in testa e rimanda a
  `team-roster`: niente collocazioni senza capacità dichiarata.
- La versione da distribuire porta nell'`outbound_comm` i `sources`
  (snapshot e piano usati): è ciò che rende confrontabile, settimana per
  settimana, la promessa con lo stato reale (regola sotto).
- **Una volta distribuita, è la promessa del trimestre.** L'aggiornamento
  settimanale (`framework:aggiornamento-settimanale`, opzione
  `compare_to_quarterly`) confronta ogni settimana lo `slot_plan`
  corrente con quello dello snapshot su cui poggiava la versione
  distribuita (in `sources` dell'`outbound_comm` approvato): in linea, in
  ritardo, in anticipo, uscite, aggiunte. Rigenerare il report in
  `product/reports/` non sposta la base; la sposta solo una nuova
  distribuzione approvata — una scelta del PM, da fare quando gli
  scostamenti sono tali che la promessa va riformulata, non per far
  sparire i ritardi dalla mail.
