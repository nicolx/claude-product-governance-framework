---
name: context-intake
description: Trascrive materiale grezzo sul contesto aziendale (Confluence, PDF, slide, bilanci, docx, ecc.) in file Markdown tracciati con citazione della fonte — da file droppati in context/ (poi eliminati, mai una copia raw persistente) o pescandolo da cartelle documentali condivise (Drive/SharePoint/Confluence) collegate come connettore in .governance/config.yaml. Richiamata anche da altre skill (prd-draft, inbox-triage) quando materiale già in lavorazione rivela contesto aziendale rilevante, sempre con conferma esplicita del PM prima di scrivere. Usala per popolare o far evolvere la comprensione del business che idea-intake e prd-draft usano insieme al codice.
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

## Tre modalità di innesco

1. **Materiale grezzo droppato direttamente in `context/`** — qualsiasi
   file non-Markdown alla radice della cartella (PDF, docx, pptx, txt,
   immagini, export Confluence...). La skill scansiona, processa e
   ripulisce.
2. **Materiale che emerge durante un'altra skill** — `prd-draft` legge
   una fonte che rivela un dato di business, `inbox-triage` processa
   un'email che parla di una riorganizzazione aziendale. Quella skill
   **non scrive da sola in `context/`**: segnala il candidato e richiama
   questa skill.
3. **Pull da una cartella documentale collegata** — `.governance/config.yaml`
   dichiara nella lista `connectors:` una o più voci con un campo
   `folders:` non vuoto (cartelle Drive/SharePoint/spazio Confluence). La
   skill le elenca **in sola lettura** tramite il connettore, trova i
   documenti nuovi o modificati dall'ultima volta e li trascrive. Vedi
   "Caso 3" sotto. Si attiva quando l'utente lo chiede esplicitamente
   ("aggiorna il contesto dalle cartelle collegate", "pesca da Drive") o
   quando la skill è invocata senza file droppati e almeno un connettore
   sorgente di contesto è dichiarato.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente — incluso il probe del
> connettore e l'elenco/lettura dei documenti di una cartella collegata
> (caso 3), che sono sola lettura — ma **non** scrivere su
> `product/`/`context/`/`.governance/` (nemmeno `context/.sources-seen.yaml`,
> nemmeno spostando file), **non** invocare `governance-sync.sh push`,
> mostra come testo l'output completo che avresti prodotto, e chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`

1. Se innescata dal caso 1: elenca ogni file non-Markdown alla radice di
   `context/` (ignora sottocartelle già organizzate). Trattali come
   elementi indipendenti, anche se droppati nello stesso momento.

   Se innescata dal caso 2: usa il materiale/estratto passato dalla skill
   chiamante.

   Se innescata dal caso 3: applica prima la sezione "Caso 3" qui
   sotto per ottenere la lista dei documenti da trascrivere, poi procedi
   dal passo 2 con ciascuno.

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
   chiedi conferma esplicita prima di scrivere** — vale per tutti e tre i
   casi d'innesco. Dedurre contesto aziendale da un documento è
   un'interpretazione, non un fatto osservato: non rientra tra le poche
   scritture dirette che il framework ammette senza conferma (vedi
   `mandate-watch`/`rice-watch`/`nsm-watch`/`deadline-watch`, limitate a fatti mai
   presunti). Non serve la coda `product/approvals/pending/` (non è una
   decisione di priorità), ma la conferma in conversazione sì, sempre.

6. **Dopo la conferma**, scrivi/aggiorna il file `context/*.md`. Poi:
   - se l'elemento era un **file droppato** in `context/` (caso 1),
     rimuovilo — non lasciarlo né lì né altrove nel repository, tracciato
     o meno (vedi principio guida sopra);
   - se veniva da una **cartella collegata** (caso 3), **non toccare la
     cartella sorgente** (il connettore è in sola lettura) e aggiorna
     `context/.sources-seen.yaml` con la voce del documento
     (`file_id`, `revision`, `transcribed_at`, `context_file`) — crea il
     file da `framework/schema/sources-seen.template.yaml` se non esiste.

