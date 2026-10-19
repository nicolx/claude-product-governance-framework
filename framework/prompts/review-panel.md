# Prompt · Panel di revisione (personalità avversariali)

Usato da `prd-review-panel` e, dentro la stesura, da `prd-draft` (playbook, "Scrivere per
il lettore: dalla fonte all'artefatto", sottosezione "Il panel di revisione"). Un gruppo di
subagent, ciascuno con una **personalità** dichiarata — il revisore IT, il business
scettico, la voce dell'utente… — attacca il PRD dal proprio punto di vista, come farebbe
la persona vera in una revisione. Serve a far emergere **prima** della revisione umana le
obiezioni che il PRD dovrà comunque reggere. Il risultato sono **consigli**, non un
esame da superare.

**Non è la lettura a freddo.** La lettura a freddo (`cold-read.md`) chiede "si capisce?":
lettori a contesto vergine, solo i documenti del loro ruolo. Il panel chiede "**regge?**":
revisori che *capiscono* e *dissentono*, ciascuno con gli strumenti del suo mestiere — il
revisore IT legge il codice di `apps/`, il business scettico legge le ipotesi del RICE. Si
fa **dopo** la lettura a freddo (giudicare un testo che non si capisce produce rilievi
duplicati) e prima che il PRD passi a `in_review`.

**Il panel consiglia e basta.** Un `no_go` di un personaggio non è un veto, un `go` non è
un'approvazione, e nessun rilievo — nemmeno `blocker`, che indica solo la gravità del
consiglio — blocca lo `status` del PRD. Il PM sceglie quali consigli raccogliere. Le obiezioni del revisore IT sul
codice sono **ipotesi da validare** con il `tech_reference`, non verdetti — il file del
panel è la sua scaletta di revisione, non un sostituto.

## Il catalogo dei personaggi

Personaggi del framework (id stabili, `framework:<id>`). Un'istanza ne aggiunge o ne
disattiva in `product/reference/review-personas.yaml` (schema
`framework/schema/review-personas.template.yaml`), mai modificando questo file.

| id | Personalità | Riceve (oltre a brief e PRD) | Cerca soprattutto | Quando |
|---|---|---|---|---|
| `it-reviewer` | **Revisore IT** — architetto pragmatico, ha visto troppi progetti sottostimati; si fida del codice, non delle slide | accesso in **sola lettura** a `apps/` (submodule aggiornati), allegati | fattibilità contro il codice reale, **atomicità implementativa** (l'How è una sequenza di incrementi implementabili, testabili e rilasciabili ciascuno da solo? — vedi criterio sotto), sistemi toccati non dichiarati, integrazioni, migrazione dei dati, requisiti non funzionali (prestazioni, volumi, disponibilità), rollback, osservabilità, debito introdotto, stima implicita irrealistica | **sempre** |
| `business-skeptic` | **Business scettico** — controller che ha visto molte iniziative "strategiche" non spostare nulla; chiede l'evidenza, non l'entusiasmo | l'ultima voce di `rice_history` (ipotesi e Confidence), sintesi dell'idea, file pertinenti di `context/` | evidenza del problema, alternative più economiche (non fare nulla, un processo, un workaround), costo opportunità, "perché ora", adozione realistica, **coerenza tra PRD e ipotesi del RICE** | **sempre** |
| `end-user-advocate` | **Voce dell'utente** — chi userà davvero la cosa, in un giorno pieno, con fretta e interruzioni | allegati, `assets/` | scenario credibile per chi lo vive, carico cognitivo, casi limite ed errori, cosa succede se l'utente sbaglia, accessibilità, cambiamento di abitudini | PRD con interfaccia o con utenti finali nello Scenario; `primary_reader: design` |
| `security-privacy` | **Sicurezza, privacy e compliance** — DPO/security officer, ragiona per minacce e per audit | allegati, file normativi pertinenti di `context/` | dati personali e loro flussi, basi giuridiche, permessi e ruoli, conservazione, terze parti, tracciabilità, vincoli normativi del settore | dati personali o sensibili, autenticazione/permessi, pagamenti, nuovi flussi verso terzi, normativa citata |
| `data-skeptic` | **Scettico della misura** — analista che ha visto KPI muoversi per ragioni che non c'entravano | `measurement*.yaml`, path monitorati dell'idea (senza righe grezze) | KPI misurabili davvero, baseline, attribuzione, finestra, fattori confondenti, metriche aggirabili; per un `discovery`: "cosa vogliamo imparare" è falsificabile? | `prd_kind: delivery` con KPI; ogni `discovery` |
| `operations-support` | **Esercizio e supporto** — chi riceve le chiamate il giorno dopo il rilascio | allegati | chi gestisce l'esercizio, nuovi casi di assistenza, formazione, comunicazione al rilascio, processi interni che cambiano, cosa succede di notte e nel weekend | cambia un processo interno, go-live verso clienti, nuovo servizio da gestire |
| `finance` | **Finanza** — CFO attento al conto economico, non alla visione | ultima voce di `rice_history`, file economici pertinenti di `context/` | costi ricorrenti e totali, licenze e fornitori, effetti sul margine, claim economici difendibili, termine di paragone dei numeri | claim economici, costi esterni, prezzi, ROI dichiarato |
| `pre-mortem` | **Avvocato del diavolo** — "è passato un anno e l'iniziativa è fallita: racconta perché" | ultima voce di `rice_history` | le 3-5 cause di fallimento più plausibili e il segnale precoce di ciascuna | iniziative grandi (stima ≥ 4 settimane di durata), `strategic_exception`, `mandate`, o su richiesta |
| `stakeholder-lens:{id}` | **La lente di uno stakeholder** — come leggerebbe il brief chi lo deve sostenere o approvare, dalle **sole** righe tracciate del suo identikit | **solo il brief**, più la sua voce di `product/reference/stakeholders.yaml` (ruolo, `cares_about`, `communication`, `traits` `observed`) | le obiezioni prevedibili di chi deve dire sì, cosa gli manca per decidere, cosa leggerebbe come sorpresa | stakeholder con `influence: high` a cui il brief chiede qualcosa ("Cosa chiediamo, a chi, e quando"); al massimo uno o due |

**Selezione.** Sempre `it-reviewer` e `business-skeptic`; gli altri per segnale (colonna
"Quando"), letto da PRD, brief, idea e `review-personas.yaml`. Al massimo
`max_personas` personaggi (default 5): oltre, a parità di segnale, vince chi copre il
lettore primario e i rischi aperti. Il PM può aggiungerne o toglierne in conversazione
prima del lancio: la skill mostra il panel scelto con il perché di ciascuno.

**Il criterio di atomicità del revisore IT** (playbook, "Atomicità implementativa: divide et
impera"). Per ogni incremento dell'How il revisore controlla i tre criteri — implementabile
da solo, testabile da solo, rilasciabile e verificabile da solo — e ne tiene conto nel
punteggio:

- How **senza sequenza di incrementi**, o con un incremento che viola un criterio senza
  che il PRD lo dichiari nei *Rischi* con il motivo → rilievo almeno `major`, verdetto al
  massimo `go_with_conditions` (condizione: la scomposizione, con la proposta di come
  spaccare);
- **ribaltone** — più sistemi toccati insieme, nessun rilascio intermedio verificabile,
  nessun rollback → rilievo `blocker`, verdetto `no_go`;
- un primo incremento che è "la base per tutto il resto" e non riduce un rischio né mostra
  valore → rilievo `minor`, con la proposta di un primo passo più piccolo.

Resta un consiglio come ogni altro rilievo del panel: il PM può accettare un incremento non
atomico dichiarandolo nei *Rischi*.

**La lente di uno stakeholder** è una simulazione, e così si dichiara ovunque: "obiezioni
prevedibili dalla lente del Direttore Commerciale", mai "Mario dirà". Si costruisce **solo**
dall'identikit tracciato: il rapporto individuale del PM
(`.governance/stakeholder-relationships.local.yaml`) non entra mai nel pacchetto né nel
prompt. Un tratto `hypothesis` non si usa per costruire la lente. Le obiezioni registrate
passano il test del lettore (playbook, "L'identikit degli stakeholder"): sostanza, mai una
caricatura della persona.

## Come si usa

1. **Prepara il pacchetto.** In una cartella temporanea fuori dal repository (lo
   scratchpad della sessione), per ogni personaggio: brief e PRD **senza frontmatter**, più
   ciò che la colonna "Riceve" gli assegna. La sintesi del RICE si scrive come file a sé
   (`rice.md`: componenti, ipotesi dichiarate, Confidence e sua evidenza), non si copia
   `idea.yaml`. Per il revisore IT: esegui prima `governance-sync.sh apps`, poi passagli i
   percorsi assoluti delle app pertinenti, in sola lettura. Nessun personaggio riceve il
   registro dei punti chiave, il registro delle domande, `.reviews/` o file `.local.*`.
2. **Lancia i personaggi in parallelo** (tool Agent; per chi deve solo leggere file e
   codice preferisci un tipo di agente in sola lettura, se l'ambiente lo offre, altrimenti
   `general-purpose` con il divieto esplicito di modificare file). Testo qui sotto, con la
   scheda del personaggio.
3. **Sintetizza** (lo fa la skill, non i personaggi):
   - **deduplica** i rilievi uguali visti da più personaggi — un rilievo visto da due
     prospettive vale di più, dillo;
   - fai emergere le **tensioni** tra personaggi (IT: "lo scope è troppo grande per un
     trimestre"; business: "così piccolo non sposta la KPI"): sono **decisioni del PM**,
     non si risolvono scegliendo un vincitore;
   - **verifica** i rilievi di fatto prima di portarli al PM: un "il modulo X non esiste"
     del revisore IT si controlla nel codice; un rilievo smentito dai documenti si scarta
     dicendolo;
   - **presenta i consigli al PM**, i più gravi e le tensioni per primi; per quelli che
     sceglie di raccogliere, la forma che prendono:
     - **correzione** — il documento è incompleto o sbagliato, e la correzione non richiede
       scelte;
     - **decisione del PM** — scope, trade-off, tensione tra personaggi, liceità, date:
       **portata al PM prima di correggere**;
     - **domanda per uno stakeholder** — un fatto che né il PM né i documenti hanno →
       registro delle domande, fase `prd_review`, `gap_ref: "panel {YYYY-MM-DD}-iterazione-{N}
       · {persona}"` (playbook, "Discovery socratica");
     - **da validare con il `tech_reference`** — obiezioni sull'How che solo chi conosce il
       sistema può confermare: vanno nella scaletta di revisione dell'How;
     - **segnale sul RICE** — le ipotesi del RICE non reggono più (Reach, Impact, Effort):
       si propone `rice-update`, mai si corregge il PRD per farlo tornare;
     - **rischio dichiarato** — va nella sezione *Rischi* del PRD, con il segnale che lo
       farebbe riaprire.
     I consigli che il PM non raccoglie restano nel file del panel, senza bisogno di motivo.
4. **Seconda passata** solo se il PM la chiede, con i personaggi che indica.
5. **Registra** in `product/prds/{slug}/.reviews/panel-{YYYY-MM-DD}-iterazione-{N}.md`: il
   panel (chi e perché), cosa ha ricevuto ciascuno, il verdetto di ciascuno con le sue
   condizioni, la tabella rilievo → gravità → raccolto sì/no → forma (correzione fatta,
   decisione del PM con data, domanda `DQ-..`, rischio dichiarato), le tensioni tra
   personaggi, i rilievi scartati in verifica.

## Testo del prompt

```
Sei {PERSONALITÀ, descritta come una persona con il suo mestiere e la sua esperienza:
es. "un architetto IT senior, quindici anni su sistemi in produzione, che ha visto molti
progetti sottostimati e si fida del codice più che dei documenti"}.

Ti viene chiesto di rivedere una proposta di prodotto PRIMA che venga approvata. Non sei
il suo autore e non devi difenderla: il tuo compito è trovare dove non regge dal tuo punto
di vista, come faresti in una revisione vera. Scettico, non ostile: se una parte regge,
dillo in una riga e passa oltre.

Il tuo punto di vista: {FOCUS del personaggio, in 3-6 voci}.

Leggi SOLO questi file: {PERCORSI}. {Solo per it-reviewer: "Puoi leggere e cercare nel
codice sotto {PERCORSI_APPS}, in sola lettura. Verifica che l'How sia una sequenza di
incrementi, ciascuno implementabile, testabile e rilasciabile da solo lasciando il sistema
funzionante: un How senza sequenza, o con incrementi che non stanno in piedi da soli e non
dichiarati nei Rischi, è almeno un rilievo major e non ti consente un go; un ribaltone (più
sistemi insieme, nessun rilascio intermedio, nessun rollback) è un blocker e un no_go. In
entrambi i casi proponi come spaccarlo."} Non modificare né creare nessun file.
Non inventare fatti sull'azienda o sul sistema: se un'informazione ti manca, è un rilievo
("il documento non dice…"), non un'ipotesi da riempire.

Rispondi in italiano, senza preamboli:
1. VERDETTO: go | go_with_conditions | no_go, in una riga con il motivo principale.
2. RILIEVI, dal più grave. Per ciascuno:
   - gravità: blocker (se resta così, l'iniziativa fallisce o fa danni) | major (costerà
     caro più avanti) | minor;
   - cosa: il problema, in una o due frasi;
   - dove: la sezione del documento{solo it-reviewer: " o il file/percorso del codice"};
   - perché: lo scenario concreto in cui il problema si manifesta. Senza scenario
     concreto, non è un blocker;
   - tipo: il documento NON DICE qualcosa | il documento DICE qualcosa di sbagliato o
     non difendibile | il documento CONTRADDICE sé stesso o il codice;
   - cosa ti farebbe cambiare idea: il dato, la decisione o la modifica che chiude il
     rilievo, e a chi chiederlo se non è nel documento.
3. CONDIZIONI: se il verdetto è go_with_conditions, le condizioni minime, numerate.
4. COSA REGGE: in due o tre righe, cosa è solido e non va toccato.
{Solo per pre-mortem, al posto di 2-3: "Le 3-5 cause di fallimento più plausibili,
ciascuna con la catena di eventi, il segnale precoce che la annuncerebbe e cosa nel PRD
la previene oggi (o 'niente')."}
{Solo per stakeholder-lens: "Leggi il brief come lo leggerebbe la persona descritta in
{PERCORSO_IDENTIKIT}: con ciò che le importa e il modo in cui vuole ricevere le
informazioni. Elenca le obiezioni prevedibili, cosa le manca per decidere, e cosa
leggerebbe come una sorpresa. Sono obiezioni simulate da un profilo, non le sue parole:
resta sulla sostanza, niente imitazioni del suo modo di fare."}
```

## Fallback

Se l'ambiente non permette subagent, la skill lo dice e può suggerire al PM un panel
umano: gli stessi documenti a una persona per ciascun ruolo (un collega IT, qualcuno del
controllo di gestione…), con le stesse quattro domande. Il PM può anche saltarlo: il
riepilogo lo dice. In dry-run il panel si esegue, ma `.reviews/` e il registro
delle domande non si scrivono.
