---
name: backlog-list
description: Mostra il backlog delle idee ordinato per RICE score, con — per ciascuna — descrizione sommaria, eventuale scadenza, note utili a decidere se prioritizzare, e flag di bypass (mandate/strategic exception). Sezioni separate per le idee senza RICE e per gli scarti recenti. Sola lettura, non scrive nulla. Usala quando serve "la lista delle idee ordinate".
---

# backlog-list

Produce la vista ordinata del backlog. È **sola lettura** — non scrive
mai su `idea.yaml`, non passa da `product/approvals/pending/`, non
richiama altre skill di scrittura. Serve a rispondere a "cosa c'è in cima
e perché", con abbastanza contesto da decidere senza aprire ogni
cartella.

Un RICE score da solo non basta per decidere: il playbook ("Ideas
prioritization") è esplicito che la scadenza, la comprensione di cosa
c'è da fare e le note di contesto contano quanto il numero. Questa skill
li mette tutti sulla stessa riga.

## Passi

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)") — una vista del backlog su
   dati locali vecchi è fuorviante.

1. **Idee RICE-ranked.** Elenca tutte le idee `classification: idea` con
   almeno una voce in `rice_history`, **ordinate per lo `score` della
   voce più recente, decrescente**. Per ciascuna mostra, sulla stessa
   riga o in un blocco compatto:
   - `short_ref` come identificatore in testa alla riga se presente (es.
     `PG-042`); se `null`, usa lo slug della cartella — non inventarne
     uno, lo assegna `backlog-refinement`. Vale per **tutte** le sezioni
     sotto, non solo questa.
   - `score` (dall'ultima voce di `rice_history`)
   - `summary` — se vuoto, segnalalo esplicitamente ("⚠ summary
     mancante") invece di inventarlo o di ripetere il `title`
   - **scadenza**: se `deadline.due_date` è valorizzato, mostrala con il
     suo `deadline.escalation_status` (`due_soon`/`overdue` in evidenza) e
     `deadline.note`
   - **note di prioritizzazione**: `notes`, più `rice_status.blocked_reason`/
     `waiting_on` se presenti (un'idea RICE-ranked di solito non ne ha,
     ma può capitare dopo una revisione)
   - flag: `strategic_exceptions` non vuoto (è già passata avanti almeno
     una volta), `links.prd_ids` non vuoto (ha già un PRD), `status`
     corrente
   Se la voce di `rice_history` più recente ha `entanglement_basis:
   structured_estimate`, segnala che lo score poggia su una stima di
   footprint più debole.

2. **Iniziative fuori RICE ancora aperte.** Sezione separata, non
   mescolata col ranking: `classification: mandate` (con
   `escalation_status` da `mandate-watch`), `classification:
   platform` (con `estimated_effort_weeks`), e le `strategic_exception`
   con `status` diverso da `done`/`aborted`/`declined`. Queste non hanno
   uno score — vanno lette per scadenza/stato, non per posizione.

3. **Idee senza RICE.** Sezione separata: `classification: idea` con
   `rice_history` vuoto, leggendo `rice_status` (già calcolato da
   `rice-watch`, non ricalcolarlo qui). Per ciascuna: `summary`, da
   quanto è ferma (`flagged_since`), `blocked_reason`/`waiting_on`, e
   **se `rice_status.deep_dive.needed` è true**, marcala chiaramente
   "richiede un meeting con {richiedente}" — è la categoria che
   `rice-watch` sorveglia con più insistenza.

4. **Scarti recenti** (opzionale, solo se richiesto o se ce ne sono di
   recenti). `status: declined` con `decline_reason` — giusto per avere
   memoria di cosa è stato scartato al triage, senza rimetterlo in coda.

5. **Non proporre azioni.** Questa skill fotografa, non decide. Se
   dall'inquadramento emerge qualcosa da fare (un RICE da rivedere, un
   meeting da fissare), dillo come osservazione e rimanda alla skill
   giusta (`rice-update`, `rice-watch`) — non lanciarla tu.

## Cosa NON fare

- Non scrivere su nessun file, non fare commit/push — è sola lettura.
- Non ricalcolare score, `escalation_status`, `rice_status`: leggi i
  valori già persistiti dalle skill che li possiedono.
- Non inventare un `summary` mancante — segnalalo come gap.
- Non fondere in un unico elenco le idee RICE-ranked e quelle fuori RICE:
  confrontarle per "posizione" non ha senso, il playbook lo dice
  esplicitamente.
