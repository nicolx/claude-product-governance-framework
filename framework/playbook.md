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
`nsm-watch`, `deadline-watch`), qui non si tratta di un fatto mai presunto ma di
un'interpretazione di materiale grezzo — per questo la conferma in
conversazione è sempre richiesta, anche se non serve la coda `pending/`
completa (non è una decisione di priorità).

## Sincronizzazione dell'istanza (`origin`)

Un'istanza è un repository git **condiviso** dal team di prodotto. Il
repository *è* la fonte di verità: idee, RICE, PRD, cerimonie e coda di
approvazione vivono lì, non nella testa di chi ha lanciato l'ultima
skill. Perché questo regga con più persone sulla stessa istanza (o la
stessa persona da macchine diverse), il clone locale e il remote `origin`
devono restare allineati — altrimenti si ricreano idee già esistenti, si
quota un RICE su dati vecchi, si genera uno snapshot di roadmap a cui
manca metà del quadro.

Questa sincronizzazione è **automatica, demandata alle skill e agli
hook**, non alla memoria del PM:

- **Pull** (`git pull --ff-only` su `origin`): all'avvio di ogni sessione
  Claude Code (hook `SessionStart`) e all'inizio delle skill che
  dipendono dal quadro completo — `inbox-triage`, `roadmap-snapshot`,
  `pending-approval`, `jira-sync` (pull), e le watch (`nsm-watch`,
  `mandate-watch`, `deadline-watch`, `rice-watch`, `measurement-watch`).
- **Commit + push**: come ultimo passo di ogni skill che scrive stato
  tracciato (`idea-intake`, `inbox-triage`, `rice-update`, `prd-draft`,
  `log-ceremony`, `roadmap-snapshot`, `pending-approval`,
  `context-intake`, `jira-sync`, le watch, `init-governance-project`). Il
  commit è **immediato** dopo la scrittura: è ciò che tiene il working
  tree pulito e rende sicuri i pull successivi.

Vincoli non negoziabili del meccanismo:

- **Solo fast-forward.** Un pull che non può fast-forward NON viene
  risolto automaticamente: la skill avvisa che c'è lavoro locale
  divergente e si ferma. Nessun merge, rebase o stash automatico.
- **Non blocca mai.** Offline, `origin` irraggiungibile, branch senza
  upstream: la skill lo segnala e procede con lo stato locale. Il commit
  resta locale e `check-unpushed.sh` (hook `Stop`) lo ricorda a fine
  sessione.
- **Solo `origin`, solo un'istanza.** Gli hook e l'helper fanno no-op se
  manca `.governance/config.yaml`, o se `origin` è il repo canonico — il
  canonico non viene mai toccato. Gli aggiornamenti del *metodo* sono
  un'altra cosa: remote `upstream`, skill `sync-framework-updates`,
  revisione umana.
- **Disattivabile per istanza.** `.governance/config.yaml`, blocco
  `sync:` con `auto_pull` / `auto_push` — default `true` entrambi; una
  chiave a `false` spegne quel lato (per un'istanza mono-PM o con un
  setup git particolare).

Implementazione: helper unico `.claude/hooks/governance-sync.sh`
(`pull` | `push "<messaggio>" [path...]`), richiamato dagli hook e come
passo esplicito delle skill.

**Cosa fare quando vedi l'avviso "impossibile allineare in fast-forward".**
Hai commit locali che il team non ha ancora, e `origin` è andato avanti:
non è un errore, è il segnale che due persone hanno lavorato in
parallelo. Esegui `git pull --rebase origin` (riscrive i tuoi commit
locali sopra quelli del team), controlla i conflitti sui file condivisi
(`product/reference/`, snapshot di roadmap), poi `git push`. Sulle
`idea.yaml` i conflitti sono quasi sempre banali: la convenzione
cartella-per-idea e `rice_history` append-only li rende rari e locali.