7. **Chiudi con un riepilogo**: quanti elementi processati, quali file di
   contesto creati/aggiornati, e se qualcosa non è stato processato
   (formato non leggibile, ambiguità irrisolta) — lascialo visibile in
   `context/` con una nota, non farlo sparire silenziosamente.

8. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "context-intake: <file aggiornati>" context/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Il commit
   cattura solo lo stato tracciato: le trascrizioni `context/*.md`, e —
   per il caso 3 — `context/.sources-seen.yaml`. Il file grezzo del
   caso 1 è già stato rimosso al passo 6. Se l'helper segnala un push
   fallito, riferiscilo nel riepilogo.

## Caso 3 — pull da un connettore sorgente di contesto

Si applica quando `.governance/config.yaml` ha almeno una voce
`connectors:` con un campo `folders:` non vuoto. Ogni voce di `folders:`
ha `link` (URL della cartella), `label` e `topic` (argomento `context/`
suggerito).

1. **Probe del connettore** — prima di leggere qualunque cosa, verifica
   che il connettore risponda, usando il `probe` dichiarato in config
   (per un `mcp:<server>`: che i suoi tool siano disponibili). Applica la
   regola del playbook "Connettori esterni": **dichiarato ma
   irraggiungibile ≠ `manuale`**. Se non risponde, segnala cosa non va,
   proponi il comando `reauth` dichiarato, e chiedi al PM se riautenticare
   e ritentare o procedere senza. Se si procede senza, il pull resta
   **rimandato** e visibile nel riepilogo (da rilanciare quando il
   connettore torna su) — mai saltato in silenzio.

2. **Elenca i documenti** di ogni cartella in `folders:` tramite i tool
   di lettura/elenco del connettore. **Sola lettura**: non creare, non
   modificare, non spostare, non condividere nulla nella cartella
   sorgente.

3. **Carica `context/.sources-seen.yaml`** (se non esiste, nessun
   documento è ancora stato trascritto). Per ogni documento elencato,
   confrontane `file_id` e `revision` con la voce registrata:
   - `file_id` assente dal file di stato → **documento nuovo**;
   - `revision` diversa da quella registrata → **documento modificato**;
   - `revision` invariata → **salta** (già trascritto).

4. **Presenta al PM** l'elenco di nuovi + modificati (con `label` della
   cartella, nome del documento, e il `topic` suggerito come
   destinazione), e quanti sono stati saltati perché invariati. Da qui
   procedi dal passo 2 della sezione "Passi" per ciascun documento: leggi
   per intero, determina il `context/*.md` di destinazione (parti dal
   `topic` della cartella, ma usa giudizio e chiedi se non torna),
   **cita come fonte il `link` del documento**, mostra il riepilogo,
   chiedi conferma, scrivi, e aggiorna `context/.sources-seen.yaml`
   (passo 6).

5. Se una cartella è vuota o tutti i suoi documenti sono invariati,
   dillo nel riepilogo — non è un errore.

## Cosa NON fare

- Non scrivere mai in un file `context/*.md` senza conferma esplicita del
  PM, nemmeno per correzioni che sembrano ovvie.
- Non conservare mai il file grezzo processato, né tracciato né
  gitignorato, dopo che la trascrizione è stata confermata.
- **Caso 3: non scrivere mai nella cartella sorgente** (Drive,
  SharePoint, spazio Confluence). Il connettore è usato in sola lettura —
  niente `create`/`update`/`trash`/`share`.
- **Caso 3: non "ripulire" un documento dalla cartella sorgente dopo
  averlo trascritto.** Lì la copia *è* la fonte citata, non una
  duplicazione grezza da rimuovere come per il caso 1.
- Non degradare in silenzio a "inserimento manuale" se il connettore non
  risponde — segnala e chiedi (vedi Caso 3, passo 1).
- Non inventare una fonte se non è nota — scrivi esplicitamente "fonte
  non specificata, verificare con [chi ha fornito il materiale]" invece
  di ometterla o indovinarla.
- Non forzare una tassonomia di file se il PM ha già un'organizzazione
  diversa in mente — chiedi come preferisce strutturarli la prima volta,
  poi resta coerente.
