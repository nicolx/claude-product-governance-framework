---
name: measurement-watch
description: Scansiona le iniziative già rilasciate (idea status "done") e verifica se le loro KPI stanno mostrando gli impatti attesi, chiedendo al PM le letture correnti quando è passata la finestra di misurazione. Segnala quali meritano un follow-up e quali possono essere chiuse. Usala periodicamente e sempre all'apertura del Backlog Refinement.
---

# measurement-watch

Un'iniziativa rilasciata non finisce il suo ciclo con il deploy — la
Definition of Done risponde a "abbiamo consegnato?", non a "ha
funzionato?" (playbook, "Product Design, development and rollout" /
"Measurement"). Questa skill è il meccanismo che impedisce che la
domanda "ha funzionato?" resti senza risposta perché nessuno se n'è più
occupato: se un'iniziativa è in produzione da settimane, qualcuno deve
controllare le KPI dichiarate nel suo PRD e decidere se c'è un impatto,
serve ancora tempo, o l'ipotesi non ha retto.

## Quando usarla

- **Standalone**, in qualunque momento: "quali iniziative dovrebbero
  già mostrare impatti?", "controlliamo lo stato delle misurazioni".
- **Richiamata da `log-ceremony`**, e idealmente **in apertura** del
  Backlog Refinement (playbook, sezione "Product Backlog Refinement"):
  prima di guardare cosa entra in agenda, si guarda cosa è già stato
  rilasciato e se sta rendendo — è tracciare le metriche su Git, nel
  tempo, che permette di capire dove veicolare gli investimenti futuri.

## Passi

1. **Elenca le iniziative rilevanti**: idee con `status: done` e
   `done_at` valorizzato, che hanno almeno un PRD collegato (`links.prd_ids`
   non vuoto) con un `measurement.yaml` (o `measurement-N.yaml`) nella
   sua cartella. Se `status: done` ma `done_at` è `null`, chiedi al PM la
   data (**mai presumere "oggi"**) e scrivila su `idea.yaml` prima di
   procedere con quella iniziativa — è un fatto mancante, non una
   decisione, scrittura diretta.

2. **Per ciascuna KPI in ciascun `measurement.yaml`**, calcola le
   settimane trascorse da `done_at` e confrontale con
   `measurement_window_weeks`:
   - Se non ancora passata: `measurement_status: pending`, non serve
     fare nulla — non è ancora il momento di aspettarsi impatti.
   - Se passata e `readings` è vuoto: `measurement_status: check_due` —
     **questo è il caso centrale**: chiedi al PM il valore attuale della
     metrica (ha accesso agli strumenti di analytics dell'istanza, per
     playbook). Se il PM lo fornisce, appendi una nuova voce a
     `readings` con `date`, `value`, `source`. Se il PM non lo sa ancora,
     lascialo `check_due` e segnalalo comunque nel riepilogo — non è un
     errore, è un'informazione che manca.
   - Se passata e ci sono già `readings`: confronta l'ultima lettura con
     `baseline`/`target` (attenzione alla direzione attesa — un
     miglioramento può essere un aumento o una diminuzione a seconda
     della metrica, non presumere sempre "più alto è meglio") e imposta
     `measurement_status` tra `on_track`/`achieved`/`at_risk`/
     `invalidated`/`inconclusive`. Se il dato più recente ha più di
     `measurement_window_weeks` di anzianità, chiedi comunque al PM se
     c'è una lettura più fresca prima di dare per buono un giudizio
     stantio.

3. **Scrivi `measurement_status` direttamente** su `measurement.yaml` —
   è una valutazione calcolata dai dati, non una decisione di priorità,
   **non passa da `product/approvals/pending/`** (stesso principio di
   `escalation_status` in `mandate-watch`).

4. **Per le KPI `at_risk` o `invalidated`, chiedi esplicitamente al PM**
   se serve un follow-up: "I dati suggeriscono che l'ipotesi non sta
   reggendo — vuoi che prepari una nuova idea per iterare (via
   `idea-intake`), o consideriamo chiusa questa iniziativa così com'è?"
   Se il PM conferma che serve un follow-up, imposta
   `follow_up_needed: true` e **suggerisci** di lanciare `idea-intake`
   sul follow-up — **non creare tu stessa la nuova idea**, è una
   decisione del PM, non un'inferenza automatica.

5. **Per le KPI che il PM decide esplicitamente di non seguire più**
   (raggiunto l'obiettivo e non serve più monitorare, oppure il
   contrario — si accetta che non ha funzionato e si chiude) — solo su
   indicazione esplicita, mai di iniziativa propria — scrivi
   `measurement_status: concluded`. Da quel momento questa KPI non
   compare più negli alert dei run successivi.

6. **Presenta un riepilogo ordinato per urgenza** (`check_due` e
   `at_risk`/`invalidated` prima, poi `on_track`, `achieved`/`concluded`
   solo se richiesti esplicitamente): per ciascuna, `idea_id`, nome
   della KPI, settimane da `done_at`, ultimo valore noto vs.
   baseline/target. **Solo segnalazione** — nessuna comunicazione o
   escalation automatica, stesso principio di `mandate-watch`.

7. Se chiamata da `log-ceremony`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa in
   `decisions.yaml`, è compito di `log-ceremony`.

## Cosa NON fare

- Non inventare un valore di lettura per completare uno schema — se il
  PM non lo sa, resta `check_due`, non forzare un numero.
- Non decidere autonomamente che un'iniziativa è `achieved`/`invalidated`
  senza dati reali a supporto — un giudizio senza readings è
  `inconclusive`, non un esito positivo o negativo per default.
- Non creare una nuova idea di follow-up di tua iniziativa — proponilo,
  la creazione resta un passo esplicito del PM tramite `idea-intake`.
- Non impostare `concluded` senza una decisione esplicita del PM in
  questa conversazione.
