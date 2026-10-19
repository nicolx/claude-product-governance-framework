---
name: stakeholder-profile
description: Crea e fa evolvere l'identikit degli stakeholder dell'istanza — ruolo, peso, cosa gli importa, come vuole ricevere le informazioni, punti di forza e punti di attenzione come comportamenti osservati, cosa funziona e cosa no — nella memoria condivisa dei PM (product/reference/stakeholders.yaml, tracciata), e il rapporto individuale tra il PM di questo clone e ciascuno di loro (familiarità, fiducia, tensioni, note franche) in un file locale mai tracciato. Da questi due livelli le skill che preparano bozze per il PM calibrano tono e forma sul destinatario, in modo diverso per chi è appena arrivato e per chi ci lavora da anni. Usala per profilare uno stakeholder, registrare com'è andata un'interazione, dichiarare il proprio rapporto con qualcuno, o chiedere "come mi conviene scrivere a X?".
---

# stakeholder-profile

Mantiene i due livelli descritti nel playbook, sezione **"L'identikit
degli stakeholder e il rapporto individuale"** — leggila prima di
scrivere, è la fonte normativa (test del lettore, matrice di
calibrazione, privacy):

| Livello | File | Tracciato | Chi lo vede |
|---|---|---|---|
| Identikit condiviso — com'è lo stakeholder | `product/reference/stakeholders.yaml` | sì | tutti i PM dell'istanza (e chiunque abbia accesso al repo) |
| Rapporto individuale — com'è il rapporto tra lui e questo PM | `.governance/stakeholder-relationships.local.yaml` | **no** (`.governance/*.local.yaml`) | solo il PM di questo clone |

Entrambi sono scrittura diretta, **non** passano da
`product/approvals/pending/` (non sono decisioni di priorità né
comunicazioni in uscita). Ogni scrittura è su **conferma del PM in
conversazione**: la skill propone, non deduce in silenzio.

## Prerequisiti

Se `.governance/config.yaml` non esiste, l'istanza non è inizializzata —
segnalalo e fermati.

## Passi

> **Dry-run.** Se la skill è invocata in simulazione (argomento
> `dry-run`, o `dry_run: true` in `.governance/config.yaml`), applica il
> contratto della sezione "Modalità dry-run (simulazione)" del playbook:
> mostra come testo le voci che avresti scritto, **non** scrivere né
> `stakeholders.yaml` né il file locale, **non** invocare
> `governance-sync.sh push`, e chiudi con `🔍 DRY-RUN — nessun file
> scritto, nessun commit, nessun push.`

1. **Sincronizza e leggi lo stato.** `bash
   .claude/hooks/governance-sync.sh pull`. Poi:
   - `.governance/config.yaml` — `pm_roster`;
   - `product/reference/stakeholders.yaml` — se non esiste, crealo in
     memoria da `framework/schema/stakeholders.template.yaml` (scaffold
     lazy);
   - `.governance/stakeholder-relationships.local.yaml` — se non esiste,
     crealo in memoria da
     `framework/schema/stakeholder-relationships.local.template.yaml`.
     Se `pm` è vuoto, chiedi al PM chi è (tra i nomi di `pm_roster`).
     Prima di scriverlo la prima volta, verifica con `git check-ignore -q
     .governance/stakeholder-relationships.local.yaml` che sia escluso:
     se **non** lo è (`.gitignore` vecchio), fermati sul livello 2 e
     spiega che va prima integrato l'aggiornamento del framework
     (`sync-framework-updates`) — mai scrivere note franche in un file
     che finirebbe in un commit;
   - per avere gli stakeholder candidati: `product-lines.yaml`
     (`stakeholders`), i `proposer` delle idee e il registro delle
     frizioni (`bash .claude/hooks/governance-dump.sh reference` e, se
     serve, `ideas`).

