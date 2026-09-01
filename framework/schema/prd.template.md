---
# Template per product/prds/{slug}/prd.md (o prd-1-*.md, prd-2-*.md se la
# iniziativa si spacca in più documenti — vedi playbook, "PRD sizing:
# il principio dell'A3 Thinking").
#
# Vincolo dimensionale: l'intero corpo Markdown sotto il frontmatter deve
# poter essere letto e verificato in un'unica iterazione di lettura — circa
# due facciate A4 se esportato in PDF. Se serve più spazio, non comprimere
# la prosa: spacca in un nuovo PRD lungo le cuciture del problema (rischio
# tecnico, owner o stakeholder distinti), non per conteggio di pagine.
id: "slug-descrittivo"              # coincide col nome della cartella
idea_id: ""                         # link all'idea di origine — il RICE NON si ripete qui, solo il link
owner: ""
status: draft                       # draft | in_review | approved | superseded
reading_sequence:
  position: 1
  of: 1
  prev: null
  next: null
release_sequence:
  position: null
  of: null
  dependency: null                  # read_only | release_blocking | independent
created_at: "2026-01-08"
---

## Why

<!-- Poche righe: il problema e perché ora. Non un saggio. -->

## What

<!-- Scope preciso, elenco puntato, non narrativa. -->

## Who

<!-- Solo se rilevante — spesso è già ovvio dalla strategia e va omesso. -->

## Metriche

<!-- 1-3 KPI massimo, con baseline e target. Il ragionamento su come si è
     arrivati a scegliere la metrica resta nell'idea di origine, non qui.

     Per OGNI KPI, dichiara anche come si recupereranno i dati per
     costruirla e osservarla nel tempo — non solo cosa si misura, ma da
     dove viene il numero:
     - Manuale: il PM la controlla lui (es. query occasionale su
       DataBricks, report ricevuto da un altro team). La metrica non
       entra nell'osservazione automatica — measurement-watch chiederà
       sempre il valore, non proverà a recuperarlo da solo.
     - Automatizzata: l'istanza ha (o prevede di avere) un'integrazione
       che può leggere il dato in autonomia. Richiede una configurazione
       locale dedicata (mai credenziali in questo repo — vedi
       framework/docs/future-work.md): finché non esiste, si comporta
       come manuale.
     Questa è una scelta esplicita del PM per ciascuna KPI, non un
     default: va dichiarata qui, non decisa da una skill.

     Se l'iniziativa non ha un'ipotesi di impatto su una metrica di
     business (tipico per iniziative di mera compliance normativa), non
     forzare una metrica proxy: scrivi "N/A — nessuna metrica di business
     attesa" con una riga sul perché. Va comunque compilato
     measurement.yaml con kpis vuoto e not_applicable_reason (skill
     prd-draft) — l'iniziativa resta da chiudere esplicitamente più
     avanti (skill measurement-watch), non sparisce dal tracciamento
     solo perché non ha KPI. -->

## How

<!-- Bullet ad alto livello: cosa serve sapere per capire il footprint del
     cambiamento (sistemi e componenti toccati, interfacce, blast radius) e
     stimare la delivery — non la specifica tecnica completa. È la fase in
     cui l'Entanglement del RICE, stimato all'intake come prima passata, si
     può raffinare: se cambia, la revisione passa da rice-update. -->

## Rischi e dipendenze aperte

## Link al prossimo PRD della sequenza

<!-- Se esiste, dichiara esplicitamente se è dipendenza di lettura o di
     rilascio (release_sequence.dependency sopra). -->
