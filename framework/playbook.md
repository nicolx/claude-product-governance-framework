# Product Governance Playbook (metodo generico)

> **Nota su questo documento.** Questa è la versione **genericizzata** del
> playbook: contiene il metodo (RICE, A3 Thinking, cerimonie, meccanismo di
> approvazione, gestione delle frizioni) senza riferimenti a un'azienda o
> prodotto specifico. È la fonte normativa che le skill in `.claude/skills/`
> devono rispettare in qualunque istanza.
>
> Per un caso reale, completo di narrativa passo-passo (le "Cronache"), vedi
> [`examples/epassi-ita/docs/playbook-v4.md`](../examples/epassi-ita/docs/playbook-v4.md)
> — è il documento da cui questa versione generica è stata estratta, e resta
> il modo migliore per vedere il metodo "in azione" con dialoghi realistici.
> Qui sotto sono riportate solo versioni brevi e anonimizzate degli episodi
> più istruttivi, a scopo illustrativo.

## Come leggere questo documento

Ha livelli di lettura diversi a seconda del ruolo:

- **Product Manager** — leggi tutto, nell'ordine in cui è scritto. Ogni
  sezione descrive una responsabilità diretta.
- **Developer / Tech Lead** — le sezioni più rilevanti sono: Product
  Backlog Refinement, Preliminary Analysis, Complete Analysis, Roadmap
  Update & Iteration Planning.
- **Stakeholder** (Operations, Sales, Marketing, Leadership) — leggi
  l'introduzione, Ideas Intake, Ideas Prioritization, e "Come gestire le
  frizioni".
- **Nuovo nel team** — inizia dall'esempio completo in
  `examples/*/docs/`, poi torna qui.

Lo scopo è rappresentare un way of working che copra il percorso del
valore dalla raccolta delle idee fino al rilascio, la misurazione
dell'efficacia e l'eventuale iterazione migliorativa.

## Il lavoro del Product Manager (in pillole)

Il punto fondamentale del lavoro del Product Manager è: creare valore
misurabile per l'azienda. Per prodotti che hanno a che fare con
piattaforme tecnologiche, il valore si intende sia per gli utenti del
sistema (beneficiari finali) sia per gli stakeholder interni (sales,
ops, marketing) che traducono il valore creato in ricavi ed efficienza
di costo.

**Parola chiave: valore.**

Quale valore viene generato è dato dall'identificazione e formalizzazione
del problema degli utenti o stakeholder coinvolti in ogni attività. Spesso
i problemi o le opportunità sono piccoli incrementi, non sempre
strategici. Il compito di prodotto è verificare l'attinenza di queste
opportunità con la strategia di prodotto (e dell'azienda). Il valore è
misurato con delle metriche (KPI di prodotto): alcune strategiche (north
star metric), altre più opportunistiche e specifiche per singola attività.

**Parole chiave: problema, why, kpi.**

Il prodotto è garante della corretta riuscita delle iniziative (tempi,
modalità, misurazione dei risultati), dando a tutta l'organizzazione
feedback continui sullo stato dell'arte. Non tutto è importante ed
urgente. Il prodotto non definisce autonomamente le priorità: coordina le
attività per razionalizzarle, riordinarle, fluidificare i processi di
esecuzione. Quando possibile, il prodotto è promotore della Product
Discovery per identificare iniziative ad alto impatto sulle NSM,
indipendentemente dagli altri stakeholder — auto-sottoponendosi agli
stessi criteri di validazione e prioritizzazione.

**Parole chiave: roadmap, product delivery, product discovery.**

Il prodotto ha un ingrato compito: essere nel mezzo tra gli stakeholder,
le loro esigenze, ed il team di tecnologia. Questo comporta che il
prodotto sia responsabile di raccogliere, organizzare e riportare a tutti
gli stakeholder (tech e non tech) le informazioni utili a fluidificare
l'implementazione. Tradurre il linguaggio del business in modo accessibile
al tech; viceversa, proteggere il team tech dall'investire troppo tempo
nella comprensione di elementi di business troppo dispersivi.

**Parole chiave: analisi dei requisiti, lean management.**

Prodotto è misurato sugli outcomes: non basta fluidificare il lavoro, non
basta comprendere il problema e promuovere soluzioni. Le NSM devono avere
impatti. Prodotto deve essere in grado, usando dati ed evidenze
sperimentali, di giustificare dei "no" per aiutare il resto
dell'organizzazione a prendere decisioni consapevoli su priorità e
allineamento alla strategia.

**Parola chiave: outcomes.**

Nessuno che si occupi di Product Management ha la sfera di cristallo: un
bravo Product Manager non si fida del proprio istinto, lo mette alla prova
riducendo il rischio ed aumentando le probabilità di un ritorno positivo.
Una volta misurati gli impatti, impara dai dati e adatta le proprie
conclusioni per le prossime attività. Il ciclo si ripete adattandosi alla
strategia, alla discovery, ai competitor, ai clienti.

**Parole chiave: gestione del rischio, ciclo del feedback.**

### Il percorso evolutivo per un Product Manager

| **4Ds** | **Cosa denota** |
|---|---|
| **Discovery** | Capacità di ridurre l'incertezza in modo strutturato: ipotesi falsificabili, problem framing, metodo di validazione adeguato al rischio, lettura critica delle metriche. |
| **Delivery** | Trasformare decisioni in risultati misurabili: roadmap eseguibile, KPI di outcome, gestione dei trade-off velocità/qualità/debito tecnico. |
| **Decision** | Assumere responsabilità strategica: trade-off espliciti, prioritizzazione basata su valore e rischio, capacità di dire no motivando con evidenze. |
| **Direction** | Influenzare la strategia aziendale e il sistema organizzativo: visione di medio-lungo periodo, standard e framework interni, mentoring. |

### Product vs Project. Errori tipici

**Project management:** presidia la delivery di un progetto (tempi e
costi); allinea gli stakeholder; è responsabile degli output; risponde di
un budget assegnato; è coinvolto dall'inizio alla fine del progetto.

**Product management:** il suo obiettivo è creare valore misurabile;
oltre a creare allineamento, è garante di fluidificazione e sintesi delle
esigenze in accordo con la strategia di prodotto; è responsabile degli
outcomes, cioè che i suoi contributi producano impatti concreti nelle
metriche che presidia; risponde della coerenza della roadmap con la
strategia e della sua fattibilità; il suo lavoro non finisce mai — c'è
sempre una metrica da migliorare.

Errore tipico: "in qualità di Product Manager mi aspetto che i
requirements siano formulati dagli stakeholder; elaborarli è lavoro di
Project Management". Il Project Manager raccoglie requirements e li
rielabora senza giudicarli. Il Product Management è garante sia di
raccoglierli sia di rielaborarli — anche facendo obiezioni basate sui dati
— per riscriverli in chiave: problema, soluzione, metriche.

I requirements non sono mai statici: evolvono man mano che emerge la
conoscenza. Fare software comporta la trasformazione della conoscenza —
per questo sono fondamentali i Product Manager.

Sequenza: lo stakeholder espone i needs → rielaborazione del PM, in
problema/soluzione/metriche → fluidificazione della delivery →
misurazione e feedback.

> **Nota sul perimetro di questo playbook.** Il focus è sulla governance
> delle priorità: dalla raccolta delle idee fino alla pianificazione
> dell'iterazione. Le sezioni relative all'implementazione tecnica
> (Product Design, Development, Rollout) sono di competenza del CTO/tech
> lead di ogni istanza e vanno integrate localmente. La sezione
> Measurement non richiede un datalake strutturato per iniziare: il
> tracciamento delle KPI (baseline, target, letture nel tempo) vive in
> Git accanto al PRD fin da subito, con le letture riportate dal PM a
> mano — vedi skill `measurement-watch`. Un datalake resta comunque
> l'obiettivo di maturità per automatizzare la raccolta delle letture,
> non un prerequisito per cominciare a tracciare.

Questo processo è progettato per governare **decisioni**, non solo
attività. Ogni iniziativa è valutata in termini di rischio cognitivo e
rendimento atteso: il livello di investimento è proporzionale alla
confidenza. Meglio fallire presto (lean management) e investire poco e in
modo calibrato, proteggendo il team dal perfezionismo.

Il framework crea dei confini (boundaries) per proteggere il team dalla
cultura esterna, fornendo interfacce (persone — il PM — e processi — le
cerimonie) per ridurre le frizioni. Il team può orientare nel lungo
termine la cultura aziendale: fare al meglio il proprio lavoro è come la
cultura evolve in meglio. Leading by example.

Tre macro fasi di lavoro per ogni prodotto:

- **Definizione della strategia di prodotto** (eccezionale, valida nel
  lungo termine): comprensione condivisa della visione aziendale;
  framework come Business Model Canvas o Blue Ocean Strategy; formalizzazione
  della strategia.
- **Esecuzione della strategia** (ricorrente): raccolta di iniziative e
  pianificazione in iterazioni consecutive; discovery, design, delivery,
  analysis, marketing, growth secondo i principi Agile; frammentazione
  logica why/what; definizione UI/UX e specifiche; go-to-market strategy.
- **Implementazione della soluzione** (ricorrente): backlog di breve
  termine secondo Agile; almeno due flussi continui — roadmap principale e
  protezione del team per manutenzione/debito tecnico/bug. Il debito
  tecnico e le attività devops pure si catalogano come
  `classification: platform`: bypassano il RICE (la priorità è giudizio
  del team tech dentro la capacità protetta, non valore di business), ma
  non sono invisibili — entrano comunque in roadmap quando rilevanti, e
  la quota di capacità che assorbono è tracciata esplicitamente
  (`capacity_allocation` in ogni snapshot settimanale) perché il
  bilanciamento tra le due cose sia una scelta consapevole, non un
  effetto collaterale.

## Le fasi ricorrenti

| **Fase (ordinata)** | **Timing** | **Attori tipici** | **Output atteso** |
|---|---|---|---|
| Ideas intake | As needed | PM, PMM, Design/Discovery, Users, Leaders | Lista non ordinata di richieste; bug loggati direttamente nel tracker di esecuzione; Strategic Exception approvate |
| Ideas prioritization | ASAP | PM, IT, Leaders | Lista prioritizzata (RICE) |
| Product Backlog Refinement | Settimanale | PM, IT | Iterazione/release popolata |
| Preliminary analysis | ASAP dopo il Refinement | PM, IT, Domain expert | Why chiaro; decisione di procedere o abort |
| Complete analysis | ASAP dopo la Preliminary | PM, Domain expert, Leaders | What/GTM, metriche, PRD; decisione di procedere (+ROI) |
| Roadmap update | Settimanale | PM | Report su cosa conta per Prodotto e IT; snapshot roadmap |
| Iteration planning | Settimanale | PM, Design, IT | User stories, valutazione 80/20, backlog di iterazione |
| Product Design | ASAP se necessario | Designer | Design pronto per l'implementazione |
| Development | ASAP | PM, IT | Deliverable testato |
| Rollout | — | PM, PMM | Esecuzione dei piani GTM |
| Measurement | — | PM, Data, IT | Obiettivi raggiunti? Serve iterare? Showcase dell'outcome |

Ogni PM è responsabile del successo di una **North Star Metric** per la
propria Product Line: il KPI più importante che, migliorato
continuamente, abilita l'azienda a raggiungere i propri traguardi. Le
Product Line di un'istanza specifica (nomi, NSM, stakeholder,
denominatori Reach) si dichiarano in `product/reference/product-lines.yaml`
— vedi `framework/schema/product-lines.template.yaml`.

