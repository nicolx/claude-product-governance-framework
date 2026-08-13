---
name: prd-draft
description: Redige un PRD "A3-sized" a partire da un'idea già prioritizzata, con visibilità sui submodule applicativi in apps/ quando presenti, e scaffolda measurement.yaml per le KPI dichiarate. Applica il vincolo dimensionale e il criterio di split del playbook — non duplica mai il RICE.
---

# prd-draft

Redige un PRD a partire da un'idea già passata da Ideas Prioritization,
applicando il principio di A3 Thinking del playbook (sezione "Complete
analysis" → "PRD sizing").

## Prerequisiti

L'idea deve avere almeno una voce in `rice_history` (score approvato,
quindi presente in `product/ideas/{slug}/idea.yaml`, non solo in
`approvals/pending/`). Se non ce l'ha, segnalalo e proponi di passare
prima da `rice-update`.

## Il differenziale di questo framework: leggere la codebase reale

Se l'istanza ha repository applicativi collegati in `apps/` (submodule),
**leggili prima di scrivere l'How** — non limitarti a chiedere all'utente
come funziona il sistema se puoi verificarlo tu stesso nel codice. Questo
è il differenziale esplicito rispetto a un tool di roadmap tradizionale:
le implicazioni tecniche vanno considerate fin dall'authoring, non
scoperte dopo. Se `apps/` è vuota o non pertinente al tema del PRD, procedi
normalmente senza bloccarti.

## Passi

1. Leggi `product/ideas/{slug}/idea.yaml` (Why implicito dal contesto
   dell'idea, ultima voce di `rice_history` per capire cosa è stato
   valutato) e tutto il materiale in `source/`.

2. Se esiste già una Preliminary/Complete Analysis registrata (es. in
   `product/ceremonies/` o note fornite dall'utente), usala come base per
   Why/What — non ripartire da zero se l'analisi è già stata fatta a
   voce.

3. Redigi seguendo `framework/schema/prd.template.md`: Why (poche righe),
   What (elenco puntato), Who (solo se rilevante — ometti se ovvio),
   Metriche con baseline e target **se l'iniziativa ne ha** (vedi passo 4
   per il caso in cui non ne ha), How ad alto livello (informato dalla
   lettura di `apps/` quando disponibile), Rischi e dipendenze aperte.

4. **Scaffolda `measurement.yaml`** (o `measurement-N.yaml` se questo è
   uno dei più PRD della cartella — stessa numerazione del file
   `prd-N-*.md` corrispondente) a partire da
   `framework/schema/measurement.template.yaml`.
   - **Caso normale**: una voce in `kpis` per ciascuna metrica scritta
     nella sezione Metriche del PRD (stesso `name`, `baseline`, `target`,
     `unit`). Non è una duplicazione: la sezione Metriche del PRD resta
     la fonte narrativa (perché quella metrica, il ragionamento),
     `measurement.yaml` è solo la sua rappresentazione strutturata
     perché `measurement-watch` possa leggerla senza fare parsing di
     Markdown libero. Chiedi (non presumere) `measurement_window_weeks`
     se l'utente/referente tecnico ha un'aspettativa diversa dal default
     nel template.
   - **Caso senza KPI di business** (tipico per iniziative di mera
     compliance, spesso `classification: mandate`): se durante la
     stesura emerge che non c'è un'ipotesi "questo migliorerà la metrica
     X" — solo un obbligo da soddisfare — **non forzare una metrica
     proxy per riempire la sezione**. Scrivi nella sezione Metriche del
     PRD stesso qualcosa come "N/A — nessuna metrica di business attesa,
     iniziativa di compliance" (motivandolo in una riga), e lascia
     `kpis: []` in `measurement.yaml` compilando `not_applicable_reason`
     con lo stesso motivo. Resta comunque un'iniziativa da chiudere
     esplicitamente più avanti (skill `measurement-watch`, blocco
     `closure`) — non sparisce dal framework solo perché non ha KPI.

5. **Applica il vincolo dimensionale attivamente, non solo a
   consuntivo**: se durante la stesura ti accorgi che il contenuto
   necessario eccede ~2 facciate A4, **fermati e proponi lo split** lungo
   le cuciture del problema (rischio tecnico, owner, o stakeholder
   distinti) — non comprimere la prosa per farcelo stare. Motiva
   esplicitamente il criterio di split scelto.

6. Se generi più PRD per la stessa idea, crea più file nella stessa
   cartella `product/prds/{slug}/` (es. `prd-1-{sub-slug}.md`,
   `prd-2-{sub-slug}.md`), con il rispettivo `measurement-1.yaml`/
   `measurement-2.yaml`, e compila `reading_sequence` e
   `release_sequence` in ciascun frontmatter **dichiarandole
   separatamente** — non assumere che l'ordine di lettura coincida con
   l'ordine di rilascio.

7. **Non ripetere il RICE**: nel PRD va solo `idea_id` che linka
   all'idea. Se durante la stesura emerge che il RICE andrebbe rivisto
   (ROI diverso da quanto stimato), non modificarlo qui — segnalalo
   all'utente e proponi di lanciare `rice-update`.

8. **Non ridescrivere framework generali** (Business Model Canvas, GTM,
   glossario di dominio) — cita solo la scelta specifica fatta per questo
   caso, con link al documento canonico se l'istanza ne ha uno in
   `product/reference/`.

9. Aggiorna `idea.yaml`: aggiungi lo/gli slug del PRD a `links.prd_ids` e
   valuta se `status` va portato a `in_prd` — questo è un aggiornamento di
   metadato dell'idea, non un diff di RICE: se l'istanza tratta anche
   questo come modifica soggetta ad approvazione, passa da
   `product/approvals/pending/`; altrimenti applicalo direttamente e
   segnalalo chiaramente nel riepilogo finale.
