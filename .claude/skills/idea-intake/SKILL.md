---
name: idea-intake
description: Trasforma materiale grezzo (email, trascrizione, segnalazione) in una nuova idea strutturata in product/ideas/, classificandola come idea/bug/strategic exception/mandate/platform secondo il playbook. Usala quando l'utente allega o incolla materiale nuovo da valutare.
---

# idea-intake

Trasforma materiale grezzo — email, trascrizione di riunione, messaggio,
segnalazione — in un'idea strutturata, secondo il playbook (sezione
"Alimentazione del bucket delle idee").

Non richiede che il materiale sia passato da `product/inbox/` — è
utilizzabile direttamente su qualunque materiale grezzo l'utente fornisca
in conversazione (allegato, testo incollato, riferimento a un file). La
skill `inbox-triage` la richiama internamente per il caso "nuova idea",
ma non è l'unico modo di usarla.

## Prerequisiti

Richiede un'istanza inizializzata (`.governance/config.yaml` presente e
`product/reference/product-lines.yaml` popolato). Se mancano, ferma e
indirizza a `init-governance-project`.

## Principio guida: garantista, non produttivista

**Meglio una domanda in più che un'idea scritta male.** Un record con
dati inferiti o indovinati per completare lo schema è peggio di non
averlo ancora creato — qualcuno prioritizzerà o lavorerà su basi
sbagliate, e il costo si scopre solo dopo. Se manca un dato essenziale
(chi è il proponente, qual è davvero il problema, perché sembra
rilevante) e non è ricavabile con certezza dal materiale, **chiedi
all'utente prima di scrivere**, non riempire il campo a caso. Vale anche
per Product Line, per l'ipotesi che l'idea sia un duplicato di una già
esistente, e per qualunque numero o affermazione non letteralmente
presente nel materiale di origine.

## Passi

1. **Leggi il materiale grezzo** fornito dall'utente (allegato, testo
   incollato, o riferimento a un file).

2. **Decomponi prima di classificare, se il materiale mescola più
   richieste indipendenti.** Una singola mail o trascrizione può
   contenere più idee distinte, ciascuna con la propria priorità futura.
   **Criterio pratico**: se a due parti del contenuto assegneresti un
   RICE score indipendente e scollegato (Reach/Impact/Confidence/Entanglement
   diversi, senza che l'uno dipenda dall'altro), sono due idee, non una
   — non forzarle in un'unica cartella solo perché sono arrivate insieme.
   Da qui in poi, ripeti i passi 3-7 **per ciascuna unità risultante**,
   in modo completamente indipendente (classificazione, slug, RICE
   futuro separati). Se invece il materiale è coeso (un solo problema
   descritto da più angolazioni), resta un'unica idea.

