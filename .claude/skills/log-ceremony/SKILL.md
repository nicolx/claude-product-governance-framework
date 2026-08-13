---
name: log-ceremony
description: Registra una cerimonia collettiva (Backlog Refinement, Roadmap & Iteration Planning, ecc.) a partire dalla sua trascrizione grezza, producendo un record strutturato di decisioni collegato a idee/roadmap impattati. Per il Backlog Refinement rileva anche reprioritizzazioni fuori RICE e richiama measurement-watch, mandate-watch e rice-watch per segnalare impatti mancati, iniziative mandatarie a rischio e idee ancora senza RICE. Usala dopo una riunione di team.
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

8. **Per `backlog-refinement`, richiama `measurement-watch` — idealmente
   per prima, prima ancora delle altre watch.** Il playbook descrive
   questa cerimonia come l'occasione per chiedersi, in apertura, quali
   iniziative già rilasciate stanno mostrando impatti e quali no, prima
   di guardare cosa entra in agenda dopo (playbook, "Product Backlog
   Refinement" / "Measurement"). Se emergono KPI `check_due` (la
   finestra di misurazione è passata ma manca ancora una lettura) o
   `at_risk`/`invalidated`, includile esplicitamente nel riepilogo (passo
   11) — è tracciare le metriche nel tempo, su Git, che permette
   decisioni migliori su dove veicolare gli investimenti futuri.

9. **Richiama anche `mandate-watch`.** È il meccanismo che garantisce il
   controllo periodico "con congruo anticipo" sulle iniziative
   mandatarie (playbook, "Iniziative Mandatarie"): ad ogni Backlog
   Refinement, non solo quando qualcuno se ne ricorda. Se emergono
   mandate `overdue`, `due_soon`, o `pending_review`, includili
   esplicitamente come input alla riunione nel riepilogo mostrato al PM
   (passo 11) — **solo segnalazione**, non generare comunicazioni o
   proposte automatiche da questo passo: `mandate-watch` non ne genera,
   e `log-ceremony` non ne aggiunge di proprie.

10. **Richiama anche `rice-watch`.** Stesso principio, ma per le idee
    normali senza RICE: senza questo controllo periodico, un'idea in
    attesa di un'informazione da uno stakeholder rischia di restare
    dimenticata nel bucket. Se emergono idee `stale` o `blocked_on`,
    includile esplicitamente nel riepilogo (passo 11) — anche qui, solo
    segnalazione, nessuna azione automatica.

11. Mostra un riepilogo delle decisioni estratte all'utente prima di
    considerare il log completo — è più facile correggere un
    fraintendimento ora che scoprirlo settimane dopo in una revisione.
    Se sono state rilevate reprioritizzazioni, includile esplicitamente
    nel riepilogo, distinguendo le due categorie. Se `measurement-watch`,
    `mandate-watch` o `rice-watch` hanno segnalato elementi a rischio,
    includili con la stessa evidenza — non in coda, non come nota a
    margine, e apri il riepilogo proprio con `measurement-watch` se ha
    trovato qualcosa: è la prima domanda della cerimonia, per playbook.
