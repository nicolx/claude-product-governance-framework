---
name: prd-review-panel
description: Valida i PRD di un'iniziativa con un panel di agenti dalle personalità diverse — il revisore IT che controlla l'How contro il codice reale di apps/, il business scettico che chiede l'evidenza e confronta il PRD con le ipotesi del RICE, e secondo i segnali la voce dell'utente, sicurezza/privacy, lo scettico della misura, esercizio e supporto, finanza, l'avvocato del diavolo (pre-mortem), la lente di uno stakeholder che deve dire sì. Ogni personaggio dà un verdetto e rilievi con gravità; la skill li verifica, fa emergere le tensioni tra personaggi, porta al PM le decisioni e registra l'esito in .reviews/. Advisory: non approva né boccia, ma nessun PRD passa a in_review con un blocker aperto. prd-draft la esegue già dentro la stesura, dopo la lettura a freddo; usala a mano per rivalidare un PRD cambiato, prima di un'approvazione, o per configurare i personaggi dell'istanza (setup).
---

# prd-review-panel

Risponde a "**questo PRD regge davanti a chi dovrà approvarlo, costruirlo,
esercirlo?**" facendolo attaccare, prima della revisione umana, da agenti
con personalità e mestieri diversi. Procedura, catalogo dei personaggi e
prompt sono in `framework/prompts/review-panel.md` — **leggilo prima di
iniziare**, insieme al playbook, "Scrivere per il lettore: dalla fonte
all'artefatto" (sottosezioni "La lettura a freddo", "Il panel di
revisione", "Gate di stato del PRD").

`prd-draft` esegue già questa logica dentro la stesura (passo 11b),
**dopo** la lettura a freddo — non serve rilanciarla subito dopo. Usala
quando: il PRD è cambiato in modo sostanziale, prima di un'approvazione
(`in_review → approved`), su un PRD scritto fuori dal framework
(insieme a `prd-draft retrofit`), o per gestire i personaggi dell'istanza.

## Cosa scrive (e cosa no)

È **advisory**: il panel consiglia, il PM decide. Non approva né boccia un
PRD, non crea voci in `product/approvals/pending/`, non compie azioni in
uscita. Scrive, con scrittura diretta:

- `product/prds/{slug}/.reviews/panel-{YYYY-MM-DD}-iterazione-{N}.md` —
  l'esito (fatto osservato, come le letture a freddo);
- le **correzioni** ai PRD/brief e i **rischi accettati** nella sezione
  *Rischi* — **solo dopo** che il PM ha deciso sui rilievi che lo
  richiedono;
- le **domande per gli stakeholder** nel registro
  `product/ideas/{slug}/discovery/questions.yaml` (fase `prd_review`);
- in modalità `setup`, `product/reference/review-personas.yaml`, su
  richiesta esplicita del PM.

Un rilievo che tocca il RICE **non** si risolve qui: si propone
`rice-update`, che passa da `pending/`.

## Prerequisiti

- Un PRD in `product/prds/{slug}/` (`draft` o `in_review`; su un
  `approved`/`superseded` solo su richiesta esplicita, e senza toccarne il
  testo: il panel produce solo il file in `.reviews/`).
- Meglio se è già passato da una lettura a freddo: se in `.reviews/` non
  ce n'è nessuna, dillo e proponi di farla prima (un testo che non si
  capisce produce rilievi duplicati). Il PM può chiedere di procedere
  comunque.

## Passi

