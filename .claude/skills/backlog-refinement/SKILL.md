---
name: backlog-refinement
description: Conduce e registra il Product Backlog Refinement settimanale — si apre "guardando indietro" (NSM, impatti, scadenze, idee senza RICE), svuota la coda di approvazione RICE, presenta il backlog ordinato come base della prioritizzazione, compone il Piano di Iterazione della settimana (la board a quattro bucket, output primario, proposto in pending/) rilevando le reprioritizzazioni fuori-RICE, poi delega a log-ceremony per la registrazione. Punto d'ingresso dedicato: fissa ceremony_type e periodo. Usala per la cerimonia settimanale di team.
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
> (nemmeno l'assegnazione di `short_ref`, nessuna approvazione applicata,
> nessuna proposta `iteration_plan` scritta in `pending/`), nessun commit,
> chiusura con `🔍 DRY-RUN`. Vedi playbook, "Modalità dry-run
> (simulazione)". In dry-run, al passo 3 elenca comunque cosa c'è in coda,
> al passo 5 mostra sia il ranking ufficiale sia quello che risulterebbe
> approvando le proposte in `pending/`, e al passo 6 mostra comunque per
> intero la board a quattro bucket del Piano di Iterazione che *avresti*
> proposto, incluso il diff `changes_since_last` da `based_on` — è la
> parte più utile della simulazione. Se il run è già stato fatto per
> errore senza dry-run: `rollback-ceremony`.

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

**L'output primario della cerimonia è il Piano di Iterazione** (passo 6):
`product/roadmap/iterations/{settimana}.yaml`, la board team-facing a
quattro bucket costruita come diff dal piano della settimana precedente.
Senza, la cerimonia registra decisioni e segnalazioni ma non lascia in
mano al team il documento su cui lavora nei giorni successivi — vedi
playbook, "Product Backlog Refinement". Come lo snapshot di roadmap, il
piano passa **sempre** da `product/approvals/pending/`
(`type: iteration_plan`) e non viene applicato nella camminata.

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
   6. `jira-sync` **modalità Riconciliazione** — idee mai passate dal
      RICE il cui lavoro è già partito in Jira (falla di governance).
      Saltala **senza rumore** solo se `jira.integration` non ha capacità
      di ricerca (`manuale`, vuoto) — è una scelta di setup. Se invece è
      dichiarato un connettore con ricerca (`atlassian-mcp`) ma **non
      risponde** al momento del run (tool `mcp__atlassian__*` assenti,
      `ENOTFOUND`/timeout su `mcp.atlassian.com`), **non saltarla in
      silenzio**: applica "Connettore dichiarato ma irraggiungibile" di
      `jira-sync` — segnala il guasto, proponi al PM di riattivare la
      connessione (`/mcp`) e ritentare il passo. Se sceglie di proseguire,
      la riconciliazione va registrata come **rimandata** nel riepilogo
      della cerimonia (debito visibile, da rilanciare `jira-sync`
      standalone quando il connettore torna su), mai come completata o
      non applicabile.

   Ogni watch **solo segnala** — nessuna azione automatica. I riepiloghi
   vanno passati a `log-ceremony` perché li includa nel `decisions.yaml`
   della cerimonia.

