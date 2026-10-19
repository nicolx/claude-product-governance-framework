---
name: iteration-planning
description: Conduce e registra il meeting di Roadmap Update & Iteration Planning — qualche giorno dopo il Backlog Refinement, quando il team tech conferma l'agenda concreta, fa la valutazione 80/20 rischio-rendimento sulle user story, stima la delivery delle iniziative in iterazione per competenza (persona-settimane + durata), verifica che il piano stia nella capacità reale del team (team.yaml) registrando ogni sforamento accettato, mostra in anteprima come le nuove stime spostano gli slot della roadmap (mandate/scadenze a rischio, scostamenti dalla roadmap trimestrale distribuita), conferma/aggiusta il Piano di Iterazione (spostamenti tra bucket → proposta aggiornata in pending/) e dichiara la capacità dedicata al debito tecnico. Punto d'ingresso dedicato: fissa ceremony_type e periodo, poi delega a log-ceremony per la registrazione.
---

# iteration-planning

Punto d'ingresso per **Roadmap Update & Iteration Planning** (playbook,
sezione omonima). `ceremony_type` e cadenza sono fissi: averla come skill
a sé evita di doverli rispecificare e tiene insieme i passi specifici di
questa cerimonia (stime di delivery per competenza, capacity check, 80/20,
capacità platform).

> **Dry-run.** Se l'utente chiede la simulazione (`dry-run`), propaga
> l'argomento a `log-ceremony`: nessuna scrittura (né `decisions.yaml`,
> né `.run-meta.yaml`, né il blocco `delivery` (stime) o
> `tech_reference` sulle idee/PRD, né la proposta `iteration_plan`
> aggiornata in `pending/`, né azioni di
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
   Poi leggi in blocco con `bash .claude/hooks/governance-dump.sh sweep`:
   idee, piani, coda `pending/`, `team.yaml` (l'offerta), l'ultimo
   snapshot approvato (lo `slot_plan` di partenza) e i metadati delle
   roadmap distribuite (la promessa fatta agli stakeholder) in una tool
   call.

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
   i quattro bucket con l'identificatore in prima colonna, `summary` e
   R · I · C · E + RICE totale (playbook, "Ogni riga che parla di un'idea si capisce da sola"), il
   `tech_reference` (referente tecnico) accanto a ogni voce, lo **slot
   attuale** dallo `slot_plan` dell'ultimo snapshot approvato (*sviluppo
   W46–W50 (stima)*, *slitta per {competenza}*, *da dimensionare*, *oltre
   il trimestre* — come in `iteration-board`), e apri il
   diritto di parola prima di procedere alle stime. Se una voce con un
   PRD non ha `tech_reference`, segnalalo — il team può assegnarlo ora
   (passo 4).

