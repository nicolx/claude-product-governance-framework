# Product Governance — EPASSI ITA

> **Nota di versione (v4).** Questa versione trasforma il documento in Markdown per renderlo parte dell'"almanacco" di istruzioni che guida i comandi/skill di Claude Code nel flusso di prodotto. Rispetto alla v3 (.docx), il contenuto è fedele all'originale — comprese le Cronache — con una revisione mirata alla sezione **Complete Analysis / PRD** (densità e dimensionamento, principio A3 Thinking). Le sezioni ancora legate ad Aha! non sono state riscritte in questa passata: la migrazione dello strumento è un lavoro separato, in corso di progettazione.

## Come leggere questo documento

Questo documento ha livelli di lettura diversi a seconda del ruolo di chi lo legge. Non è necessario leggerlo tutto in una volta: è pensato per essere consultato più volte nel tempo, man mano che ci si confronta con le situazioni reali.

**Se sei un Product Manager** — leggi tutto, nell'ordine in cui è scritto. Ogni sezione descrive una tua responsabilità diretta. Le Cronache sono esempi concreti del processo in azione: non saltarle.

**Se sei un Developer o Tech Lead** — le sezioni più rilevanti per te sono: Product Backlog Refinement, Preliminary Analysis, Complete Analysis, Roadmap Update & Iteration Planning. Capire le fasi precedenti (Ideas intake, Prioritization) ti aiuta a comprendere perché alcune cose arrivano in agenda e altre no.

**Se sei uno Stakeholder (Operations, Sales, Marketing, Leadership)** — leggi l'introduzione, la sezione Ideas Intake e Ideas Prioritization. Le Cronache ti mostreranno come le tue richieste vengono accolte, valutate e processate. La sezione "Come gestire le frizioni" è scritta anche per te.

**Se sei nuovo nel team** — inizia dalle Cronache di EPASSI ITA (Episodi 1-8). Sono un racconto continuo che attraversa tutto il processo. Poi torna all'inizio e leggi il framework con gli occhi di chi ha già visto come funziona in pratica.

Lo scopo di questo documento è rappresentare una proposta di flusso di lavoro (way of working) che copra il percorso del valore dalla raccolta delle idee (o la product discovery autonoma) fino al rilascio, la misurazione dell'efficacia e l'eventuale iterazione migliorativa di ogni prodotto o soluzione.

## Il lavoro del Product Manager (in pillole)

Il punto fondamentale del lavoro del Product Manager è: creare valore misurabile per l'azienda. Nel caso di prodotti che hanno a che fare con piattaforme tecnologiche il valore si intende sia per gli utenti del sistema tecnologico (beneficiari, merchant, clienti) e gli stakeholder (sales, ops e marketing) che hanno l'obiettivo di tradurre il valore che noi creiamo in ricavi ed efficienza di costo.

**Parola chiave: valore.**

