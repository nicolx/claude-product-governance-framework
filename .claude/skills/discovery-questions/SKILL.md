---
name: discovery-questions
description: Conduce la Discovery di un'iniziativa con metodo socratico — in ogni fase di analisi (meeting di approfondimento prima del RICE, Preliminary e Complete analysis, revisione del PRD, misurazione) individua cosa non sappiamo ancora, raccomanda a quale stakeholder chiederlo e con quali domande (aperte, sul passato, con la loro scala di follow-up), e prepara la guida del prossimo incontro calibrata su chi c'è. Dopo l'incontro recepisce le risposte (da trascrizione, appunti o dichiarazione del PM) e le propaga a tutti i materiali — punti chiave, brief, PRD, glossario, scadenze — proponendo in coda di approvazione ciò che tocca il RICE o un mandate. Tiene il registro delle domande in product/ideas/{slug}/discovery/. Usala per "prepara l'incontro con X", "cosa devo chiedere?", "ecco gli appunti della riunione", o per vedere le domande ancora aperte.
---

# discovery-questions

Applica la sezione del playbook **"Discovery socratica: le domande agli
stakeholder"** — leggila prima di iniziare (le sei famiglie di domande, le
regole, il ciclo prepara → incontro → recepisci). Legge anche "Preliminary
analysis", "Complete analysis" e "Scrivere per il lettore" per la fase in
cui si trova l'idea, e — per calibrare guida e invito sul destinatario —
"L'identikit degli stakeholder e il rapporto individuale".

Il criterio di successo: **dopo l'incontro, il PM sa qualcosa che prima non
sapeva e ogni artefatto lo riflette.** Non "abbiamo fatto tante domande".

| Modalità | Cosa fa | Scrive |
|---|---|---|
| `prepara` (default) | individua le lacune, raccomanda domande e interlocutori, scrive la guida del prossimo incontro | `discovery/questions.yaml`, `discovery/{data}-{interlocutore}.md` |
| `recepisci` | legge le risposte, aggiorna il registro, propaga ai materiali | registro, guida (sezione Esito), `source/`, punti chiave, brief, PRD, glossario, `deadline`; proposte in `pending/` |
| `stato` | domande aperte e incontri in sospeso, per un'idea o per tutte | niente (sola lettura) |

Il registro e le guide sono **scrittura diretta** (registro del lavoro di
analisi, come `key-points.yaml`). Ciò che una risposta *cambia* segue la
regola del suo target: RICE → `rice-update` → `pending/`; campi di un
mandate dopo la creazione → proposta `mandate_update`; cambiamento
materiale del contesto aziendale → `context-intake` con conferma;
identikit → `stakeholder-profile` su conferma. **Nessun invio**: l'invito e
il pre-read sono bozze che il PM manda a mano.

## Prerequisiti

Se `.governance/config.yaml` non esiste, l'istanza non è inizializzata —
segnalalo e fermati. L'idea deve esistere in `product/ideas/`. Per un'idea
`declined`/`aborted`/`done` chiedi conferma prima di preparare domande
(fase `measurement` a parte, che vale per le `done`).

## Passi

> **Dry-run.** Se la skill è invocata in simulazione (argomento
> `dry-run`, o `dry_run: true` in `.governance/config.yaml`), applica il
> contratto della sezione "Modalità dry-run (simulazione)" del playbook:
> letture e analisi normali, **non** scrivere nulla sotto `product/`
> (registro, guide, `source/`, propagazioni, proposte in `pending/`),
> **non** invocare `governance-sync.sh push`, mostra come testo tutto
> ciò che avresti scritto e chiudi con `🔍 DRY-RUN — nessun file scritto,
> nessun commit, nessun push.`

### Comune

