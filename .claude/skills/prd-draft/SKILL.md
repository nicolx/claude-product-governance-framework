---
name: prd-draft
description: Redige il brief d'iniziativa e i PRD "A3-sized" di un'idea già prioritizzata, scritti per il loro lettore (design, tech, Finance/Legal, stakeholder — persone o agenti senza il contesto della sessione). Parte dal registro dei punti chiave della fonte, intervista il PM sugli aspetti di prodotto, verifica la copertura (nessun punto perso in silenzio) e collauda i documenti con una lettura a freddo. Legge apps/ e context/, scaffolda measurement*.yaml, non duplica mai il RICE. Anche in modalità retrofit su PRD esistenti.
---

# prd-draft

Redige gli artefatti di specifica di un'idea già passata da Ideas Prioritization:
il **brief d'iniziativa** (la storia, una volta sola, per tutti), uno o più **PRD**
(ciascuno scritto per il suo lettore) e, per un PoC, un **allegato dati**. Applica
l'A3 Thinking del playbook ("Complete analysis" → "PRD sizing") e i principi di
"Scrivere per il lettore: dalla fonte all'artefatto" — **leggi quella sezione prima
di iniziare**.

Il criterio di successo non è "il PRD è completo", ma: **chi lo riceve, senza aver
partecipato a nessuna conversazione, può lavorarci senza tornare a chiedere.** Il
lettore può essere una persona o un agente (es. un Claude di design o di sviluppo)
che non ha questa sessione, la memoria locale né l'accesso a `context/`.

## Prerequisiti

L'idea deve avere almeno una voce in `rice_history` (score approvato,
quindi presente in `product/ideas/{slug}/idea.yaml`, non solo in
`approvals/pending/`). Se non ce l'ha, segnalalo e proponi di passare
prima da `rice-update`.

Se non esiste ancora un brief (`product/prds/{slug}/README.md`), è normale: lo
scrive questa skill (passo 5). Se la Preliminary analysis ne ha già prodotto una
bozza (`stage: preliminary`), parti da quella.

## Il differenziale di questo framework: leggere la codebase reale (e il contesto aziendale)

Se l'istanza ha repository applicativi collegati in `apps/` (submodule),
**leggili prima di scrivere l'How** — non limitarti a chiedere all'utente
come funziona il sistema se puoi verificarlo tu stesso nel codice. Questo
è il differenziale esplicito rispetto a un tool di roadmap tradizionale:
le implicazioni tecniche vanno considerate fin dall'authoring, non
scoperte dopo. Se `apps/` è vuota o non pertinente al tema del PRD, procedi
normalmente senza bloccarti.