---

# Il playbook in dettaglio

*"The greatest danger in times of turbulence is not the turbulence; it is
to act with yesterday's logic." — Peter Drucker*

Ogni passaggio deve essere inequivocabile nell'execution — ciò non toglie
che i processi evolvano e si adattino al contesto: **il playbook è
un'entità viva.**

Tutta la Product Governance fonda i suoi elementi sul Manifesto Agile.
Non lo usiamo come metodologia, ma come bussola per interpretare le scelte
operative: "fermo restando il valore delle voci a destra, consideriamo più
importanti le voci a sinistra" — le persone, il software, la
collaborazione, l'evoluzione sono l'obiettivo, non negoziabile; il come è
oggetto delle prossime sezioni.

## Product Governance in practice

Tutte le attività hanno origine e fondamento nella Strategia di Prodotto,
che si inserisce in un contesto di Strategia di Business (tipicamente
descritta con un framework come il Lean Canvas). Ogni membro
dell'organizzazione di prodotto e tecnologia dovrebbe avere chiaro come
funziona sommariamente il modello di business: solo una chiara
comprensione del business aiuta a mantenere il focus sulle cose che
spostano (principio 80/20).

## Contesto aziendale (`context/`)

Il paragrafo precedente dice che "ogni membro dell'organizzazione di
prodotto e tecnologia dovrebbe avere chiaro come funziona sommariamente
il modello di business": questa sezione descrive dove vive quella
comprensione dentro un'istanza, non solo nella testa del PM.

Un'istanza mantiene una cartella `context/` alla **radice del
repository** (non sotto `product/`, perché non tutto quello che ci va è
materiale di prodotto — bilanci pubblici, org chart, materiale
legale/societario ci stanno altrettanto bene), popolata con qualunque
materiale che aiuti a razionalizzare il contesto aziendale: export
Confluence, slide, PDF, bilanci, documenti strategici. Le skill che
generano idee e PRD (`idea-intake`, `prd-draft`) leggono `context/`
insieme al codice in `apps/` — il differenziale del framework non è solo
"conosce la codebase", è anche "conosce il business".

**Nessuna copia del materiale grezzo persiste nel repository, né
tracciata né ignorata da git.** Un file gitignorato esiste solo nel clone
di chi l'ha processato: un collega che clona l'istanza vede la sintesi ma
non può verificarla, e se aggiunge il proprio materiale grezzo il
contesto diverge silenziosamente tra le macchine del team — esattamente
il problema che si voleva evitare tenendo un originale "per sicurezza".
La skill `context-intake` legge il materiale grezzo droppato in
`context/`, lo trascrive in file Markdown tracciati per argomento,
**citando sempre la fonte** (link Confluence/Drive/URL se esiste,
altrimenti nome del documento, chi l'ha fornito, e la data), poi elimina
l'originale. La verificabilità viene dal puntare alla fonte di sistema
condivisa, non da una copia locale.

**È un documento vivo, non un archivio statico.** Quando materiale già in
lavorazione da un'altra skill (un PRD, un elemento smistato da
`inbox-triage`) rivela un'informazione che cambia la comprensione del
business — una riorganizzazione, un nuovo dato di mercato, un pivot
dichiarato — quella skill non scrive da sola in `context/`: segnala il
candidato e richiama `context-intake`, che **propone l'aggiornamento e lo
scrive solo dopo conferma esplicita del PM** nella stessa conversazione.
A differenza delle poche scritture dirette che il framework ammette senza
passare da `product/approvals/pending/` (`mandate-watch`, `rice-watch`,
`nsm-watch`), qui non si tratta di un fatto mai presunto ma di
un'interpretazione di materiale grezzo — per questo la conferma in
conversazione è sempre richiesta, anche se non serve la coda `pending/`
completa (non è una decisione di priorità).

## Alimentazione del bucket delle idee

*"The best way to have a good idea is to have a lot of ideas." — Linus
Pauling*

