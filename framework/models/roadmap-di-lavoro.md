---
id: roadmap-di-lavoro
kind: roadmap
title: "Roadmap di lavoro (aggiornata a ogni cerimonia)"
origin: framework
original_ref: null
extends: null
audience_default: "team, owner di Product Line"
cadence_default: per_ceremony
period_format: "YYYY-Www"
horizon: "iterazione corrente + backlog prioritizzato + scadenze dichiarate, con il perché di ogni posizione"

options:
  show_rice_components: true   # mostra R·I·C·E oltre allo score (false = solo lo score)
  backlog_limit: 15            # quante idee prioritizzate fuori dal piano mostrare, per Product Line (0 = sezione omessa)
  deadline_horizon_weeks: 12   # finestra della sezione "Scadenze" (le overdue si mostrano sempre)
  max_comments_per_item: 3     # commenti per voce, i più recenti prima
  comments_lookback: 2         # quante cerimonie per tipo considerare come fonte dei commenti (la corrente + le precedenti)
  recently_done_weeks: 2       # finestra della sezione "Rilasciato di recente" (0 = sezione omessa)

sources:
  - "product/roadmap/iterations/{ultima settimana approvata}.yaml"
  - "product/ideas/*/idea.yaml"
  - "product/ceremonies/*/{ultime comments_lookback per tipo}/decisions.yaml"
  - "product/approvals/pending/ (solo i nomi: per dichiarare cosa è ancora in attesa)"
  - "product/reference/product-lines.yaml"

fields:
  - field: "In iterazione"
    source: "Piano di Iterazione approvato più recente: urgent_priority, in_development, analysis_in_progress, analysis_todo"
    rule: "una tabella per Product Line, bucket in quest'ordine; stato in chiaro (priorità d'urgenza / in sviluppo / in analisi / analisi da avviare)"
  - field: "Backlog prioritizzato"
    source: "idee con rice_history non vuoto, status bucket/prioritized, fuori da tutti i bucket del piano"
    rule: "ordinate per ultimo RICE score approvato decrescente, prime backlog_limit per Product Line; posizione = rango nel backlog"
  - field: "Scadenza"
    source: "mandate.due_date + mandate.escalation_status; altrimenti deadline.due_date + deadline.escalation_status"
    rule: "data esatta + stato (in evidenza due_soon/overdue); '—' se non dichiarata. Mai una data stimata"
  - field: "Stima"
    source: "delivery.estimated_effort_weeks (Iteration Planning)"
    rule: "'N sett. (stima)' per le voci in iterazione che ce l'hanno; '—' altrimenti"
  - field: "RICE"
    source: "ultima voce APPROVATA di rice_history (reach_points/impact_points/confidence_score/entanglement_score/score)"
    rule: "'R4 I6 C8 E2 → 96' (o solo lo score se show_rice_components: false). Senza RICE: '—' + motivo (mandate / platform / SE / senza RICE). Una proposta rice_diff in pending/ si segnala come '(revisione in attesa)', mai mostrata come valore"
  - field: "Commenti"
    source: "decisions.yaml delle ultime comments_lookback cerimonie per tipo: decisions[] con l'idea in impacts.idea_ids (summary), reprioritizations (reason), approvals_reviewed (note, se rejected/deferred); più, dal piano: why_now / note / trigger + decided"
    rule: "testo della fonte, accorciato ma non riscritto nel senso; ciascuno con la cerimonia di provenienza ('BR W42', 'IP W42'); più recenti prima, al massimo max_comments_per_item; nessun commento → cella vuota, non inventata"
  - field: "Cambiato dall'ultima versione"
    source: "changes_since_last del Piano di Iterazione + diff dei rice_history approvati dopo il report precedente"
    rule: "elenco breve: entrate, uscite, avanzate, slittate, RICE rivisti (vecchio → nuovo)"
  - field: "Product Line"
    source: "idea.product_line → product-lines.yaml"
    rule: "una sezione per Product Line (filtrabile da filters.product_lines); platform senza product_line in 'Piattaforma'"

gaps: []
---

# Roadmap di lavoro — {periodo}

## Scopo

