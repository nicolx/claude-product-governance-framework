---
name: context-watch
description: Controlla periodicamente le cartelle documentali collegate come sorgente di contesto (Drive/OneDrive/SharePoint/Confluence, dichiarate in .governance/config.yaml come connectors: con folders:) e porta in context/ i documenti nuovi o cambiati — applicando direttamente gli aggiornamenti di routine e mandando in coda di approvazione i cambiamenti materiali (che cambierebbero come si scrivono i PRD). In ogni caso produce un recap al PM. Usala periodicamente e come parte della sweep di apertura del Backlog Refinement.
---

# context-watch

Il pull da cartelle collegate (`context-intake`, "Caso 3") esiste già, ma
va lanciato a mano: un documento che cambia in Drive/OneDrive/SharePoint
non si accorge da solo. `context-watch` è la **watch** che rende quel
pull periodico — parallela a `rice-watch`/`nsm-watch` — così il PM non
deve ricordarsi di aggiornare il contesto.

Vedi playbook, sezione "Contesto aziendale (`context/`)", sottosezione
"Aggiornamento di routine vs. cambiamento materiale": è la fonte
normativa di come si classifica e instrada un cambiamento.

## Quando usarla

- **Standalone**, in qualunque momento: "controlla il contesto", "ci sono
  aggiornamenti nelle cartelle collegate?".
- **Durante il Backlog Refinement**: `backlog-refinement` la richiama come
  ultimo passo della sweep di apertura (cadenza settimanale garantita —
  vedi quella skill). Il recap confluisce nel riepilogo della cerimonia;
  `log-ceremony` lo registra in `decisions.yaml` — non scrivere tu in
  `decisions.yaml`.

## Prerequisiti

Richiede un'istanza inizializzata con **almeno una voce `connectors:` che
ha un campo `folders:` non vuoto** in `.governance/config.yaml`. Se non ce
n'è nessuna, **no-op silenzioso**: l'istanza non ha sorgenti di contesto
collegate, non c'è niente da controllare (non è un guasto).

## Il routing per materialità (fonte: playbook)

Per ogni documento nuovo o cambiato, la skill classifica il cambiamento:

- **Routine** — rinfresca dati o aggiunge dettaglio **senza cambiare le
  conclusioni** che `idea-intake`/`prd-draft` traggono dal contesto: il
  nuovo report trimestrale con le cifre aggiornate, un trimestre in più di
  dati di mercato, un contatto o un numero rivisto, una sezione ampliata.
  → **si applica direttamente** (via `context-intake` in modalità
  auto-apply), con commit tracciato, e finisce nel recap.
- **Materiale** — cambierebbe **come si scrive un PRD o come evolve il
  prodotto**: un pivot di modello di business, una NSM ridefinita, un
  vincolo regolatorio nuovo, un riposizionamento di mercato, una
  riorganizzazione che sposta l'ownership di prodotto, un cambio di
  strategia dichiarato. → **non si scrive `context/`**: va in
  `product/approvals/pending/` (`type: context_update`) e il PM approva
  esplicitamente prima che tocchi il contesto.
- **Nel dubbio → materiale.** Stesso principio garantista di
  `inbox-triage`: un contesto sbagliato si propaga in silenzio in ogni
  PRD futuro, un'approvazione in più costa poco.

In **entrambi** i casi il PM riceve un recap.

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui `pull`, probe dei connettori, elenco e lettura dei
> documenti e la **classificazione** normalmente (sono tutte letture) —
> ma **non** invocare `context-intake` in scrittura, **non** creare voci
> in `product/approvals/pending/`, **non** scrivere
> `context/.sources-seen.yaml`, **non** invocare `governance-sync.sh
> push`. Mostra come testo il recap completo che avresti prodotto
> (auto-applicabili + da mettere in coda) e chiudi con `🔍 DRY-RUN —
> nessun file scritto, nessun commit, nessun push.`

0. **Sincronizza** (uso standalone): `bash .claude/hooks/governance-sync.sh pull`
   — non ha senso confrontare le cartelle con un `context/.sources-seen.yaml`
   vecchio. (Se richiamata da `backlog-refinement`, il `pull` unico della
   sweep è già stato fatto: non rifarlo.)

1. **Per ogni voce `connectors:` con `folders:`**, verifica che il
   connettore risponda con il suo `probe` dichiarato (per un `mcp:<server>`:
   che i suoi tool siano disponibili). Applica la regola del playbook
   "Connettori esterni" **per-connettore**:
   - **raggiungibile** → procedi con le sue cartelle;
   - **dichiarato ma irraggiungibile** → segnala *quale* connettore non
     risponde, proponi il suo comando `reauth`, chiedi al PM se
     riautenticare e ritentare o proseguire senza. Se si prosegue: quel
     connettore resta **rimandato** nel recap (da rilanciare
     `context-watch` quando torna su), **gli altri connettori proseguono
     comunque** — un guasto su Drive non blocca SharePoint.

2. **Elenca i documenti** di ogni cartella (`folders[].link`) tramite i
   tool di lettura/elenco del connettore. **Sola lettura**: mai
   creare/modificare/spostare/condividere nella cartella sorgente.