3. **Svuota la coda di approvazione — prima di guardare il backlog.**
   Elenca `product/approvals/pending/` (usa `pending-approval`, sezione
   "Elenco"): quando ci sono più voci verso un'idea, come **tabella** con
   le colonne descritte lì — identificativo idea (`short_ref` o `id`),
   `summary`, tipo, score proposto (col delta vs. quello corrente),
   scadenza con `escalation_status`, e la colonna **Bypass** che segnala
   le Strategic Exception *dichiarate ma non ancora approvate* e le
   iniziative mandatarie. I `rice_diff` in particolare: finché non sono
   approvati, i loro score non esistono per `backlog-list`, e la
   prioritizzazione al passo 6 gira su un ranking incompleto. **Cammina la
   coda con il PM / il team, voce per voce**: per ciascuna, il PM decide
   approva / rifiuta / rimanda (con motivo), e tu applichi la decisione
   via `pending-approval` (Approvazione o Rifiuto). Questo è il luogo previsto
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
   `.governance/config.yaml`, o `PG` se assente.
   - **Guard anti-collisione.** Se il prefisso risolto coincide
     (case-insensitive) con `jira.project_key` in `.governance/config.yaml`,
     **fermati e non assegnare**: i due namespace si confonderebbero
     (`{sigla}-42` idea vs. ticket — vedi playbook, "Ogni elenco prodotto
     dal sistema è indirizzabile", e `init-governance-project`). Segnala
     la collisione al PM e chiedi di correggere `short_ref_prefix` in
     config prima di procedere. Le idee restano senza handle per questo
     run — non è un errore bloccante per il resto della cerimonia. Il Backlog Refinement è
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

6. **Componi il Piano di Iterazione, partendo da quello della settimana
   precedente.** È l'output primario della cerimonia
   (`framework/schema/iteration-plan.template.yaml`). Non scrivere mai il
   file direttamente: si genera una proposta `type: iteration_plan` in
   `pending/` (passo 6.7).

   1. **Carica il piano precedente.** Cerca il file di iterazione più
      recente in `product/roadmap/iterations/` con settimana `<` quella
      corrente → è `based_on`. Se non ne esiste nessuno (primo run
      dell'istanza): `based_on: null`, e costruisci i bucket dallo stato
      corrente — idee `status: in_analysis` → `analysis_in_progress`;
      idee con `jira.card_id` e stato dev attivo → `in_development`.
   2. **Riconcilia ogni voce del piano precedente con lo stato attuale**
      e popola `changes_since_last`:
      - idea ora `status: done` → `completed`, non riportarla nei bucket;
      - idea avanzata di stato (analisi → dev) → spostala di bucket,
        `carried_from` = settimana precedente, registrala in `advanced`;
      - idea ferma allo stesso punto → carry-over nel suo bucket,
        incrementa `weeks_in_bucket`; se supera una soglia indicativa di
        **3 iterazioni** senza avanzare, mettila in `slipped` e segnalala
        esplicitamente al PM (non annegarla nel riepilogo);
      - idea non più pertinente che il team decide di togliere →
        `dropped` con `reason`.
   3. **Presenta al PM la board carried-over** — i quattro bucket più il
      diff — prima di chiedere le aggiunte.
   4. **Chiedi le aggiunte, bucket per bucket:**
      - `analysis_todo`: *dal ranking RICE del passo 5, quali idee
        `classification: idea` iniziano l'analisi questa settimana?* —
        **è la domanda centrale della riunione**, non una formalità. Per
        ciascuna registra `why_now`.
      - `in_development`: card nuove emerse nella riconciliazione Jira del
        passo 2.6 e non ancora nel piano.
      - `urgent_priority`: **questo assorbe il vecchio "rileva le
        reprioritizzazioni fuori-RICE".** Sono le iniziative
        `classification: idea` che entrano nell'iterazione **davanti a
        idee con RICE score più alto** ancora in backlog (dal ranking del
        passo 5), più le idee con `deadline`/`mandate` a `due_soon`/
        `overdue` che il team decide di forzare in analisi adesso. Per
        ciascuna, chiedi esplicitamente al PM se è una **Strategic
        Exception** (bypass autorizzato da uno stakeholder) o una
        **scelta qualitativa del team** dentro il processo normale:
        - se **Strategic Exception**: voce `urgent_priority` con
          `kind: strategic_exception`, `approved_by` **mai presunto**, e
          **in più** genera una proposta `strategic_exception_flag` in
          `pending/` (append a `strategic_exceptions` dell'idea +
          `pending-approval` aggiunge la riga a
          `product/reference/friction-log.yaml`) — esattamente come prima
          dell'introduzione del piano. È così che il framework intercetta
          il pattern "stessa persona che bypassa la priorità ogni
          settimana" (playbook, "Come gestire le frizioni" — Scenario 2);
        - se **scelta qualitativa del team**: la voce resta solo nel
          piano (`urgent_priority` o `analysis_todo` con `why_now`), e in
          `decisions.yaml` come `reprioritization` con
          `reason_type: qualitative_team_call` — nessuna proposta
          `strategic_exception_flag`.
   5. **Chiedi il `iteration_goal`** — una frase: focus della settimana /
      iniziativa o metrica che si cerca di impattare.
   6. Il PM conferma la board finale.
   7. **Genera la proposta** `type: iteration_plan` in
      `product/approvals/pending/{settimana}-iteration-plan.yaml`
      (`framework/schema/approval.template.yaml`, `payload` = piano
      completo, `target_file` =
      `product/roadmap/iterations/{settimana}.yaml`). **Non applicare** —
      resta pending, si approva separatamente (skill `pending-approval`,
      come `roadmap_snapshot`).
   8. Sincronizza `pending/`:
      `bash .claude/hooks/governance-sync.sh push "backlog-refinement: proposta Piano di Iterazione <settimana>" product/approvals/pending/`.

7. **`retro_notes`** — % completamento dell'iterazione precedente,
   impedimenti riscontrati, informazioni mancate — se presenti nella
   trascrizione.

8. Consegna tutto a `log-ceremony` per i passi comuni: estrazione delle
   decisioni atomiche, `decisions.yaml` (con `retro_notes`,
   `reprioritizations`, `approvals_reviewed` del passo 3 e
   `iteration_plan_ref` = path della proposta del passo 6.7 valorizzati),
   riepilogo al PM — aperto **sempre** dagli allarmi `nsm-watch` se
   presenti — chiusura di `.run-meta.yaml`, sincronizzazione.

## Dopo

- **`pending-approval`** per approvare la proposta di Piano di Iterazione
  del passo 6 (e le eventuali `strategic_exception_flag` generate): finché
  resta in `pending/`, `product/roadmap/iterations/{settimana}.yaml` non
  esiste ancora. La camminata della cerimonia **non** l'ha approvata.
- **`iteration-board`** per la vista "a colpo d'occhio" del piano (daily
  standup, mail settimanale, Confluence).
- Il passo naturale successivo è **`roadmap-snapshot`** — la proposta di
  snapshot settimanale della roadmap, che ora **referenzia** il Piano di
  Iterazione (`iteration_plan_ref`) invece di ricostruire una propria
  lista di iniziative, e legge i riepiloghi delle watch loggati qui.
- Qualche giorno dopo: **`iteration-planning`**, quando il team tech
  fissa l'agenda concreta di delivery e **conferma/aggiusta** il Piano di
  Iterazione (stime di delivery, valutazione 80/20).