## Alimentazione del bucket delle idee

*"The best way to have a good idea is to have a lot of ideas." — Linus
Pauling*

Ogni giorno arrivano email, conversazioni, riflessioni a voce alta. Non
può stare tutto nella mente del PM: va cristallizzato in un archivio, per
contenere lo stress e la pressione esterna — e perché è molto raro che
un'idea sia immediatamente azionabile.

Le idee devono essere inserite in modo che sia facile capire:

- Da chi arrivano e di cosa si tratta, con un titolo e una **`summary`**
  di una riga in linguaggio piano — cosa c'è da fare, comprensibile
  senza aprire il materiale di origine (il titolo è spesso solo l'oggetto
  di una mail, che non basta a orientarsi nella lista ordinata)
- Una descrizione che spieghi il contesto e permetta di risalire alle
  informazioni essenziali (citazioni email, documenti già disponibili)
- Una categoria (Product Line, tipo di richiesta) per semplificare i
  filtri

> *Pattern pratico consigliato: usa l'oggetto della mail/segnalazione come
> titolo dell'idea, il contenuto (con allegati) come dettaglio in
> `source/`, e scrivi a mano la `summary` leggibile. Rende più semplice
> risalire alla fonte e non perde informazione.*

**Non tutto quello che arriva è un'idea.** Una parte del materiale
(richieste di supporto tecnico, temi fuori dal perimetro del team, cose
già coperte altrove) va **scartata al triage** — `status: declined`, con
`decline_reason` in una riga. Non si scarta in silenzio: si crea comunque
il record (archivio/audit, distinto da `aborted` che è "avviata poi
interrotta"), e si prepara una bozza di risposta al richiedente (vedi
sezione successiva). L'automazione propone lo scarto, il PM conferma — è
un giudizio, non un fatto.

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
- [ ] L'idea è stata registrata con titolo, `summary` leggibile, proponente, descrizione del contesto?
- [ ] Se è un bug: è già stato aperto un ticket con impatto stimato nel tracker di esecuzione?
- [ ] Se è una Strategic Exception: è stata approvata al livello richiesto (o è chiaro che è ancora in attesa di conferma)?
- [ ] Se non è un'idea: è stata scartata come `declined` con `decline_reason`, non cancellata né lasciata in inbox?
- [ ] L'idea è stata categorizzata per Product Line?
- [ ] È stata preparata (e mostrata al PM) una bozza di risposta al richiedente, quando c'è un richiedente esterno?
- [ ] Se arriva via canale informale (chat, voce): è stata trasferita nell'archivio prima di qualsiasi altra azione?

## Chiudere il loop col richiedente

*"The single biggest problem in communication is the illusion that it has
taken place." — George Bernard Shaw*

Il framework è bravo a catturare, classificare e prioritizzare — ma
un'email arrivata da uno stakeholder, se non riceve risposta, lascia il
richiedente al buio: non sa se è stata vista, se serve altro, quando
succederà qualcosa. La delusione (e la frizione) nasce lì, non dal RICE
score.

Per questo **ogni intake con un richiedente esterno identificabile
produce una bozza di risposta** — scritta dall'automazione, rivista e
inviata *a mano* dal PM (mai invio automatico), salvata sull'idea in
`requester_reply`. Non passa da `product/approvals/pending/`: è una
cortesia 1:1 con l'idea, non una decisione. Se l'idea nasce dal PM stesso
o da un brainstorm interno, non c'è nessuno da avvisare e la bozza si
salta.

Il contenuto dipende da come è stata classificata:

- **Idea normale** — la bozza copre tre cose: (a) presa in carico; (b)
  **serve una riunione di approfondimento col richiedente per fare un
  RICE serio?** Spesso sì — un dato che solo lui ha, un problema da
  inquadrare meglio. Se sì, va segnato in modo strutturato
  (`rice_status.deep_dive`) perché `rice-watch` continui a ricordarlo
  finché il meeting non avviene; (c) **una prima ipotesi onesta di
  quando** potrebbe essere prioritizzata, letta dal backlog ordinato
  attuale ("con N idee davanti a RICE più alto e nessuna quotazione
  ancora, realisticamente non prima di…") — una forbice, mai una data,
  mai una promessa.
- **Strategic Exception invocata all'intake** — "accolta su canale
  privilegiato, **in attesa di conferma** dall'autorità richiesta"
  (CEO/CPO-CTO): non si dice "approvata" finché non lo è. Si esplicita
  l'impegno del PM a restituire feedback sull'esito (è un dovere del
  metodo, non un favore).
- **Scarto (`declined`)** — si spiega con rispetto perché il team di
  prodotto non è il posto giusto per quella richiesta, e — se sensato —
  si indirizza altrove. Meglio un "no" chiaro e motivato subito che un
  silenzio che il richiedente interpreta come "ci stanno lavorando".
- **`needs_clarification`** — la bozza pone le domande precise che
  servono a sbloccare la classificazione (è già `clarification.draft_message`).

*Principi Agile da incarnare in questa fase:*
- *Una conversazione faccia a faccia (o almeno una risposta) è il modo
  più efficiente per comunicare.*
- *Accogliamo i cambiamenti nei requisiti: chi ci scrive va tenuto nel
  ciclo, non lasciato fuori.*

**Checklist operativa**
- [ ] Ogni idea con un richiedente esterno ha una `requester_reply.draft` pronta?
- [ ] Nessuna bozza è stata inviata in automatico — tutte mostrate al PM per revisione?
- [ ] Per le idee normali: la bozza dice se serve un meeting di approfondimento, e in tal caso `rice_status.deep_dive` è compilato?
- [ ] Per le idee normali: la prima ipotesi di timing è una forbice onesta, non una data né una promessa?
- [ ] Per le Strategic Exception: la bozza dice "in attesa di conferma", non "approvata", finché non lo è?

## Intake storico e roadmap pre-esistente

*"You can't cross the sea merely by standing and staring at the water." —
Rabindranath Tagore*

Il resto di questa sezione assume materiale che arriva alla spicciolata,
un'email o una segnalazione alla volta. Quando un'istanza nasce su un team
**già operativo**, l'intake iniziale deve digerire in un colpo solo due
tipi di materiale che quell'assunzione non copre — ed è la norma, non
l'eccezione, per ogni nuova istanza.

**1. Backlog storico accumulato** (idee e segnalazioni raccolte per mesi
in uno strumento esterno — Aha!, Jira, un foglio di calcolo — e mai
passate dal framework). Trattalo come materiale normale via
`inbox-triage`, con un solo accorgimento: usa la **data di creazione
originale** dell'elemento (non la data dell'intake) per `created_at`,
così `rice-watch`, `mandate-watch` e `measurement-watch` calcolano
correttamente da quanto tempo qualcosa è fermo o in produzione. Un
backlog di cento voci datate tutte "oggi" nasconde esattamente le idee
che sono rimaste indietro.

**2. Iniziative già decise da leadership prima del framework** (una
roadmap pre-esistente con GO / NO GO / POSTPONED già assegnati). Non
hanno mai avuto un RICE, ma non è onesto trattarle come idee vergini in
bucket: **erano già una decisione**, presa da qualcuno con l'autorità per
prenderla, e il team ci sta già lavorando o ci lavorerà a breve. Come le
si fa rientrare nel modello di governance senza fingere che la decisione
pregressa non esista, né bloccare l'intake in attesa di rifare il RICE su
iniziative già in corso?

