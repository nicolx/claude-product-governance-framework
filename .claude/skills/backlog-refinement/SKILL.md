---
name: backlog-refinement
description: Conduce e registra il Product Backlog Refinement settimanale — la cerimonia che si apre "guardando indietro" (NSM in degrado, impatti delle iniziative rilasciate, scadenze mandatarie e non, idee senza RICE) e poi popola il backlog dell'iterazione. Punto d'ingresso dedicato: fissa ceremony_type e periodo, orchestra la sweep delle watch e il rilevamento delle reprioritizzazioni fuori-RICE, poi delega a log-ceremony per la registrazione. Usala dopo la riunione settimanale di team.
---

# backlog-refinement

Punto d'ingresso per il **Product Backlog Refinement** (playbook, sezione
omonima). Esiste perché questa cerimonia ha un `ceremony_type` e una
cadenza fissi (settimanale): averla come skill a sé evita di doverli
rispecificare ogni volta e tiene insieme, in un unico posto, la sequenza
"si apre guardando indietro, poi si prioritizza".

> **Dry-run.** Se l'utente chiede la simulazione (`dry-run`, "simula la
> cerimonia"), propaga l'argomento a ogni skill che invochi
> (`log-ceremony` e tutte le watch): nessuna scrittura, nessun commit,
> chiusura con `🔍 DRY-RUN`. Vedi playbook, "Modalità dry-run
> (simulazione)". Se il run è già stato fatto per errore senza dry-run:
> `rollback-ceremony`.

## Cosa fa

Registra la cerimonia tramite `log-ceremony` con `ceremony_type:
backlog-refinement` (fisso) e `periodo` = settimana ISO corrente
(`YYYY-Www`), salvo l'utente indichi una settimana diversa. Segue tutti i
passi comuni di `log-ceremony` (cattura `base_sha`, cartella cerimonia,
`.run-meta.yaml`, `source/`, `decisions.yaml`, "proponi non applicare",
sincronizzazione) e, in aggiunta, i passi specifici di questa cerimonia
descritti sotto.

## Passi specifici del Backlog Refinement

1. **Sincronizza da `origin`** (`governance-sync.sh pull`) prima di
   leggere lo stato — la sweep confronta lo stato di molte idee, deve
   partire da dati aggiornati.

2. **Apri "guardando indietro", non avanti** (playbook: "la riunione si
   apre guardando indietro"). Richiama, **in quest'ordine**:
   1. `nsm-watch` — per prima: è il segnale più strategico. NSM in
      degrado con `alert.status` attivo aprono il riepilogo, prima di
      tutto il resto.
   2. `measurement-watch` — iniziative rilasciate che dovrebbero già
      mostrare impatti: KPI `check_due`, `at_risk`, `invalidated`.
   3. `mandate-watch` — iniziative mandatarie `overdue`/`due_soon`/
      `pending_review`.
   4. `deadline-watch` — idee normali/strategic exception con scadenza a
      ≤4 settimane: push forte, non una riga tra le altre.
   5. `rice-watch` — idee `classification: idea` ancora senza RICE:
      `stale`, `blocked_on`, `needs_deep_dive`.

   Ogni watch **solo segnala** — nessuna azione automatica. I riepiloghi
   vanno passati a `log-ceremony` perché li includa nel `decisions.yaml`
   della cerimonia.

3. **Rileva le reprioritizzazioni fuori-RICE.** Solo per iniziative
   `classification: idea` che entrano nell'iterazione corrente davanti a
   idee con RICE score più alto ancora in backlog. Per ciascuna, chiedi
   esplicitamente al PM se è una **Strategic Exception** (bypass
   autorizzato da uno stakeholder → proposta `strategic_exception_flag`
   in `pending/`, `approved_by` mai presunto) o una **scelta qualitativa
   del team** (resta solo nelle `reprioritizations` della cerimonia).
   È così che il framework intercetta il pattern "stessa persona che
   bypassa la priorità ogni settimana" (playbook, "Come gestire le
   frizioni" — Scenario 2).

4. **`retro_notes`** — % completamento dell'iterazione precedente,
   impedimenti riscontrati, informazioni mancate — se presenti nella
   trascrizione.

5. Consegna tutto a `log-ceremony` per i passi comuni: estrazione delle
   decisioni atomiche, `decisions.yaml` (con `retro_notes` e
   `reprioritizations` valorizzati), riepilogo al PM — aperto **sempre**
   dagli allarmi `nsm-watch` se presenti — chiusura di `.run-meta.yaml`,
   sincronizzazione.

## Dopo

- Il passo naturale successivo è **`roadmap-snapshot`** — la proposta di
  snapshot settimanale della roadmap, che legge i riepiloghi delle watch
  loggati qui.
- Qualche giorno dopo: **`iteration-planning`**, quando il team tech
  fissa l'agenda concreta di delivery.