1. **Sincronizza e leggi.** `bash .claude/hooks/governance-sync.sh pull`.
   Poi, per l'idea: `idea.yaml` (`summary`, `notes`, `classification`,
   `status`, `rice_history`/`rice_status`, `deadline`, `mandate`,
   `requester_reply`, `iteration`), tutto `source/` e
   `source/key-points.yaml`, il registro `discovery/questions.yaml` se
   esiste (altrimenti crealo in memoria da
   `framework/schema/discovery-questions.template.yaml`), le guide già in
   `discovery/`, e — se esistono — brief e PRD in
   `product/prds/{slug}/` con le letture a freddo in `.reviews/`. Leggi i
   file pertinenti di `context/` e, se l'idea tocca il codice,
   `bash .claude/hooks/governance-sync.sh apps` e poi `apps/`: **non si
   chiede a uno stakeholder ciò che è già documentato o verificabile.**
   Infine `product/reference/stakeholders.yaml` (identikit) e, in sola
   lettura, `.governance/stakeholder-relationships.local.yaml`.

2. **Stabilisci la fase** (dichiarata dal PM, altrimenti dedotta e
   detta): `deep_dive` se l'idea è `classification: idea` senza RICE e
   `rice_status.deep_dive.needed: true`; `preliminary` se è in
   `analysis_todo` o il brief manca o è `stage: preliminary`;
   `complete` se il brief è `preliminary` e si scrivono i PRD;
   `prd_review` se un PRD è `draft`/`in_review` con domande residue della
   lettura a freddo o del panel di revisione; `measurement` per un'idea `done` con una misurazione
   aperta che lo stakeholder deve leggere o accettare.

### Modalità `prepara`

3. **Inventario delle lacune — cosa non sappiamo.** Non partire da una
   lista di domande standard: parti dai buchi reali. Fonti, in ordine:
   - punti del registro dei punti chiave `type: open_question`,
     `hypothesis`, `estimate` non verificate, `opinion` usate come
     evidenza, attori (`actor`) mai sentiti;
   - il brief: "Cosa non sappiamo", ipotesi senza conferma, "Cosa
     chiediamo, a chi e quando" con date "da definire";
   - il RICE: quale parametro poggia su un'opinione o su un dato che solo
     uno stakeholder ha (Reach senza denominatore, Impact senza valore
     economico, Confidence bassa) — per `deep_dive` è il cuore;
   - le letture a freddo: domande residue e rilievi "decisione del PM"
     che il PM non può chiudere da solo;
   - il checklist della fase nel playbook (Why per la Preliminary; What,
     KPI con baseline/target, GTM per la Complete);
   - le domande del registro ancora `open`/`asked`/`partially_answered`.
   Per ogni lacuna scrivi `gap`, `gap_ref`, `why_it_matters` (quale
   decisione o artefatto cambia) e `affects`. **Scarta le lacune la cui
   risposta non cambierebbe nulla** e dillo nel recap.

