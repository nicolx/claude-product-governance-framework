---
name: pending-approval
description: Elenca, spiega e applica (o rifiuta) le proposte in product/approvals/pending/ — l'unico punto in cui un diff di RICE, uno snapshot di roadmap, un Piano di Iterazione, una Strategic Exception rilevata in Backlog Refinement, un aggiornamento a un'iniziativa mandataria, un cambiamento materiale del contesto aziendale (context_update, da context-watch), o una comunicazione in uscita passano da proposti ad effettivi. Dopo un giro di approvazioni che tocca la roadmap la rigenera (viste per_ceremony); approvato lo snapshot della settimana, prepara l'aggiornamento settimanale agli stakeholder (proposta outbound_comm, mai inviata). Usala per rivedere la coda.
---

# pending-approval

Gestisce la coda unica di "pending approval" del framework — il
meccanismo per cui **l'automazione propone, un umano decide**, sia per i
diff di roadmap/RICE sia per le comunicazioni in uscita.

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook. L'`Elenco` funziona già in sola lettura. Per
> `Approvazione`/`Rifiuto`: esegui la lettura e mostra cosa
> verrebbe applicato a `target_file`, ma **non** modificare `target_file`,
> **non** spostare la voce in `product/approvals/decided/`, **non**
> invocare `governance-sync.sh push`; chiudi con `🔍 DRY-RUN — nessun
> file scritto, nessun commit, nessun push.`

## Elenco

Se l'utente chiede genericamente cosa c'è da approvare: `bash
.claude/hooks/governance-dump.sh backlog` (coda `pending/` + idee attive
per il contesto della tabella, in **una** tool call). Elenca ogni voce in
`product/approvals/pending/` con un riepilogo leggibile (non lo YAML
grezzo): tipo, cosa cambierebbe, chi/cosa l'ha proposto, quando. Ordina
per data, più vecchi prima — una coda che si accumula è un segnale da far
notare esplicitamente all'utente, non da nascondere.

Per le voci con un `target_file` che punta a un'idea (`rice_diff`,
`strategic_exception_flag`, `mandate_update`, `mandate_reclassification`)
non basta lo YAML del diff: si decide con lo stesso contesto della lista
ordinata del backlog. Quando queste voci sono più d'una, **rendile come
tabella** con una riga per voce e queste colonne:

- **Identificativo idea** — **prima colonna**, sempre valorizzato:
  `short_ref` se assegnato (es. `PG-042`), altrimenti l'`id` dell'idea (lo
  slug della cartella). Non lasciarlo vuoto e non inventare uno
  `short_ref` (lo assegna `backlog-refinement`). Vedi playbook, "Ogni
  elenco prodotto dal sistema è indirizzabile".
- **`summary`** dell'idea — se vuoto, "⚠ summary mancante", non il
  `title`.
- **R · I · C · E** e **RICE** *correnti* — dall'ultima voce approvata
  di `rice_history`; "—" e il motivo (`mandate`/`platform`/`bug`/`SE`/
  `senza RICE`) se non c'è (playbook, "Ogni riga che parla di un'idea si capisce da sola").
- **Tipo** di proposta (`rice_diff`, `strategic_exception_flag`, …).
- **Proposto** — per `rice_diff`: i quattro parametri e lo score del
  `payload` nella stessa forma compatta (`R4 I6 C8 E2 → 96`), col delta
  dello score vs. quello corrente (es. `480 (+120)`); marcato come
  proposto, mai mescolato nelle colonne correnti. Per gli altri tipi:
  "—".
- **Scadenza** — se l'idea ha `deadline.due_date` (o, per un `mandate`,
  `mandate.due_date`), mostrala con il suo `escalation_status`
  (`due_soon`/`at_risk`/`overdue` in evidenza). "—" se non c'è.
