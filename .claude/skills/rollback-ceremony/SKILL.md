---
name: rollback-ceremony
description: Annulla un run di cerimonia (Backlog Refinement, Iteration Planning, ad-hoc) lanciato per errore senza dry-run o interrotto a metà — riporta il repo allo stato precedente al run leggendo base_sha da .run-meta.yaml. Usa git revert forward sui commit già pushati (mai reset/force-push su storia condivisa), reset solo se il run è ancora tutto locale. Non tocca mai una decisione già approvata in product/approvals/decided/. Usala quando "annulliamo e riproviamo".
---

# rollback-ceremony

Il dry-run (playbook, "Modalità dry-run") è la prevenzione; questa skill
è la cura, per quando è troppo tardi: hai lanciato `backlog-refinement` /
`iteration-planning` / `log-ceremony` **senza** `dry-run`, o la cerimonia
si è interrotta a metà e i file sono in uno stato incoerente. Riporta il
repo allo stato immediatamente precedente al run, così puoi rifarlo
pulito (idealmente in dry-run).

## Principio non negoziabile: si annulla in avanti, non riscrivendo

Un'istanza è un repo **condiviso** e il meccanismo di sync è
fast-forward-only (playbook, "Sincronizzazione dell'istanza"). Quindi:

- Commit del run **già pushati su `origin`** → si annullano con
  **`git revert`** (un nuovo commit che li disfa). Mai `git reset` +
  force-push: romperebbe il clone di chi ha già fatto pull, ed è
  esattamente ciò che il framework vieta ovunque. "Abbiamo sbagliato e
  annullato il {data}" è esso stesso parte del registro difendibile,
  coerente con l'append-only di `rice_history`/`strategic_exceptions`.
- Commit del run **ancora solo locali** (mai pushati) → `git reset` è
  lecito, previa conferma esplicita.
- Modifiche non committate / file non tracciati → `git restore` / `rm`
  mirati, con conferma.

## Fuori scope: decisioni già approvate

Se una proposta creata dal run è **già stata approvata**
(`pending-approval` l'ha spostata in `product/approvals/decided/` con
`decision: approved` e ha applicato il `payload` al `target_file`),
**quella decisione non si annulla qui**: è una decisione umana tracciata.
La skill la rileva, la esclude dal rollback e la segnala — se va davvero
disfatta, è un'operazione separata e deliberata (nuova proposta inversa,
o intervento git esplicito dell'utente).

## Passi

> **Dry-run.** Se invocata con `dry-run`, esegui i passi 0-4 (analisi e
> piano) e **fermati lì**: mostra il piano di rollback senza eseguire
> revert/reset/rm né alcun commit. Chiudi con `🔍 DRY-RUN — piano di
> rollback mostrato, nulla eseguito.`

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)"). Serve sapere se un
   collega ha pushato dopo il run che stai per annullare — cambia il
   piano. Se l'helper segnala un disallineamento non-fast-forward,
   fermati e riferiscilo all'utente: va risolto prima.

1. **Identifica il run da annullare.**
   - Se l'utente nomina la cerimonia (tipo + periodo), leggi
     `product/ceremonies/{tipo}/{periodo}/.run-meta.yaml`.
   - Altrimenti elenca i `.run-meta.yaml` più recenti (prima quelli con
     `status: running` — run interrotti — poi i `completed` recenti) e
     chiedi quale.
   - Da `.run-meta.yaml` prendi `base_sha`, `ceremony_type`, `period`,
     `status`.
   - **Se `.run-meta.yaml` non esiste** (run precedente alla sua
     introduzione, o cancellato): chiedi all'utente lo SHA dell'ultimo
     commit "buono" prima del run, oppure ricostruiscilo da
     `git log --oneline -- product/ceremonies/{tipo}/{periodo}/` e
     fallo confermare. Non procedere senza un `base_sha` confermato.

2. **Verifica che `base_sha` sia un antenato di `HEAD`.**
   `git merge-base --is-ancestor <base_sha> HEAD`. Se non lo è, la storia
   è già stata riscritta (rebase, un altro rollback): fermati e riferisci
   all'utente, non tentare di indovinare.