Quale valore viene generato è dato dall'identificazione e dalla formalizzazione del problema degli utenti o stakeholder coinvolti in ogni attività portata avanti dal prodotto. Spesso i problemi o le opportunità sono piccoli incrementi (non sempre strategici). Il compito di prodotto è verificare l'attinenza di queste opportunità con la strategia di prodotto (e dell'azienda). Il valore nel prodotto è misurato con delle metriche (KPI di prodotto): alcune strategiche (north star metrics) altre più opportunistiche e specifiche per singola attività.

**Parole chiave: problema, why, kpi.**

Il prodotto è garante della corretta riuscita delle iniziative (tempi, modalità, misurazione dei risultati) dando a tutta l'organizzazione feedback continui sullo stato dell'arte. Non tutto è importante ed urgente. Il prodotto non è responsabile della definizione autonoma delle priorità: invece, il prodotto coordina le attività per razionalizzare le priorità, riordinare le attività, fluidificare tutti i processi di esecuzione (nel nostro caso, prevalentemente implementazioni tecniche... ma non solo!). Quando possibile (o in parallelo) alle attività promosse dagli stakeholder, il prodotto è promotore della Product Discovery per identificare iniziative ad alto impatto sulle NSM, indipendentemente dagli altri stakeholder (ma auto-sottoponendosi agli stessi criteri di validazione e prioritizzazione).

**Parole chiave: roadmap, product delivery, product discovery.**

Il prodotto ha un ingrato compito (*nota del relatore: sì, io lo definisco esplicitamente ingrato*): essere nel mezzo tra gli stakeholder, le loro esigenze ed il team di tecnologia. Questo comporta che il prodotto sia responsabile del raccogliere, organizzare e riportare a tutti gli stakeholder (tech e non tech) tutte le informazioni utili a fluidificare l'implementazione. Tradurre quindi il linguaggio del business in modo accessibile al tech. Viceversa, proteggere il team tech dal dover investire troppo tempo nella comprensione di elementi di business troppo dispersivi.

Nota. Un bravo team tech però sa comprendere sufficientemente il business per partecipare, col prodotto, alla valutazione di ogni contingenza con la finalità di creare efficienza ed attuare implementazioni "lean", contenere il rischio della sperimentazione ed andare online quanto prima (solo il codice in produzione ci permette di misurare gli impatti e rivalutare le priorità con gli stakeholder).

**Parole chiave: analisi dei requisiti, lean management.**

Prodotto è misurato sugli outcomes: non basta fluidificare il lavoro, non basta comprendere il problema e promuovere soluzioni, non basta avere ampia consapevolezza del dominio. Le NSM devono avere degli impatti. Prodotto deve essere in grado, usando dati ed evidenze sperimentali, di giustificare dei "no" per aiutare il resto dell'organizzazione a prendere decisioni consapevoli sulle priorità e sull'allineamento delle richieste alla strategia di prodotto e di business. Il prodotto non ha una opinione sulle cose. Usa i dati per analizzare le evidenze. Produce outcomes per supportare evidenze positive.

**Parola chiave: outcomes.**

Nessuno che si occupi di Product Management ha la sfera di cristallo (non vede il futuro, non è nella testa degli utenti): l'istinto di un bravo Product Manager può accelerare il successo ma non è un requisito. Un bravo Product Manager, in ogni caso, non si fida del proprio istinto, anzi: lo mette alla prova riducendo, in ogni attività o metrica che presidia, il rischio ed aumentando le probabilità di un ritorno positivo (rischio/rendimento). Una volta messa in discussione la propria ipotesi e misurando gli impatti, impara dai dati e adatta le proprie conclusioni per definire le prossime attività. Di settimana in settimana, di mese in mese, di anno in anno, il ciclo si ripete adattandosi alla strategia, alla discovery, ai competitor, ai clienti.

**Parole chiave: gestione del rischio, ciclo del feedback.**

### Il percorso evolutivo per un Product Manager

| **4Ds** | **Skills** | **Outcomes** | **Resources** |
|---|---|---|---|
| **Discovery** — La Discovery denota la capacità di ridurre l'incertezza in modo strutturato. La padronanza di queste competenze è il requisito di base per una risorsa che si propone per l'incarico o che sta facendo un percorso in questo ruolo. | Formulazione di ipotesi falsificabili; Problem framing strutturato (problem statement chiaro e verificabile); Selezione metodo di validazione adeguato al rischio; Lettura critica di metriche quantitative e qualitative; Costruzione di esperimenti con metriche di successo definite prima; Capacità di distinguere segnale da rumore; Collegamento tra insight utente e modello di business | Riduzione esplicita del rischio prima della delivery; Roadmap fondata su evidenze, non su opinioni; Invalidazione tempestiva di idee deboli; Miglioramento della qualità delle decisioni del team; Documentazione chiara di ipotesi e learnings | **Libri:** "Inspired" — Marty Cagan; "Lean Startup" — Eric Ries; "Testing Business Ideas" — Strategyzer; "Lean Analytics" — Croll & Yoskovitz. **Esperienze:** conduzione di almeno 10 interviste utenti autonome; disegno di almeno 3 esperimenti strutturati con metriche definite ex ante; caso documentato di pivot o stop decisionato su evidenze |
| **Delivery** — La Delivery riguarda il trasformare decisioni in risultati misurabili. Non è solo un tema di rispetto delle scadenze ma soprattutto di far emergere il valore creato a tutti i soggetti, coinvolgerli ed allinearli per la migliore prestazione possibile. | Traduzione di decisioni in roadmap eseguibile; Definizione di KPI di outcome (non solo output); Allineamento continuo con tech e business; Gestione dei trade-off tra velocità, qualità, debito tecnico; Monitoraggio post-release con metriche chiare; Capacità di correggere rotta senza perdere credibilità | Rilasci coerenti con obiettivi dichiarati; Misurazione sistematica dei risultati; Riduzione del gap tra promessa e valore generato; Stabilità del team in fasi di pressione; Visibilità chiara dell'impatto prodotto | **Libri:** "Measure What Matters" — John Doerr; "Accelerate" — Forsgren, Humble, Kim; "Escaping the Build Trap" — Melissa Perri. **Esperienze:** ownership completa di almeno 2 release significative; definizione e monitoraggio di KPI end-to-end; gestione di stakeholder multipli su roadmap conflittuali |
| **Decision** — Decision riguarda la capacità di assumere responsabilità strategica su un prodotto o un'area, generando scelte coerenti e impatti misurabili. | Esplicitazione dei trade-off strategici; Prioritizzazione basata su valore e rischio; Assunzione di responsabilità sotto incertezza; Capacità di dire no motivando con evidenze; Coerenza strategica nel tempo; Costruzione di narrative fondate su dati | Decisioni chiare e comprensibili per l'organizzazione; Riduzione dell'ambiguità decisionale; Maggiore velocità nelle scelte complesse; Fiducia degli stakeholder nella leadership di prodotto; Portfolio coerente nel tempo | **Libri:** "Good Strategy Bad Strategy" — Richard Rumelt; "Playing to Win" — Lafley & Martin; "Thinking in Bets" — Annie Duke. **Esperienze:** caso documentato di scelta impopolare ma corretta nel tempo; decisioni prese con informazioni incomplete; responsabilità su budget o P&L di area |
| **Direction** — Direction riguarda la capacità di influenzare la strategia aziendale e il sistema organizzativo nel suo complesso, creando standard, visione e moltiplicazione di competenze oltre il perimetro del singolo prodotto. Con queste competenze, il PM produce autonomamente impatti sul business attraverso il prodotto fino a condizionare la strategia aziendale con un modello Product-Led. | Definizione di visione e strategia di medio-lungo periodo; Disegno di portfolio prodotto coerente; Costruzione di standard e framework interni; Sviluppo e mentoring di altri PM; Influenza su executive e board; Capacità di modellare organizzazione product-led | Allineamento strategico cross-team; Impatti misurabili su revenue, retention o market position; Introduzione di standard metodologici adottati da altri team; Crescita della maturità prodotto dell'organizzazione; Nascita di nuove linee prodotto o evoluzioni 0→1 | **Libri:** "7 Powers" — Hamilton Helmer; "Crossing the Chasm" — Geoffrey Moore; "The Innovator's Dilemma" — Clayton Christensen. **Esperienze:** ownership di strategia annuale o multi-prodotto; lancio di un prodotto 0→1; mentorship documentata di altri PM; presentazioni strategiche a executive level |

### Product vs Project. Errori tipici

Nelle righe sopra ho dato alcuni accenni sintetici alle responsabilità di prodotto. Nelle prossime righe non farò una disamina dettagliata del Project Management ma cercherò di mettere in relazione tra loro le differenze tra il Product ed il Project management.

**Project management:**

- Obiettivo nel presidiare la delivery di un progetto (tempi e costi)
- Il suo focus è nell'allineare gli stakeholder
- È responsabile degli output
- Risponde di un budget assegnatoli
- È coinvolto dall'inizio alla fine del progetto

**Product management:**

- Il suo obiettivo è creare valore misurabile per l'azienda
- Oltre a creare allineamento, è garante che ci sia fluidificazione e sintesi (o reinterpretazione) delle esigenze in accordo con la strategia di prodotto, con il costo/opportunità delle varie scelte
- È responsabile degli outcomes, cioè che i suoi contributi producano impatti concreti nelle metriche che presidia (esempio, le metriche di Conversion & Engagement dei beneficiari)
- Risponde della coerenza della roadmap di prodotto con la strategia e risponde della fattibilità della stessa (previene che la roadmap contenga cose non fattibili in tempi/modi coerenti con l'esigenza di creare valore misurabile)
- Il suo lavoro inizia quando viene assunto e non finisce mai: c'è sempre una metrica da migliorare, un deterioramento delle stesse (a causa dei competitor o dell'evoluzione dei bisogni degli utenti)

È frequente incappare in questa percezione: "in qualità di Product Manager mi aspetto che i requirements siano formulati dagli stakeholder; il fatto di elaborare dei requirements è lavoro di Project Management".

Da quello che ho sintetizzato qui, la mia visione è diversa. Il Project Manager raccoglie requirements e li rielabora (senza giudicarli) per metterli a disposizione del team, facendo domande ed approfondimenti quando utile. Il Product Management, invece, è al 100% garante sia di raccogliere i requirements ma anche di rielaborarli (perché no, anche facendo obiezioni basate sui dati) per essere riscritti in chiave: problema, soluzione, metriche.

Questo comporta, accidentalmente, che il Product Manager sia spesso una persona molto informata sui processi aziendali (ha partecipato alla loro definizione in termini di soluzioni di prodotto per risolverli) e sul business (perché è co-creatore di valore attraverso il prodotto). Quindi sì, è un lavoro ampio, coinvolgente ed anche frustrante (come ho già detto, è carico di pressione perché sta nel mezzo tra forze non sempre facili da allineare). Frustrazione e difficoltà varie che vanno superate dalla passione di voler creare impatto: siamo una Product Company, siamo centrali nel successo della stessa, ci accolliamo la fatica e l'onere perché lo scegliamo!

I requirements poi non sono mai statici. Evolvono man mano che emerge la conoscenza. Fare software comporta la trasformazione della conoscenza: uno stakeholder, per quanto bravo, non può avere il suo tempo impiegato nella comprensione ed evoluzione dei requirements. Per questo sono fondamentali invece i Product Manager.

La sequenza è: lo stakeholder espone i needs (anche sotto forma di bozza di requirements); rielaborazione del Product Manager, raffinamento e traduzione in problema, soluzione, metriche; fluidificazione della delivery; misurazione e feedback.

> **Nota sul perimetro di questo documento.** Questo playbook è un'entità viva e intenzionalmente incompleta nella sua versione attuale. Il focus della presente versione è sulla governance delle priorità: dalla raccolta delle idee fino alla pianificazione dell'iterazione. Le sezioni relative all'implementazione tecnica (Product Design, Development, Rollout) sono di competenza del CTO e saranno integrate in una versione successiva del documento. La sezione Measurement è attualmente in forma essenziale: l'assenza di un datalake strutturato limita oggi la nostra capacità di osservazione sistematica delle metriche — il potenziamento di questa fase è un obiettivo esplicito del percorso di maturità del team. Chi legge è invitato a concentrarsi sulle fasi coperte e a contribuire all'evoluzione delle parti ancora da costruire.

Questo processo è progettato per governare **decisioni**, non solo attività.

Ogni iniziativa è valutata in termini di rischio cognitivo e rendimento atteso, il livello di investimento è proporzionale alla confidenza. Meglio fallire presto (lean management) e investire poco e in modo calibrato, proteggendo il team dal perfezionismo.

Lo sviluppo software è un processo di trasformazione della conoscenza in valore. Condividiamo col team uno scopo, una visione per favorire la comprensione del contesto ed il trasferimento della conoscenza. Dalla conoscenza di dominio arriva l'efficienza nell'esecuzione ed il focus sulla qualità (perché evitiamo di perdere tempo in attività a basso valore, dove c'è valore mettiamo eccellenza tecnica ed implementativa).

Una delle sfide più importanti è capire il perimetro in cui opera la Product Governance. Proponiamo un framework di lavoro interno al team. Il team ha la responsabilità di incarnare i valori proposti ed i processi come mandatori. Non possiamo invece controllare che gli stakeholder accolgano ed assumano comportamenti coerenti con questi valori. Ciò è dato dalla cultura aziendale. Il framework crea dei confini (boundaries) per proteggere il team dalla cultura esterna, fornendo delle interfacce (persone — il PM — e processi — le cerimonie) per ridurre le possibili frizioni. Tuttavia, il team può orientare nel lungo termine la cultura aziendale: fare al meglio il proprio lavoro esplica come possa evolvere la cultura aziendale in meglio. Leading by example.

Nell'organizzazione del nostro lavoro ci sono tre macro fasi di lavoro per ogni prodotto:

- **Definizione della strategia di prodotto** (attività eccezionale, valida nel lungo termine)
  - Comprensione e condivisione con tutto il team prodotto ed IT della visione aziendale e della missione, per allineare tutti i comportamenti
  - Utilizzo di framework come Business Model Canvas o Blue Ocean Strategy per rendere visibili i flussi di business ed i percorsi di crescita potenziali
  - Formalizzazione della strategia di prodotto (se cambia spesso, riverificare i punti precedenti)
- **Esecuzione della strategia di prodotto** (fase ricorrente)
  - Raccolta di iniziative (ideas, problems), feature e pianificazione delle stesse (roadmap) in iterazioni consecutive per facilitare la delivery
  - Product operations: discovery, design, delivery, analysis, marketing, growth sono portate avanti secondo i principi del manifesto Agile
  - Frammentazione logica e chiarezza strategica: **why**, **what**
  - Definizione UI/UX, stesura specifiche dettagliate, lavoro col team Tech nella stesura della todo list e dei task: **how**
  - Il team prodotto fluidifica e facilita i processi implementativi
  - In accordo con gli stakeholder, in particolare col PMM, viene definita una go-to-market strategy (più o meno sofisticata a seconda delle esigenze): **when**
- **Implementazione della soluzione** (fase ricorrente)
  - Il team di tecnologia porta avanti un backlog di breve termine secondo i principi del manifesto Agile, dalla collaborazione nella definizione dell'how col prodotto fino alla revisione e miglioramento continuo del processo interno
  - L'organizzazione delle persone è tale da prevedere almeno due flussi continui di lavoro: a) flusso di lavoro sulla roadmap principale; b) flusso di protezione del team per manutenzione ordinaria, gestione del debito tecnico, bug, POC

Le fasi ricorrenti, oggetto di dettaglio nei successivi paragrafi, in modo schematico sono:

| **Fase (ordinata)** | **Timing** | **Attori** | **Input** | **Output atteso** | **Tool** |
|---|---|---|---|---|---|
| Ideas intake (alimentazione bucket) | As needed | PM, PMM, PDS, Users, Leaders | Idee sparse da team non operativi o dai loro leader; opportunità identificate dal PMM sui competitor; discovery continua del PDS; bug report; Strategic Exception (shortcut commerciali) | Lista non ordinata di richieste, non ancora identificate come epiche/iniziative/feature; problemi tracciati; bug loggati direttamente su Jira per gestione prioritaria; Strategic Exception approvate direttamente su Jira | Email; Brainstorming; Aha!; Jira (bug) |
| Ideas prioritization | ASAP | PM, IT, Leaders | Un item dal bucket idee | Lista prioritizzata di idee eleggibili per entrare in agenda | RICE Scoring |
| Product Backlog Refinement | Settimanale | PM, IT | Idee prioritizzate | Lista di iniziative/feature; Release in Aha! | Aha! |
| Preliminary analysis | ASAP (dopo il Refinement) | PM, IT, Domain expert | Un'iniziativa o feature | Buon livello di comprensione del problema; Why; verifica di allineamento strategico; decisione di procedere; possibile abort anticipato e ritorno al backlog | Miro; Why template; Lean |
| Complete analysis | ASAP (dopo la Preliminary) | PM, Domain expert, Leaders | Un'iniziativa/feature con Why chiaro | Alto livello di comprensione del problema; What/GTM; metriche e KPI; decisione di procedere (+ROI); possibile abort e ritorno al backlog | Miro; What/When; diagrammi di flusso; DataBricks; DDD |
| Roadmap update | Settimanale (con Iteration Planning) | PM | Comprensione completa delle iniziative/feature pianificate per il prossimo periodo | Report per azienda, leader, stakeholder su cosa conta per Prodotto e IT; vista Gantt | Aha!; Jira |
| Iteration planning | Settimanale | PM, PDS, IT | Un'iniziativa/feature con Why, What, When chiari | User stories; flussi UI/UX; valutazione tecnica 80/20; caricamento Jira; backlog di iterazione; criteri di accettazione; possibile abort se il ROI cambia | Miro; Jira; Aha! |
| Product Design | ASAP (se necessario) | PDS | Una user story che richiede UI/UX | Design front-end chiaro, pronto per l'implementazione | Miro; Figma |
| Development | ASAP | PM, IT | Una user story | Deliverable testato | Jira; Agile; XP |
| Rollout | — | PM, PMM | Un deliverable | Esecuzione dei piani GTM | Aha!; HubSpot (?); Marketing Cloud; Social |
| Measurement | — | PM, Data, IT Manager | KPI precedenti; nuovi valori | Abbiamo raggiunto gli obiettivi? Servono altre iterazioni o si chiude il flusso? C'è debito tecnico da gestire? Si butta via tutto? Showcase dell'outcome | DataBricks; PowerPoint; retrospettiva decisionale |

La nostra organizzazione di prodotto è definita per presidiare il successo delle iniziative, specialmente tecnologiche, che impattino determinate metriche. Ogni PM è responsabile del successo di una **North Star Metric**. Questo concetto rappresenta il KPI specifico più importante che, se ogni PM si sforza di migliorare continuamente — con la Product Discovery individuale o intercettando le "Ideas" del resto dell'azienda — abiliterà l'azienda a raggiungere in futuro i propri traguardi.

| **Product Line** | **Descrizione** | **NSM / altri KPI** | **Stakeholder** |
|---|---|---|---|
| Conversion and engagement | Frontend platforms. Employee satisfaction e happiness | + GMV used (%); + Time to first purchase; + Active employee | Elisa, Felice |
| Onboarding and integration | Employee acquisition e reporting. Efficienza interna e processi di backoffice | + CR prospect → customer; + FTE staff efficiency; + GMV per Employee (avg); + Employee per employer | Elisa, Filiberto, Felice |
| Merchant Success | Rendere il Merchant felice può guidare fee migliori | + Transacted fees (product mix); + Employee access frequency; + Merchant distributed MS | Elisa, Felice, Filiberto |
| Web frontend and acquisition | Il sito EPASSI Italia deve convertire lead in funnel di vendita promuovendo benefit chiari e di default | + New B2B leads; + Total fees; + Discount fees amount | Elisa, Felice |
| EPASSI synergy | Promuovere e facilitare l'integrazione dei prodotti EPASSI | (?) platform KPIs | IT |

Altre persone chiave di supporto all'organizzazione di Prodotto:

1. **Product Design** — UI/UX focus dedicato ai prodotti italiani; lavora trasversalmente su tutte le Product Line; **da assumere** (parte del team Product Design, reporting a Leeni).
2. **Product Marketing** — Alignment con Sales/Ops sul go-to-market; competitor analysis e market intelligence.

Team tech coinvolto:

| **Ruolo** | **Scenario** |
|---|---|
| Conversion and engagement | 5HC |
| Onboarding and Integration | 5HC |
| Merchant Success | 3HC |
| EPASSI Synergy | 3HC |
| Web frontend and acquisition | n/a |

---

# Product Playbook — EPASSI ITA

*"The greatest danger in times of turbulence is not the turbulence; it is to act with yesterday's logic." — **Peter Drucker***

Entriamo nel dettaglio di ogni attività con esempi concreti ed arricchendo il documento con citazioni per inquadrare bene la visione e lo scopo di ogni passaggio. Ogni passaggio deve essere inequivocabile nell'execution. Ciò non toglie che i processi evolvono e si adattano al contesto: **il playbook è una entità viva!**

Tutta la Product Governance ed il conseguente Playbook fondano tutti gli elementi sul Manifesto Agile per lo sviluppo del software. È importante inquadrare che il Playbook, in quanto entità viva, è opportuno che non venga meno ai valori fondamentali del Manifesto. Nel lavoro, come nella vita, perché un organismo (o un'organizzazione) progredisca per il bene comune servono dei valori. Suonano come supercazzole filosofiche? Al contrario! Come i valori aziendali **orientano** il comportamento degli individui in relazione agli obiettivi del business, i valori del Manifesto **orientano** i comportamenti degli individui coinvolti nel ciclo di vita del software. Siamo una tech company, pertanto il ciclo di vita del software è Core Business e deve attenersi a pratiche di riprovato successo. Non useremo il Manifesto Agile come metodologia, ma come bussola per interpretare le scelte operative descritte nel Playbook. Quindi, facciamo un po' di filosofia prima per lavorare al meglio delle nostre possibilità dopo!

Potremmo spendere molte parole sui contenuti del manifesto. In questo momento ci soffermeremo solo sull'ultima frase: "Ovvero, fermo restando il valore delle voci a destra, consideriamo più importanti le voci a sinistra". Mi impressiona leggere "fermo restando le voci a destra": non stiamo parlando di una visione della vita che "non ha contratti" o "non ha scadenze" o che "non richiede processi" o che "non richiede documentazione, KPI o metriche da analizzare"; stiamo parlando di come il valore delle voci a sinistra (le persone, il software, la collaborazione, l'evoluzione) sia il nostro obiettivo, sono le cose **non negoziabili**; il come (voci a destra) è invece oggetto delle prossime pagine.

Ai valori del Manifesto si aggiungono 12 principi concreti che vengono citati via via nel Playbook, associando il principio alle attività da fare.

## Product Governance in practice

Tutte le attività del Product Playbook hanno origine e fondamento nella Strategia di Prodotto.

La strategia di prodotto si inserisce in un contesto di Strategia di Business che è descritto su Aha! mediante il framework del Lean Canvas. È importante che tutti i membri dell'organizzazione di prodotto e tecnologia abbiano chiaro come funziona sommariamente il modello di business. Ogni nostra attività richiede allineamento ad esso e richiede attente valutazioni (generare efficienza creando l'ottanta per cento del risultato col venti per cento dello sforzo). **Solo una chiara comprensione del business aiuta a mantenere il focus sulle cose che spostano!**

Nelle sezioni "Strategy" di Aha! sono disponibili altri pannelli: SWOT Analysis, Competitors, Customer Personas. Sono utili per la consultazione occasionale ma vengono mantenuti occasionalmente, quando l'azienda compie dei pivot significativi.

## Alimentazione del bucket delle idee

*"The best way to have a good idea is to have a lot of ideas." — **Linus Pauling***

Ogni giorno riceviamo email, prendiamo il caffè con qualcuno, riflettiamo a voce alta coi colleghi. E nella vita del Product Manager, tutte queste interazioni non sono semplici scambi. Sono tempeste di idee. Ipotesi di miglioramento, quel feedback dal basso che rende bene l'idea di come funzioni (o non funzioni) un flusso.

Tutto questo non può stare nella nostra mente. Va cristallizzato per contenere lo stress, la pressione esterna (di chi ci ha spiegato le sue posizioni...) e soprattutto è molto raro che sia immediatamente azionabile. Serve un archivio, un basket: la sezione "ideas" di Aha!

Le idee devono essere inserite in modo che sia abbastanza facile capire:

- Da chi arrivano [NOME] e di cosa si tratta, con un titolo
- Una descrizione che spieghi il contesto e permetta di risalire alle informazioni essenziali per valutare in futuro le priorità dell'idea in relazione con le altre idee (con delle citazioni email, ad esempio, o le citazioni dei documenti già disponibili)
- È interessante incasellarle in categorie (attività di Operations, richieste di compliance, cose prettamente tecniche) per semplificare i filtri

> *Abbiamo convenuto che sia più pratico ed immediato usare:*
> - *L'oggetto della mail come titolo dell'idea*
> - *Il contenuto della mail ed i suoi allegati come dettaglio*
>
> *Rende più semplice risalire alla fonte e non perde nessuna informazione.*

A volte quelle che sembrano idee da catalogare sul tool sono in realtà due input che devono scavalcare le prossime fasi del processo:

a) **Bug**: entrano in agenda del team di sviluppo, non è un tema di priorità RICE. **Definizione operativa**: è un bug tutto ciò che — per un errore di codice o per un'interpretazione errata del requisito — produce in produzione un output diverso dalla percezione qualitativa attesa da chi usa o da chi testa la piattaforma. Il valore atteso non viene percepito perché l'*output* è diverso dalle attese. È una distinzione importante: si parla di **output**, non di *outcome* — non è un bug se una feature funziona esattamente come progettata ma semplicemente non muove la metrica di business che ci si aspettava (quella è un'ipotesi di prodotto invalidata, va in Measurement, non in Jira come bug). A seconda dell'impatto prodotto, un bug va risolto con ragionevole priorità: un tema di security va gestito ASAP, mentre un processo automatico che ha un fallback manuale può attendere giorni se ci sono altre urgenze.

b) **Strategic Exception**: quando arriva il CEO o il CPO/CTO o uno stakeholder molto rilevante, consideriamo di valore l'accogliere ogni proposta su un canale privilegiato. Il PM ha comunque il dovere di restituire feedback ed evidenze sulla bontà dell'investimento (anche per prendere nota dell'esito delle varie Strategic Exception che si verificano nel tempo). Ma anche in caso le evidenze non siano le migliori, è opportuno accogliere alcune richieste eccezionali.

*Principi da incarnare per essere allineati e lavorare con profitto in questa fase del Playbook:*

- *Accogliamo i cambiamenti nei requisiti, anche a stadi avanzati dello sviluppo. I processi agili sfruttano il cambiamento a favore del vantaggio competitivo del cliente.*
- *Una conversazione faccia a faccia è il modo più efficiente e più efficace per comunicare con il team ed all'interno del team.*

> **Cronache di EPASSI ITA — Episodio 1.**
> Filiberto, il nostro Head of Operations, ha una fantastica idea su come rendere più efficace il motore di approvazione automatica delle ricevute dei beneficiari (già basato su AI). Ha notato che quando il motore fallisce spesso si tratta di una ricevuta in cui non sono indicate nel dettaglio tutte le voci di spesa ma solo il totale (il classico scontrino sbrigativo del negozio locale). Manda una dozzina di casi per email a Gennaro (Product Manager) raccontando la situazione: "in tutti questi casi lo scontrino ha solo un dato, il totale". Nella pratica, anche se non c'è corrispondenza con le singole voci di spesa, gli operatori approvano la richiesta di rimborso a mano se c'è corrispondenza tra il totale ed il nome del Merchant indicato nella richiesta di rimborso. Gennaro annota su Aha! e conclude soddisfatto la giornata.

**✅ Checklist operativa**

- [ ] L'idea è stata registrata su Aha! con titolo, proponente e descrizione del contesto?
- [ ] Se è un bug: è già stato aperto un ticket su Jira con impatto stimato?
- [ ] Se è una Strategic Exception: è stata approvata dal CEO/CPO? È già su Jira?
- [ ] L'idea è stata categorizzata per Product Line (Theme su Aha!)?
- [ ] Se arriva via email/WhatsApp/voce: è stata trasferita su Aha! prima di qualsiasi altra azione?

## Ideas prioritization

*"There are no solutions, only trade-offs." — **Thomas Sowell***

ASAP, non necessariamente nello stesso istante in cui annota l'idea sul tool, il PM, insieme ad un referente tecnico (un advisor del team abbastanza esperto da avere una certa sensibilità sul dominio e sulle possibili implicazioni tecniche di ogni idea ad alto livello), cerca di raccogliere con lo stakeholder alcuni pareri per applicare il RICE.

RICE è un framework di prioritizzazione molto semplice basato su quattro parametri:

- **(R)each →** Quante persone o utenti avranno un beneficio lavorando su questa idea? **Il valore va sempre espresso come rapporto 0-100 (percentuale) sulla popolazione rilevante per quella Product Line, non come valore assoluto** — solo così i punteggi restano confrontabili tra Product Line diverse nello stesso Backlog Refinement. Esempi di rapporto per Product Line: employee coinvolti / employee totali (Conversion); ore di backoffice risparmiate / ore totali disponibili di backoffice (Internals); benefit coinvolti / benefit totali offerti (Merchant); prospect toccati / prospect totali B2B nel periodo (WEB). Il valore assoluto (quante persone, quante ore) resta utile come nota di contesto nel record dell'idea, ma il campo Reach usato per il punteggio è sempre la percentuale.

  **Popolazione di riferimento (denominatore).** Il numero usato come denominatore per ciascuna Product Line non è lasciato alla stima soggettiva di chi compila il RICE: va dichiarato esplicitamente e mantenuto aggiornato come dato di riferimento condiviso (non ricalcolato ogni volta a occhio). Ogni Product Line deve avere un denominatore definito e la relativa fonte dati (es. DataBricks), con un owner responsabile di tenerlo aggiornato periodicamente. Finché questa dichiarazione non è formalizzata per ogni Product Line, il Reach normalizzato resta un'approssimazione e va trattato come tale nelle decisioni di priorità.
- **(I)mpact →** Quali sono gli impatti attesi? Faremo più soldi (molti o pochi)? Ne risparmieremo? In caso sia un topic legale, quali sono i rischi se non lo accogliamo? Un ottimo modo per esprimerlo è dire "fatto 10pt il valore dell'EBITDA incrementale atteso nell'anno, quanto vale in EBITDA questa attività?" — un manager di linea ha sicuramente il polso di questo valore. **Target 2026 → 300k incrementali** (l'incremento atteso sull'anno, non il totale a budget — vedi `product/reference/annual-target.yaml`). Iniziativa da 100k vale ~3pt.
- **(C)onfidence →** Misura **la qualità dell'evidenza a supporto delle stime di Reach e Impact** — non quanta analisi abbiamo fatto, non quanto è maturo il progetto. Sono due cose diverse: si può aver condotto un'analisi molto approfondita e scoprire che il dato sottostante resta comunque debole o parziale (vedi Episodio 4: analisi "quantitativa e precisa" con Confidence alta, ma il quadro si è rivelato distorto). Il criterio è quindi il tipo di evidenza disponibile, non lo sforzo investito per raccoglierla:
  - Score 1-3: opinione o istinto, nessun dato a supporto
  - Score 3-6: dato aneddotico o singola fonte non verificata (es. una email, una stima a voce)
  - Score 6-8: dato quantitativo verificato da almeno una fonte primaria (DataBricks, contratto, ticket storico)
  - Score >8: dato quantitativo verificato da più fonti indipendenti, o validato con un esperimento

  La maturità dell'analisi (quanto lavoro di scoping è stato fatto) si riflette nelle fasi successive (Preliminary/Complete Analysis) e nel progressivo consolidamento dell'evidenza — non va confusa con Confidence.
- **(E)ntanglement → footprint del cambiamento.** Quanto l'iniziativa è intrecciata col resto del sistema: quanti componenti, sistemi e team tocca, quanto è ampia la superficie di regressione, quanto sono complessi review e rollout. **Non è una stima di tempo-sviluppatore** — con Claude Code il tempo di codifica si è scollegato dal costo reale del cambiamento, e quello che resta (capire le conseguenze, revisionare, coordinare, contenere i side-effect) è ciò che il RICE vuole al denominatore. Un cambiamento che tocca una riga in un componente ha Entanglement basso; uno che tocca 17 cose in 3 sistemi ha Entanglement alto. Scala 1-10: 1-2 un componente/un sistema; 3-5 più componenti in un sistema o un'interfaccia con pochi consumer; 6-8 più sistemi o molti consumer o dato cross bounded-context; 9-10 cambiamento strutturale trasversale. I costi esterni hard non comprimibili (legale, licenze, UAT estesa) alzano comunque il punteggio. Quando i repo sono in `apps/`, `rice-update` ispeziona il codice per la stima; è una prima passata, raffinabile in Complete Analysis. La stima di tempo-calendario per la pianificazione vive altrove (`delivery.estimated_effort_weeks`, in Iteration Planning).

Nessuno di questi parametri richiede una precisione chirurgica nell'esprimere una valutazione, ma avere degli ordini di grandezza (scala 1:10) aiuta a comprendere cosa sia prioritario oggi e cosa no.

Aha! offre un pannello apposito per inserire le valutazioni. Una volta popolate, le valutazioni ci permetteranno di mettere in ordine ogni possibile idea con tutte le altre.

Il framework può essere usato male (mettendo tutti valori falsi per farsi mettere un'idea in priorità). **Questo è un grave atto di irresponsabilità manageriale perché forza il perseguimento del proprio interesse anziché l'interesse dell'azienda** (voglio a tutti i costi qualcosa perché mi semplificherà il lavoro anche se gli impatti generali non saranno così alti). Se uno stakeholder pensa davvero di avere un asso nella manica che il framework RICE non riesce a catturare correttamente, può sempre invocare la Strategic Exception in accordo col CEO: può capitare! Tuttavia, se ogni settimana c'è un'eccezione, beh, non è più un'eccezione ;)

Importante: essere in priorità 1 non significa che ora il team si fionda a fare quel cantiere. Vedremo dopo le altre cerimonie che non sono ASAP. Per interrompere l'agenda di sviluppo con una nuova attività immediata si deve ricorrere sempre alla Strategic Exception.

*Principi da incarnare per essere allineati e lavorare con profitto in questa fase del Playbook:*

- *Committenti e sviluppatori devono lavorare insieme quotidianamente per tutta la durata del progetto.*
- *I processi agili promuovono uno sviluppo sostenibile. Gli sponsor, gli sviluppatori e gli utenti dovrebbero essere in grado di mantenere indefinitamente un ritmo costante.*

> **Cronache di EPASSI ITA — Episodio 2.**
> Nel primo pomeriggio del giorno successivo, Franco del team di sviluppo è disponibile per prendersi qualche minuto con Filiberto e Gennaro riguardo l'ultima trovata di Filiberto per fare efficienza. Franco ha tante cose da fare, rispettiamo il suo tempo (ma non possiamo fare a meno di lui per proteggere il suo stesso tempo da attività inutili o pericolose...). Gennaro è il facilitatore del meeting. I tre hanno dato un'occhiata alla descrizione su Aha! prima dell'appuntamento ed hanno già alcune idee: a) Filiberto ha verificato che il problema si verifica nel 30% delle ricevute non riconosciute che sono il 30% del totale (una Reach totale del 15%); b) ha stimato che se il problema fosse del tutto risolto, risparmieremmo 4 FTE al backoffice (sono 100k l'anno di EBITDA salvati, circa un terzo dei 300k di crescita attesa dell'EBITDA nel 2026, che valgono ~3pt di impatto atteso); c) le sue analisi sono assolutamente quantitative e precise con evidenze chiare, per cui se lo facessimo otterremmo con altissima probabilità l'impatto atteso (confidence 10pt); d) l'Entanglement è sorprendentemente basso: basta escludere una regola che fa da filtro nel motore di approvazione — un solo componente, un solo sistema, nessun consumer esterno (2pt). Il meeting si conclude con grande soddisfazione di tutti: questa idea è ora al terzo posto nella lista delle priorità. Filiberto è contento e sboccia, sa che di lì a poco si farà. Il resto del team prende semplicemente un caffè e torna sulla tastiera, ora c'è altro in pentola...

