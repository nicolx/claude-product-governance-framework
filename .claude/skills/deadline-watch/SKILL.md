---
name: deadline-watch
description: Scansiona tutte le idee (qualunque classification tranne mandate) con un deadline.due_date dichiarato e fa un push esplicito e forte quando mancano 4 settimane o meno, quando per finire in tempo dovrebbe partire entro 4 settimane, o quando lo slot plan dice che con la capacità del team finirà dopo la scadenza — senza mai decidere da sola se bypassare il RICE. Usala periodicamente e sempre come parte del Backlog Refinement, subito dopo mandate-watch (backlog-refinement la richiama).
---

# deadline-watch

Non tutte le iniziative con una scadenza reale sono già `classification:
mandate` (che salta il RICE per definizione — playbook, "Iniziative
Mandatarie") o una `strategic_exception` già invocata per quella
ragione. Un'idea normale può avere un blocco `deadline` dichiarato
(playbook, "Ideas prioritization" -> "Scadenze su idee normali") senza
che questo cambi come compete sul RICE: è un fatto reso visibile, non un
bypass automatico. Questa skill è il meccanismo che impedisce che quella
scadenza passi inosservata mentre l'idea resta tranquilla in un backlog
RICE-ranked — stesso principio di `mandate-watch`, applicato a un caso
più comune e più facile da perdere perché non salta subito all'occhio
come un mandate dichiarato.

**A 4 settimane dalla scadenza, questa skill deve fare un push forte** —
non una riga tra le altre nel riepilogo (vedi passo 4). Aspettare che
qualcuno se ne accorga da solo è esattamente il fallimento che questa
skill esiste per evitare.

Le 4 settimane di calendario però non bastano: un'idea con 10 settimane
di lavoro e la scadenza tra 8 è già persa, anche se il calendario la dà
`on_track`. Per questo la watch guarda anche **quanto lavoro c'è** (la
durata stimata → l'ultimo inizio utile, `start_by`) e **quando il team
riesce davvero a farlo** (lo `slot_plan` dell'ultimo snapshot approvato,
playbook "Capacità del team e slot della roadmap"). Una scadenza che lo
slot plan manca è `at_risk` con settimane, a volte mesi, di anticipo —
il momento in cui le tre strade del passo 4 costano ancora poco.

## Quando usarla

- **Standalone**, in qualunque momento: "quali idee hanno una scadenza in
  arrivo?", "rischiamo di perdere qualche finestra?".
- **Durante il Backlog Refinement** la logica di questa skill gira
  **inline** nella sweep di apertura di `backlog-refinement` (che fa un
  solo `pull`, un solo `governance-dump.sh sweep` e un solo commit per
  tutte le watch — vedi playbook, "La sweep di apertura dev'essere
  calcolo, non attesa di I/O"). Non invocare questa skill da lì. Questo
  file resta il punto d'ingresso **standalone** e la fonte normativa
  delle formule di seguito.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** scrivere su
> `product/` (nemmeno `deadline.escalation_status`), **non** invocare
> `governance-sync.sh push`, mostra come testo l'output completo che
> avresti prodotto, e chiudi con `🔍 DRY-RUN — nessun file scritto,
> nessun commit, nessun push.`

0. **Sincronizza e leggi in blocco** (uso standalone): `bash
   .claude/hooks/governance-sync.sh pull`, poi `bash
   .claude/hooks/governance-dump.sh sweep` — tutte le `idea.yaml`,
   `team.yaml` (per `analysis_lead_weeks`) e l'ultimo snapshot approvato
   (lo `slot_plan`) in un colpo invece di leggerli uno per uno.

1. **Elenca tutte le idee** (dal dump) con `deadline.due_date` valorizzato
   e `status` diverso da `done` o `aborted`. Includi qualunque `classification` — `idea`,
   `strategic_exception`, `platform` — **ma non `mandate`**: quelle hanno
   già `mandate-watch` con la propria logica di lead time; includerle qui
   duplicherebbe il segnale. Se non ce ne sono, dillo esplicitamente e
   fermati — è uno stato normale, non un errore.

2. **Per ciascuna, calcola `start_by` ed `escalation_status`**.
   - **`start_by`** (se l'idea ha `delivery.estimated_effort_weeks`, o
     `platform.estimated_effort_weeks`): `due_date` − durata, meno
     `capacity.analysis_lead_weeks` di `team.yaml` (default 2) se l'idea
     non è ancora `in_analysis` o oltre. Senza stima di durata: `null`.
   - **Lo slot**: cerca l'idea nello `slot_plan` dell'ultimo snapshot
     approvato (`slots`, poi `unslotted`).
   Poi lo stato, nel primo caso che si applica (e `escalation_basis`
   che dice quale):
   - **`overdue`** — `due_date` è già passata e lo `status` dell'idea non
     ha ancora raggiunto almeno `in_jira`. (`calendar`)
   - **`due_soon`** — mancano **4 settimane o meno** alla `due_date`
     (`calendar`), **oppure** `start_by` cade entro 4 settimane da oggi
     e l'idea non è ancora in sviluppo (`start_by`): per finire in tempo
     deve partire adesso.
   - **`at_risk`** — lo slot finisce **dopo** la `due_date`
     (`end_week` > settimana della `due_date`), oppure la `due_date` cade
     nell'orizzonte dello slot plan e l'idea è in `unslotted` come
     `beyond_horizon` o `infeasible` (`slot`): con la capacità che il
     team ha, e nell'ordine di priorità attuale, non ci arriva.
   - **`on_track`** — nessuno dei casi sopra.
   Un'idea **non dimensionata** (nessuna stima, quindi né `start_by` né
   slot) resta sulla sola regola di calendario: segnalala nel riepilogo
   ("scadenza il {due_date}, nessuna stima — non si sa se ci sta"),
   perché è proprio il caso che il calendario da solo non vede. Se
   `team.yaml` non ha capacità o non c'è uno snapshot con `slot_plan`, la
   regola `slot` non si applica: dillo una volta in testa al riepilogo.
   Lo slot plan è quello **dell'ultimo snapshot approvato** (di solito la
   settimana precedente): non ricalcolarlo qui.

