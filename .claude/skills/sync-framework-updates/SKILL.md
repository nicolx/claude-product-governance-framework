---
name: sync-framework-updates
description: Tira giù gli aggiornamenti del metodo (playbook, skill, schema) dall'upstream del framework canonico e li spiega in linguaggio PM, segnalando se richiedono una migrazione dei dati locali. Usala periodicamente in un'istanza già inizializzata.
---

# sync-framework-updates

Aggiorna un'istanza già inizializzata con le ultime modifiche del metodo
dal repo canonico (`upstream`), senza toccare i dati dell'istanza.

## Prerequisiti

Richiede `.governance/config.yaml` presente (istanza inizializzata) e un
remote `upstream` configurato (aggiunto da `bootstrap.sh`). Se manca,
segnalalo invece di procedere.

## Passi

1. `git fetch upstream`.

2. Mostra `git log HEAD..upstream/main --oneline` (o il branch principale
   configurato) — se è vuoto, informa l'utente che è già allineato e
   fermati qui.

3. Prima di fare merge, leggi i commit/diff che toccano
   **esclusivamente** cartelle di proprietà framework
   (`framework/`, `.claude/skills/`, `.githooks/`, `bootstrap.sh`,
   `CLAUDE.md`, `README.md`). Se un commit upstream tocca `apps/` o
   `product/`, è un'anomalia (quelle cartelle non dovrebbero esistere nel
   canonico) — segnalala esplicitamente invece di applicarla in
   automatico.