**✅ Checklist operativa**

- [ ] I quattro parametri RICE sono stati compilati su Aha! (Reach, Impact, Confidence, Entanglement)?
- [ ] Reach è espresso come percentuale (0-100) sulla popolazione rilevante della Product Line, non come valore assoluto?
- [ ] Confidence riflette la qualità dell'evidenza a supporto della stima (non la quantità di analisi svolta)?
- [ ] Il referente tecnico ha validato la stima di Entanglement (footprint del cambiamento) ad alto livello?
- [ ] Lo stakeholder proponente ha confermato i valori di Reach e Impact?
- [ ] L'idea è stata confrontata con le prime 5 in backlog per coerenza del ranking?
- [ ] Se il RICE score è basso: è stata comunicata allo stakeholder la motivazione del posizionamento?

## Product Backlog Refinement

*"Plans are useless, but planning is indispensable." — **Dwight D. Eisenhower***

Il team PM (tutti) e IT (tutti) stabilisce un giorno della settimana in cui fissare una riunione molto importante per pianificare le attività che, trovandosi in cima alle priorità, potrebbero avere spazio nell'agenda del team IT nei prossimi giorni o settimane. Il team usa la metafora delle "iterazioni settimanali" (o, per gli amici di SCRUM, "sprint") come metafora che aiuti il resto dell'organizzazione, specie fuori da prodotto/tecnologia, a comprendere come i flussi di lavoro del team abbiano bisogno di periodi superiori al "giorno" per essere portati normalmente a compimento e per dare un'idea delle possibili date di rilascio, non in termini di "giorno esatto" ma di periodizzazione (per convenzione noi usiamo la settimana).