3. **Scrivi `escalation_status`, `escalation_basis` e `start_by`
   direttamente** su ciascun `idea.yaml` —
   è un fatto calcolato da una formula, non una decisione di priorità,
   quindi **non passa da `product/approvals/pending/`** (stesso principio
   di `mandate.escalation_status`).

4. **Per ogni idea `due_soon` o `overdue`, fai un push esplicito e
   forte.** Non annegarlo nel riepilogo finale: interrompi con una
   domanda diretta, per ciascuna idea, mostrando lo stato attuale (RICE
   score e posizione approssimativa in backlog se `classification: idea`;
   stato della Strategic Exception se `classification: strategic_exception`):

   > "⏰ L'idea «{title}» ({idea_id}) ha una scadenza il {due_date} —
   > mancano {N} settimane (o: è scaduta da {N} settimane). È ancora nel
   > processo RICE normale (score {score}, posizione ~{rank} in backlog)
   > e a questo ritmo rischia di non essere presa in carico in tempo.
   > Vuoi: (a) invocare una Strategic Exception, (b) valutare se soddisfa
   > davvero i criteri di Iniziativa Mandataria (playbook, «Iniziative
   > Mandatarie») e farla riclassificare, o (c) lasciarla nel processo
   > normale perché la scadenza non è così rigida?"

   Per `escalation_basis: start_by` o `slot` la prima frase dice il
   motivo reale, non il calendario:

   > "⏰ L'idea «{title}» ({idea_id}) ha una scadenza il {due_date}. Con
   > {N} settimane di lavoro stimate dovrebbe partire entro il
   > {start_by}" — oppure — "Con la capacità attuale del team, lo slot
   > plan la fa finire in {end_week} (stima), dopo la scadenza{, per la
   > capacità {delayed_by}}" — "oppure: non trova spazio nel trimestre."

   e alle tre strade aggiunge una quarta, che spesso è la più economica:
   **(d) ridurre lo scope** (80/20) o **anticiparla nel piano** — da
   portare al prossimo Backlog Refinement o Iteration Planning, dove si
   decide l'ordine.

   **Solo segnalazione — nessuna azione automatica**: non invocare tu
   stessa una Strategic Exception, non riclassificare a `mandate`, non
   toccare il RICE. La decisione resta del PM:
   - se sceglie (a), indirizzalo al meccanismo esistente per una
     Strategic Exception (`backlog-refinement` se nasce in cerimonia, o
     conferma diretta con `approved_by`/`reason` se immediata);
   - se sceglie (b), prepara una proposta `type: mandate_reclassification`
     in `product/approvals/pending/` (vedi
     `framework/schema/approval.template.yaml`) — non applicarla da sola;
   - se sceglie (c), non fare nulla: la scadenza resta visibile e
     continuerà a essere segnalata ai run successivi finché non cambia
     stato;
   - se sceglie (d), annotalo come azione aperta per la prossima
     cerimonia — non cambi tu né la stima né il piano.

