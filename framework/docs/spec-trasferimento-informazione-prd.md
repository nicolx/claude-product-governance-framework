# Specifica — Trasferimento dell'informazione dalla fonte agli artefatti (PRD e dintorni)

**Stato:** implementata (PR "feat: scrivere per il lettore"), dopo un collaudo manuale su un caso reale (§10). Resta come documento di progetto: il testo normativo è nel playbook, sezione "Scrivere per il lettore: dalla fonte all'artefatto".
**Origine:** retrospettiva su un caso reale di un'istanza, qui anonimizzato (§1).
**Destinatario:** chi implementa le modifiche al framework (PM o agente nel repo canonico).
**Impatto sulle istanze:** non breaking. Tutti i campi nuovi sono opzionali e la migrazione
dei PRD esistenti è facoltativa (§7).

---

## 1. Il caso che ha fatto emergere il problema

Una call di ideazione di circa 15 minuti tra due persone (trascrizione Teams) contiene
un'idea ricca di storytelling:

- **il problema**, raccontato con una storia personale: un dipendente che chiede l'aumento
  in welfare invece che in RAL;
- **una catena di valore**: bisogni espressi dagli utenti a un assistente AI → soluzioni
  trovate in piattaforma → risparmio stimato per il cliente aziendale → ROI → più budget
  caricato;
- **esempi concreti**, con numeri esplicitamente illustrativi;
- **due destinatari indiretti**: il CFO del cliente, che va convinto, e i prospect, che
  non hanno ancora dati;
- **una richiesta esplicita**: un proof of concept da mostrare in giro.

Il workflow (`inbox-triage` → `rice-update` → `pending-approval` → `prd-draft`) ha
prodotto:

- un'idea corretta, con la trascrizione integra in `source/` e note dettagliate;
- tre PRD formalmente ineccepibili: split motivato, rischi legali intercettati in anticipo,
  How ancorato al codice, metriche a più livelli.

Alla rilettura il PM ha giudicato i PRD **non interpretabili da chi non ha sentito la call**.
Un designer che riceve il PRD del PoC produrrebbe una dashboard di analytics generica:

- l'assistente AI che genera i dati non era mai nominato nel PRD;
- la storia era ridotta a un elenco di tre "livelli" equivalenti, invece di un racconto con
  una conclusione;
- il momento d'uso (l'HR che deve convincere il CFO) e lo scenario dei prospect senza dati
  erano spariti;
- gli esempi illustrativi erano stati eliminati insieme ai numeri, perché "non usabili come
  stime";
- il PRD di discovery non diceva cosa si volesse imparare, né quali varianti prototipare;
- i testi rimandavano alla "call" come se il lettore l'avesse sentita.

## 2. Diagnosi

**L'informazione non si è persa, non è arrivata al lettore.** Fonte, note e contesto erano
tutti conservati. In tutta la catena manca un passaggio che chieda: *chi legge questo
artefatto, cosa gli serve, e lo capisce?*

Le cause sono strutturali, non di esecuzione:

| # | Causa | Dove sta nel framework |
|---|---|---|
| C1 | Il template spinge la narrativa fuori dal PRD. Il Why chiede "poche righe", il Who è "solo se rilevante", e il ragionamento "resta nell'idea" — cioè in `idea.yaml`, che il lettore finale non apre mai. | `prd.template.md`, playbook "PRD sizing" |
| C2 | `prd-draft` verifica solo la governance. Le domande obbligatorie riguardano split, `data_source`, finestre e `tech_reference`; nessuna riguarda il lettore, lo scenario d'uso o cosa succede dopo. Quello che il processo verifica è quello che viene prodotto. | `prd-draft` passi 3-10 |
| C3 | Nessuna verifica di copertura. Niente confronta i contenuti della fonte con gli artefatti, quindi un punto può sparire in silenzio. | assente |
| C4 | Nessuna tassonomia del tipo di informazione. Le regole garantiste ("non inventare numeri") sono solide, ma non distinguono un fatto, una stima, un esempio illustrativo, una visione, una citazione. La conseguenza è un eccesso di zelo: l'esempio viene eliminato invece di essere marcato come tale. | playbook, `idea-intake`, `inbox-triage` |
| C5 | Preliminary e Complete analysis non producono un artefatto, solo una checklist. Si può passare da intake a PRD senza che la storia venga mai scritta per qualcuno. | playbook "Preliminary analysis" / "Complete analysis" |

## 3. Principi nuovi (da aggiungere al playbook)

Da inserire come sottosezione di "Complete analysis", prima di "PRD sizing", con il titolo
**"Scrivere per il lettore: dalla fonte all'artefatto"**.