> **Nota del relatore riguardo SCRUM [Nicola].** Io sono un fan di approcci più Kanban: una cosa dopo l'altra, se ben ordinate per priorità, viene smarcata (ammesso che il team abbia ciò che serve per smarcarla). In sintesi, credo che Scrum sia un tool per i CEO e non un tool per i team di sviluppo. Produrre un GANTT che rappresenti a che punto del trimestre la feature X nello sprint Y sarà rilasciata è un modo sofisticato per dire "non mi fido di come il team sia autoresponsabilizzato sul rilasciare valore quanto prima, quindi per sicurezza mi annoto una deadline e verifico che le persone si allineino a quella". Personalmente, ne ho un'opinione molto negativa. Le persone devono venire prima del tool (appunto SCRUM o GANTT). Prendo il buono del concetto di iterazione periodica (in questo caso settimanale) per razionalizzare il lavoro ed avere una sequenza cronologica. Questo aiuta il team anche a migliorare la propria capacità di fare "stime" (non promesse!). Le stime sono un'arte che si impara facendo errori, ma se la Product Governance basata su SCRUM rischia di evocare concetti inappropriati come "il fallimento dello Sprint" (approccio non promosso da SCRUM ma talvolta usato) — in questo caso per me l'agilità (la collaborazione) è finita: la prossima volta il team stimerà il 20% in più, non perché serve ma per evitare di essere giudicato sulla performance nell'implementazione. Cosa che produce verbosità, rallenta la velocity, fa notare un calo della performance, mette gli sviluppatori nelle condizioni di prendersela comoda (ho finito lo Sprint in anticipo, ho diritto a riposare anziché prendere la prossima attività prioritaria): quindi l'azienda rallenta, quindi cala la fiducia nel team. Ricordiamo: fermo restando il valore delle cose a destra (il tool, come SCRUM), vengono prima gli individui e le interazioni tra di loro.

La nota sottolinea un concetto chiave: l'output di questa riunione NON è la definizione del piano che SICURAMENTE sarà implementato la settimana successiva o la settimana X. **Serve per popolare un backlog di cose in cui crediamo, in cui vogliamo investire del tempo di prodotto e tecnologia nelle giornate o settimane successive.** Questo elenco è sicuramente più ampio dello spazio disponibile realmente e probabilmente comprende attività già in corso che vogliamo ultimare prima di passare alla prossima attività in cima alla lista.

Dal punto di vista pratico, il team si confronta davanti ad Aha! Attività numero 1 della riunione è creare la "release" corrente. Nel nostro contesto specifico, cercheremo di implementare strategie di CI/CD senza "date di rilascio specifiche" o particolari pianificazioni (salvo che la situazione non lo richieda espressamente). Quindi usiamo il tool delle Releases di Aha! come mero contenitore delle ipotesi di lavoro nella presente iterazione.

Una volta creata la Release ed inseriti i tag chiave (Goal ed Initiative che cerchiamo di impattare in questa iterazione, e quando dovrebbe partire il lavoro) possiamo passare alla fase successiva, che consiste nel popolare la Release con le feature in priorità.

Come accennavamo, la release potrebbe nascere come "duplicato" della release precedente (che magari è stata smarcata come "shipped" ma solo al 70%...). In questo caso è comodo duplicarla per trovarla già parzialmente popolata ed accelerare la compilazione successiva.

> **Nota particolare sulle Releases.** Il "Local Product Upgrade" è una release ad hoc: tale progetto è una commessa ad un consulente esterno, ha un GANTT semi-indipendente dall'agenda del nostro team e delle date di rilascio waterfall-like. In questi casi, usiamo la Release come metafora basica di contenitore di task di un progetto. Anche la Release "Platform Enhancement" ha una vocazione particolare: è un "parking lot" di attività di miglioramento tecnologico che fanno da sfondo allo sviluppo di prodotto. Le tracciamo qui perché appaiano nei GANTT complessivi dell'azienda, facendo emergere il lavoro di gestione del debito tecnico quando non può essere contenuto dentro una feature.

Ora il team è pronto per operare sulle idee promosse in feature. Le feature vengono aggiunte alla release appena creata. Via via che diverranno disponibili, popoleremo questa feature con nuovi dati come le specifiche di dettaglio (Miro, Confluence, Figma) man mano che i PM o Designer le raffinano (vedi fasi successive), commenti e discussioni.

Il grosso del lavoro è stato fatto al RICE scoring. Questa cerimonia formale però ha aggiunto dei particolari utili al team: 1) abbiamo preso coscienza di come sia andata l'iterazione precedente; 2) abbiamo un'idea di quali opportunità o cose di valore dovremo fare nel prossimo futuro. Può essere anche l'occasione per un piccolo momento retrospettivo: perché siamo riusciti a fare solo il 50% dell'iterazione precedente? Quali impedimenti sono sopraggiunti? Cosa è mancato a livello di informazioni? Alle volte basta un brutto raffreddore a spiegare perché qualcosa sia andato male. La consapevolezza è tutto. Ora l'azienda si affida alla professionalità del team per proseguire!

**60 minuti**. Deve durare anche meno, se possibile. Bando alle discussioni troppo dettagliate (prossima fase, analisi preliminare). Limitiamoci a constatare "che cosa l'azienda vede prioritaria e vorrebbe da noi nel prossimo periodo". **Va benissimo via Teams!**

*Principi da incarnare per essere allineati e lavorare con profitto in questa fase del Playbook:*

- *Consegniamo frequentemente software funzionante, con cadenza variabile da un paio di settimane ad un paio di mesi, preferendo i periodi brevi.*
- *I processi agili promuovono uno sviluppo sostenibile. Gli sponsor, gli sviluppatori e gli utenti dovrebbero essere in grado di mantenere indefinitamente un ritmo costante.*
- *A intervalli regolari il team riflette su come diventare più efficace, dopodiché regola e adatta il proprio comportamento di conseguenza.*

> **Cronache di EPASSI ITA — Episodio 3.**
> È un giovedì pomeriggio un po' sconfortante per tutto il team. Franco è stato poco bene per un paio di giorni e l'agenda è ancora fitta di cose da fare dalla settimana precedente. Marchiamo l'iterazione chiusa al 65% ma notiamo subito una buonissima notizia: le attività che rimangono dalla settimana precedente hanno dei RICE Score decisamente più bassi della feature di Filiberto — questo significa che anche se sono ancora lì da fare, saranno rinviate ancora di qualche giorno perché c'è qualcosa di davvero bellissimo che attira la nostra attenzione. Appena saremo pronti (lato prodotto, vedi fasi successive) e liberi lato tech (appena chiudiamo i task aperti), potremo passare ad una feature migliorativa che avrà forti impatti sul business. Facciamo una scelta forte: aggiungiamo SOLO due nuove attività al backlog — la nuova proposta di Filiberto ed un'altra (apparentemente) importante richiesta. Non consideriamo le altre più in fondo nel Product Backlog. Vogliamo il giusto focus!