| Stato pre-esistente | Come entra nel framework |
|---|---|
| **GO** (decisa, in corso o imminente) | `classification: strategic_exception`, voce in `strategic_exceptions` con `invoked_at_stage: intake`. `approved_by`: il PM che conduce l'intake — si assume esplicitamente la responsabilità di portare avanti una decisione presa altrove (è l'unico caso in cui `approved_by` di una strategic exception non è un livello CEO/CPO-CTO; il razionale è la difendibilità, non un nuovo bypass). `reason`: la motivazione originale della decisione. Se in realtà è una direttiva di leadership con una scadenza esterna fissa, `classification: mandate` la descrive meglio — scegli in base alle definizioni di "Iniziative Mandatarie" e "Strategic Exception", non a occhio. |
| **POSTPONED** (rimandata, non rifiutata) | Idea normale in bucket, `classification: idea`, `rice_history` vuoto. Il RICE è ancora da fare: rientra nel processo standard e verrà quotata quando qualcuno ci lavora, come qualunque altra idea in attesa. |
| **NO GO** (rifiutata) | `classification: idea`, `status: aborted`. Record storico: non entra in prioritizzazione attiva, ma resta consultabile — se la stessa richiesta torna, c'è traccia del perché fu scartata. |

Questo permette al backlog storico di rientrare nel processo RICE
standard **non appena qualcuno ci lavora davvero** (analisi, PRD), senza
un big-bang di scoring a freddo su decine di iniziative e senza perdere
la memoria di cosa era già stato deciso e da chi.

**Checklist operativa**
- [ ] Il backlog storico è entrato con `created_at` = data di creazione originale, non data dell'intake?
- [ ] Le iniziative GO pre-esistenti sono entrate come strategic exception (`invoked_at_stage: intake`) o mandate, con `approved_by`/`mandated_by` e `reason` espliciti, non presunti?
- [ ] Le iniziative POSTPONED sono in bucket come idee normali, con il RICE dichiarato ancora da fare?
- [ ] Le iniziative NO GO sono archiviate come `status: aborted`, non cancellate?
- [ ] Dopo l'intake storico, `rice-watch`, `mandate-watch` e `deadline-watch` sono stati eseguiti una volta per fotografare lo stato di partenza?

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
  atteso nell'anno (es. EBITDA), quanto vale questa attività?" Il target
  annuale di riferimento va dichiarato per l'istanza in
  `product/reference/annual-target.yaml` (raccolto nell'intervista di
  `init-governance-project`, passo 4) — così ogni iniziativa si converte
  in punti in modo coerente. **Attenzione: è l'incremento atteso — il
  delta sull'anno precedente — non il totale a budget.** Un PM parla
  naturalmente in termini di totale (es. "300k a budget"); il numero che
  serve è solo la crescita di quel totale rispetto all'anno prima (es.
  30k). Un'iniziativa che da sola vale l'intero incremento annuo sta a
  Impact 10 — la scala non ha headroom oltre. Finché
  `annual-target.yaml` ha `value: null`, ogni Impact è
  un'approssimazione qualitativa e va trattato come tale (stesso
  principio del denominatore Reach).

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

  La maturità dell'analisi (quanto scoping è stato fatto) si riflette
  nelle fasi successive e nel progressivo consolidamento dell'evidenza —
  non va confusa con Confidence.

