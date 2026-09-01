---
name: log-ceremony
description: Registra una cerimonia collettiva (Backlog Refinement, Roadmap & Iteration Planning, ecc.) a partire dalla sua trascrizione grezza, producendo un record strutturato di decisioni collegato a idee/roadmap impattati. Per il Backlog Refinement rileva anche reprioritizzazioni fuori RICE e richiama nsm-watch, measurement-watch, mandate-watch, deadline-watch e rice-watch per segnalare NSM in degrado, impatti mancati, iniziative mandatarie e scadenze su idee normali a rischio, e idee ancora senza RICE. Usala dopo una riunione di team.
---

# log-ceremony

Registra una cerimonia collettiva del playbook (Product Backlog
Refinement, Roadmap Update & Iteration Planning, o altra cerimonia
ricorrente/ad-hoc) a partire dalla sua trascrizione o dagli appunti
grezzi.

## Quando usarla e quando no

Usala per riunioni di **team** con decisioni qualitative da tracciare
(priorità discusse, retro, user story confermate). **Non usarla** per la
discussione di RICE scoring legata a una singola idea (Episodio-tipo:
PM + referente tecnico + stakeholder che stimano RICE di un'idea
specifica) — quel materiale va invece salvato come `source/` dentro la
cartella dell'idea stessa, perché è 1:1 con un'idea, non un rito
ricorrente del team.

## Passi

0. **Sincronizza da `origin` prima di leggere lo stato**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)"). Le reprioritizzazioni e
   le watch che seguono confrontano lo stato di molte idee: devono
   partire dai dati aggiornati del team. Se l'helper segnala un
   disallineamento non-fast-forward, fermati e riferiscilo all'utente.

1. Determina `ceremony_type` (es. `backlog-refinement`,
   `roadmap-iteration-planning`, `measurement-retro`, o altro se
   l'utente lo specifica) e il periodo (settimana ISO per cerimonie
   settimanali, data per le altre).

2. Crea `product/ceremonies/{ceremony_type}/{periodo}/`. Se esiste già
   per lo stesso periodo, chiedi se integrare o è un errore.

3. Salva il materiale grezzo (trascrizione, appunti) in `source/` dentro
   la cartella, senza parafrasarlo via.

4. Estrai le decisioni atomiche e compila `decisions.yaml` da
   `framework/schema/ceremony-decisions.template.yaml`: per ogni
   decisione, un `summary` breve e gli `impacts` — quali idee sono state
   ridiscusse, se è stato generato uno snapshot di roadmap, se è stata
   creata una voce in `approvals/`.

5. **Non applicare tu stesso gli impatti.** Se dalla cerimonia emerge che
   il RICE di un'idea va rivisto, lancia (o suggerisci di lanciare)
   `rice-update` — non scrivere direttamente su `idea.yaml`. Se emerge
   che serve un nuovo snapshot di roadmap, suggerisci `roadmap-snapshot`.
   `log-ceremony` cattura e struttura il *materiale*, non decide da sola
   cosa applicare.