**✅ Checklist operativa**

- [ ] La release corrente è stata creata o aggiornata su Aha! con Goal e Initiative di riferimento?
- [ ] Le feature prioritarie sono state aggiunte alla release corrente?
- [ ] Il team ha fatto una mini-retrospettiva sull'iterazione precedente (% completamento, impedimenti)?
- [ ] Le feature in backlog sono ancora coerenti con il RICE score? Qualcosa è cambiato?
- [ ] La durata del meeting è stata contenuta entro 60 minuti?

## Preliminary analysis

*"If you don't know why you are doing something, you shouldn't be doing it." — **W. Edwards Deming***

Il Product Backlog Refinement ha prodotto come output un elenco ordinato di feature in Aha! che sono inserite nell'iterazione che "formalmente" parte qualche giorno dopo: supponiamo che la convenzione dica che la riunione sia il giovedì pomeriggio, possiamo pensare che l'iterazione nuova cominci formalmente il lunedì, ma tutti saranno già con la mente alle prossime sfide o a concludere quelle rimaste dalle volte prima.

Il cambiamento più significativo è che le cose che erano prima in cima all'elenco ora possono essere cambiate. In questo momento il PM è la persona con più pressione addosso: a breve il team Tech potrebbe iniziare a sviluppare ma probabilmente gli mancano molte informazioni. Gli sviluppi sono (potenzialmente) bloccati per scarsità o disorganizzazione delle specifiche.

È ora di aprire Miro ed iniziare a rispondere ai quesiti chiave che guidino la comprensione del problema. Finora il Prodotto ha accettato senza troppe domande le proposte degli stakeholder (o le proprie medesime intuizioni). Inizia la fase di messa in discussione.

Il primo obiettivo è compilare semplicemente il box del **Why**. Tempo stimato: 15 minuti. In 15 minuti dobbiamo capire se la richiesta abbia o meno coerenza con la strategia globale (se lavoriamo con SMB o meno dipende dalla strategia aziendale). **Se il problema che vogliamo risolvere, o il perché esista il problema, è in conflitto con la strategia, allora è opportuno valutare se abortire l'iniziativa e passare ad una nuova attività.**

**✅ Checklist operativa**

- [ ] Il Why è stato compilato: qual è il problema reale che stiamo risolvendo?
- [ ] L'iniziativa è allineata alla strategia aziendale (Business Model Canvas)?
- [ ] Ci sono segnali tecnici evidenti che potrebbero cambiare il ROI? (verifica con tech lead)
- [ ] La decisione di procedere o di abortire è stata registrata su Aha!?
- [ ] Se si procede: il team tech è stato informato che l'analisi completa inizierà a breve?

Mentre il "Why" è assolutamente obbligatorio per completare questa fase, la sezione "What" richiede sicuramente un lavoro a due mani tra team tech e prodotto. Se l'iniziativa supera il blocco "Why" possiamo dire che ci troviamo nella via di mezzo tra la conclusione di questa analisi preliminare ed il completamento dell'analisi nel prossimo blocco. Può essere interessante iniziare a mappare se ci siano degli approfondimenti tecnici rilevanti che potrebbero condizionare significativamente il ROI atteso. Siamo ancora ad alto livello, ma spesso l'intuito e l'esperienza del team riescono a intuire i primi problemi fin da subito.

Opzionalmente potrebbe essere interessante iniziare a compilare la sezione "Who". Tale sezione è utile prevalentemente nelle fasi di discovery e di ridefinizione della strategia. Normalmente è chiaro dalla strategia di prodotto quali siano i customer personas (vedi introduzione sul Business Model Canvas o sulla SWOT analysis).

*Principi da incarnare per essere allineati e lavorare con profitto in questa fase del Playbook:*

- *La nostra massima priorità è soddisfare il cliente rilasciando software di valore, fin da subito ed in maniera continua.*
- *Committenti e sviluppatori devono lavorare insieme per tutta la durata del progetto.*
- *La semplicità — l'arte di massimizzare il lavoro non svolto — è essenziale.*

> **Cronache di EPASSI ITA — Episodio 4.**
> Gennaro è carichissimo. Nemmeno il tempo di congedare il team dal Backlog Refinement che già è su Miro a compilare i template per fare il recap dei problemi. Tensione altissima: non capita tutti i giorni di poter fare un quick-win che vale il 20% del target annuo dell'EBITDA! Mentre butta giù con grande agilità la definizione del problema, si trova improvvisamente spiazzato davanti al Why. Dalle conversazioni fatte finora è palese che è un tema di taglio dei costi: persone che ora lavorano sul progetto dovranno essere riposizionate. La sua mente si ferma un attimo sulle implicazioni, in un certo senso "etiche", di questo sviluppo. Che ne sarà dei colleghi? Intanto segna nel blocco What gli impatti economici (ROI) attesi. Franco gli conferma che lo sviluppo è ridicolo, costo zero... per Gennaro sembra che avverrà l'inevitabile. Anche Franco è frastornato, il software anziché aiutare le persone le penalizzerà. Sono già passati 15 minuti e Gennaro non è sereno a chiudere la fase così com'è. Apre Slack e lancia un Huddle a Filiberto, che fortuitamente era disponibile: "Filiberto, devi aiutarmi a comprendere bene PERCHÉ facciamo questa attività, io e Franco non siamo convinti... forse non siamo sereni all'idea e vorremmo comprendere meglio i valori dell'iniziativa sperando che vadano oltre il vil denaro". Inizia la 5 whys analysis: "Perché vogliamo migliorare il processo di automazione?" (×3 domande, finché) "In quanto per aggredire il segmento SMB dobbiamo ricalibrare le nostre priorità e lo staff: automatizziamo quanto più possibile per concentrare le persone su nuovi scenari operativi." "Wow, fermi tutti". Quindi nel breve termine stiamo comprando efficienza operativa ma il ROI ipotizzato in realtà non è veritiero... quel costo rimarrà ma si spera che creerà valore nel futuro in altro modo... Filiberto ha potuto condividere solo una parte della realtà dei fatti, creando una distorsione nella percezione del team: voleva ottenere efficienza nel medio/lungo termine ma l'ha promossa come efficienza di breve termine. **Questo potrebbe cambiare il RICE scoring e portare alla rimozione dell'attività dalle priorità!** Inoltre Gennaro è molto perplesso: il "who" iniziale (il nostro attuale Customer Base) è cambiato in un attimo con un huddle fatto quasi per caso. Dal solito LMB ad un segmento SMB che però NON È PARTE DELLA STRATEGIA DI PRODOTTO. L'iniziativa quindi dovrebbe essere annullata anche per un motivo di grave incoerenza strategica! Filiberto però ha subito annusato il rischio. Alza lo sguardo e davanti alla sua postazione c'è Augusto che, in qualità di Strategic Advisor, interviene: "Gennaro, purtroppo non siamo ancora nelle condizioni di allinearci tutti al 100%, questioni di riservatezza sui progetti futuri. Ma posso sicuramente anticiparti che questa mossa riguarderà il futuro parco clienti SMB. Se il processo è rigido e pensi che per questo motivo dovremmo fermare tutto, parliamone: nel caso tiriamo in causa Alberto ed invocheremo la gestione di una Strategic Exception". Gennaro però con l'Agile si è preso bene e sa che la **collaborazione** e la **risposta al cambiamento** sono dei valori guida per il suo lavoro. Il cantiere va avanti e Gennaro e Franco sono molto più felici di sapere sia che i loro colleghi hanno un grande futuro in azienda, sia di essere parte attiva dell'evoluzione dell'azienda. Aggiorna Aha! con i link al Miro appena creato. E fu sera e fu mattina...

## Complete analysis

*"Without data, you're just another person with an opinion." — **W. Edwards Deming***

In questo momento il PM ha in mano preziose informazioni sul Why, gli impatti ed una o più feature utili per risolvere il problema. Procediamo con un'analisi di dettaglio che comprenda sempre l'uso di un framework visivo su Miro per completare il What e definire una GTM Strategy. A questo punto è necessario puntualizzare che il go-to-market è molto diverso a seconda della portata della feature e degli utenti coinvolti. Alcuni esempi:

- **Introdurre un miglioramento su un processo interno**
  - Basso livello di allineamento esterno
  - Probabilmente verrà visto un miglioramento anche all'esterno, ma sarà del tutto trasparente per gli utenti delle nostre piattaforme
- **Clienti e beneficiari vedranno un miglioramento molto piccolo**
  - Solitamente può essere rilasciato "appena pronto"
  - Se la modifica può impattare il flusso di lavoro degli utenti, può essere opportuno segnalarla con un tooltip o un feedback visivo
- **Il miglioramento introduce una nuova funzionalità che prima non c'era**
  - Risolve un problema nuovo o risolve un problema vecchio in modo del tutto differente dal passato
  - È importante allineare vari stakeholder (Sales, Marketing ed Operations), sia per prevenire errori nel processo
  - In accordo col Product Marketing Manager, potrebbe essere opportuno inviare comunicazioni più complete (una email? Un giro di chiamate?)
  - La pianificazione del rilascio è comunque flessibile: va bene anticipare l'evento agli utenti, ma il lancio della novità non è così disruptive da appesantire il flusso
- **La modifica è EPOCALE**
  - Servono varie sessioni di UAT per verificare che sia chiaro cosa stiamo facendo e comunicando agli utenti: non possiamo sbagliare!
  - Lo devono sapere tutti per tempo (anche settimane o mesi)
  - Va probabilmente lanciata con uscite stampa, convention, mesi di hype
  - Al momento del lancio si ordina la pizza, si va tutti in ufficio e si porta pazienza osservando in tempo reale se/come tutto funzioni: mission critical

Non vogliamo entrare troppo nel merito del lavoro del Product Marketing Manager. Citiamo solo che è importante che sia coinvolto in questa fase del processo. È lo stakeholder chiave per mappare il "When" (go-to-market). È il garante della risposta più appropriata ai punti appena elencati, la persona migliore per scegliere l'opzione più adatta a questo caso. Il PM, anche in questo caso, è prevalentemente un facilitatore: ascolta, trascrive, supervisiona il processo.

### PRD sizing: il principio dell'A3 Thinking

> *Questo è l'unico blocco della sezione Complete Analysis rivisto in questa versione del documento (v4), a seguito di un problema ricorrente osservato in pratica: i PRD prodotti tendevano a essere lunghi, a duplicare informazioni già presenti altrove (in particolare il RICE score) e a diventare difficili da revisionare in una singola iterazione di lettura.*

Un PRD non è il posto dove si documenta tutto ciò che si sa su un'iniziativa. È il posto dove si documenta **ciò che serve per prendere una decisione o per implementare**, nella quantità minima che permette a chi legge di farlo in un unico passaggio di attenzione. Ci ispiriamo qui al principio dell'**A3 Thinking** (Toyota): non "un documento corto" in senso letterale, ma un vincolo di spazio che *forza* chiarezza — impedisce di annegare la decisione in prosa e obbliga a separare ciò che è essenziale da ciò che è contesto.

**Regola pratica.** Un PRD dovrebbe poter essere letto e verificato in un'unica iterazione, in un tempo paragonabile a due facciate A4 se esportato in PDF. Se il contenuto necessario supera questa soglia, la risposta corretta non è comprimere la prosa, ma **spaccare l'iniziativa in più PRD**, secondo il criterio seguente.

