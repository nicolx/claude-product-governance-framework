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
     assoluto, chiedi il target annuale di riferimento della Product Line
     (o dell'istanza) per convertirlo in punti in modo coerente con le
     altre idee.
   - **Confidence**: 1-10, classificando la fonte secondo le soglie del
     playbook (opinione 1-3, aneddotico 3-6, quantitativo singola fonte
     6-8, quantitativo multi-fonte >8). Chiedi esplicitamente che tipo di
     evidenza c'è dietro la stima — non dedurlo dal tono del messaggio.
   - **Effort**: settimane stimate. Se disponibile, chiedi conferma a un
     referente tecnico prima di considerarla definitiva.

3. Calcola `score = reach_percent * impact_points * confidence_score /
   effort_weeks`.

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
