---
name: inbox-triage
description: Svuota product/inbox/ classificando ogni elemento grezzo che il PM ci ha buttato dentro (email, thread, trascrizioni, allegati, immagini) — idea nuova, aggiornamento di un'idea/PRD esistente, bug, strategic exception, o materiale troppo ambiguo da richiedere un chiarimento al mittente. È il punto d'ingresso raccomandato per il materiale grezzo non ancora ordinato.
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

## Passi

1. **Elenca tutto ciò che c'è in `product/inbox/`.** Non assumere che sia
   un solo elemento: possono esserci più file/oggetti scollegati tra loro
   in un colpo solo (es. tre email diverse buttate lì nello stesso
   giorno). Trattali come elementi indipendenti fin dall'inizio.

2. **Per ciascun elemento, leggi il contenuto** (testo, trascrizione,
   metadati di eventuali immagini/allegati) prima di decidere qualunque
   cosa.

3. **Prima di classificare come "nuova idea", cerca se esiste già
   qualcosa di collegato**: leggi titoli/contesto di
   `product/ideas/*/idea.yaml` e frontmatter di `product/prds/*/prd.md`
   (Why/What, non serve leggere tutto il corpo per uno screening
   iniziale). Se il contenuto sembra riferirsi chiaramente a un'idea o
   PRD già esistente, tratta l'elemento come **aggiornamento**, non come
   nuova idea. Se il collegamento è plausibile ma non certo, chiedi
   conferma all'utente invece di decidere da solo — un falso collegamento
   è peggio di una domanda in più.

4. **Classifica** ogni elemento in uno di questi esiti:

   - **Nuova idea** — segui gli stessi passi della skill `idea-intake`
     per struttura della cartella, naming dello slug e classificazione
     idea/bug/strategic_exception. Il materiale grezzo si **sposta**
     (non copia) da `product/inbox/` a
     `product/ideas/{data}-{slug}/source/`.

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
     traccia), `classification: strategic_exception`, ma lascia
     `strategic_exception.approved_by`/`reason` da confermare
     esplicitamente — non presumere l'approvazione solo perché il
     mittente ha un ruolo senior.

   - **Troppo ambiguo per classificare** — **non forzare una
     classificazione indovinando**. Crea comunque
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

5. **Chiudi il run con un riepilogo**, non solo con le scritture fatte:
   quanti elementi processati, quanti nuove idee / aggiornamenti / bug /
   strategic exception / needs_clarification, e — se qualcosa non è
   stato processato per un problema tecnico (file illeggibile, formato
   non gestito) — dillo esplicitamente e lascialo in `product/inbox/`
   piuttosto che farlo sparire silenziosamente.

6. **Verifica che `product/inbox/` sia vuota** (a parte `.gitkeep` e gli
   eventuali elementi non processabili segnalati al passo 5) prima di
   considerare il run concluso.

## Cosa NON fare

- Non creare mai voci di `rice_history` da questa skill — è compito di
  `rice-update`, con la sua propria coda di approvazione.
- Non riscrivere PRD esistenti — è compito di `prd-draft`, su richiesta
  esplicita.
- Non inviare comunicazioni (email, Slack) senza conferma esplicita per
  ogni singolo invio.
- Non lasciare materiale "a metà": o finisce in una cartella tracciata
  (idea/PRD, anche come needs_clarification), o resta visibilmente in
  `product/inbox/` con una spiegazione del perché.