**Il criterio di split è il problema, non il conteggio delle pagine.** Un PRD si divide quando il *What* genera sotto-problemi con rischio tecnico, owner o stakeholder chiaramente distinti tra loro — non quando il documento "è arrivato a pagina 3". Tagliare per lunghezza produce frammenti che non si capiscono da soli; tagliare lungo le cuciture naturali del problema produce documenti verticali, ciascuno giudicabile (accettare/rifiutare/rimandare) senza dover leggere gli altri per avere il quadro.

**Sequenza di lettura ≠ sequenza di rilascio.** Se un'iniziativa produce più PRD consecutivi, ognuno deve dichiarare esplicitamente due cose separate, perché non coincidono per definizione:
- in che ordine questi documenti si capiscono (sequenza di lettura — un aiuto cognitivo per il reviewer);
- in che ordine, se e quando, questi pezzi finiranno in produzione (sequenza di rilascio — che può essere indipendente, parziale, o assente).

Confondere le due cose è il modo più rapido per generare aspettative sbagliate nel Roadmap Update.

**Cosa NON deve comparire in un PRD, perché vive altrove e va solo referenziato:**

- **Il RICE score.** Se un'iniziativa ha un PRD, è perché ha già superato la fase di Ideas Prioritization: il RICE è già stato deciso altrove (nel backlog idee) e ripeterlo nel PRD significa rimettere in discussione, in un documento sbagliato, una decisione già presa. Il PRD riporta solo un riferimento (link/ID) all'idea di origine, con lo score al momento del via libera — se il RICE cambia successivamente per nuova evidenza, l'aggiornamento va fatto lì, non creando una seconda fonte di verità nel PRD.
- **Framework generali già formalizzati altrove** (Business Model Canvas, matrice GTM a 4 livelli, glossario DDD, Customer Personas). Il PRD cita la scelta specifica fatta per quel caso ("GTM: livello 2 — perché: ...") con link al documento canonico, non ridescrive il framework.

**Scheletro consigliato per un PRD "A3-sized":**

1. **Header** — link all'idea/RICE di origine, owner, stato, sequenza di lettura e (se applicabile) sequenza di rilascio dichiarate separatamente
2. **Why** — poche righe: il problema e perché ora (non un saggio)
3. **What** — scope preciso, elenco puntato, non narrativa
4. **Who** — solo se rilevante; spesso è già ovvio dalla strategia e va omesso
5. **Metriche** — 1-3 KPI massimo, con baseline e target; il ragionamento su come si è arrivati alla scelta della metrica resta nell'idea di origine, non qui
6. **How** — bullet ad alto livello: cosa serve sapere per capire il footprint del cambiamento (sistemi/componenti toccati, blast radius) e stimare la delivery, non la specifica tecnica completa
7. **Rischi e dipendenze aperte**
8. **Link al prossimo PRD della sequenza**, se esiste, con dichiarazione esplicita se è dipendenza di rilascio o solo di lettura

Questo scheletro va applicato ai contenuti descritti nel resto di questa sezione (Complete Analysis) — diagrammi di flusso, terminologia DDD, KPI — con lo stesso principio: solo la scelta fatta per *questo* PRD, non la ripetizione del framework generale.

---

Il PM ora costruisce tutte le specifiche nel dettaglio che serviranno al team per procedere con l'implementazione. Capita sovente che un processo vada descritto, ed un ottimo modo per farlo è l'uso dei diagrammi di flusso. C'è tanta bibliografia in merito e non è un tool specifico del nostro processo, è solo una proposta per rappresentare concetti.

Può essere opportuno citare anche il Domain Driven Design in questa fase del processo. Dare nomi alle cose è un'attività molto importante e stabilire i corretti confini di ogni oggetto che stiamo mappando conta: sia perché influenza come il team di tecnologia interpreta una parola chiave, sia perché quel termine diventa poi parte del gergo aziendale (Dominio). In breve: non esiste un sistema di convenzioni di nomi "tecnico" ed un sistema di convenzioni di nomi "aziendale". C'è solo un unico dizionario con cui tutti si confrontano.

Un "customer" lo è per tutti. Nel nostro dominio abbiamo alcune sfide di identificazione e soluzione del dizionario: Chi è un cliente? Ed il beneficiario? A volte li chiamiamo Employer o Employee... ma possono esistere dei clienti che non siano Employer (magari dal mondo VIP District...). E tra tutti questi, chi sono gli "utenti" della piattaforma? I Beneficiari? Ma i Merchant che accedono per i flussi App2App sono utenti a loro volta? **[TODO]**

Arriviamo all'ultima parte dell'analisi che il PM è chiamato a fare: quali **metriche** vogliamo impattare con questo sviluppo. Le KPI che saranno scelte hanno almeno due funzioni:

1. Servono per **stabilire qualcosa di misurabile fin da subito** e che, verificandosi, produca a sua volta l'impatto di business atteso — ad esempio il ROI atteso e definito nel What. Possono essere più di una. Sicuramente devono essere correlate alla North Star Metric che il PM presidia principalmente.
2. Aiutano molto il team implementativo a stabilire parti dell'How. Se la metrica dice che ci sarà un impatto sul Conversion Rate sul flusso di prenotazione per i beneficiari, ci aspettiamo che la UI/UX consideri questa informazione nel formulare i funnel graficamente. **Le metriche orientano i comportamenti del team.**

Normalmente si associa alla ricerca della KPI sia un valore di partenza (valore attuale raccolto dai vari database applicativi, tool di analytics, PowerBI, **DataBricks** in particolare) sia un valore di destinazione (target). Il PM è responsabile di definire ed osservare nel tempo l'andamento di queste metriche fino alla stabilizzazione. **Il PM è un utente DataBricks sufficientemente autonomo da costruire da solo delle dashboard per tenere facilmente sotto controllo le feature rilasciate di recente. Il PM deve prendere delle iniziative, tra cui mettere in priorità nuove idee laddove le KPI non stiano raggiungendo i risultati attesi.** Nelle fasi successive ribadiremo che il lavoro non finisce col rilascio.

Citiamo che anche in questa fase c'è un rischio che la feature venga rinviata o annullata:

- Le KPI potrebbero non essere sane o disponibili.
- Il ROI si rivela diverso da quanto ipotizzato precedentemente.
- Potrebbe esserci un approfondimento che cambia il RICE Score.

In questa fase inizia a prendere forma la sezione di "How", per il momento compilata fondamentalmente dal team prodotto.

*Principi da incarnare per essere allineati e lavorare con profitto in questa fase del Playbook:*

- *La nostra massima priorità è soddisfare il cliente rilasciando software di valore, fin da subito ed in maniera continua.*
- *Committenti e sviluppatori devono lavorare insieme per tutta la durata del progetto.*
- *Il software funzionante è il miglior metro di misura del progresso.*

> **Cronache di EPASSI ITA — Episodio 5.**
> La notte ha portato consiglio a Gennaro. Anche se la feature in oggetto somiglia molto ad una Strategic Exception (roba da fare, poco da pensare o pianificare) ha concluso che se un domani la SMB diventerà la nuova customer base di riferimento, avrebbe senso interpretare questa feature come fosse già parte del tutto. Prima di tutto vuole i numeri. Apre Databricks e nota una cosa che non aveva mai visto: il numero di clienti con meno di 250 beneficiari è basso (meno del 10%) ma sono 3 mesi di fila che raddoppia di mese in mese: c'è un bel trend che possiamo cavalcare! Inizialmente pensa in grande e si domanda se questa sia la KPI ideale per osservare il successo o meno dell'iniziativa. Ma poi ci ragiona: aumentare la nostra velocità di gestione documentale porterà più clienti? Non in modo diretto... porterà le condizioni per cui i sales possano spingere il canale, ma non clienti in senso stretto. Cambia idea e torna a pensare all'80/20. Su Databricks è ben evidenziato il tasso di fallimento di approvazione documenti con AI (il famoso 30% dei casi che anche Filiberto aveva evidenziato). È chiaro che questo numero deve cambiare e possiamo impattarlo in modo molto diretto con questo sviluppo. Nuovo obiettivo: portare il numero sotto il 20%. Non ci sono grandi diagrammi di flusso da fare (è un bel quick-win) ma nella mente di Gennaro c'è ancora l'accorato discorso di Augusto sul valore strategico di questa attività. Gennaro decide che fare un passaggio con Gianna, la Product Marketing Manager, non fa mai male. Gianna comprende al volo dove l'azienda sta andando e per il team di Marketing non è una cosa del tutto nuova. Gianna approfitta dell'occasione per far vedere a Gennaro un po' di nuove ricerche: quali sono i nostri competitor in quello spazio di mercato? Quanto è grande potenzialmente (sarebbe una svolta pazzesca, l'azienda diventerebbe 10x!)? Ma la cosa che Gennaro porta a casa più di tutte è il confronto che Gianna ha fatto con le piattaforme dei competitor: tutte hanno la buzzword AI infilata in ogni pagina dei loro siti. Lo fanno per davvero? Usano, come noi, l'AI almeno per i processi interni? E perché non usarla per migliorare i flussi dei beneficiari? 30 minuti con Gianna davvero ben investiti. Decidono una cosa fondamentale per la GTM strategy di questa feature. Anche se si tratta di un micro sviluppo e che apparentemente ha un impatto solamente interno, dobbiamo cavalcarlo per spiegare ai nostri clienti (attuali e futuri) che noi sull'AI siamo sul pezzo! Gianna prende la sua call-to-action di discutere col suo team una campagna di comunicazione. Gennaro esce dal meeting con una serie di idee che ora scriverà su Aha! **La prossima settimana il Refinement sarà davvero combattuto: abbiamo idee che svoltano!**

**✅ Checklist operativa**

- [ ] Il What è definito: quali sono le funzionalità o i cambiamenti attesi?
- [ ] Il PRD rispetta il vincolo di dimensione A3 (circa due facciate A4 in PDF)? Se no, è stato spaccato lungo le cuciture del problema (non per conteggio di pagine)?
- [ ] Se il PRD fa parte di una sequenza: sono dichiarate separatamente la sequenza di lettura e quella di rilascio?
- [ ] Il RICE NON è ripetuto nel PRD, ma solo referenziato con link all'idea di origine?
- [ ] I framework generali (Business Model Canvas, GTM, DDD) sono citati per riferimento e non ridescritti?
- [ ] Le KPI di successo sono state identificate e hanno un valore base (baseline) su DataBricks?
- [ ] Il target della KPI è stato definito e condiviso con lo stakeholder?
- [ ] La GTM strategy (When) è stata discussa con il PMM?
- [ ] L'How di alto livello è stato abbozzato in collaborazione con il team tech?
- [ ] Il ROI atteso è ancora coerente con il RICE score originale? Se no, il ranking è stato aggiornato (nella fonte di verità, non nel PRD)?

## Roadmap update & Iteration planning

*"You don't need to be perfect. You need to be fast and learning." — **Eric Ries***

Qualche giorno dopo il backlog refinement, il team dovrebbe avere le informazioni utili a confermare o riorganizzare l'agenda concreta del team di tecnologia e design. Ipotizzando che il Refinement sia avvenuto di giovedì, il lunedì successivo potrebbe essere chiamata la riunione di conferma dell'agenda.

Questo meeting serve sostanzialmente per fissare un'agenda di appuntamenti e scadenze di breve termine per il lavoro concreto del team. Ed il team di tecnologia cambia approccio. Ora non è ammesso nessun contributo passivo, bisogna decidere concretamente cosa fare. Di fatto, ci si concentra nella parte più operativa del blocco How.

- Servono dei flussi visivi? Abbiamo qualche schizzo di mockup? Quando sarà possibile per il Product Designer realizzare questi flussi?
- In che giorno pensiamo di approvare (o no, se richiesto) i flussi UX/UI? Ci servono per definire le User Stories?
- Se apriamo insieme i GANTT della roadmap di prodotto su Aha!, i tempi sono coerenti con le conversazioni che stiamo avendo, o dobbiamo assicurarci che l'azienda non veda dati errati e non si faccia aspettative sbagliate?

Il team di tecnologia ora ha una responsabilità fondamentale: rileggendo tutto il materiale descritto schematicamente dal PM (why, what, ecc.), chiarire se ci siano ipotesi tecnologiche che spingano il rollout accelerato: 80/20. "Se cambiamo questo nel requisito descritto nel What, anziché 10 giorni facciamo tutto in 2 giorni. Siamo sicuri che quella parte sia così importante?" Il team di tecnologia qui deve comunicare in termini di Rischio-Rendimento. Nessuno (PM o Stakeholder) ha la sfera di cristallo. Tutte le feature sono "ipotesi" con cui speriamo di creare un impatto nelle metriche stabilite e quindi valore per l'azienda. Ma sono scommesse. Non sappiamo come andrà. Ogni scommessa porta con sé un "rischio". Se il ritorno è basso ma l'investimento è alto, il rischio è irragionevole! Ma anche qualora il rendimento atteso fosse altissimo, contenere il rischio è sempre una buona cosa. Dobbiamo diventare tutti molto bravi a capire cosa possiamo fare per contenere il rischio.

Alla fine di questa fase, la cosa più bella è constatare che una cosa che sembrava difficile può essere ricalibrata perché sia più facile (meno rischiosa). Finire il lavoro sapendo che se anche "ci siamo sbagliati, possiamo comunque procedere perché abbiamo condotto iterazioni reversibili o investimenti modulari": Fail Fast.

*Principi da incarnare per essere allineati e lavorare con profitto in questa fase del Playbook:*

- *Accogliamo cambiamenti anche a fasi avanzate del processo di sviluppo. I processi agili sfruttano il cambiamento a favore del vantaggio competitivo del cliente.*
- *Le architetture, i requisiti e la progettazione migliori emergono da team che si auto-organizzano.*
- *La semplicità — l'arte di massimizzare il lavoro non svolto — è essenziale.*

> **Cronache di EPASSI ITA — Episodio 6.**
> Ogni settimana l'iteration planning è una vera battaglia. Tutti contro tutti perché le risorse sono poche e sembra che ogni settimana se non facciamo il 120% l'azienda chiuderà. Questo lunedì però Gennaro è più positivo del solito. C'è poca carne al fuoco e forse un quick-win darà impatti grandiosi. C'è da dire che Franco, già nelle fasi di analisi di alto livello, ha messo in pratica il fondamentale principio di Pareto (80/20). Sarà la rimozione del filtro la soluzione al problema della miglior approvazione automatica delle procedure? Difficile a dirsi. Ma l'esperimento merita di essere fatto in questo modo semplicissimo. Se così fosse e non ci fossero effetti collaterali, sarebbe un successo! Il team però incappa in un imprevisto. Considerando le cose che abbiamo in sviluppo al momento e la Roadmap, sembra che questo lavoro, per quanto velocissimo, non sarà possibile farlo prima di 10 giorni! Sarà anche un "win" ma non sembra così "quick" a causa delle altre cose da fare. Come possiamo fare? Interrompiamo un'attività in corso o aspettiamo? Gennaro prende la parola: "è vero che stiamo gestendo questa feature che ha avuto un percorso quasi da Strategic Exception, con corsie preferenziali, ecc... ma se ragioniamo un momento vediamo che questo lavoro ha comunque impatti non immediati ma di medio termine (cambio della strategia commerciale) ed abbiamo visto nella sezione When che Gianna vorrebbe promuovere una comunicazione strutturata su questo fatto del potenziamento AI. Quindi è inutile incasinare l'agenda adesso, teniamo l'attività in cima alla lista dell'iterazione che inizia oggi ed appena c'è uno sviluppatore disponibile, si partirà!" **Make sense, Gennaro ;)**

