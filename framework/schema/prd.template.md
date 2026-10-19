---
# Template per product/prds/{slug}/prd.md (o prd-1-*.md, prd-2-*.md se la
# iniziativa si spacca in più documenti — vedi playbook, "PRD sizing:
# il principio dell'A3 Thinking").
#
# Vincolo dimensionale: l'intero corpo Markdown sotto il frontmatter deve
# poter essere letto e verificato in un'unica iterazione di lettura — circa
# due facciate A4 se esportato in PDF. Se serve più spazio, non comprimere
# la prosa: spacca in un nuovo PRD lungo le cuciture del problema (rischio
# tecnico, owner, stakeholder o LETTORE distinti), non per conteggio di pagine.
# Il contesto narrativo comune a tutti i PRD dell'iniziativa sta nel BRIEF
# (README.md della cartella, framework/schema/initiative-brief.template.md);
# dati, parametri e testi di un PoC in un ALLEGATO
# (framework/schema/prd-annex.template.md). Così il PRD resta A3 senza
# perdere informazione.
#
# Scrivere per il lettore (playbook, "Scrivere per il lettore: dalla fonte
# all'artefatto"): il PRD deve reggersi da solo, insieme al brief, per chi
# NON ha partecipato a nessuna conversazione — persona o agente (es. un
# Claude di design o di sviluppo) senza accesso alla sessione, alla memoria
# locale o a context/. Niente "come detto in call", niente percorsi locali,
# niente id interni non spiegati (eccezione: riferimenti a codice e ticket
# nei PRD con primary_reader: tech, il cui lettore ha accesso ai repository).
id: "slug-descrittivo"              # coincide col nome della cartella
idea_id: ""                         # link all'idea di origine — il RICE NON si ripete qui, solo il link
owner: ""
tech_reference: ""                  # sviluppatore con cui validare l'How (skill team-fit, dal roster product/reference/team.yaml).
                                    # È il referente per la revisione del documento e la prima scelta naturale in assegnazione —
                                    # NON l'assegnazione formale di implementazione (quella si decide in Iteration Planning e vive
                                    # nel tracker). "" se team.yaml non è ancora popolato. Scrittura diretta come owner/status.
primary_reader: stakeholder         # design | tech | business | legal_finance | stakeholder | pm — CHI deve poter
                                    #   lavorare con questo documento senza tornare a chiedere. Decide cosa mettere in
                                    #   evidenza (tabella in fondo al template). Chiesto da prd-draft, mai presunto.
prd_kind: delivery                  # discovery (PoC/prototipo: si vuole IMPARARE) | delivery (si vuole RILASCIARE)
brief_ref: "README.md"              # brief d'iniziativa; null solo se il brief non è obbligatorio (un solo PRD, lettore pm/stakeholder)
status: draft                       # draft | in_review | approved | superseded
                                    #   draft → in_review solo dopo almeno una lettura a freddo, un panel di revisione
                                    #   senza blocker aperti e con il registro dei punti chiave senza punti "open"
                                    #   (prd-draft); in_review → approved: decisione umana (il panel non approva).
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
updated_at: "2026-01-08"
---

# {PRD-N · Titolo}

<!-- Una riga in corsivo: per chi è il documento, cosa leggere prima (il brief), dove sono
     dati e materiali (allegato, assets/). -->

## Why

<!-- Il problema e perché ora, comprensibile senza aver partecipato ad alcuna conversazione.
     Fino a ~8 righe. Se c'è un brief, RICHIAMALO invece di riscrivere la storia. -->

## Scenario

<!-- OBBLIGATORIO. 3-6 righe, meglio con personaggi concreti: chi, in quale momento, cosa
     fa con il risultato, cosa deve succedere dopo, eventuali destinatari indiretti (chi
     va convinto senza usare il prodotto). Sostituisce il vecchio "Who": lo scenario è
     sempre rilevante per chi deve costruire. -->

## What

<!-- Scope preciso. Per primary_reader: design, l'ordine e la gerarchia contano (cosa si
     vede per primo, cosa porta a cosa) — non un elenco di widget equivalenti. Per
     prd_kind: discovery, rimanda all'allegato per dati e testi. -->

