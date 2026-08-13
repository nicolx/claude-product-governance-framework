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

5. **Spiega cosa è cambiato in linguaggio PM, non solo il diff grezzo.**
   Esempi del tipo di traduzione richiesta:
   - "il playbook ha aggiornato le soglie di Confidence" → spiega la
     nuova soglia e se qualche RICE esistente andrebbe rivalutato.
   - "è stata aggiunta la skill X" → spiega cosa fa e quando userla.
   - "lo schema di `idea.yaml` ha un nuovo campo obbligatorio" →
     **questo è il caso che richiede attenzione**: segnala esplicitamente
     che le idee esistenti in `product/ideas/` potrebbero non avere quel
     campo, e proponi (senza applicarlo da solo) un piano di migrazione
     minimo. Non modificare in massa i file di istanza senza che
     l'utente lo chieda esplicitamente.

6. Chiudi con un riepilogo breve: cosa è cambiato, cosa richiede
   attenzione da parte dell'utente, cosa non richiede nulla.