**✅ Checklist operativa**

- [ ] Ogni User Story ha criterio di accettazione chiaro?
- [ ] Il team tech ha fatto la valutazione 80/20 su ogni storia?
- [ ] I task sono caricati su Jira e assegnati?
- [ ] L'agenda tiene conto del flusso di manutenzione ordinaria/debito tecnico?
- [ ] Le date di rilascio stimate su Aha! sono coerenti con quanto discusso?
- [ ] Gli stakeholder chiave sono stati aggiornati sulle aspettative di delivery?

## Product Design, development and rollout

*"Simplicity is the ultimate sophistication." — **Leonardo da Vinci***

L'agenda del team di tecnologia emerge dalla raffinazione delle proposte a livello di prodotto. Quando un'attività è matura a sufficienza, viene riportata da Aha! a Jira per diventare backlog effettivo del team tech. Il backlog è prioritizzato secondo l'approccio Kanban (vedi glossario).

Ogni attività può essere un'epica o divisa in varie user story.

### Daily Standup

Il team si riunisce ogni giorno per un massimo di 15 minuti. Il riferimento visivo è la board Jira, scorrendo da destra verso sinistra — dalla colonna più vicina al rilascio verso quella di sviluppo — per mantenere il focus su ciò che è prioritario completare.

Lo standup è facilitato dal CTO. Per ogni ticket in lavorazione vengono affrontate tre domande: cosa è stato completato ieri, cosa è in agenda oggi, cosa blocca l'avanzamento. L'obiettivo non è fare un report di status ma identificare impedimenti e assegnare un owner per risolverli entro la giornata.

Il PM partecipa attivamente: porta il contesto di priorità e business quando necessario, segnala se un blocco tecnico ha impatto sulla roadmap o sugli stakeholder, e si coordina con il CTO per scalare eventuali decisioni che richiedono un allineamento più ampio.

I commenti su opportunità o aggiornamenti di contesto che non richiedono una decisione immediata vengono parcheggiati e gestiti in modo asincrono o nel successivo momento di allineamento strutturato.

> **Sezione di competenza del CTO — in fase di definizione.** Questa sezione coprirà i seguenti ambiti: realizzazione dei design (Figma/Miro), scrittura delle User Stories su Jira, processo di sviluppo e testing, criteri di Definition of Done, modalità di roll-out in coordinamento con la GTM strategy definita nella fase When. Verrà integrata nel documento non appena il processo implementativo sarà formalizzato dal team tecnico.
>
> **Nota operativa.** In assenza di una DoD dichiarata dal CTO, una bozza può essere derivata ispezionando la board Jira reale (colonne, transizioni, campi obbligatori per chiudere una card). Questo dà un punto di partenza fattuale, ma va trattato come **ipotesi osservata dal comportamento attuale del team, non come DoD approvata** — il modo in cui il team lavora oggi non coincide necessariamente con ciò che il CTO considererebbe "fatto" se lo scrivesse. Poiché lo stato Jira alimenterà comunicazioni automatiche verso gli stakeholder (MBR, mail settimanale), questa bozza va confermata con Davide prima che il sistema la tratti come regola vincolante.
>
> **Definizione di "Done".** Una card è Done quando il codice ad essa relativo è **in produzione**. Punto. Non è Done perché ha prodotto l'output o l'outcome atteso: quella verifica appartiene alla fase di Measurement, non alla Definition of Done. Tenere separati i due concetti è importante perché altrimenti una card resterebbe aperta a tempo indeterminato in attesa che una metrica di business si muova — cosa che può richiedere settimane e dipende da fattori fuori dal controllo del team tech. "Done" risponde alla domanda "abbiamo consegnato?", non alla domanda "ha funzionato?" (quella è la domanda di Measurement).

*Principi da incarnare per essere allineati e lavorare con profitto in questa fase del Playbook:*

- *La continua attenzione all'eccellenza tecnica e la buona progettazione esaltano l'agilità.*
- *Le architetture, i requisiti e la progettazione migliori emergono da team che si auto-organizzano.*

> **Cronache di EPASSI ITA — Episodio 7.**
> *(episodio ancora da scrivere nella versione originale del documento)*

## Measurement

*"In God we trust. All others must bring data." — **W. Edwards Deming***

Abbiamo raggiunto gli obiettivi? Controlliamo su DataBricks con la giusta frequenza. Dobbiamo fare altre iterazioni o chiudere il flusso? Dipenderà dal rischio-rendimento. Dobbiamo gestire debito tecnico? Lo annoteremo su Aha! Dobbiamo buttare tutto? Capita: se abbiamo fatto il giusto MVP non avremo rammarico.

> **Nota sulla maturità attuale di questa fase.** Nella versione attuale del playbook, la fase di Measurement è volutamente essenziale. L'assenza di un datalake strutturato limita oggi la nostra capacità di costruire dashboard di osservazione sistematica post-rilascio. Le metriche vengono monitorate con gli strumenti disponibili (DataBricks, report manuali) ma senza ancora un processo formalizzato e ripetibile. Il potenziamento di questa fase è un obiettivo esplicito del percorso di crescita del team: quando gli strumenti lo consentiranno, questa sezione sarà espansa con processi di A/B testing, dashboard standard per ogni feature rilasciata, e cadenze formali di retrospettiva sui dati. Per ora, la cosa più importante è coltivare l'abitudine mentale: ogni feature rilasciata è un'ipotesi, e ogni ipotesi merita una verifica — anche informale.

Presentiamo i risultati. Facciamo dei video che raccontano le novità all'azienda. Usiamo i dati delle metriche per celebrare i successi. Quando invece va tutto storto, celebriamo di aver imparato. Non siamo veggenti, siamo coloro che cercano di creare un circolo virtuoso.

*Principi da incarnare per essere allineati e lavorare con profitto in questa fase del Playbook:*

- *A intervalli regolari il team riflette su come diventare più efficace, dopodiché regola e adatta il proprio comportamento di conseguenza.*
- *Il software funzionante è il miglior metro di misura del progresso.*

> **Cronache di EPASSI ITA — Episodio 8.**
> Il grande bluff. Filiberto aveva preso una cantonata. Alla fine il fatto che non ci fossero le voci nella ricevuta non aveva alcun impatto sulla probabilità di approvazione automatica o meno. Questo è vero solo nel 5% dei casi. Alla fine gli impatti sul business sono molti meno di quanto atteso. Ma il team è soddisfatto comunque. Con pochissimo lavoro ha condotto un esperimento prezioso, ha imparato qualcosa di più sul fronte AI ed ha gettato le basi per altri miglioramenti futuri (specie col marketing AI lanciato da Gianna). Ora c'è un gran numero di nuove idee su cui fare delle riflessioni. Una iterazione dopo l'altra il team proverà ad affrontarle nel corso del 2026!

**✅ Checklist operativa**

- [ ] Le KPI definite nella fase di Complete Analysis sono state misurate?
- [ ] Il valore attuale è stato confrontato con il target definito in origine?
- [ ] L'esito è stato presentato al team e agli stakeholder (video, slide o report)?
- [ ] Se il target non è stato raggiunto: è stato avviato un processo di analisi causa-effetto?
- [ ] Il debito tecnico generato è stato annotato su Aha!?
- [ ] Le nuove idee emerse dalla misurazione sono state aggiunte al bucket di Aha!?

---

# Come gestire le frizioni con gli stakeholder

Il framework descritto in questo playbook protegge il team e garantisce qualità delle decisioni. Ma il framework opera all'interno di un'azienda dove non tutti hanno letto questo documento, e dove la pressione esterna è reale e quotidiana. Questa sezione è dedicata a come il PM — e il team — dovrebbero comportarsi quando il contesto esterno non rispetta le regole del gioco.

## Il principio base: boundaries con empatia

Proteggere il processo non significa essere rigidi o burocratici. Significa essere i custodi della qualità delle decisioni nell'interesse dell'azienda. Ogni volta che un PM cede a una pressione non strutturata, non sta facendo un favore allo stakeholder: sta assumendo un rischio non quantificato, sottraendo risorse a priorità già valutate, e inviando un segnale al team che il processo è negoziabile. Il confine va tenuto con fermezza e con rispetto, spiegando sempre il perché.

## Scenario 1: Lo stakeholder che bypassa il processo

*"Ho bisogno che il team faccia questa cosa entro venerdì. È urgente." — via WhatsApp, alle 18:30.*

