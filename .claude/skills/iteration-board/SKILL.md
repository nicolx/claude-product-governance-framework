---
name: iteration-board
description: Mostra il Piano di Iterazione della settimana (product/roadmap/iterations/) come vista a colpo d'occhio — i quattro bucket (analisi da avviare, analisi in corso, in sviluppo, prioritizzate d'urgenza) più il diff rispetto alla settimana precedente (completate / avanzate / slittate / rimosse / nuove). Sola lettura, non scrive nulla. Usala per il daily standup, la mail settimanale, Confluence — "cosa stiamo facendo questa settimana?".
---

# iteration-board

Rende leggibile il **Piano di Iterazione** — l'output primario del Backlog
Refinement (`framework/schema/iteration-plan.template.yaml`). È a
`backlog-list` quello che il piano è al backlog: la vista che risponde a
"su cosa lavora il team questa settimana" senza aprire lo YAML.

È **sola lettura** — legge `product/roadmap/iterations/*.yaml` (e, per il
diff, il piano precedente). Non scrive nulla, non applica approvazioni,
non richiama skill di scrittura.

> **Dry-run.** Questa skill è già read-only: in dry-run si comporta
> identica (nessuna scrittura, nessun commit da fare). Se invocata con
> `dry-run`, chiudi comunque con la riga
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`

## Passi

0. **Sincronizza e leggi in blocco**: `bash
   .claude/hooks/governance-sync.sh pull` (una vista su dati vecchi è
   fuorviante), poi `bash .claude/hooks/governance-dump.sh iterations` —
   gli ultimi due piani di iterazione (corrente + `based_on`) in una tool
   call. Aggiungi `governance-dump.sh pending` se devi controllare una
   proposta `iteration_plan` non ancora approvata.

1. **Determina il piano da mostrare.**
   - Di default: il file `product/roadmap/iterations/{YYYY-Www}.yaml` con
     settimana ISO più recente.
   - Se l'utente indica una settimana, quello.
   - Se in `product/roadmap/iterations/` non c'è nulla ma esiste una
     proposta `type: iteration_plan` in `product/approvals/pending/`,
     mostrala **marcandola chiaramente come non ancora approvata** (il
     Backlog Refinement l'ha proposta, nessuno l'ha approvata): il piano
     "ufficiale" non esiste ancora.
   - Se non c'è né file né proposta: dillo esplicitamente e fermati — è
     uno stato normale se il primo Backlog Refinement non è ancora
     avvenuto, non un errore.

2. **Rendi i quattro bucket**, in quest'ordine, come tabella o blocco
   compatto — una riga per voce:
   1. **Analisi da avviare** (`analysis_todo`) — `idea_ref`, `summary`,
      `rice_score` (o "mandate"/"—" se senza RICE), `why_now`.
   2. **Analisi in corso** (`analysis_in_progress`) — `idea_ref`,
      `summary`, `since`, `weeks_in_bucket` (evidenzia se ≥ 3), `note`.
   3. **In sviluppo** (`in_development`) — `idea_ref`, `summary`,
      `jira_card_id`, `jira_status`, `completion_pct` se presente.
   4. **Prioritizzate d'urgenza** (`urgent_priority`) — `idea_ref`,
      `kind`, `trigger`, `decided`; per `kind: strategic_exception`
      segnala `approved_by` (o "✋ bypass non ancora confermato" se
      `null`).
   Apri con `iteration_goal` in testa e la settimana. **Prima colonna:
   l'identificatore** `idea_ref` (short_ref); se una voce non ce l'ha, lo
   slug — mai vuoto (playbook, "Ogni elenco prodotto dal sistema è
   indirizzabile").

3. **Mostra il diff `changes_since_last`** come riga/sezione finale:
   *completate N · avanzate N · slittate N · rimosse N · nuove N*, con
   l'elenco delle voci per ciascuna categoria. Se `based_on` è `null`
   (primo piano), scrivi "primo piano — tutto nuovo". Le **slittate** e le
   **rimosse** vanno rese visibili, non nascoste: sono il segnale che il
   piano esiste per dare.

4. Se la vista è richiesta per una comunicazione (mail, Confluence),
   producila in Markdown pulito pronto da incollare — ma **non inviare
   nulla** e non prepararne una proposta `outbound_comm`: è il PM a
   decidere se e dove pubblicarla (stessa logica di `demo-capture` e
   `requester_reply`).

5. **Non proporre azioni.** Questa skill fotografa, non decide. Se emerge
   qualcosa da fare (una voce slittata da settimane, una SE senza
   approvazione), dillo come osservazione e rimanda alla skill giusta
   (`pending-approval`, `backlog-refinement`) — non lanciarla tu.

## Cosa NON fare

- Non scrivere su nessun file, non fare commit/push — è sola lettura.
- Non ricalcolare `changes_since_last`, `weeks_in_bucket`, `rice_score`:
  leggi i valori già persistiti nel file di iterazione (li calcola
  `backlog-refinement` al passo 6).
- Non fondere i quattro bucket in un unico elenco ordinato per "priorità":
  sono stati diversi del lavoro, non una classifica.
- Non presentare una proposta `iteration_plan` ancora in `pending/` come
  se fosse il piano approvato — marcala sempre come non ufficiale.
- Non inventare un `summary`/`why_now` mancante — segnalalo come gap.