Ogni giorno arrivano email, conversazioni, riflessioni a voce alta. Non
può stare tutto nella mente del PM: va cristallizzato in un archivio, per
contenere lo stress e la pressione esterna — e perché è molto raro che
un'idea sia immediatamente azionabile.

Le idee devono essere inserite in modo che sia facile capire:

- Da chi arrivano e di cosa si tratta, con un titolo
- Una descrizione che spieghi il contesto e permetta di risalire alle
  informazioni essenziali (citazioni email, documenti già disponibili)
- Una categoria (Product Line, tipo di richiesta) per semplificare i
  filtri

> *Pattern pratico consigliato: usa l'oggetto della mail/segnalazione come
> titolo dell'idea, e il contenuto (con allegati) come dettaglio in
> `source/`. Rende più semplice risalire alla fonte e non perde
> informazione.*

Due input che sembrano idee ma scavalcano le fasi successive:

**a) Bug.** Entra in agenda del team di sviluppo, non è un tema di
priorità RICE. Definizione operativa: è un bug tutto ciò che — per un
errore di codice o un'interpretazione errata del requisito — produce in
produzione un **output** diverso dalla percezione qualitativa attesa. Non
è un bug se una feature funziona come progettata ma non muove la metrica
di business attesa: quella è un'ipotesi di prodotto invalidata (va in
Measurement). L'impatto prodotto determina la priorità di risoluzione: un
tema di security va gestito ASAP.

**b) Strategic Exception.** Quando una richiesta arriva da uno stakeholder
molto rilevante (tipicamente C-level), si può accogliere su un canale
privilegiato, bypassando il RICE. Il PM ha comunque il dovere di
restituire feedback ed evidenze sulla bontà dell'investimento. Se una
Strategic Exception si verifica ogni settimana, non è più un'eccezione.

*Principi Agile da incarnare in questa fase:*
- *Accogliamo i cambiamenti nei requisiti, anche a stadi avanzati.*
- *Una conversazione faccia a faccia è il modo più efficiente per
  comunicare col team.*

> **Esempio.** Uno stakeholder Operations nota che un processo di
> approvazione automatica (basato su AI) fallisce spesso in un caso
> ricorrente e specifico. Manda al PM una dozzina di esempi via email,
> spiegando il pattern osservato. Il PM registra l'idea con titolo,
> proponente e link alla mail, e la categorizza sulla Product Line
> pertinente. *(Versione completa: Cronache Episodio 1 in
> `examples/epassi-ita/`.)*

**Checklist operativa**
- [ ] L'idea è stata registrata con titolo, proponente, descrizione del contesto?
- [ ] Se è un bug: è già stato aperto un ticket con impatto stimato nel tracker di esecuzione?
- [ ] Se è una Strategic Exception: è stata approvata al livello richiesto?
- [ ] L'idea è stata categorizzata per Product Line?
- [ ] Se arriva via canale informale (chat, voce): è stata trasferita nell'archivio prima di qualsiasi altra azione?

## Ideas prioritization

*"There are no solutions, only trade-offs." — Thomas Sowell*

ASAP, non necessariamente subito dopo l'annotazione, il PM insieme a un
referente tecnico (abbastanza esperto da avere sensibilità sulle
implicazioni tecniche ad alto livello) raccoglie con lo stakeholder i
pareri per applicare il RICE.

RICE è un framework di prioritizzazione basato su quattro parametri:

- **(R)each →** Quante persone o utenti avranno un beneficio? **Il valore
  va sempre espresso come rapporto 0-100 (percentuale) sulla popolazione
  rilevante per quella Product Line, non come valore assoluto** — solo
  così i punteggi restano confrontabili tra Product Line diverse nello
  stesso Backlog Refinement. Il valore assoluto resta utile come nota di
  contesto nel record dell'idea, ma il campo usato per il punteggio è
  sempre la percentuale.

  **Popolazione di riferimento (denominatore).** Il numero usato come
  denominatore per ciascuna Product Line non è lasciato alla stima
  soggettiva di chi compila il RICE: va dichiarato esplicitamente e
  mantenuto aggiornato come dato di riferimento condiviso, con una fonte
  dati e un owner. Finché questa dichiarazione non è formalizzata, il
  Reach normalizzato resta un'approssimazione e va trattato come tale.

- **(I)mpact →** Quali sono gli impatti attesi? Più ricavi, risparmio di
  costo, o — per temi legali/compliance — rischio se non si accoglie?
  Un ottimo modo per esprimerlo: "fatto 10pt il valore dell'incremento
  atteso nell'anno (es. EBITDA), quanto vale questa attività?" Un target
  annuale di riferimento va dichiarato per l'istanza (es. in
  `product/reference/`), così ogni iniziativa si può convertire in punti.

- **(C)onfidence →** Misura **la qualità dell'evidenza a supporto delle
  stime di Reach e Impact** — non quanta analisi è stata fatta, non
  quanto è maturo il progetto. Si può aver condotto un'analisi molto
  approfondita e scoprire che il dato sottostante resta comunque debole.
  Scala:
  - 1-3: opinione o istinto, nessun dato a supporto
  - 3-6: dato aneddotico o singola fonte non verificata
  - 6-8: dato quantitativo verificato da almeno una fonte primaria
  - >8: dato quantitativo verificato da più fonti indipendenti, o
    validato con un esperimento

  La maturità dell'analisi (quanto scoping è stato fatto) è già
  rappresentata in Effort e nelle fasi successive — non va confusa con
  Confidence.

- **(E)ffort →** Quanto costerà implementarlo (persone, tempo, eventuali
  investimenti)? Si può sintetizzare come "numero di settimane necessarie,
  con le poche info a disposizione".

Nessuno di questi parametri richiede precisione chirurgica, ma avere
ordini di grandezza (scala 1:10) aiuta a comprendere cosa sia prioritario.