## Vincoli di design

<!-- OPZIONALE, consigliata per primary_reader: design. Cosa NON si può mostrare o dire e
     perché, in linguaggio non legale; etichette ammesse/vietate; tono. -->

## Cosa vogliamo imparare

<!-- SOLO per prd_kind: discovery, AL POSTO di "Metriche". Contiene:
     - ipotesi da testare, una riga ciascuna, falsificabili;
     - per ciascuna, il segnale che la conferma e quello che la smentisce, in forma di
       COMPORTAMENTI, non di opinioni (tabella);
     - le varianti da confrontare;
     - il protocollo di feedback (chi, quante sessioni, domande guida);
     - l'esito atteso: la decisione che il PoC deve abilitare.
     measurement-N.yaml resta con kpis: [] e not_applicable_reason. -->

## Metriche

<!-- SOLO per prd_kind: delivery. 1-3 KPI massimo, con baseline e target. Il ragionamento
     su come si è arrivati a scegliere la metrica resta nell'idea di origine, non qui.

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

     Con una fonte analytics collegata, l'idea ha già i suoi path da
     monitorare (idea.yaml, blocco monitoring — skill path-watch): una
     KPI automatizzata può dichiarare da quale path si legge (id del
     path → data_source.path_ref in measurement.yaml), e la sua baseline
     è quella già letta sul path. I path "da strumentare" diventano qui
     un REQUISITO DI TRACCIAMENTO: quali eventi aggiungere, con che nome,
     da consegnare nella stessa iterazione della feature.

     KPI con finestre di osservazione diverse (es. metriche anticipatorie a
     poche settimane, metrica principale a un anno): un file di misura per
     finestra, measurement-N-{suffisso}.yaml (measurement-watch li legge
     tutti); quello senza suffisso è la valutazione complessiva.

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
     può raffinare: se cambia, la revisione passa da rice-update.
     Per primary_reader diverso da tech: tienilo minimo e senza gergo.

     Chiudi la sezione con una riga sul referente tecnico (frontmatter
     tech_reference) e perché: chi conosce i sistemi toccati / copre i
     rischi aperti. Es.:
     _Validare l'How con: Gastone (owner approval-engine; copre il rischio
     su Postgres). Shortlist completa: `team-fit {slug}`._ -->

## Rischi e dipendenze aperte

<!-- Rischi tecnici e di prodotto ancora aperti, dipendenze da altri team o
     sistemi. Qui anche i rilievi del panel di revisione ACCETTATI dal PM come
     rischio dichiarato, ciascuno con il segnale che lo farebbe riaprire. -->

## Provenienza

<!-- Breve, tre liste:
     - dalla fonte: cosa viene dal materiale originale (eventualmente con gli id del
       registro, KP-03…);
     - aggiunto dall'analisi: vincoli, riferimenti di codice, benchmark, correzioni emerse
       dalla lettura a freddo e dal panel di revisione;
     - deciso dal PM in conversazione, con data.
     Rende visibile l'arricchimento (P5): il PM lo convalida invece di scoprirlo. -->

## Prossimo documento

<!-- Se esiste, dichiara esplicitamente se è dipendenza di lettura o di
     rilascio (release_sequence.dependency sopra). -->

<!--
Orientamento per primary_reader — cosa mettere in evidenza / cosa ridurre al minimo:

| primary_reader  | In evidenza                                                                 | Al minimo                     |
|-----------------|-----------------------------------------------------------------------------|-------------------------------|
| design          | Scenario, gerarchia del racconto, contenuti di esempio (dal brief/allegato), Vincoli di design | stack, repository, articoli di legge |
| tech            | How (sistemi, interfacce, blast radius), regole, criteri di accettazione, dipendenze di rilascio | narrativa (sta nel brief)     |
| legal_finance   | ipotesi, fonti, claim e loro difendibilità, termini di paragone dei numeri   | UI, stack                     |
| stakeholder/pm  | Why, decisione richiesta, rischi                                            | dettagli implementativi       |
| business        | scenario, valore, impatto su processi e persone                            | dettagli implementativi       |
-->
