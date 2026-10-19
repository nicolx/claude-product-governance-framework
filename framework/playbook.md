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
  effetto collaterale. Entrambi i flussi stanno dentro la capacità reale
  del team, per competenza: la roadmap si pianifica a slot che il team
  può davvero coprire (vedi "Capacità del team e slot della roadmap").

## Le fasi ricorrenti

| **Fase (ordinata)** | **Timing** | **Attori tipici** | **Output atteso** |
|---|---|---|---|
| Ideas intake | As needed | PM, PMM, Design/Discovery, Users, Leaders | Lista non ordinata di richieste; bug loggati direttamente nel tracker di esecuzione; Strategic Exception approvate |
| Ideas prioritization | ASAP | PM, IT, Leaders | Lista prioritizzata (RICE) |
| Product Backlog Refinement | Settimanale | PM, IT | Piano di Iterazione (4 bucket, diff dalla settimana prima) |
| Preliminary analysis | ASAP dopo il Refinement | PM, IT, Domain expert | Why chiaro; decisione di procedere o abort |
| Complete analysis | ASAP dopo la Preliminary | PM, Domain expert, Leaders | What/GTM, metriche, PRD; decisione di procedere (+ROI) |
| Roadmap update | Settimanale | PM | Report su cosa conta per Prodotto e IT; snapshot roadmap; viste per gli stakeholder dai modelli di reporting dichiarati |
| Iteration planning | Settimanale | PM, Design, IT | User stories, valutazione 80/20, Piano di Iterazione confermato/aggiustato |
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

### Ogni elenco prodotto dal sistema è indirizzabile

Ogni elenco o tabella che una skill mostra al PM ha, come **prima
colonna, l'identificatore stabile dell'oggetto** — così il PM può
riferirsi a una riga con "{ID}" invece di incollare testo copiato dalla
riga di comando. L'identificatore **non** è opzionale "se presente":

| Oggetto | Identificatore mostrato |
|---|---|
| Idea | `short_ref` se assegnato (`PG-042`), altrimenti lo slug `id` della cartella — mai vuoto o "—" |
| NSM | `{product_line} / {name}` |
| KPI di misurazione | `{prd_id} · {kpi_name}` |
| Voce in coda di approvazione | il nome file della proposta in `product/approvals/pending/` |
| Voce in coda di triage delivery | il suo `id` (`{data}-{card}-{evento}`) in `product/reference/delivery-watch.yaml` |
| Cerimonia | `{tipo}/{periodo}` |

Se lo `short_ref` di un'idea non è ancora stato assegnato, si mostra lo
slug: qualcosa di digitabile c'è sempre. Questo vale per tutte le skill di
vista e per i riepiloghi delle watch (`backlog-list`, `pending-approval`,
`iteration-board`, `mandate-watch`, `deadline-watch`, `rice-watch`,
`measurement-watch`, `nsm-watch`, `delivery-watch`).

**Ogni riga che parla di un'idea si capisce da sola.** Un identificatore
dice *quale* riga, non *di cosa* si parla: `PG-042` da solo costringe il
PM ad aprire lo YAML o a ricordarsi a memoria cosa sia. Per questo ogni
tabella o elenco che mostra idee — o voci che puntano a un'idea: voci del
Piano di Iterazione, proposte in coda di approvazione, righe delle watch,
eventi di delivery con `idea_ref` — porta **sempre**, in quest'ordine e
prima delle colonne specifiche della vista:

| Colonna | Fonte | Se il dato manca |
|---|---|---|
| **ID** | `short_ref`, altrimenti slug (sopra) | mai vuoto |
| **Summary** | `summary` dell'idea | "⚠ summary mancante" — mai il `title` al suo posto, mai inventato |
| **R · I · C · E** | ultima voce *approvata* di `rice_history`: `reach_points`, `impact_points`, `confidence_score`, `entanglement_score` | "—" in ciascuna |
| **RICE** | `score` della stessa voce | il motivo per cui non c'è: `mandate`, `platform`, `bug`, `SE` (strategic exception senza RICE), `senza RICE` |

Regole:

- **Le colonne non si tolgono** perché una riga non ha il RICE (una watch
  di mandate, `rice-watch`, un bug): si riempiono con "—" e il motivo.
  Vedere *che* manca il RICE è un'informazione, non un buco da
  nascondere.
- **Solo valori approvati.** Un RICE proposto in `pending/` non entra
  nelle colonne R·I·C·E/RICE: se la vista lo deve mostrare (es.
  `pending-approval`, `backlog-list` sezione proposte), va in una colonna
  a parte marcata come **proposto**, accanto a quello corrente.
- **Mai ricalcolato.** Lo score si legge dalla voce di `rice_history` (o
  dal valore denormalizzato nel Piano di Iterazione), non si rifà la
  moltiplicazione in vista.
- **Forma compatta** quando la vista è un elenco a righe e non una
  tabella: `PG-042 · {summary} · R4 I5 C8 E2 → 80`.
- **Ambito.** Vale per le viste rivolte al PM e al team (skill di vista,
  checkpoint delle cerimonie, riepiloghi delle watch). I report per gli
  stakeholder generati da `report-render` seguono invece il proprio
  modello (`framework/models/`), che decide se esporre i punteggi (es.
  `show_scores` in `roadmap-now-next-later`): identificatore e summary ci
  sono sempre, il dettaglio RICE è una scelta del modello.

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

**Due canali di ingresso.** `context/` si alimenta in due modi, entrambi
gestiti da `context-intake`:

1. **Materiale grezzo droppato in `context/`** — un file non-Markdown alla
   radice della cartella. La skill lo trascrive e poi lo rimuove (è la
   copia grezza da non conservare).
2. **Pull da cartelle documentali collegate** — una o più raccolte
   condivise (una cartella Drive, uno spazio OneDrive/SharePoint o
   Confluence, qualunque store documentale raggiungibile via MCP), anche
   di ecosistemi diversi affiancati, dichiarate come connettori in
   `.governance/config.yaml` (`connectors:`, campo `folders:`; vedi
   `framework/schema/governance-config.template.yaml`). `context-intake`
   elenca ogni cartella **in sola lettura** tramite i tool del connettore,
   legge i documenti nuovi o modificati e li trascrive in `context/*.md`,
   citando come fonte il link del documento. Qui **non si rimuove nulla**:
   il documento resta nella cartella, dove *è* la fonte di sistema
   condivisa — non una copia da ripulire. Un file di stato tracciato,
   `context/.sources-seen.yaml` (id + revisione + data + materialità
   dell'ultima trascrizione, scritto solo dalle skill), evita che un run
   successivo ri-proponga documenti invariati. La skill **`context-watch`**
   rende questo pull periodico — non serve ricordarsi di lanciarlo: gira
   standalone e come ultimo passo della sweep di apertura del Backlog
   Refinement.

Il connettore-sorgente segue la stessa disciplina di ogni altro
connettore (`integration`/`probe`/`reauth`, verifica a inizio processo,
«dichiarato ma irraggiungibile ≠ `manuale`», per-connettore — vedi
"Connettori esterni"). Un ecosistema che l'istanza non collega al setup
semplicemente non esiste per il framework: nessuna cartella lì viene
cercata.

### Aggiornamento di routine vs. cambiamento materiale

Il canale 1 (drop manuale) e un run di `context-intake` avviato dal PM
scrivono **sempre dopo conferma esplicita** nella conversazione: è il PM
che ha portato quel materiale, la conferma è naturale. Ma per il pull
periodico di `context-watch` la conferma-per-ogni-documento è proprio
l'attrito da eliminare — un report trimestrale che arriva con le cifre
aggiornate non ha bisogno di un assenso ogni volta. Quindi
`context-watch` **classifica** ogni documento nuovo o cambiato e lo
instrada:

- **Aggiornamento di routine** — rinfresca dati o aggiunge dettaglio
  **senza cambiare le conclusioni** che `idea-intake`/`prd-draft` traggono
  dal contesto: nuove cifre in un report ricorrente, un trimestre in più
  di dati di mercato, un contatto o una sezione ampliata.
  → `context-watch` lo **applica direttamente** (via `context-intake`),
  con commit tracciato, e lo elenca nel recap.
- **Cambiamento materiale** — cambierebbe **come si scrive un PRD o come
  evolve il prodotto**: un pivot di modello di business, una NSM
  ridefinita, un vincolo regolatorio nuovo, un riposizionamento di
  mercato, una riorganizzazione che sposta l'ownership di prodotto, un
  cambio di strategia dichiarato.
  → **non si scrive `context/`**: va in `product/approvals/pending/`
  (`type: context_update`) e il PM approva esplicitamente prima che tocchi
  il contesto. È lo stesso principio di difendibilità del resto del
  framework: una svolta di direzione di prodotto deve avere un trail.
- **Nel dubbio → materiale.** Un contesto sbagliato si propaga in
  silenzio in ogni PRD futuro; un'approvazione in più costa poco (stesso
  principio garantista di `inbox-triage`).

In **ogni** caso il PM riceve un **recap** di cosa è cambiato — applicato
o in attesa. La rete di sicurezza dell'auto-apply di routine è questa:
test di materialità + recap obbligatorio + i cambiamenti materiali
comunque gated + ogni scrittura è un commit rivedibile e revertibile.