3. **Classifica** ogni unità risultante secondo il playbook:
   - **Bug** — se descrive un output diverso da quanto atteso per errore
     di codice o interpretazione errata del requisito. **Crea comunque la
     cartella idea** (passi 4-6 sotto), con `classification: bug` — serve
     per non perdere il materiale grezzo e per avere un record archiviato
     e diffabile. La differenza rispetto a un'idea normale: **non passa
     mai dal RICE** (`rice_history` resta `[]` per sempre, non solo in
     questo passo) e non entra nel Backlog Refinement per priorità —
     segnala esplicitamente all'utente che va aperto anche nel tracker di
     esecuzione (Jira) con impatto stimato, e chiedi se vuole che tu
     prepari il testo del ticket. Una volta creato il ticket, popola
     comunque `jira.card_id`/`jira.url` sull'idea (vedi skill
     `jira-sync`), così il record locale resta collegato a dove il lavoro
     viene davvero tracciato.
   - **Strategic Exception** — se il proponente è a un livello che nel
     `product/reference/` (o dichiarato dall'utente) qualifica per bypass
     del RICE. Crea comunque la cartella idea (serve comunque traccia),
     ma imposta `classification: strategic_exception` e aggiungi una voce
     a `strategic_exceptions` con `invoked_at_stage: intake` —
     `approved_by`/`reason` restano da confermare con l'utente, **non
     assumere l'approvazione**, chiedila esplicitamente.
   - **Mandate (iniziativa mandataria)** — se l'iniziativa è imposta
     dall'alto (leadership/board), marcata "critical" indipendentemente
     dai numeri, o vincolata a una scadenza esterna fissa (compliance,
     contratto, evento) — playbook, sezione "Iniziative Mandatarie". A
     differenza di bug/strategic exception, **non salta l'analisi**: va
     comunque in `in_analysis`/`in_prd` come un'idea normale, salta solo
     il RICE. Imposta `classification: mandate` e compila il blocco
     `mandate`: `mandated_by` e `rationale` **vanno sempre chiesti
     esplicitamente**, mai presunti dal ruolo o dal tono del mittente —
     non c'è un vincolo di ruolo su chi può dichiarare un mandate, per
     questo la disciplina nel chiedere conta di più, non di meno. Se
     emerge una `due_date`, chiedi anche una prima stima di
     `lead_time_weeks` (segnala che andrebbe validata con un referente
     tecnico appena possibile — se non disponibile subito, lascia `null`
     con una nota, non bloccare la creazione). Non compilare mai
     `analysis_start_by`/`escalation_status` — sono calcolati dalla
     skill `mandate-watch`, non a mano.
   - **Platform (debito tecnico/devops puro)** — non è un bug (non
     produce un output sbagliato) né un'idea di business: è manutenzione,
     upgrade, gestione del debito tecnico o attività devops che il team
     tech giudica necessaria (playbook, "flusso di protezione del team").
     Può arrivare sia dal team tech direttamente sia mediata dal PM —
     nessun vincolo su chi la propone. Imposta `classification: platform`
     e compila il blocco `platform`: `rationale` sempre chiesto
     esplicitamente (perché serve — rischio, manutenibilità, ecc.), non
     dedotto dal fatto che "viene dal team tech quindi ovviamente serve".
     Se emerge una stima di sforzo, chiedi `estimated_effort_weeks`
     (segnala che andrebbe validata dal team tech se chi la propone non
     lo è già) — serve al calcolo della capacità protetta in
     `roadmap-snapshot`, non a un RICE (che questa classification non ha
     mai). Come `mandate`, **non salta l'analisi**: le iniziative
     importanti seguono comunque `in_analysis`/`in_prd`; quelle piccole
     possono saltare direttamente a `in_jira`, a giudizio del team tech.
   - **Idea normale** — il caso di default.

4. **Determina titolo, proponente, Product Line** (per la singola unità
   che stai processando). Per convenzione, se il materiale è un'email,
   usa l'oggetto come titolo — se l'email è stata decomposta in più
   unità, aggiungi un breve suffisso che distingua i titoli tra loro. Se
   la Product Line non è ovvia, chiedi — non indovinare tra le opzioni in
   `product/reference/product-lines.yaml`. Se questa idea nasce da un
   riorientamento di Discovery confermato dalla skill `nsm-watch` (una
   NSM in degrado), chiedi se va collegata in `links.nsm_targeted` — non
   presumerlo solo perché il contesto della conversazione lo suggerisce.

5. **Genera lo slug e crea la cartella**
   `product/ideas/{YYYY-MM-DD}-{slug-descrittivo}/` (data odierna o data
   del materiale di origine, a scelta più sensata per il caso). Lo slug è
   un topic-slug leggibile (es. `ricevute-scontrino-solo-totale`), non un
   ID opaco. Una cartella per unità, anche se più unità condividono la
   stessa origine.

6. **Salva il materiale grezzo** in `source/` dentro la cartella (es.
   `source/email-originale.md`, `source/trascrizione.md`) — non
   parafrasarlo via, l'originale deve restare consultabile. **Se
   un'unica fonte ha generato più unità (idee/bug/ecc.), copia il
   materiale grezzo per intero in ognuna delle cartelle risultanti** —
   non spezzettarlo in estratti parziali: chi apre una cartella deve
   poter leggere il contesto completo senza dover risalire alle altre.
   In questo caso, aggiungi in cima al file copiato una riga tipo `<!--
   Questa fonte ha generato anche: {altri slug} -->` così chi la legge sa
   che esistono record collegati dalla stessa origine.

7. **Scrivi `idea.yaml`** a partire da
   `framework/schema/idea.template.yaml`, compilando i campi noti. **Non
   compilare `rice_history`** in questo passo — quello è compito della
   skill `rice-update`, con la sua propria approvazione. Lascialo vuoto
   (`[]`).

8. **Non serve passare da `product/approvals/pending/` per la creazione
   di una nuova idea** (a differenza degli aggiornamenti a idee/roadmap
   già esistenti): l'intake è la prima cattura, non ancora una decisione
   di priorità. Comunicalo comunque chiaramente all'utente e mostragli il
   contenuto creato — **se sono state create più unità dalla stessa
   fonte, elencale tutte insieme nel riepilogo finale**, non una alla
   volta senza collegarle — prima di considerare il passo concluso.

9. **Sincronizza il repo**: come ultimo passo, esegui
   `bash .claude/hooks/governance-sync.sh push "idea-intake: <slug>[, +N unità]" product/ideas/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se
   l'helper segnala un push fallito o un disallineamento, riferiscilo nel
   riepilogo — non ripetere le scritture.
