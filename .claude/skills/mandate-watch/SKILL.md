---
name: mandate-watch
description: Scansiona tutte le idee classification "mandate" (iniziative top-down, "critical" da leadership, o con scadenza esterna fissa) e calcola/aggiorna il loro escalation_status in base al lead time necessario prima della due_date. Usala periodicamente e sempre come parte del Backlog Refinement (backlog-refinement la richiama).
---

# mandate-watch

Le iniziative `classification: mandate` (playbook, sezione "Iniziative
Mandatarie") non passano dal RICE, ma devono comunque entrare in analisi
**con anticipo sufficiente** rispetto a una eventuale scadenza esterna.
Questa skill è il meccanismo che garantisce che non vengano dimenticate
finché non è troppo tardi: calcola per ciascun mandate aperto se è ancora
in tempo, a rischio, o già in ritardo — e lo rende visibile, senza mai
agire da sola sulla priorità.

## Quando usarla

- **Standalone**, in qualunque momento: "controlla lo stato dei mandate",
  "siamo a rischio su qualche scadenza mandataria?".
- **Richiamata da `backlog-refinement`** durante il Backlog Refinement — è così
  che il controllo avviene ad ogni ciclo settimanale, non solo quando
  qualcuno se ne ricorda.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** scrivere su
> `product/` (nemmeno i fatti calcolati come `escalation_status`/
> `analysis_start_by`), **non** invocare `governance-sync.sh push`, mostra
> come testo l'output completo che avresti prodotto, e chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)") prima di leggere le idee —
   uno scan su dati locali vecchi rischia falsi `overdue`/`due_soon` su
   mandate che un collega ha già mosso avanti.

1. **Elenca tutte le idee** in `product/ideas/*/idea.yaml` con
   `classification: mandate` e `status` diverso da `done` o `aborted`.
   Se non ce ne sono, dillo esplicitamente e fermati — non è un errore,
   è uno stato normale. Le idee `classification: idea`/
   `strategic_exception` con solo un blocco `deadline` (non ancora
   riclassificate a `mandate`) **non** rientrano qui: le copre
   `deadline-watch`.

2. **Per ciascuna, calcola `escalation_status`**:
   - Se `due_date` o `lead_time_weeks` sono `null`: `escalation_status:
     pending_review`. Questo è lo stato di default per i mandate
     "critical" senza scadenza fissa (`is_critical: true`, `due_date:
     null`) — **non è un errore da correggere subito**, ma va comunque
     rimenzionato esplicitamente ad ogni run finché qualcuno non lo
     risolve (aggiungendo una data, o confermando che non ne serve una).
     Non silenziarlo dopo la prima segnalazione.
   - Se entrambi sono noti: calcola `analysis_start_by = due_date -
     lead_time_weeks` (in settimane). Poi:
     - `overdue` — `analysis_start_by` è già passata E lo `status`
       dell'idea non ha ancora raggiunto almeno `in_analysis`.
     - `due_soon` — mancano 2 settimane o meno ad `analysis_start_by` (o
       è già passata ma l'idea è già almeno `in_analysis` — la scadenza
       resta da sorvegliare, ma l'analisi è partita).
     - `on_track` — mancano più di 2 settimane ad `analysis_start_by`.

3. **Scrivi `analysis_start_by` e `escalation_status` direttamente** su
   ciascun `idea.yaml` — sono fatti calcolati da una formula, non
   decisioni di prodotto, quindi **non passano da
   `product/approvals/pending/`** (stesso principio già usato per
   `jira.status`/`jira.last_polled_at` nella skill `jira-sync`). Non
   toccare mai `due_date`, `lead_time_weeks`, `mandated_by`, `rationale`,
   `is_critical` — quelli si modificano solo via proposta
   `mandate_update` (skill che gestisce il caso, tipicamente
   `idea-intake`/`inbox-triage` alla creazione, o una richiesta esplicita
   dell'utente per un aggiornamento).

4. **Presenta un riepilogo ordinato per urgenza** (`overdue` prima,
   poi `due_soon`, poi `pending_review`, poi `on_track` solo se
   rilevante): per ciascun mandate a rischio, mostra `short_ref` se
   presente, `idea_id`, `mandated_by`, `due_date`, `analysis_start_by`,
   lo `status` corrente
   dell'idea. **Solo segnalazione — nessuna azione automatica**: non
   proporre né inviare comunicazioni di escalation da questa skill, la
   decisione su come/se sollecitare resta interamente del PM.

5. Se chiamata da `backlog-refinement`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa nel file
   `decisions.yaml` della cerimonia, è compito di `log-ceremony`.

6. **Sincronizza il repo**: se il passo 3 ha scritto almeno un
   `idea.yaml`, esegui
   `bash .claude/hooks/governance-sync.sh push "mandate-watch: aggiornati escalation_status" product/ideas/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)") — anche se
   la skill è stata richiamata da `backlog-refinement`: le scritture su
   `idea.yaml` vanno sincronizzate subito, non aspettano il commit finale
   della cerimonia.

## Cosa NON fare

- Non decidere autonomamente di anticipare o modificare la roadmap in
  base a un mandate a rischio — questa skill segnala, non prioritizza.
- Non proporre comunicazioni di escalation (email, Slack) — per questo
  framework è deliberatamente fuori scope: la segnalazione forte in
  conversazione/log è sufficiente, l'escalation a stakeholder esterni
  resta una scelta del PM.
- Non silenziare un mandate `pending_review` solo perché è già stato
  segnalato in un run precedente.