3. **Classifica i commit del run.** `git rev-list --reverse base_sha..HEAD`.
   Per ciascun commit determina:
   - **appartiene al run?** — tocca `product/ceremonies/{tipo}/{periodo}/`,
     o i `product/approvals/pending/` creati dal run, o gli `idea.yaml`/
     `nsm-tracking.yaml` scritti dalle watch/`iteration-planning` durante
     il run. I commit che **non** appartengono al run (push di un
     collega, un `rice-update` scollegato, un'altra cerimonia) vanno
     mostrati ma **mai** revertati d'ufficio: elencali e chiedi conferma
     esplicita dell'insieme da annullare. In caso di dubbio, chiedi.
   - **è già pushato?** — confronta con `git rev-list base_sha..@{u}`
     (se il branch ha upstream). Determina l'insieme "pushati" e
     "solo locali".
   - **ha creato una proposta poi approvata?** — per ogni file aggiunto
     in `product/approvals/pending/` (`rice_diff`,
     `strategic_exception_flag`, `iteration_plan`, `roadmap_snapshot`,
     …), controlla se esiste ora un omologo in
     `product/approvals/decided/` con `decision: approved`. Se sì: quel
     commit (e la catena fino all'approvazione e ai file aggiornati) è
     **fuori scope** — vedi sezione sopra. Per un `iteration_plan`
     approvato, "i file aggiornati" includono
     `product/roadmap/iterations/{settimana}.yaml` **e** i puntatori
     `iteration.current`/`iteration.bucket` scritti sulle `idea.yaml`:
     tutta questa catena resta fuori scope, non solo il file di
     iterazione.
     Una proposta `iteration_plan` **ancora in `pending/`** (non
     approvata — il caso normale subito dopo la cerimonia) fa invece
     parte dei commit del run e viene revertata come gli altri.

4. **Componi e mostra il piano di rollback**, esplicito, prima di
   toccare qualunque cosa:
   - i commit che verranno **revertati** (già pushati), in ordine
     inverso;
   - i commit che verranno rimossi con **reset** (solo locali) — offerto
     **solo** se *tutti* i commit del run sono locali e nessuno è escluso
     per approvazione; altrimenti si reverta anche quelli, per coerenza;
   - le modifiche non committate / file non tracciati che verranno
     ripristinati o rimossi, elencati uno per uno;
   - cosa resta **escluso** (decisioni approvate, commit non del run) e
     perché;
   - che fine fa la **trascrizione grezza** in `source/`: il
     revert/reset la rimuove. Chiedi se copiarla prima in
     `product/ceremonies/{tipo}/{periodo}-void-{n}/` (con un
     `.run-meta.yaml` minimale `status: rolled_back`) — è costosa da
     ricreare. Default: **sì, conservala**.

   **Fermati e chiedi conferma esplicita.** Non procedere su un "ok"
   implicito o perché l'utente sembrava d'accordo prima.

5. **Esegui** (solo dopo conferma):
   - Se conservi la trascrizione: copia `source/` (e nient'altro) nella
     cartella `-void-{n}` **prima** del revert/reset, come dir non
     tracciata.
   - **Revert**: `git revert --no-commit <sha>` per ogni commit
     dell'insieme, dal più recente al più vecchio, poi un unico commit
     `rollback-ceremony: annullato run <ceremony_type> <period> (base <base_sha corto>)`.
     Se un revert dà **conflitto**, `git revert --abort`, fermati e
     riferisci all'utente esattamente su quale commit e quali file —
     **non risolvere il conflitto da solo** (stesso principio di
     `governance-sync.sh` che non fa mai merge automatici).
   - **Reset** (caso tutto-locale): `git reset --hard <base_sha>` dopo
     aver mostrato che `git status` è pulito da altro lavoro.
   - Se hai conservato la trascrizione: `git add` della cartella
     `-void-{n}` e includila nel commit di rollback (o un commit
     dedicato dopo il reset).

6. **Aggiorna la traccia.** Nel `-void-{n}/.run-meta.yaml` (se creato)
   scrivi `status: rolled_back`, `rolled_back_at`, `rollback_ref` (SHA
   del commit di revert, o "reset a {base_sha}" se era tutto locale).
   Se non hai conservato la cartella, il commit di rollback è l'unica
   traccia — va bene, il suo messaggio dice tutto.

7. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "rollback-ceremony: <ceremony_type> <period>" product/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se dopo
   un reset locale il push non è fast-forward, **non forzare**: segui
   l'istruzione dell'helper (`git pull --rebase && git push`) — se
   `origin` è andato avanti significa che quei commit *erano* pushati e
   il reset era la scelta sbagliata: fermati e passa al revert.

8. **Chiudi indicando il passo successivo**: il run è annullato, si può
   rifare la cerimonia — **in `dry-run` prima**, per verificare l'esito
   senza riscrivere, poi per davvero.

## Cosa NON fare

- Mai `git push --force` / `--force-with-lease`, mai `git reset` su
  commit già pushati.
- Mai revertare commit che non appartengono al run senza conferma
  esplicita dell'utente sull'insieme.
- Mai annullare una decisione già in `product/approvals/decided/` con
  `decision: approved` — è fuori scope, si segnala e basta.
- Mai risolvere da soli un conflitto di revert — abort, ferma, riferisci.
- Non cancellare la trascrizione grezza senza aver chiesto se conservarla.