**È un documento vivo, non un archivio statico.** Quando materiale già in
lavorazione da un'altra skill (un PRD, un elemento smistato da
`inbox-triage`) rivela un'informazione che cambia la comprensione del
business — una riorganizzazione, un nuovo dato di mercato, un pivot
dichiarato — quella skill non scrive da sola in `context/`: segnala il
candidato e richiama `context-intake`, che **propone l'aggiornamento e lo
scrive solo dopo conferma esplicita del PM** nella stessa conversazione.

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
  `pending-approval`, `backlog-list`, `iteration-board`, `jira-sync`
  (pull), e le watch (`nsm-watch`, `mandate-watch`, `deadline-watch`,
  `rice-watch`, `measurement-watch`, `context-watch`, `delivery-watch`,
  `path-watch`) nell'uso *standalone*. Nella sweep di
  apertura del Backlog Refinement il pull è **uno solo** per l'intera
  sweep (la logica delle watch di calcolo gira inline; `context-watch` e
  `delivery-watch` girano come task in background con commit distinto;
  `path-watch` gira in background in modalità solo-calcolo e le sue
  scritture entrano nel commit unico della sweep — vedi "Product Backlog
  Refinement").
- **Commit + push**: come ultimo passo di ogni skill che scrive stato
  tracciato (`idea-intake`, `inbox-triage`, `rice-update`, `prd-draft`,
  `backlog-refinement`, `iteration-planning`, `log-ceremony`,
  `roadmap-snapshot`, `pending-approval`, `context-intake`, `context-watch`,
  `jira-sync`, `demo-capture`, le watch, `init-governance-project`). Il
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
(`pull` | `push "<messaggio>" [path...]` | `apps`), richiamato dagli hook
e come passo esplicito delle skill.

**Codice applicativo (`apps/`).** Il `pull` riallinea i *dati*; i
submodule in `apps/` restano invece fermi al commit registrato nel
puntatore, che invecchia a ogni rilascio dei team tech. Le skill che
**ragionano sul codice** — `inbox-triage` e `idea-intake` (è un bug? è
già risolto? è debito tecnico?), `prd-draft` (l'How), `rice-update`
(l'Entanglement da ispezione), `path-watch` (le rotte e gli eventi già
tracciati nel codice) — prima di leggerlo eseguono quindi
`governance-sync.sh apps`, che porta ogni submodule all'ultimo commit
del suo branch remoto (`submodule.<nome>.branch` in `.gitmodules`,
altrimenti il branch di default del remote). Stessi principi del pull: non blocca mai (fetch
fallito, accesso negato → avviso e si legge lo stato locale), non
sovrascrive mai modifiche locali (submodule con modifiche → saltato e
segnalato), e stampa per ogni app il commit letto, così la diagnosi
riporta un riferimento verificabile. **Non committa il puntatore
aggiornato**: `apps/` resta di proprietà di `init-governance-project`, e il
codice "corrente" è quello del remote, non quello registrato
nell'istanza (`check-unpushed.sh` ignora quindi i puntatori dei submodule
spostati). Disattivabile con `sync.apps_pull: false`.

**Cosa fare quando vedi l'avviso "impossibile allineare in fast-forward".**
Hai commit locali che il team non ha ancora, e `origin` è andato avanti:
non è un errore, è il segnale che due persone hanno lavorato in
parallelo. Esegui `git pull --rebase origin` (riscrive i tuoi commit
locali sopra quelli del team), controlla i conflitti sui file condivisi
(`product/reference/`, snapshot di roadmap), poi `git push`. Sulle
`idea.yaml` i conflitti sono quasi sempre banali: la convenzione
cartella-per-idea e `rice_history` append-only li rende rari e locali.

## Connettori esterni: dichiarati, verificati a inizio processo, mai un fallback silenzioso

Un'istanza gira su uno stack che il framework non conosce a priori. Può
avere connettori a **qualunque** sistema esterno — un tracker di
esecuzione (Jira, Asana, Linear…), una fonte di metriche (un warehouse
analytics, un client SQL, un tool SaaS…), altro ancora (un tool di
design…). La **disciplina è identica per tutti**; cambia solo quale skill
lo usa. Si dichiarano in `.governance/config.yaml`:

- **`jira:`** — il tracker di esecuzione, per il dedup e la
  riconciliazione (`jira-sync`) e per il monitoraggio delle transizioni
  di delivery (`delivery-watch`, blocco `delivery_watch:`). Tipicamente
  Jira, ma il blocco vale per qualunque tracker; solo i dettagli MCP/CLI
  in `jira-sync` sono Jira-specifici.
- **`metrics:`** — la fonte da cui `nsm-watch` e `measurement-watch`
  leggono NSM e KPI dai dati di produzione, invece di chiederli a mano al
  PM, e da cui `path-watch` prende il catalogo per suggerire e applicare i
  path da monitorare di ogni idea (sottoblocco `metrics.paths` — vedi
  "Measurement", "Path da monitorare").
- **`connectors:`** — lista aperta per qualunque altro connettore. Una
  voce con un campo `folders:` non vuoto è una **sorgente di contesto**:
  `context-watch` e `context-intake` ne elencano e leggono i documenti per
  alimentare `context/` (vedi "Contesto aziendale (`context/`)"). Più
  sorgenti di contesto affiancate (Drive **e** OneDrive/SharePoint, ecc.)
  sono normali — ognuna è un connettore a sé, sondato e gestito
  indipendentemente: un guasto su uno non ferma gli altri, e un ecosistema
  non collegato al setup semplicemente non viene interrogato. Le altre
  voci sono per skill custom o future.

Ogni connettore ha lo stesso schema di base: `configured` (c'è davvero?),
`integration` (`mcp:<server>` / `cli:<nome>` / `manuale` / vuoto), `probe`
(come verificare che sia vivo — per un MCP il prefisso dei suoi tool, per
una CLI/API un comando o una chiamata read-only rapida), `reauth` (il
comando/azione per rimetterlo su quando scade), e note. **Mai credenziali**
— solo nomi e comandi.

**Dichiarato non vuol dire attivo.** Un connettore può essere non loggato,
con la sessione OAuth scaduta, o il servizio irraggiungibile (`ENOTFOUND`,
timeout). **Alcuni scadono a ogni sessione** — tipico dei login OAuth
interattivi da riga di comando, che vanno rifatti ogni volta. Per questo:

1. **Verifica all'inizio del processo.** Le skill che dipendono da un
   connettore ne controllano la raggiungibilità *prima* di partire (con
   il `probe` dichiarato): a inizio cerimonia (`backlog-refinement`,
   `iteration-planning` verificano `jira` e `metrics`), al passo 0 delle
   watch di metriche e di `jira-sync` standalone, all'inizio di
   `context-watch`/`context-intake` (per-connettore) quando pescano da una
   sorgente di contesto. L'hook
   `check-connectors.sh` (a inizio sessione) ricorda quali connettori la
   config dichiara e **mostra il comando `reauth`** — non può verificare
   lo stato da bash, ma ti dà subito cosa rilanciare.

2. **Dichiarato ma irraggiungibile ≠ `manuale`.** Se al momento dell'uso
   il connettore non risponde, **non** degradare in silenzio
   all'inserimento manuale e **non** saltare il passo: è un guasto
   transitorio, non una scelta di setup, e trattarlo come "non
   configurato" nasconde una falla invece di renderla visibile.
   - Segnala **cosa** non risponde e proponi il comando **`reauth`**
     dichiarato in config; se è rete/servizio, ritentare tra poco.
   - Chiedi al PM se riattivare e ritentare, o procedere senza.
   - Se procede senza: la lettura che dipendeva dal connettore la dà il
     PM a mano per questo run, **e** il fatto che la lettura automatica è
     stata saltata va registrato come **rimandato** nel riepilogo (e nel
     `decisions.yaml` se in cerimonia), con promemoria di rilanciare la
     skill quando il connettore torna su. Mai "non applicabile", mai
     silenzioso.

3. **`manuale` o non dichiarato** → il PM inserisce i valori a mano come
   sempre, nessuna segnalazione: è la configurazione scelta, non un
   guasto.

**Le azioni che il processo impone non sono interattive.** Il probe di un
connettore, il `pull`/`push` di sincronizzazione del repo
(`governance-sync.sh`), le letture in blocco (`governance-dump.sh`) e — per
un bug confermato — la creazione del ticket sul tracker sono passi previsti
dal metodo: la skill li esegue senza chiedere conferma volta per volta.
Perché funzionino senza attriti vanno **pre-autorizzati** nei permessi di
Claude Code — la parte stack-agnostica sta in `.claude/settings.json`
(proprietà framework), i tool del connettore dichiarato li scrive
`init-governance-project` in `.claude/settings.local.json` (proprietà
istanza, non tracciato). Restano interattivi solo: le decisioni di priorità
(coda `product/approvals/pending/`), l'invio di comunicazioni verso persone
(mail, Slack), e la conferma di classificazione del bug stesso.

Vale in dry-run come a regime — una query analytics o una ricerca JQL è
comunque una lettura. La skill `jira-sync` ha i dettagli specifici del
connettore Jira; questa sezione è la regola generale di cui quello è un
caso.

## Modalità dry-run (simulazione)

A volte serve **vedere cosa produrrebbe** una skill — tipicamente una
cerimonia — senza toccare nulla: per provare il flusso di un Backlog
Refinement prima di condurlo davvero, per addestrare un nuovo PM, o
semplicemente per rifare la stessa riunione due volte e ritrovarsi con
gli stessi dati. Questo è il dry-run: la skill legge, analizza e mostra
l'output completo che *scriverebbe*, ma non persiste nulla di tracciato e
non fa alcun commit o push. È ripetibile identica finché gli input non
cambiano.

**Come si attiva:**

- **Per singola invocazione** — l'utente lo chiede esplicitamente
  ("lancia `backlog-refinement` in dry-run", "simula la cerimonia",
  argomento `dry-run` alla skill). Vale solo per quel run.
- **Persistente per istanza** — `.governance/config.yaml`, chiave
  top-level `dry_run: true`. Finché è `true`, **ogni** skill gira in
  simulazione. Utile per un'istanza di training/demo; da togliere quando
  l'istanza diventa operativa.

**Contratto — cosa fa una skill in dry-run:**

1. Esegue tutti i passi di **lettura e analisi** normalmente, incluso
   `governance-sync.sh pull` (è read-only fast-forward: non sporca nulla
   di tracciato e tiene la simulazione onesta sullo stato reale del
   team).
2. **Non crea né modifica** file sotto `product/`, `context/`,
   `.governance/` — né con scrittura diretta, né spostando file
   (`inbox/` → `ideas/`, `pending/` → `decided/`, rinomina di cartelle
   cerimonia…).
3. **Non invoca `governance-sync.sh push`**: nessun commit, nessun push.
   Come rete di sicurezza l'helper stesso fa no-op sul `push` quando il
   dry-run è attivo (env `GOVERNANCE_DRY_RUN`, o `dry_run: true` in
   config) — così anche una skill che dimentica il contratto non scrive
   su `origin`.
4. **Presenta come testo** l'output completo che avrebbe scritto:
   contenuto di `decisions.yaml`, proposte per `pending/` (YAML
   completo), riepiloghi delle watch, diff RICE, bozze di
   `requester_reply`. Nulla di meno di un run vero — solo non persistito.
5. Chiude con una riga inequivocabile:
   `🔍 DRY-RUN — nessun file scritto, nessun commit, nessun push. Rilancia senza "dry-run" per applicare.`

Una skill che ne richiama altre (es. `log-ceremony` con le watch)
**propaga** il dry-run alle skill richiamate.

**Cosa il dry-run NON è.** Non è un meccanismo di rollback: se hai già
lanciato una cerimonia *vera* e vuoi annullarla, serve `rollback-ceremony`
(sezione sotto) — non basta rilanciare in dry-run.
`init-governance-project` e `sync-framework-updates` non hanno una
modalità dry-run (il primo è bootstrap una-tantum, il secondo riguarda il
*metodo* su `upstream`, con una sua revisione umana).

**Hook.** `SessionStart` fa `pull` (già read-only) e
`check-pending-approvals.sh`. `check-unpushed.sh`, `check-inbox.sh` e
`check-pending-approvals.sh` (hook `Stop`, il terzo anche su
`SessionStart`) restano attivi anche in dry-run e sono utili — ti dicono
se resta lavoro non pushato da run precedenti, `inbox/` non processata, o
proposte arretrate nella coda di approvazione — non vanno silenziati.

## Annullare un run di cerimonia (`rollback-ceremony`)

Se una cerimonia è stata registrata per errore senza dry-run, o si è
interrotta a metà lasciando i file in uno stato incoerente, la skill
`rollback-ceremony` riporta il repo allo stato immediatamente precedente
al run — così lo si può rifare pulito. Si appoggia a `.run-meta.yaml`
(scritto da `log-ceremony` all'inizio di ogni run), che registra il
`base_sha`: il commit git da cui il run è partito.

**Si annulla in avanti, non riscrivendo la storia** — coerente con il
vincolo fast-forward-only del sync su un repo condiviso:

- Commit del run **già pushati su `origin`** → `git revert` (un nuovo
  commit che li disfa). Mai `git reset` + force-push: romperebbe il
  clone di chi ha già fatto pull. Il commit di revert è esso stesso
  parte del registro difendibile ("annullato il run X il {data}").
- Commit del run **ancora solo locali** → `git reset` è lecito, previa
  conferma.
- Un conflitto di revert **non si risolve automaticamente**: la skill fa
  `--abort`, si ferma e riferisce (stesso principio dell'helper di sync
  che non fa mai merge automatici).

**Fuori scope: le decisioni già approvate.** Se il run aveva prodotto una
proposta poi approvata da `pending-approval` (spostata in
`product/approvals/decided/`, `payload` applicato al `target_file`),
quella decisione **non** viene annullata da `rollback-ceremony`: è una
decisione umana tracciata. La skill la rileva, la esclude e la segnala —
disfarla è un'operazione separata e deliberata.

La trascrizione grezza in `source/` viene per default conservata in una
cartella `{periodo}-void-{n}` prima dell'annullamento: è costosa da
ricreare, e resta come traccia del tentativo.

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

Un bug **confermato dal PM** va aperto sul tracker di esecuzione **subito**,
contestualmente all'intake, con un impatto stimato — non rimandato a un
secondo assenso. L'unica conferma richiesta è quella sulla classificazione
stessa ("è davvero un bug?"): superata quella, il filing è automatico e non
interattivo. Il razionale è operativo: un bug lasciato come bozza in un
riepilogo di conversazione si perde, ed è esattamente la perdita di
informazione che il metodo esiste per prevenire. Prima di aprirlo vale
comunque la dedup contro ticket già esistenti (regola "non duplicare", vedi
"Il tracker di esecuzione (Jira): collegamento, non duplicazione"): se
emergono candidati plausibili si mostrano al PM per la disambiguazione, se è
chiaramente nuovo si crea. Se il connettore è `manuale` o dichiarato ma
irraggiungibile, il bug non può essere filato in automatico: si consegna il
testo del ticket pronto e lo si segnala come **azione aperta** da completare
appena il connettore torna su — mai come "fatto", mai come "non applicabile"
(vedi "Connettori esterni"). Questa regola vale per qualunque skill che
confermi un bug, non solo per l'intake.

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
- [ ] Se è un bug confermato: il ticket è stato aperto **ora** sul tracker di esecuzione con impatto stimato (o, se il connettore è giù/`manuale`, è stato consegnato il testo pronto e segnalato come azione aperta)? Non "è già stato aperto" — l'apertura è parte di questo passo.
- [ ] Se è una Strategic Exception: è stata approvata al livello richiesto (o è chiaro che è ancora in attesa di conferma)?
- [ ] Se non è un'idea: è stata scartata come `declined` con `decline_reason`, non cancellata né lasciata in inbox?
- [ ] L'idea è stata categorizzata per Product Line?
- [ ] È stata preparata (e mostrata al PM) una bozza di risposta per chi ha mandato il materiale, qualunque sia la classificazione — o è esplicito che non c'è nessuno da avvisare?
- [ ] Se arriva via canale informale (chat, voce): è stata trasferita nell'archivio prima di qualsiasi altra azione?

## Chiudere il loop col richiedente

*"The single biggest problem in communication is the illusion that it has
taken place." — George Bernard Shaw*

Il framework è bravo a catturare, classificare e prioritizzare — ma
un'email arrivata da uno stakeholder, se non riceve risposta, lascia il
richiedente al buio: non sa se è stata vista, se serve altro, quando
succederà qualcosa. La delusione (e la frizione) nasce lì, non dal RICE
score.

Per questo **nessun elemento esce dall'intake senza una bozza di
risposta per chi l'ha mandato** — qualunque sia l'esito del triage (idea,
bug, Strategic Exception, mandate, platform, scarto, chiarimento) e anche
quando il materiale non crea niente di nuovo ma aggiorna un'idea o un PRD
esistente. La bozza è scritta dall'automazione, rivista e inviata *a
mano* dal PM (mai invio automatico), salvata sull'idea in
`requester_reply` (o, per un aggiornamento, in `followup_replies`). Non
passa da `product/approvals/pending/`: è una cortesia 1:1 con l'idea, non
una decisione.

L'unica eccezione è quando **non c'è nessuno da avvisare**: l'idea nasce
dal PM stesso, da un brainstorm interno, o da un backfill del tracker. Non
sono eccezioni: un canale di risposta non noto (la bozza si scrive
comunque, il recap dice che il canale va trovato), un mittente senior
(gli si risponde lo stesso), un materiale inoltrato dal PM per conto di
uno stakeholder (il richiedente è lo stakeholder). Il recap dell'intake
elenca **ogni** elemento processato con la sua bozza o con il motivo
esplicito per cui non ce n'è una — mai un'assenza silenziosa.

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
- **Bug** — confermato come bug: entra nell'agenda del team di sviluppo
  senza passare dalla prioritizzazione. La bozza dà il riferimento al
  ticket (o dice che è in apertura, se il connettore era giù) e l'impatto
  stimato, **mai una data di risoluzione**, e anticipa che verrà avvisato
  alla chiusura. Se la verifica nel codice dice che il "bug" è il
  comportamento voluto, l'unità diventa un'idea e la bozza lo spiega con
  rispetto (com'è pensato oggi, e che la richiesta di cambiarlo entra nel
  backlog come miglioria).
- **Mandate** — presa in carico come iniziativa mandataria: salta la
  prioritizzazione, non l'analisi. La scadenza è registrata e monitorata;
  quando partirà l'analisi è una forbice dal lead time, mai una promessa.
- **Platform** proposta da qualcuno che non è il PM (tipicamente il team
  tech) — presa in carico, rientra nella capacità protetta per il debito
  tecnico, se ne parla in Iteration Planning.
- **Aggiornamento di un'idea o di un PRD esistente** — chi manda un dato,
  un'obiezione, una precisazione o un sollecito su qualcosa che c'è già
  resta appeso quanto chi propone una cosa nuova. La bozza (`kind:
  update_ack`, voce di `followup_replies` sull'idea — per un PRD, sull'idea
  del suo `idea_id`) dice: ricevuto e collegato a {ID/titolo}; dov'è oggi
  l'iniziativa in linguaggio piano; cosa succede al materiale ("verrà
  valutato se cambia la stima" — mai anticipare l'esito di un
  `rice-update`; "confluirà nella prossima revisione del PRD"). Nessuna
  data, nessuna promessa.

**Un mittente, una risposta.** Se lo stesso elemento genera più unità
(una mail con tre richieste, un thread che crea un'idea e aggiorna un
PRD), il mittente riceve **un solo messaggio** che copre tutti gli esiti,
non tre. La bozza vive nella prima unità creata (o, se non ne nasce
nessuna nuova, nella voce `followup_replies` della prima idea
aggiornata); le altre portano `reply_status: consolidated` e
`consolidated_in` verso quella. In un thread a più voci, i destinatari
sono il proponente più chi ha posto una domanda diretta.

**Una bozza non inviata lascia appeso quanto nessuna bozza.** Ogni bozza
ha un `reply_status` (`drafted` → `sent` quando il PM dichiara di
averla mandata, o `waived` con un motivo dato da lui, es. "risposto a
voce"). Le bozze ancora `drafted` le ricorda l'hook
`check-requester-replies.sh` a inizio e fine sessione, e le elenca la
sweep di apertura del Backlog Refinement con il diritto di parola per
dichiararle inviate o esentarle.

*Principi Agile da incarnare in questa fase:*
- *Una conversazione faccia a faccia (o almeno una risposta) è il modo
  più efficiente per comunicare.*
- *Accogliamo i cambiamenti nei requisiti: chi ci scrive va tenuto nel
  ciclo, non lasciato fuori.*

**Checklist operativa**
- [ ] Ogni elemento processato all'intake ha una bozza di risposta per chi l'ha mandato (anche bug, mandate, platform e aggiornamenti di idee/PRD esistenti), oppure un motivo esplicito per cui non c'è nessuno da avvisare?
- [ ] Un mittente che ha generato più unità riceve un solo messaggio consolidato?
- [ ] Le bozze ancora `drafted` dalle settimane precedenti sono state inviate o esentate con motivo?
- [ ] Nessuna bozza è stata inviata in automatico — tutte mostrate al PM per revisione?
- [ ] Per le idee normali: la bozza dice se serve un meeting di approfondimento, e in tal caso `rice_status.deep_dive` è compilato?
- [ ] Per le idee normali: la prima ipotesi di timing è una forbice onesta, non una data né una promessa?
- [ ] Per le Strategic Exception: la bozza dice "in attesa di conferma", non "approvata", finché non lo è?

Il loop si chiude anche **all'uscita**: consegna, interruzione e chiusura
della misurazione generano un avviso obbligatorio agli stakeholder — vedi
"Avvisare gli stakeholder della conclusione".

### Testi che il PM manda a mano: visibili e pronti da copiare

Ogni bozza che il framework prepara perché il PM la mandi dal **suo**
client di posta — `requester_reply`, `followup_replies`,
`clarification.draft_message`, le mail di `delivery-watch`, gli avvisi
di `conclusion_notices` — deve arrivare al PM **già leggibile** e
passare nel client con **un solo copia-incolla**, senza ritocchi di
formato. Il PM rivede e adatta il contenuto; non deve ripulire il testo.

**Visibile subito.** La bozza si mostra **per intero** nella
conversazione nel momento in cui viene scritta — nel recap del run, non
solo come titolo o conteggio. Se è stata scritta da un run non
presidiato (cron), la prima sessione la mostra per intero quando il PM
apre la coda (l'hook ne ricorda il conteggio). Il formato di
presentazione è sempre lo stesso, in tre blocchi separati, ciascuno in un
blocco di codice `text` senza altro dentro:

- **A** — i destinatari, separati da `; ` (accettato da Outlook e
  Gmail): indirizzi se noti, altrimenti nome e ruolo da completare;
- **Oggetto** — una riga (assente se la bozza è una risposta in un
  thread esistente, come di solito `requester_reply`);
- **Testo** — il corpo.

**Testo semplice, non Markdown.** Il corpo si incolla in un client di
posta, che non interpreta il Markdown e trasforma in rumore tutto ciò
che non è testo:

- niente `**grassetto**`, `_corsivo_`, `#` titoli, backtick, tabelle,
  link `[testo](url)` — un URL si scrive in chiaro su una riga sua;
- **un paragrafo = una riga**: nessun a-capo dentro un paragrafo (lo
  spezzarsi della riga nel terminale non è un a-capo del testo);
  paragrafi separati da una riga vuota;
- nessuna indentazione a inizio riga; un elenco, se serve davvero, con
  righe che iniziano con `- ` e senza sotto-livelli;
- solo lettere (accentate comprese), cifre e punteggiatura comune:
  niente emoji, frecce, spunte, pallini tipografici o altri simboli
  grafici — "dalla review alla produzione", non "review → prod";
- niente gergo del framework o della board nel testo per lo stakeholder:
  né slug, né `short_ref`, né nomi di campo o di stato tecnici, se non
  servono a lui;
- **niente firma**: la aggiunge il client del PM. Il saluto finale sì;
- un dato mancante non si inventa e non resta come segnaposto di
  sistema (`{nome}`): si scrive `[DA COMPLETARE: cosa manca]`, ben
  visibile, così il PM lo vede prima di mandare.

**Negli appunti, su un tasto.** Selezionare un testo lungo dal terminale
può portarsi dietro a-capo e spazi del layout. Quando il PM rivede una
bozza per mandarla, la skill copia il **Testo** negli appunti con
`bash .claude/hooks/copy-to-clipboard.sh` (strumento locale, non invia
nulla; macOS, Linux, Windows/WSL) e lo dice; l'Oggetto o i destinatari
si copiano allo stesso modo se il PM lo chiede. Se lo strumento manca,
resta il testo mostrato in conversazione. Il testo copiato è lo stesso
salvato nella voce: se il PM lo modifica nel client, nella voce resta
quello proposto, a meno che il PM non dia la versione finale.

**Salvato com'è.** Nel file YAML il corpo è un blocco letterale (`|`)
con la stessa struttura: un paragrafo per riga, righe vuote tra i
paragrafi. Il file è il trail, non la sorgente del copia-incolla.

**Checklist operativa**
- [ ] Ogni bozza è stata mostrata per intero al PM, in tre blocchi (A, Oggetto, Testo), appena scritta o all'apertura della coda?
- [ ] Il Testo è testo semplice: niente Markdown, un paragrafo per riga, nessun simbolo grafico, nessuna firma?
- [ ] I dati mancanti sono segnati `[DA COMPLETARE: …]`, non inventati?

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

- **(R)each →** Quante persone o utenti avranno un beneficio? Si parte da
  un **rapporto sulla popolazione rilevante per quella Product Line** (non
  un valore assoluto) — è ciò che rende i punteggi confrontabili tra
  Product Line diverse nello stesso Backlog Refinement. Quel rapporto poi
  si porta sulla stessa **scala 1-10** degli altri tre fattori:

  > `reach_points = max(1, ceil(percentuale / 10))`  → intero 1-10

  Esempi: 3% → 1 · 11% → 2 · 15% → 2 · 50% → 5 · 95% → 10. Arrotondamento
  **per eccesso**, minimo **1** (un'iniziativa verticale per un cliente
  solo non viene azzerata da un Reach frazionario). La percentuale e il
  valore assoluto restano nel record come nota di contesto — sono *come si
  ricava* il punteggio, non il punteggio. Prima di questo riscalamento
  Reach era espresso come percentuale 0-100 direttamente nello score: le
  voci `rice_history` più vecchie vanno migrate (`sync-framework-updates`,
  meccanicamente).

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
  pianificazione, non per il ranking: vive nel blocco `delivery`
  (`effort_by_competency` + `estimated_effort_weeks`, stimato dal team
  tech — vedi "Capacità del team e slot della roadmap") e in
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
- [ ] Reach è espresso 1-10 (`max(1, ceil(` percentuale sulla popolazione rilevante della Product Line `/ 10))`), con la percentuale e l'assoluto annotati come contesto?
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
- [ ] Ogni tabella di idee mostra ID, summary, R·I·C·E e RICE totale (con "—" e il motivo dove il RICE manca)?

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
tempo (sezione "Ideas prioritization"), se il contesto aziendale è
cambiato nelle cartelle documentali collegate (`context-watch` — sezione
"Contesto aziendale"), e quali transizioni di delivery sulle iniziative
collegate meritano una comunicazione agli stakeholder (`delivery-watch`
— sezione "Transizioni di delivery rilevanti per gli stakeholder"), e —
con una fonte analytics collegata — quali idee non hanno ancora un path
da monitorare, quali path sono da strumentare o si sono rotti
(`path-watch` — sezione "Measurement", "Path da monitorare"). Solo
dopo si passa a decidere le priorità del prossimo periodo — è più
facile prioritizzare bene quando si parte da un quadro aggiornato di cosa
sta già funzionando, invece di scoprirlo a posteriori.

**Diritto di parola dopo ogni passo.** Ogni passo della sweep di apertura
— e ogni passo successivo della cerimonia — si chiude con un
**checkpoint**: la skill mostra la tabella indirizzabile di quel passo
(sezione "Ogni elenco prodotto dal sistema è indirizzabile") e chiede
esplicitamente se il PM vuole commentare o agire su una delle voci
**prima di procedere**. Non si accorpano le interazioni alla fine: quando
l'oggetto è ancora sullo schermo, ed è chiaro da quale passo arriva, è il
momento giusto per dire "{ID} non serve più" o "{ID} aggiorna la
scadenza". Le azioni tipiche del checkpoint — tutte già previste altrove,
qui solo rese immediate:

- **archiviare** un'idea che non ha più motivo di esistere:
  `status: declined` + `decline_reason` se non è mai partita, o
  `status: aborted` se era in lavorazione — sempre su conferma esplicita
  del PM in conversazione, registrata in `decisions.yaml`, mai decisa
  dalla sola skill;
- **pulire una scadenza** non più rilevante: svuotare
  `deadline.due_date`/`note`;
- **chiudere una misurazione**: `closure` sul `measurement.yaml` (come
  `measurement-watch`);
- **chiudere un allarme NSM** tornato a posto: `alert.status: resolved`
  (come `nsm-watch`);
- **annotare** contesto sull'idea: `notes`;
- **rivedere un RICE**: si rimanda a `rice-update`, che passa da
  `product/approvals/pending/` come sempre.

Se il PM non ha nulla da dire, un "procedi" e si va avanti. Ogni azione o
commento del checkpoint diventa una voce in `decisions` del
`decisions.yaml` della cerimonia, con l'idea impattata referenziata.

**Poi si svuota la coda di approvazione, e si guarda il backlog
ordinato.** Un RICE proposto da nuova evidenza non conta finché non è
approvato (sezione "Ideas prioritization" — l'automazione propone, un
umano decide); e un ranking che nessuno ha davanti non serve a
prioritizzare. Quindi, prima di discutere cosa entra in iterazione: si
cammina la coda `product/approvals/pending/` — i diff di RICE voce per
voce, approvati o rifiutati dal team — e poi si mette davanti a tutti la
**lista ordinata del backlog**, con score, scadenze e note di contesto.
È il materiale su cui si sceglie: la cerimonia registra le decisioni, ma
prima espone le opzioni.

**La coda di approvazione non dovrebbe accumularsi tra una cerimonia e
l'altra.** Arrivare al Backlog Refinement con decine di `rice_diff`
arretrati significa che per settimane la prioritizzazione è girata su un
ranking incompleto (gli score proposti non contano finché non sono
approvati). Le proposte vanno riviste via `pending-approval` man mano che
emergono — il Refinement è il *backstop*, non l'unico momento in cui si
guarda la coda. L'hook `check-pending-approvals.sh` (a inizio e fine
sessione Claude Code) la rende visibile: quante proposte, di che tipo, da
quanto tempo — con un'escalation quando la coda è ampia o stantia. Nessun
altro segnale lo fa (`git status` è pulito: i file *sono* committati).

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

**L'output primario della cerimonia è il Piano di Iterazione.** Un
artefatto team-facing (`product/roadmap/iterations/{settimana}.yaml`) con
quattro liste — *analisi da avviare*, *analisi in corso*, *in sviluppo*,
*prioritizzate d'urgenza* — costruito **come diff dal piano della
settimana precedente**: cosa è stato completato, cosa è slittato (fermo
allo stesso punto da più iterazioni), cosa è stato tolto, cosa è nuovo. È
il "contenitore dell'iterazione corrente" con i suoi tag chiave (un
`iteration_goal` in una frase: quale iniziativa o metrica si cerca di
impattare), popolato con le feature in priorità — la lista `analisi da
avviare` si sceglie **esplicitamente dal ranking RICE**, con un `why_now`
per ciascuna voce. È ciò che il team guarda nei giorni successivi per
sapere su cosa lavora; senza, la cerimonia registra decisioni e
segnalazioni ma non lascia in mano nulla di eseguibile. Come ogni diff di
RICE o snapshot di roadmap, il piano passa **sempre** da
`product/approvals/pending/` (`type: iteration_plan`) e non viene
applicato nella camminata della cerimonia. Lo snapshot di roadmap
(`roadmap/snapshots/`, il rollup strategico per gli MBR/MTR) lo
**referenzia** senza duplicarlo.

Le iniziative `classification: idea` che entrano nell'iterazione
**davanti a idee con RICE score più alto** ancora in backlog finiscono
nella lista *prioritizzate d'urgenza*: per ciascuna il PM dichiara se è
una Strategic Exception (bypass autorizzato da uno stakeholder — genera
comunque la voce in `strategic_exceptions` e la riga nel friction-log)
o una scelta qualitativa del team dentro il processo normale. È così che
il framework intercetta il pattern "stessa persona che bypassa la
priorità ogni settimana" (sezione "Come gestire le frizioni", Scenario 2).

Il grosso del lavoro è già stato fatto al RICE scoring. Questa cerimonia
aggiunge: 1) consapevolezza di come sia andata l'iterazione precedente;
2) un'idea di cosa fare nel prossimo futuro. È anche l'occasione per una
mini-retrospettiva: perché è stato completato solo il 50% dell'iterazione
precedente? Quali impedimenti? Cosa è mancato a livello di informazioni?

**60 minuti**, meno se possibile. Bando alle discussioni troppo
dettagliate (sono oggetto della fase successiva). Va bene anche da remoto.

**La sweep di apertura dev'essere calcolo, non attesa di I/O.** La
cerimonia blocca il tempo di molte persone in riunione: non si può
lasciarle a guardare lo schermo mentre l'automazione rilegge le stesse
decine di `idea.yaml` una volta per watch. La skill `backlog-refinement`
fa **un solo** `pull`, **un solo** dump dello stato
(`.claude/hooks/governance-dump.sh sweep`), calcola *inline* la logica di
tutte le watch (NSM, misurazioni, mandate, scadenze, RICE — sono
aritmetica di date e soglie), lancia la riconciliazione Jira **in
background** mentre il team discute, e chiude con **un solo commit** per
l'intera sweep. Le watch (`nsm-watch`, `mandate-watch`, …) restano skill
a sé per l'uso *standalone* fuori cerimonia. I checkpoint dopo ogni
blocco (sotto) restano — quello è tempo umano, è il senso della riunione;
è il calcolo tra un checkpoint e l'altro che dev'essere istantaneo.

*Principi Agile da incarnare in questa fase:*
- *Consegniamo frequentemente software funzionante, preferendo i periodi
  brevi.*
- *A intervalli regolari il team riflette su come diventare più efficace,
  poi regola il proprio comportamento di conseguenza.*

Questa cerimonia va registrata con la skill **`backlog-refinement`**, che
apre la sweep di apertura in un solo passaggio (logica delle watch
calcolata inline, `nsm-watch` per prima), **cammina la coda di
approvazione** (`pending-approval`, i `rice_diff`
voce per voce con il team), **presenta il backlog ordinato**
(`backlog-list`) come base della prioritizzazione, assegna gli handle
corti `short_ref` (`PG-042`) alle idee che ancora non ne hanno — il
refinement settimanale è il punto di serializzazione a scrittore singolo
per cui questo non collide — **compone il Piano di Iterazione**
partendo da quello della settimana precedente (rilevando lì le
reprioritizzazioni fuori-RICE e verificando con il capacity check che
stia nella capacità reale del team — "Capacità del team e slot della
roadmap"), e delega a `log-ceremony` per la
scrittura in `product/ceremonies/backlog-refinement/{YYYY-Www}/` —
trascrizione grezza in `source/`, esito strutturato in `decisions.yaml`
(vedi `framework/schema/ceremony-decisions.template.yaml`), metadati di
esecuzione in `.run-meta.yaml`. Il Piano di Iterazione, ogni diff di RICE
e ogni snapshot di roadmap prodotti passano da
`product/approvals/pending/` prima di essere applicati. La vista "a colpo
d'occhio" del piano si ottiene con la skill **`iteration-board`**.

**Checklist operativa**
- [ ] Dopo ogni watch della sweep di apertura c'è stato un checkpoint: tabella con `{ID}` in prima colonna e diritto di parola al PM prima di procedere? Le azioni concordate (archiviazioni, scadenze pulite, misurazioni chiuse) sono in `decisions.yaml`?
- [ ] `context-watch` ha controllato le cartelle di contesto collegate? Gli aggiornamenti di routine sono stati applicati e messi nel recap; i cambiamenti materiali sono in `product/approvals/pending/` (`type: context_update`)?
- [ ] `delivery-watch` ha girato (se `delivery_watch.enabled`) e la coda di triage è stata rivista? Ogni movimento delle card ha un esito esplicito — mail inviata a mano dal PM, o (per eccezione) dismiss con motivo — e nessuna comunicazione è partita in automatico?
- [ ] La coda `product/approvals/pending/` è stata camminata: ogni `rice_diff` approvato o rifiutato dal team? Quel che resta in coda è stato segnalato?
- [ ] Il backlog ordinato (`backlog-list`) è stato mostrato al team prima di decidere cosa entra in iterazione?
- [ ] Il Piano di Iterazione è stato generato **partendo da quello della settimana precedente** (`based_on`)?
- [ ] Le idee su cui iniziare l'analisi (`analysis_todo`) sono state scelte esplicitamente dal ranking RICE, con un `why_now` per ciascuna?
- [ ] Il diff vs. settimana precedente (completate / avanzate / slittate / rimosse / nuove) è stato rivisto col team? Le voci slittate da ≥ 3 iterazioni sono state affrontate?
- [ ] Il capacity check del piano è stato mostrato al team? Ogni competenza oltre capacità è stata riequilibrata, o lo sforamento è stato accettato con motivazione e chi l'ha deciso?
- [ ] Le voci `prioritizzate d'urgenza` che sono Strategic Exception hanno una proposta `strategic_exception_flag` in coda e una riga nel friction-log?
- [ ] La proposta `type: iteration_plan` è in `product/approvals/pending/` (non applicata nella camminata)?
- [ ] È stata fatta una mini-retrospettiva sull'iterazione precedente?
- [ ] La cerimonia è stata loggata in `product/ceremonies/backlog-refinement/`?
- [ ] La durata è stata contenuta entro 60 minuti?

## Preliminary analysis

*"If you don't know why you are doing something, you shouldn't be doing
it." — W. Edwards Deming*

Il Backlog Refinement produce il bucket `analisi da avviare` del Piano di
Iterazione della settimana — le idee su cui iniziare l'analisi, che parte
formalmente qualche giorno dopo. Il cambiamento significativo: quello che
era in cima all'elenco può ancora cambiare. Il team potrebbe a breve
iniziare a sviluppare, ma probabilmente mancano molte informazioni.

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

**L'artefatto della Preliminary analysis: la bozza del brief.** Il Why
non resta nella testa del PM né nelle note dell'idea: diventa la bozza del
**brief d'iniziativa** (`product/prds/{slug}/README.md`, template
`framework/schema/initiative-brief.template.md`, `stage: preliminary`) —
"La storia in un minuto", "Chi è coinvolto e in quale momento", "Come
produce valore", "Cosa sappiamo, cosa ipotizziamo, cosa non sappiamo". È il
primo posto in cui la storia viene scritta *per qualcuno che non c'era*
(vedi "Scrivere per il lettore", sotto). Se si arriva a `prd-draft` senza
bozza (percorso rapido), la scrive `prd-draft`: la storia si scrive
comunque prima dei PRD.

**Checklist operativa**
- [ ] Il Why è stato compilato: qual è il problema reale?
- [ ] La bozza del brief è comprensibile da chi non ha partecipato alle conversazioni?
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

La Complete analysis **completa il brief** (`stage: complete`: esempi,
cosa chiediamo a chi e quando, vincoli trasversali, parole che usiamo,
mappa dei documenti) e poi produce i PRD, ciascuno scritto per il suo
lettore.

### Scrivere per il lettore: dalla fonte all'artefatto

*"The single biggest problem in communication is the illusion that it has
taken place." — attribuita a George Bernard Shaw*

Un'idea nasce quasi sempre in una conversazione ricca: una call, un
workshop, un thread. Passando agli artefatti (idea, brief, PRD) il rischio
**non è perdere il materiale** — la fonte resta integra in `source/` — ma
che **il contenuto non arrivi a chi legge**. Chi ha partecipato alla
conversazione rilegge il PRD e lo trova completo, perché il contesto ce l'ha
in testa; chi non c'era (un designer, uno sviluppatore, uno stakeholder, un
agente come un Claude di design o di sviluppo senza la sessione in cui il
PRD è stato scritto) costruisce la cosa sbagliata. È un difetto che chi
scrive non vede, per costruzione.