6. Per `backlog-refinement`, compila anche `retro_notes` (percentuale di
   completamento dell'iterazione precedente, impedimenti riscontrati) se
   presente nella trascrizione.

7. **Per `backlog-refinement`, rileva le reprioritizzazioni.** Si
   applica **solo alle iniziative `classification: idea`** — bug,
   strategic exception, mandate e platform non sono mai state
   RICE-ranked per disegno, quindi il loro ingresso in iterazione non è
   una reprioritizzazione da segnalare, è il loro percorso normale (non
   chiedere nulla per queste). Per ogni iniziativa `classification: idea`
   che entra nell'iterazione corrente, confronta la sua posizione con il
   RICE score attuale delle altre idee `classification: idea` ancora in
   backlog (leggi `rice_history` più recente di ciascuna idea
   prioritizzata non ancora in iterazione). Se un'iniziativa entra pur
   avendoci idee con score più alto ancora in attesa, **non limitarti a
   registrarlo come una decisione qualunque**: chiedi esplicitamente al
   PM —

   > "Questa iniziativa entra davanti a idee con RICE più alto ancora in
   > backlog. È una Strategic Exception (uno stakeholder ha chiesto di
   > bypassare la priorità) o una scelta qualitativa del team dentro il
   > processo normale?"

   Registra la risposta in `reprioritizations` (vedi
   `ceremony-decisions.template.yaml`), con `reason_type` distinto:
   - **`qualitative_team_call`** — resta solo qui, nessun'altra
     scrittura. È normale governance del backlog, non un'eccezione.
   - **`strategic_exception`** — in più, prepara una proposta
     `type: strategic_exception_flag` in `product/approvals/pending/`
     (payload: nuova voce per `strategic_exceptions` dell'idea, con
     `invoked_at_stage: backlog_refinement`, `ceremony_ref` verso questa
     cartella). **Non scrivere direttamente su `idea.yaml`** — stessa
     regola delle altre skill: proponi, non applicare. Non presumere mai
     `approved_by`: chiedilo esplicitamente, anche se il richiedente ha
     un ruolo senior.

   Questa distinzione è il modo in cui il framework intercetta il
   pattern descritto dal playbook ("Come gestire le frizioni" — Scenario
   2): se la stessa persona invoca Strategic Exception ogni settimana,
   deve emergere dai dati, non restare un'impressione.

8. **Per `backlog-refinement`, richiama `nsm-watch` per prima tra tutte
   le watch — prima ancora di `measurement-watch`.** È il segnale più
   strategico che il framework osserva (playbook, "Salute delle NSM e
   Product Discovery"): se una North Star Metric sta degradando, questo
   dovrebbe riportare il focus della Product Discovery su iniziative
   mirate a quella metrica, anche rispetto a idee con RICE più alto in
   backlog. Se emergono NSM `degrading` con `alert.status: active`,
   apri il riepilogo (passo 12) proprio con questo — prima delle
   reprioritizzazioni, prima delle iniziative mandatarie, prima di
   tutto.

9. **Richiama `measurement-watch`.** Il playbook descrive questa
   cerimonia come l'occasione per chiedersi, in apertura, quali
   iniziative già rilasciate stanno mostrando impatti e quali no, prima
   di guardare cosa entra in agenda dopo (playbook, "Product Backlog
   Refinement" / "Measurement"). Se emergono KPI `check_due` (la
   finestra di misurazione è passata ma manca ancora una lettura) o
   `at_risk`/`invalidated`, includile esplicitamente nel riepilogo (passo
   12) — è tracciare le metriche nel tempo, su Git, che permette
   decisioni migliori su dove veicolare gli investimenti futuri.

10. **Richiama anche `mandate-watch`.** È il meccanismo che garantisce il
    controllo periodico "con congruo anticipo" sulle iniziative
    mandatarie (playbook, "Iniziative Mandatarie"): ad ogni Backlog
    Refinement, non solo quando qualcuno se ne ricorda. Se emergono
    mandate `overdue`, `due_soon`, o `pending_review`, includili
    esplicitamente come input alla riunione nel riepilogo mostrato al PM
    (passo 12) — **solo segnalazione**, non generare comunicazioni o
    proposte automatiche da questo passo: `mandate-watch` non ne genera,
    e `log-ceremony` non ne aggiunge di proprie.

11. **Richiama anche `deadline-watch`, subito dopo `mandate-watch`.**
    Stesso tipo di segnale (una scadenza esterna in avvicinamento), ma
    per idee normali o strategic exception che non sono (ancora)
    `classification: mandate` — playbook, "Scadenze su idee normali
    (`deadline`)". Se emergono idee `due_soon` (4 settimane o meno) o
    `overdue`, includile nel riepilogo (passo 13) con la **stessa forza**
    con cui `deadline-watch` le ha segnalate — non attenuarle qui: sono
    un push esplicito al PM, non una nota informativa.

12. **Richiama anche `rice-watch`.** Stesso principio, ma per le idee
    normali senza RICE: senza questo controllo periodico, un'idea in
    attesa di un'informazione da uno stakeholder rischia di restare
    dimenticata nel bucket. Se emergono idee `stale`, `blocked_on` o
    **`needs_deep_dive`** (aspettano un meeting col richiedente che il PM
    deve organizzare — la categoria più actionable), includile
    esplicitamente nel riepilogo (passo 13) — anche qui, solo
    segnalazione, nessuna azione automatica.

13. Mostra un riepilogo delle decisioni estratte all'utente prima di
    considerare il log completo — è più facile correggere un
    fraintendimento ora che scoprirlo settimane dopo in una revisione.
    Se sono state rilevate reprioritizzazioni, includile esplicitamente
    nel riepilogo, distinguendo le due categorie. Se `nsm-watch`,
    `measurement-watch`, `mandate-watch`, `deadline-watch` o `rice-watch`
    hanno segnalato elementi a rischio, includili con la stessa evidenza
    — non in coda, non come nota a margine — e **apri sempre il
    riepilogo con gli allarmi di `nsm-watch`**, se ce ne sono (è il
    segnale più strategico della cerimonia, per playbook), seguiti dalle
    scadenze `overdue`/`due_soon` di `mandate-watch` e `deadline-watch`.

14. **Sincronizza il repo**: esegui
    `bash .claude/hooks/governance-sync.sh push "log-ceremony: <ceremony_type> <periodo>" product/ceremonies/ product/approvals/pending/`
    (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Le watch
    richiamate ai passi 8-12 hanno già sincronizzato le proprie scritture
    su `idea.yaml`/`nsm-tracking.yaml` con un commit dedicato ciascuna;
    questo passo cattura i file della cerimonia e le eventuali proposte in
    `pending/`. Se l'helper segnala un push fallito, riferiscilo nel
    riepilogo.
