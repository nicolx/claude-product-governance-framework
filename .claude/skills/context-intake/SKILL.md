---
name: context-intake
description: Trascrive materiale grezzo sul contesto aziendale (Confluence, PDF, slide, bilanci, docx, ecc.) droppato in context/ in file Markdown tracciati con citazione della fonte, poi elimina l'originale — mai una copia raw persistente. Richiamata anche da altre skill (prd-draft, inbox-triage) quando materiale già in lavorazione rivela contesto aziendale rilevante, sempre con conferma esplicita del PM prima di scrivere. Usala per popolare o far evolvere la comprensione del business che idea-intake e prd-draft usano insieme al codice.
---

# context-intake

`context/` (alla radice dell'istanza, non sotto `product/`) è dove vive
la comprensione del business/azienda — modello di business, finanza,
organizzazione, mercato — che `idea-intake` e `prd-draft` leggono insieme
al codice in `apps/`. Vedi playbook, sezione "Contesto aziendale
(`context/`)".

A differenza di `product/inbox/`, `context/` **non viene svuotata**: è un
insieme di documenti vivi che si aggiornano nel tempo, non un buffer da
smistare altrove.

## Prerequisiti

Richiede un'istanza inizializzata. Se `context/` non esiste ancora,
crealo tu stesso (non è un blocco duro come
`product/reference/product-lines.yaml` — `context/` si popola in modo
incrementale, non solo all'init).

## Principio guida: la fonte prevale sulla copia

**Nessuna copia del materiale grezzo persiste nel repository, né
tracciata né ignorata da git.** Un file gitignorato esisterebbe solo nel
clone di chi l'ha processato: un collega che clona l'istanza vedrebbe la
sintesi ma non potrebbe verificarla, e se aggiungesse il proprio
materiale grezzo il contesto divergerebbe silenziosamente tra le macchine
del team. La verificabilità deve venire dal citare la fonte di sistema
condivisa (link Confluence/Drive/URL, o quantomeno documento + chi l'ha
fornito + data), non da una copia nel repo.

Vale anche il principio guida già in uso in `idea-intake`/`inbox-triage`:
**meglio una conferma in più che un contesto scritto male.** Un dato
aziendale sbagliato in un file che tutte le altre skill consultano si
propaga silenziosamente in idee e PRD futuri — è più costoso di una
domanda in più.

## Due modalità di innesco

1. **Materiale grezzo droppato direttamente in `context/`** — qualsiasi
   file non-Markdown alla radice della cartella (PDF, docx, pptx, txt,
   immagini, export Confluence...). La skill scansiona, processa e
   ripulisce.
2. **Materiale che emerge durante un'altra skill** — `prd-draft` legge
   una fonte che rivela un dato di business, `inbox-triage` processa
   un'email che parla di una riorganizzazione aziendale. Quella skill
   **non scrive da sola in `context/`**: segnala il candidato e richiama
   questa skill.

## Passi

1. Se innescata dal caso 1: elenca ogni file non-Markdown alla radice di
   `context/` (ignora sottocartelle già organizzate). Trattali come
   elementi indipendenti, anche se droppati nello stesso momento.

   Se innescata dal caso 2: usa il materiale/estratto passato dalla skill
   chiamante.

2. **Leggi ogni elemento per intero** prima di sintetizzare. Per file
   grandi (PDF lunghi, bilanci con molte pagine), segui il vincolo del
   `CLAUDE.md` globale sulle letture mirate: usa il parametro `pages` per
   i PDF e procedi a blocchi invece di caricare tutto in un colpo solo se
   evitabile.

3. **Determina il file di destinazione** in `context/`: un file Markdown
   per macro-argomento (es. `context/modello-di-business.md`,
   `context/finanza.md`, `context/organizzazione.md`,
   `context/mercato-competitor.md`). Non c'è una tassonomia fissa imposta
   dal framework — usa giudizio, e se un elemento è a cavallo tra più
   argomenti o non è ovvio dove vada, chiedi al PM invece di indovinare.
   Se il file esiste già, integra/aggiorna la sezione pertinente invece
   di duplicare: i file di contesto sono documenti vivi, non un log di
   eventi.

4. **Ogni informazione aggiunta o modificata deve riportare la fonte
   esplicitamente**: link diretto (Confluence, Drive, intranet) se
   disponibile; se il materiale non ha un link persistente (es. un PDF
   allegato a un'email, uno slide deck ricevuto), riporta nome del
   documento, chi l'ha fornito, e la data — con una nota che l'originale
   non è conservato nel repository. Non lasciare mai un'informazione
   senza fonte tracciata.

5. **Mostra al PM un riepilogo di cosa stai per scrivere/modificare e
   chiedi conferma esplicita prima di scrivere** — vale sia per il caso 1
   sia per il caso 2. Dedurre contesto aziendale da un documento è
   un'interpretazione, non un fatto osservato: non rientra tra le poche
   scritture dirette che il framework ammette senza conferma (vedi
   `mandate-watch`/`rice-watch`/`nsm-watch`, limitate a fatti mai
   presunti). Non serve la coda `product/approvals/pending/` (non è una
   decisione di priorità), ma la conferma in conversazione sì, sempre.

6. **Dopo la conferma**, scrivi/aggiorna il file `context/*.md` e — se
   l'elemento era un file droppato in `context/` — rimuovilo. Non
   lasciarlo né lì né altrove nel repository, tracciato o meno (vedi
   principio guida sopra).

7. **Chiudi con un riepilogo**: quanti elementi processati, quali file di
   contesto creati/aggiornati, e se qualcosa non è stato processato
   (formato non leggibile, ambiguità irrisolta) — lascialo visibile in
   `context/` con una nota, non farlo sparire silenziosamente.

## Cosa NON fare

- Non scrivere mai in un file `context/*.md` senza conferma esplicita del
  PM, nemmeno per correzioni che sembrano ovvie.
- Non conservare mai il file grezzo processato, né tracciato né
  gitignorato, dopo che la trascrizione è stata confermata.
- Non inventare una fonte se non è nota — scrivi esplicitamente "fonte
  non specificata, verificare con [chi ha fornito il materiale]" invece
  di ometterla o indovinarla.
- Non forzare una tassonomia di file se il PM ha già un'organizzazione
  diversa in mente — chiedi come preferisce strutturarli la prima volta,
  poi resta coerente.
