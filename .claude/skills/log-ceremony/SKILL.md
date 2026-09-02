---
name: log-ceremony
description: Registra una cerimonia collettiva a partire dalla sua trascrizione grezza, producendo un record strutturato di decisioni (decisions.yaml) e i metadati di esecuzione (.run-meta.yaml) collegati a idee/roadmap impattati. Motore comune usato dalle skill di cerimonia dedicate (backlog-refinement, iteration-planning); usala direttamente per cerimonie ad-hoc o ricorrenti diverse dalle due settimanali (measurement-retro, strategic-exception-review, altro).
---

# log-ceremony

Registra una cerimonia collettiva del playbook a partire dalla sua
trascrizione o dagli appunti grezzi. È il **motore comune** della
registrazione di una cerimonia: crea la cartella, salva il materiale
grezzo, struttura le decisioni, scrive i metadati di esecuzione,
sincronizza — senza mai applicare da sé gli impatti su RICE/roadmap.

## Quando usarla e quando no

- **Per le due cerimonie settimanali, non invocarla direttamente**: usa
  `backlog-refinement` (Product Backlog Refinement) e `iteration-planning`
  (Roadmap Update & Iteration Planning). Sono i punti d'ingresso dedicati
  — fissano `ceremony_type` e periodo così non vanno rispecificati ogni
  volta, aggiungono i passi specifici di quella cerimonia, e poi delegano
  qui per la parte comune.
- **Usala direttamente** per una cerimonia ad-hoc o ricorrente diversa
  (`measurement-retro`, `strategic-exception-review`, o altro tipo che
  l'utente specifica): in quel caso `ceremony_type` e periodo li dai tu.
- **Non usarla** per la discussione di RICE scoring legata a una singola
  idea (Episodio-tipo: PM + referente tecnico + stakeholder che stimano
  RICE di un'idea specifica) — quel materiale va invece salvato come
  `source/` dentro la cartella dell'idea stessa, perché è 1:1 con
  un'idea, non un rito ricorrente del team.

## Rapporto con le skill di cerimonia dedicate

I passi qui sotto sono quelli **comuni** a qualunque cerimonia.
`backlog-refinement` e `iteration-planning` li eseguono tutti,
intercalando i propri passi specifici — la sweep delle watch e le
reprioritizzazioni fuori-RICE per il primo, le stime di delivery e la
valutazione 80/20 per il secondo (descritti nelle rispettive skill, non
qui: non duplicare, linkare). Per una cerimonia ad-hoc invocata
direttamente, questi passi sono tutto ciò che serve.

## Passi comuni

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture e analisi normalmente, **non** scrivere su
> `product/`/`context/`/`.governance/` (nessuna cartella cerimonia,
> nessun `decisions.yaml`, nessun `.run-meta.yaml`, nessuna proposta in
> `pending/`), **non** invocare `governance-sync.sh push`, mostra come
> testo l'output completo che avresti prodotto, e chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`
> **Propaga il dry-run** a ogni skill che richiami.

0. **Sincronizza da `origin` prima di leggere lo stato**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)"). Se l'helper segnala un
   disallineamento non-fast-forward, fermati e riferiscilo all'utente.

1. Determina `ceremony_type` (es. `backlog-refinement`,
   `roadmap-iteration-planning`, `measurement-retro`, o altro se
   l'utente lo specifica) e il periodo (settimana ISO per cerimonie
   settimanali, data per le altre). Se invocata da `backlog-refinement`
   o `iteration-planning`, entrambi sono già fissati.

2. Crea `product/ceremonies/{ceremony_type}/{periodo}/`. Se esiste già
   per lo stesso periodo, chiedi se integrare o è un errore.
   - **Prima di creare qualunque file**, esegui `git rev-parse HEAD` e
     tienilo come `base_sha` — è il punto a cui `rollback-ceremony`
     riporterà il repo se questo run va annullato. (Se stai integrando
     un run già `completed`, non riscrivere `base_sha`: resta quello
     del primo run.)
   - Scrivi subito `.run-meta.yaml` nella cartella, da
     `framework/schema/ceremony-run-meta.template.yaml`: `ceremony_type`,
     `period`, `started_at` (ora corrente), `started_by`, `base_sha`,
     `status: running`. È metadato di esecuzione, non una decisione:
     scrittura diretta, non passa da `pending/`.

3. Salva il materiale grezzo (trascrizione, appunti) in `source/` dentro
   la cartella, senza parafrasarlo via.

4. Estrai le decisioni atomiche e compila `decisions.yaml` da
   `framework/schema/ceremony-decisions.template.yaml`: per ogni
   decisione, un `summary` breve e gli `impacts` — quali idee sono state
   ridiscusse, se è stato generato uno snapshot di roadmap, se è stata
   creata una voce in `approvals/`.

5. **Non applicare tu stesso gli impatti.** Se dalla cerimonia emerge che
   il RICE di un'idea va rivisto, lancia (o suggerisci di lanciare)
   `rice-update` — non scrivere direttamente su `idea.yaml`. Se emerge
   che serve un nuovo snapshot di roadmap, suggerisci `roadmap-snapshot`.
   `log-ceremony` cattura e struttura il *materiale*, non decide da sola
   cosa applicare.

   La skill di cerimonia che ti ha invocato (`backlog-refinement`,
   `iteration-planning`) ti passa anche il proprio materiale specifico da
   riversare qui: i riepiloghi delle watch e le `reprioritizations` per
   il Backlog Refinement (inclusi `retro_notes`), le stime di delivery e
   la valutazione 80/20 per l'Iteration Planning. Includili nelle
   `decisions`/campi appositi di `decisions.yaml` — non rieseguire tu
   quei passi, sono di competenza della skill chiamante.

6. **Mostra un riepilogo delle decisioni estratte all'utente** prima di
   considerare il log completo — è più facile correggere un
   fraintendimento ora che scoprirlo settimane dopo in una revisione.
   Se la skill chiamante ha fornito reprioritizzazioni o riepiloghi di
   watch a rischio, includili con la **stessa evidenza** — non in coda,
   non come nota a margine. Per il Backlog Refinement, **apri sempre il
   riepilogo con gli allarmi di `nsm-watch`** se ce ne sono (è il segnale
   più strategico della cerimonia, per playbook), seguiti dalle scadenze
   `overdue`/`due_soon` di `mandate-watch` e `deadline-watch`.

7. **Chiudi `.run-meta.yaml` e sincronizza il repo.** Imposta in
   `.run-meta.yaml` `status: completed` e `completed_at` (ora corrente),
   poi esegui
   `bash .claude/hooks/governance-sync.sh push "log-ceremony: <ceremony_type> <periodo>" product/ceremonies/ product/approvals/pending/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). La skill
   chiamante e le watch che ha richiamato hanno già sincronizzato le
   proprie scritture su `idea.yaml`/`nsm-tracking.yaml` con un commit
   dedicato ciascuna; questo passo cattura i file della cerimonia
   (inclusi `.run-meta.yaml`) e le eventuali proposte in `pending/`. Se
   l'helper segnala un push fallito, riferiscilo nel riepilogo —
   `status: completed` resta comunque scritto in locale, il commit è
   già stato fatto.
