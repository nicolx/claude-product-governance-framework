---
name: rice-watch
description: Scansiona le idee classification "idea" ancora senza RICE (rice_history vuoto) e segnala da quanto tempo sono ferme e perché, se noto — per non perdere idee che restano senza quotazione in attesa di informazioni dagli stakeholder. Usala periodicamente e sempre come parte del Backlog Refinement (log-ceremony la richiama).
---

# rice-watch

Un'idea `classification: idea` nasce con `rice_history: []` — è normale,
il RICE si scorer in un passo successivo (playbook, "Ideas
prioritization"). Il problema è quando quel passo non arriva mai: l'idea
resta nel bucket, dimenticata, spesso perché manca un'informazione da
uno stakeholder per calibrare Reach o Impact, non per semplice
disattenzione. Questa skill è il meccanismo che impedisce che succeda in
silenzio.

## Quando usarla

- **Standalone**, in qualunque momento: "quali idee non hanno ancora un
  RICE?", "siamo in attesa di info da qualcuno per quotare qualcosa?".
- **Richiamata da `log-ceremony`** durante il Backlog Refinement — stesso
  principio di `mandate-watch`: il controllo deve avvenire ad ogni ciclo
  settimanale, non solo quando qualcuno se ne ricorda.

## Passi

1. **Elenca tutte le idee** in `product/ideas/*/idea.yaml` con
   `classification: idea` (bug, strategic_exception e mandate non
   passano mai dal RICE per disegno — non sono "in ritardo", sono
   strutturalmente esenti, non includerle) e `rice_history` vuoto. Se
   non ce ne sono, dillo esplicitamente e fermati.

2. **Per ciascuna, calcola da quanto tempo è ferma** (oggi -
   `created_at`, o - `rice_status.flagged_since` se già presente da un
   run precedente — usa la data più vecchia disponibile, non azzerare il
   conteggio ad ogni run). Classifica (soglie indicative, adattabili se
   l'istanza ne discute di diverse in una cerimonia):
   - **`fresh`** — meno di 7 giorni. Normale, non richiede azione.
   - **`aging`** — 7-21 giorni. Da controllare, non ancora urgente.
   - **`stale`** — oltre 21 giorni. A rischio concreto di essere persa,
     va segnalata con forza.

   Se `rice_status.waiting_on` è già valorizzato (bloccata da un'attesa
   nota), lo stato da mostrare è **`blocked_on: {waiting_on}`**
   indipendentemente dall'anzianità — non è la stessa cosa di una stale
   dimenticata, è un'attesa esplicita e motivata.

3. **Per le idee che rilevi per la prima volta come non quotate**
   (`rice_status.flagged_since` ancora `null`), scrivi
   `flagged_since` con la data odierna — è un fatto osservato (prima
   volta rilevata così), non una decisione, quindi **non passa da
   `product/approvals/pending/`**.

4. **Per le idee `aging` o `stale` senza `blocked_reason`/`waiting_on`
   già noti, chiedi al PM** (non presumere): "Sai perché questa idea non
   ha ancora un RICE? Manca qualcosa da uno stakeholder?" Se la risposta
   identifica un'informazione mancante e chi dovrebbe fornirla, scrivi
   `blocked_reason`/`waiting_on` — anche questi sono cattura di contesto,
   non passano da approvazione. Se il PM non lo sa o non ha ancora
   avuto modo di verificarlo, lascia `null` e segnalalo comunque nel
   riepilogo: non forzare una risposta che non c'è.

5. **Presenta un riepilogo ordinato per urgenza** (`stale` prima, poi
   `blocked_on`, poi `aging`, `fresh` solo se rilevante o richiesto
   esplicitamente): per ciascuna, `idea_id`, `title`, giorni fermi,
   `blocked_reason`/`waiting_on` se noti. **Solo segnalazione — nessuna
   azione automatica**: non lanciare tu stessa `rice-update`, non
   contattare stakeholder, non proporre comunicazioni. La decisione su
   come sbloccarle resta del PM.

6. Se chiamata da `log-ceremony`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa nel file
   `decisions.yaml` della cerimonia, è compito di `log-ceremony`.

## Cosa NON fare

- Non stimare tu un RICE "provvisorio" per sbloccare la segnalazione —
  un RICE inventato per completare lo schema è esattamente il rischio
  che il principio garantista di `idea-intake`/`rice-update` vuole
  evitare.
- Non silenziare un'idea `stale` solo perché è già stata segnalata in un
  run precedente — resta visibile finché non ottiene un RICE reale.
- Non includere bug, strategic exception o mandate in questa scansione:
  non hanno mai un RICE per disegno, non sono "in ritardo".
