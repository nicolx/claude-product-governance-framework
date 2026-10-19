---
name: sync-framework-updates
description: Tira giù gli aggiornamenti del metodo (playbook, skill, schema) dall'upstream del framework canonico, li spiega in linguaggio PM e — leggendo le voci nuove di framework/CHANGELOG.md — verifica per ciascuna se l'istanza è già a posto e propone solo ciò che resta da fare (setup di una funzione nuova, migrazione dei dati locali). Usala periodicamente in un'istanza già inizializzata.
---

# sync-framework-updates

Aggiorna un'istanza già inizializzata con le ultime modifiche del metodo
dal repo canonico (`upstream`), senza toccare i dati dell'istanza, e
porta a termine l'adozione delle funzioni nuove: cosa configurare, cosa
migrare, cosa non chiede nulla.

La fonte di cosa fare dopo l'aggiornamento è **`framework/CHANGELOG.md`**
(una voce per evoluzione, con tipo di impatto, passi e un controllo "già
a posto se"). Leggi l'intestazione del file per il formato e il
significato dei tipi di impatto prima di iniziare.

## Prerequisiti

Richiede `.governance/config.yaml` presente (istanza inizializzata) e un
remote `upstream` configurato (aggiunto da `bootstrap.sh`). Se manca,
segnalalo invece di procedere.

## Passi

1. `git fetch upstream`.

2. **Fissa il punto di partenza** prima del merge:
   `BASE=$(git merge-base HEAD upstream/main)` — l'ultimo commit di
   upstream già integrato in questa istanza (più affidabile di
   `framework.upstream_ref` in config, che va solo confrontato: se
   differiscono, l'istanza è stata aggiornata a mano, dillo). Mostra
   `git log $BASE..upstream/main --oneline` (o il branch principale
   configurato) — se è vuoto, l'istanza è già allineata: passa al passo
   7 (voci in sospeso) e poi fermati.

3. Prima di fare merge, controlla che i commit upstream tocchino
   **solo** file di proprietà framework (`CLAUDE.md`, tabella "Confini di
   proprietà"): `bootstrap.sh`, `.githooks/`, `framework/`,
   `.claude/skills/`, `.claude/settings.json`, `.claude/hooks/`,
   `.gitignore`, `CLAUDE.md`, `README.md`, `examples/`. Se un commit
   upstream tocca `apps/`, `product/`, `context/` o `.governance/`, è
   un'anomalia (quelle cartelle non dovrebbero esistere nel canonico) —
   segnalala esplicitamente invece di applicarla in automatico.

4. **Raccogli le voci nuove del changelog** (prima del merge, così puoi
   anticiparle al PM):
   - se `framework/CHANGELOG.md` esiste a `$BASE`: le voci nuove sono
     quelle il cui `id` compare in
     `git show upstream/main:framework/CHANGELOG.md` e non in
     `git show $BASE:framework/CHANGELOG.md`;
   - se a `$BASE` il file non esisteva ancora (primo aggiornamento dopo
     la sua introduzione): le voci con data (prefisso dell'`id`) uguale o
     successiva a quella di `$BASE` (`git show -s --format=%cs $BASE`).
     Alcune possono riguardare cose già integrate lo stesso giorno: il
     controllo "già a posto se" del passo 6 le scarta.
   - **Controllo di copertura**: per ogni commit di
     `git log $BASE..upstream/main` che tocca uno schema
     (`framework/schema/`), la config, i permessi o il `.gitignore`
     senza una voce nuova corrispondente, spiega la modifica dal diff
     come sempre e segnala che al canonico manca una voce di changelog
     (è un difetto da riportare a chi lo mantiene, non da correggere
     nell'istanza).

5. Fai `git merge upstream/main` (o il branch configurato). Se emergono
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

6. **Per ogni voce nuova, verifica e spiega in linguaggio PM.** Esegui il
   controllo "Già a posto se" sul repo dell'istanza (file presenti,
   chiavi in `.governance/config.yaml`, campi delle idee — per le idee
   usa `bash .claude/hooks/governance-dump.sh ideas`, una sola lettura).
   Poi presenta le voci in tre gruppi:
   - **Da fare** — voci `setup`/`migrazione`/`migrazione-meccanica` il
     cui controllo non è soddisfatto: cosa si guadagna, i passi della
     voce, la skill da lanciare;
   - **Già a posto** — una riga per voce;
   - **Nessuna azione** — voci `nessuna`: cosa cambia nel lavoro
     quotidiano, in una o due righe.
   Le regole per tipo valgono sempre, anche se la voce non le ripete:
   - `setup` → **proponi**, non applicare da solo; non blocca nulla.
     Scritture in `.governance/config.yaml` solo su richiesta esplicita
     del PM (`CLAUDE.md`); permessi in `.claude/settings.local.json`
     mostrati prima, come in `init-governance-project` punto 7.
   - `migrazione` → proponi un piano minimo; **non modificare in massa i
     file di istanza** senza richiesta esplicita. Le correzioni che
     cambiano una priorità (RICE) passano da `rice-update` e dalla sua
     coda di approvazione.
   - `migrazione-meccanica` → applicabile da te **su conferma
     esplicita**, in un unico commit con il nome indicato dalla voce (o
     `sync-framework-updates: <id>`), mostrando prima/dopo, poi
     `governance-sync.sh push`. Non passa da `product/approvals/pending/`:
     è un cambio di formato, non una decisione di priorità.
   - Una voce che richiede un **dato** al PM (es. il target annuale) non
     si completa con un valore inventato: se il PM non lo sa, resta da
     fare e lo dici.

7. **Voci in sospeso.** Le voci "da fare" che il PM rimanda restano
   tali: al prossimo giro il controllo "già a posto se" le ritrova e le
   ripropone in una riga, senza insistere. Per vederle anche quando non
   c'è nulla da integrare (passo 2 vuoto), esegui i controlli delle voci
   `setup`/`migrazione*` con data uguale o successiva a `initialized_at`
   della config — le voci precedenti all'inizializzazione non riguardano
   l'istanza, perché l'init raccoglie già lo stato corrente del
   framework.

8. **Registra la versione integrata**: dopo un merge riuscito, scrivi
   `framework.upstream_ref` = `git rev-parse upstream/main` in
   `.governance/config.yaml` (è l'unica chiave della config che questa
   skill scrive, ed è un fatto di sincronizzazione, non una scelta del
   PM) e sincronizza con
   `bash .claude/hooks/governance-sync.sh push "sync-framework-updates: upstream_ref <sha breve>" .governance/config.yaml`.

9. Chiudi con un riepilogo breve: cosa è cambiato, cosa richiede
   attenzione da parte dell'utente (le voci "da fare", in ordine
   consigliato), cosa non richiede nulla.