**Principi.**

- **P1 — Il lettore prima del template.** Ogni artefatto ha un lettore
  primario dichiarato (`primary_reader` nel PRD). Il template fissa le
  sezioni minime; il lettore decide cosa va in evidenza e quanto contesto
  serve. Un PoC disegnato da un designer e costruito da uno sviluppatore
  merita due PRD: lettori diversi sono una cucitura del problema.
- **P2 — L'artefatto si regge da solo.** Un PRD, insieme al brief, è
  comprensibile da chi non ha partecipato a nessuna conversazione. Vietato
  "come detto in call" al posto del contenuto.
- **P3 — Nessun punto sparisce in silenzio.** Ogni punto chiave della fonte
  finisce in un artefatto, oppure è escluso con un motivo confermato dal
  PM. Lo strumento è il **registro dei punti chiave**
  (`source/key-points.yaml`, template
  `framework/schema/key-points.template.yaml`), estratto all'intake e
  verificato da `prd-draft`.
- **P4 — Narrativa ≠ stima.** Un esempio illustrativo si conserva e si
  mostra, marcato come tale: è il materiale più prezioso per chi progetta.
  Non diventa mai una stima (RICE, baseline, target). Il principio
  garantista dice "non inventare numeri", non "butta via gli esempi".
- **P5 — L'arricchimento è visibile.** Ciò che l'analisi aggiunge alla
  fonte (vincoli normativi, riferimenti al codice, precedenti, benchmark) e
  ciò che il PM decide in conversazione si dichiara nella sezione
  *Provenienza* del PRD: il PM lo convalida invece di scoprirlo rileggendo.