- **Bypass** — segnala se l'iniziativa scavalca il RICE e se il bypass è
  **coperto da un'approvazione o solo dichiarato**:
  - `Strategic Exception ✋ non approvata` — la voce è un
    `strategic_exception_flag` ancora in coda, **oppure** l'idea si
    presenta come `classification: strategic_exception` ma `strategic_exceptions`
    non ha ancora una voce corrispondente (dichiarata, bypass mai
    confermato — è un rischio di governance da rendere visibile qui, non
    da scoprire dopo).
  - `Strategic Exception ✓` — l'idea ha già almeno una voce approvata in
    `strategic_exceptions`.
  - `Mandate` (+ `mandate.escalation_status`) — `classification: mandate`,
    o la voce è un `mandate_reclassification` in attesa (`Mandate ✋ in
    riclassificazione`).
  - "—" per un'idea normale senza bypass.

Le voci senza `target_file` verso un'idea (`roadmap_snapshot`,
`iteration_plan`, `outbound_comm`, `context_update`) restano un riepilogo
in prosa (tipo, cosa cambierebbe, chi l'ha proposto, quando) — la tabella
non le riguarda. Per un `context_update`: mostra il documento sorgente (il
link), quale `context/*.md` verrebbe toccato, e il **razionale di
materialità** dal payload (perché `context-watch` l'ha giudicato un
cambiamento che inciderebbe su come si scrivono i PRD) — è la parte su cui
si decide se approvarlo.
Per un `iteration_plan`, il riepilogo mostra `iteration_goal`, quante voci
per bucket, e il diff `changes_since_last` (completate / avanzate /
slittate / rimosse / nuove) — è la parte che dice se vale la pena
approvarlo così com'è — e il `capacity_check`: saturazione per
competenza, e per ogni competenza `over` la decisione di sforamento
registrata (motivazione, chi). Una competenza `over` **senza**
`over_capacity_decision` va segnalata in evidenza: è uno sforamento non
deciso, da chiarire prima di approvare.

## Approvazione

Quando l'utente approva una voce specifica (per nome file o descrizione):

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)"). La coda o il `target_file`
   potrebbero essere cambiati per mano di un collega. Se l'helper segnala
   un disallineamento non-fast-forward, fermati e riferiscilo all'utente
   prima di applicare qualunque cosa.