Il framework può essere usato male (valori falsi per farsi mettere
un'idea in priorità). **Questo è un grave atto di irresponsabilità
manageriale**, perché forza il perseguimento dell'interesse personale
anziché quello dell'azienda. Se uno stakeholder pensa di avere un asso
nella manica che il RICE non cattura, può invocare la Strategic Exception.
Ma se capita ogni settimana, non è più un'eccezione.

Essere in priorità 1 non significa che il team si fionda immediatamente
sull'attività: per interrompere l'agenda con un'attività immediata serve
sempre la Strategic Exception.

**Cosa succede a un'idea che non riesce ad avere un RICE.** Non tutte le
idee arrivano con abbastanza informazione per essere quotate subito —
spesso manca un dato da uno stakeholder (un numero, una conferma, una
priorità di business che solo lui conosce). Questo è normale e non va
forzato: **meglio un'idea che resta senza RICE in attesa di
un'informazione reale, che un RICE inventato per far procedere qualcosa**
(lo stesso principio del "nel dubbio, chiedi" applicato all'intake vale
qui). Il rischio non è avere idee in attesa — è **perderle di vista**: se
nessuno controlla periodicamente cosa è rimasto senza quotazione,
un'idea può restare ferma per mesi senza che nessuno se ne accorga. Per
questo il controllo va fatto ad ogni Backlog Refinement, non solo quando
qualcuno se ne ricorda.

*Principi Agile da incarnare in questa fase:*
- *Committenti e sviluppatori devono lavorare insieme quotidianamente per
  tutta la durata del progetto.*
- *I processi agili promuovono uno sviluppo sostenibile: un ritmo costante
  e mantenibile indefinitamente.*

**Checklist operativa**
- [ ] I quattro parametri RICE sono stati compilati (Reach, Impact, Confidence, Effort)?
- [ ] Reach è espresso come percentuale sulla popolazione rilevante della Product Line?
- [ ] Confidence riflette la qualità dell'evidenza, non la quantità di analisi svolta?
- [ ] Il referente tecnico ha validato la stima di Effort ad alto livello?
- [ ] Lo stakeholder proponente ha confermato Reach e Impact?
- [ ] L'idea è stata confrontata con le prime posizioni del backlog per coerenza del ranking?
- [ ] Se il RICE score è basso: è stata comunicata la motivazione allo stakeholder?
- [ ] Le idee ancora senza RICE sono state riviste all'ultimo Backlog Refinement, indipendentemente da quanto sembrino vecchie o marginali?
- [ ] Per le idee senza RICE da più di qualche settimana: è chiaro cosa manca e a chi è stato chiesto?

## Iniziative Mandatarie

*"Work expands so as to fill the time available for its completion." —
C. Northcote Parkinson*

Non tutte le iniziative nascono da un'idea che compete per priorità.
Alcune sono **imposte dall'alto** (una direttiva di leadership o board),
**marcate "critical"** indipendentemente da qualunque numero, o vincolate
a una **scadenza esterna fissa** che il framework non controlla
(compliance normativa, un contratto firmato con una data, un evento a
calendario). Chiamiamo queste iniziative **Iniziative Mandatarie**
(`mandate`).

Una Iniziativa Mandataria **non compete sul RICE** — non ha senso
calcolare Reach/Impact/Confidence/Effort per decidere se "vale la pena":
non è una domanda che il framework è chiamato a rispondere in questo
caso, la priorità è già stata data da chi ha il mandato per farlo. Ma
questo non significa che salti l'analisi: un'iniziativa mandataria
attraversa comunque Preliminary Analysis, Complete Analysis, PRD — deve
comunque essere capita, scoperta nelle sue implicazioni tecniche,
dimensionata. Salta solo la domanda "conviene farla ora rispetto al
resto?". La domanda a cui risponde invece è diversa e più urgente:
**"abbiamo abbastanza tempo prima della scadenza per farla bene?"**

Questa è la parte che il citazione di Parkinson coglie: senza un
meccanismo che forzi l'attenzione ad anticiparsi, il lavoro (o la sua
mancanza) si espande fino a riempire tutto il tempo disponibile — e la
scadenza si scopre quando è troppo tardi per rispettarla con qualità. Per
questo ogni Iniziativa Mandataria con una scadenza nota richiede una
stima di **lead time**: quante settimane servono, prima della scadenza,
per completare analisi, PRD e sviluppo. Questa stima **va fatta con un
referente tecnico**, con lo stesso spirito con cui l'Effort del RICE
viene validato ad alto livello nella prioritizzazione — non è un numero
che il PM inventa da solo.

**Chi può dichiarare un'iniziativa come mandataria?** Non c'è un vincolo
di ruolo esplicito, a differenza della Strategic Exception (che richiede
un'approvazione CEO/CPO-CTO): chiunque può proporla. Ma proprio per
questo, **chi la impone e perché** vanno sempre dichiarati esplicitamente
e mai presunti — non basta il tono o il ruolo del mittente per giustificare
il bypass del RICE. Il controllo non è a priori (nessun blocco), ma a
posteriori: ogni Iniziativa Mandataria resta visibile nei report di
roadmap con la sua scadenza e il suo stato, per chiunque — così un abuso
sistematico della categoria (usarla per bypassare il RICE senza un vero
mandato) diventa visibile con la stessa logica con cui il framework
intercetta le Strategic Exception ricorrenti.

**Verifica ad ogni Backlog Refinement.** Ogni ciclo di Backlog
Refinement è anche il momento in cui si controlla lo stato di avanzamento
di ogni Iniziativa Mandataria aperta rispetto alla sua scadenza: siamo in
tempo per iniziare l'analisi, siamo a ridosso, o è già tardi? Questo
controllo non è occasionale — deve accadere ogni settimana,
automaticamente, non solo quando qualcuno se ne ricorda. Un'iniziativa
mandataria senza una scadenza nota (il caso "critical ma senza data") non
è esente da questo controllo: resta in stato di verifica finché qualcuno
non la chiarisce, comparendo ogni settimana finché non viene risolta.

*Principi Agile da incarnare in questa fase:*
- *La nostra massima priorità è soddisfare il cliente rilasciando
  software di valore, fin da subito ed in maniera continua.*
- *A intervalli regolari il team riflette su come diventare più
  efficace, poi regola il proprio comportamento di conseguenza.*

**Checklist operativa**
- [ ] Chi impone l'iniziativa (`mandated_by`) e perché (`rationale`) sono stati dichiarati esplicitamente, non presunti?
- [ ] Se esiste una scadenza esterna: è stata registrata come data precisa, non come "presto" o "appena possibile"?
- [ ] È stata fatta una stima di lead time con un referente tecnico?
- [ ] L'iniziativa è stata controllata all'ultimo Backlog Refinement, indipendentemente da quanto sembri lontana la scadenza?
- [ ] Se la scadenza è a rischio: è stato segnalato esplicitamente al PM, non lasciato in un file che nessuno rilegge?
- [ ] L'iniziativa mandataria compare nei report di roadmap anche se non è ancora entrata in lavorazione?

## Salute delle NSM e Product Discovery

*"Success breeds complacency. Complacency breeds failure. Only the
paranoid survive." — Andy Grove*

Ogni PM è responsabile del successo di una North Star Metric (sezione
"Il lavoro del Product Manager"), e il prodotto è "promotore della
Product Discovery per identificare iniziative ad alto impatto sulle
NSM, indipendentemente dagli altri stakeholder". Questo principio esiste
già nel playbook — quello che manca, se non viene reso esplicito, è
**cosa succede quando la salute di una NSM peggiora davvero**.

**Il funzionamento ordinario è corretto così com'è.** Con molte
richieste (interne, di stakeholder, idee di team) è normale e sano che
la priorità segua il RICE score: è il meccanismo che tiene onesta la
prioritizzazione, discusso in "Ideas prioritization". La Discovery
continua a lavorare sullo sfondo, sempre attiva, senza bisogno di
interrompere nulla.

**Ma un deterioramento di una NSM chiave è un segnale di categoria
diversa.** Non è un'altra richiesta da mettere in coda e valutare col
RICE come le altre — è un'indicazione che la Product Line nel suo
complesso sta peggiorando, e nessuna quantità di idee ad alto RICE score
prese dal backlog compensa una NSM che va nella direzione sbagliata: se
il fondamentale peggiora, l'intero portfolio di iniziative rischia di
star ottimizzando le cose sbagliate. Per questo, quando succede, **il
focus della Product Discovery deve tornare esplicitamente sulla NSM in
difficoltà** — generare e prioritizzare iniziative (strategiche o
tattiche) mirate a recuperarla, anche rispetto a idee con RICE più alto
già in backlog.

Questo non è un override automatico del RICE, ed è coerente con lo
spirito del framework: **un segnale forte, non una decisione presa al
posto del PM.** La skill `nsm-watch` osserva le NSM (e altri KPI chiave)
di ogni Product Line nel tempo, calcola quando una sta degradando, e lo
porta all'attenzione del PM con la massima evidenza — in apertura di
ogni Backlog Refinement, prima di qualunque altra cosa. Sta al PM (col
team) decidere se e come riorientare la Discovery, tenendo traccia
esplicita di quella decisione.

**Distinzione rispetto alla Measurement** (sezione dedicata): la
Measurement verifica se l'ipotesi di **una singola iniziativa** ha reso
quanto sperato, dopo il rilascio. Questa sezione riguarda la salute
**aggregata** di una Product Line — indipendente da quale iniziativa
specifica la stia muovendo, osservata con continuità, non solo dopo un
rilascio.

*Principi Agile da incarnare in questa fase:*
- *A intervalli regolari il team riflette su come diventare più efficace,
  poi regola il proprio comportamento di conseguenza.*
- *Il prodotto è promotore della Product Discovery indipendentemente
  dagli altri stakeholder, auto-sottoponendosi agli stessi criteri di
  validazione.*

**Checklist operativa**
- [ ] Le NSM di ogni Product Line hanno baseline e target dichiarati, non solo un nome?
- [ ] Sono state riviste all'ultimo Backlog Refinement, in apertura, prima di ogni altra watch?
- [ ] Per le NSM in degrado: il riorientamento della Discovery è stato discusso esplicitamente, non ignorato perché "il backlog RICE è già pieno"?
- [ ] Le idee nate da un riorientamento di Discovery sono collegate alla NSM che intendono recuperare?
- [ ] Un allarme risolto è stato chiuso esplicitamente, con la motivazione, non lasciato a scomparire da solo?

## Product Backlog Refinement

*"Plans are useless, but planning is indispensable." — Dwight D.
Eisenhower*

Il team PM e IT stabilisce un giorno della settimana per una riunione che
pianifica le attività in cima alle priorità e che potrebbero avere spazio
nell'agenda del team nei prossimi giorni/settimane. Si usa la metafora
delle "iterazioni settimanali" per dare un'idea delle possibili date di
rilascio in termini di periodizzazione, non di giorno esatto.

**La riunione si apre guardando indietro, non avanti.** Prima di
discutere cosa entra in agenda, si controlla lo stato di ciò che è già
stato rilasciato e di ciò che ha una scadenza in avvicinamento: quali
iniziative stanno mostrando gli impatti attesi sulle metriche e quali
no (sezione "Measurement"), quali iniziative mandatarie richiedono
attenzione per la loro scadenza (sezione "Iniziative Mandatarie"), quali
idee restano senza RICE da troppo tempo (sezione "Ideas prioritization").
Solo dopo si passa a decidere le priorità del prossimo periodo — è più
facile prioritizzare bene quando si parte da un quadro aggiornato di cosa
sta già funzionando, invece di scoprirlo a posteriori.

> **Nota su Scrum vs Kanban.** Un approccio più Kanban (una cosa dopo
> l'altra, ben ordinate per priorità) è spesso preferibile a un
> commitment rigido per sprint: un Gantt che promette la feature X nello
> sprint Y comunica sfiducia verso l'autoresponsabilizzazione del team.
> Le persone vengono prima del tool. L'iterazione periodica (qui
> settimanale) resta utile per razionalizzare il lavoro, avere una
> sequenza cronologica, e migliorare la capacità di stima — senza
> scadere nel "fallimento dello sprint", che produce solo stime gonfiate
> per autodifesa.

L'output di questa riunione NON è il piano che sarà sicuramente
implementato la settimana successiva. **Serve per popolare un backlog di
cose in cui si crede**, più ampio dello spazio disponibile, che include
probabilmente attività già in corso.

Dal punto di vista pratico: si crea/aggiorna il contenitore
dell'iterazione corrente (release), con i tag chiave (goal e iniziativa
che si cerca di impattare, quando dovrebbe partire il lavoro), poi si
popola con le feature in priorità.