5. **Presenta un riepilogo ordinato per urgenza** (`overdue` prima, poi
   `due_soon`, poi `at_risk`, poi `on_track` solo se richiesto
   esplicitamente). **Prima
   colonna: l'identificatore** — `short_ref` se assegnato, altrimenti lo
   slug `idea_id` (mai vuoto — vedi playbook, "Ogni elenco prodotto dal
   sistema è indirizzabile"), così il PM può riferirsi a una riga con
   "{ID}". Poi `summary`, R · I · C · E e RICE ("—" e il motivo se senza
   RICE — playbook, "Ogni riga che parla di un'idea si capisce da sola"), `due_date`, `escalation_status` con
   `escalation_basis`, `start_by` e la fine stimata dallo slot (o
   "nessuna stima").

6. Se chiamata da `backlog-refinement`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa in
   `decisions.yaml`, è compito di `log-ceremony`.

7. **Sincronizza il repo**: se il passo 3 ha scritto almeno un
   `idea.yaml`, esegui
   `bash .claude/hooks/governance-sync.sh push "deadline-watch: aggiornati escalation_status" product/ideas/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)") — anche se
   richiamata da `backlog-refinement`.

## Cosa NON fare

- Non decidere autonomamente di invocare una Strategic Exception o di
  riclassificare un'idea a `mandate` — questa skill segnala con forza,
  non agisce.
- Non presumere `due_date`/`note` se non dichiarati esplicitamente dal
  PM — se `deadline.due_date` è `null`, l'idea semplicemente non entra in
  questa scansione, non è un errore da correggere o un valore da
  inventare per farla comparire.
- Non includere le idee `classification: mandate` in questa scansione —
  hanno già `mandate-watch`, con una logica di lead time diversa
  (`analysis_start_by`, non solo `due_date`).
- Non ricalcolare lo slot plan né correggere stime o priorità per far
  rientrare una scadenza: la watch legge lo `slot_plan` approvato e
  segnala; l'ordine e le stime si cambiano in cerimonia.
- Non silenziare un'idea `due_soon`/`at_risk`/`overdue` solo perché è già stata
  segnalata in un run precedente — resta visibile finché lo stato non
  cambia (riclassificata, in `in_jira`/`done`, o il PM ha esplicitamente
  chiarito che la scadenza non è più rilevante e ha svuotato
  `deadline.due_date`).
- Non annacquare il push del passo 4 in una riga generica — è la parte
  che fa funzionare questa skill: a 4 settimane deve essere impossibile
  da non notare.