1. Rileggi il file per intero, non fidarti del riepilogo precedente.
2. Applica `payload` a `target_file` secondo il `type`:
   - `rice_diff`: appendi la voce a `rice_history` nell'idea (mai
     sovrascrivere voci precedenti).
   - `roadmap_snapshot`: crea/sovrascrivi
     `product/roadmap/snapshots/{settimana}.yaml` col contenuto proposto.
   - `iteration_plan`: scrivi il `payload` in
     `product/roadmap/iterations/{settimana}.yaml` (`target_file` — crea
     la cartella `product/roadmap/iterations/` se non esiste). La serie è
     append-only: un file per settimana ISO, non sovrascrivere un file di
     una settimana diversa. Se esiste già un file per **questa** settimana
     (revisione da `iteration-planning`, `refined_by_iteration_planning:
     true`), sovrascrivilo col nuovo contenuto — è la stessa settimana,
     non una nuova voce di serie.
     **In più**, applica il puntatore denormalizzato sulle idee:
     - per ogni idea presente in un bucket del piano, scrivi
       `iteration.current` = la settimana del piano e `iteration.bucket` =
       il nome del bucket, direttamente sul suo `idea.yaml`;
     - per ogni idea che era in un bucket del piano `based_on` e **non**
       compare in nessun bucket di questo piano, azzera
       `iteration.current`/`iteration.bucket` sul suo `idea.yaml`.
     È denormalizzazione di una decisione approvata (scrittura diretta,
     stesso principio di `jira.status`) — la fonte di verità resta il file
     di iterazione. Il file di iterazione e **tutti** i puntatori
     `iteration.*` toccati viaggiano nello stesso commit atomico (passo 5,
     come `rice_diff` con la voce in `decided/` + `target_file`).
   - `outbound_comm`: non hai qui il compito di inviare fisicamente la
     comunicazione (email, ecc.) a meno che l'istanza abbia
     un'integrazione dedicata configurata — se non c'è, prepara il testo
     finale pronto per l'invio manuale da parte dell'utente. Prima di
     mostrarlo rileggi i `recipients` contro l'identikit
     (`product/reference/stakeholders.yaml`) e il rapporto locale del PM
     (`.governance/stakeholder-relationships.local.yaml`): se qualcuno ha
     punti di attenzione rilevanti per questo contenuto, dillo nella riga
     `Calibrazione: …` (solo in conversazione) e suggerisci un passaggio
     1:1 prima dell'invio — il testo approvato non si riscrive (playbook,
     "L'identikit degli stakeholder e il rapporto individuale").
   - `strategic_exception_flag`: appendi la voce a `strategic_exceptions`
     nell'idea (mai sovrascrivere voci precedenti — stesso principio
     append-only di `rice_history`). **In più**, appendi una riga
     sintetica a `product/reference/friction-log.yaml` (chi, quando,
     quale idea, `scenario: recurring_strategic_exception`) — è il modo
     in cui il framework rende visibile un pattern (la stessa persona che
     bypassa la priorità ogni settimana) senza dover ricostruire la
     storia idea per idea.
   - `mandate_update`: aggiorna i campi del blocco `mandate` sull'idea
     con i nuovi valori dal payload (`due_date`, `lead_time_weeks`,
     `mandated_by`, `rationale`, `is_critical` — solo quelli presenti nel
     payload, non toccare gli altri). **Non toccare mai
     `analysis_start_by`/`escalation_status`** — sono calcolati da
     `mandate-watch`, non da questa approvazione; se il cambio di
     `due_date`/`lead_time_weeks` li rende stale, segnala all'utente di
     rilanciare `mandate-watch` dopo l'approvazione, non ricalcolarli qui.
   - `context_update`: invoca `context-intake` per scrivere la
     trascrizione proposta nel `target_file` (`context/<argomento>.md`) e
     aggiornare `context/.sources-seen.yaml` per quel documento
     (`revision`, `transcribed_at` = oggi, `materiality: material`,
     `pending_ref` azzerato). Non trascrivi tu qui a mano: `context-intake`
     ha già il contratto (cita la fonte, non tocca la cartella sorgente,
     documento vivo non log). Il `context/*.md` e `.sources-seen.yaml`
     viaggiano nello stesso commit della voce spostata in `decided/`.
   - `mandate_reclassification`: cambia `classification` a `mandate` e
     popola il blocco `mandate` con i valori iniziali del payload
     (`mandated_by`, `rationale`, `is_critical`, `due_date`,
     `lead_time_weeks`). **Non toccare `rice_history`** — resta
     esattamente com'era, append-only, come registro storico di cosa
     l'idea valeva nel processo RICE normale prima della
     riclassificazione. Non compilare `analysis_start_by`/
     `escalation_status`: li calcola `mandate-watch` al run successivo.
     Se l'idea aveva un blocco `deadline` valorizzato, lascialo intatto
     (diventa ridondante con `mandate.due_date` ma non va rimosso — è
     parte della storia di come si è arrivati alla riclassificazione).
3. Imposta `decision: approved`, `decided_by` (chiedi conferma di chi sta
   approvando se non ovvio dal contesto), `decided_at`.
4. Sposta il file da `product/approvals/pending/` a
   `product/approvals/decided/`.
