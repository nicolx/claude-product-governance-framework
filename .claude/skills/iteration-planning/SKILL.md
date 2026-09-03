---
name: iteration-planning
description: Conduce e registra il meeting di Roadmap Update & Iteration Planning — qualche giorno dopo il Backlog Refinement, quando il team tech conferma l'agenda concreta, fa la valutazione 80/20 rischio-rendimento sulle user story, stima le settimane di delivery delle iniziative in iterazione, conferma/aggiusta il Piano di Iterazione (spostamenti tra bucket → proposta aggiornata in pending/) e dichiara la capacità dedicata al debito tecnico. Punto d'ingresso dedicato: fissa ceremony_type e periodo, poi delega a log-ceremony per la registrazione.
---

# iteration-planning

Punto d'ingresso per **Roadmap Update & Iteration Planning** (playbook,
sezione omonima). `ceremony_type` e cadenza sono fissi: averla come skill
a sé evita di doverli rispecificare e tiene insieme i passi specifici di
questa cerimonia (stime di delivery, 80/20, capacità platform).

> **Dry-run.** Se l'utente chiede la simulazione (`dry-run`), propaga
> l'argomento a `log-ceremony`: nessuna scrittura (né `decisions.yaml`,
> né `.run-meta.yaml`, né `delivery.estimated_effort_weeks` sulle idee,
> né la proposta `iteration_plan` aggiornata in `pending/`, né azioni di
> checkpoint applicate), nessun commit, chiusura con `🔍 DRY-RUN`. Vedi playbook, "Modalità dry-run
> (simulazione)". In dry-run mostra comunque la board del Piano di
> Iterazione rifinita che *avresti* proposto (stime di delivery inserite,
> spostamenti tra bucket dalla valutazione 80/20). Run già fatto per
> errore senza dry-run: `rollback-ceremony`.

## Cosa fa

Registra la cerimonia tramite `log-ceremony` con `ceremony_type:
roadmap-iteration-planning` (fisso) e `periodo` = settimana ISO di
riferimento — di norma la **stessa** del Backlog Refinement a cui questo
planning si riferisce, salvo diversa indicazione. Segue tutti i passi
comuni di `log-ceremony` (`base_sha`, cartella cerimonia, `.run-meta.yaml`,
`source/`, `decisions.yaml`, "proponi non applicare", sincronizzazione) e,
in aggiunta, i passi specifici sotto.

## Passi specifici dell'Iteration Planning

1. **Sincronizza da `origin`** (`governance-sync.sh pull`) prima di
   leggere lo stato delle idee in iterazione. Se la config dichiara
   connettori esterni (`jira`, `metrics`), **verificali** con lo stesso
   criterio del Backlog Refinement (playbook, "Connettori esterni:
   dichiarati, verificati a inizio processo, mai un fallback silenzioso").

2. **Carica il Piano di Iterazione della settimana.** Cerca, nell'ordine:
   una proposta `type: iteration_plan` per questa settimana in
   `product/approvals/pending/`, altrimenti il file già approvato
   `product/roadmap/iterations/{settimana}.yaml`. È la base concreta di
   questo planning: le sue voci `analysis_todo` + `in_development` sono le
   iniziative da dimensionare al passo 3; i suoi quattro bucket sono ciò
   che la valutazione 80/20 può riorganizzare al passo 4. Se non esiste
   né proposta né file (il Backlog Refinement non ha ancora prodotto il
   piano, o è stato saltato), **segnalalo** e procedi sullo stato delle
   idee come prima — ma è un'anomalia da riferire, non la norma.
   **Checkpoint** (playbook, "Diritto di parola dopo ogni passo"): mostra
   i quattro bucket con l'identificatore in prima colonna e apri il
   diritto di parola prima di procedere alle stime.

3. **Stima di settimane di delivery.** Per ogni iniziativa
   `classification: idea` nei bucket `analysis_todo` / `in_development` /
   `urgent_priority` del piano, cattura dal team tech
   `delivery.estimated_effort_weeks` — **tempo-calendario**,
   non l'Entanglement del RICE (che è un footprint 1-10, non settimane —
   playbook, "Roadmap update & Iteration planning"). Serve prima non
   perché al RICE interessasse: è qui, con la valutazione 80/20 in mano,
   che una stima di durata diventa realistica.
   - Scrittura **diretta** su `product/ideas/{slug}/idea.yaml`, blocco
     `delivery`: è un fatto di pianificazione, non una decisione di
     priorità — non passa da `product/approvals/pending/` (stessa logica
     di `deadline`/`rice_status`).
   - Se una stima non è disponibile in riunione, lascia `null` e
     segnalalo — `roadmap-snapshot` la tratterà come "non ancora
     dimensionata" (`capacity_allocation.undimensioned_ideas`), non
     stimarla d'ufficio.
   - Le iniziative `classification: platform` usano invece
     `platform.estimated_effort_weeks` (già raccolto all'intake o qui se
     emerge) — non `delivery`.
   - **Sincronizza subito queste scritture** (stesso principio delle
     watch): se hai scritto almeno un `idea.yaml`, esegui
     `bash .claude/hooks/governance-sync.sh push "iteration-planning: stime delivery <periodo>" product/ideas/`
     prima di procedere — non aspettare il commit finale della cerimonia,
     che stage solo `product/ceremonies/` e `product/approvals/pending/`.

