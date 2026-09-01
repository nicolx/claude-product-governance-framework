---
name: deadline-watch
description: Scansiona tutte le idee (qualunque classification tranne mandate) con un deadline.due_date dichiarato e fa un push esplicito e forte quando mancano 4 settimane o meno — senza mai decidere da sola se bypassare il RICE. Usala periodicamente e sempre come parte del Backlog Refinement, subito dopo mandate-watch (log-ceremony la richiama).
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

## Quando usarla

- **Standalone**, in qualunque momento: "quali idee hanno una scadenza in
  arrivo?", "rischiamo di perdere qualche finestra?".
- **Richiamata da `log-ceremony`** durante il Backlog Refinement, subito
  dopo `mandate-watch` — stesso principio: il controllo deve avvenire ad
  ogni ciclo settimanale, non solo quando qualcuno se ne ricorda.

## Passi

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)") prima di scansionare —
   uno scan su dati locali vecchi rischia di mancare una scadenza che un
   collega ha già dichiarato.

1. **Elenca tutte le idee** in `product/ideas/*/idea.yaml` con
   `deadline.due_date` valorizzato e `status` diverso da `done` o
   `aborted`. Includi qualunque `classification` — `idea`,
   `strategic_exception`, `platform` — **ma non `mandate`**: quelle hanno
   già `mandate-watch` con la propria logica di lead time; includerle qui
   duplicherebbe il segnale. Se non ce ne sono, dillo esplicitamente e
   fermati — è uno stato normale, non un errore.

2. **Per ciascuna, calcola `escalation_status`** confrontando `due_date`
   con oggi:
   - **`overdue`** — `due_date` è già passata e lo `status` dell'idea non
     ha ancora raggiunto almeno `in_jira`.
   - **`due_soon`** — mancano **4 settimane o meno**. Questa è la soglia
     che conta per il push del passo 4.
   - **`on_track`** — mancano più di 4 settimane.

3. **Scrivi `escalation_status` direttamente** su ciascun `idea.yaml` —
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

   **Solo segnalazione — nessuna azione automatica**: non invocare tu
   stessa una Strategic Exception, non riclassificare a `mandate`, non
   toccare il RICE. La decisione resta del PM:
   - se sceglie (a), indirizzalo al meccanismo esistente per una
     Strategic Exception (`log-ceremony` se nasce in cerimonia, o
     conferma diretta con `approved_by`/`reason` se immediata);
   - se sceglie (b), prepara una proposta `type: mandate_reclassification`
     in `product/approvals/pending/` (vedi
     `framework/schema/approval.template.yaml`) — non applicarla da sola;
   - se sceglie (c), non fare nulla: la scadenza resta visibile e
     continuerà a essere segnalata ai run successivi finché non cambia
     stato.

5. **Presenta un riepilogo ordinato per urgenza** (`overdue` prima, poi
   `due_soon`, poi `on_track` solo se richiesto esplicitamente).

6. Se chiamata da `log-ceremony`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa in
   `decisions.yaml`, è compito di `log-ceremony`.

7. **Sincronizza il repo**: se il passo 3 ha scritto almeno un
   `idea.yaml`, esegui
   `bash .claude/hooks/governance-sync.sh push "deadline-watch: aggiornati escalation_status" product/ideas/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)") — anche se
   richiamata da `log-ceremony`.

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
- Non silenziare un'idea `due_soon`/`overdue` solo perché è già stata
  segnalata in un run precedente — resta visibile finché lo stato non
  cambia (riclassificata, in `in_jira`/`done`, o il PM ha esplicitamente
  chiarito che la scadenza non è più rilevante e ha svuotato
  `deadline.due_date`).
- Non annacquare il push del passo 4 in una riga generica — è la parte
  che fa funzionare questa skill: a 4 settimane deve essere impossibile
  da non notare.
