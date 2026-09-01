---
name: rice-update
description: Propone una nuova voce di RICE (iniziale o revisione) per un'idea esistente, calcolando lo score e scrivendo la proposta in product/approvals/pending/ — non scrive mai direttamente su idea.yaml. Usala per il primo scoring o quando nuova evidenza cambia una stima.
---

# rice-update

Propone un aggiornamento del RICE per un'idea esistente in
`product/ideas/{slug}/idea.yaml` — sia il primo scoring dopo l'intake, sia
una revisione per nuova evidenza. Segue il playbook (sezione "Ideas
prioritization").

## Regola fondamentale

**Non scrive mai direttamente `rice_history` in `idea.yaml`.** Scrive
sempre una proposta in `product/approvals/pending/`, con
`target_file` puntato all'idea e `type: rice_diff`. Solo dopo approvazione
umana esplicita (skill `pending-approval`) la voce viene appesa a
`rice_history` — che resta append-only: mai sovrascrivere voci precedenti.

## Passi

1. Identifica l'idea (per slug, o aiutando l'utente a trovarla se
   descritta a parole).

2. Raccogli input per i quattro parametri, chiedendo esplicitamente ciò
   che manca — non inventare numeri:
   - **Reach**: percentuale (0-100) sulla popolazione della Product Line
     dell'idea. Usa `reach_denominator` da
     `product/reference/product-lines.yaml` per convertire un numero
     assoluto in percentuale se l'utente fornisce solo l'assoluto. Se il
     denominatore è `null`, segnala che il Reach risultante è
     un'approssimazione (per playbook) e chiedi se procedere comunque.
   - **Impact**: punti 1-10. Se l'utente fornisce un valore economico
     assoluto, leggi `product/reference/annual-target.yaml` e converti:
     `impact_points ≈ round(valore_iniziativa / target * 10)`, dove
     `target` è l'override della Product Line dell'idea se presente in
     `per_product_line`, altrimenti `value` a livello di istanza.
     **`value` è l'incremento atteso nell'anno, non il totale a budget**
     — se per qualche motivo devi ricavarlo da un totale, calcola il
     delta e fallo confermare, non usare il totale. **Tappa a 10**: se il
     valore dell'iniziativa eguaglia o supera l'intero incremento annuo,
     `impact_points: 10`, la scala non va oltre. Se `value` è `null`
     (target non ancora dichiarato), segnala che l'Impact risultante è
     un'approssimazione qualitativa (per playbook, come per il
     denominatore Reach) e chiedi all'utente il punteggio 1-10 a
     giudizio, annotandolo nel `rationale`.
   - **Confidence**: 1-10, classificando la fonte secondo le soglie del
     playbook (opinione 1-3, aneddotico 3-6, quantitativo singola fonte
     6-8, quantitativo multi-fonte >8). Chiedi esplicitamente che tipo di
     evidenza c'è dietro la stima — non dedurlo dal tono del messaggio.
   - **Entanglement** (footprint del cambiamento, 1-10 — **non**
     settimane): vedi playbook, "Ideas prioritization", per la scala
     completa. Quanto l'iniziativa è intrecciata col sistema: componenti,
     sistemi e team toccati, superficie di regressione, complessità di
     review/rollout, più eventuali costi esterni hard (legale, licenze,
     UAT estesa).
     - **Se i repository sono montati in `apps/`**: ispezionali per
       collocare l'ordine di grandezza — quali moduli/sistemi tocca
       l'iniziativa, che interfacce e consumer sono coinvolti, quanto è
       accoppiato ciò che cambia. È una passata leggera, non una Complete
       Analysis. Registra `entanglement_basis: code_inspection` e
       riassumi in `entanglement_note` cosa hai visto (sistemi,
       interfacce, consumer). Se l'iniziativa è un primo scoring di un
       intake storico bulk (playbook, "Intake storico e roadmap
       pre-esistente"), salta l'ispezione e metti un valore grezzo con
       `entanglement_basis: structured_estimate` e una nota.
     - **Se `apps/` non è collegato, o l'iniziativa tocca sistemi non
       montati**: stima con un referente tecnico, registra
       `entanglement_basis: structured_estimate` e segnala nel `rationale`
       che l'evidenza sul footprint è più debole.
     - In entrambi i casi è una **prima passata**: la Preliminary/Complete
       Analysis può cambiare il quadro, e quella revisione entra come
       nuova voce in `rice_history` (append-only).

3. Calcola `score = reach_percent * impact_points * confidence_score /
   entanglement_score`.

4. Scrivi `rationale` che spiega perché questi valori (riferimento alla
   discussione/evidenza, non solo i numeri nudi) e `approved_by` con chi
   li ha validati. Se la revisione nasce da una cerimonia già loggata,
   valorizza `ceremony_ref` col percorso.

5. Crea il file in `product/approvals/pending/{data}-{slug-idea}-rice.yaml`
   usando `framework/schema/approval.template.yaml`: `type: rice_diff`,
   `payload` con la nuova voce di `rice_history` completa, `target_file`
   puntato a `product/ideas/{slug}/idea.yaml`.

6. Mostra chiaramente la proposta all'utente e ricordagli che resta in
   `pending/` finché non viene approvata esplicitamente (skill
   `pending-approval`) — non applicarla da solo, nemmeno se l'utente
   sembra già d'accordo nella stessa conversazione: l'approvazione è un
   passo distinto e tracciato.

7. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "rice-update: proposta RICE per <slug>" product/approvals/pending/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se l'helper
   segnala un push fallito, riferiscilo all'utente.
