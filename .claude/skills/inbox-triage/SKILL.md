---
name: inbox-triage
description: Svuota product/inbox/ classificando ogni elemento grezzo che il PM ci ha buttato dentro (email, thread, trascrizioni, allegati, immagini) — idea nuova, aggiornamento di un'idea/PRD esistente, bug, strategic exception, mandate/iniziativa mandataria, platform/debito tecnico, o materiale troppo ambiguo da richiedere un chiarimento al mittente. È il punto d'ingresso raccomandato per il materiale grezzo non ancora ordinato.
---

# inbox-triage

`product/inbox/` è il raccoglitore universale: il PM ci butta dentro
qualsiasi cosa arrivi a casaccio — una mail, un thread, un export Slack,
la trascrizione di un workshop, immagini, allegati — senza doverla
pre-classificare. Questa skill la analizza e la smista, poi **la
svuota**: alla fine di un run, `product/inbox/` deve contenere solo
`.gitkeep` (o cose che il run corrente non è riuscito a processare, mai
lasciate silenziosamente).

`product/inbox/` non è tracciata da git (vedi `.gitignore` — dimensioni
imprevedibili: email intere, registrazioni, allegati). Tutto quello che
deve sopravvivere passa da qui a una cartella tracciata come parte di
questo processo.

**Questa skill non è un passaggio obbligato.** È una comodità per il
materiale che arriva disordinato. Un PM può sempre, in alternativa:
creare/modificare file sotto `product/ideas/` o `product/prds/` a mano,
o chiedere direttamente a `idea-intake`/`prd-draft` di processare del
materiale senza mai passare da `product/inbox/`. Non presumere mai che
tutto debba transitare da qui.

## Principio guida: garantista, non produttivista

**Meglio una domanda in più che un'idea scritta male.** Questa skill non
è misurata su quante cartelle crea per run, ma su quanto è affidabile
quello che scrive. Un'idea o un aggiornamento pieno di dati inferiti o
indovinati è **peggio** di non averlo ancora creato: qualcuno ci lavorerà
sopra, prioritizzerà su basi sbagliate, e l'errore si scopre solo dopo
aver bruciato tempo reale. Se non basta rileggere il materiale una
seconda volta per essere ragionevolmente sicuri, non indovinare — chiedi.

Ci sono **due livelli di dubbio**, e vanno trattati diversamente:

1. **Dubbio che il PM davanti a te può risolvere subito, in conversazione**
   (es. "questa email sembra riferirsi alla Product Line A o B, quale
   delle due?", "questo materiale è un aggiornamento dell'idea
   `2026-01-08-xyz` o è scollegato?", "il proponente è lo stesso Filiberto
   di Operations o un omonimo?"). **Fai la domanda subito, nella
   conversazione corrente**, prima di scrivere qualunque file — non
   serve creare un record `needs_clarification` per questo, il PM ha
   l'informazione a portata di mano.

2. **Dubbio che solo chi ha mandato il materiale originale può risolvere**
   (dati mancanti che il PM stesso non conosce: un numero, un dettaglio
   del problema, chi sia davvero il beneficiario coinvolto). Questo è il
   caso che diventa `status: needs_clarification` (vedi passo 5 sotto) —
   con domande specifiche pronte per essere rispedite al mittente.

In entrambi i casi, la regola è la stessa: **non scrivere un campo con un
valore inventato o indovinato solo per completare lo schema.** Se un dato
non è nel materiale e nessuno dei due livelli sopra lo risolve subito,
lascialo esplicitamente vuoto/null con una nota, non riempirlo a caso.

Non vale solo per la classificazione: vale anche per numeri, nomi,
percentuali, product line, e per l'ipotesi che un elemento sia collegato
a un'idea/PRD già esistente (passo 4).

## Passi

1. **Elenca tutto ciò che c'è in `product/inbox/`.** Non assumere che sia
   un solo elemento: possono esserci più file/oggetti scollegati tra loro
   in un colpo solo (es. tre email diverse buttate lì nello stesso
   giorno). Trattali come elementi indipendenti fin dall'inizio.

2. **Per ciascun elemento, leggi il contenuto** (testo, trascrizione,
   metadati di eventuali immagini/allegati) prima di decidere qualunque
   cosa.

3. **Decomponi ogni elemento se mescola più richieste indipendenti.**
   Una singola mail o trascrizione può contenere più idee distinte,
   ciascuna con la propria priorità futura — ogni idea ha il proprio
   RICE, quindi non vanno bundlate solo perché arrivate insieme.
   **Criterio pratico** (stesso di `idea-intake`): se a due parti del
   contenuto assegneresti un RICE score indipendente e scollegato, sono
   due unità separate, non una. Da qui in poi, i passi 4-5 (verifica
   collegamenti + classificazione) vanno ripetuti **per ciascuna unità
   risultante**, indipendentemente — un singolo elemento può produrre in
   output una combinazione qualsiasi di nuova idea / aggiornamento /
   bug / needs_clarification, non solo "più idee nuove". Se il contenuto
   è coeso (un solo problema descritto da più angolazioni), resta
   un'unica unità.

   **Regola per il materiale grezzo condiviso**: quando un elemento si
   decompone in più unità, il materiale grezzo va copiato per intero
   (mai spezzettato in estratti parziali) in ciascuna delle destinazioni
   che le unità genereranno — chi apre una cartella deve poter leggere
   il contesto completo senza risalire alle altre. Aggiungi in cima a
   ogni copia una riga di nota che indichi le altre destinazioni
   generate dalla stessa fonte. L'elemento lascia `product/inbox/` solo
   dopo che tutte le unità generate sono state scritte nella loro
   destinazione finale — se un'unica email genera 3 record, esce
   dall'inbox solo quando tutti e 3 esistono, non dopo il primo.

4. **Per ciascuna unità, prima di classificarla come "nuova idea", cerca
   se esiste già qualcosa di collegato**: leggi titoli/contesto di
   `product/ideas/*/idea.yaml` e frontmatter di `product/prds/*/prd.md`
   (Why/What, non serve leggere tutto il corpo per uno screening
   iniziale). Se il contenuto sembra riferirsi chiaramente a un'idea o
   PRD già esistente, tratta l'unità come **aggiornamento**, non come
   nuova idea. Se il collegamento è plausibile ma non certo, è un dubbio
   di **livello 1** (vedi sopra): chiedi conferma al PM nella
   conversazione, subito, invece di decidere da solo — un falso
   collegamento è peggio di una domanda in più.

5. **Classifica** ogni unità in uno di questi esiti. Prima di scegliere
   idea/bug/strategic_exception/mandate/platform/aggiornamento (cioè prima di
   scartare `needs_clarification`), verifica di poter rispondere, **solo dal
   materiale a disposizione o da una domanda di livello 1 già fatta al
   PM**, a queste domande minime:
   - Chi è il proponente (o almeno un canale/fonte identificabile)?
   - Qual è il problema o la richiesta, in termini comprensibili?
   - Perché sembra rilevante, anche minimamente?

   Se anche una sola di queste tre resta senza risposta dopo aver provato
   il livello 1, non forzare la classificazione: vai su
   `needs_clarification` (livello 2, sotto).

   - **Nuova idea** — segui gli stessi passi della skill `idea-intake`
     per struttura della cartella, naming dello slug e classificazione
     idea/bug/strategic_exception/mandate/platform. Materiale grezzo:
     vedi la regola sul condiviso al passo 3 se questa unità è una tra
     più generate dallo stesso elemento.

   - **Aggiornamento di un'idea esistente** — sposta il materiale in
     `product/ideas/{slug-esistente}/source/` (nome file che non collida
     con quelli già presenti). Non modificare `rice_history` o `status`
     da solo: segnala all'utente cosa è arrivato e perché potrebbe
     essere rilevante (es. "questo materiale sembra invalidare la stima
     di Reach fatta il 12/01 — vuoi che lanci rice-update?"). Applica lo
     stesso principio del RICE: proponi, non decidere.

   - **Aggiornamento/integrazione di un PRD esistente** — sposta il
     materiale in `product/prds/{slug}/source/` (nome file che non
     collida con quelli già presenti). **Non riscrivere il PRD da solo**
     — l'authoring del PRD resta un atto deliberato (skill `prd-draft`).
     Segnala che è arrivato nuovo materiale rilevante e in cosa potrebbe
     impattare (Why/What/Metriche/Rischi).

   - **Bug** — stessa regola di `idea-intake`: **crea comunque la cartella
     idea** (`classification: bug`, `rice_history` che resta `[]` per
     sempre — un bug non passa mai dal RICE) per non perdere il materiale
     e avere un record archiviato. In più, prepara il testo del ticket
     per il tracker di esecuzione e chiedi conferma prima di aprirlo (se
     è disponibile un'integrazione) o consegna il testo pronto
     all'utente. Il materiale grezzo si sposta comunque in `source/` —
     mai lasciato solo nel testo del ticket.

   - **Strategic Exception** — crea comunque la cartella idea (per
     traccia), `classification: strategic_exception`, e aggiungi una voce
     a `strategic_exceptions` con `invoked_at_stage: intake` —
     `approved_by`/`reason` restano da confermare esplicitamente, non
     presumere l'approvazione solo perché il mittente ha un ruolo senior.
     (Questo è distinto dal caso in cui un'idea normale salta la coda più
     avanti, in Backlog Refinement — vedi skill `log-ceremony`.)

   - **Mandate (iniziativa mandataria)** — stessa regola di
     `idea-intake`: iniziativa imposta dall'alto, "critical" per
     leadership, o con scadenza esterna fissa (playbook, "Iniziative
     Mandatarie"). `classification: mandate` — salta solo il RICE, non
     l'analisi. `mandated_by`/`rationale` sempre chiesti esplicitamente,
     mai presunti (nessun vincolo di ruolo su chi può dichiararlo, quindi
     la disciplina nel chiedere conta di più). Se c'è una `due_date`,
     chiedi anche una prima stima di `lead_time_weeks` (da validare poi
     con un referente tecnico — se non disponibile, lascia `null` con
     nota, non bloccare). Mai compilare `analysis_start_by`/
     `escalation_status` — li calcola `mandate-watch`.

   - **Platform (debito tecnico/devops puro)** — stessa regola di
     `idea-intake`: non è un bug né un'idea di business, è manutenzione o
     debito tecnico che il team tech giudica necessario. `classification:
     platform` — salta solo il RICE, non necessariamente l'analisi (le
     iniziative importanti sì, quelle piccole possono saltare
     direttamente a `in_jira`). `rationale` sempre chiesto
     esplicitamente, mai presunto solo perché arriva dal team tech.

   - **Troppo ambiguo per classificare (dubbio di livello 2)** — **non
     forzare una classificazione indovinando**. Crea comunque
     `product/ideas/{data}-{slug-provvisorio}/` con:
     - `status: needs_clarification`
     - `classification` lasciata come miglior tentativo provvisorio (può
       restare vuota se non hai nemmeno un'ipotesi)
     - `clarification.needed: true`, `clarification.questions` con le
       domande specifiche che servono per sbloccare la classificazione
       (non domande generiche tipo "puoi spiegare meglio?" — punta al
       dato mancante preciso: chi è il beneficiario, che numero c'è
       dietro, quale prodotto è coinvolto, ecc.)
     - `clarification.draft_message`: una bozza di messaggio pronta,
       nel tono giusto per essere rispedita a chi ha mandato il
       materiale originale, che ponga quelle domande
     Il materiale grezzo si sposta comunque in `source/` — non resta in
     `product/inbox/`, e non va perso.
     **Non inviare mai il messaggio di chiarimento in automatico.**
     Mostralo all'utente e chiedi se vuole inviarlo lui, o se c'è
     un'integrazione disponibile (es. email) chiedi esplicitamente
     conferma prima di usarla.

6. **Se un elemento rivela contesto aziendale rilevante (non di
   prodotto)** — un dato finanziario, una riorganizzazione, un cambio di
   strategia dichiarato — **non scriverlo tu in `context/`**: segnalalo
   nel riepilogo finale e proponi di richiamare `context-intake` su
   quell'elemento. Vale indipendentemente dalla classificazione scelta
   sopra (può capitare anche per un elemento che diventa una nuova idea).

7. **Chiudi il run con un riepilogo**, non solo con le scritture fatte:
   quanti elementi processati, in quante unità si sono decomposti, quante
   nuove idee / aggiornamenti / bug / strategic exception / mandate /
   platform / needs_clarification ne sono derivate — **raggruppa nel riepilogo le
   unità nate dallo stesso elemento**, non elencarle come se fossero
   scollegate — e se qualcosa non è stato processato per un problema
   tecnico (file illeggibile, formato non gestito) dillo esplicitamente e
   lascialo in `product/inbox/` piuttosto che farlo sparire
   silenziosamente.

8. **Verifica che `product/inbox/` sia vuota** (a parte `.gitkeep` e gli
   eventuali elementi non processabili segnalati al passo 7) prima di
   considerare il run concluso.

## Cosa NON fare

- Non inventare o indovinare un valore per completare uno schema — nel
  dubbio, chiedi (livello 1 o 2, vedi sopra) o lascia il campo vuoto con
  una nota. Meglio un record incompleto e onesto che uno completo e
  sbagliato.
- Non creare mai voci di `rice_history` da questa skill — è compito di
  `rice-update`, con la sua propria coda di approvazione.
- Non riscrivere PRD esistenti — è compito di `prd-draft`, su richiesta
  esplicita.
- Non inviare comunicazioni (email, Slack) senza conferma esplicita per
  ogni singolo invio.
- Non lasciare materiale "a metà": o finisce in una cartella tracciata
  (idea/PRD, anche come needs_clarification), o resta visibilmente in
  `product/inbox/` con una spiegazione del perché.
