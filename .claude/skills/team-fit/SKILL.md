---
name: team-fit
description: Data una PRD già redatta, propone una shortlist ordinata di sviluppatori con cui validare l'How — incrociando i sistemi toccati, il blast radius e i rischi aperti del PRD con l'anagrafica del team (product/reference/team.yaml). Advisory: propone, non assegna. Su conferma esplicita del PM scrive il tech_reference del PRD (referente per la revisione, non l'assegnazione di implementazione — quella è di Iteration Planning e vive nel tracker). Usala quando il roster cambia o il PRD evolve; prd-draft la esegue già dentro la stesura.
---

# team-fit

Risponde a "**chi, nel team, è la persona di riferimento per questo
PRD?**" leggendo il PRD e incrociandolo con `product/reference/team.yaml`.

`prd-draft` esegue già questa logica dentro la stesura e imposta il
`tech_reference` del PRD — **non serve rilanciarla a mano subito dopo**.
Usala quando: il roster è cambiato, il PRD è evoluto, o all'Iteration
Planning si riconfermano i referenti.

## Cosa scrive (e cosa no)

È **advisory**: propone, non decide. Non tocca il tracker di esecuzione,
non compie azioni in uscita, non crea voci in `product/approvals/pending/`.

L'unica cosa che scrive — e **solo su conferma esplicita del PM** — è il
`tech_reference`:
- nel frontmatter del/dei `prd*.md`;
- denormalizzato su `product/ideas/{slug}/idea.yaml` (PRD primario).

È scrittura **diretta**, la stessa che fa `prd-draft` alla stesura: il
`tech_reference` è il referente con cui validare l'How e la prima scelta
naturale in assegnazione — **non** l'assegnazione formale di
implementazione (quella si decide in Roadmap update & Iteration Planning e
vive nel tracker, unica fonte di verità per l'esecuzione). Vedi playbook,
"Team di sviluppo, referente tecnico e staffing di un PRD".

## Prerequisiti

- Un PRD già redatto in `product/prds/{slug}/` (skill `prd-draft`).
- `product/reference/team.yaml` popolato. Se manca o ha `members: []`,
  **fermati** e rimanda a `team-roster` — non tirare a indovinare i
  componenti del team.

## Passi

> **Dry-run.** Se invocata con `dry-run` (o `dry_run: true` in
> `.governance/config.yaml`): esegui letture e analisi, mostra la
> shortlist e il `tech_reference` che *proporresti*, **non** scrivere il
> frontmatter del PRD né `idea.yaml`, **non** fare commit/push, chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`

1. **Sincronizza e leggi.** `bash .claude/hooks/governance-sync.sh pull`
   (una vista su un roster o un PRD vecchi è fuorviante). Poi:
   - risolvi il PRD target: se l'argomento è uno slug, apri
     `product/prds/{slug}/`; altrimenti chiedi quale. Leggi **tutti** i
     `prd*.md` della cartella (se l'iniziativa è spaccata in più
     documenti, valuta ciascuno — possono servire referenti diversi) e
     l'`idea.yaml` collegata via `idea_id` (per `classification`,
     `product_line`, dominio, e l'eventuale `tech_reference` già posto);
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
   elenco prodotto dal sistema è indirizzabile"). Se il PRD ha già un
   `tech_reference`, mostralo come "referente attuale" e posiziona la
   shortlist come conferma o alternativa.

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

6. **Proponi il `tech_reference` e chiedi conferma.** Il candidato di
   testa è la proposta. **Non scrivere in silenzio** — è una persona, la
   conferma il PM in conversazione (come `deadline`). Alla conferma:
   - scrivi `tech_reference` nel frontmatter del/dei PRD toccati (uno per
     PRD se differiscono) e aggiorna la riga di chiusura della sezione
     *How* (`_Validare l'How con: {nome} ({motivo})..._`);
   - denormalizza `tech_reference` su `idea.yaml` (PRD primario);
   - `bash .claude/hooks/governance-sync.sh push "team-fit: tech_reference <slug>" product/prds/ product/ideas/`.
   Se il PM non conferma nessuno (nessun match convincente, vuole
   deciderlo altrove), **non scrivere niente** — resta la shortlist come
   input.

7. **Chiudi.** Il `tech_reference` è il referente per validare l'How, non
   l'assegnazione: quella si conferma in Iteration Planning e vive nel
   tracker.

## Cosa NON fare

- Non fare commit/push oltre a quello del passo 6, non creare voci in
  `pending/`, non toccare il tracker, non compiere azioni in uscita.
- Non scrivere `tech_reference` senza conferma esplicita del PM.
- Non "assegnare" l'implementazione — proponi il referente soltanto.
- Non valutare le persone su nulla che non sia in `team.yaml` (niente
  giudizi di performance, niente inferenze sul carattere).
- Non inventare competenze o disponibilità non dichiarate: se un dato
  manca, il match è più debole e va detto.
- Non procedere con un roster vuoto o assente: rimanda a `team-roster`.