3. **Carica `context/.sources-seen.yaml`** (se non esiste, tutti i
   documenti sono "nuovi"). Per ciascun documento elencato:
   - `file_id` assente dal file di stato → **nuovo**;
   - `revision` diversa da quella registrata → **cambiato**;
   - `revision` invariata → **salta** (già trascritto);
   - `pending_ref` valorizzato e la voce in `pending/` è ancora `pending`
     → **salta** (un cambiamento materiale è già in coda, non ri-accodarlo);
   - `revision` uguale a `rejected_revision` → **salta** (un `context_update`
     su *questa* revisione è già stato rifiutato dal PM; si riprende solo a
     una revisione successiva del documento).

4. **Per ogni documento nuovo o cambiato**: leggilo per intero **e**
   leggi il `context/*.md` che oggi ne contiene la sintesi (dalla voce in
   `.sources-seen.yaml`, o dal `topic` della cartella se è nuovo).
   **Classifica** il cambiamento come `routine` o `material` secondo la
   sezione "Il routing per materialità". Se un documento è al confine,
   trattalo come `material` e spiega perché nel recap.

5. **Aggiornamenti di routine** → invoca `context-intake` in **modalità
   auto-apply** passandogli il documento, il connettore/cartella di
   origine e il `context/*.md` di destinazione. `context-intake` trascrive
   senza chiedere conferma per-documento, aggiorna `context/*.md` e la
   voce in `.sources-seen.yaml` (`revision`, `transcribed_at`,
   `materiality: routine`). Tieni da parte una **sintesi in una riga** di
   cosa è cambiato, per il recap.

6. **Cambiamenti materiali** → **non** scrivere `context/`. Per ciascuno,
   crea `product/approvals/pending/{YYYY-MM-DD}-context-{slug}.yaml` da
   `framework/schema/approval.template.yaml`:
   - `type: context_update`, `proposed_by: context-watch`;
   - `target_file`: il `context/*.md` che verrebbe aggiornato;
   - `payload`: link del documento sorgente, sintesi del cambiamento, la
     trascrizione proposta (o il diff proposto sul file), e il **razionale
     di materialità** (perché cambierebbe come si scrivono i PRD).
   Poi scrivi in `.sources-seen.yaml` la voce del documento con
   `materiality: material` e `pending_ref` = l'id della voce in coda
   (così il passo 3 non la ri-accoda al run successivo). **Non** aggiornare
   `revision`/`transcribed_at` finché non è approvata — lo farà
   `pending-approval`.

7. **Aggiorna `last_watch`** in `context/.sources-seen.yaml`: `run_at`
   (oggi), e per ogni connettore lo stato (`reachable` / `unreachable`).
   Crea il file da `framework/schema/sources-seen.template.yaml` se non
   esiste.

8. **Recap al PM** — sempre, anche se non c'è nulla:
   - **Applicati** (routine): per documento — connettore/cartella,
     `context/*.md` toccato, la sintesi in una riga del cambiamento.
   - **In attesa di approvazione** (materiali): per documento — cosa
     cambierebbe, il razionale di materialità, il nome della voce in
     `product/approvals/pending/`. Ricorda al PM che finché non le approva
     (via `pending-approval` o al Backlog Refinement) quel contesto **non**
     è ancora in `context/`.
   - **Rimandati**: connettori irraggiungibili non controllati.
   - **Invariato**: quanti documenti saltati perché non cambiati (una
     riga, non l'elenco).

9. **Sincronizza il repo**: se hai scritto qualcosa (auto-apply di
   `context-intake`, voci in `pending/`, `last_watch`), esegui
   `bash .claude/hooks/governance-sync.sh push "context-watch: <n> aggiornamenti di routine, <m> in coda" context/ product/approvals/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Nota:
   l'auto-apply di `context-intake` potrebbe aver già fatto il suo commit;
   questo passo cattura il resto. Se richiamata da `backlog-refinement`,
   il commit di `context-watch` è **distinto** da quello della sweep
   (tocca `context/`, non le `idea.yaml`) — vedi quella skill.

10. Se chiamata da `backlog-refinement`, **restituisci il recap** perché
    venga incluso nel log della cerimonia — non scrivere tu in
    `decisions.yaml`, è compito di `log-ceremony`.

## Cosa NON fare

- **Mai auto-applicare un cambiamento materiale.** Se cambierebbe come si
  scrive un PRD o l'evoluzione del prodotto, va in `pending/` e lo approva
  il PM. Nel dubbio, materiale.
- **Mai scrivere nella cartella sorgente** — il connettore è in sola
  lettura (niente `create`/`update`/`trash`/`share`).
- **Mai far degradare in silenzio a "non configurato"** un connettore
  dichiarato ma irraggiungibile — segnalalo e lascialo `rimandato`.
- **Mai bloccare gli altri connettori** perché uno non risponde.
- Non decidere tu che un allarme di contesto è chiuso o irrilevante — la
  skill segnala e propone, il PM decide (stesso principio di `nsm-watch`).
- Non riassumere il playbook a memoria per la definizione di
  routine/materiale — rileggi la sezione "Contesto aziendale", evolve.
