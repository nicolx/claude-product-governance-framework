---
name: iteration-planning
description: Conduce e registra il meeting di Roadmap Update & Iteration Planning — qualche giorno dopo il Backlog Refinement, quando il team tech conferma l'agenda concreta, fa la valutazione 80/20 rischio-rendimento sulle user story, stima le settimane di delivery delle iniziative entrate in iterazione e dichiara la capacità dedicata al debito tecnico. Punto d'ingresso dedicato: fissa ceremony_type e periodo, poi delega a log-ceremony per la registrazione.
---

# iteration-planning

Punto d'ingresso per **Roadmap Update & Iteration Planning** (playbook,
sezione omonima). `ceremony_type` e cadenza sono fissi: averla come skill
a sé evita di doverli rispecificare e tiene insieme i passi specifici di
questa cerimonia (stime di delivery, 80/20, capacità platform).

> **Dry-run.** Se l'utente chiede la simulazione (`dry-run`), propaga
> l'argomento a `log-ceremony`: nessuna scrittura (né `decisions.yaml`,
> né `.run-meta.yaml`, né `delivery.estimated_effort_weeks` sulle idee),
> nessun commit, chiusura con `🔍 DRY-RUN`. Vedi playbook, "Modalità
> dry-run (simulazione)". Run già fatto per errore senza dry-run:
> `rollback-ceremony`.

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
   leggere lo stato delle idee in iterazione.

2. **Stima di settimane di delivery.** Per ogni iniziativa
   `classification: idea` entrata nell'iterazione corrente, cattura dal
   team tech `delivery.estimated_effort_weeks` — **tempo-calendario**,
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

3. **Valutazione 80/20 (rischio-rendimento)** su ogni user story
   confermata: "se cambiamo questo requisito, anziché N giorni ne
   servono M — quella parte è davvero così importante?". Registra gli
   esiti tra le `decisions` di `decisions.yaml`. Se una storia non ha un
   criterio di accettazione chiaro, va segnalato, non lasciato implicito.

4. **Capacità platform dell'iterazione, dichiarata esplicitamente.**
   Quanta capacità del team va a debito tecnico/devops questa iterazione
   — un numero esplicito, non lasciato implicito (checklist playbook).
   Alimenta `capacity_allocation` in `roadmap-snapshot`.

5. Consegna a `log-ceremony` (passi comuni): estrazione decisioni,
   `decisions.yaml` (con gli esiti della valutazione 80/20 e la capacità
   platform tra le `decisions`), riepilogo al PM, chiusura
   `.run-meta.yaml`, sincronizzazione finale della cartella cerimonia.

## Dopo

Il passo naturale successivo è un nuovo **`roadmap-snapshot`** che tiene
conto delle stime di delivery raccolte e della capacità platform
dichiarata.