Il grosso del lavoro è già stato fatto al RICE scoring. Questa cerimonia
aggiunge: 1) consapevolezza di come sia andata l'iterazione precedente;
2) un'idea di cosa fare nel prossimo futuro. È anche l'occasione per una
mini-retrospettiva: perché è stato completato solo il 50% dell'iterazione
precedente? Quali impedimenti? Cosa è mancato a livello di informazioni?

**60 minuti**, meno se possibile. Bando alle discussioni troppo
dettagliate (sono oggetto della fase successiva). Va bene anche da remoto.

*Principi Agile da incarnare in questa fase:*
- *Consegniamo frequentemente software funzionante, preferendo i periodi
  brevi.*
- *A intervalli regolari il team riflette su come diventare più efficace,
  poi regola il proprio comportamento di conseguenza.*

Questa cerimonia va registrata in
`product/ceremonies/backlog-refinement/{YYYY-Www}/` — trascrizione grezza
in `source/`, esito strutturato in `decisions.yaml` (vedi
`framework/schema/ceremony-decisions.template.yaml`). Se la discussione
cambia il RICE di un'idea o produce un nuovo snapshot di roadmap, la
proposta passa da `product/approvals/pending/` prima di essere applicata.

**Checklist operativa**
- [ ] Il contenitore dell'iterazione corrente è stato creato/aggiornato con goal e iniziativa di riferimento?
- [ ] Le feature prioritarie sono state aggiunte all'iterazione?
- [ ] È stata fatta una mini-retrospettiva sull'iterazione precedente?
- [ ] Le feature in backlog sono ancora coerenti col RICE score? Qualcosa è cambiato?
- [ ] La cerimonia è stata loggata in `product/ceremonies/backlog-refinement/`?
- [ ] La durata è stata contenuta entro 60 minuti?

## Preliminary analysis

*"If you don't know why you are doing something, you shouldn't be doing
it." — W. Edwards Deming*

Il Backlog Refinement produce un elenco ordinato di feature per
l'iterazione che parte formalmente qualche giorno dopo. Il cambiamento
significativo: quello che era in cima all'elenco può ancora cambiare. Il
team potrebbe a breve iniziare a sviluppare, ma probabilmente mancano
molte informazioni.

È il momento di rispondere ai quesiti chiave che guidino la comprensione
del problema. Finora il Prodotto ha accettato senza troppe domande le
proposte degli stakeholder (o le proprie intuizioni). Inizia la fase di
messa in discussione.

Il primo obiettivo è compilare il box del **Why**. Tempo stimato: 15
minuti. In 15 minuti bisogna capire se la richiesta ha coerenza con la
strategia globale. **Se il problema (o il perché esiste) è in conflitto
con la strategia, va valutato l'abort dell'iniziativa.**

*Principi Agile da incarnare in questa fase:*
- *La nostra massima priorità è soddisfare il cliente rilasciando
  software di valore, fin da subito ed in maniera continua.*
- *La semplicità — l'arte di massimizzare il lavoro non svolto — è
  essenziale.*

> **Esempio.** Durante l'analisi preliminare di un quick-win apparente,
> il PM si accorge che il razionale addotto (efficienza di breve termine)
> non regge a un'analisi "5 whys": la vera motivazione è una
> ricalibrazione strategica più ampia, non ancora comunicata a tutto il
> team. Il RICE originale va rivisto perché basato su un ROI parzialmente
> distorto — e il "who" dell'iniziativa risulta diverso da quanto
> ipotizzato. Il PM porta la cosa a un referente strategico prima di
> decidere se procedere. *(Versione completa: Cronache Episodio 4.)*

**Checklist operativa**
- [ ] Il Why è stato compilato: qual è il problema reale?
- [ ] L'iniziativa è allineata alla strategia aziendale?
- [ ] Ci sono segnali tecnici evidenti che potrebbero cambiare il ROI?
- [ ] La decisione di procedere o abortire è stata registrata?
- [ ] Se si procede: il team tech è stato informato che l'analisi completa inizierà a breve?

## Complete analysis

*"Without data, you're just another person with an opinion." — W.
Edwards Deming*

Analisi di dettaglio che completa il What e definisce una GTM Strategy
(quando/come comunicarlo). Il go-to-market varia molto in base a portata
della feature e utenti coinvolti — da "trasparente per l'utente" a
"cambiamento epocale che richiede UAT, hype, comunicazioni strutturate".

### PRD sizing: il principio dell'A3 Thinking