- **(E)ntanglement → footprint del cambiamento.** Quanto l'iniziativa è
  intrecciata col resto del sistema: quanti componenti, sistemi e team
  tocca, quanto è ampia la superficie di regressione, quanto sono
  complessi review e rollout. **Non è una stima di tempo-sviluppatore.**
  Con l'implementazione AI-assistita il tempo di codifica si è scollegato
  dal costo reale di un cambiamento, e in modo non uniforme: un change
  meccanico su molti file può essere rapido, un fix sottile su una riga
  no. Quello che resta — e domina — è il costo di capire le conseguenze,
  revisionare, coordinare tra team e contenere i side-effect. Un
  cambiamento che tocca una riga in un componente ha Entanglement basso;
  uno che tocca 17 cose in 3 sistemi ha Entanglement alto, perché rischia
  effetti collaterali ovunque. Scala 1-10:
  - 1-2: un componente, un sistema. Conseguenze evidenti a colpo
    d'occhio, review rapida.
  - 3-5: più componenti in un sistema, o un'interfaccia condivisa da
    pochi consumer noti. Superficie di regressione contenuta e mappabile.
  - 6-8: più sistemi, o un'interfaccia con molti consumer, o un dato che
    attraversa più bounded context. Side-effect plausibili in punti non
    ovvi, serve coordinamento tra team.
  - 9-10: cambiamento strutturale trasversale (migrazione dati, modello
    core, la maggior parte dei sistemi). Blast radius difficile da
    delimitare a priori, rollout a fasi obbligato.

  I **costi esterni hard** che non si comprimono (consulenza legale,
  licenze, UAT estesa con clienti, spesa infrastrutturale) alzano il
  punteggio anche quando il footprint di codice è piccolo.

  **Come si stima.** Quando i repository applicativi sono montati in
  `apps/`, la stima non parte da un'opinione: `rice-update` ispeziona il
  codice per collocare l'ordine di grandezza (quali sistemi, accoppiamento
  grossolano, consumer di un'interfaccia) e registra
  `entanglement_basis: code_inspection`. È una **prima passata** — il
  blast radius reale lo scopre la Preliminary/Complete Analysis, e la
  revisione entra come nuova voce in `rice_history`. Senza `apps/`
  collegato, o per sistemi non montati, si stima con un referente tecnico
  (`entanglement_basis: structured_estimate`) e si tratta l'evidenza come
  più debole.

  **Perché non più "Effort" (settimane).** Il tempo-sviluppatore è
  diventato un segnale rumoroso di ciò che il RICE vuole davvero
  catturare al denominatore — il costo e il rischio di far atterrare il
  cambiamento. La stima di tempo-calendario serve ancora, ma per la
  pianificazione, non per il ranking: vive in `delivery.estimated_effort_weeks`
  (riempita in Iteration Planning, alimenta `capacity_allocation`) e in
  `mandate.lead_time_weeks` per le iniziative con scadenza.

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

Un sotto-caso merita attenzione a sé: le idee che non hanno un RICE non
perché manca un dato che arriverà, ma perché **serve una riunione di
approfondimento col richiedente** per inquadrare il problema. Aspettare
non le sblocca — le sblocca solo il PM che fissa quel meeting. Vanno
marcate esplicitamente (`rice_status.deep_dive`) all'intake o quando
`rice-watch` le rileva, e `rice-watch` le tiene in cima ai suoi
promemoria — con un'escalation se il meeting è riconosciuto necessario da
settimane e non è ancora nemmeno in calendario.

**La lista ordinata del backlog non è solo una colonna di numeri.**
Quando si guarda il backlog per decidere (skill `backlog-list`), accanto
allo score vanno sempre mostrati: la `summary` (cosa c'è da fare, in
chiaro), l'eventuale scadenza (`deadline`), e le note utili a capire se e
quando prioritizzare (`notes`, `rice_status`). Un ranking RICE letto
senza questo contesto porta a decisioni meccaniche — e le iniziative
fuori RICE (mandate, platform, strategic exception) non vanno mescolate
nello stesso elenco ordinato: non hanno una "posizione", si leggono per
scadenza e stato.

*Principi Agile da incarnare in questa fase:*
- *Committenti e sviluppatori devono lavorare insieme quotidianamente per
  tutta la durata del progetto.*
- *I processi agili promuovono uno sviluppo sostenibile: un ritmo costante
  e mantenibile indefinitamente.*