Questa situazione è comune, specialmente nelle fasi iniziali in cui il team non è ancora riconosciuto come struttura con processi propri. La risposta giusta non è né ignorare né cedere immediatamente.

**Come rispondere:** Ringrazia per la segnalazione, chiedi 15 minuti per valutare l'impatto sull'agenda corrente, poi rispondi con dati. Esempio: "Ho guardato l'agenda: il team ha due attività critiche in corso questa settimana. Se inseriamo questo ora, una delle due slitta. Quale delle tre ha la priorità più alta per il business in questo momento? Possiamo formalizzarlo come Strategic Exception se necessario." In questo modo non dici no, ma costringi lo stakeholder a fare una scelta consapevole e a prendersene la responsabilità.

## Scenario 2: La Strategic Exception che diventa abitudine

*"Lo so che è la terza volta questo mese, ma questa volta è davvero importante."*

La Strategic Exception esiste per gestire i casi davvero eccezionali. Se uno stakeholder la invoca ogni settimana, ha smesso di essere un'eccezione ed è diventata la norma parallela. Questo è un segnale che il processo non è ancora stato interiorizzato, oppure che la struttura delle priorità non è condivisa a livello aziendale.

**Come rispondere:** Porta i dati. Tieni traccia di ogni Strategic Exception — data, richiedente, oggetto, esito. Dopo tre o quattro episodi ravvicinati, porta il pattern all'attenzione del tuo diretto superiore non come lamentela ma come analisi: "Nel corso dell'ultimo mese abbiamo gestito quattro eccezioni dallo stesso canale. Il costo è stato X giorni di sviluppo sottratti alla roadmap. Vorrei capire se questo riflette una priorità strategica che devo incorporare nel processo ordinario."

## Scenario 3: Lo stakeholder che non capisce perché la sua idea non è in cima alle priorità

*"Ho proposto questa cosa tre mesi fa e non è ancora stata fatta. Non siete capaci di lavorare?"*

**Come rispondere:** La trasparenza è la migliore difesa. Mostra il RICE score della sua idea rispetto alle altre. Non come giustificazione, ma come condivisione del ragionamento. "La tua proposta è in backlog con un RICE score di X. Le tre cose che abbiamo fatto in questi tre mesi avevano score Y, Z e W. Non è una questione di capacità: è una questione di dove l'azienda ha scelto di investire il tempo disponibile. Se pensi che il punteggio non rifletta il vero valore, parliamone: magari ci sono informazioni che non ho."

## Scenario 4: La pressione dal top ("lo vuole il CEO")

*"Il CEO ha detto in riunione che vuole questa feature per fine mese."*

Questo scenario richiede il massimo equilibrio. Non è mai una buona idea ignorare un segnale che viene dall'alto — ma è altrettanto sbagliato eseguire ciecamente senza capire il contesto e senza comunicare i trade-off.

**Come rispondere:** Prima di muovere qualsiasi risorsa, cerca un confronto diretto — anche breve — con chi ha trasmesso la richiesta, idealmente con il CEO stesso se accessibile. Obiettivo: capire se è una direttiva strategica ferma o un'idea espressa in un momento di conversazione. Poi porta i trade-off in modo chiaro: "Possiamo farlo entro fine mese. Per farlo dobbiamo spostare X dalla roadmap. Confermo che è la scelta giusta?" La responsabilità della decisione torna dove deve stare.

## Il registro delle frizioni

Indipendentemente dallo scenario, il PM dovrebbe tenere un registro informale delle frizioni ricorrenti: chi, quando, su cosa, come è stato gestito, esito. Non per creare conflitti, ma per due ragioni pratiche. Prima: i pattern emergono e diventano dati con cui migliorare il processo o la comunicazione verso certi stakeholder. Seconda: se un giorno il processo viene messo in discussione, il PM ha evidenze concrete su come il team ha operato e perché.

> **Cronache di EPASSI ITA — Episodio 9.**
> È un martedì mattina e Gennaro trova in inbox un messaggio di Augusto, il Chief Revenue Officer, inviato la sera prima: "Gennaro, ho sentito che potremmo fare una cosa veloce per i Merchant. Ho promesso a tre clienti enterprise che avremmo avuto una novità entro fine mese. Fammi sapere come possiamo accelerare." Gennaro chiude il laptop per un secondo e respira. Sa già che il team ha l'agenda piena per le prossime due settimane e che la feature Merchant in backlog ha un RICE score medio — c'è ben altro davanti. Ma sa anche che Augusto non è un nemico: è qualcuno che ha fatto una promessa in buona fede senza avere il quadro completo. Gennaro risponde chiedendo 30 minuti di call per quel pomeriggio. Nella call, mostra ad Augusto la roadmap su Aha!, il RICE score della feature Merchant e le due attività in corso che rimarrebbero incomplete se si accelerasse ora. Augusto è sorpreso dalla chiarezza. "Non sapevo ci fosse tutto questo in ballo." Insieme decidono che la feature Merchant può aspettare tre settimane — Augusto gestirà la comunicazione con i clienti, Gennaro si impegna a dargli un aggiornamento ogni settimana sull'avanzamento. Nessuno ha perso la faccia. Il processo ha retto.

---

# Glossario

Riferimento rapido ai termini tecnici, di processo e di dominio utilizzati nel documento.

## Termini di dominio Epassi

**Beneficiario** — Il dipendente che utilizza la piattaforma Epassi per fruire dei benefit aziendali (buoni pasto, welfare, ecc.).

**Employer** — L'azienda cliente che acquista i servizi Epassi e li mette a disposizione dei propri dipendenti (Beneficiari).

**Employee** — Il dipendente dell'Employer. Coincide con il Beneficiario nel contesto della piattaforma di fruizione.

**Merchant** — Il negozio o esercente convenzionato che accetta i pagamenti tramite Epassi. Può accedere alla piattaforma tramite flussi dedicati (es. App2App).

**GMV (Gross Merchandise Value)** — Il valore totale delle transazioni processate sulla piattaforma. Uno dei KPI fondamentali del business.

**FTE (Full Time Equivalent)** — Unità di misura del lavoro equivalente a una persona a tempo pieno. Usato per stimare l'impatto di efficienza operativa.

## Termini di processo

**RICE** — Framework di prioritizzazione basato su quattro parametri: Reach (quante persone impatta), Impact (quanto vale in termini di business), Confidence (quanto siamo sicuri delle nostre stime), Entanglement (footprint del cambiamento nel sistema — quanto è intrecciato col resto, non quanto tempo-sviluppatore costa; sostituisce la vecchia "Effort" resa poco significativa da Claude Code). Il punteggio finale è R × I × C / E.

**NSM — North Star Metric** — Il KPI più importante che ogni PM presidia per la propria Product Line. Rappresenta la misura di successo principale a cui tutte le attività della product line devono contribuire.

**Strategic Exception** — Meccanismo che consente a una richiesta di bypassare il normale processo di prioritizzazione, su approvazione del CEO o del CPO/CTO. Deve essere rara e motivata. Se si verifica ogni settimana, non è più un'eccezione.

**Ideas Bucket** — Il repository (su Aha!) dove vengono raccolte tutte le idee, richieste e segnalazioni prima di essere valutate. Non è una coda di lavoro: è un archivio non ordinato da cui emergono le priorità.

**Product Backlog Refinement** — Cerimonia settimanale in cui PM e tech lead allineano le priorità e preparano il backlog per l'iterazione successiva. Non è una pianificazione ferma: è una fotografia aggiornata delle intenzioni.

**Why / What / How / When** — I quattro assi dell'analisi di ogni feature. Why: il problema reale da risolvere. What: cosa costruiamo concretamente. How: come lo costruiamo (user stories, architettura). When: la GTM strategy, ovvero quando e come lo comunichiamo al mercato.

**A3 Thinking** — Principio (Toyota) per cui un documento di decisione va vincolato a uno spazio ridotto (storicamente, un foglio A3) per forzare chiarezza e separare l'essenziale dal contesto. In Epassi ITA applicato al dimensionamento dei PRD: circa due facciate A4 in PDF; se un'iniziativa richiede più spazio, si spacca in più PRD lungo le cuciture del problema, non per conteggio di pagine.

**Fail Fast** — Principio lean che incoraggia a testare le ipotesi con il minimo investimento possibile, così da imparare velocemente e correggere la rotta prima di aver speso risorse significative.

**DDD — Domain Driven Design** — Approccio alla progettazione software che mette al centro il linguaggio e i concetti del dominio di business. Il principio chiave: non esiste un dizionario tecnico separato da quello aziendale. C'è un solo vocabolario condiviso da tutti.

**80/20 (Principio di Pareto)** — L'osservazione che l'80% del valore si ottiene spesso con il 20% dello sforzo. Applicato al prodotto: prima di implementare una feature complessa, chiedersi sempre se esiste una versione più semplice che produce la maggior parte del valore.

**Kanban** — Metodo di gestione visiva del lavoro che organizza le attività in colonne rappresentanti gli stati del flusso (es. To Do, In Progress, Done). L'obiettivo è limitare il lavoro in corso (WIP — Work In Progress) per aumentare la velocità di completamento e ridurre i colli di bottiglia. In Epassi ITA il Kanban è gestito su Jira e viene consultato quotidianamente durante lo standup. La lettura da destra verso sinistra — dalla colonna più vicina al rilascio — garantisce che il team focalizzi l'energia su ciò che è più urgente completare prima di iniziare nuove attività.

**Standup Meeting** — Cerimonia quotidiana di allineamento del team, della durata massima di 15 minuti. Il nome deriva dalla pratica di tenerla in piedi, per mantenere la riunione breve e focalizzata. Non è un report di status ma un momento di sincronizzazione operativa: si identificano blocchi, si assegnano owner per risolverli, si mantiene visibilità condivisa sull'avanzamento. In Epassi ITA è facilitato dal CTO con riferimento alla board Jira.

**Epica** — Unità di lavoro di alto livello che raggruppa un insieme di User Story correlate attorno a un obiettivo comune. Un'epica rappresenta una funzionalità o un'area di prodotto sufficientemente ampia da non poter essere completata in una singola iterazione. Viene scomposta progressivamente in User Story man mano che il team si avvicina alla fase di sviluppo. In Jira, le epiche fungono da contenitore organizzativo che permette di tracciare l'avanzamento complessivo di un'iniziativa e il suo contributo alla roadmap.

**User Story** — Descrizione di una funzionalità dal punto di vista dell'utente finale, formulata secondo lo schema: *"Come [tipo di utente], voglio [azione o funzionalità], in modo da [beneficio atteso]."* Non è una specifica tecnica ma uno strumento di comunicazione: serve a mantenere il focus sul problema dell'utente piuttosto che sulla soluzione tecnica. Una buona User Story è accompagnata da criteri di accettazione chiari — le condizioni verificabili che determinano quando la storia è completata. In Epassi ITA le User Story sono il livello operativo del backlog: vengono raffinate durante il Product Backlog Refinement e stimate dal team tech prima di entrare in iterazione.

## Ruoli

**PM — Product Manager** — Responsabile del successo di una Product Line e della relativa North Star Metric. Governa il processo dall'idea al rilascio, facilita le cerimonie e funge da interfaccia tra business e tecnologia.

**PMM — Product Marketing Manager** — Responsabile dell'allineamento con Sales e Operations sulla go-to-market strategy. Porta la voce del mercato nel processo di prodotto e gestisce la comunicazione esterna delle novità.

**PDS — Product Designer** — Responsabile dei flussi UI/UX per i prodotti italiani. Lavora trasversalmente su tutte le Product Line. Al momento della stesura del documento, la figura è in fase di selezione (e resta, alla data di questa revisione, non assegnata).

**ITs — Team IT / Sviluppatori** — Il team di tecnologia che implementa le soluzioni. Partecipa attivamente alle cerimonie di analisi e pianificazione, non solo alla fase di sviluppo. La loro voce sul rischio tecnico e sul footprint del cambiamento (l'Entanglement del RICE) è fondamentale già nelle fasi di analisi.