3. **Stima di delivery, per competenza.** Per ogni iniziativa
   `classification: idea` / `strategic_exception` / `mandate` nei bucket
   `analysis_todo` / `in_development` / `urgent_priority` del piano,
   cattura dal team tech due numeri (playbook, "Capacità del team e slot
   della roadmap"):
   - `delivery.effort_by_competency` — **quanto lavoro**, in
     persona-settimane per competenza del catalogo di
     `product/reference/team.yaml` (`{ backend: 3, frontend: 2, qa: 1 }`).
     Una competenza non in catalogo non si aggiunge in silenzio: chiedi
     se è un sinonimo di una esistente o se il catalogo va esteso con
     `team-roster`;
   - `delivery.estimated_effort_weeks` — **in quanto tempo-calendario**,
     una volta partita (la durata dello slot).
   Entrambi sono tempo, non l'Entanglement del RICE (che è un footprint
   1-10 — playbook, "Roadmap update & Iteration planning"). È qui, con la
   valutazione 80/20 in mano, che la stima diventa `estimate_basis:
   committed`: se c'era una stima `rough` da `prd-draft`, mostrala come
   punto di partenza e chiedi di confermarla o correggerla. Aggiorna
   `estimated_at`. Se l'istanza ha squad e `delivery.squad` è vuoto,
   chiedi quale squad la prende (proponi quella che possiede gli `apps/`
   toccati).
   **Verifica di fattibilità**, per ogni stima: il carico settimanale
   `effort_by_competency[c] / estimated_effort_weeks` non deve superare
   l'offerta settimanale **totale** di quella competenza (nella squad, se
   assegnata). Se la supera, la durata è troppo corta per il team che
   c'è (o la competenza manca): dillo subito e chiedi al team se
   allungare la durata, ridurre lo scope (80/20) o se serve supporto
   esterno — non correggerla da solo.
   - Scrittura **diretta** su `product/ideas/{slug}/idea.yaml`, blocco
     `delivery`: è un fatto di pianificazione, non una decisione di
     priorità — non passa da `product/approvals/pending/` (stessa logica
     di `deadline`/`rice_status`).
   - Se una stima non è disponibile in riunione, lascia i campi vuoti e
     segnalalo — `roadmap-snapshot` la tratterà come "non ancora
     dimensionata" (`capacity_allocation.undimensioned_ideas`), non
     stimarla d'ufficio.
   - Le iniziative `classification: platform` usano gli stessi due campi
     nel blocco `platform` (`platform.effort_by_competency`,
     `platform.estimated_effort_weeks`, già raccolti all'intake o qui se
     emergono) — non `delivery`.
   - **Sincronizza subito queste scritture** (stesso principio delle
     watch): se hai scritto almeno un `idea.yaml`, esegui
     `bash .claude/hooks/governance-sync.sh push "iteration-planning: stime delivery <periodo>" product/ideas/`
     prima di procedere — non aspettare il commit finale della cerimonia,
     che stage solo `product/ceremonies/` e `product/approvals/pending/`.

