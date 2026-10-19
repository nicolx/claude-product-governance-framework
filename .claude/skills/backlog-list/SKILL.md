---
name: backlog-list
description: Mostra il backlog delle idee ordinato per RICE score, con — per ciascuna — descrizione sommaria, eventuale scadenza, note utili a decidere se prioritizzare, flag di bypass (mandate/strategic exception) e quando può partire con il team attuale (slot dallo slot plan dello snapshot, collo di bottiglia per competenza). Sezioni separate per le proposte RICE ancora in coda di approvazione, le idee senza RICE e gli scarti recenti. Sola lettura, non scrive nulla. Usala quando serve "la lista delle idee ordinate".
---

# backlog-list

Produce la vista ordinata del backlog. È **sola lettura** — legge
`idea.yaml`, `product/approvals/pending/` e lo `slot_plan` dell'ultimo
snapshot approvato, non scrive nulla, non applica
approvazioni, non richiama skill di scrittura. Serve a rispondere a "cosa
c'è in cima e perché", con abbastanza contesto da decidere senza aprire
ogni cartella.

Un RICE score da solo non basta per decidere: il playbook ("Ideas
prioritization") è esplicito che la scadenza, la comprensione di cosa
c'è da fare e le note di contesto contano quanto il numero. Questa skill
li mette tutti sulla stessa riga — insieme a **quando** l'idea può
partire con il team che c'è (playbook, "Capacità del team e slot della
roadmap"): il RICE dice in che ordine, lo slot dice se l'ordine si
traduce in qualcosa che parte questo trimestre.

## Passi

0. **Sincronizza e leggi in blocco**: `bash
   .claude/hooks/governance-sync.sh pull` (una vista su dati vecchi è
   fuorviante, e la sezione 2 dipende dalla coda aggiornata), poi `bash
   .claude/hooks/governance-dump.sh backlog` — tutte le `idea.yaml` attive
   + la coda `pending/` + l'ultimo snapshot approvato in **una** tool
   call, invece di glob-e-leggi-ognuna.

0b. **Riga di capacità in testa**, dallo `slot_plan` dello snapshot (se
   c'è e non è vuoto): quante idee del ranking ufficiale hanno uno slot
   nel trimestre, e i colli di bottiglia — le competenze più frequenti in
   `delayed_by` e quelle `over` in `capacity_allocation.by_competency`
   (*"Nel trimestre partono 6 delle 14 idee prioritizzate · backend fa
   slittare 4 idee · snapshot W42"*). Se lo snapshot ha più di 2
   settimane, dillo. Se manca o lo `slot_plan` è vuoto, una riga: "slot
   non disponibili — `roadmap-snapshot`, e `team-roster` se la capacità
   non è dichiarata"; la colonna slot sotto viene omessa.

1. **Idee RICE-ranked.** Elenca tutte le idee `classification: idea` con
   almeno una voce in `rice_history`, **ordinate per lo `score` della
   voce più recente, decrescente**. Per ciascuna mostra, sulla stessa
   riga o in un blocco compatto:
   - `short_ref` come identificatore in **prima colonna** se assegnato
     (es. `PG-042`); se `null`, usa lo slug della cartella — non
     inventarne uno, lo assegna `backlog-refinement`. Mai vuoto (playbook,
     "Ogni elenco prodotto dal sistema è indirizzabile"). Vale per
     **tutte** le sezioni sotto, non solo questa.
   - `reach_points` · `impact_points` · `confidence_score` ·
     `entanglement_score` e `score` (dall'ultima voce di `rice_history`),
     subito dopo `summary` — playbook, "Ogni riga che parla di un'idea si capisce da sola". Nelle sezioni senza RICE
     (bypass, idee non quotate, scarti) le colonne restano, con "—" e il
     motivo, non spariscono
   - `summary` — se vuoto, segnalalo esplicitamente ("⚠ summary
     mancante") invece di inventarlo o di ripetere il `title`
   - **scadenza**: se `deadline.due_date` è valorizzato, mostrala con il
     suo `deadline.escalation_status` (`due_soon`/`at_risk`/`overdue` in evidenza, con `escalation_basis`) e
     `deadline.note`
   - **note di prioritizzazione**: `notes`, più `rice_status.blocked_reason`/
     `waiting_on` se presenti (un'idea RICE-ranked di solito non ne ha,
     ma può capitare dopo una revisione)
   - **referente tecnico**: se `tech_reference` è valorizzato, mostralo
     (è chi valida l'How / prima scelta in assegnazione); se l'idea ha
     già un PRD (`links.prd_ids` non vuoto) ma `tech_reference` è `null`,
     segnalalo come gap
   - flag: `strategic_exceptions` non vuoto (è già passata avanti almeno
     una volta), `links.prd_ids` non vuoto (ha già un PRD), `status`
     corrente, e — se `iteration.current` è valorizzato — "in iterazione
     {settimana} · {iteration.bucket}" (letto dal campo già persistito da
     `pending-approval`, non ricalcolato)
   - **slot**, dallo `slot_plan` (cerca l'idea per `idea_id`): *sviluppo
     W50–W03 (stima)*, con *stima grezza* se `estimate_basis: rough`,
     *slitta per {competenza}* se `delayed_by`, *⚠ oltre la scadenza* se
     `at_risk`; senza slot, il motivo da `unslotted` — *da dimensionare*,
     *oltre il trimestre con il team attuale*, *non fattibile col team
     attuale*, *competenza sconosciuta*; *slot non ancora calcolato* se
     l'idea non compare né in `slots` né in `unslotted`. È la colonna
     che spiega perché un'idea alta nel ranking può partire dopo una più
     bassa (una competenza satura, una stima mancante): rendila
     visibile, non riordinare il ranking per slot
   Se la voce di `rice_history` più recente ha `entanglement_basis:
   structured_estimate`, segnala che lo score poggia su una stima di
   footprint più debole.

2. **Proposte RICE non ancora approvate.** Sezione separata, **subito
   dopo il ranking ufficiale**. Leggi `product/approvals/pending/` per le
   voci `type: rice_diff`: per ciascuna, `short_ref`/slug dell'idea
   (`target_file`), `summary`, R·I·C·E e score correnti (o "—"), i
   parametri e lo `score` **proposti** dal `payload`, da quanto è in
   coda, e — se l'idea è già nel ranking del passo 1 — la differenza
   rispetto allo score attuale. Mostra come si inserirebbero nel ranking
   ("PG-042, proposto 480 → salirebbe al 2° posto"). Se l'idea ha una
   `deadline.due_date` o si presenta come Strategic Exception ancora
   senza voce approvata in `strategic_exceptions`, segnalalo sulla riga —
   è contesto che pesa quanto lo score proposto. **Marca la sezione
   in modo inequivocabile come non ufficiale**: sono numeri proposti, non
   approvati — diventano reali solo passando da `pending-approval`. Se la
   coda è vuota, salta la sezione. Se è lunga (intake storico bulk),
   dillo esplicitamente: è un blocco di prioritizzazione, non un
   dettaglio.

3. **Iniziative fuori RICE ancora aperte.** Sezione separata, non
   mescolata col ranking: `classification: mandate` (con
   `escalation_status` da `mandate-watch`), `classification:
   platform` (con `estimated_effort_weeks` ed `effort_by_competency`),
   e le `strategic_exception` con `status` diverso da `done`/`aborted`/
   `declined`. Queste non hanno uno score — vanno lette per
   scadenza/stato, non per posizione. Se `iteration.current` è
   valorizzato, mostralo qui pure ("in iterazione {settimana} ·
   {bucket}"). Mostra lo **slot** come al passo 1: per un mandate, uno
   slot `at_risk` (finisce oltre la `due_date`) è l'informazione più
   importante della riga.

4. **Idee senza RICE.** Sezione separata: `classification: idea` con
   `rice_history` vuoto **e nessuna proposta `rice_diff` in coda** (se
   ce l'ha, è già alla sezione 2), leggendo `rice_status` (già calcolato
   da `rice-watch`, non ricalcolarlo qui). Per ciascuna: `summary`, da
   quanto è ferma (`flagged_since`), `blocked_reason`/`waiting_on`, e
   **se `rice_status.deep_dive.needed` è true**, marcala chiaramente
   "richiede un meeting con {richiedente}" — è la categoria che
   `rice-watch` sorveglia con più insistenza.

5. **Scarti recenti** (opzionale, solo se richiesto o se ce ne sono di
   recenti). `status: declined` con `decline_reason` — giusto per avere
   memoria di cosa è stato scartato al triage, senza rimetterlo in coda.

6. **Non proporre azioni.** Questa skill fotografa, non decide. Se
   dall'inquadramento emerge qualcosa da fare (un RICE da rivedere, un
   meeting da fissare, una coda di approvazione da svuotare), dillo come
   osservazione e rimanda alla skill giusta (`rice-update`, `rice-watch`,
   `pending-approval`) — non lanciarla tu.

## Cosa NON fare

- Non scrivere su nessun file, non fare commit/push — è sola lettura.
- Non ricalcolare score, `escalation_status`, `rice_status`,
  `iteration.*`, `tech_reference` né gli slot: leggi i valori già
  persistiti dalle skill che li possiedono (gli slot li calcola
  `roadmap-snapshot`). Per una proposta RICE in coda (sezione 2) non
  stimare dove finirebbe lo slot: dipende dall'approvazione e dal
  prossimo snapshot.
- Non riordinare il ranking per slot: l'ordine è quello del RICE, lo
  slot è contesto accanto.
- Non inventare un `summary` mancante — segnalalo come gap.
- Non fondere in un unico elenco le idee RICE-ranked e quelle fuori RICE:
  confrontarle per "posizione" non ha senso, il playbook lo dice
  esplicitamente.
- Non fondere gli score proposti (sezione 2, da `pending/`) col ranking
  ufficiale (sezione 1): restano due sezioni distinte, i proposti marcati
  come non ancora approvati. Non applicare né spostare nulla in
  `pending/` — per quello c'è `pending-approval` (o il passo 3 di
  `backlog-refinement`).