4. **A chi chiederlo.** Per ogni lacuna, chi ha la risposta: proponente,
   attori del brief (anche indiretti: chi paga, chi va convinto, chi
   riceve l'output), stakeholder della Product Line, referente tecnico
   (`tech_reference`) per le lacune di How/Entanglement, chi presidia
   marketing/comunicazione per la GTM. Usa gli id dell'identikit quando
   esistono. Se una lacuna non ha un interlocutore noto, è essa stessa
   una domanda (al PM: "chi lo sa?"). Raggruppa per interlocutore: ogni
   gruppo è un candidato incontro.

5. **Scrivi le domande con metodo socratico** (playbook, tabella "Le sei
   famiglie di domande" e regole). Per ogni lacuna:
   - la famiglia giusta per il tipo di buco: un termine vago →
     `clarification`; un'ipotesi data per scontata → `assumption`; un
     numero o una convinzione senza fonte → `evidence`; un attore mai
     sentito → `viewpoint`; una soluzione già decisa → `implication`
     ("se lo facessimo, cosa dovrebbe cambiare per lei, e come ce ne
     accorgeremmo?"); un problema mal posto → `meta`;
   - formulazione **aperta, sul passato e sui fatti**, nel linguaggio
     dell'interlocutore, senza suggerire la risposta, senza gergo del
     framework;
   - `follow_ups`: la scala — cosa chiedere se risponde con un'opinione,
     con un "tutti/sempre", con un numero detto a voce, con una
     soluzione invece che un problema;
   - `expected_answer_kind`: cosa serve per chiudere il gap (un'opinione
     non chiude un Reach);
   - `priority`: `blocking` se senza risposta la fase non si chiude.
   **Socratico non vuol dire tante domande**: per un incontro di 30
   minuti 5-7 domande, le altre restano `open` nel registro per il
   prossimo.

6. **Mostra la raccomandazione al PM prima di scrivere**: tabella per
   interlocutore — `DQ`, domanda, famiglia, perché conta, priorità — più
   le lacune scartate. Chiedi: con chi è il prossimo incontro (o i
   prossimi), quando, quanto dura, se serve un invito/pre-read. Il PM può
   togliere, riformulare, spostare domande. **Applica il metodo anche a
   lui**: se una domanda del PM è chiusa o suggerisce la risposta,
   proponi la versione aperta e spiega perché in una riga — senza
   insistere oltre una volta.

7. **Scrivi la guida** dell'incontro
   (`product/ideas/{slug}/discovery/{YYYY-MM-DD}-{slug-interlocutore}.md`,
   template `framework/schema/discovery-meeting.template.md`; data =
   `planned_for`, o oggi se non fissata): cosa deve rendere possibile,
   cosa sappiamo già (da non chiedere), apertura larga, domande con la
   scala, ipotesi da mettere alla prova (con la conseguenza osservabile
   che dovrebbe essere vera se reggono), chiusura (teach-back, chi altro
   sentire, cosa non ho chiesto, prossimo passo). **Calibrata** sugli
   interlocutori: dall'identikit la forma (cosa gli importa → da lì si
   apre; `watch_out` → cosa evitare nella formulazione), dal rapporto la
   distanza. Nessuna parola del rapporto individuale nella guida (è
   tracciata): la riga `Calibrazione: …` solo in conversazione.
   Se il PM vuole un invito o un pre-read, scrivilo nella guida come
   bozza (A / Oggetto / Testo, testo semplice — playbook, "Testi che il PM
   manda a mano"): scopo e 2-3 temi, **mai** la scala socratica né le
   ipotesi da verificare. Mostralo per intero, copia il Testo negli
   appunti con `bash .claude/hooks/copy-to-clipboard.sh`,
   `invite_status: drafted`.

8. **Aggiorna il registro**: domande nuove con `status: planned` (quelle
   nella guida) o `open`, voce in `meetings` (`status: prepared`,
   `guide_ref`, `planned_for`). Se l'incontro è il meeting di
   approfondimento pre-RICE, aggiorna anche
   `rice_status.deep_dive.scheduled_for` quando il PM dà la data (cattura
   di un fatto, scrittura diretta). Poi
   `bash .claude/hooks/governance-sync.sh push "discovery-questions: guida <slug> con <interlocutore>" product/ideas/{slug}/`.

### Modalità `recepisci`

9. **Raccogli le risposte.** Da: trascrizione o appunti che il PM incolla
   o indica (anche arrivati via `inbox-triage`), oppure il racconto del
   PM in conversazione. Il materiale grezzo va in
   `product/ideas/{slug}/source/` (nome con data e interlocutore; mai
   dentro `discovery/`) — stessa regola di `idea-intake`. Associa
   l'incontro (`M-..`) o creane la voce se non era stato preparato.

10. **Mappa risposta → domanda.** Per ogni `DQ` pianificata: `answered`,
    `partially_answered` o non posta (resta `planned` → torna `open`). Per
    ogni risposta: `summary` fedele, `quote` se la formulazione conta,
    `by`, `at`, `info_kind` (tabella "Tipi d'informazione": un numero
    detto a voce è `estimate`, un esempio è `illustrative`, un "secondo me"
    è `opinion`), `source_locator`. **Mai completare una risposta che non
    c'è**: se è ambigua, chiedi al PM. Cerca anche:
    - **ciò che è emerso senza domanda** (spesso il più prezioso) → nuovi
      punti del registro dei punti chiave;
    - **contraddizioni** con il brief, il RICE o altre risposte → mostrale
      al PM come tali, non risolverle da sola;
    - **domande nuove** nate dalle risposte (`new_questions`): la
      discovery è una scala, il prossimo gradino si scrive subito.

11. **Piano di propagazione — mostralo prima di scrivere.** Per ogni
    risposta, dove va e cosa cambia:
    - `source/key-points.yaml`: punti nuovi (provenienza
      `source_locator` dell'incontro) o punti esistenti che cambiano
      `info_kind` (un'ipotesi ora confermata diventa `fact`);
    - brief (`README.md`): "Cosa sappiamo / ipotizziamo / non sappiamo",
      "Chi è coinvolto", "Cosa chiediamo, a chi, e quando", esempi;
    - PRD in `draft`/`in_review`: le sezioni toccate (Scenario, What,
      Rischi, Metriche, Provenienza — "deciso/riferito da {chi}, {data}");
      un PRD `approved` non si tocca senza richiesta esplicita;
    - `measurement*.yaml`: baseline/target **solo** da un `fact` o da una
      stima verificata — mai da un `illustrative`;
    - RICE: se una risposta cambia Reach/Impact/Confidence/Entanglement,
      **non** toccare `rice_history`: proponi `rice-update` con la
      risposta come evidenza (va in `pending/`);
    - `deadline`: una scadenza dichiarata dallo stakeholder si cattura
      (conferma del PM); per un mandate dopo la creazione, proposta
      `mandate_update` in `pending/`;
    - glossario: termini nuovi, alla conferma del PM;
    - `context/`: un'informazione di contesto aziendale nuova o in
      contrasto → richiama `context-intake` (conferma esplicita);
    - identikit: un comportamento osservato nell'incontro (cosa ha
      funzionato, come ha reagito a una domanda) → proponilo come episodio
      a `stakeholder-profile`, solo su conferma; mai giudizi;
    - Why in conflitto con la strategia (Preliminary): **segnalalo come
      possibile abort** — la decisione resta del PM (playbook, "Preliminary
      analysis").
    Il PM conferma il piano (anche in parte): è una conferma unica, non
    una per riga.

12. **Applica**: registro (`answer`, `status`, `propagated_to`,
    `new_questions`), voce `meetings` (`status: ingested`, `held_at`,
    `source_ref`, `ingested_at`), sezione **Esito** della guida, e le
    scritture dirette confermate. Se l'incontro era il meeting di
    approfondimento pre-RICE, scrivi `rice_status.deep_dive.done_at` e
    proponi subito `rice-update`. Per le proposte (`rice-update`,
    `mandate_update`) richiama le skill relative. Poi
    `bash .claude/hooks/governance-sync.sh push "discovery-questions: recepito <M-..> <slug>" product/ideas/ product/prds/ product/reference/glossary.yaml product/approvals/pending/`.

13. **Raccomanda il prossimo passo**, sempre: le domande ancora `open`
    per priorità, con chi andrebbero poste e se conviene un altro
    incontro (prepara subito la guida se il PM vuole). Se non restano
    domande `blocking` per la fase, dillo: è il segnale che la fase può
    chiudersi (brief `stage: complete`, PRD verso `in_review`, RICE
    quotabile).

### Modalità `stato`

14. Sola lettura, senza `pull` se già fatto in sessione. Per l'idea
    indicata, o per tutte le idee attive (`bash
    .claude/hooks/governance-dump.sh discovery` — idee, registri delle
    domande, piano di iterazione corrente, identikit): domande `blocking`
    aperte, incontri `prepared` non ancora tenuti (con `planned_for`),
    incontri `held` non ancora recepiti, inviti `drafted` non mandati, e
    idee in analisi **senza registro** (da preparare). Prima colonna
    l'identificatore dell'idea (`short_ref` o slug), poi `summary`.

## Riepilogo finale

- fase, interlocutori, guida scritta (percorso) o risposte recepite;
- domande: N nuove, M risposte, K ancora aperte (di cui `blocking`);
- lacune scartate perché la risposta non cambierebbe nulla;
- propagazioni fatte e proposte in `pending/`;
- contraddizioni emerse e decisioni che spettano al PM;
- azioni aperte del PM: fissare l'incontro, mandare l'invito, recuperare
  la trascrizione, chi altro sentire.
