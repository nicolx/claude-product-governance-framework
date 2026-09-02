---
name: nsm-watch
description: Osserva le North Star Metric (e altri KPI chiave) di ogni Product Line nel tempo e lancia un allarme quando degradano — segnale che dovrebbe riportare il focus della Product Discovery su iniziative mirate a quella metrica, anche rispetto a idee con RICE più alto in backlog. Usala periodicamente e sempre per prima all'apertura del Backlog Refinement.
---

# nsm-watch

Le NSM di una Product Line sono il segnale più strategico che il
framework osserva — più a monte delle KPI di singola iniziativa
(`measurement-watch`, che verifica se una scommessa specifica ha reso).
Questa skill risponde a una domanda diversa: **la Product Line nel suo
complesso sta andando bene?** Se una NSM chiave degrada, per playbook
("Salute delle NSM e Product Discovery") questo deve riportare il focus
della Product Discovery su iniziative orientate a quella metrica —
**anche rispetto a idee con RICE più alto già in backlog**. È normale che
con molte richieste (interne o di stakeholder) la priorità segua il
RICE; ma un deterioramento di una NSM è il segnale che deve far tornare
l'attenzione lì, non un'eccezione da gestire in silenzio.

## Quando usarla

- **Standalone**, in qualunque momento: "come stanno andando le nostre
  NSM?", "abbiamo una nuova lettura per la NSM X?".
- **Richiamata da `log-ceremony`**, e **per prima tra tutte le watch**
  in apertura del Backlog Refinement — è il segnale più strategico, va
  visto prima di misurare l'impatto delle singole iniziative
  (`measurement-watch`) o di controllare le scadenze e l'housekeeping
  operativo (`mandate-watch`, `deadline-watch`, `rice-watch`).

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** scrivere su
> `product/` (nemmeno lo scaffold di `nsm-tracking.yaml`, né
> `readings`/`trend_status`/`alert`), **non** invocare
> `governance-sync.sh push`, mostra come testo l'output completo che
> avresti prodotto, e chiudi con `🔍 DRY-RUN — nessun file scritto,
> nessun commit, nessun push.`

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)") — è il segnale più
   strategico del framework, non ha senso giudicarlo su un
   `nsm-tracking.yaml` locale vecchio.

1. **Se `product/reference/nsm-tracking.yaml` non esiste ancora**,
   scaffoldalo da `framework/schema/nsm-tracking.template.yaml`: una
   voce per ciascuna NSM dichiarata in `product/reference/product-lines.yaml`
   (`nsm: []` di ogni Product Line). Chiedi al PM `baseline`, `target`,
   `unit` per ciascuna — **non inventare valori né lasciarli a "0" per
   comodità**: se il PM non li ha a portata di mano ora, lascia `null`
   con nota e prosegui, non bloccare l'intero run per una NSM.

2. **Per ciascuna metrica**, se `last_checked` è passato (usa lo stesso
   criterio di buon senso di `rice-watch`: non serve una nuova lettura
   ogni singolo giorno, ma non deve restare ferma per mesi) chiedi al PM
   se ha un dato più recente. Se lo fornisce, appendi una voce a
   `readings` (`date`, `value`, `source`, `note`) e aggiorna
   `last_checked`. Se non lo ha, aggiorna comunque `last_checked` (fatto:
   "l'abbiamo rivista, anche senza nuovo dato") — non lasciarlo fermo
   silenziosamente.

3. **Calcola `trend_status`** confrontando le ultime letture (serve
   almeno 2, altrimenti resta `unknown` — non giudicare da un solo
   punto). Usa la convenzione del prefisso nel nome della NSM (`+` = ci
   aspettiamo che salga, `-` = ci aspettiamo che scenda) per giudicare se
   il movimento è `improving`, `stable`, o `degrading` — se il nome non
   ha un prefisso riconoscibile, **chiedi al PM la direzione attesa**
   invece di presumere "più alto è meglio".

4. **Se `trend_status: degrading` e `alert.status` non è già `active`**,
   scrivi `alert.status: active`, `triggered_at` (oggi) — è un fatto
   calcolato dal trend, scrittura diretta, non passa da
   `product/approvals/pending/`. Poi **segnala con la massima evidenza**
   al PM, non come una riga tra le altre:

   > "La NSM '{name}' di {product_line} sta peggiorando (da {valore
   > precedente} a {valore attuale}). Per playbook, questo dovrebbe
   > riportare il focus della Product Discovery su iniziative mirate a
   > questa metrica, anche rispetto a idee con RICE più alto in backlog.
   > Vuoi confermare questo riorientamento ora?"

   Se il PM conferma, scrivi `discovery_focus_confirmed: true` e
   `discovery_focus_note` con cosa si farà (es. "avviamo idea-intake su
   nuove iniziative per il funnel di conversion"). Se non conferma (es.
   un calo spiegabile e temporaneo, già capito), registra comunque
   `alert.status: active` con `discovery_focus_confirmed: false` e la
   sua spiegazione in `discovery_focus_note` — **non forzare la
   conferma**, ma non lasciare nemmeno l'alert senza traccia della
   discussione.

5. **Se una NSM con `alert.status: active` torna a `improving`/`stable`**,
   proponi di chiudere l'allarme. Solo su conferma esplicita del PM,
   scrivi `alert.status: resolved`, `resolved_at`, `resolved_note`
   (perché si chiude — tornata a posto, o spiegazione accettata). Mai
   chiuderlo di tua iniziativa.

6. **Quando il PM conferma un riorientamento della Discovery**, se
   emergono idee concrete durante la conversazione, **suggerisci**
   `idea-intake` per catturarle — non crearle tu stessa. Se l'idea che
   ne risulta è esplicitamente mirata a recuperare questa NSM, segnala
   di collegarla in `idea.yaml` → `links.nsm_targeted` (vedi
   `idea.template.yaml`), per poter poi verificare se il focus di
   Discovery ha davvero funzionato.

7. **Presenta il riepilogo con gli allarmi attivi per primi**, in cima a
   tutto — è il segnale più importante che questa skill produce, non va
   annegato tra le altre righe. Poi le NSM `improving`/`stable` solo se
   richiesto esplicitamente.

8. Se chiamata da `log-ceremony`, restituisci il riepilogo perché venga
   incluso nel log della cerimonia — non scrivere tu stessa in
   `decisions.yaml`, è compito di `log-ceremony`.

9. **Sincronizza il repo**: se hai scritto/aggiornato
   `product/reference/nsm-tracking.yaml`, esegui
   `bash .claude/hooks/governance-sync.sh push "nsm-watch: aggiornato nsm-tracking" product/reference/nsm-tracking.yaml`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)") — anche se
   richiamata da `log-ceremony`, e anche prima: è il segnale più
   strategico, i colleghi devono vederlo appena disponibile.

## Cosa NON fare

- Non decidere autonomamente che la Discovery va riorientata — segnali,
  il PM conferma. La differenza tra "segnalare con forza" e "decidere al
  posto del PM" è la stessa di tutto il resto del framework: proponi,
  non applicare.
- Non giudicare un trend da una sola lettura — resta `unknown` finché
  non ce ne sono almeno due.
- Non presumere la direzione attesa di una NSM senza un prefisso `+`/`-`
  riconoscibile — chiedi.
- Non inventare baseline/target per completare lo schema al primo run —
  lascia `null` con nota se il PM non li ha a disposizione subito.
- Non chiudere un allarme (`resolved`) senza una decisione esplicita del
  PM in questa conversazione.