Un PRD non è il posto dove si documenta tutto ciò che si sa su
un'iniziativa. È il posto dove si documenta **ciò che serve per prendere
una decisione o per implementare**, nella quantità minima che permette a
chi legge di farlo in un unico passaggio di attenzione. Principio
ispirato all'A3 Thinking (Toyota): non "un documento corto" in senso
letterale, ma un vincolo di spazio che *forza* chiarezza.

**Regola pratica.** Un PRD dovrebbe poter essere letto e verificato in
un'unica iterazione, in un tempo paragonabile a due facciate A4 in PDF.
Se il contenuto necessario supera questa soglia, la risposta non è
comprimere la prosa, ma **spaccare l'iniziativa in più PRD**.

**Il criterio di split è il problema, non il conteggio delle pagine.** Un
PRD si divide quando il What genera sotto-problemi con rischio tecnico,
owner o stakeholder chiaramente distinti — non quando "è arrivato a
pagina 3". Tagliare per lunghezza produce frammenti che non si capiscono
da soli; tagliare lungo le cuciture naturali del problema produce
documenti verticali, ciascuno giudicabile senza dover leggere gli altri.

**Sequenza di lettura ≠ sequenza di rilascio.** Se un'iniziativa produce
più PRD, ognuno deve dichiarare esplicitamente entrambe, perché non
coincidono per definizione.

**Cosa NON deve comparire in un PRD, perché vive altrove:**
- **Il RICE score** — se un'iniziativa ha un PRD, il RICE è già stato
  deciso in fase di prioritizzazione. Il PRD riporta solo un riferimento
  (link) all'idea di origine.
- **Framework generali già formalizzati altrove** (Business Model Canvas,
  matrice GTM, glossario di dominio, Customer Personas). Il PRD cita la
  scelta specifica fatta per quel caso, con link al documento canonico.

Lo scheletro consigliato è in `framework/schema/prd.template.md`.

---

Il processo va descritto anche con diagrammi di flusso dove utile — non è
uno strumento specifico di questo metodo, solo una raccomandazione. Può
essere opportuno citare il Domain Driven Design: dare nomi alle cose è
importante, sia perché influenza come il team di tecnologia interpreta
una parola chiave, sia perché quel termine diventa gergo aziendale. Non
esiste un dizionario tecnico separato da quello di business: c'è un solo
vocabolario condiviso. Il glossario di dominio di un'istanza specifica va
mantenuto in `product/reference/` (locale, non nel framework — è
specifico del business di quell'istanza).

Ultima parte dell'analisi: quali **metriche** impattare. Le KPI scelte
hanno due funzioni: 1) stabilire qualcosa di misurabile fin da subito che,
verificandosi, produca l'impatto atteso; 2) orientare l'How — se la
metrica dice che ci sarà impatto su un conversion rate, ci si aspetta che
la UI/UX consideri questa informazione. **Le metriche orientano i
comportamenti del team.**

Si associa alla KPI un valore di partenza (baseline) e uno di destinazione
(target). Il PM è responsabile di definire ed osservare l'andamento nel
tempo fino alla stabilizzazione, ed è un utente sufficientemente autonomo
degli strumenti di analytics dell'istanza da costruire da solo dashboard
per tenere sotto controllo le feature rilasciate di recente.

Rischio anche in questa fase: le KPI potrebbero non essere sane o
disponibili; il ROI si rivela diverso da quanto ipotizzato; un
approfondimento potrebbe cambiare il RICE Score.

*Principi Agile da incarnare in questa fase:*
- *La nostra massima priorità è soddisfare il cliente rilasciando
  software di valore, fin da subito ed in maniera continua.*
- *Il software funzionante è il miglior metro di misura del progresso.*

**Checklist operativa**
- [ ] Il What è definito: quali sono le funzionalità o i cambiamenti attesi?
- [ ] Il PRD rispetta il vincolo A3 (circa due facciate A4 in PDF)? Se no, è stato spaccato lungo le cuciture del problema?
- [ ] Se il PRD fa parte di una sequenza: sono dichiarate separatamente sequenza di lettura e di rilascio?
- [ ] Il RICE NON è ripetuto nel PRD, solo referenziato con link all'idea di origine?
- [ ] I framework generali sono citati per riferimento, non ridescritti?
- [ ] Le KPI di successo hanno un valore baseline?
- [ ] Il target della KPI è stato definito e condiviso con lo stakeholder?
- [ ] La GTM strategy è stata discussa con chi presidia il marketing/comunicazione?
- [ ] L'How di alto livello è stato abbozzato con il team tech?
- [ ] Il ROI atteso è ancora coerente col RICE originale? Se no, il ranking è stato aggiornato nella fonte di verità?

## Roadmap update & Iteration planning

*"You don't need to be perfect. You need to be fast and learning." —
Eric Ries*

Qualche giorno dopo il Backlog Refinement, il team ha le informazioni per
confermare o riorganizzare l'agenda concreta di tecnologia e design.
Questo meeting fissa un'agenda di appuntamenti e scadenze di breve
termine. Il team di tecnologia ora deve decidere concretamente cosa fare,
concentrandosi sulla parte operativa dell'How:

- Servono flussi visivi o mockup? Quando saranno pronti?
- In che giorno si approvano i flussi UX/UI? Servono per le User Stories?
- I tempi sulla roadmap sono coerenti con le conversazioni in corso, o
  serve assicurarsi che non si generino aspettative sbagliate?

Il team di tecnologia comunica in termini di Rischio-Rendimento (80/20):
"se cambiamo questo requisito, anziché 10 giorni facciamo tutto in 2.
Siamo sicuri che quella parte sia così importante?" Nessuno ha la sfera
di cristallo — ogni feature è un'ipotesi con cui si spera di creare un
impatto. Se il ritorno è basso ma l'investimento alto, il rischio è
irragionevole. Anche con rendimento atteso altissimo, contenere il
rischio resta una buona cosa: fail fast.

*Principi Agile da incarnare in questa fase:*
- *Accogliamo cambiamenti anche a fasi avanzate. I processi agili
  sfruttano il cambiamento a favore del vantaggio competitivo del
  cliente.*
- *Le architetture, i requisiti e la progettazione migliori emergono da
  team che si auto-organizzano.*

Anche questa cerimonia va registrata in
`product/ceremonies/roadmap-iteration-planning/{YYYY-Www}/`, con lo stesso
pattern trascrizione + decisioni strutturate.

**Checklist operativa**
- [ ] Ogni User Story ha criterio di accettazione chiaro?
- [ ] Il team tech ha fatto la valutazione 80/20 su ogni storia?
- [ ] I task sono caricati nel tracker di esecuzione e assegnati?
- [ ] L'agenda tiene conto del flusso di manutenzione ordinaria/debito tecnico?
- [ ] Le date di rilascio stimate sono coerenti con quanto discusso?
- [ ] Gli stakeholder chiave sono stati aggiornati sulle aspettative di delivery?
- [ ] La capacità dedicata a platform (debito tecnico/devops) questa iterazione è stata dichiarata esplicitamente, non lasciata implicita?

## Product Design, development and rollout

*"Simplicity is the ultimate sophistication." — Leonardo da Vinci*

L'agenda del team di tecnologia emerge dalla raffinazione delle proposte
di prodotto. Quando un'attività è matura, passa dalla roadmap di prodotto
al backlog effettivo del team tech (tipicamente prioritizzato secondo
Kanban).

### Daily Standup

Il team si riunisce ogni giorno per un massimo di 15 minuti, con
riferimento visivo alla board del tracker di esecuzione, scorrendo dalla
colonna più vicina al rilascio verso quella di sviluppo. Tre domande per
ticket: cosa completato ieri, cosa in agenda oggi, cosa blocca
l'avanzamento. L'obiettivo non è un report di status ma identificare
impedimenti e assegnare un owner per risolverli entro la giornata. Il PM
partecipa attivamente: porta contesto di priorità e business, segnala se
un blocco tecnico impatta la roadmap.