4. Fai `git merge upstream/main` (o il branch configurato). Se emergono
   conflitti, **non risolverli automaticamente su file di proprietà
   framework**: mostrali all'utente. I conflitti su file di istanza
   dovrebbero essere rari per costruzione (l'upstream non scrive lì), se
   capitano vanno trattati con particolare attenzione.

   Dopo un merge pulito, **pusha su `origin`** (non `governance-sync.sh`
   qui — questo è l'unico punto del framework in cui il push porta
   commit da `upstream`, non stato dati dell'istanza): `git push origin`.
   Se fallisce (non fast-forward, un collega ha pushato nel frattempo),
   segnalalo esplicitamente invece di forzare — stesso principio
   "solo fast-forward" della sincronizzazione dati (playbook,
   "Sincronizzazione dell'istanza (`origin`)").

5. **Spiega cosa è cambiato in linguaggio PM, non solo il diff grezzo.**
   Esempi del tipo di traduzione richiesta:
   - "il playbook ha aggiornato le soglie di Confidence" → spiega la
     nuova soglia e se qualche RICE esistente andrebbe rivalutato.
   - "è stata aggiunta la skill X" → spiega cosa fa e quando userla.
   - "è stato aggiunto un file di riferimento di istanza" (es.
     `framework/schema/annual-target.template.yaml`, nuovo) → l'istanza
     non ha ancora il file corrispondente in `product/reference/`.
     Proponi di crearlo dal template e di raccogliere il dato mancante
     (nel caso di `annual-target.yaml`: l'incremento annuo atteso, non il
     totale a budget — vedi il template) — senza bloccare, ma segnalando
     cosa resta approssimato finché non è dichiarato.
   - "lo schema di `idea.yaml` ha un nuovo campo obbligatorio" →
     **questo è il caso che richiede attenzione**: segnala esplicitamente
     che le idee esistenti in `product/ideas/` potrebbero non avere quel
     campo, e proponi (senza applicarlo da solo) un piano di migrazione
     minimo. Non modificare in massa i file di istanza senza che
     l'utente lo chieda esplicitamente. Se i campi nuovi sono opzionali
     (es. `summary`, `notes`, `requester_reply`, `followup_replies`,
     `rice_status.deep_dive`, `status: declined`): le idee vecchie restano
     valide senza; l'unico con valore a essere backfillato è `summary` (una
     riga per idea ancora attiva), perché `backlog-list` lo mostra —
     proponilo come lavoretto incrementale, non un blocco. Eccezione
     meccanica: `requester_reply.reply_status` — per le idee con
     `needed: true` e `sent_at` valorizzato vale `sent`, con `needed:
     false` vale `not_needed`; quelle con `needed: true` e `sent_at: null`
     vanno chieste al PM (inviata a voce/fuori traccia → `sent` o
     `waived`, altrimenti `drafted`), mai presunte — è ciò che
     l'hook `check-requester-replies.sh` conta.
   - "un nuovo **gate** su una transizione di stato" (es.
     `conclusion_notices`: `status: done`/`aborted` e `closure.closed`
     solo con l'avviso agli stakeholder `sent`/`waived`) → il gate vale
     **in avanti**: le idee già `done`/`aborted` e le closure già scritte
     restano valide, nessun backfill retroattivo di voci. Spiega cosa
     cambia nel lavoro quotidiano (la conclusione si chiude quando è
     comunicata) e — solo se il PM lo chiede — proponi di aprire una voce
     per le consegne recenti che non erano mai state comunicate.
   - "un campo esistente ha cambiato significato" (es. la "E" del RICE è
     passata da `effort_weeks`/settimane a `entanglement_score`/footprint
     1-10) → **caso di migrazione dati**: le voci `rice_history` esistenti
     hanno la vecchia semantica e i loro `score` sono calcolati sulla
     vecchia formula. Spiega che restano valide come storico ma non sono
     più confrontabili 1:1 con le voci nuove, e proponi (senza applicarlo)
     di ricalcolare l'Entanglement — via `rice-update`, con la sua coda di
     approvazione — per le idee ancora attive in backlog, lasciando
     intatte quelle già chiuse. Segnala anche i campi nuovi che le idee
     attive dovranno avere popolati (es. `delivery.estimated_effort_weeks`
     in Iteration Planning per le iniziative in iterazione;
     `short_ref`, assegnato dal prossimo `backlog-refinement` alle idee
     ancora senza handle).

   - "Reach del RICE è passata da percentuale 0-100 a banda intera 1-10"
     → **migrazione dati MECCANICA** (a differenza del caso Entanglement
     sopra, che richiede ri-stima): non serve giudizio, è pura
     conversione di formato. Per **ogni** voce di `rice_history` di
     **ogni** idea con `reach_percent` valorizzato:
     - `reach_points = max(1, ceil(reach_percent / 10))`;
     - `score` ricalcolato = `reach_points * impact_points *
       confidence_score / entanglement_score`;
     - il vecchio valore va spostato in `reach_absolute_note`
       (prependi "≈{reach_percent}% della popolazione → {reach_points}"
       se la nota ha già contenuto), poi rimuovi la chiave `reach_percent`
       (o lasciala a `null` — è marcata deprecata nello schema).
     Questo **puoi applicarlo direttamente su conferma esplicita
     dell'utente** — idea per idea, un unico commit
     (`sync-framework-updates: migrazione Reach %→1-10`), poi
     `governance-sync.sh push`. Non passa da `product/approvals/pending/`:
     è un riscalamento di formato, non una revisione di priorità (vedi
     `idea.template.yaml`, nota sull'append-only). Mostra all'utente la
     tabella prima/dopo degli `score` così vede se qualche ranking si
     sposta ai confini di banda — è un effetto atteso, non un errore.

   - "i PRD si scrivono per il loro lettore" (brief d'iniziativa,
     `primary_reader`/`prd_kind`, registro dei punti chiave, allegato dati,
     lettura a freddo, glossario — playbook, "Scrivere per il lettore:
     dalla fonte all'artefatto") → **nessuna migrazione obbligatoria**: i
     campi nuovi del frontmatter PRD sono opzionali e i PRD esistenti
     restano validi. Spiega al PM cosa cambia nel modo di lavorare
     (`prd-draft` ora intervista anche su lettore e scenario, scrive il
     brief e collauda i documenti con una lettura a freddo) e:
     - se manca `product/reference/glossary.yaml`, proponi di crearlo vuoto
       dal template;
     - per i PRD in `draft`/`in_review` che dovranno essere condivisi con
       persone o agenti fuori dalla sessione, **proponi** `prd-draft {slug}
       retrofit` (registro dei punti chiave, brief, lettura a freddo,
       correzioni proposte). Non toccare i PRD `approved`/`superseded`.

   - "il framework ora vieta che `short_ref_prefix` coincida con
     `jira.project_key`" → **controllo di setup**: leggi
     `.governance/config.yaml`. Se `short_ref_prefix` (o il default `PG`
     se la chiave manca) è uguale (case-insensitive) a `jira.project_key`,
     l'istanza ha handle di governance che si confondono con le card del
     tracker. Segnala che serve un **rinominamento una-tantum** degli
     `short_ref` già assegnati verso un prefisso proprio: è manuale
     (`sed`/`grep -rl` su `product/`, aggiornare i titoli dei PRD e le
     note che citano il vecchio handle; i titoli delle card Jira si
     aggiornano a mano). Non farlo tu — proponilo e lascia decidere.

6. Chiudi con un riepilogo breve: cosa è cambiato, cosa richiede
   attenzione da parte dell'utente, cosa non richiede nulla.