5. **Sincronizza il repo in un unico commit atomico** — la voce spostata
   in `decided/` e il `target_file` aggiornato devono viaggiare insieme:
   `bash .claude/hooks/governance-sync.sh push "pending-approval: approvata <nome-voce>" product/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Per un
   `context_update` il `target_file` è sotto `context/`: aggiungilo ai
   path del push (`… product/ context/`) così `context/*.md` e
   `.sources-seen.yaml` viaggiano nello stesso commit.
6. Conferma all'utente cosa è stato effettivamente scritto/cambiato; se
   l'helper ha segnalato un push fallito, dillo.
7. **Rigenera la roadmap aggiornata**, una volta sola alla fine del giro
   di approvazioni (non dopo ogni voce: un batch di 12 `rice_diff`
   produce una rigenerazione, non 12). Se nel giro è stato approvato
   almeno un `iteration_plan`, `rice_diff`, `strategic_exception_flag`,
   `mandate_update`, `mandate_reclassification` o `roadmap_snapshot`,
   richiama `report-render` in modalità ceremony con `trigger: approval`
   e l'elenco delle voci approvate: le viste `cadence: per_ceremony`
   escono con il piano e i RICE appena approvati, e il banner "in attesa
   di approvazione" lasciato dalla cerimonia sparisce. Non chiedere se
   farlo; riporta in una riga cosa è cambiato nella roadmap. Un rifiuto
   non la rigenera (la roadmap mostrava già l'approvato), un
   `outbound_comm` o un `context_update` nemmeno.
8. **Prepara l'aggiornamento settimanale**, se nel giro è stato approvato
   un `roadmap_snapshot`: per ogni vista dichiarata in
   `reporting-models.yaml` con modello `framework:aggiornamento-settimanale`
   (o un modello aziendale che lo estende) e `cadence: weekly`, che non
   ha ancora un report per la settimana dello snapshot, richiama
   `report-render` in modalità render su quella vista e quel periodo. Il
   report esce con le consegne stimate e gli spostamenti dallo snapshot
   appena approvato; per un pubblico fuori dal team `report-render`
   mette la mail in `pending/` come `outbound_comm` — **non parte
   nulla**: la manda il PM dopo averla approvata. Non chiedere se farlo
   (è una proposta, non un invio); riporta in una riga cosa hai
   preparato. Se il report della settimana esiste già, non rigenerarlo
   da solo: dillo e lascia decidere al PM. Nessuna vista settimanale
   dichiarata → nessuna azione, al più una riga che suggerisce
   `report-render` setup.

## Rifiuto

0. **Sincronizza da `origin`** (stesso passo 0 della sezione Approvazione
   sopra) prima di procedere.
1. Imposta `decision: rejected`, `decided_by`, `decided_at`, e chiedi
   (o registra se già fornita) una `notes` col motivo — serve per
   l'audit trail, non lasciarla vuota.
2. Sposta comunque il file in `product/approvals/decided/` — un rifiuto è
   una decisione tracciata, non va cancellato.
3. **Non applicare nulla a `target_file`.** Per un `context_update`
   rifiutato: in `context/.sources-seen.yaml`, sulla voce del documento,
   azzera `pending_ref` e scrivi `rejected_revision` = la revisione
   rifiutata, così `context-watch` non la ri-accoda (aspetterà una
   revisione successiva del documento).
4. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "pending-approval: rifiutata <nome-voce>" product/approvals/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Per un
   `context_update` rifiutato aggiungi `context/` ai path del push (hai
   toccato `context/.sources-seen.yaml`).

## Regole generali

- Non approvare né rifiutare mai di propria iniziativa: solo su istruzione
  esplicita dell'utente per quella specifica voce. "Approva tutto" è
  un'istruzione valida se l'utente la dà esplicitamente, ma va comunque
  eseguita voce per voce (log distinto per ciascuna), non con una
  scrittura unica indistinta.
- Il **Backlog Refinement è il luogo previsto** per rivedere la coda dei
  `rice_diff` (playbook, "Product Backlog Refinement"): quando
  `backlog-refinement` cammina la coda con il team e il PM decide voce per
  voce, quella **è** istruzione esplicita — applicala normalmente. Vale
  anche l'approvazione in blocco di un batch coerente (primo scoring di un
  intake storico) se il PM lo indica esplicitamente, sempre eseguita una
  voce alla volta.
- Se una proposta in `pending/` è più vecchia di qualche settimana,
  segnalalo: potrebbe essere basata su dati non più attuali (es. un RICE
  diff calcolato prima di un'altra revisione più recente della stessa
  idea).