**Checklist operativa**
- [ ] I quattro parametri RICE sono stati compilati (Reach, Impact, Confidence, Entanglement)?
- [ ] Reach è espresso come percentuale sulla popolazione rilevante della Product Line?
- [ ] Confidence riflette la qualità dell'evidenza, non la quantità di analisi svolta?
- [ ] Se l'Impact nasce da un valore economico: è stato rapportato all'`annual-target.yaml` (l'incremento atteso, non il totale a budget), e tappato a 10 se lo eguaglia o supera?
- [ ] Entanglement è stato stimato dal footprint reale del cambiamento (ispezione di `apps/` quando disponibile, o stima con un referente tecnico), non da un tempo-sviluppatore?
- [ ] Lo stakeholder proponente ha confermato Reach e Impact?
- [ ] L'idea è stata confrontata con le prime posizioni del backlog per coerenza del ranking?
- [ ] Se il RICE score è basso: è stata comunicata la motivazione allo stakeholder?
- [ ] Le idee ancora senza RICE sono state riviste all'ultimo Backlog Refinement, indipendentemente da quanto sembrino vecchie o marginali?
- [ ] Per le idee senza RICE da più di qualche settimana: è chiaro cosa manca e a chi è stato chiesto?
- [ ] Per le idee che richiedono un meeting di approfondimento col richiedente: il meeting è stato fissato, o è chiaro perché non ancora?
- [ ] Quando si guarda il backlog ordinato, si vedono anche summary, scadenza e note — non solo lo score?

## Scadenze su idee normali (`deadline`)

*"A goal is a dream with a deadline." — Napoleon Hill*

Non tutte le iniziative con una scadenza reale nascono già come
Iniziativa Mandataria (sezione successiva) o come Strategic Exception.
Un'idea può competere normalmente sul RICE e **avere comunque un vincolo
di tempo esterno** — un impegno preso con un cliente, una finestra
commerciale, una data che qualcuno ha già comunicato all'esterno — senza
che questo sia (ancora) abbastanza per giustificare il bypass completo
del RICE previsto per un mandate. È il caso più comune e il più facile
da perdere: la scadenza non salta all'occhio come un mandate dichiarato,
e un'idea con RICE score modesto può restare tranquilla in backlog fino
a quando la finestra si chiude.

Il framework tiene questo caso **distinto e più leggero** di `mandate`:
un blocco `deadline` (`due_date`, `note`) compilabile su qualunque
`classification` tranne `mandate` (che ha già il proprio). Impostarlo
**non salta il RICE e non decide nulla da solo** — è un fatto reso
visibile, non un'autorizzazione. La skill `deadline-watch` lo sorveglia:
quando mancano **4 settimane o meno** alla scadenza, fa un push esplicito
e forte al PM (non una riga tra le altre), chiedendo di scegliere tra tre
strade — invocare una Strategic Exception, verificare se l'iniziativa
soddisfa davvero la definizione di Iniziativa Mandataria e farla
riclassificare, o lasciarla nel processo RICE normale perché la scadenza
non è poi così rigida. **Nessuna delle tre è automatica**: `deadline-watch`
segnala con la massima evidenza, la decisione resta del PM, con lo stesso
principio delle altre watch del framework.

**Riclassificare un'idea a `mandate`.** Se una scadenza dichiarata in
`deadline` si rivela, alla prova dei fatti, una vera scadenza esterna
rigida (compliance, contratto, evento fisso — vedi definizione nella
sezione successiva), l'idea può passare da `classification: idea` (o
`strategic_exception`) a `classification: mandate`. Non è un'operazione
automatica: passa da `product/approvals/pending/` come qualunque altra
decisione di priorità (`type: mandate_reclassification`), perché cambia
come l'iniziativa compete. Il `rice_history` esistente **non si
cancella**: resta append-only, come registro storico di cosa sarebbe
valso nel processo normale — utile se in futuro si discute se la
riclassificazione era giustificata.

*Principi Agile da incarnare in questa fase:*
- *A intervalli regolari il team riflette su come diventare più efficace,
  poi regola il proprio comportamento di conseguenza.*