2. **Capisci l'intento.** Uno tra:
   - **profila** uno stakeholder nuovo (o completa uno esistente);
   - **registra un episodio** — com'è andata un'interazione, una
     riunione, una mail ("ha risposto male", "ha apprezzato le due
     opzioni");
   - **dichiara il rapporto** — "lo conosco da anni", "sono appena
     arrivato", "ci siamo scontrati";
   - **consulta** — "come mi conviene scrivere a X?", "cosa sappiamo di
     Y prima della riunione di domani?": sola lettura, vai al passo 6;
   - **rileggi** — identikit con `last_reviewed_at` vecchio (oltre sei
     mesi) o richiesta di revisione: ripassa la voce per intero col PM;
   - **semina** — primo giro sull'istanza: proponi l'elenco degli
     stakeholder ricorrenti senza identikit (proposer frequenti,
     stakeholders delle linee, `who` del registro delle frizioni) e
     chiedi da chi partire. Non profilare nessuno in blocco.

3. **Identikit condiviso — raccogli senza presumere.** Per uno
   stakeholder, i campi del template: `id` (slug stabile), `name`,
   `aliases` (come compare nel materiale grezzo), `role`,
   `product_lines` (validale contro `product-lines.yaml`), `influence`/
   `interest`, `cares_about`, `communication` (canale, formato,
   lunghezza, registro di default, cattive notizie, tempi), `traits`,
   `what_works`, `what_to_avoid`. Chiedi solo ciò che il PM sa; un campo
   ignoto resta `""`, mai riempito "a buon senso".

   **Il test del lettore, su ogni riga, prima di mostrarla.** Se il PM
   detta un giudizio sulla persona ("è un despota", "ha un pessimo
   carattere"):
   - riformulalo in **comportamento osservato + come gestirlo** e chiedi
     l'episodio che lo sostiene ("Quando ti ha dato questa impressione?
     Cosa è successo?") — "alza i toni quando una scadenza slitta e lo
     scopre da altri → avvisarlo per primo, a voce (call del 3/6)";
   - senza episodio, il tratto entra come `confidence: hypothesis`;
   - offri di tenere la versione franca nel **rapporto locale**
     (`personal_notes`), che resta suo.

   Mai, nemmeno se il PM lo chiede: salute, vita privata, opinioni
   politiche/religiose/sindacali, orientamento, o altro che non serve a
   comunicare meglio sul lavoro — né nell'identikit né nel file locale.
   Spiega perché in una riga e prosegui.

   **Episodi.** Ogni episodio è append-only, con `recorded_by` (il PM),
   data, contesto, cosa è successo descritto senza aggettivi sulla
   persona, e la lezione. Se l'episodio è anche una frizione (bypass del
   processo, Strategic Exception ricorrente, pressione dal top), proponi
   di aggiungere la riga in `product/reference/friction-log.yaml` e
   collega le due (`friction_log_ref`). Dopo un episodio, chiedi se
   cambia un tratto (nuovo, confermato da `hypothesis` a `observed`, o
   smentito — un tratto smentito si toglie, non si lascia accanto al suo
   contrario).

   Un tratto o un episodio scritto da un altro PM non si cancella né si
   riscrive senza dirlo: se il PM attuale non è d'accordo, aggiungi il
   suo episodio e proponi di rivedere il tratto, citando chi l'aveva
   scritto.

4. **Rapporto individuale — su dichiarazione del PM.** `familiarity`,
   `trust`, `tension`, `register`, `allies`, `approach`,
   `personal_notes`, e un momento in `history` per ogni interazione che
   il PM racconta (con `effect`). Qui il PM può essere franco. Non
   dedurre `trust` o `tension` da un singolo episodio: chiedi. Senza voce
   il rapporto vale `new` — se il PM dice "lo conosco da anni", scrivilo
   esplicitamente.

5. **Scrivi.**
   - `product/reference/stakeholders.yaml` — aggiorna `updated_at` e,
     se il PM ha riletto la voce per intero, `last_reviewed_at`. Ordina
     `stakeholders` per `id` (stabilità dei diff). Poi `bash
     .claude/hooks/governance-sync.sh push "stakeholder-profile: <id> —
     <cosa è cambiato>" product/reference/`. Il messaggio di commit dice
     cosa è cambiato in termini neutri ("aggiunto episodio", "nuovo
     identikit"), mai il contenuto di un tratto.
   - `.governance/stakeholder-relationships.local.yaml` — scrittura
     locale, **nessun** commit, nessun push (è fuori da git). Ricorda al
     PM, la prima volta, che il file non ha backup: se cambia macchina lo
     copia a mano.

6. **Riepiloga / consulta.** Per uno stakeholder, una scheda breve per
   il PM che combina i due livelli, come la usano le skill che scrivono
   bozze (playbook, matrice "identikit × rapporto"):
   - chi è e cosa gli importa (2-3 righe);
   - come scrivergli **per te**, adesso: registro, formato, lunghezza,
     cosa mettere in testa, canale ("prima una call, poi la mail");
   - punti di attenzione e cosa evitare, con l'episodio di riferimento;
   - se il tuo rapporto è `new` o `tension: ongoing`: cosa cambia
     rispetto a chi ci lavora da tempo, e chi può fare da ponte;
   - se l'identikit è vecchio o ha solo ipotesi, dillo.
   Il contenuto del rapporto locale si mostra solo in conversazione al
   PM che lo possiede, mai in un file tracciato.

## Usata dalle altre skill

Le skill che preparano un testo che il PM manda a mano (`idea-intake`,
`inbox-triage`, `delivery-watch`, `jira-sync`, `measurement-watch`,
`backlog-refinement`, `report-render`, `pending-approval` per gli
`outbound_comm`) leggono **in sola lettura** i due file e calibrano la
bozza come da playbook, mostrando la riga `Calibrazione: …` fuori dal
testo. Quando il PM dà una versione finale diversa dalla bozza o
racconta la reazione dello stakeholder, propongono in una riga di
registrarlo; se il PM accetta, applicano i passi 3–5 di questa skill per
quella sola voce (stesse regole: test del lettore, conferma, episodio).

## Cosa NON fare

- Non scrivere giudizi sul carattere nell'identikit condiviso: solo
  comportamenti osservati con episodio, o ipotesi dichiarate.
- Non copiare mai nulla del rapporto locale in un file tracciato, in un
  messaggio di commit, in una bozza o in un recap di cerimonia.
- Non scrivere il rapporto locale se `git check-ignore` dice che non è
  escluso.
- Non dedurre familiarità, fiducia o tensioni: le dichiara il PM.
- Non profilare persone che non sono stakeholder del prodotto (es. il
  team di sviluppo: per quello c'è `team.yaml`, descrittivo e non
  valutativo).
- Non usare l'identikit per cambiare la sostanza di una comunicazione:
  calibra come si dice, mai cosa si dice.
- Non trattare `stakeholders.yaml` come soggetto ad approvazione:
  reference data, scrittura diretta.
