---
name: idea-intake
description: Trasforma materiale grezzo (email, trascrizione, segnalazione) in una nuova idea strutturata in product/ideas/, classificandola come idea/bug/strategic exception secondo il playbook. Usala quando l'utente allega o incolla materiale nuovo da valutare.
---

# idea-intake

Trasforma materiale grezzo — email, trascrizione di riunione, messaggio,
segnalazione — in un'idea strutturata, secondo il playbook (sezione
"Alimentazione del bucket delle idee").

## Prerequisiti

Richiede un'istanza inizializzata (`.governance/config.yaml` presente e
`product/reference/product-lines.yaml` popolato). Se mancano, ferma e
indirizza a `init-governance-project`.

## Passi

1. **Leggi il materiale grezzo** fornito dall'utente (allegato, testo
   incollato, o riferimento a un file).

2. **Classifica** prima di tutto secondo il playbook:
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
     ma imposta `classification: strategic_exception` e lascia
     `strategic_exception.approved_by`/`reason` da confermare con
     l'utente — **non assumere l'approvazione**, chiedila esplicitamente.
   - **Idea normale** — il caso di default.

3. **Determina titolo, proponente, Product Line.** Per convenzione, se il
   materiale è un'email, usa l'oggetto come titolo. Se la Product Line non
   è ovvia, chiedi — non indovinare tra le opzioni in
   `product/reference/product-lines.yaml`.

4. **Genera lo slug e crea la cartella**
   `product/ideas/{YYYY-MM-DD}-{slug-descrittivo}/` (data odierna o data
   del materiale di origine, a scelta più sensata per il caso). Lo slug è
   un topic-slug leggibile (es. `ricevute-scontrino-solo-totale`), non un
   ID opaco.

5. **Salva il materiale grezzo** in `source/` dentro la cartella (es.
   `source/email-originale.md`, `source/trascrizione.md`) — non
   parafrasarlo via, l'originale deve restare consultabile.

6. **Scrivi `idea.yaml`** a partire da
   `framework/schema/idea.template.yaml`, compilando i campi noti. **Non
   compilare `rice_history`** in questo passo — quello è compito della
   skill `rice-update`, con la sua propria approvazione. Lascialo vuoto
   (`[]`).

7. **Non serve passare da `product/approvals/pending/` per la creazione
   di una nuova idea** (a differenza degli aggiornamenti a idee/roadmap
   già esistenti): l'intake è la prima cattura, non ancora una decisione
   di priorità. Comunicalo comunque chiaramente all'utente e mostragli il
   contenuto creato prima di considerare il passo concluso.

8. Se dal materiale emergono **più idee distinte** (es. una trascrizione
   di riunione che tocca temi diversi), crea più cartelle separate invece
   di forzarle in una sola — ognuna deve restare giudicabile
   singolarmente in fase di prioritizzazione.