- **P1 — Il lettore prima del template.** Ogni artefatto ha un lettore primario dichiarato.
  Il template fissa le sezioni minime; il lettore decide cosa va messo in evidenza e quanto
  contesto serve.
- **P2 — L'artefatto si regge da solo.** Un PRD, insieme al brief d'iniziativa, deve essere
  comprensibile da chi non ha partecipato a nessuna conversazione. Vietati i rimandi a
  materiale che il lettore non ha ("come detto in call", "vedi trascrizione") come sostituto
  del contenuto. Sono ammessi come *citazione di fonte*, accanto al contenuto.
- **P3 — Nessun punto sparisce in silenzio.** Ogni punto chiave della fonte finisce in un
  artefatto oppure viene escluso con un motivo confermato dal PM.
- **P4 — Narrativa ≠ stima.** Un esempio illustrativo è materiale prezioso per la
  narrativa e va mostrato, marcato come illustrativo. Non va mai usato come stima (RICE,
  baseline, target). Estende il principio garantista senza indebolirlo.
- **P5 — L'arricchimento è visibile.** Quello che l'analisi aggiunge rispetto alla fonte
  (vincoli legali, riferimenti di codice, benchmark, decisioni del PM in conversazione) è
  marcato come tale, così il PM lo convalida invece di scoprirlo rileggendo.
- **P6 — Ogni fase di analisi lascia un artefatto.** La Preliminary analysis produce la
  bozza del brief d'iniziativa; la Complete analysis lo completa. Il PRD non è il primo
  posto in cui la storia viene scritta.
- **P7 — Portabilità: l'artefatto viaggia senza il sistema che l'ha prodotto.** Brief e PRD
  vengono condivisi con persone e con altri agenti (es. Claude Design, Claude Code, Claude di
  un collega) che **non hanno** la sessione in cui sono stati scritti, la memoria locale
  dell'agente, l'accesso al repository di governance né i file in `context/`. Quindi:
  - nel corpo, niente percorsi locali (`~/…`), niente rimandi a `context/*.md`, niente id
    interni non spiegati (`PG-042`, `ABC-123`, codici di roadmap). Se servono, si spiega in parole
    cosa sono e l'id va tra parentesi o nella sezione finale "Materiale di origine";
  - i fatti presi da `context/` vengono **riportati** in forma sintetica, non linkati;
  - i riferimenti al codice (`ReportingServiceImpl`, percorsi di repository applicativi)
    sono ammessi solo nei documenti con `primary_reader: tech`, perché quel lettore ha
    accesso ai repository;
  - la lettura a freddo (M6) verifica questo principio: il lettore simulato riceve solo il
    testo, senza accesso a niente, quindi un rimando non spiegato emerge come domanda.
  *(Principio emerso durante il collaudo della specifica sul caso reale, quando il PM ha
  indicato che i documenti vanno condivisi con stakeholder e con persone che usano Claude
  senza la memoria locale.)*

## 4. Modifiche per componente

Ogni modifica riporta: **cosa**, **specifica**, **file toccati**, **criteri di
accettazione**.

### M1 — Registro dei punti chiave della fonte (`source/key-points.yaml`)

**Cosa.** All'intake di materiale ricco si estrae un registro strutturato dei punti chiave.
È la base della verifica di copertura (M5) e della lettura a freddo (M6).

**Quando si produce.** È obbligatorio quando la fonte è una trascrizione, un workshop, un
thread con più interlocutori, oppure supera circa 400 parole. Per una mail breve è
facoltativo: la skill può saltarlo e dirlo nel riepilogo.

**Nuovo template `framework/schema/key-points.template.yaml`:**

```yaml
source_ref: "source/trascrizione-2026-01-08.vtt"   # file in source/ da cui sono estratti
extracted_at: "2026-01-08"
extracted_by: "inbox-triage"                        # skill
other_units_from_same_source: []                    # slug delle altre unità generate dalla stessa fonte
points:
  - id: "KP-01"
    type: problem        # problem | scenario | actor | value_chain | example | hypothesis |
                         # decision | constraint | open_question | metric_claim | vision | quote
    text: ""             # parafrasi fedele, una o due righe
    quote: null          # citazione testuale, se la formulazione conta (tono, metafora, slogan)
    source_locator: ""   # timestamp, paragrafo o riga — per ritrovarlo nella fonte
    speaker: ""          # chi l'ha detto (ruolo, se il nome non serve)
    info_kind: fact      # fact | estimate | illustrative | intent | opinion   (vedi M7)
    usable_as: [narrative]   # narrative | estimate | requirement | none — dove è lecito usarlo
    status: open        # open | covered | excluded
    covered_by: []       # es. ["README.md", "prd-1-poc.md#scenario"]
    exclusion_reason: null   # obbligatorio se status: excluded — confermato dal PM
```