Prima di leggerli, **portali all'ultima versione**:
`bash .claude/hooks/governance-sync.sh apps` (vedi playbook,
"Sincronizzazione dell'istanza (`origin`)", sottosezione "Codice
applicativo (`apps/`)"). I submodule restano altrimenti fermi al commit
registrato all'init, e un How scritto su codice vecchio descrive un
sistema che non esiste più. L'helper non blocca mai: un'app non
aggiornata (modifiche locali, fetch fallito) va riportata tra le azioni
aperte del riepilogo (passo 14), perché l'How su quell'app potrebbe non
essere attuale. Vale anche in dry-run e in retrofit.

Allo stesso modo, se `context/` (radice del repository, vedi playbook
sezione "Contesto aziendale") ha file rilevanti per il Why/Who di questa
idea — modello di business, dati di mercato, organizzazione, normativa —
leggili prima di scrivere, invece di chiedere all'utente cose che sono già
documentate. **Nei documenti, i fatti presi da `context/` si riportano in
sintesi, non si linkano** (il lettore non ha `context/`, principio P7). Se
durante la lettura di `source/` o del codice emerge un'informazione di
contesto aziendale (non di prodotto) che sembra nuova o in contrasto con
`context/`, **non aggiornarlo da solo**: segnala il candidato e richiama
`context-intake`, che propone la modifica e la scrive solo dopo conferma
esplicita del PM.

Cerca anche i **precedenti** dentro l'istanza: mockup, prototipi, PRD di
iniziative vicine, materiale in `source/` di altre idee collegate. Un
precedente non citato è il modo più rapido per far reinventare (male) qualcosa
che esiste già. Se è visivo, copialo in `assets/` (passo 6).

## Passi

> **Dry-run.** Se la skill è stata invocata in modalità simulazione
> (argomento `dry-run`, o `dry_run: true` in `.governance/config.yaml`),
> applica il contratto della sezione "Modalità dry-run (simulazione)" del
> playbook: esegui letture, analisi e anche la lettura a freddo
> normalmente, **non** creare né modificare file sotto `product/` (brief,
> PRD, allegati, `assets/`, `measurement*.yaml`, `.reviews/`, registro dei
> punti chiave, registro delle domande, glossario), **non** invocare
> `governance-sync.sh push`, mostra come testo il contenuto completo che
> avresti scritto, e chiudi con
> `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push.`

> **Retrofit.** Con l'argomento `retrofit` la skill lavora su PRD già
> esistenti: genera il registro dei punti chiave se manca (passo 2), scrive
> il brief se manca, esegue copertura e lettura a freddo (passi 9-11) e
> **propone** le correzioni ai PRD — le applica solo alla conferma del PM.
> Non tocca PRD `approved`/`superseded` senza richiesta esplicita.

1. **Leggi** `product/ideas/{slug}/idea.yaml` (contesto, `notes`, ultima voce
   di `rice_history` per capire cosa è stato valutato), **tutto** il materiale
   in `source/`, i file di `context/` pertinenti, ed eventuali analisi già
   registrate (es. in `product/ceremonies/` o note fornite dall'utente) — non
   ripartire da zero se l'analisi è già stata fatta a voce.

2. **Registro dei punti chiave** (`product/ideas/{slug}/source/key-points.yaml`,
   schema `framework/schema/key-points.template.yaml`). Se esiste, caricalo.
   Se manca e la fonte è ricca (trascrizione, workshop, thread a più voci,
   oltre ~400 parole), **generalo ora** con la stessa logica di `idea-intake`.
   È la base delle verifiche dei passi 9 e 11: senza registro non si può
   dimostrare che nessun punto è stato perso.

3. **Intervista di prodotto.** Accanto alle domande di governance (split,
   `data_source`, finestre, `tech_reference`), chiedi al PM **solo ciò che non
   è ricavabile** da fonte, registro, `context/` o `apps/`:
   - **chi riceverà ciascun documento** (persone? agenti? con o senza accesso
     al repository?) → `primary_reader` di ogni PRD;
   - se si vuole **imparare** (PoC, prototipo → `prd_kind: discovery`) o
     **rilasciare** (`delivery`);
   - **scenario d'uso**: chi, in quale momento, cosa fa con il risultato, cosa
     deve succedere dopo;
   - **destinatari indiretti**: chi va convinto o riceve l'output senza usare
     il prodotto;
   - per un `discovery`: a chi verrà mostrato, e quale decisione deve
     permettere.
   Non presumere mai le risposte: il lettore cambia cosa va scritto.
   **Con metodo socratico** (playbook, "Discovery socratica: le domande
   agli stakeholder", regola 8): quando il PM dà una stima, un'ipotesi o
   una soluzione già decisa, chiedi una volta l'evidenza, l'assunzione o
   la conseguenza osservabile ("come ce ne accorgeremmo che ha
   funzionato?"), dicendo perché. Ciò che il PM **non sa** e che solo uno
   stakeholder può dire non si inventa e non blocca la stesura: diventa
   una domanda del registro (passo 3b).

3b. **Domande per gli stakeholder.** Carica il registro
   `product/ideas/{slug}/discovery/questions.yaml` (se manca, crealo da
   `framework/schema/discovery-questions.template.yaml`). Se ha incontri
   `held` non ancora `ingested`, **recepiscili prima di scrivere**
   (`discovery-questions` modalità `recepisci`): scrivere un PRD
   ignorando risposte già avute è il modo più rapido di perderle. Poi
   applica la logica di `discovery-questions` (modalità `prepara`, passi
   3-5, fase `complete`) alle lacune che restano — dal registro dei punti
   chiave, dal brief, dall'intervista — e mostrale al PM per
   interlocutore. Le domande `blocking` ancora aperte si dichiarano nel
   brief ("Cosa non sappiamo", "Cosa chiediamo, a chi, e quando") e nei
   Rischi del PRD; non si colmano con un'ipotesi presentata come fatto.

4. **Piano dei documenti, da far confermare al PM prima di scrivere:**
   - **brief** (`README.md`): obbligatorio se i PRD saranno più di uno o se un
     PRD ha `primary_reader` diverso da `pm`/`stakeholder`;
   - **PRD**, uno per cucitura del problema: rischio tecnico, owner,
     stakeholder **o lettore** distinti. Esempio tipico per un PoC: un PRD di
     esperienza per il design e uno di costruzione per lo sviluppo. Motiva
     esplicitamente il criterio di split;
   - **allegato dati** (`allegato-{lettera}-{sub-slug}.md`, template
     `framework/schema/prd-annex.template.md`): per ogni PRD `discovery` con
     dati dimostrativi, comune ai PRD che lo usano;
   - **`assets/`**: per i materiali visivi di riferimento.

5. **Scrivi il brief** (`framework/schema/initiative-brief.template.md`): la
   storia in un minuto, chi è coinvolto e quando, come produce valore, da dove
   partiamo, esempi (marcati illustrativi), cosa sappiamo/ipotizziamo/non
   sappiamo, **cosa chiediamo, a chi e quando**, vincoli, parole che usiamo,
   mappa dei documenti. Gli esempi della fonte con numeri **si usano** come
   narrativa, marcati "illustrativi" (P4) — non si scartano e non diventano
   mai stime.

6. **Scrivi i PRD** secondo `framework/schema/prd.template.md`:
   - sezioni secondo `prd_kind`: `discovery` → *Cosa vogliamo imparare*
     (ipotesi, segnali di conferma/smentita in forma di comportamenti, varianti,
     protocollo di feedback, decisione attesa) al posto di *Metriche*;
     `delivery` → *Metriche*;
   - evidenza secondo `primary_reader` (tabella in fondo al template); per
     `design` aggiungi *Vincoli di design*;
   - **Scenario** sempre, **Provenienza** sempre (dalla fonte / aggiunto
     dall'analisi / deciso dal PM, con data);
   - **portabilità (P7)**: nessun "come detto in call", nessun percorso locale,
     nessun id interno non spiegato (eccezione: codice e ticket nei PRD `tech`);
   - **vincolo dimensionale attivo**: se un PRD supera ~2 facciate A4,
     **fermati e proponi lo split** lungo le cuciture — non comprimere la prosa.
     Il contesto in più va nel brief, i dati nell'allegato;
   - allegato: definizioni prima dei dati, dati in unità assolute, parametri in
     un posto solo, **risultati attesi espliciti** (diventano criteri di
     accettazione), testi pronti, regole di arrotondamento. **Ricalcola tu
     stesso ogni numero derivato** prima di scriverlo;
   - copia in `assets/` i materiali visivi di riferimento trovati (mockup,
     schermate); elenca come azione aperta del PM quelli che mancano;
   - se più PRD: compila `reading_sequence` e `release_sequence`
     **separatamente** — l'ordine di lettura non coincide per forza con quello
     di rilascio.

7. **Scaffolda `measurement-N.yaml`** per ogni PRD (stessa numerazione del
   file `prd-N-*.md`), da `framework/schema/measurement.template.yaml`.
   - **Caso normale** (`delivery` con KPI): una voce in `kpis` per ciascuna
     metrica della sezione Metriche (stesso `name`, `baseline`, `target`,
     `unit`). Non è una duplicazione: il PRD resta la fonte narrativa,
     `measurement` la sua forma strutturata per `measurement-watch`. Chiedi
     (non presumere) `measurement_window_weeks` se l'aspettativa è diversa dal
     default. **KPI con finestre diverse** (es. metriche anticipatorie a poche
     settimane e metrica principale a un anno): un file per finestra,
     `measurement-N-{suffisso}.yaml` — `measurement-watch` li legge tutti; il
     file senza suffisso è la valutazione complessiva, e la sua `closure`
     chiude l'iniziativa.
   - **Per ciascuna KPI, chiedi esplicitamente `data_source`**: "come
     pensi di recuperare questo dato — lo controlli tu (manuale), o
     l'istanza ha un'integrazione che può leggerlo in autonomia
     (automatizzata)?" Non presumere mai la risposta, e non default a
     "automated" solo perché sembra la scelta più moderna — è una
     decisione del PM, va scritta nella sezione Metriche del PRD stesso
     (non solo in `measurement.yaml`) prima di procedere. Se risponde
     "automatizzata" ma l'istanza non ha ancora un'integrazione
     configurata (il caso comune oggi — vedi
     `framework/docs/future-work.md`), scrivi comunque `mode: automated`
     come intento dichiarato: `measurement-watch` si comporterà come
     manuale finché quell'integrazione non esiste davvero, senza
     bloccare la stesura del PRD per questo.
   - **Path da monitorare** (solo con `metrics.configured: true`, non
     `manuale`, e `metrics.paths.enabled` non `false`). Prima di scrivere la
     sezione *Metriche*, riesegui inline la logica di `path-watch` (passi
     1-5) sull'idea, questa volta contro l'How reale del PRD: i path già
     applicati all'intake si rifiniscono, quelli nuovi si **applicano
     direttamente** su `idea.yaml` (nessuna conferma — playbook,
     "Measurement", "Path da monitorare"). Poi:
     - per ogni KPI, **proponi** il path `active` che la misura (e la sua
       baseline come `baseline` della KPI); se il PM conferma, scrivi
       `data_source.path_ref` e dichiaralo nella sezione *Metriche* — il
       legame KPI→path resta una scelta sua, come `mode`;
     - ogni path `to_instrument` diventa un **requisito di tracciamento**
       nel PRD (eventi mancanti, nome atteso, dove nel codice), da
       consegnare con la feature: senza, la misurazione partirà senza
       baseline. Mettilo anche tra le azioni aperte del riepilogo;
     - se il connettore è giù, i path restano quelli dell'intake e il
       giro è **rimandato** nel riepilogo — non bloccare la stesura.
   - **Senza KPI di business** (compliance, oppure `discovery`, oppure un PRD
     di costruzione o di modello che abilita le KPI di un altro PRD): **non
     forzare una metrica proxy**. Scrivi il motivo nel PRD, lascia `kpis: []`
     e compila `not_applicable_reason`. Resta comunque da chiudere
     esplicitamente più avanti (`measurement-watch`, blocco `closure`).

8. **Non ripetere il RICE e non ridescrivere framework generali.** Nel PRD va
   solo `idea_id`. Se emerge che il RICE andrebbe rivisto, segnalalo e proponi
   `rice-update`. Il divieto riguarda i *framework* (Business Model Canvas,
   GTM generico, glossario completo): **il contesto specifico dell'iniziativa
   invece va raccontato**, nel brief.

9. **Copertura.** Per ogni punto `open` del registro:
   - associalo a una sezione del brief, di un PRD o dell'allegato
     (`status: covered`, `covered_by`);
   - oppure proponi l'esclusione con un motivo e **fai confermare al PM in
     conversazione** (`status: excluded`, `exclusion_reason`).
   A fine stesura **nessun punto resta `open`**. Aggiungi al registro i punti
   nati dall'analisi o dalle decisioni del PM, dichiarandone la provenienza.
   Scrittura diretta (registro del lavoro fatto, non decisione di priorità).

10. **Glossario.** Elenca i termini di dominio e le sigle usati nei documenti
    che non sono né in `product/reference/glossary.yaml` né nella sezione
    "Parole che usiamo" del brief. Proponi le definizioni al PM e, alla
    conferma, scrivile in entrambi (scrittura diretta). Se il glossario non
    esiste, crealo da `framework/schema/glossary.template.yaml`.

11. **Lettura a freddo** (prompt e procedura in
    `framework/prompts/cold-read.md`). Lancia in parallelo lettori simulati a
    contesto vergine, ciascuno con i soli documenti del suo ruolo, in un
    pacchetto isolato fuori dal repository: almeno il `primary_reader` di
    ogni PRD; per un'iniziativa con brief, anche uno *stakeholder* sul solo
    brief; il lettore *tech* **ricalcola i numeri**. Poi:
    - classifica i rilievi (lacuna, fraintendimento, incoerenza, **decisione
      del PM**, ipotesi accettabile);
    - **porta al PM le decisioni** prima di correggere — una lettura a freddo
      fa emergere scelte che solo lui può fare (scope, termini di paragone,
      liceità, date), non solo refusi;
    - le lacune che **né il PM né i documenti** possono chiudere (un dato,
      un vincolo, un'approvazione che ha uno stakeholder) diventano
      domande del registro, fase `prd_review`, con `gap_ref` alla lettura
      a freddo e l'interlocutore;
    - correggi, poi seconda iterazione (massimo 2);
    - registra ogni iterazione in
      `product/prds/{slug}/.reviews/cold-read-{YYYY-MM-DD}-iterazione-{N}.md`.
    Se i subagent non sono disponibili, dillo e proponi una lettura a freddo
    umana: **mai saltata in silenzio**. Lo `status: in_review` si raggiunge
    solo dopo almeno una lettura a freddo, con la copertura completa e
    senza domande `blocking` aperte nel registro — o con quelle rimaste
    accettate esplicitamente dal PM come rischio dichiarato nel PRD.

12. **Aggiorna `idea.yaml`**: aggiungi lo slug della cartella PRD a
    `links.prd_ids`, valuta `status: in_prd`, e aggiungi in `notes` una riga
    su cosa è stato prodotto. È un aggiornamento di metadato, non un diff di
    RICE: applicalo direttamente e segnalalo nel riepilogo (se l'istanza lo
    tratta come soggetto ad approvazione, passa da `product/approvals/pending/`).

13. **Assegna il referente tecnico (`tech_reference`).** Se
    `product/reference/team.yaml` esiste ed ha membri, esegui **dentro la
    stesura** la logica di `team-fit` (leggi il playbook, "Team di
    sviluppo, referente tecnico e staffing di un PRD"): incrocia i sistemi
    toccati nell'How, i rischi aperti e il dominio dell'idea con `apps` e
    `skills` di ogni membro, e produci la shortlist ordinata con
    motivazione puntuale.
    - Parti dall'eventuale `idea.tech_reference` (ipotesi posta
      all'intake) come proposta di partenza, poi rivedila contro l'How
      reale.
    - **Proponi il candidato di testa come `tech_reference` e fallo
      confermare al PM** — è una persona, si conferma in conversazione
      (come `deadline`), non si scrive in silenzio; ma non è
      un'assegnazione di implementazione (quella è di Iteration Planning).
    - Alla conferma, scrivi:
      1. `tech_reference` nel frontmatter del PRD (per un'iniziativa
         spaccata in più PRD, uno per PRD — possono differire);
      2. la riga di chiusura della sezione *How*: `_Validare l'How con:
         {nome} ({motivo}). Shortlist completa: `team-fit {slug}`._`;
      3. il denormalizzato `tech_reference` su `product/ideas/{slug}/idea.yaml`
         (il PRD primario) — puntatore per viste e cerimonie, scrittura
         diretta senza approvazione (stessa logica di `links.prd_ids`).
    - Se `team.yaml` manca o è vuoto: lascia `tech_reference: ""` nel
      frontmatter, scrivilo chiaramente nel riepilogo come gap, e rimanda
      a `team-roster`.
    - Se nessun membro copre bene i sistemi/rischi del PRD: dillo
      esplicitamente (è un segnale — supporto esterno, upskilling), non
      forzare un nome debole.
    - **Stima grezza di delivery** (playbook, "Capacità del team e slot
      della roadmap"): se `team.yaml` ha un catalogo `competencies`,
      chiedi al PM — che la raccoglie dal referente tecnico appena
      confermato, mai inventata da te — `effort_by_competency` in
      persona-settimane e `estimated_effort_weeks` di durata. Scrivila sul
      blocco `delivery` di `idea.yaml` con `estimate_basis: rough` e
      `estimated_at` (scrittura diretta, come le stime di Iteration
      Planning); se c'è già una stima `committed`, non toccarla. Serve a
      collocare l'iniziativa nello `slot_plan` del trimestre prima che
      entri in iterazione; senza, resta "non dimensionata". Se il
      referente non è disponibile ora, lascia i campi vuoti e mettilo
      tra le azioni aperte del PM — non bloccare il PRD.

14. **Riepilogo finale**, oltre alle scritture fatte:
    - documenti prodotti, ciascuno con il suo lettore;
    - copertura: N punti, X coperti, Y esclusi (con motivo);
    - esito delle letture a freddo: lacune trovate e corrette, domande
      residue accettate, "potrebbe iniziare domani?" per ciascun lettore;
    - **cosa hai aggiunto rispetto alla fonte** (P5) e quali decisioni ha
      preso il PM;
    - **domande per gli stakeholder** (sempre, anche se nessuna è
      bloccante): aperte per interlocutore con la loro priorità, e il
      prossimo incontro raccomandato — offri di preparare subito la guida
      (`discovery-questions`);
    - **azioni aperte del PM** (materiali da allegare, date, verifiche,
      eventi da strumentare per i path `to_instrument`);
    - path da monitorare applicati/rifiniti e KPI legate a un path;
    - su quale commit di ogni app pertinente si basa l'How, e le app che
      `governance-sync.sh apps` non è riuscito ad aggiornare.

15. **Sincronizza il repo**: esegui
    `bash .claude/hooks/governance-sync.sh push "prd-draft: PRD <slug>" product/prds/ product/ideas/ product/reference/glossary.yaml product/reference/product-lines.yaml`
    (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se l'helper
    segnala un push fallito, riferiscilo nel riepilogo finale.
