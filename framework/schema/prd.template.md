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
     arrivati a scegliere la metrica resta nell'idea di origine, non qui. -->

## How

<!-- Bullet ad alto livello: cosa serve sapere per stimare l'effort,
     non la specifica tecnica completa. -->

## Rischi e dipendenze aperte

## Link al prossimo PRD della sequenza

<!-- Se esiste, dichiara esplicitamente se è dipendenza di lettura o di
     rilascio (release_sequence.dependency sopra). -->