> **Dry-run.** Se invocata con `dry-run` (o `dry_run: true` in
> `.governance/config.yaml`): esegui il panel normalmente (è lettura e
> analisi), mostra la sintesi e le correzioni che *proporresti*, **non**
> scrivere `.reviews/`, PRD, brief, registro delle domande o
> `review-personas.yaml`, **non** fare commit/push, chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`

1. **Sincronizza e leggi.** `bash .claude/hooks/governance-sync.sh pull`,
   poi `bash .claude/hooks/governance-sync.sh apps` (il revisore IT legge
   il codice: su submodule vecchi giudica un sistema che non esiste più —
   le app non aggiornate vanno nel riepilogo). Leggi:
   - tutti i `prd*.md` della cartella, il brief (`README.md`), gli
     allegati, `measurement*.yaml`;
   - `idea.yaml` dell'`idea_id` (classification, ultima voce di
     `rice_history`, `delivery`, `monitoring`, `tech_reference`);
   - `.reviews/` esistenti (letture a freddo e panel precedenti: non
     riproporre rilievi già decisi dal PM, salvo che il testo sia
     cambiato);
   - `product/reference/review-personas.yaml` se esiste;
   - `product/reference/stakeholders.yaml` (solo per scegliere ed
     eventualmente costruire una lente di stakeholder);
   - `.governance/config.yaml` `apps[]`.
   **Mai** `.governance/stakeholder-relationships.local.yaml`: il rapporto
   individuale non entra nel panel.

2. **Componi il panel** secondo la regola di selezione del prompt:
   sempre `it-reviewer` e `business-skeptic`, gli altri per segnale, più i
   personaggi d'istanza, meno i `disabled`, entro `max_personas`. Mostra
   al PM il panel con **una riga di perché** per ciascuno e cosa riceve,
   e lascialo aggiungere o togliere. Se il PM ha già indicato i
   personaggi nell'argomento (`personas=it-reviewer,finance`), usa quelli.
   Senza `apps/` pertinenti, dillo: il revisore IT lavora solo sui
   documenti e i suoi rilievi sull'How valgono meno.

3. **Prepara i pacchetti e lancia in parallelo** i personaggi (prompt,
   pacchetti isolati e tipo di agente come da
   `framework/prompts/review-panel.md`). Se i subagent non sono
   disponibili, dillo e proponi il panel umano del fallback: **mai
   saltato in silenzio**.

4. **Sintetizza**: deduplica, verifica i rilievi di fatto (nel codice, nei
   documenti), fai emergere le tensioni tra personaggi, classifica ogni
   rilievo (correzione / decisione del PM / domanda per uno stakeholder /
   da validare con il `tech_reference` / segnale sul RICE / rischio
   accettato / respinto). Presenta al PM:
   - una riga per personaggio: verdetto e motivo principale;
   - i **blocker** e le **tensioni** per primi, ciascuno con le opzioni e
     una raccomandazione;
   - poi i `major`, poi i `minor` in forma compatta;
   - ogni riga indirizzabile (`P-01`, `P-02`…) così il PM può rispondere
     "P-03 accetto il rischio, P-05 respingo perché…".
   Con metodo socratico (playbook, "Discovery socratica", regola 8):
   quando il PM respinge un `blocker`, chiedi una volta su quale evidenza,
   e registra la risposta come motivo.

5. **Applica le decisioni.**
   - correzioni ai documenti — mostrale prima, applicale alla conferma;
     in un PRD, ciò che il panel ha fatto aggiungere va nella sezione
     *Provenienza* ("aggiunto dall'analisi: … emerso dal panel di
     revisione");
   - rischi accettati nella sezione *Rischi e dipendenze aperte*, con il
     segnale che li farebbe riaprire;
   - domande per gli stakeholder nel registro (fase `prd_review`,
     `gap_ref: "panel {data}-iterazione-{N} · {persona}"`, `ask_to` dal
     rilievo), con la logica di `discovery-questions`;
   - segnali sul RICE: proponi di lanciare `rice-update` con l'evidenza
     del rilievo;
   - obiezioni da validare con il `tech_reference`: elencale in testa al
     file del panel come scaletta per la revisione dell'How.

6. **Seconda iterazione** (al massimo 2), solo con i personaggi che
   avevano `blocker` o `no_go`, sul testo corretto. Se alla seconda un
   `blocker` resta e il PM non lo accetta né lo respinge, il PRD resta
   `draft`: dillo chiaramente.

7. **Registra** ogni iterazione in
   `product/prds/{slug}/.reviews/panel-{YYYY-MM-DD}-iterazione-{N}.md`
   (contenuto come da prompt). Il file entra nel repository tracciato:
   le obiezioni di una lente di stakeholder si scrivono come "obiezioni
   prevedibili dalla lente di {ruolo}", sulla sostanza.

8. **Riepilogo**: panel e verdetti; blocker e come sono stati chiusi;
   tensioni e decisioni del PM; `major` aperti; domande create e a chi;
   proposte di `rice-update`; scaletta per il `tech_reference`; se il PRD
   può passare a `in_review` (gate) o cosa manca. Lo `status` del PRD lo
   cambia `prd-draft` o il PM: questa skill dice solo se il gate del panel
   è soddisfatto.

9. **Sincronizza il repo**:
   `bash .claude/hooks/governance-sync.sh push "prd-review-panel: <slug> iterazione <N>" product/prds/ product/ideas/`
   (aggiungi `product/reference/review-personas.yaml` in setup).

## Modalità `setup`: i personaggi dell'istanza

Con l'argomento `setup` (o una richiesta come "aggiungi un revisore di
compliance bancaria", "qui il personaggio esercizio non serve"):

- **aggiungere** un personaggio: chiedi personalità, focus, materiali che
  riceve e quando entra nel panel (schema
  `framework/schema/review-personas.template.yaml`); se specializza uno
  del framework, usa `extends: framework:<id>`. Un personaggio è un punto
  di vista professionale, **mai** una persona reale: per uno stakeholder
  specifico c'è la lente `stakeholder-lens:{id}`, dall'identikit;
- **disattivare** un personaggio del framework: serve un motivo del PM;
  `it-reviewer` e `business-skeptic` non si disattivano (si possono
  specializzare con `extends`);
- **cambiare** `max_personas`.
Crea il file al primo uso, mostra il diff, scrivi alla conferma, poi
push.

## Cosa NON fare

- Non cambiare lo `status` del PRD e non trattare un `go` come
  approvazione o un `no_go` come veto.
- Non correggere i documenti prima che il PM abbia deciso sui rilievi che
  lo richiedono; non "far tornare" il PRD con il RICE: si propone
  `rice-update`.
- Non passare ai personaggi il rapporto individuale del PM, il registro
  delle domande, i `.reviews/` o file `.local.*`; non usare tratti
  `hypothesis` per costruire una lente.
- Non registrare obiezioni attribuite a una persona reale ("Mario dirà"),
  né imitazioni del suo modo di fare.
- Non presentare come fatto un rilievo del revisore IT sul codice senza
  averlo verificato: o lo verifichi, o è "da validare con il
  `tech_reference`".