**Regole.**
- Se una fonte genera più unità, ogni unità ha il proprio registro con i soli punti
  pertinenti. I punti assegnati ad altre unità sono elencati in
  `other_units_from_same_source`. La fonte grezza resta copiata per intero (regola
  invariata).
- Gli esempi con numeri vanno sempre registrati con `info_kind: illustrative` e
  `usable_as: [narrative]`. Non vanno scartati.
- Chi è presente nella conversazione ma non è il proponente, e i destinatari indiretti (chi
  va convinto, chi userà l'output), si registrano come `type: actor`. Sono i punti che si
  perdono più facilmente.

**File toccati:** nuovo `framework/schema/key-points.template.yaml`; `idea-intake`
(nuovo passo dopo "Salva il materiale grezzo"); `inbox-triage` (passo 5, sezione "Nuova
idea", e regola del materiale condiviso al passo 3); `CLAUDE.md` (tabella proprietà: nuova
riga, vedi §5).

**Criteri di accettazione.**
- Il registro di una trascrizione di ideazione contiene almeno un punto per ciascun tipo
  `problem`, `scenario`, `actor`, `value_chain` (se presenti nella fonte).
- Gli esempi numerici compaiono come `illustrative`, mai scartati.
- Il riepilogo di intake mostra il numero di punti estratti per tipo.

### M2 — Brief d'iniziativa (`product/prds/{slug}/README.md`)

**Cosa.** Un documento narrativo per iniziativa, leggibile da chiunque, che racconta la
storia **una sola volta**. I PRD restano A3 perché il contesto sta qui. Ogni PRD della
cartella lo dichiara come lettura propedeutica.

**Nuovo template `framework/schema/initiative-brief.template.md`.** Il vincolo
dimensionale è lo stesso dei PRD: circa due facciate A4.

```markdown
---
idea_id: ""
owner: ""
stage: preliminary        # preliminary | complete — vedi M8
key_points_ref: "../../ideas/{slug}/source/key-points.yaml"
created_at: ""
updated_at: ""
---

## La storia in un minuto
<!-- Il problema raccontato dal punto di vista delle persone coinvolte, con un caso concreto.
     Prosa, non bullet. Chi non sa nulla deve capire perché questa cosa conta. -->

## Chi è coinvolto e in quale momento
<!-- Attori diretti (chi usa) e indiretti (chi va convinto, chi riceve l'output, chi paga).
     Per ciascuno: il momento d'uso e cosa deve succedere dopo. -->

## Come produce valore
<!-- La catena causale fino alla NSM / metrica di business. Una riga per anello. -->

## Esempi
<!-- Esempi concreti dalla fonte, marcati "illustrativo" quando lo sono. Sono materiale per
     chi progetta e scrive, NON stime. -->

## Cosa sappiamo, cosa ipotizziamo, cosa non sappiamo
<!-- Tre liste brevi. Separa i fatti verificati dalle ipotesi e dalle domande aperte. -->

## Vincoli trasversali
<!-- Vincoli che valgono per tutti i PRD (legali, di brand, tecnici), detti in linguaggio
     comprensibile a un non specialista. -->

## Parole che usiamo
<!-- Termini di dominio usati nei PRD di questa cartella, con link al glossario
     (product/reference/glossary.yaml). Solo quelli che il lettore potrebbe non conoscere. -->

## Mappa dei documenti
<!-- Tabella: PRD | per chi è scritto (primary_reader) | cosa decide/abilita | ordine di
     lettura | ordine di rilascio. -->
```

**Regole.**
- Il brief è obbligatorio quando un'iniziativa ha più di un PRD, oppure quando un PRD ha
  `primary_reader` diverso da `stakeholder`/`pm`. Negli altri casi è facoltativo.
- Il brief non sostituisce `idea.yaml`, che resta il registro (classificazione, RICE,
  stato). Il brief è la versione leggibile. Il RICE non si ripete nel brief (stessa regola
  dei PRD).
- Gli esempi illustrativi stanno qui. I PRD li richiamano invece di riscriverli.

**File toccati:** nuovo template; `prd-draft` (M4); playbook ("PRD sizing", "Preliminary
analysis", "Complete analysis"); `CLAUDE.md` (tabella proprietà).

**Criteri di accettazione.** Un lettore che ha solo il brief sa rispondere a:
- qual è il problema;
- chi lo vive;
- come l'iniziativa produce valore;
- cosa non sappiamo ancora.

È verificato dalla lettura a freddo (M6).

### M3 — Template PRD: lettore, tipo di PRD, scenario, provenienza

**Frontmatter, campi nuovi:**

```yaml
primary_reader: design      # design | tech | business | legal_finance | stakeholder | pm
prd_kind: delivery          # discovery | delivery
brief_ref: "README.md"      # brief d'iniziativa; null solo se il brief non è obbligatorio (M2)
```

**Sezioni:**

- **`## Why`.** Il commento cambia da "poche righe" a: *"Il problema e perché ora, in modo
  comprensibile senza aver partecipato ad alcuna conversazione. Fino a ~8 righe. Se c'è un
  brief, richiamalo invece di riscrivere la storia."*
- **`## Scenario` (nuova, obbligatoria, al posto di `## Who`).** Da 3 a 6 righe:
  - chi;
  - in quale momento;
  - cosa fa con il risultato;
  - cosa deve succedere dopo;
  - eventuali destinatari indiretti.

  Sostituisce il Who "solo se rilevante": lo scenario è sempre rilevante per chi deve
  costruire.
- **Sezioni condizionate da `prd_kind`:**
  - `discovery` → al posto di `## Metriche`, la sezione **`## Cosa vogliamo imparare`**:
    - ipotesi da testare, una riga ciascuna, falsificabili;
    - varianti da prototipare per discriminare tra le ipotesi;
    - segnali di conferma e di smentita, in forma di comportamenti, non di opinioni;
    - protocollo di raccolta del feedback (chi, quante sessioni, domande guida);
    - esito atteso: la decisione che il PoC deve abilitare.

    `measurement-N.yaml` resta con `kpis: []` e `not_applicable_reason`, come oggi.
  - `delivery` → `## Metriche`, invariata.
- **Sezioni condizionate da `primary_reader`.** Il template contiene una tabella di
  orientamento (commento HTML) su cosa mettere in evidenza:

  | primary_reader | Mettere in evidenza | Ridurre al minimo |
  |---|---|---|
  | design | Scenario, contenuti di esempio (dal brief), gerarchia del racconto, **`## Vincoli di design`** (nuova, opzionale: cosa NON si può mostrare o dire e perché, in linguaggio non legale) | stack, repository, articoli di legge |
  | tech | How (sistemi, interfacce, blast radius), dipendenze di rilascio | narrativa (sta nel brief) |
  | legal_finance | ipotesi, fonti, claim e la loro difendibilità | UI, stack |
  | stakeholder / pm | Why, decisione richiesta, rischi | dettagli implementativi |

- **`## Provenienza` (nuova, in fondo, breve).** Tre liste:
  - dalla fonte: punti chiave coperti, per id (`KP-03`, `KP-07`…);
  - aggiunto dall'analisi: es. vincolo normativo letto in `context/`, aggancio nel codice,
    benchmark;
  - deciso dal PM in conversazione, con data.

  È ammessa la marcatura inline `[KP-03]` sulle frasi che riportano numeri o claim.

Il vincolo dimensionale A3 resta invariato: il contesto in più va nel brief, non nel PRD.

**File toccati:** `framework/schema/prd.template.md`.

**Criteri di accettazione.**
- Un PRD `discovery` non può avere una sezione Metriche vuota senza `## Cosa vogliamo
  imparare` compilata.
- Un PRD con `primary_reader: design` contiene Scenario e contenuti di esempio (anche
  tramite richiamo al brief).
- Nessun PRD contiene rimandi del tipo "come detto in call" senza il contenuto.

### M4 — `prd-draft`: intervista di prodotto, brief, copertura, glossario

Nuovi passi, nell'ordine:

1. **(Prima della stesura) Verifica dello stadio di analisi.** Se non esiste un brief
   (`stage: preliminary` o `complete`), proponi di scriverlo prima dei PRD. Non è un blocco
   rigido, è la proposta di default. Se il PM salta il brief, registralo nel riepilogo.
2. **Intervista di prodotto**, accanto alle domande di governance che esistono già. Chiedi
   solo ciò che non è ricavabile da `source/`, dal registro o da `context/`:
   - per ogni PRD previsto: **chi lo legge** (`primary_reader`) e **che tipo di PRD è**
     (`prd_kind`);
   - **scenario d'uso**: chi, in quale momento, cosa fa con il risultato, cosa deve
     succedere dopo;
   - **destinatari indiretti**: chi deve essere convinto o ricevere l'output senza usare il
     prodotto;
   - per un `discovery`: cosa deve permettere di decidere il PoC, e a chi verrà mostrato.
3. **Carica il registro dei punti chiave** (M1) e costruisci la mappa di copertura prima di
   scrivere. Se il registro manca e la fonte è ricca, generalo ora: è un retrofit, con la
   stessa logica di M1.
4. **Redigi brief e PRD** secondo M2/M3. Gli esempi illustrativi vanno nel brief, marcati
   come tali (P4).
5. **Report di copertura.** Per ogni punto `open`:
   - associalo a una sezione del brief o di un PRD (`covered`, con `covered_by`);
   - oppure proponi l'esclusione con un motivo e **fai confermare al PM in conversazione**
     (`excluded` + `exclusion_reason`).

   Nessun punto resta `open` a fine stesura. Aggiornare il registro è una scrittura diretta
   (è il registro del lavoro fatto, non una decisione di priorità).
6. **Verifica del glossario.** Elenca i termini di dominio usati nel brief e nei PRD che non
   sono né in `product/reference/glossary.yaml` né nella sezione "Parole che usiamo" del
   brief. Proponi le definizioni al PM e scrivile alla conferma (M9).
7. **Lettura a freddo** (M6) per ogni PRD con `primary_reader` diverso da `pm`. Applica le
   correzioni, poi mostra al PM il confronto.
8. **Riepilogo finale arricchito**, in aggiunta a quanto previsto oggi:
   - copertura (N punti: X coperti, Y esclusi con motivo);
   - esito delle letture a freddo (lacune trovate e corrette, domande residue);
   - "cosa ho aggiunto rispetto alla fonte" (P5).

Cosa resta invariato: non ripetere il RICE, non ridescrivere framework generali, A3 con
split per cuciture, `data_source` chiesto per ogni KPI, `tech_reference`.

**Nota sul passo 8 "Non ridescrivere framework generali".** Va chiarito che il divieto
riguarda i *framework* (BMC, GTM generico), **non il contesto specifico dell'iniziativa**.
Questo deve essere raccontato, nel brief.

**File toccati:** `.claude/skills/prd-draft/SKILL.md`.

**Criteri di accettazione:** vedi il test di regressione in §6.

### M5 — Verifica di copertura come regola del metodo

È già operativa dentro `prd-draft` (M4, passo 5). Va resa normativa nel playbook (P3) ed
estesa ad altri due momenti:
- **`inbox-triage` / `idea-intake`, decomposizione.** Quando una fonte si decompone in più
  unità, ogni punto chiave deve finire in almeno un'unità, oppure essere dichiarato "non
  pertinente a nessuna unità" con un motivo. Questo previene la perdita alla prima
  diramazione.
- **Aggiornamento di un PRD esistente** (nuovo materiale in `source/` di un PRD). I nuovi
  punti entrano nel registro come `open`. `prd-draft`, alla riapertura, li deve coprire o
  escludere.

**File toccati:** playbook; `idea-intake`; `inbox-triage`.

### M6 — Lettura a freddo (cold read)

**Cosa.** Un controllo automatico che simula il lettore primario: un agente a **contesto
vergine** riceve solo il testo del brief e del PRD e restituisce cosa ha capito. È la
formalizzazione del test che il PM ha fatto a mano nel caso di §1.

**Meccanismo.**
- `prd-draft` lancia un subagent (tool Agent) passando **nel prompt** il testo integrale del
  brief e del PRD.
- Istruzione esplicita: non leggere file del repository e non cercare altro contesto.
- Il prompt è un file del framework: nuovo `framework/prompts/cold-read.md`, parametrizzato
  per `primary_reader`.
- Il subagent impersona il lettore primario (es. "sei un product designer che riceve
  questo documento") e risponde con questa struttura fissa:
  1. il problema, con parole sue;
  2. chi è coinvolto e in quale momento;
  3. **cosa produrrebbe**, concretamente:
     - design → elenco delle schermate, con contenuto e gerarchia;
     - tech → componenti e interfacce;
     - legal_finance → claim da verificare;
  4. le domande che dovrebbe fare prima di iniziare;
  5. i termini che non ha capito.
- L'agente principale confronta la risposta con il registro dei punti chiave e classifica:
  - **lacune**: punti `problem`/`scenario`/`actor`/`constraint` che non compaiono nella
    risposta;
  - **fraintendimenti**;
  - **domande** che il documento avrebbe dovuto chiarire.

  Ognuna diventa una correzione del testo, oppure una domanda aperta accettata e
  dichiarata nel PRD.
- Al massimo **2 iterazioni**. Se dopo la seconda restano lacune su punti `problem` o
  `scenario`, va segnalato al PM come problema di contenuto, non di forma.

**Esito registrato** in `product/prds/{slug}/.reviews/cold-read-{prd-id}-{YYYY-MM-DD}.md`
(file tracciato, breve), con:
- la risposta del lettore simulato (sintesi);
- le lacune trovate;
- le correzioni applicate;
- le domande residue accettate.

È audit trail del perché il documento è fatto così.

**Gate di stato.** `status: draft → in_review` solo dopo almeno una lettura a freddo e con
la copertura completa (nessun punto `open`). La transizione `in_review → approved` resta
umana: PM più `tech_reference`, ed eventualmente un rappresentante del lettore primario.

**Fallback.**
- Se l'ambiente non permette subagent, la skill lo dice e propone al PM una lettura a freddo
  umana: invia il PRD a una persona del ruolo `primary_reader` con le stesse 5 domande.
  Mai saltata in silenzio.
- In dry-run la lettura a freddo si esegue, ma `.reviews/` non viene scritto.

**File toccati:** nuovo `framework/prompts/cold-read.md`; `prd-draft`; playbook (gate di
stato dei PRD, che oggi non esiste in modo esplicito); `CLAUDE.md` (tabella proprietà:
`.reviews/`).

**Criteri di accettazione.**
- La lettura a freddo del PRD discovery del caso di §1, nella sua versione originale, deve
  far emergere almeno queste domande:
  - "da dove vengono i bisogni?";
  - "chi guarda questa pagina e per farci cosa?";
  - "cosa vogliamo imparare?".
- Sulla versione corretta queste domande non devono più emergere.

### M7 — Tassonomia del tipo d'informazione

**Cosa.** Estende il principio garantista con una classificazione esplicita. Si applica al
registro (M1), al brief (M2) e alle note di intake:

| `info_kind` | Esempio | Dove è lecito usarlo |
|---|---|---|
| `fact` | "Il budget lo decide il CFO al rinnovo annuale" (confermato) | ovunque |
| `estimate` | "circa 20k €/anno di licenze", detto dal PM, da verificare | RICE e metriche **solo dopo verifica**; in narrativa con "stimato" |
| `illustrative` | "il 5% è stressato, il 3,3% ha trovato una soluzione" | **solo narrativa ed esempi** (brief, contenuti di esempio del PoC); mai RICE, baseline o target |
| `intent` | "vogliamo un PoC da mostrare in giro" | requisiti, scenario |
| `opinion` | "è la svolta per il prodotto" | contesto, mai come evidenza (Confidence ≤ 3) |

**Regola chiave (P4):** un'informazione `illustrative` **si conserva e si mostra marcata**,
non si elimina. La rimozione è ammessa solo se l'esempio è fuorviante anche come
illustrazione (es. viola un vincolo legale), e va registrata nel registro come `excluded`
con motivo.

**File toccati:** playbook (sezione del principio garantista in "Alimentazione del bucket
delle idee", più P4); `idea-intake`; `inbox-triage`; `prd-draft`.

### M8 — Le fasi di analisi producono il brief

**Cosa.** Dà un artefatto a Preliminary e Complete analysis, che oggi hanno solo una
checklist.

- **Preliminary analysis** → bozza del brief (`stage: preliminary`):
  - "La storia in un minuto";
  - "Chi è coinvolto";
  - "Come produce valore";
  - "Cosa sappiamo / ipotizziamo / non sappiamo".

  Nuovo punto nella checklist: *"[ ] Il brief è comprensibile da chi non ha partecipato
  alle conversazioni?"*
- **Complete analysis** → il brief è completo (`stage: complete`: esempi, vincoli
  trasversali, glossario, mappa dei documenti), poi i PRD.
- Se si arriva a `prd-draft` senza brief (percorso rapido, come nel caso di §1), il brief
  si scrive dentro `prd-draft` (M4, passo 1). La storia viene comunque scritta prima dei
  PRD.

**File toccati:** playbook ("Preliminary analysis", "Complete analysis").

### M9 — Glossario di dominio dell'istanza

**Cosa.** Il playbook prevede già un glossario in `product/reference/`, ma non c'è un
template, nessuna skill lo crea e nessuna lo verifica.

**Nuovo template `framework/schema/glossary.template.yaml`:**

```yaml
terms:
  - term: ""                 # nome interno
    definition: ""           # una o due righe, comprensibili a un nuovo assunto
    external_name: null      # nome verso clienti/utenti, se diverso dall'interno
    aliases: []              # altri nomi usati in azienda
    not_to_confuse_with: []  # termini simili con significato diverso
    source: ""               # dove è stato definito/deciso
    added_at: ""
```

**Regole.**
- `init-governance-project` crea il file vuoto.
- `prd-draft` (M4, passo 6) e `idea-intake`/`inbox-triage` propongono termini nuovi e li
  scrivono **alla conferma del PM in conversazione**. È una scrittura diretta, senza
  `pending/`: è un dato di riferimento condiviso, come il denominatore Reach.
- `external_name` serve in particolare per i prodotti con nome interno diverso da quello
  pubblico. Il PRD per `design` deve usare il nome che vedrà l'utente.

**File toccati:** nuovo template; `init-governance-project`; `prd-draft`; `idea-intake`;
`inbox-triage`; playbook (riga già esistente sul glossario, da collegare al template);
`CLAUDE.md` (tabella proprietà).

## 5. Modifiche a `CLAUDE.md` (tabella dei confini di proprietà)

Righe nuove:

| Cartella / file | Proprietà | Chi scrive |
|---|---|---|
| `product/ideas/*/source/key-points.yaml` | Istanza | `idea-intake`/`inbox-triage` all'origine; `prd-draft` aggiorna `status`/`covered_by`/`exclusion_reason`. Le esclusioni sono confermate dal PM in conversazione. Scrittura diretta, nessuna approvazione (registro del lavoro, non decisione di priorità) |
| `product/prds/*/README.md` (brief d'iniziativa) | Istanza | `prd-draft` (e, quando esisterà, l'analisi preliminare); creazione diretta come i PRD |
| `product/prds/*/.reviews/` | Istanza, **tracciata** | Solo `prd-draft`: esito delle letture a freddo, fatto osservato, scrittura diretta |
| `product/reference/glossary.yaml` | Istanza | Creato da `init-governance-project`; termini aggiunti da `prd-draft`/`idea-intake`/`inbox-triage` alla conferma del PM |
| `framework/prompts/` | Framework (upstream) | Solo PR sul canonico |

## 6. Test di regressione (sul caso di §1, anonimizzato)

Da conservare come caso di prova per chi modifica `prd-draft` in futuro.

**Input:** trascrizione di una call di ideazione di circa 15 minuti con i contenuti
descritti in §1.

**Output atteso dopo le modifiche:**

1. `key-points.yaml` contiene, tra gli altri:
   - il problema (il cliente aziendale non capisce il beneficio, quindi non aumenta il
     budget);
   - lo scenario personale (aumento in welfare invece che in RAL);
   - gli attori indiretti (CFO del cliente; prospect senza dati);
   - la catena di valore;
   - gli esempi numerici come `illustrative`;
   - l'intento "PoC da mostrare e raccogliere feedback";
   - i temi aperti dichiarati (legali, design, report via email).
2. Esiste `README.md` (brief), con la storia raccontata e gli esempi marcati come
   illustrativi.
3. Il PRD del PoC ha:
   - `prd_kind: discovery` e `primary_reader: design`;
   - lo Scenario (HR davanti al CFO; Sales davanti a un prospect);
   - `## Cosa vogliamo imparare`, con ipotesi e varianti;
   - `## Vincoli di design`.
4. Il report di copertura non ha punti `open`. Lo scenario dei prospect è coperto (oppure
   escluso con motivo confermato dal PM), **non scomparso**.
5. `.reviews/cold-read-prd-1-*.md` esiste. La lettura a freddo finale non contiene più la
   domanda "da dove vengono i dati?".
6. Restano veri: niente RICE nel PRD, A3 rispettato, rischi legali intercettati,
   `data_source` chiesto per ogni KPI dei PRD `delivery`.

## 7. Migrazione per le istanze (`sync-framework-updates`)

- **Non breaking.** I campi nuovi del frontmatter PRD (`primary_reader`, `prd_kind`,
  `brief_ref`) sono opzionali. I PRD esistenti senza questi campi restano validi.
- **Retrofit facoltativo, su richiesta.** `prd-draft {slug} retrofit`:
  1. genera `key-points.yaml` dalla fonte esistente;
  2. scrive il brief;
  3. esegue la lettura a freddo sui PRD esistenti;
  4. propone le correzioni.

  Non riscrive i PRD senza conferma del PM.
- `sync-framework-updates` deve spiegare la novità in linguaggio PM e proporre il retrofit
  per i PRD in `draft`/`in_review`, non per quelli `approved`/`superseded`.
- Il glossario viene creato vuoto al primo `prd-draft` dopo l'aggiornamento, se manca.

## 8. Ordine di implementazione consigliato (PR separate)

| PR | Contenuto | Perché in quest'ordine |
|---|---|---|
| 1 | M3 (template PRD: `primary_reader`, `prd_kind`, Scenario, Cosa vogliamo imparare, Vincoli di design, Provenienza) + M4 passo 2 (intervista di prodotto) | Massimo impatto e minimo sforzo: corregge già da sola il caso di §1 |
| 2 | M2 + M8 (brief d'iniziativa, fasi di analisi che lo producono) + M4 passo 1 | Dà alla narrativa un posto in cui stare senza violare l'A3 |
| 3 | M1 + M5 + M7 (registro dei punti chiave, copertura, tassonomia) + M4 passi 3-5 | Rende impossibile la perdita silenziosa |
| 4 | M6 (lettura a freddo, gate di stato) + M4 passi 7-8 | Chiude il ciclo con una verifica dal punto di vista del lettore |
| 5 | M9 (glossario) + M4 passo 6 | Utile, ma meno urgente |

## 9. Fuori scope / cosa NON cambiare

- Il vincolo A3 sui PRD **resta**. Il contesto in più va nel brief, non nei PRD.
- Il RICE resta fuori da PRD e brief.
- La narrativa non va dentro `idea.yaml`, che resta il registro.
- Nessuna dipendenza nuova negli script: le modifiche riguardano template, skill e
  playbook. La lettura a freddo usa il tool Agent già disponibile, non un servizio
  esterno.
- La lettura a freddo non sostituisce la revisione umana: anticipa le domande più ovvie,
  così la revisione umana si concentra sul merito.

## 10. Lezioni dal primo collaudo (2026-10-12)

La specifica è stata applicata a mano all'iniziativa che l'aveva originata: registro dei
punti chiave, brief, quattro PRD per lettore e due iterazioni di lettura a freddo con tre
lettori simulati. Esito: alla seconda iterazione designer e sviluppatore simulati **non
avevano domande bloccanti** e hanno ricalcolato tutti i numeri. Integrazioni da portare
nelle PR:

1. **P7 (portabilità)**, già aggiunto in §3: è emerso dal PM e la lettura a freddo l'ha
   confermato. Designer e sviluppatore non avevano accesso né alla demo né al mockup citati.
2. **Allegato dati per i PRD di discovery** (nuovo, da aggiungere a M3). Un PoC ha bisogno di
   un dataset dimostrativo **coerente e verificabile**: definizioni, dati in unità assolute
   (non solo percentuali), parametri, testi, risultati attesi usati come criteri di
   accettazione. Non sta nell'A3, quindi va in un `allegato-*.md` comune ai PRD di
   esperienza e di costruzione. Senza di esso la prima lettura a freddo ha trovato 8
   incoerenze numeriche, tutte invisibili all'autore.
3. **Cartella `assets/`** accanto ai PRD per i materiali visivi di riferimento (mockup,
   schermate). La lettura a freddo con un lettore "design" deve riceverli.
4. **Un PRD di discovery per design e uno di costruzione per tech**: quando chi disegna e chi
   costruisce sono lettori diversi, la cucitura per lettore (P1) giustifica lo split anche
   per un PoC.
5. **Lettura a freddo con più ruoli, non solo il `primary_reader`** (da aggiungere a M6):
   - lo **stakeholder** (sul solo brief) ha trovato i problemi di **sostanza**: liceità del
     racconto d'apertura, termine di paragone del ROI, commissione esclusa, assenza di
     richiesta e calendario, una quick win;
   - lo **sviluppatore** ha trovato i problemi **numerici** ricalcolando;
   - il **designer** ha trovato i problemi di **esperienza** (quale portale imitare, confine
     tra temi ammessi e vietati).

   Raccomandazione: brief → stakeholder; PRD design → designer; PRD tech → sviluppatore, con
   un interprete per ricalcolare.
6. **Una lettura a freddo fa emergere decisioni del PM, non solo correzioni di testo.**
   Nell'iterazione 1 sono uscite 4 decisioni (storia d'apertura, paragone del ROI, quick
   win, calendario). `prd-draft` deve prevedere un passo "domande al PM dalla lettura a
   freddo" tra le due iterazioni.
7. **Il brief deve dire cosa si chiede, a chi e quando** (aggiungere a M2 la sezione "Cosa
   chiediamo, a chi, e quando"). Lo stakeholder simulato lo ha indicato come il primo motivo
   per non dare il proprio appoggio.
8. **Errori dell'autore che solo il ricalcolo trova**: per esempio un costo evitato
   attribuito a un tema che è un beneficio del dipendente. Aggiungere a M6 che il lettore
   tech ricalcola sempre i numeri dichiarati.