4. **Valutazione 80/20 (rischio-rendimento)** su ogni user story
   confermata: "se cambiamo questo requisito, anziché N giorni ne
   servono M — quella parte è davvero così importante?". Registra gli
   esiti tra le `decisions` di `decisions.yaml`.
   È anche il momento per **confermare o correggere il `tech_reference`**
   di ogni PRD in iterazione: se il team decide che il referente è un
   altro (roster cambiato, carico, competenza più adatta emersa nella
   discussione 80/20), aggiorna il frontmatter `tech_reference` del PRD e
   la copia denormalizzata su `idea.yaml` — scrittura diretta, non passa
   da `pending/` (stessa logica di `delivery.estimated_effort_weeks`).
   Sincronizza subito queste scritture come le stime del passo 3. Se una storia non ha un
   criterio di accettazione chiaro, va segnalato, non lasciato implicito.
   Se la valutazione porta il team a **spostare una voce tra bucket** del
   piano (es. un'iniziativa che non è pronta per lo sviluppo torna in
   `analysis_todo`) o a **toglierla**, quello confluisce nel passo 5.
   Chiudi con un **checkpoint** (playbook, "Diritto di parola dopo ogni
   passo"): la parola al PM sulle voci discusse prima di generare la
   proposta aggiornata.

4b. **Ricalcola il capacity check** del piano con le stime `committed`
   del passo 3 e i bucket dopo il passo 4 — stesse regole del Backlog
   Refinement (`capacity_check` nel template del piano; playbook,
   "Capacità del team e slot della roadmap"). Mostra la tabella
   competenza → offerta / domanda / saturazione. Se una competenza è
   `over`: proponi le opzioni (spostare una voce, ridurre lo scope con
   l'80/20, un membro con quella competenza in `can_also`), e se il team
   accetta lo sforamento registra motivazione e `decided_by` in
   `over_capacity_decision` e in `decisions.yaml` (`capacity_overrides`)
   — **mai presunti**. Una decisione di sforamento già presa al Backlog
   Refinement resta valida solo se il quadro non è peggiorato: se la
   domanda è cresciuta, richiedila.

4c. **Slot dopo le nuove stime.** Le stime `committed` del passo 3 e i
   bucket del passo 4 spostano gli slot: è qui che il team vede *subito*
   cosa la sua stima significa in date, invece di scoprirlo dallo
   snapshot. Applica lo slotting di `roadmap-snapshot` (playbook,
   "Capacità del team e slot della roadmap" — stesso ordine, stessa
   regola di collocazione, stesso orizzonte) sullo stato appena
   aggiornato, **in memoria**, e confrontalo con lo `slot_plan`
   dell'ultimo snapshot approvato. Mostra solo ciò che cambia:
   - voci la cui fine stimata si sposta di almeno 2 settimane — *PG-042
     fine W48 → W51*, con la causa: *nuova stima*, *capacità
     {competenza}* (un'altra voce ha preso la capacità), *riordino del
     piano*;
   - voci che entrano o escono dal trimestre, o diventano `infeasible`;
   - **mandate e deadline che diventano `at_risk`** (fine stimata oltre
     la `due_date`), in evidenza: è il momento di decidere — ridurre lo
     scope con l'80/20, anticiparle nel piano, o accettare il rischio e
     dirlo;
   - voci che si allontanano dalla **roadmap trimestrale distribuita**
     (stesso confronto di "Rispetto alla roadmap del trimestre"
     nell'aggiornamento settimanale): sono le aspettative degli
     stakeholder da riallineare (checklist del playbook).
   **Checkpoint**: la parola al team su ogni spostamento prima del passo
   5 — una stima che fa slittare un mandate si discute ora, non si
   scopre in MBR. Registra in `decisions.yaml` una `decision` per ogni
   spostamento discusso (cosa si è deciso, `impacts.idea_ids`). Non
   scrivi nessuno slot: lo `slot_plan` ufficiale lo produce
   `roadmap-snapshot` con lo stesso algoritmo — se i dati non cambiano
   nel frattempo, darà gli stessi numeri. Non prepari comunicazioni:
   gli stakeholder da riallineare finiscono tra le azioni aperte del PM
   nel riepilogo, e lo spostamento comparirà comunque nell'aggiornamento
   settimanale dopo lo snapshot. Se `team.yaml` non ha capacità o non
   c'è uno snapshot precedente, dillo e salta il confronto (mostra solo
   gli slot calcolati, se c'è la capacità).

5. **Produci la proposta di Piano di Iterazione aggiornata**, se il passo
   3, il passo 4 o il 4b hanno cambiato qualcosa (stime di delivery
   inserite, voci spostate/tolte tra bucket, `capacity_check` cambiato). Non modifichi il file di iterazione
   in place: generi una **nuova proposta** `type: iteration_plan` in
   `product/approvals/pending/{settimana}-iteration-plan-refined.yaml`
   (o sovrascrivi quella del Backlog Refinement se è ancora in `pending/`
   e non approvata) con:
   - `refined_by_iteration_planning: true`, `generated_at` aggiornato;
   - i bucket riorganizzati dalla valutazione 80/20 — una voce che
     entra in un bucket nuovo porta `summary`/`rice_score`/
     `rice_components` denormalizzati dall'idea come nel Backlog
     Refinement;
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
   Con `team.yaml` dimensionato, mostralo come quota dell'offerta
   calcolata al passo 4b (es. "platform 1.2 persona-settimane su 6.4 =
   19%") invece di chiederlo in astratto; il team conferma o corregge le
   stime `platform.*` da cui viene. Alimenta `capacity_allocation` in
   `roadmap-snapshot`.

7. Consegna a `log-ceremony` (passi comuni): estrazione decisioni,
   `decisions.yaml` (con gli esiti della valutazione 80/20, la capacità
   platform tra le `decisions`, e `iteration_plan_ref` = path della
   proposta rifinita del passo 5 se generata), riepilogo al PM, chiusura
   `.run-meta.yaml`, sincronizzazione finale della cartella cerimonia.

## Dopo

- **`pending-approval`** se il passo 5 ha generato una proposta di Piano
  di Iterazione rifinita: va approvata come quella del Backlog Refinement.
- La roadmap aggiornata (viste `per_ceremony`) l'ha già rigenerata
  `log-ceremony` in chiusura, con le stime di delivery e i commenti della
  valutazione 80/20; all'approvazione del piano rifinito
  `pending-approval` la rigenera di nuovo.
- Il passo naturale successivo è un nuovo **`roadmap-snapshot`** che tiene
  conto del Piano di Iterazione rifinito, delle stime di delivery
  raccolte e della capacità platform dichiarata: rende ufficiale lo
  `slot_plan` che il passo 4c ha mostrato in anteprima, e alla sua
  approvazione `pending-approval` prepara l'aggiornamento settimanale con
  gli spostamenti discussi qui.