- **P6 — Ogni fase di analisi lascia un artefatto.** La Preliminary analysis
  produce la bozza del brief, la Complete analysis lo completa; il PRD non è
  il primo posto in cui la storia viene scritta.
- **P7 — Portabilità.** Brief e PRD viaggiano senza il sistema che li ha
  prodotti: senza la sessione, senza la memoria locale dell'agente, spesso
  senza accesso al repository di governance. Nel corpo niente percorsi
  locali, niente rimandi a `context/*.md` (i fatti si **riportano** in
  sintesi), niente id interni non spiegati. I riferimenti a codice e ticket
  sono ammessi solo nei PRD per lettori `tech`. I materiali visivi si
  copiano in `assets/`.

**Tipi d'informazione.** Ogni punto della fonte ha una natura, e la natura
decide dove si può usare:

| Tipo | Esempio | Dove è lecito usarlo |
|---|---|---|
| `fact` | "il budget lo decide il CFO al rinnovo annuale" (confermato) | ovunque |
| `estimate` | "circa 20k €/anno di licenze", detto a voce | RICE e metriche **solo dopo verifica**; in narrativa come "stimato" |
| `illustrative` | "il 5% è stressato, il 3% trova una soluzione" | **solo narrativa ed esempi** (brief, contenuti dimostrativi); mai RICE, baseline o target |
| `intent` | "vogliamo un PoC da mostrare in giro" | requisiti, scenario |
| `opinion` | "è la svolta per il prodotto" | contesto; come evidenza vale al più Confidence opinione (1-3) |

**Gli artefatti di una specifica.**

| Artefatto | Dove | Per chi | Cosa contiene |
|---|---|---|---|
| Registro dei punti chiave | `product/ideas/{slug}/source/key-points.yaml` | il PM e le skill (verifica) | i punti della fonte, la loro natura, dove sono finiti |
| Brief d'iniziativa | `product/prds/{slug}/README.md` | tutti | la storia una volta sola, attori, valore, cosa chiediamo a chi e quando, vincoli, parole, mappa dei documenti |
| PRD | `product/prds/{slug}/prd-N-*.md` | il suo `primary_reader` | Why, **Scenario**, What, (Vincoli di design), *Cosa vogliamo imparare* (discovery) o *Metriche* (delivery), How, Rischi, **Provenienza** |
| Allegato dati | `product/prds/{slug}/allegato-*.md` | design e sviluppo di un PoC | definizioni, dati dimostrativi in unità assolute, parametri, testi, **risultati attesi** come criteri di accettazione |
| Materiali visivi | `product/prds/{slug}/assets/` | design | mockup, schermate, precedenti |
| Letture a freddo | `product/prds/{slug}/.reviews/` | audit | chi ha letto cosa, lacune → correzioni, domande residue |
| Glossario | `product/reference/glossary.yaml` | tutti (via il brief) | il vocabolario di dominio dell'istanza |

**La lettura a freddo.** Prima che un PRD passi da `draft` a `in_review`,
`prd-draft` lo fa leggere a lettori simulati a contesto vergine, ciascuno
con i soli documenti del suo ruolo (procedura e prompt in
`framework/prompts/cold-read.md`). Non è un controllo di forma. Nel primo
collaudo:
- lo **stakeholder**, sul solo brief, ha trovato problemi di **sostanza**: la
  liceità del racconto d'apertura, il termine di paragone di un ROI,
  l'assenza di una richiesta e di un calendario;
- lo **sviluppatore** ha trovato le **incoerenze numeriche** ricalcolando;
- il **designer** ha trovato le ambiguità di **esperienza**.

Una lettura a freddo fa emergere anche **decisioni che spettano al PM**, e
vanno portate a lui prima di correggere. Al massimo due iterazioni. Mai
saltata in silenzio: senza subagent, si fa con una persona del ruolo.

**Gate di stato del PRD.** `draft` → `in_review`: almeno una lettura a
freddo registrata e registro dei punti chiave senza punti `open`.
`in_review` → `approved`: decisione umana — PM e `tech_reference`, più un
rappresentante del lettore primario quando conta.

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
owner, stakeholder **o lettore** chiaramente distinti — non quando "è
arrivato a pagina 3". Tagliare per lunghezza produce frammenti che non si capiscono
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
  Attenzione: il divieto riguarda i *framework*, **non il contesto
  specifico dell'iniziativa**, che va raccontato — nel brief, una volta
  sola, così i PRD restano A3 senza perdere la storia.

Lo scheletro consigliato è in `framework/schema/prd.template.md`; il brief
in `framework/schema/initiative-brief.template.md`; l'allegato dati in
`framework/schema/prd-annex.template.md`.

---