- *Meglio fallire presto: una scadenza a rischio va scoperta con
  settimane di anticipo, non il giorno prima.*

**Checklist operativa**
- [ ] Le idee con un vincolo di tempo esterno noto hanno `deadline.due_date` compilato, con `note` che spiega perché?
- [ ] `deadline-watch` è stata eseguita all'ultimo Backlog Refinement?
- [ ] Le idee `due_soon`/`overdue` hanno ricevuto una decisione esplicita del PM (Strategic Exception, riclassificazione, o conferma che restano nel processo normale) — non un silenzio?
- [ ] Se un'idea è stata riclassificata a `mandate`: è passata da `product/approvals/pending/`, e il `rice_history` precedente è rimasto intatto?

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

La soglia per il terzo caso è alta: una scadenza deve essere davvero
**esterna e rigida** perché da sola giustifichi il bypass del RICE. Una
scadenza più morbida (un obiettivo interno, una finestra desiderabile)
su un'idea che per il resto compete normalmente non la rende mandataria —
va nel blocco `deadline` (sezione precedente, "Scadenze su idee
normali"), sorvegliato da `deadline-watch`. Se col tempo quella scadenza
si rivela più rigida del previsto, l'idea si può riclassificare a
`mandate` passando da `product/approvals/pending/`
(`type: mandate_reclassification`) — mai automaticamente, e senza
cancellare il `rice_history` già accumulato.

Una Iniziativa Mandataria **non compete sul RICE** — non ha senso
calcolare Reach/Impact/Confidence/Entanglement per decidere se "vale la pena":
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
referente tecnico**, con lo stesso spirito con cui l'Entanglement del
RICE viene validato con un referente tecnico nella prioritizzazione — non
è un numero che il PM inventa da solo. (Il lead time è tempo-calendario,
una domanda diversa da Entanglement: quanta runway c'è prima della
scadenza, non quanto è intrecciato il cambiamento.)

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
idee normali hanno una scadenza dichiarata in avvicinamento (sezione
"Scadenze su idee normali"), quali idee restano senza RICE da troppo
tempo (sezione "Ideas prioritization"). Solo dopo si passa a decidere le
priorità del prossimo periodo — è più
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

È anche il momento in cui le iniziative `classification: idea` entrate in
iterazione ricevono una **stima di settimane di delivery**
(`delivery.estimated_effort_weeks`) dal team tech — tempo-calendario, non
l'Entanglement del RICE. Non serve prima: al RICE scoring interessa il
footprint del cambiamento, non la durata; è qui, con la valutazione
80/20 in mano, che una stima di durata diventa realistica. Alimenta
`capacity_allocation` in `roadmap-snapshot`, in parallelo a
`platform.estimated_effort_weeks` per le iniziative platform.

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
- [ ] Le iniziative `idea` in iterazione hanno una stima `delivery.estimated_effort_weeks` per la contabilità di capacità?
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

Questo scenario si previene all'intake: se una bozza di risposta
(`requester_reply`) fosse partita quando l'idea è arrivata — con una
prima ipotesi onesta di timing e, se serviva, la richiesta di un meeting
di approfondimento — lo stakeholder non arriverebbe a tre mesi di
silenzio prima di lamentarsi. Vedi "Chiudere il loop col richiedente".

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
business), Confidence (quanto si è sicuri delle stime), Entanglement
(footprint del cambiamento nel sistema — vedi voce dedicata). Il punteggio
finale è R × I × C / E.

