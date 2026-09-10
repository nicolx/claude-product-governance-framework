---
name: team-fit
description: Data una PRD già redatta, propone una shortlist ordinata di sviluppatori che potrebbero prenderla in carico — incrociando l'How (sistemi toccati, blast radius), gli apps/ coinvolti e i rischi aperti del PRD con l'anagrafica del team (product/reference/team.yaml). Sola lettura, advisory: non scrive nulla, non assegna niente. La decisione vera è di Iteration Planning e vive nel tracker di esecuzione. Usala durante o dopo prd-draft, e all'Iteration Planning quando si confermano le assegnazioni.
---

# team-fit

Risponde a "**chi, nel team, potrebbe prendere in carico questo PRD?**"
leggendo il PRD e incrociandolo con `product/reference/team.yaml`.

È **sola lettura e advisory**. Non scrive file, non fa commit, non crea
voci in `product/approvals/pending/`, non tocca il tracker di esecuzione,
non registra l'assegnazione da nessuna parte. La shortlist è un input per
il PM e il tech lead: **l'assegnazione vera si decide in Iteration
Planning e vive in Jira** (il tracker resta l'unica fonte di verità per
l'esecuzione — vedi playbook, "Il tracker di esecuzione (Jira):
collegamento, non duplicazione").

## Prerequisiti

- Un PRD già redatto in `product/prds/{slug}/` (skill `prd-draft`).
- `product/reference/team.yaml` popolato. Se manca o ha `members: []`,
  **fermati** e rimanda a `team-roster` — non tirare a indovinare i
  componenti del team.

## Passi

Questa skill non scrive stato tracciato, quindi non ha un contratto
dry-run: è già priva di effetti collaterali per costruzione.

1. **Sincronizza e leggi.** `bash .claude/hooks/governance-sync.sh pull`
   (una vista su un roster o un PRD vecchi è fuorviante). Poi:
   - risolvi il PRD target: se l'argomento è uno slug, apri
     `product/prds/{slug}/`; altrimenti chiedi quale. Leggi **tutti** i
     `prd*.md` della cartella (se l'iniziativa è spaccata in più
     documenti, valuta ciascuno — possono servire competenze diverse) e
     l'`idea.yaml` collegata via `idea_id` (per `classification`,
     `product_line`, dominio);
   - `product/reference/team.yaml`;
   - `.governance/config.yaml` `apps[]` (per collegare gli slug del roster
     ai sistemi reali).

2. **Estrai il profilo tecnico del PRD:**
   - **sistemi/componenti toccati** — dalla sezione *How* e dai
     riferimenti a `apps/`. Mappali sugli slug di `config.yaml apps[]`
     quando possibile;
   - **rischi e dipendenze aperte** — dalla sezione omonima: ognuno è
     un'area di competenza specifica da coprire;
   - **profilo di cambiamento** — dall'How: integrazione vs. UI vs. dato
     vs. infra, blast radius, se serve conoscere un sistema legacy;
   - **dominio / product line** — dall'idea.

3. **Valuta ogni membro** contro questo profilo, usando **solo** ciò che
   è scritto in `team.yaml`:
   - `apps` del membro ∩ sistemi toccati dal PRD — familiarità diretta col
     codice è il segnale più forte;
   - `skills` del membro ∩ tecnologie e aree di rischio del PRD (es. un
     rischio "throughput su Kafka" è coperto da uno `skills: [kafka]`);
   - `availability` — un ottimo match tecnico a disponibilità zero va
     detto, non nascosto;
   - `seniority` / `notes` — per iniziative ad alto blast radius o su
     sistemi legacy, il presidio storico conta.

4. **Produci la shortlist** — 3-5 nomi ordinati, ciascuno con una riga di
   motivazione **puntuale e verificabile**, che cita il match specifico:

   > 1. **Marco** — presidia `apps/checkout-service` (toccato dall'How);
   >    `skills: kafka` copre il rischio aperto #2. Disponibilità piena.
   > 2. **Sara** — full-stack su `checkout-service`; nessun match diretto
   >    sui rischi ma conosce il flusso end-to-end. `-20% questo mese`.

   Ogni riga è indirizzabile dal `name` del membro (playbook, "Ogni
   elenco prodotto dal sistema è indirizzabile").

5. **Dichiara i buchi, non nasconderli:**
   - rischi o sistemi toccati che **nessun** membro copre → dillo
     esplicitamente ("il rischio #3, migrazione dati Postgres, non è
     coperto da nessuno nel roster — valutare supporto esterno o
     upskilling");
   - se il candidato di testa è a bassa disponibilità;
   - se `team.yaml` `updated_at` è vecchio di mesi → segnala che il roster
     potrebbe non riflettere il team attuale, rimanda a `team-roster`;
   - se `apps/` è vuota nell'istanza → il match si è basato solo su
     `skills`, dillo.

6. **Chiudi rimandando alla decisione vera.** La shortlist non è
   un'assegnazione: va portata in Iteration Planning (checklist "i task
   sono caricati nel tracker e assegnati?"), dove il team conferma e
   l'assegnazione viene registrata in Jira.

## Cosa NON fare

- Non scrivere su nessun file, non fare commit/push, non creare voci in
  `pending/`, non scrivere nel PRD, non toccare il tracker.
- Non "assegnare" — proponi soltanto.
- Non valutare le persone su nulla che non sia in `team.yaml` (niente
  giudizi di performance, niente inferenze sul carattere).
- Non inventare competenze o disponibilità non dichiarate: se un dato
  manca, il match è più debole e va detto.
- Non procedere con un roster vuoto o assente: rimanda a `team-roster`.