Il processo va descritto anche con diagrammi di flusso dove utile — non è
uno strumento specifico di questo metodo, solo una raccomandazione. Può
essere opportuno citare il Domain Driven Design: dare nomi alle cose è
importante, sia perché influenza come il team di tecnologia interpreta
una parola chiave, sia perché quel termine diventa gergo aziendale. Non
esiste un dizionario tecnico separato da quello di business: c'è un solo
vocabolario condiviso. Il glossario di dominio di un'istanza specifica va
mantenuto in `product/reference/glossary.yaml` (locale, non nel framework
— è specifico del business di quell'istanza; template
`framework/schema/glossary.template.yaml`). Il brief riporta i termini che
usa nella sezione "Parole che usiamo".

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
- [ ] Il brief d'iniziativa è completo (anche "Cosa chiediamo, a chi, e quando")?
- [ ] Ogni PRD dichiara il suo `primary_reader` e `prd_kind`, e ha uno Scenario?
- [ ] Il registro dei punti chiave non ha punti `open` (ogni punto coperto o escluso con motivo confermato)?
- [ ] La lettura a freddo è stata fatta e registrata in `.reviews/`, e le decisioni emerse sono state prese dal PM?
- [ ] I documenti si reggono senza la sessione, la memoria locale e `context/` (P7)?
- [ ] Il PRD rispetta il vincolo A3 (circa due facciate A4 in PDF)? Se no, è stato spaccato lungo le cuciture del problema?
- [ ] Se il PRD fa parte di una sequenza: sono dichiarate separatamente sequenza di lettura e di rilascio?
- [ ] Il RICE NON è ripetuto nel PRD, solo referenziato con link all'idea di origine?
- [ ] I framework generali sono citati per riferimento, non ridescritti?
- [ ] Le KPI di successo hanno un valore baseline?
- [ ] Il target della KPI è stato definito e condiviso con lo stakeholder?
- [ ] La GTM strategy è stata discussa con chi presidia il marketing/comunicazione?
- [ ] L'How di alto livello è stato abbozzato con il team tech?
- [ ] Il PRD ha un `tech_reference` (il referente tecnico con cui validare l'How), proposto da `team-fit` e confermato dal PM?
- [ ] Il ROI atteso è ancora coerente col RICE originale? Se no, il ranking è stato aggiornato nella fonte di verità?

## Team di sviluppo, referente tecnico e staffing di un PRD (`team-fit`)

Un PRD dice *cosa* fare e, nell'How, *quanto è intrecciato* col sistema.
La domanda successiva — *chi, nel team, è la persona di riferimento per
questo lavoro?* — non va lasciata all'istinto né rimandata a quando si
apre il ticket: il metodo la fa emergere già durante la stesura dei
documenti e la tiene visibile in tutte le viste e le cerimonie.

### L'anagrafica del team (`product/reference/team.yaml`)

Un'istanza mantiene una mappa leggera di **chi c'è nel team di sviluppo,
quali aree di `apps/` presidia, cosa sa fare, quanta capacità porta**.
Per persona: nome (o handle), eventuale email, seniority, squad, gli slug
`apps/` che presidia, tag di competenza liberi (linguaggi, framework,
aree), la capacità (`fte` dedicato al prodotto, ripartizione sulle
competenze del catalogo, assenze), disponibilità in prosa, note di
contesto. La parte di capacità è la fonte dell'offerta nella sezione
"Capacità del team e slot della roadmap".

- **Chi la scrive.** `init-governance-project` la popola all'intervista
  (passo "Team di sviluppo"); `team-roster` la fa evolvere quando il team
  cambia (aggiungi / aggiorna / rimuovi un membro).
- **Non passa da approvazione.** È un dato di riferimento condiviso, alla
  pari di `product-lines.yaml`, `annual-target.yaml` e del denominatore
  Reach: scrittura diretta, tracciata da git. Non è una decisione di
  priorità né una comunicazione in uscita, quindi la regola del
  `pending/` non la tocca.
- **Descrittiva, non valutativa.** È una mappa di competenze e presidio
  per instradare il lavoro — non uno strumento di valutazione delle
  persone. Niente giudizi di performance, niente note sensibili:
  `team-roster` riporta il focus se la conversazione va lì. Privacy: il
  minimo che serve al matching.

### Il referente tecnico (`tech_reference`)

Ogni iniziativa che arriva a un documento porta con sé un **referente
tecnico**: lo sviluppatore con cui il PM valida l'How e — di norma — la
prima scelta naturale quando l'iniziativa verrà assegnata.

**Non è l'assegnazione formale di implementazione.** Quella si decide in
Roadmap update & Iteration Planning e vive nel tracker di esecuzione (che
resta l'unica fonte di verità per l'esecuzione). `tech_reference` è un
puntatore leggero — chi è la persona giusta con cui ragionare del *come* —
e si può cambiare liberamente, non è un impegno.

**Ciclo di vita:**

| Fase | Dove | Chi lo scrive | Solidità |
|---|---|---|---|
| Intake | `idea.yaml` `tech_reference` | `idea-intake` / `inbox-triage`, **solo** se il materiale ha segnale tecnico e `team.yaml` è popolato — confermato dal PM, mai presunto (come `deadline`) | Ipotesi preliminare |
| PRD | frontmatter `tech_reference` del PRD + denormalizzato su `idea.yaml` | `prd-draft`, eseguendo il matching di `team-fit` contro l'How reale, su conferma del PM | Solido — è la fonte di verità per-PRD |
| Cerimonie / viste | voci del Piano di Iterazione, `backlog-list`, `iteration-board` | denormalizzato da `backlog-refinement` (come `summary`/`rice_score`/`rice_components`) | Sola lettura, riflette il PRD |

Per un'iniziativa spaccata in più PRD, ogni PRD ha il suo
`tech_reference`; il campo su `idea.yaml` è quello del PRD primario.

Scrittura **diretta** ovunque — non è una decisione di priorità, non
passa da `product/approvals/pending/` (stessa logica di `deadline`,
`iteration.current`, `jira.status`). Il valore deve corrispondere a un
`members[].name` di `team.yaml`.

### La proposta di staffing (`team-fit`)

`team-fit <prd-slug>` legge il PRD (l'How e i sistemi toccati, i rischi e
le dipendenze aperte, il dominio dall'idea di origine) e lo incrocia con
`team.yaml`, producendo una **shortlist ordinata di candidati** — ognuno
con una motivazione puntuale: familiarità diretta con gli `apps/`
toccati, tag di competenza che coprono un rischio specifico,
disponibilità.

È **advisory**: propone, non decide. Non tocca il tracker, non compie
azioni in uscita, non crea voci in `pending/`. L'unica cosa che scrive —
e **solo su conferma esplicita del PM** — è il `tech_reference` del PRD
(e la sua copia denormalizzata sull'idea), quando il roster è cambiato o
il PRD non ne aveva ancora uno. È la stessa scrittura diretta che fa
`prd-draft` alla stesura, non un'eccezione alla regola del `pending/`.

`team-fit` è **onesta sui buchi**: se un rischio o un sistema toccato non
è coperto da nessuno nel roster, lo dice — è un segnale (supporto
esterno, upskilling, hiring), non un dettaglio da nascondere. Se il
roster è vuoto o palesemente vecchio, rimanda a `team-roster` invece di
tirare a indovinare.

Quando usarla: `prd-draft` la esegue già dentro la stesura (non serve
lanciarla a mano dopo un PRD appena scritto); a mano quando il roster
cambia, il PRD evolve, o all'Iteration Planning si riconfermano i
referenti.

## Capacità del team e slot della roadmap

Una roadmap che non sa quanta gente c'è promette date che il team non
può mantenere. Il problema tipico non è la capacità totale ma quella di
**una competenza**: tre iniziative che si contendono l'unico sviluppatore
mobile non partono in parallelo, qualunque sia il loro RICE. Il metodo
mette a confronto due cose, entrambe dichiarate dal team e mai inventate:

- **l'offerta** — quanta capacità c'è, per competenza, settimana per
  settimana (`product/reference/team.yaml`);
- **la domanda** — quanto lavoro chiede ogni iniziativa, per competenza
  (blocco `delivery` o `platform` di `idea.yaml`).

Il confronto produce due cose: un **capacity check** sul Piano di
Iterazione della settimana, e uno **slot plan** che colloca le iniziative
nel trimestre dentro la capacità residua. Il RICE dice *in che ordine*;
lo slot plan dice *quando, con il team che c'è*.

### L'offerta: chi sa fare cosa, e quanto tempo ha

`team.yaml` porta, oltre a presidio e competenze per il matching di
`team-fit`:

- un **catalogo di competenze** dell'istanza — poche famiglie larghe con
  cui il team tech stima (es. `backend`, `frontend`, `mobile`, `ux`,
  `qa`, `data`, `devops`). È un vocabolario chiuso: offerta e domanda
  usano gli stessi id, altrimenti non si confrontano;
- per persona: **`fte`** — la quota del tempo lavorativo dedicata a
  *questo* prodotto (0–1: part-time o condivisa con altri prodotti vale
  meno di 1) — la **ripartizione** di quel tempo sulle competenze
  (`{backend: 0.7, devops: 0.3}`), le competenze che copre all'occorrenza
  (`can_also`), le date di ingresso/uscita, le **assenze** (solo date);
- per il team: l'**overhead** (cerimonie, supporto, bug ordinari,
  review — default 0.2), le festività comuni, le eventuali **squad**.

**Capacità non è produttività.** `fte` è tempo dedicato, non velocità:
le differenze di ritmo stanno nelle stime del team, mai nel roster. Vale
la stessa regola dell'anagrafica: descrittiva, non valutativa.

**Calcolo dell'offerta** di una competenza `c` in una settimana `w`, in
persona-settimane:

```
offerta(c, w) = Σ membri  fte × quota_c × (giorni lavorativi in w / 5) × (1 − overhead_pct)
```

dove i giorni lavorativi escludono weekend, `holidays`, `absences` del
membro e i giorni fuori da `from`/`until`. Con le squad, l'offerta si
calcola per squad (i soli suoi membri). Un membro con `fte: null` non
entra nel calcolo e va segnalato (`unsized_members`) — mai presunto a 1.
`can_also` **non** entra nell'offerta: serve a proporre come sciogliere
un collo di bottiglia, non a gonfiare i numeri.

### La domanda: quanto lavoro, e in quanto tempo

Il team tech stima ogni iniziativa con due numeri distinti:

- **`effort_by_competency`** — quanto lavoro, in persona-settimane per
  competenza: `{backend: 3, frontend: 2, qa: 1}`;
- **`estimated_effort_weeks`** — in quanto tempo-calendario, una volta
  partita: la durata dello slot.

Il **carico settimanale** su una competenza è
`effort_by_competency[c] / estimated_effort_weeks`. Se supera l'offerta
**totale** di quella competenza, l'iniziativa non può stare in quella
durata con il team che c'è (o la competenza manca del tutto): è
`infeasible`, e lo si dice subito al team — allungare la durata, ridurre
lo scope con l'80/20, supporto esterno. Nessuna skill lo corregge da
sola.

Nessuno dei due numeri è l'Entanglement del RICE (un footprint 1-10). La
stima nasce **`rough`** quando il referente tecnico valida l'How in
`prd-draft` — serve a collocare l'iniziativa nel trimestre prima che
entri in iterazione — e diventa **`committed`** in Iteration Planning,
con la valutazione 80/20 in mano. Le viste marcano le `rough` come stima
grezza. Un'iniziativa senza stima è **non dimensionata**: compare come
tale, non viene stimata d'ufficio. Vale per `idea`, `strategic_exception`
e `mandate` (blocco `delivery`) e per `platform` (blocco `platform`): il
debito tecnico consuma la stessa capacità e sta negli stessi slot. I bug
ordinari stanno nell'overhead.

### Il capacity check del Piano di Iterazione

Il Backlog Refinement lo calcola componendo il piano, l'Iteration
Planning lo ricalcola dopo le stime `committed`. Domanda della settimana
= carichi settimanali di ciò che consuma capacità di sviluppo *questa*
settimana: `in_development`, `urgent_priority` che entra in sviluppo,
platform in lavorazione. Le analisi non consumano capacità di delivery
(sono nell'overhead). Per competenza:

| Stato | Saturazione (domanda / offerta) |
|---|---|
| `ok` | < 85% |
| `tight` | 85–100% |
| `over` | > 100% |

**Sforare si può, ma mai in silenzio.** Se una competenza è `over`, il
PM sceglie in cerimonia: **riequilibrare** (spostare o togliere una
voce, ridurre lo scope, coinvolgere chi ha la competenza in `can_also`)
oppure **accettare lo sforamento** con una motivazione e chi l'ha
deciso — registrati nel piano (`capacity_check.over_capacity_decision`)
e in `decisions.yaml` (`capacity_overrides`). Non passa da `pending/`
di per sé: viaggia dentro la proposta di piano, che ci passa già. È
la stessa logica della Strategic Exception: non è vietato, è tracciato.
La serie dei `capacity_overrides` mostra se lo sforamento è
un'eccezione o il modo normale di lavorare — nel secondo caso il
problema è il dimensionamento del team rispetto a ciò che si promette,
ed è un'informazione per la leadership, non un fallimento del team.

### Lo slot plan: quando, con il team che c'è

`roadmap-snapshot` colloca le iniziative dimensionate nelle prossime 13
settimane (`slot_plan`), con un algoritmo semplice e verificabile a mano:

1. **Ordine di priorità:**
   1. in sviluppo — tengono lo slot già iniziato (dallo snapshot
      precedente; una nuova stima lo ricalcola; senza snapshot
      precedente, l'inizio è il primo Piano di Iterazione in cui la voce
      compare in `in_development`);
   2. `urgent_priority` del piano, poi mandate e idee con `deadline` non
      ancora in lavorazione, ordinate per ultimo inizio utile (`due_date`
      − durata);
   3. platform in lavorazione o pianificata dal team;
   4. `analysis_in_progress` / `analysis_todo` del piano, per RICE;
   5. resto del backlog con stima, per RICE.
2. **Collocazione:** ogni iniziativa prende la **prima settimana di
   inizio** in cui, per tutta la sua durata e per ogni sua competenza, il
   carico settimanale sta nella capacità residua (della sua squad, o del
   team). Non prima della settimana corrente se è già in analisi, non
   prima di `capacity.analysis_lead_weeks` se non lo è ancora. Le
   iniziative in sviluppo si collocano comunque (sono un impegno preso):
   se sforano, lo slot è `over_capacity` e deve esserci la decisione
   registrata nel piano.
3. **Esito per iniziativa:** inizio/fine, `delayed_by` (la competenza
   che l'ha fatta slittare, se è slittata), `at_risk` se finisce oltre la
   sua `due_date`. Quelle che non si collocano vanno in `unslotted` con il
   motivo — `undimensioned`, `beyond_horizon` (non ci sta nel trimestre:
   è il "Later"), `infeasible`, `unknown_competency` — mai omesse.

Lo slot plan è **advisory e derivato**: passa da `pending/` con lo
snapshot, e non cambia le priorità — se uno slot non piace, si cambia
l'ordine nel Backlog Refinement o la stima in Iteration Planning, non lo
slot a mano. Lo snapshot mostra il calcolo (offerta per competenza,
ordine, slot) perché il PM possa verificarlo.

**Cosa ci dice.** `delayed_by` è il collo di bottiglia con un nome: "il
checkout slitta di 4 settimane per `mobile`" è una conversazione molto
più utile, con gli stakeholder e con la leadership, di "il team è
pieno". Un mandate `at_risk` nello slot plan è il segnale da anticipare
nel prossimo Backlog Refinement, prima che lo dica `mandate-watch`.

**Chi lo legge.** Le viste standard di roadmap non ricalcolano mai lo
slotting, leggono lo `slot_plan` dell'ultimo snapshot approvato: la
roadmap di lavoro (colonna "Slot"), la trimestrale (timeline per mese e
saturazione per competenza) e la Now/Next/Later, dove **Next è ciò che
il team riesce a iniziare nel trimestre con la capacità che ha** e Later
ciò che non ci sta ancora — senza date, salvo opzione. Anche
`iteration-board` mostra accanto a ogni voce del piano il suo slot di
sviluppo e le voci fuori dal piano in arrivo entro 4 settimane.

### Quando i dati mancano

Ogni pezzo degrada in modo esplicito, mai con un default silenzioso:

- `team.yaml` senza capacità (nessun `fte`) → capacity check
  `not_available`, slot plan vuoto con il motivo, `total_capacity_weeks`
  chiesto al team come numero dichiarato (`basis: declared`). Rimanda a
  `team-roster`.
- Membri senza `fte`, iniziative senza stima → elencati
  (`unsized_members`, `undimensioned`): il calcolo è parziale e lo dice.
- Una competenza usata in una stima ma assente dal catalogo → segnalata,
  l'iniziativa va in `unslotted` (`unknown_competency`) finché il PM non
  la rimappa o estende il catalogo.

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

È anche il momento in cui le iniziative entrate in iterazione ricevono
la **stima di delivery `committed`** dal team tech: quanto lavoro per
competenza (`delivery.effort_by_competency`, persona-settimane) e in
quanto tempo-calendario (`delivery.estimated_effort_weeks`) — non
l'Entanglement del RICE. Al RICE scoring interessa il footprint del
cambiamento, non la durata; è qui, con la valutazione 80/20 in mano, che
la stima diventa realistica (una stima `rough` del referente tecnico può
esserci già da `prd-draft`, per collocare l'iniziativa nel trimestre).
Con le stime in mano, il team **ricalcola il capacity check** del piano
e decide su ogni competenza oltre capacità — vedi "Capacità del team e
slot della roadmap". Alimenta `capacity_allocation` e `slot_plan` in
`roadmap-snapshot`, in parallelo alle stesse stime nel blocco `platform`
per le iniziative platform.

Anche questa cerimonia va registrata con una skill dedicata,
**`iteration-planning`**: **carica il Piano di Iterazione** prodotto dal
Backlog Refinement (non ne crea uno nuovo), raccoglie le stime di
delivery per competenza dal team tech per le iniziative nei suoi bucket,
ricalcola il capacity check, registra la valutazione 80/20 e la capacità
platform dichiarata.
Se la valutazione 80/20 porta a spostare voci tra bucket o a toglierle,
la skill produce una **proposta di Piano di Iterazione aggiornata**
(`refined_by_iteration_planning: true`) che passa da
`product/approvals/pending/` come quella del Backlog Refinement. Poi
delega a `log-ceremony` per la scrittura in
`product/ceremonies/roadmap-iteration-planning/{YYYY-Www}/` — stesso
pattern trascrizione + decisioni strutturate + `.run-meta.yaml`.

**Checklist operativa**
- [ ] Ogni User Story ha criterio di accettazione chiaro?
- [ ] Il team tech ha fatto la valutazione 80/20 su ogni storia?
- [ ] I task sono caricati nel tracker di esecuzione e assegnati? (`team-fit <prd-slug>` propone una shortlist di candidati dal roster; l'assegnazione si decide qui e vive nel tracker)
- [ ] L'agenda tiene conto del flusso di manutenzione ordinaria/debito tecnico?
- [ ] Le date di rilascio stimate sono coerenti con quanto discusso?
- [ ] Gli stakeholder chiave sono stati aggiornati sulle aspettative di delivery?
- [ ] Le iniziative in iterazione hanno una stima `committed` per competenza (`effort_by_competency` + `estimated_effort_weeks`)?
- [ ] Il piano sta nella capacità del team per ogni competenza, o lo sforamento è stato deciso e registrato (`capacity_overrides`)?
- [ ] `team.yaml` riflette il team di questa settimana (ingressi/uscite, assenze note)?
- [ ] La capacità dedicata a platform (debito tecnico/devops) questa iterazione è stata dichiarata esplicitamente, non lasciata implicita?

## Modelli di reporting (roadmap, metriche, aggiornamenti)

*"The single biggest problem in communication is the illusion that it has
taken place." — George Bernard Shaw*

Il framework produce dati affidabili — Piano di Iterazione, snapshot,
RICE, NSM, misurazioni — ma gli stakeholder non leggono YAML. Leggono una
roadmap, una scorecard, una mail del lunedì. Se l'istanza non dichiara
**in che forma** quei dati arrivano a chi decide, succede una di due
cose: nessuno li vede, oppure il PM continua a compilare a mano le slide
e i fogli di prima, in parallelo al framework. Il doppio binario è il
modo più rapido per far divergere ciò che si comunica da ciò che si è
deciso. Per questo i modelli di reporting sono una scelta da fare
**all'attivazione** dell'istanza, non un'aggiunta successiva.

**Un modello è un contratto di presentazione, non una fonte di dati.**
Ogni campo di un modello punta a un dato che il framework già tiene
(`fields`), oppure è dichiarato come lacuna (`gaps`). Un report non si
corregge a mano: se è sbagliato, si corregge la fonte (con la skill che
la possiede) e si rigenera. Struttura comune:
`framework/schema/report-model.template.md`.

**Due livelli.**

| Situazione | Modelli | Dove vivono |
|---|---|---|
| **Progetto nascente** — nessun formato aziendale da rispettare | I modelli standard del framework: Now/Next/Later, roadmap trimestrale, scorecard metriche, aggiornamento settimanale. Set minimo: Now/Next/Later + scorecard | `framework/models/` (proprietà framework, catalogo nel suo `README.md`) |
| **Azienda strutturata** — ha già un formato di MBR, una pagina di roadmap, un foglio di KPI | I formati dell'azienda, **trascritti** come modelli aziendali con la mappatura di ogni campo sui dati del framework. Possono estendere un modello standard (`extends: framework:<id>`) | `product/reference/models/` (istanza) |

I due livelli convivono: un'azienda può usare il proprio formato per la
leadership e un modello standard per la mail settimanale.

**Trascrivere un formato aziendale.** Come per il contesto aziendale,
il file grezzo (deck, docx) non resta nel repo: il modello ne riproduce
**sezioni e ordine**, non lo stile grafico, e tiene un puntatore
all'originale (`original_ref`). Ogni campo si mappa su un dato del
framework; quelli che il framework non tiene (budget speso, RAG di
progetto, owner commerciale…) vanno in `gaps` con una gestione scelta
dal PM — chiederlo al render, lasciarlo visibilmente vuoto, ometterlo.
Mai un valore dedotto per riempire una casella. Se più di un terzo dei
campi finisce in `gaps`, il formato chiede dati che il processo non
produce: è una conversazione da fare con chi lo ha imposto, non un buco
da tappare a ogni report.

**Dichiarare le viste.** `product/reference/reporting-models.yaml`
(template `framework/schema/reporting-models.template.yaml`) elenca le
viste dell'istanza: per ciascuna il modello, il pubblico, i destinatari,
la cadenza (`weekly`/`monthly`/`quarterly`/`on_demand`), la destinazione
(dove la pubblica il PM: mail, Confluence, deck) e i filtri per Product
Line. La crea `init-governance-project`; dopo si modifica con
`report-render` in modalità setup, su richiesta esplicita. Un'istanza
inizializzata prima di questa sezione non ha il file: `report-render`
propone di crearlo, non inventa viste.

**Generare e distribuire.** `report-render` compone la vista dai soli
dati **approvati** (mai da proposte in `pending/`), verifica prima che
le fonti non siano vecchie (piano, snapshot, ultime letture delle
metriche) e scrive il report in `product/reports/{vista}/{periodo}.md`.
Il report è **derivato**: scrittura diretta, rigenerabile, mai editato
a mano. Portarlo fuori dal team è invece una comunicazione in uscita:
per ogni vista con pubblico diverso da `team`, la skill prepara una
proposta `outbound_comm` in `product/approvals/pending/`, e dopo
l'approvazione è il PM a inviarla o pubblicarla. Il framework non
pubblica mai da solo.

Momenti naturali: dopo l'approvazione del Piano di Iterazione (aggiornamento
settimanale), dopo lo snapshot (roadmap), a fine mese/trimestre. La
sweep di apertura del Backlog Refinement segnala le viste in scadenza;
la generazione resta un passo separato, dopo la cerimonia — tranne per
la roadmap aggiornata, sotto.

### La roadmap si aggiorna da sola (cadenza `per_ceremony`)

Ogni cerimonia cambia qualcosa della roadmap: un'idea entra in analisi,
un RICE viene rivisto, una scadenza diventa urgente, il team spiega
perché una voce slitta. Se la roadmap che leggono gli altri si aggiorna
solo quando il PM se ne ricorda, per giorni mostra la settimana prima —
e i commenti che spiegano le scelte restano in un verbale che nessuno
apre. Per questo **la roadmap si rigenera da sola alla fine di ogni
cerimonia**.

- **Quale roadmap.** Quella che l'istanza dichiara con `cadence:
  per_ceremony` in `reporting-models.yaml`. Il framework **non
  presuppone un formato**: il default è il modello standard
  `roadmap-di-lavoro` (per ogni voce: stato, scadenza, stima, R·I·C·E e
  score, commenti di cerimonia); un'azienda che ha già il suo formato di
  roadmap lo trascrive come modello aziendale e gli dà quella cadenza. Si
  possono dichiarare più viste `per_ceremony` (es. la roadmap di lavoro
  per il team e il formato aziendale per la leadership): si rigenerano
  tutte.
- **Quando.** Alla chiusura di **ogni** cerimonia registrata —
  `log-ceremony`, quindi Backlog Refinement, Iteration Planning e le
  ad-hoc — e a ogni giro di `pending-approval` che approva un piano, un
  RICE, una Strategic Exception, un aggiornamento di mandate o uno
  snapshot. Nessuna conferma: il report è derivato e si sovrascrive; al PM
  arriva nel riepilogo cosa è cambiato.
- **Solo approvato, e lo dice.** Anche qui la roadmap si compone dai soli
  dati approvati. Alla chiusura del Backlog Refinement il nuovo piano è
  ancora in `pending/`: la roadmap esce comunque, con un banner che
  elenca le proposte in attesa ("questa versione mostra ancora l'ultimo
  stato approvato"), e si rigenera all'approvazione. Mai una roadmap che
  mostri come deciso ciò che è solo proposto.
- **I commenti si citano, non si scrivono.** Vengono dal registro delle
  cerimonie (`decisions.yaml`: decisioni con l'idea in
  `impacts.idea_ids`, motivi delle reprioritizzazioni, note sulle
  proposte rinviate o rifiutate) e dal piano (`why_now`, `note`,
  `trigger`), ciascuno con la cerimonia da cui viene. Una voce senza
  commenti in cerimonia ha la cella vuota. È anche un incentivo: se la
  ragione di una scelta non è stata detta in cerimonia, la roadmap non la
  mostra.
- **Distribuzione invariata.** Una vista `per_ceremony` con pubblico
  diverso da `team` prepara un `outbound_comm` come le altre, una sola
  per vista e periodo (aggiornata, non accodata di nuovo). Rigenerare non
  è pubblicare.
- **Annullabile.** Il report rigenerato in chiusura entra nel commit del
  run: `rollback-ceremony` lo riporta alla versione precedente insieme al
  resto.

Un'istanza senza nessuna vista `per_ceremony` non ha la roadmap
automatica: la cerimonia lo dice in una riga e rimanda a `report-render`
setup — non inventa una vista.

**Principi delle viste standard** (valgono anche come buona pratica per
i modelli aziendali):
- **Nessuna data inventata.** Le uniche date esatte sono le scadenze
  dichiarate (`mandate.due_date`, `deadline.due_date`). Una collocazione
  in un mese si basa solo sullo `slot_plan` dell'ultimo snapshot (inizio
  e fine ricavati dalla capacità del team) e porta la dicitura "stima"
  — "stima grezza" se `estimate_basis: rough`; le iniziative non
  dimensionate o fuori orizzonte si elencano a parte.
- **L'ordine è quello del RICE e del Piano**, non quello di chi chiede
  più forte: Next e Later si leggono dal Piano di Iterazione e dal
  backlog ordinato.
- **Una metrica senza lettura recente si dichiara vecchia**, non si
  presenta come attuale.

**Checklist operativa**
- [ ] All'attivazione l'istanza ha dichiarato almeno una vista di roadmap e una di metriche (o ha detto esplicitamente perché no)?
- [ ] Una vista di roadmap ha `cadence: per_ceremony` — nel formato standard o in quello aziendale — così si aggiorna da sola a fine cerimonia?
- [ ] Ogni modello aziendale ha tutti i campi mappati su un dato del framework o dichiarati in `gaps`?
- [ ] I report distribuiti sono passati da `pending/` come `outbound_comm`?
- [ ] Le viste in scadenza segnalate dal Backlog Refinement sono state generate?
- [ ] Nessuno compila più a mano, in parallelo, la roadmap o la scorecard che il framework genera?

## Product Design, development and rollout

*"Simplicity is the ultimate sophistication." — Leonardo da Vinci*

L'agenda del team di tecnologia emerge dalla raffinazione delle proposte
di prodotto. Quando un'attività è matura, passa dalla roadmap di prodotto
al backlog effettivo del team tech (tipicamente prioritizzato secondo
Kanban).

### Il tracker di esecuzione (Jira): collegamento, non duplicazione

Jira (o l'equivalente) è la **fonte di verità per l'esecuzione**: stato
delle card, transizioni, blocchi. Il repo di governance non lo duplica e
non ci fa sync in tempo reale — tiene solo un puntatore (`jira.card_id`)
sull'idea e ne fa polling periodico. La skill `jira-sync` gestisce il
collegamento in tre modi: Push (idea prioritizzata → nuovo ticket), Pull
(stato dei ticket collegati → repo), Riconciliazione.

Push non è solo il caso "idea prioritizzata": serve anche il **bug
confermato all'intake**, che entra sul tracker **subito**, saltando per
disegno la coda di priorità e il RICE (vedi "Alimentazione del bucket delle
idee", punto a). In quel caso `idea-intake`/`inbox-triage` invocano Push
appena il PM conferma la classificazione, senza un secondo assenso.

La regola "non duplicare" vale **nei due sensi**. Non solo "non copiare
Jira nel repo": anche **non aprire su Jira un ticket per qualcosa che è
già tracciato lì**. Prima di creare, `jira-sync` cerca un ticket
esistente sulle parole chiave dell'idea e, se lo trova, lo linka invece
di duplicarlo.

Il caso più costoso è quello silenzioso: un'iniziativa portata avanti
direttamente in Jira — a volte prima ancora che l'istanza esistesse —
**senza mai passare dal RICE**. È la falla che il gate di
prioritizzazione dovrebbe chiudere. La modalità **Riconciliazione** di
`jira-sync` la rende visibile: periodicamente (in apertura del Backlog
Refinement, se il connettore permette la ricerca) confronta le idee
ancora senza RICE con i ticket "attivi" del progetto e segnala i match —
lavoro in esecuzione fuori dalla governance, da riallineare
esplicitamente.

Un connettore **dichiarato ma irraggiungibile** al momento del run (MCP
non loggato o sessione scaduta, servizio giù, `ENOTFOUND`/timeout) non
equivale a «non configurato»: è un guasto transitorio, non una scelta di
setup. La cerimonia non salta la riconciliazione in silenzio — segnala
cosa non risponde, propone di riattivare la connessione (`/mcp` per il
login) e di ritentare il passo prima di proseguire. Se si sceglie
comunque di andare avanti, la riconciliazione resta **rimandata** e
visibile nel record della cerimonia (da rilanciare `jira-sync` standalone
quando il connettore torna su), mai persa né segnata come non
applicabile.

Il connettore consigliato è l'**Atlassian Remote MCP Server ufficiale**
(OAuth 2.1, nessun token da gestire); una CLI o l'operatività manuale
sono fallback. Come l'istanza si connette è dichiarato in
`.governance/config.yaml`, blocco `jira` (vedi
`framework/schema/governance-config.template.yaml`).

### Transizioni di delivery rilevanti per gli stakeholder (`delivery-watch`)

`jira-sync` Pull risponde a "dov'è adesso questo ticket". Non risponde a
"cosa è appena cambiato": non tiene memoria del valore precedente e non
legge il `changelog` della card. Tra una sessione e l'altra il PM perde
il fatto che una card è partita, è andata in review, si è bloccata, è
andata in produzione o è regredita — proprio l'informazione che serve per
tenere gli stakeholder nel ciclo con un aggiornamento, una
rassicurazione, o la segnalazione onesta di una criticità.

`delivery-watch` è la watch che colma quel buco. **Ogni movimento di una
card collegata è un evento**: ogni cambio di stato nel `changelog` dopo
l'ultimo giro, anche se tra due giri la card ha fatto più passi (In
Progress → In Review → Done sono tre eventi). Lo stakeholder che ha
chiesto una cosa vuole sapere quando parte, quando è quasi pronta e
quando è fatta, non solo la fine. La classificazione si basa sulla
**status *category* di Jira** — `new` / `indeterminate` / `done`,
universale su ogni board — più il flag "Impediment", l'`issuetype` e, per
la review, il nome dello stato (`delivery_watch.review_status_names`, o
di default ogni stato il cui nome contiene "review"). Ogni riga di stato
prende il primo tipo che la descrive, in quest'ordine: `regression`,
`delivered`/`bug_resolved`, `blocked`, `in_review`,
`entered_development`, e `status_changed` come rete finale:

| `event_type` | Segnale | Framing suggerito |
|---|---|---|
| `entered_development` | categoria `new` → `indeterminate`; per le board che non spostano la colonna, assegnatario impostato da vuoto | *aggiornamento* — "è partita, se ne occupa {nome}" |
| `in_review` | stato entrato in uno di `delivery_watch.review_status_names` (default: nome che contiene "review") | *aggiornamento* — "è in revisione, il prossimo passo è il rilascio" |
| `status_changed` | ogni altro cambio di stato (es. torna da review a sviluppo, passa in QA) | *aggiornamento* — "è passata da {da} a {a}" |
| `delivered` | categoria → `done`, `issuetype` ≠ Bug | *rassicurazione* — "è in produzione" |
| `bug_resolved` | categoria → `done`, `issuetype` = Bug | *rassicurazione* — "il problema segnalato è chiuso" |
| `blocked` | flag "Impediment" aggiunto, o stato entrato in uno di `delivery_watch.blocked_status_names` | *criticità* — "lavorazione temporaneamente bloccata" |
| `regression` | categoria `done` → `indeterminate`/`new` (riapertura), o label di `delivery_watch.regression_labels` aggiunta | *criticità* — "è emersa una regressione" |

La prima volta che un ticket entra nel perimetro è una **baseline**, non
un evento.

Ogni evento rilevato è annotato in una **coda di triage che sopravvive
tra le sessioni** (`product/reference/delivery-watch.yaml`). È la
capacità deliberatamente nuova: il PM non deve perdere un evento di
delivery solo perché non lo ha smarcato nella sessione in cui è stato
rilevato. L'hook `check-delivery-queue.sh` (a inizio e fine sessione) ne
mostra il conteggio, con lo stesso stile di sola-allerta di
`check-pending-approvals.sh`.

**`delivery-watch` non comunica, ma prepara la comunicazione.** Fa
quello che fanno le altre watch — fatti osservati, un recap al PM, una
coda — e in più, per ogni evento, scrive già la **bozza di mail** agli
stakeholder nella voce di coda. Il default è che ogni movimento abbia il
suo aggiornamento: al PM resta da rivederlo e mandarlo, non da decidere
se scriverlo. È "solo segnalazione" nello stesso senso di `mandate-watch` e
`deadline-watch`: la scrittura di `jira.status`/`jira.last_polled_at`
sull'idea è lo stesso fatto osservato che scrive `jira-sync` (scrittura
diretta, mai `pending/`).

L'invio è un **atto deliberato del PM**, nel triage. Ogni bozza è
mostrata per intero già nel recap del rilevamento, in testo semplice
pronto da incollare nel client di posta (sezione "Testi che il PM manda
a mano: visibili e pronti da copiare"). Per ogni voce il PM rivede la
bozza (destinatari e testo) e la **invia a mano**, stessa
logica di `requester_reply` ("Chiudere il loop col richiedente"):
nessun invio automatico, nessuna coda `pending/`; il testo inviato, i
destinatari e la data restano nella voce di coda come trail. In
alternativa la lascia per dopo, o — per eccezione, con un motivo — la
archivia (es. card spostata per errore e subito tornata indietro). Non
c'è nessun percorso non presidiato.

**Una mail per card, che racconta il percorso.** Se tra un invio e
l'altro una card si è mossa più volte, le voci ancora aperte della
stessa card confluiscono in un'unica bozza (`merged_into`) con lo stato
vero di oggi e i passi fatti — lo stakeholder riceve un aggiornamento,
non tre mail in fila, e nessun passo si perde. La tempestività dipende da
quanto spesso gira la watch: per un aggiornamento "appena si muove" il
cron di detect va schedulato giornaliero.

**Le conclusioni non si archiviano.** Per `delivered` e `bug_resolved` la
comunicazione non è una scelta: è l'avviso di conclusione obbligatorio
(sezione "Avvisare gli stakeholder della conclusione"). Nel triage la
bozza va nella voce `delivered` di `conclusion_notices` sull'idea, e il
dismiss non esiste — l'unica alternativa all'invio è l'**esenzione**
(`waived`) con un motivo dato dal PM. L'idea passa a `status: done` solo
quando l'avviso è `sent` o `waived`. Per questi due eventi la bozza non
si prepara al rilevamento ma nel triage, dopo che il PM ha confermato la
Definition of Done; se la card ha altre voci aperte (es. un `in_review`
non ancora mandato) il percorso entra nell'avviso.

**Lavoro che bypassa la governance.** Se `delivery_watch.board_jql` è
configurata, `delivery-watch` guarda anche le card della board non
collegate a nessuna idea. Quando ne intercetta una con una transizione
rilevante — è lavoro partito dritto su Jira, fuori dal RICE —
**crea l'idea in automatico** (via `idea-intake` in modalità backfill:
classificazione e dati abbozzati dalla card, `backfill_review_needed:
true`), la collega alla card, e accoda l'evento. Recupera il tracciamento
senza fermare il rilevamento; il PM rivede la classificazione al triage.
È il complemento della modalità Riconciliazione di `jira-sync` (che
collega idee *già esistenti* a card attive): qui l'idea non c'è ancora e
va creata.

**Rediscussione esplicita.** `framework/docs/future-work.md` chiedeva che
un livello di notifiche non fosse "ereditato per default" dalla decisione
di `mandate-watch` ("solo segnalazione, nessuna comunicazione
automatica"). Questa sezione **è** quella rediscussione: l'esito è che la
*persistenza della coda* entra nel metodo, mentre l'*auto-invio* e un
livello *batch/cron che spedisce a persone* restano fuori. Un cron
opzionale (`/schedule`) può eseguire `delivery-watch` in modalità detect
— rileva, accoda con le bozze pronte, committa — ma non fa triage e non
manda nulla; il
promemoria via hook resta il canale con cui la coda arriva davanti al PM.

**Relazione con `demo-capture`.** Per un evento `delivered` su
un'iniziativa con UI visibile, `delivery-watch` suggerisce
`demo-capture`, così la mail allo stakeholder può mostrare "cosa si vede
adesso". Definition of Done: "in produzione per Jira" si riporta, il
giudizio DoD resta del PM (come in `jira-sync` Pull).

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
> Nel repo di governance, però, l'idea passa a `status: done` solo
> quando la consegna è stata **comunicata** agli stakeholder (o
> esplicitamente esentata dal PM) — vedi "Avvisare gli stakeholder della
> conclusione". Il codice in produzione è il fatto; l'avviso è ciò che
> lo rende vero anche per chi lo aveva chiesto.
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

### Evidenza visiva di delivery (`demo-capture`)

Una card è "Done" quando il codice è in produzione — ma una card che ha
prodotto un cambiamento **visibile** (una nuova schermata, un flusso
rivisto, un componente ridisegnato) chiude meglio il loop con gli
stakeholder se alla richiesta di partenza si può riagganciare *cosa si
vede adesso*, non solo "fatto, è in produzione". Descrivere a parole un
cambiamento di interfaccia in una mail di avanzamento è debole; un'immagine
no.

`demo-capture` genera quell'evidenza partendo dal **codice reale**, non da
un mockup: fa il rendering dell'applicazione — la stessa che va (o è
andata) in produzione — su uno stato di dati controllato, e cattura gli
screenshot dei flussi che l'iniziativa ha toccato.

**Cosa è fedele e cosa no.** Fedele è il *rendering del codice*: se si
cattura dal commit/tag di release con un build di produzione, l'HTML/CSS/JS
è quello che vede l'utente. Non è fedele — ed è dichiarato su ogni
immagine e nel `manifest.yaml` — il *dato* (sintetico, mai dati reali di
clienti), le *zone con servizi terzi* (auth, pagamenti, mappe: stubbate in
modalità demo) e l'*ambiente di rendering* (font, versione del browser:
fissati, non quelli di un utente reale). L'evidenza dice "ecco la
funzionalità", non "ecco il tuo account".

**Due modalità.** `deployed` — si punta a un deployment reale del codice
(staging, o la preview environment per-PR): massima fedeltà, pipeline e
infrastruttura identiche. `local` — si porta su l'app in locale con un
build di produzione e dati di seed: il ripiego quando non c'è un ambiente
pre-esistente, con i caveat sopra tutti a carico della disciplina di
configurazione.

**Nessuna azione in uscita.** `demo-capture` produce solo artefatti
locali: gli screenshot e una bozza di nota per la card. Non allega niente
al tracker di esecuzione, non condivide niente — il momento in cui
l'evidenza esce verso gli stakeholder è sempre un atto manuale del PM
(stessa logica di `requester_reply` — "Chiudere il loop col richiedente").
Gli screenshot sono artefatti binari e non entrano in Git
(`product/demos/captures/*/screenshots/` è escluso); resta tracciato solo
un `manifest.yaml` per cattura — cosa è stato catturato, da quale commit,
quando — come record di audit, allo stesso titolo di `jira.card_id`.

**Il contratto per-app.** Come si porta su un'applicazione in modalità
demo, quali dati seminare, quali flussi catturare: tutto vive in
`product/demos/recipes/<app-slug>.yaml` (vedi
`framework/schema/demo-recipe.template.yaml`), un file per applicazione
collegata in `apps/`, scaffoldato da `demo-capture` al primo uso e
completato dal team. **Nessun segreto vi è scritto** — credenziali ed
endpoint sensibili restano in variabili d'ambiente o in un file locale
escluso da Git, mai nel repo tracciato (stesso vincolo dell'integrazione
analytics — `framework/docs/future-work.md`).

*Principio Agile da incarnare in questa fase:*
- *Il software funzionante è il miglior metro di misura del progresso.*

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

### Path da monitorare: la misurazione si prepara all'intake

Il secondo modo di dimenticarsi di misurare è arrivare al momento della
misurazione senza sapere *cosa* guardare: gli eventi che servivano non
sono mai stati tracciati, la baseline non è stata presa prima del
rilascio, e il confronto "prima/dopo" diventa impossibile. Per questo,
**quando l'istanza è collegata a una fonte analytics** (`metrics.configured:
true`), il framework **suggerisce costantemente e applica** a ogni idea
i *path da monitorare* — i percorsi utente (funnel, sequenze di
pagine/schermate/eventi) che l'idea dovrebbe muovere, o che non deve
peggiorare. Skill `path-watch`, blocco `monitoring` di `idea.yaml`.

- **Costantemente.** All'intake (`idea-intake`/`inbox-triage`), alla
  stesura del PRD (`prd-draft`), a ogni Backlog Refinement (sweep di
  apertura) e su richiesta. Ogni giro ricontrolla i path esistenti: un
  path *da strumentare* diventa attivo quando gli eventi compaiono nel
  catalogo, un path attivo diventa *rotto* quando uno step sparisce.
- **Applica, non propone.** Un path è la configurazione di cosa osservare,
  non una decisione di priorità: si scrive direttamente sull'idea (e
  nello strumento — punto sotto), senza
  `pending/`, e va nel recap al PM, che può toglierlo quando vuole (un
  path tolto non viene più riproposto). È lo stesso principio degli
  aggiornamenti di routine del contesto: l'automazione fa il lavoro, il
  PM vede cosa è stato fatto.
- **Mai inventato.** Un path è attivo solo se tutti i suoi step esistono
  nel catalogo reale dell'analytics, cercati partendo dal comportamento
  che l'idea vuole cambiare e dalle rotte/eventi già presenti nel codice
  di `apps/`. Se uno step manca, il path è *da strumentare*: non è un
  errore, è un **requisito di tracciamento** che `prd-draft` porta nel
  PRD, e che va soddisfatto *nella stessa iterazione* in cui si sviluppa
  la feature — dopo è tardi per la baseline. Se l'idea non ha un
  comportamento utente osservabile, lo si dichiara (`no_path_reason`),
  non si forza un path di comodo.
- **Baseline subito, solo aggregati.** Applicando un path attivo si legge
  la sua baseline (conversione o volume su una finestra) — un numero, mai
  righe o dati per utente: il repo è tracciato da git.
- **Dal path alla KPI.** Nel PRD il PM può legare una KPI a un path
  (`data_source.path_ref`): con `mode: automated` e il connettore su,
  `measurement-watch` legge l'aggregato di quel path invece di chiederlo.
  Il legame resta una scelta del PM, non di `path-watch`.
- **Applicati anche nello strumento, senza danneggiare il lavoro
  esistente.** Un path osservabile solo da un file YAML non lo guarda
  nessuno: il framework crea nell'analytics il funnel/report salvato del
  path (con il riferimento all'idea nel nome, in una cartella dedicata se
  il tool la prevede), o riusa e allinea quello che c'è già, e aggiunge
  gli eventi mancanti come *pianificati* nel piano di tracciamento. Lo
  strumento però è condiviso — analisti, growth, altri team ci lavorano
  già. Il criterio non è *di chi è* un oggetto, ma **se la modifica si
  può annullare**:
  - **reversibile → si fa**, anche su un oggetto creato da altri: prima
    di scrivere si registra lo stato precedente (versione del tool o
    definizione completa) in `analytics_changes` sul path, così ogni
    modifica si può annullare; le modifiche al lavoro di altri vanno
    comunque nel recap, con prima/dopo;
  - **irreversibile o che tocca lo storico → conferma esplicita prima**,
    per quella singola modifica: eliminare oggetti, unire/bloccare/
    rinominare eventi o proprietà, inviare o cancellare dati, cambiare
    impostazioni di progetto — e qualunque modifica di cui non si è
    riusciti a salvare lo stato precedente. Si spiega cosa si perde e chi
    ne è toccato; senza il PM in conversazione (sweep in background) non
    si esegue, resta una proposta;
  - i **dati storici non si distruggono** come effetto collaterale:
    cambiare come si *guardano* (definizione di un report) è reversibile,
    cambiare cosa è stato *raccolto* non lo è.
- **Una dashboard per Product Line.** I path sparsi idea per idea non
  danno il quadro: per ogni Product Line il framework tiene allineata una
  dashboard con la NSM in cima (se ha un oggetto nell'analytics) e un
  grafico per ogni path attivo delle idee attive della linea, in ordine
  di priorità — più l'elenco di ciò che è da strumentare o rotto. Si
  riallinea a ogni giro di `path-watch`: un'idea chiusa o un path tolto
  esce dalla dashboard (si toglie il grafico, non il report). Può essere
  una dashboard nuova o una esistente del team: in entrambi i casi il
  framework gestisce **solo i grafici che ha messo lui**, e quelli
  aggiunti da altri restano dove sono. Stesse regole di reversibilità.
  Riferimento in `product-lines.yaml` (`analytics_dashboard`).
  Il contenuto di un'idea (che può venire da materiale non fidato) decide
  *cosa cercare nel catalogo*, mai una query o un'operazione libera.

Con `metrics.configured: false` o `manuale` tutto questo non avviene,
senza rumore: senza un catalogo reale non c'è modo di verificare un path.

*Principi Agile da incarnare in questa fase:*
- *A intervalli regolari il team riflette su come diventare più efficace,
  poi regola il proprio comportamento di conseguenza.*
- *Il software funzionante è il miglior metro di misura del progresso.*

**Checklist operativa**
- [ ] Con una fonte analytics collegata: ogni idea in sviluppo ha i suoi path attivi con baseline, e nessun path *da strumentare* è arrivato al rilascio senza i suoi eventi?
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
- [ ] La chiusura è stata comunicata agli stakeholder (`conclusion_notices`, `kind: measurement_closed`, `sent` o `waived`) — nello stesso passo, non dopo?

## Avvisare gli stakeholder della conclusione

*"The single biggest problem in communication is the illusion that it has
taken place." — George Bernard Shaw*

"Chiudere il loop col richiedente" chiude il loop **all'ingresso**: chi
ha chiesto sa che la richiesta è stata vista. Questa sezione lo chiude
**all'uscita**, ed è altrettanto non negoziabile. Un'iniziativa che si
conclude senza che gli stakeholder lo sappiano è, per loro, un'iniziativa
ancora in corso — o peggio, dimenticata. Il valore consegnato che nessuno
sa di avere non costruisce fiducia nel processo; un'interruzione
scoperta per caso la distrugge.

**Tre conclusioni, tre avvisi obbligatori.**

| Conclusione | Quando | Cosa dice l'avviso | Destinatari tipici |
|---|---|---|---|
| `delivered` | l'idea passa a `status: done` (codice in produzione — Definition of Done; per un bug: problema chiuso) | cosa è cambiato, da quando, come si vede (screenshot da `demo-capture` se c'è UI), quando si guarderà l'impatto | richiedente (`proposer`) + stakeholders della `product_line` |
| `measurement_closed` | `closure.closed: true` nel `measurement*.yaml` | l'esito: la KPI si è mossa o non si è mossa, nelle parole del PM (`closure.outcome`/`note`), ed eventuale follow-up | stakeholders della `product_line` + richiedente |
| `aborted` | l'idea passa a `status: aborted` | perché ci si ferma, cosa succede alla richiesta (rimessa nel bucket, assorbita da un'altra iniziativa, abbandonata) | richiedente + chi era stato informato dell'avvio |

`declined` non è in tabella: è uno scarto al triage, già coperto dalla
`requester_reply` di tipo `decline`.

**Il gate.** La conclusione, per il metodo, **avviene quando è
comunicata**, non quando è rilevata. Nessuna skill scrive `status: done`,
`status: aborted` o `closure.closed: true` se non nello stesso passo in
cui la voce corrispondente di `conclusion_notices` sull'idea arriva a:

- **`sent`** — il PM dichiara di aver inviato l'avviso (testo,
  destinatari e data restano nella voce come trail); oppure
- **`waived`** — esente, con un `waived_reason` **dato dal PM** (es.
  "idea interna del PM, nessuno stakeholder esterno da avvisare"; "intake
  storico, esito già comunicato a suo tempo"). Mai un'esenzione presunta
  o automatica: "non c'è nessuno da avvisare" è un giudizio del PM.

Finché la voce resta `pending` o `drafted`, l'idea resta nello stato
precedente (`in_jira`, o in lavorazione) e la conclusione compare come
**rilevata, in attesa di avviso** — nella sweep di apertura del Backlog
Refinement e nel promemoria dell'hook `check-conclusion-notices.sh` (a
inizio e fine sessione). `done_at` resta comunque la data del fatto (il
rilascio in produzione), non quella dell'invio: la finestra di
misurazione non si sposta perché l'avviso è partito in ritardo.

**Chi apre la voce.** Chi rileva la conclusione:

- `delivery-watch` — un evento `delivered`/`bug_resolved` nel triage
  apre (o aggiorna) la voce `delivered` sull'idea; non è archiviabile con
  un semplice dismiss (vedi "Transizioni di delivery rilevanti per gli
  stakeholder");
- `jira-sync` — in Pull o in Riconciliazione, quando il PM conferma che
  un ticket chiuso significa Done;
- `measurement-watch` — quando il PM conferma l'atto di chiusura;
- `backlog-refinement` (o qualunque skill/PM in conversazione) — quando
  il PM decide di interrompere un'iniziativa (`aborted`) o dichiara a
  mano che è in produzione (istanza senza tracker collegato).

**Mai inviato in automatico.** Come `requester_reply`: la skill scrive la
bozza (`subject`, `body`, `recipients` proposti da `proposer` +
stakeholders della `product_line` in `product-lines.yaml`), il PM la
rivede e la manda a mano dal suo client di posta — mostrata per intero
e pronta da copiare, vedi "Testi che il PM manda a mano: visibili e
pronti da copiare". Non passa da `product/approvals/pending/`: è
comunicazione 1:1 con l'iniziativa, non una decisione di priorità, e
rimandarla a un secondo assenso significherebbe perderla — la stessa
ragione per cui il ticket di un bug confermato si apre subito. Il gate
non chiede un'approvazione in più: chiede che l'avviso **esista**.

*Principio Agile da incarnare in questa fase:*
- *La nostra massima priorità è soddisfare il cliente* — e il cliente
  interno che non sa di essere stato soddisfatto non lo è.

**Checklist operativa**
- [ ] Ogni idea `done` ha una voce `delivered` in `conclusion_notices` con `sent` o `waived`?
- [ ] Ogni idea `aborted` (dopo l'avvio) ha una voce `aborted` con `sent` o `waived`?
- [ ] Ogni `closure.closed: true` ha la sua voce `measurement_closed` con `sent` o `waived`?
- [ ] Ogni `waived` ha un motivo dato dal PM, non presunto?
- [ ] Le conclusioni rilevate e ancora `pending`/`drafted` sono state riviste all'ultimo Backlog Refinement?

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

**RICE** — Framework di prioritizzazione basato su quattro parametri, tutti
su scala **1-10**: Reach (quante persone impatta — vedi voce dedicata),
Impact (quanto vale in termini di business), Confidence (quanto si è sicuri
delle stime), Entanglement (footprint del cambiamento nel sistema — vedi
voce dedicata). Il punteggio finale è R × I × C / E.

**Reach** — La "R" del RICE. Quota della popolazione della Product Line
che beneficia dell'iniziativa, portata su scala 1-10:
`max(1, ceil(percentuale / 10))` — arrotondamento per eccesso, minimo 1.
La percentuale si ricava dal `reach_denominator` dichiarato per la Product
Line (`product/reference/product-lines.yaml`), non a occhio; il valore
assoluto e la percentuale restano come nota di contesto nel record
dell'idea, non entrano nello score. Fino a settembre 2026 Reach era una
percentuale 0-100 dentro lo score — le voci `rice_history` più vecchie si
migrano meccanicamente (`sync-framework-updates`).

**Entanglement (footprint del cambiamento)** — La "E" del RICE. Stima
1-10 di quanto un'iniziativa è intrecciata col resto del sistema: quanti
componenti/sistemi/team tocca, superficie di regressione, complessità di
review e rollout, più eventuali costi esterni hard (legale, licenze, UAT
estesa). Valore alto = più intrecciata = più a rischio = deprioritizzata
(è a denominatore). Sostituisce la vecchia "Effort" (settimane-
sviluppatore), resa un segnale rumoroso dall'implementazione AI-assistita
che scollega il tempo di codifica dal costo reale del cambiamento. La
stima di tempo per la pianificazione vive altrove (blocco `delivery`,
persona-settimane per competenza + durata, stimato dal team tech;
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
sempre la fonte del materiale grezzo da cui derivano. Alimentata dalla
skill `context-intake` (drop manuale o pull da cartelle collegate) e
tenuta aggiornata da `context-watch`. Nessun file grezzo (PDF, slide,
docx) vi persiste: solo la trascrizione. Vedi sezione "Contesto aziendale
(`context/`)".

**`context-watch`** — Skill che controlla periodicamente le cartelle
documentali collegate come sorgente di contesto (`connectors:` con
`folders:` in `.governance/config.yaml`) e porta in `context/` i documenti
nuovi o cambiati: applica direttamente gli **aggiornamenti di routine**
(rinfresco di dati senza cambiare le conclusioni), manda in
`product/approvals/pending/` (`type: context_update`) i **cambiamenti
materiali** (che cambierebbero come si scrivono i PRD), e in ogni caso
produce un recap al PM. Gira standalone e come ultimo passo della sweep di
apertura del Backlog Refinement. Vedi sezione "Contesto aziendale
(`context/`)", sottosezione "Aggiornamento di routine vs. cambiamento
materiale".

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
con un richiedente che non è il PM stesso, qualunque sia l'esito, il
framework prepara una bozza di risposta (presa in carico / bug in agenda /
mandate o platform presi in carico / eccezione in attesa di conferma /
scarto motivato / richiesta di chiarimento), salvata sull'idea in
`requester_reply` — o in `followup_replies` quando il materiale aggiorna
un'idea o un PRD esistente — e **mai inviata in automatico**: la rivede e
la manda il PM. Serve a chiudere il loop con chi ha scritto, che
altrimenti resta al buio. Vedi "Chiudere il loop col richiedente".

**Deep dive (meeting di approfondimento)** — Riunione col richiedente
necessaria per inquadrare un'idea abbastanza da farne un RICE serio.
Marcata in `rice_status.deep_dive`; `rice-watch` la ricorda con
insistenza — con escalation — finché il meeting non è fissato e
avvenuto. È il sotto-caso più actionable di "idea senza RICE": non
aspetta un dato, aspetta che il PM metta il meeting in calendario.

**Product Backlog Refinement** — Cerimonia settimanale in cui PM e tech
lead allineano le priorità e preparano il backlog per l'iterazione
successiva. Non è una pianificazione ferma: è una fotografia aggiornata
delle intenzioni. Il suo output primario è il **Piano di Iterazione**.

**Piano di Iterazione** — Artefatto team-facing
(`product/roadmap/iterations/{settimana}.yaml`), output primario del
Backlog Refinement: quattro bucket (*analisi da avviare*, *analisi in
corso*, *in sviluppo*, *prioritizzate d'urgenza*) costruiti come diff dal
piano della settimana precedente. È la board operativa "cosa fa il team
adesso"; lo snapshot di roadmap è il rollup strategico che lo referenzia.
Passa sempre da `product/approvals/pending/`. Vista rapida:
skill `iteration-board`.

**Capacity check** — Confronto, per competenza, tra l'offerta del team
nella settimana (`team.yaml`: `fte` × ripartizione × giorni lavorativi,
al netto dell'overhead) e la domanda del Piano di Iterazione (carichi
settimanali delle iniziative in sviluppo). Una competenza oltre il 100%
si riequilibra o si accetta con decisione registrata
(`capacity_overrides`). Vedi "Capacità del team e slot della roadmap".

**Slot plan** — Collocazione delle iniziative dimensionate nelle
prossime 13 settimane, in ordine di priorità, dentro la capacità residua
per competenza (`roadmap-snapshot`, blocco `slot_plan`). Dice *quando*,
con il team che c'è; `delayed_by` nomina la competenza collo di
bottiglia. Advisory e derivato: non cambia le priorità.

**Persona-settimana** — Unità di capacità e di stima: una persona a tempo
pieno sul prodotto per una settimana lavorativa. L'offerta si esprime al
netto dell'overhead; la domanda (`effort_by_competency`) è il lavoro
pianificato.

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