4. **Valutazione 80/20 (rischio-rendimento)** su ogni user story
   confermata: "se cambiamo questo requisito, anziché N giorni ne
   servono M — quella parte è davvero così importante?". Registra gli
   esiti tra le `decisions` di `decisions.yaml`. Se una storia non ha un
   criterio di accettazione chiaro, va segnalato, non lasciato implicito.
   Se la valutazione porta il team a **spostare una voce tra bucket** del
   piano (es. un'iniziativa che non è pronta per lo sviluppo torna in
   `analysis_todo`) o a **toglierla**, quello confluisce nel passo 5.
   Chiudi con un **checkpoint** (playbook, "Diritto di parola dopo ogni
   passo"): la parola al PM sulle voci discusse prima di generare la
   proposta aggiornata.

5. **Produci la proposta di Piano di Iterazione aggiornata**, se il passo
   3 o il passo 4 hanno cambiato qualcosa (stime di delivery inserite,
   voci spostate/tolte tra bucket). Non modifichi il file di iterazione
   in place: generi una **nuova proposta** `type: iteration_plan` in
   `product/approvals/pending/{settimana}-iteration-plan-refined.yaml`
   (o sovrascrivi quella del Backlog Refinement se è ancora in `pending/`
   e non approvata) con:
   - `refined_by_iteration_planning: true`, `generated_at` aggiornato;
   - i bucket riorganizzati dalla valutazione 80/20;
   - `changes_since_last` ricalcolato rispetto allo stesso `based_on`.
   Passa **sempre** da `pending/`, non applicare — `iteration-planning`
   non scrive mai `product/roadmap/iterations/` direttamente (stessa
   regola di `backlog-refinement`). Se il passo 3/4 non ha cambiato nulla
   di strutturale (solo stime di delivery, che sono scrittura diretta su
   `idea.yaml`), non serve una nuova proposta: dillo e salta.
   Sincronizza `pending/` se hai scritto la proposta.

6. **Capacità platform dell'iterazione, dichiarata esplicitamente.**
   Quanta capacità del team va a debito tecnico/devops questa iterazione
   — un numero esplicito, non lasciato implicito (checklist playbook).
   Alimenta `capacity_allocation` in `roadmap-snapshot`.

7. Consegna a `log-ceremony` (passi comuni): estrazione decisioni,
   `decisions.yaml` (con gli esiti della valutazione 80/20, la capacità
   platform tra le `decisions`, e `iteration_plan_ref` = path della
   proposta rifinita del passo 5 se generata), riepilogo al PM, chiusura
   `.run-meta.yaml`, sincronizzazione finale della cartella cerimonia.

## Dopo

- **`pending-approval`** se il passo 5 ha generato una proposta di Piano
  di Iterazione rifinita: va approvata come quella del Backlog Refinement.
- Il passo naturale successivo è un nuovo **`roadmap-snapshot`** che tiene
  conto del Piano di Iterazione rifinito, delle stime di delivery
  raccolte e della capacità platform dichiarata.
