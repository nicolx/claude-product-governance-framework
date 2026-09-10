---
name: team-roster
description: Crea e fa evolvere l'anagrafica del team di sviluppo dell'istanza (product/reference/team.yaml) — chi c'è, quali aree di apps/ presidia, competenze, disponibilità. Primo popolamento (se init non l'ha fatto) e modifiche successive (aggiungi / aggiorna / rimuovi un membro). Dato di riferimento condiviso come product-lines.yaml: scrittura diretta, non passa da approvazione. La legge team-fit per proporre candidati su un PRD.
---

# team-roster

Mantiene `product/reference/team.yaml` — la mappa di **chi c'è nel team di
sviluppo, cosa presidia, cosa sa fare**. È il gemello in scrittura di
`team-fit` (che la legge in sola lettura per proporre chi potrebbe
prendere in carico un PRD).

`team.yaml` è un **dato di riferimento condiviso**, alla pari di
`product/reference/product-lines.yaml` e `annual-target.yaml`: scrittura
diretta, **non** passa da `product/approvals/pending/` (non è una
decisione di priorità né una comunicazione in uscita). Tracciata da git.

**Descrittiva, non valutativa.** Il roster registra competenze, presidio e
disponibilità per instradare il lavoro — non giudizi di performance. Se la
conversazione scivola su "X è lento", "Y non è affidabile", riporta il
focus: quello che serve è *cosa sa fare* e *cosa conosce*, non come rende.

## Prerequisiti

Nessuno stringente. Se `.governance/config.yaml` non esiste, l'istanza non
è inizializzata — segnalalo e fermati (stessa logica delle altre skill di
istanza).

## Passi

> **Dry-run.** Se la skill è invocata in simulazione (argomento
> `dry-run`, o `dry_run: true` in `.governance/config.yaml`), applica il
> contratto della sezione "Modalità dry-run (simulazione)" del playbook:
> leggi e analizza normalmente, mostra come testo il `team.yaml` completo
> che avresti scritto, **non** scrivere il file, **non** invocare
> `governance-sync.sh push`, e chiudi con `🔍 DRY-RUN — nessun file
> scritto, nessun commit, nessun push.`

1. **Sincronizza e leggi lo stato.** `bash
   .claude/hooks/governance-sync.sh pull`. Poi:
   - `.governance/config.yaml` — la lista `apps[]` (per validare gli slug
     che il PM assocerà ai membri) e `pm_roster` (i PM non vanno nel team
     di sviluppo a meno che non sviluppino anche loro — chiedi se non è
     chiaro).
   - `product/reference/team.yaml` se esiste. Se **non** esiste, è il
     primo run: crealo in memoria da
     `framework/schema/team.template.yaml` (scaffold lazy, stesso
     principio di `nsm-tracking.yaml`).

2. **Capisci l'intento.** Uno tra:
   - **primo popolamento** — il PM elenca il team (o incolla una tabella /
     un export da uno strumento HR); estrai tutto ciò che mappa sui campi
     del template e chiedi solo quello che manca;
   - **aggiungi** un membro;
   - **aggiorna** un membro (nuove skill, cambio di presidio, disponibilità
     diversa);
   - **rimuovi** un membro (è uscito dal team / dall'azienda). Non
     cancellare a cuor leggero se non richiesto: chiedi conferma.

3. **Per ogni membro toccato**, raccogli — senza presumere:
   - `name` (o handle con cui il team lo chiama) ed `email` **solo se il
     team la vuole tracciare** (default `""`, come si può fare per
     `pm_roster`);
   - `seniority` — libero, con la convenzione che l'istanza preferisce;
   - `apps` — gli slug delle voci `apps/` che presidia. **Validali contro
     `config.yaml` `apps[].slug`**: se uno slug non combacia, avvisa
     ("`checkout` non è tra gli apps collegati — intendevi
     `checkout-service`?") ma **non bloccare** (l'app potrebbe essere
     aggiunta dopo). Se `apps/` è vuota nell'istanza, lascia `apps: []` e
     nota che il matching di `team-fit` si baserà solo su `skills`;
   - `skills` — tag liberi (linguaggi, framework, aree: `kafka`, `go`,
     `payments`, `react`, `observability`…). Punta al concreto, non a
     etichette vaghe ("bravo col back-end" → chiedi *cosa*);
   - `availability` — in prosa, un fatto dichiarato dal PM, mai calcolato;
   - `notes` — contesto extra utile al matching (owner di fatto di un
     sistema, in onboarding su un'area, vincoli noti).

4. **Scrivi `product/reference/team.yaml`.** Aggiorna `updated_at` alla
   data odierna. Ordina `members` per `name` (stabilità dei diff).
   Scrittura diretta — **non** creare nessuna voce in
   `product/approvals/pending/`.

5. **Sincronizza il repo:** `bash .claude/hooks/governance-sync.sh push
   "team-roster: <cosa è cambiato>" product/reference/`. Se l'helper
   segnala un push fallito, riferiscilo nel riepilogo.

6. **Riepiloga** cosa è cambiato e — se utile — ricorda che `team-fit
   <prd-slug>` usa questi dati per proporre chi potrebbe prendere in
   carico un PRD.

## Cosa NON fare

- Non registrare giudizi di performance, note disciplinari, valutazioni.
  Solo competenze, presidio, disponibilità.
- Non presumere skill, seniority o disponibilità: sono dati che il PM
  dichiara.
- Non trattare `team.yaml` come soggetta ad approvazione: è reference
  data, scrittura diretta (stessa regola di `product-lines.yaml`).
- Non inserire i PM nel team di sviluppo per default — solo se sviluppano
  davvero.
- Non inventare slug `apps/`: se non combaciano con `config.yaml`, avvisa
  e chiedi.