Dare al team e agli owner di Product Line **la roadmap com'è dopo
l'ultima cerimonia**: cosa è in iterazione, cosa viene dopo nell'ordine
del RICE, quali scadenze incombono, e **perché** ogni voce è dove è — con
i commenti emersi in cerimonia accanto alla voce, non sepolti in un
verbale. Si rigenera da sola alla fine di ogni cerimonia (cadenza
`per_ceremony`): nessuno deve ricordarsi di aggiornarla.

È il formato di partenza: un'istanza con un proprio formato di roadmap
dichiara quello come vista `per_ceremony` (modello aziendale, anche con
`extends: framework:roadmap-di-lavoro`) e il meccanismo è lo stesso.

## Scheletro

```markdown
# Roadmap di lavoro — {periodo}
_Aggiornata al {data} dopo {cerimonia} · Piano di Iterazione {settimana}._
{⚠ In attesa di approvazione: {elenco proposte pending che toccano la roadmap} — questa versione mostra ancora l'ultimo stato approvato.}

## Cambiato dall'ultima versione
- {entrate / uscite / avanzate / slittate / RICE rivisti}

## {Product Line}

### In iterazione
| ID | Iniziativa | Stato | Scadenza | Stima | RICE | Commenti |
|---|---|---|---|---|---|---|
| {short_ref} | {summary} | {stato} | {due_date · escalation} | {N sett. (stima)} | {R I C E → score} | {commento (cerimonia)}<br>{…} |

### Backlog prioritizzato
| # | ID | Iniziativa | Scadenza | RICE | Commenti |
|---|---|---|---|---|---|
| {rango} | {short_ref} | {summary} | {due_date · escalation} | {R I C E → score} | {commento (cerimonia)} |

## Scadenze (prossime {deadline_horizon_weeks} settimane e scadute)
| Data | ID | Iniziativa | Tipo | Stato | Dove è oggi |
|---|---|---|---|---|---|
| {due_date} | {short_ref} | {summary} | mandate / scadenza | {escalation_status} | {bucket del piano / backlog #N / non pianificata} |

## Rilasciato di recente
- {short_ref} · {summary} — in produzione dal {done_at}

---
Come leggere questa roadmap: l'ordine del backlog è quello del RICE
approvato; le uniche date esatte sono scadenze dichiarate; le stime sono
del team tech e portano la dicitura "stima". I commenti vengono dalle
cerimonie indicate tra parentesi.
```

## Regole di composizione

- **Solo dati approvati o registrati.** Piano e RICE: solo ciò che è in
  `product/roadmap/iterations/` e nelle voci approvate di `rice_history`,
  mai una proposta in `pending/`. I commenti vengono dal registro delle
  cerimonie (`decisions.yaml`), che è un fatto registrato, non una
  proposta. Se in `pending/` c'è un `iteration_plan`, un `rice_diff`, uno
  `strategic_exception_flag` o un `mandate_*` che toccherebbero questa
  roadmap, il banner in testa lo dice: la versione successiva uscirà
  all'approvazione (`pending-approval` la rigenera).
- Se l'ultimo piano approvato è più vecchio di 2 settimane, dillo in
  testa.
- Una voce compare **una volta sola**: se è nel piano, sta in "In
  iterazione" e non nel backlog. La sezione "Scadenze" è un indice
  trasversale: ripete la voce con la colonna "Dove è oggi", così una
  scadenza vicina con l'idea ancora in fondo al backlog salta all'occhio.
- Nel backlog, un'idea senza RICE non compare (non è prioritizzata);
  compare invece in "Scadenze" se ha una scadenza dichiarata, con
  "senza RICE" in "Dove è oggi".
- Escludi `declined`, `aborted`, `needs_clarification`, i bug e le idee
  con `backfill_review_needed: true`.
- **I commenti non si scrivono, si citano.** Ogni commento ha una fonte
  nel registro; se una voce non ne ha, la cella resta vuota. Se un
  commento contiene un giudizio su una persona, omettilo e lascia solo
  la parte sulla decisione.
- Le Strategic Exception in `urgent_priority` si mostrano come tali,
  senza nominare chi le ha approvate: quel dato resta nel repo.