**Entanglement (footprint del cambiamento)** — La "E" del RICE. Stima
1-10 di quanto un'iniziativa è intrecciata col resto del sistema: quanti
componenti/sistemi/team tocca, superficie di regressione, complessità di
review e rollout, più eventuali costi esterni hard (legale, licenze, UAT
estesa). Valore alto = più intrecciata = più a rischio = deprioritizzata
(è a denominatore). Sostituisce la vecchia "Effort" (settimane-
sviluppatore), resa un segnale rumoroso dall'implementazione AI-assistita
che scollega il tempo di codifica dal costo reale del cambiamento. La
stima di tempo-calendario per la pianificazione vive altrove
(`delivery.estimated_effort_weeks`, riempita in Iteration Planning;
`mandate.lead_time_weeks` per le iniziative con scadenza). Vedi "Ideas
prioritization".

**NSM — North Star Metric** — Il KPI più importante che ogni PM presidia
per la propria Product Line.

**Strategic Exception** — Meccanismo che consente a una richiesta di
bypassare il normale processo di prioritizzazione, su approvazione di un
livello dirigenziale definito dall'istanza. Deve essere rara e motivata.
Se la motivazione è (anche) una scadenza reale, può portare un blocco
`deadline` (vedi voce dedicata) per rendere quella motivazione
verificabile nel tempo, non solo testo libero in `reason`.

**Iniziativa Mandataria (mandate)** — Iniziativa che bypassa il RICE
perché imposta dall'alto, marcata "critical" da leadership, o vincolata a
una scadenza esterna fissa — non l'analisi, che resta necessaria. A
differenza della Strategic Exception, non richiede un'approvazione di
ruolo specifico, ma richiede sempre di dichiarare esplicitamente chi la
impone e perché, e una stima di lead time verificata ad ogni Backlog
Refinement. Vedi sezione "Iniziative Mandatarie". Un'idea normale può
essere riclassificata a mandate a posteriori se una scadenza dichiarata
in `deadline` si rivela soddisfare davvero questa definizione — passa
comunque da `product/approvals/pending/` (`type:
mandate_reclassification`), non è mai automatico.

**Deadline (scadenza su idea normale)** — Blocco opzionale (`due_date`,
`note`) compilabile su qualunque `classification` tranne `mandate` (che
ha già il proprio `due_date`): rende visibile che un'idea RICE-ranked o
una Strategic Exception ha comunque un vincolo di tempo esterno, **senza
bypassare da solo il RICE**. Sorvegliato dalla skill `deadline-watch`,
che fa un push esplicito quando mancano 4 settimane o meno alla
scadenza — segnala, non decide. Vedi sezione "Scadenze su idee normali
(`deadline`)".

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

**Declined (scarto al triage)** — Stato terminale per un elemento
arrivato all'intake che non è qualcosa su cui il team di prodotto può o
deve lavorare (richiesta di supporto, fuori perimetro, già coperto). Il
record si crea comunque, con `decline_reason` e una bozza di risposta al
richiedente. Distinto da `aborted` (iniziativa avviata e poi interrotta):
il primo non è mai entrato nel processo, il secondo sì. Vedi
"Alimentazione del bucket delle idee" e "Chiudere il loop col
richiedente".

**Requester reply (bozza di risposta al richiedente)** — Ad ogni intake
con un richiedente esterno identificabile, il framework prepara una bozza
di risposta (presa in carico / eccezione in attesa di conferma / scarto
motivato / richiesta di chiarimento), salvata sull'idea in
`requester_reply` e **mai inviata in automatico**: la rivede e la manda
il PM. Serve a chiudere il loop con chi ha scritto, che altrimenti resta
al buio. Vedi "Chiudere il loop col richiedente".

**Deep dive (meeting di approfondimento)** — Riunione col richiedente
necessaria per inquadrare un'idea abbastanza da farne un RICE serio.
Marcata in `rice_status.deep_dive`; `rice-watch` la ricorda con
insistenza — con escalation — finché il meeting non è fissato e
avvenuto. È il sotto-caso più actionable di "idea senza RICE": non
aspetta un dato, aspetta che il PM metta il meeting in calendario.

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
sua voce su rischio tecnico e footprint del cambiamento (l'Entanglement
del RICE) è fondamentale già nelle fasi di analisi.
