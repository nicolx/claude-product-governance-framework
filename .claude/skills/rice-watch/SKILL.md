---
name: rice-watch
description: Scansiona le idee classification "idea" ancora senza RICE (rice_history vuoto) e segnala da quanto tempo sono ferme e perché, se noto — incluse quelle che aspettano un meeting di approfondimento col richiedente, ricordate con insistenza finché il meeting non avviene. Con lo slot plan dello snapshot segnala anche le idee senza RICE che consumano già capacità del team, e quanta capacità resta libera nel trimestre mentre le idee aspettano di essere quotate. Usala periodicamente e sempre come parte del Backlog Refinement (backlog-refinement la richiama).
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
- **Durante il Backlog Refinement** la logica di questa skill gira
  **inline** nella sweep di apertura di `backlog-refinement` (un solo
  `pull`, un solo `governance-dump.sh sweep`, un solo commit per tutte le
  watch — vedi playbook, "La sweep di apertura dev'essere calcolo, non
  attesa di I/O"). Non invocarla da lì. Questo file resta il punto
  d'ingresso **standalone** e la fonte normativa delle formule di seguito.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** scrivere su
> `product/` (nemmeno `rice_status.flagged_since`/`blocked_reason`/
> `waiting_on`/`deep_dive.*`), **non** invocare `governance-sync.sh push`,
> mostra come testo l'output completo che avresti prodotto, e chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`

0. **Sincronizza e leggi in blocco** (uso standalone): `bash
   .claude/hooks/governance-sync.sh pull`, poi `bash
   .claude/hooks/governance-dump.sh sweep` — tutte le `idea.yaml` e
   l'ultimo snapshot approvato (lo `slot_plan`) in un colpo. Non vuoi segnalare come "senza RICE" un'idea che un collega ha
   già quotato in locale e non hai ancora ricevuto.

1. **Elenca tutte le idee** (dal dump) con `classification: idea` (bug,
   strategic_exception e mandate non
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

   Se `rice_status.deep_dive.needed` è `true` e `deep_dive.done_at` è
   ancora `null`, lo stato è **`needs_deep_dive: {richiedente}`** —
   categoria a sé, la più actionable: non aspetta un dato che arriverà
   da solo, aspetta **una riunione che il PM deve organizzare**. Se
   `deep_dive.requested_at` risale a più di ~2 settimane fa e
   `scheduled_for` è ancora `null`, marcala **in ritardo**: il meeting è
   stato riconosciuto necessario e non è ancora nemmeno in calendario.
   Leggi anche il registro `discovery/questions.yaml` dell'idea, se
   esiste (playbook, "Discovery socratica: le domande agli
   stakeholder"): se non ha domande di fase `deep_dive`, il meeting
   partirebbe vuoto — raccomanda `discovery-questions {ID}`; se ha un
   incontro `held` non ancora `ingested`, o `done_at` valorizzato senza
   risposte registrate, lo stato è **`deep_dive_not_ingested`**: il
   meeting c'è stato ma le risposte non sono arrivate ai materiali né al
   RICE — raccomanda `discovery-questions {ID} recepisci`, poi
   `rice-update`.

3. **Per le idee che rilevi per la prima volta come non quotate**
   (`rice_status.flagged_since` ancora `null`), scrivi
   `flagged_since` con la data odierna — è un fatto osservato (prima
   volta rilevata così), non una decisione, quindi **non passa da
   `product/approvals/pending/`**.

4. **Per le idee `aging` o `stale` senza `blocked_reason`/`waiting_on`
   già noti, chiedi al PM** (non presumere): "Sai perché questa idea non
   ha ancora un RICE? Manca qualcosa da uno stakeholder, o serve una
   riunione di approfondimento col richiedente?" Se la risposta
   identifica un'informazione mancante e chi dovrebbe fornirla, scrivi
   `blocked_reason`/`waiting_on`. Se identifica che **serve un meeting
   col richiedente**, scrivi `rice_status.deep_dive.needed: true` e
   `requested_at` (oggi, se non già valorizzato da un `requester_reply`
   generato all'intake). Se il PM dice che il meeting è fissato o è
   avvenuto, scrivi `scheduled_for`/`done_at`. Tutti cattura di contesto,
   non passano da approvazione. Se il PM non lo sa, lascia `null` e
   segnalalo comunque nel riepilogo — non forzare una risposta che non
   c'è.

4b. **Incrocia con lo slot plan** dell'ultimo snapshot approvato
   (playbook, "Capacità del team e slot della roadmap") — due segnali,
   nessuna scrittura:
   - **Consuma capacità senza RICE.** Un'idea di questa lista che ha uno
     slot attivo (in `slot_plan.slots`, tipicamente `status: committed`:
     è in sviluppo perché la riconciliazione con il tracker l'ha trovata
     già partita) occupa capacità del team **senza essere mai stata
     prioritizzata**. Mostrala con il suo carico per competenza
     (`load_by_competency`) e la fine stimata: non è più "un'idea che
     aspetta", è lavoro in corso che il RICE non ha mai visto. Va quotata
     per prima (`rice-update`), o il PM dichiara perché no.
   - **Capacità libera mentre si aspetta.** Da
     `slot_plan.saturation_by_month`: le competenze sotto il 70% di
     saturazione nei prossimi mesi, con le persona-settimane libere
     (offerta − domanda). Se ci sono, mettilo in testa al riepilogo
     accanto al numero di idee `stale`/`needs_deep_dive`: *"Nei prossimi
     due mesi restano ~9 persona-settimane libere (frontend 6, qa 3) e 5
     idee aspettano un RICE da oltre 21 giorni"*. Non dice quali idee
     riempirebbero quello spazio (senza stima non si sa): dice che
     sbloccarle ora ha un valore concreto.
   Se non c'è uno snapshot con `slot_plan`, salta il passo e dillo in una
   riga.

5. **Presenta un riepilogo ordinato per urgenza**: in testa la riga di
   capacità libera del passo 4b, se c'è; poi le idee che **consumano
   capacità senza RICE**; poi le **`needs_deep_dive`** (specie quelle in ritardo — il meeting è
   riconosciuto necessario ma non ancora in calendario) e le
   **`deep_dive_not_ingested`**, poi `stale`,
   poi `blocked_on`, poi `aging`, `fresh` solo se rilevante o richiesto.
   **Prima colonna: l'identificatore** — `short_ref` se assegnato,
   altrimenti lo slug `idea_id` (mai vuoto — vedi playbook, "Ogni elenco
   prodotto dal sistema è indirizzabile"), così il PM può riferirsi a una
   riga con "{ID}". Poi `summary`, R · I · C · E e RICE — qui per
   definizione "—" / `senza RICE`, ma le colonne restano (playbook, "Ogni riga che parla di un'idea si capisce da sola"); poi `title`, giorni fermi,
   `blocked_reason`/`waiting_on`, e per le `needs_deep_dive` chi è il
   richiedente da coinvolgere e da quanto il meeting è in sospeso. **Solo
   segnalazione — nessuna azione automatica**: non lanciare tu stessa
   `rice-update`, non contattare stakeholder, non fissare tu il meeting
   né proporre comunicazioni. La decisione su come sbloccarle resta del
   PM.

6. Se chiamata da `backlog-refinement`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa nel file
   `decisions.yaml` della cerimonia, è compito di `log-ceremony`.

7. **Sincronizza il repo**: se i passi 3-4 hanno scritto almeno un
   `idea.yaml`, esegui
   `bash .claude/hooks/governance-sync.sh push "rice-watch: aggiornati rice_status" product/ideas/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)") — anche se
   richiamata da `backlog-refinement`.

## Cosa NON fare

- Non stimare tu né il RICE né la delivery di un'idea per collocarla
  nella capacità libera: lo slot si ricava solo da stime del team, dopo
  il RICE.
- Non stimare tu un RICE "provvisorio" per sbloccare la segnalazione —
  un RICE inventato per completare lo schema è esattamente il rischio
  che il principio garantista di `idea-intake`/`rice-update` vuole
  evitare.
- Non silenziare un'idea `stale` solo perché è già stata segnalata in un
  run precedente — resta visibile finché non ottiene un RICE reale.
- Non includere bug, strategic exception o mandate in questa scansione:
  non hanno mai un RICE per disegno, non sono "in ritardo".
