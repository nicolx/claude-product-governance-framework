---
name: init-governance-project
description: Inizializza questo fork come istanza operativa del framework di Product Governance — intervista il PM, collega i repository applicativi come submodule, scaffolda apps/ e product/, scrive .governance/config.yaml. Da lanciare una sola volta, subito dopo bootstrap.sh.
---

# init-governance-project

Inizializza un fork del framework come istanza operativa per un progetto
reale. Va eseguita **una sola volta** per istanza, dopo che l'utente ha
già lanciato `./bootstrap.sh` (verifica che `origin` non sia il repo
canonico, attiva gli hook, aggiunge il remote `upstream`).

## Prerequisiti da verificare prima di iniziare

1. Controlla che `.governance/config.yaml` **non** esista già. Se esiste,
   ferma tutto e informa l'utente che questa istanza è già inizializzata —
   non sovrascrivere silenziosamente. Se l'utente vuole comunque
   rieseguire alcuni passaggi (es. aggiungere un submodule), fallo in modo
   mirato, non ripartendo da zero.
2. Controlla che `framework/canonical-remote.txt` non contenga più il
   placeholder `PLACEHOLDER-ORG`. Se lo contiene ancora, avvisa l'utente
   che il legame con l'upstream non è verificabile finché non viene
   aggiornato, ma procedi comunque con l'intervista se lo chiede
   esplicitamente.

## L'intervista

Conduci una conversazione naturale (non un questionario rigido a caselle)
per raccogliere:

1. **Nome del progetto/istanza** — usato in `.governance/config.yaml` e
   nel titolo del README locale.
2. **PM assegnati** — nome ed email di ciascuno. Se più PM, chiedi se
   presidiano Product Line diverse.
3. **Product Line** — nome, descrizione, North Star Metric + eventuali
   altri KPI, stakeholder di riferimento. Se l'utente ha già una tabella
   pronta (es. incollata da un documento), usala direttamente invece di
   richiederla campo per campo. Popola `product/reference/product-lines.yaml`
   a partire da `framework/schema/product-lines.template.yaml`. Per ogni
   Product Line, chiedi esplicitamente il denominatore Reach (valore,
   fonte, owner) — se l'utente non lo sa ancora, lascialo `null` con nota,
   **non inventarlo**: il playbook è esplicito che un Reach non
   formalizzato resta un'approssimazione.
4. **Repository applicativi da collegare** — per ciascuno: URL git,
   nome/slug con cui va montato sotto `apps/`. Per ognuno esegui:
   `git submodule add <url> apps/<slug>`. Se l'utente non ha ancora repo
   da collegare, salta questo passo e nota in `.governance/config.yaml`
   che va fatto in seguito (non bloccare l'inizializzazione per questo).
5. **Jira** (o altro tracker di esecuzione) — project key, URL board. Solo
   configurazione, nessun collegamento realtime va creato qui.
6. **Eventuali altre configurazioni rilevanti** — canale Slack/Teams per
   comunicazioni, link a strumenti di analytics (es. DataBricks), altro
   che l'utente ritenga utile avere a portata di mano nel config.

Non forzare un ordine rigido se l'utente fornisce più informazioni insieme
(es. incolla una trascrizione di un meeting di kickoff): estrai tutto ciò
che serve da lì e chiedi solo quello che manca.

## Cosa scrivere

1. `.governance/config.yaml` (crea la cartella `.governance/` se non
   esiste) con almeno: nome progetto, data di inizializzazione, PM
   roster, riferimento Jira, elenco submodule collegati, versione/commit
   del framework upstream al momento dell'init (`git rev-parse
   upstream/main` se disponibile, altrimenti `HEAD`).
2. `product/reference/product-lines.yaml` (da template).
3. `product/reference/friction-log.yaml` (da template, vuoto).
4. Scaffold vuoto: `product/ideas/`, `product/prds/`,
   `product/roadmap/snapshots/`, `product/ceremonies/`,
   `product/approvals/pending/`, `product/approvals/decided/` (con
   `.gitkeep` dove servono, git non traccia cartelle vuote).

## Dopo l'inizializzazione

- Fai un commit dedicato, es. `Initialize governance instance: <nome
  progetto>`.
- Riepiloga all'utente cosa è stato creato e cosa resta da fare (es.
  submodule non ancora collegati, denominatori Reach non ancora
  formalizzati).
- Ricorda che da questo momento in poi nessuna scrittura in `product/`
  deve avvenire senza passare da `product/approvals/pending/` — vedi
  `CLAUDE.md` e `framework/playbook.md`.
