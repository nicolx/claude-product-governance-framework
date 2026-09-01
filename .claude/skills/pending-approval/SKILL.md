---
name: pending-approval
description: Elenca, spiega e applica (o rifiuta) le proposte in product/approvals/pending/ — l'unico punto in cui un diff di RICE, uno snapshot di roadmap, una Strategic Exception rilevata in Backlog Refinement, un aggiornamento a un'iniziativa mandataria, o una comunicazione in uscita passano da proposti ad effettivi. Usala per rivedere la coda.
---

# pending-approval

Gestisce la coda unica di "pending approval" del framework — il
meccanismo per cui **l'automazione propone, un umano decide**, sia per i
diff di roadmap/RICE sia per le comunicazioni in uscita.

## Elenco

Se l'utente chiede genericamente cosa c'è da approvare, elenca tutti i
file in `product/approvals/pending/`, per ciascuno un riepilogo leggibile
(non lo YAML grezzo): tipo, cosa cambierebbe, chi/cosa l'ha proposto,
quando. Ordina per data, più vecchi prima — una coda che si accumula è un
segnale da far notare esplicitamente all'utente, non da nascondere.

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
   - `outbound_comm`: non hai qui il compito di inviare fisicamente la
     comunicazione (email, ecc.) a meno che l'istanza abbia
     un'integrazione dedicata configurata — se non c'è, prepara il testo
     finale pronto per l'invio manuale da parte dell'utente.
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
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)").
6. Conferma all'utente cosa è stato effettivamente scritto/cambiato; se
   l'helper ha segnalato un push fallito, dillo.

## Rifiuto

0. **Sincronizza da `origin`** (stesso passo 0 della sezione Approvazione
   sopra) prima di procedere.
1. Imposta `decision: rejected`, `decided_by`, `decided_at`, e chiedi
   (o registra se già fornita) una `notes` col motivo — serve per
   l'audit trail, non lasciarla vuota.
2. Sposta comunque il file in `product/approvals/decided/` — un rifiuto è
   una decisione tracciata, non va cancellato.
3. **Non applicare nulla a `target_file`.**
4. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "pending-approval: rifiutata <nome-voce>" product/approvals/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)").

## Regole generali

- Non approvare né rifiutare mai di propria iniziativa: solo su istruzione
  esplicita dell'utente per quella specifica voce. "Approva tutto" è
  un'istruzione valida se l'utente la dà esplicitamente, ma va comunque
  eseguita voce per voce (log distinto per ciascuna), non con una
  scrittura unica indistinta.
- Se una proposta in `pending/` è più vecchia di qualche settimana,
  segnalalo: potrebbe essere basata su dati non più attuali (es. un RICE
  diff calcolato prima di un'altra revisione più recente della stessa
  idea).
