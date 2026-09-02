---
name: backlog-refinement
description: Conduce e registra il Product Backlog Refinement settimanale — si apre "guardando indietro" (NSM, impatti, scadenze, idee senza RICE), svuota la coda di approvazione RICE, presenta il backlog ordinato come base della prioritizzazione, rileva le reprioritizzazioni fuori-RICE, poi delega a log-ceremony per la registrazione. Punto d'ingresso dedicato: fissa ceremony_type e periodo. Usala per la cerimonia settimanale di team.
---

# backlog-refinement

Punto d'ingresso per il **Product Backlog Refinement** (playbook, sezione
omonima). Esiste perché questa cerimonia ha un `ceremony_type` e una
cadenza fissi (settimanale): averla come skill a sé evita di doverli
rispecificare ogni volta e tiene insieme, in un unico posto, la sequenza
"si apre guardando indietro, poi si prioritizza".

> **Dry-run.** Se l'utente chiede la simulazione (`dry-run`, "simula la
> cerimonia"), propaga l'argomento a ogni skill che invochi
> (`log-ceremony`, le watch, `pending-approval`): nessuna scrittura
> (nemmeno l'assegnazione di `short_ref`, nessuna approvazione applicata),
> nessun commit, chiusura con `🔍 DRY-RUN`. Vedi playbook, "Modalità
> dry-run (simulazione)". In dry-run, al passo 3 elenca comunque cosa c'è
> in coda e al passo 5 mostra sia il ranking ufficiale sia quello che
> risulterebbe approvando le proposte in `pending/` — è la parte più
> utile della simulazione. Se il run è già stato fatto per errore senza
> dry-run: `rollback-ceremony`.

## Cosa fa

Registra la cerimonia tramite `log-ceremony` con `ceremony_type:
backlog-refinement` (fisso) e `periodo` = settimana ISO corrente
(`YYYY-Www`), salvo l'utente indichi una settimana diversa. Segue tutti i
passi comuni di `log-ceremony` (cattura `base_sha`, cartella cerimonia,
`.run-meta.yaml`, `source/`, `decisions.yaml`, "proponi non applicare",
sincronizzazione) e, in aggiunta, i passi specifici di questa cerimonia
descritti sotto.

La cerimonia non si limita a **registrare** cosa il team ha deciso: gli
mette davanti le **opzioni** da cui decidere. Un backlog ordinato che
nessuno vede — perché gli score sono fermi in `product/approvals/pending/`
— non serve a prioritizzare. Per questo i passi 3 e 5 svuotano la coda di
approvazione e presentano la lista ordinata, prima che si discuta cosa
entra in iterazione.

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
   6. `jira-sync` **modalità Riconciliazione** — solo se
      `.governance/config.yaml` ha un `jira.integration` con capacità di
      ricerca: idee mai passate dal RICE il cui lavoro è già partito in
      Jira (falla di governance). Saltala senza rumore se Jira non è
      configurato così.

   Ogni watch **solo segnala** — nessuna azione automatica. I riepiloghi
   vanno passati a `log-ceremony` perché li includa nel `decisions.yaml`
   della cerimonia.

3. **Svuota la coda di approvazione — prima di guardare il backlog.**
   Elenca `product/approvals/pending/` (usa `pending-approval`, sezione
   "Elenco"). I `rice_diff` in particolare: finché non sono approvati, i
   loro score non esistono per `backlog-list`, e la prioritizzazione al
   passo 6 gira su un ranking incompleto. **Cammina la coda con il PM /
   il team, voce per voce**: per ciascuna, il PM decide approva / rifiuta
   / rimanda (con motivo), e tu applichi la decisione via
   `pending-approval` (Approvazione o Rifiuto). Questo è il luogo previsto
   per rivedere i RICE — l'approvazione sollecitata qui **è** istruzione
   esplicita, resa voce per voce.
   - Per un **primo scoring di un intake storico bulk** (decine di
     proposte coerenti, tutte prima quotazione — playbook, "Intake
     storico e roadmap pre-esistente"), il PM può approvarle in blocco su
     sua esplicita indicazione ("approva tutte queste del batch del
     {data}, rivediamo insieme solo le N dubbie") — `pending-approval` le
     esegue comunque una per una, con log distinto.
   - Registra in `decisions.yaml` (via `log-ceremony`, campo
     `approvals_reviewed`) quali voci sono state approvate / rifiutate /
     rimandate in questa cerimonia.
   - Le proposte lasciate in coda vanno segnalate nel riepilogo finale —
     una coda che sopravvive alla cerimonia è un debito da rendere
     visibile, non da ignorare.

4. **Assegna `short_ref` alle idee che ne sono prive.** Per ogni idea in
   `product/ideas/*/idea.yaml` con `short_ref: null`, assegna il prossimo
   handle: `{prefisso}-{NNN}` dove `NNN = max(numeri short_ref esistenti
   in tutte le idee) + 1`, zero-padded a 3 cifre (parti da `001` se non
   ce n'è nessuno). Prefisso: `short_ref_prefix` da
   `.governance/config.yaml`, o `PG` se assente. Il Backlog Refinement è
   il punto di serializzazione a scrittore singolo per cui questo non
   collide (hai appena fatto `pull` al passo 1). È un fatto di
   housekeeping — scrittura **diretta** su `idea.yaml`, non passa da
   `pending/` — e una volta assegnato non cambia più. Sincronizza subito
   queste scritture (come le watch):
   `bash .claude/hooks/governance-sync.sh push "backlog-refinement: assegnati short_ref" product/ideas/`.
   Non toccare le idee che un `short_ref` ce l'hanno già.

5. **Presenta il backlog ordinato — è la base della prioritizzazione.**
   Richiama `backlog-list` e mostra la sua vista: idee `classification:
   idea` ordinate per RICE score, iniziative fuori-RICE ancora aperte,
   idee senza RICE. Questa **non** è una formalità: è il materiale su cui
   il team decide cosa entra nell'iterazione — senza, la cerimonia
   registra decisioni senza aver mai mostrato le opzioni. Se dopo il
   passo 3 restano ancora proposte in `pending/` non approvate,
   `backlog-list` lo evidenzia (sezione "Proposte RICE non ancora
   approvate") — tienilo presente al passo 6.

6. **Rileva le reprioritizzazioni fuori-RICE.** Solo per iniziative
   `classification: idea` che entrano nell'iterazione corrente davanti a
   idee con RICE score più alto ancora in backlog (dal ranking del passo
   5). Per ciascuna, chiedi esplicitamente al PM se è una **Strategic
   Exception** (bypass autorizzato da uno stakeholder → proposta
   `strategic_exception_flag` in `pending/`, `approved_by` mai presunto) o
   una **scelta qualitativa del team** (resta solo nelle
   `reprioritizations` della cerimonia). È così che il framework
   intercetta il pattern "stessa persona che bypassa la priorità ogni
   settimana" (playbook, "Come gestire le frizioni" — Scenario 2).

7. **`retro_notes`** — % completamento dell'iterazione precedente,
   impedimenti riscontrati, informazioni mancate — se presenti nella
   trascrizione.

8. Consegna tutto a `log-ceremony` per i passi comuni: estrazione delle
   decisioni atomiche, `decisions.yaml` (con `retro_notes`,
   `reprioritizations` e `approvals_reviewed` del passo 3 valorizzati),
   riepilogo al PM — aperto **sempre** dagli allarmi `nsm-watch` se
   presenti — chiusura di `.run-meta.yaml`, sincronizzazione.

## Dopo

- Il passo naturale successivo è **`roadmap-snapshot`** — la proposta di
  snapshot settimanale della roadmap, che legge i riepiloghi delle watch
  loggati qui.
- Qualche giorno dopo: **`iteration-planning`**, quando il team tech
  fissa l'agenda concreta di delivery.