> **Definizione di "Done".** Una card è Done quando il codice ad essa
> relativo è **in produzione**. Punto. Non è Done perché ha prodotto
> l'output o l'outcome atteso: quella verifica appartiene a Measurement,
> non alla Definition of Done. Tenerli separati evita che una card resti
> aperta indefinitamente in attesa che una metrica di business si muova.
> "Done" risponde a "abbiamo consegnato?", non a "ha funzionato?".
>
> **Nota operativa per una nuova istanza.** In assenza di una DoD
> dichiarata dal tech lead, una bozza può essere derivata ispezionando la
> board reale del tracker di esecuzione (colonne, transizioni, campi
> obbligatori per chiudere una card). Va trattata come **ipotesi
> osservata dal comportamento attuale del team, non come DoD approvata**
> — va confermata esplicitamente prima che il sistema la tratti come
> regola vincolante per comunicazioni automatiche verso gli stakeholder.

*Principi Agile da incarnare in questa fase:*
- *La continua attenzione all'eccellenza tecnica e la buona progettazione
  esaltano l'agilità.*
- *Le architetture, i requisiti e la progettazione migliori emergono da
  team che si auto-organizzano.*

## Measurement

*"In God we trust. All others must bring data." — W. Edwards Deming*

Gli obiettivi sono stati raggiunti? Servono altre iterazioni o si chiude
il flusso? Dipende dal rischio-rendimento. C'è debito tecnico da gestire?
Va annotato. Va buttato tutto? Capita: se è stato fatto il giusto MVP, non
ci sarà rammarico.

Si presentano i risultati, si celebrano i successi con i dati. Quando va
storto, si celebra di aver imparato. Nessuna sfera di cristallo: solo la
ricerca di un circolo virtuoso.

**Il rischio non è misurare male — è dimenticarsi di misurare.** Un'idea
consegnata "Done" (codice in produzione, playbook "Product Design,
development and rollout") non risponde da sola alla domanda se ha
funzionato: qualcuno deve tornare a controllare le sue KPI, e "qualcuno
tornerà a controllare" senza un meccanismo esplicito diventa in pratica
"nessuno lo farà mai". Per questo il controllo va integrato nel ciclo
ricorrente, non lasciato alla buona volontà: **ad ogni Backlog
Refinement, prima ancora di guardare cosa entra in agenda, si controllano
le iniziative già rilasciate** — quali stanno mostrando l'impatto atteso,
quali sono ancora troppo giovani per giudicarle, quali non lo stanno
mostrando e meritano un follow-up o una chiusura consapevole. Questo
tracciamento, accumulato settimana dopo settimana in Git accanto ai PRD,
è ciò che nel tempo permette di vedere pattern e decidere con più
sicurezza dove veicolare gli investimenti futuri — non solo "abbiamo
consegnato tanto", ma "quello che abbiamo consegnato ha reso".

**Non tutte le iniziative hanno una metrica di business.** Una richiesta
di mera compliance normativa (spesso un'Iniziativa Mandataria — vedi
sezione dedicata) non nasce con l'ipotesi "questo migliorerà la metrica
X": nasce da un obbligo. Forzare una metrica proxy solo per riempire la
sezione Metriche del PRD produce dati inutili nel tempo — meglio
dichiarare esplicitamente che non c'è nulla da misurare.

Questo però non significa che il cantiere resti aperto per sempre senza
nessuno che se ne occupi. Serve comunque un **atto esplicito di
chiusura/accettazione**: qualcuno, ad un certo punto, deve dire "questa
iniziativa è chiusa" — che ci sia una KPI che si è mossa (o non si è
mossa) come sperato, o che non ci sia proprio nulla da misurare (il caso
compliance). La chiusura non è un'inferenza automatica basata sui dati:
è una decisione del PM, tracciata con data e motivazione, che smette di
far riapparire quell'iniziativa negli alert successivi. Senza questo
atto esplicito, un'iniziativa senza KPI rischia di restare per sempre
un'eccezione che nessuno chiude formalmente.

*Principi Agile da incarnare in questa fase:*
- *A intervalli regolari il team riflette su come diventare più efficace,
  poi regola il proprio comportamento di conseguenza.*
- *Il software funzionante è il miglior metro di misura del progresso.*

**Checklist operativa**
- [ ] Le KPI definite in Complete Analysis sono state misurate?
- [ ] Il valore attuale è stato confrontato col target definito in origine?
- [ ] L'esito è stato presentato al team e agli stakeholder?
- [ ] Se il target non è stato raggiunto: è stato avviato un processo di analisi causa-effetto?
- [ ] Il debito tecnico generato è stato annotato?
- [ ] Le nuove idee emerse dalla misurazione sono state aggiunte al bucket?
- [ ] Le iniziative rilasciate da tempo sufficiente sono state riviste all'ultimo Backlog Refinement, in apertura, non come ripensamento a fine riunione?
- [ ] Per le iniziative il cui impatto non convince: è stata presa una decisione esplicita (follow-up o chiusura), invece di lasciarle in un limbo?
- [ ] Per le iniziative senza una metrica di business (es. compliance): è dichiarato esplicitamente il perché, invece di una metrica proxy inventata?
- [ ] Ogni iniziativa rilasciata ha, prima o poi, un atto esplicito di chiusura/accettazione — non resta aperta indefinitamente senza che nessuno se ne occupi?

---

# Come gestire le frizioni con gli stakeholder

Il framework protegge il team e garantisce qualità delle decisioni, ma
opera in un'azienda dove non tutti lo conoscono e la pressione esterna è
reale. Questa sezione descrive come PM e team dovrebbero comportarsi
quando il contesto esterno non rispetta le regole del gioco.

## Il principio base: boundaries con empatia

Proteggere il processo non significa essere rigidi. Significa essere i
custodi della qualità delle decisioni nell'interesse dell'azienda. Ogni
volta che un PM cede a una pressione non strutturata, non fa un favore
allo stakeholder: assume un rischio non quantificato, sottrae risorse a
priorità già valutate, e segnala al team che il processo è negoziabile.
Il confine va tenuto con fermezza e rispetto, spiegando sempre il perché.

## Scenario 1: lo stakeholder che bypassa il processo

*"Ho bisogno che il team faccia questa cosa entro venerdì. È urgente." —
via chat, fuori orario.*

Comune, specialmente nelle fasi iniziali. La risposta giusta non è né
ignorare né cedere immediatamente.

**Come rispondere:** ringrazia, chiedi tempo per valutare l'impatto
sull'agenda, poi rispondi con dati: "Il team ha due attività critiche in
corso. Se inseriamo questo ora, una delle due slitta. Quale ha la
priorità più alta per il business in questo momento? Possiamo
formalizzarlo come Strategic Exception se necessario." Non si dice no, ma
si costringe lo stakeholder a una scelta consapevole di cui si prende la
responsabilità.

## Scenario 2: la Strategic Exception che diventa abitudine

*"Lo so che è la terza volta questo mese, ma questa volta è davvero
importante."*

Se una Strategic Exception viene invocata ogni settimana, ha smesso di
essere un'eccezione. Segnale che il processo non è ancora interiorizzato,
o che la struttura delle priorità non è condivisa a livello aziendale.

**Come rispondere:** tieni traccia di ogni Strategic Exception (data,
richiedente, oggetto, esito). Dopo tre o quattro episodi ravvicinati,
porta il pattern all'attenzione del management non come lamentela ma come
analisi: costo in giorni di sviluppo sottratti alla roadmap, richiesta di
capire se riflette una priorità da incorporare nel processo ordinario.

## Scenario 3: lo stakeholder che non capisce perché la sua idea non è in cima

*"Ho proposto questa cosa tre mesi fa e non è ancora stata fatta."*

