---
name: jira-sync
description: Push - crea/collega il ticket Jira per un'idea o PRD già prioritizzato e persiste l'ID; Pull - fa polling occasionale dello stato/commenti dei ticket già collegati. Nessun sync realtime, Jira resta l'unica fonte di verità per l'esecuzione.
---

# jira-sync

Gestisce il collegamento (non la duplicazione) tra le idee/PRD di
questa istanza e Jira, secondo il brief: "Jira: sistema di verità per
l'esecuzione, non duplicato. Nessun sync in tempo reale."

## Modalità Push (idea/PRD → Jira)

Da usare quando un'idea è stata prioritizzata ed è pronta a entrare nel
backlog di esecuzione (tipicamente dopo Backlog Refinement / Iteration
Planning).

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` (vedi playbook,
   "Sincronizzazione dell'istanza (`origin`)") — verifica che l'idea non
   sia già stata collegata a un ticket da un collega nel frattempo.
1. Verifica che l'idea abbia RICE approvato e, se serve un PRD per
   procedere, che esista in `product/prds/`.
2. Prepara il contenuto del ticket (titolo, descrizione sintetica, link
   al PRD e/o alla cartella idea nel repo — non copiare il contenuto
   integrale del PRD dentro Jira, linkalo).
3. Crea il ticket via integrazione Jira disponibile nell'ambiente (MCP
   tool o CLI, secondo cosa è configurato in questa istanza). Se non è
   disponibile alcuna integrazione, prepara comunque il testo pronto da
   incollare e chiedi all'utente di crearlo lui, poi chiedigli l'ID per
   completare il passo 4.
4. Scrivi `jira.card_id`, `jira.url`, `jira.last_polled_at` (= ora) in
   `product/ideas/{slug}/idea.yaml`. Questo campo NON passa dalla coda di
   approvazione (è un fatto — il ticket esiste o non esiste — non una
   proposta soggetta a revisione), ma segnalalo chiaramente all'utente.
5. Aggiorna `status` dell'idea a `in_jira`.
6. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "jira-sync: push <slug> -> <card_id>" product/ideas/{slug}`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)").

## Modalità Pull (Jira → stato locale)

Da usare periodicamente (non in tempo reale) per aggiornare lo stato
locale, tipicamente prima di generare uno `roadmap-snapshot`.

0. **Sincronizza da `origin`**: esegui
   `bash .claude/hooks/governance-sync.sh pull` prima di iniziare il
   polling, così non sovrascrivi con dati Jira uno stato locale già
   superato da un collega.
1. Per ogni idea con `jira.card_id` valorizzato, interroga stato e
   commenti recenti del ticket.
2. Aggiorna `jira.status` e `jira.last_polled_at`. Se lo stato Jira
   indica che il ticket è chiuso/in produzione, segnalalo esplicitamente
   — ma non decidere tu se questo significa "Done" secondo la Definition
   of Done dell'istanza (vedi playbook): riportalo, lascia la
   valutazione all'utente.
3. Questo aggiornamento è un fatto osservato (stato remoto), non una
   proposta: **non passa dalla coda di approvazione**. Se invece dal
   commento Jira emerge un'informazione che dovrebbe cambiare il RICE o
   la roadmap, quella è una proposta vera e propria — passala a
   `rice-update` o `roadmap-snapshot`, non applicarla qui direttamente.
4. Se molte idee sono collegate, fai il pull in batch e presenta un
   riepilogo unico invece di aggiornamenti sparsi uno per uno.
5. **Sincronizza il repo**: esegui
   `bash .claude/hooks/governance-sync.sh push "jira-sync: pull stato N idee" product/ideas/`
   (vedi playbook, "Sincronizzazione dell'istanza (`origin`)"). Se l'helper
   segnala un push fallito, riferiscilo nel riepilogo.