**Come rispondere:** la trasparenza è la migliore difesa. Mostra il RICE
score della sua idea rispetto alle altre, non come giustificazione ma
come condivisione del ragionamento. "Se pensi che il punteggio non
rifletta il vero valore, parliamone: magari ci sono informazioni che non
ho."

## Scenario 4: la pressione dal top

*"Il CEO ha detto in riunione che vuole questa feature per fine mese."*

Richiede il massimo equilibrio: mai ignorare un segnale dall'alto, ma
altrettanto sbagliato eseguire ciecamente senza capire il contesto e
comunicare i trade-off.

**Come rispondere:** prima di muovere risorse, cerca un confronto diretto
con chi ha trasmesso la richiesta. Obiettivo: capire se è direttiva
strategica ferma o idea espressa in un momento di conversazione. Poi
porta i trade-off in modo chiaro: "possiamo farlo entro fine mese, per
farlo dobbiamo spostare X. Confermi che è la scelta giusta?" La
responsabilità della decisione torna dove deve stare.

## Il registro delle frizioni

Indipendentemente dallo scenario, il PM dovrebbe tenere un registro
informale delle frizioni ricorrenti: chi, quando, su cosa, come è stato
gestito, esito — vedi `product/reference/friction-log.yaml`. Non per
creare conflitti, ma per due ragioni pratiche: i pattern emergono e
diventano dati con cui migliorare il processo o la comunicazione verso
certi stakeholder; e se il processo viene messo in discussione, il PM ha
evidenze concrete su come il team ha operato e perché.

---

# Glossario (metodo)

Termini di processo/framework, riusabili in qualsiasi istanza. I termini
di dominio (nomi di ruoli utente, prodotti specifici, unità di misura di
business) vanno definiti localmente in `product/reference/` — vedi
l'esempio in `examples/*/docs/` per un caso reale.

**RICE** — Framework di prioritizzazione basato su quattro parametri:
Reach (quante persone impatta), Impact (quanto vale in termini di
business), Confidence (quanto si è sicuri delle stime), Effort (quanto
costa implementarlo). Il punteggio finale è R × I × C / E.

**NSM — North Star Metric** — Il KPI più importante che ogni PM presidia
per la propria Product Line.

**Strategic Exception** — Meccanismo che consente a una richiesta di
bypassare il normale processo di prioritizzazione, su approvazione di un
livello dirigenziale definito dall'istanza. Deve essere rara e motivata.

**Iniziativa Mandataria (mandate)** — Iniziativa che bypassa il RICE
perché imposta dall'alto, marcata "critical" da leadership, o vincolata a
una scadenza esterna fissa — non l'analisi, che resta necessaria. A
differenza della Strategic Exception, non richiede un'approvazione di
ruolo specifico, ma richiede sempre di dichiarare esplicitamente chi la
impone e perché, e una stima di lead time verificata ad ogni Backlog
Refinement. Vedi sezione "Iniziative Mandatarie".

**Platform** — Debito tecnico o attività devops pura. Bypassa il RICE
perché la priorità è giudizio del team tech dentro una capacità protetta,
non valore di business né autorità esterna — a differenza sia delle idee
normali (RICE) sia delle Iniziative Mandatarie (autorità esterna). Non è
lavoro invisibile: entra in roadmap come qualunque altra iniziativa
quando rilevante, e la capacità che assorbe è tracciata esplicitamente
(`capacity_allocation` in ogni snapshot settimanale) per rendere
consapevole il bilanciamento con la roadmap principale.

**Allarme NSM (NSM Alert)** — Segnale generato quando una North Star
Metric (o altro KPI chiave di Product Line) mostra un trend di
peggioramento, osservato nel tempo indipendentemente da quale iniziativa
specifica la stia muovendo. A differenza del `measurement_status` di una
singola iniziativa, un allarme NSM dovrebbe riportare il focus della
Product Discovery sulla metrica in difficoltà, anche rispetto a idee con
RICE più alto in backlog — non un override automatico, ma un segnale
con la massima evidenza che richiede una decisione esplicita del PM. Vedi
sezione "Salute delle NSM e Product Discovery".

**`context/`** — Cartella alla radice dell'istanza (non sotto `product/`)
che raccoglie la comprensione del business/azienda (modello di business,
finanza, organizzazione, mercato) come file Markdown tracciati, citando
sempre la fonte del materiale grezzo da cui derivano. Alimentata e fatta
evolvere dalla skill `context-intake`. Nessun file grezzo (PDF, slide,
docx) vi persiste: solo la trascrizione. Vedi sezione "Contesto aziendale
(`context/`)".

**Ideas Bucket** — Il repository dove vengono raccolte tutte le idee,
richieste e segnalazioni prima di essere valutate. Non è una coda di
lavoro: è un archivio non ordinato da cui emergono le priorità.

**Product Backlog Refinement** — Cerimonia settimanale in cui PM e tech
lead allineano le priorità e preparano il backlog per l'iterazione
successiva. Non è una pianificazione ferma: è una fotografia aggiornata
delle intenzioni.

**Why / What / How / When** — I quattro assi dell'analisi di ogni
feature. Why: il problema reale. What: cosa si costruisce. How: come lo
si costruisce. When: la GTM strategy.

**A3 Thinking** — Principio (Toyota) per cui un documento di decisione va
vincolato a uno spazio ridotto per forzare chiarezza e separare
l'essenziale dal contesto. Qui applicato al dimensionamento dei PRD: circa
due facciate A4 in PDF; se serve più spazio, si spacca lungo le cuciture
del problema, non per conteggio di pagine.

**Fail Fast** — Principio lean che incoraggia a testare le ipotesi con il
minimo investimento possibile, per imparare velocemente e correggere la
rotta prima di aver speso risorse significative.

**DDD — Domain Driven Design** — Approccio alla progettazione software
che mette al centro il linguaggio e i concetti del dominio di business.
Non esiste un dizionario tecnico separato da quello aziendale: c'è un
solo vocabolario condiviso.

**80/20 (Principio di Pareto)** — L'80% del valore si ottiene spesso col
20% dello sforzo. Prima di implementare una feature complessa, chiedersi
sempre se esiste una versione più semplice che produce la maggior parte
del valore.

**Kanban** — Metodo di gestione visiva del lavoro in colonne che
rappresentano gli stati del flusso, con l'obiettivo di limitare il lavoro
in corso (WIP) per aumentare la velocità di completamento.

**Standup Meeting** — Cerimonia quotidiana di allineamento, massimo 15
minuti. Non un report di status ma un momento di sincronizzazione
operativa.

**Epica** — Unità di lavoro di alto livello che raggruppa un insieme di
User Story correlate attorno a un obiettivo comune, troppo ampia per una
singola iterazione.

**User Story** — Descrizione di una funzionalità dal punto di vista
dell'utente finale: *"Come [tipo di utente], voglio [azione], in modo da
[beneficio atteso]."* Accompagnata da criteri di accettazione chiari.

## Ruoli

**PM — Product Manager** — Responsabile del successo di una Product Line
e della relativa North Star Metric. Governa il processo dall'idea al
rilascio, facilita le cerimonie, interfaccia tra business e tecnologia.

**PMM — Product Marketing Manager** — Responsabile dell'allineamento con
Sales e Operations sulla go-to-market strategy. Porta la voce del mercato
nel processo di prodotto e gestisce la comunicazione esterna.

**Designer (UI/UX)** — Responsabile dei flussi UI/UX, trasversale sulle
Product Line.

**Team di tecnologia** — Implementa le soluzioni. Partecipa attivamente
alle cerimonie di analisi e pianificazione, non solo allo sviluppo. La
sua voce su rischio tecnico ed effort è fondamentale già nelle fasi di
analisi.
