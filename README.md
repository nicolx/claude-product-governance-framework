# Claude Product Governance Framework

Un framework per fare **Product Governance dentro Claude Code**, invece che
in un tool separato dal lavoro reale (Aha!, Jira-come-backlog-idee, ecc.).

L'idea di fondo: il Product Manager scrive comunque il PRD ogni giorno,
partendo da email e trascrizioni. Se quell'attività avviene già in Claude
Code, la governance (RICE, roadmap, tracciamento) può diventare un
**sottoprodotto automatico** di quel lavoro, invece che un compito separato
che nessuno mantiene. Il contesto completo del perché è nato questo
progetto è in [`examples/epassi-ita/docs/vision-brief.md`](examples/epassi-ita/docs/vision-brief.md).

## Due repository, non uno

Questo repository è il **framework astratto**: metodo (playbook) + motore
(skill Claude Code) + template di schema. **Non contiene mai dati reali di
un progetto** — nessuna idea, nessun PRD, nessun submodule applicativo.

Per usarlo su un progetto reale, si crea un'**istanza**: un fork di questo
repo, inizializzato con i dati specifici di quel progetto (chi sono i PM,
gli stakeholder, quali repository applicativi collegare, il progetto Jira).
Progetti scollegati tra loro (es. due prodotti diversi, due aziende diverse)
sono fork indipendenti dello stesso framework.

```
repo canonico (questo)  ──fork──▶  istanza progetto A  (dati reali A + submodule A)
                          ──fork──▶  istanza progetto B  (dati reali B + submodule B)
```

Ogni istanza può in seguito tirare giù aggiornamenti del metodo
dall'upstream (nuove skill, playbook raffinato) senza perdere i propri dati,
perché le due cose vivono in cartelle separate (vedi sotto).

## Come creare una nuova istanza

```bash
# 1. Fork del repo canonico su GitHub (bottone "Fork", non "clone" del canonico)
# 2. Clona il TUO fork
git clone <url-del-tuo-fork>
cd <cartella>

# 3. Bootstrap: attiva gli hook di protezione e il remote upstream
./bootstrap.sh

# 4. Apri Claude Code in questa cartella e lancia la skill di inizializzazione
#    (intervista: PM assegnati, stakeholder, repo applicativi, Jira, ecc.)
```

Usa la skill **`init-governance-project`** (vedi `.claude/skills/`).
Scrive `.governance/config.yaml` (il marker che segna l'istanza come
inizializzata) e scaffolda `apps/` e `product/`.

## Struttura di un'istanza (dopo l'inizializzazione)

```
/
├── bootstrap.sh, .githooks/, framework/     ← di proprietà upstream (framework)
├── .claude/skills/                          ← di proprietà upstream (framework)
├── .governance/config.yaml                  ← config/marker di QUESTA istanza
├── apps/                                    ← submodule dei repository applicativi
│   └── <nome-repo>/
└── product/                                 ← artefatti di Product Management di QUESTA istanza
    ├── inbox/                   ← raccoglitore universale, NON tracciato da git (.gitignore)
    │                              qualsiasi cosa arrivi a casaccio (email, thread, trascrizioni,
    │                              allegati, immagini) si butta qui; la skill inbox-triage la
    │                              analizza, classifica e smista, poi la svuota
    ├── ideas/{YYYY-MM-DD}-{slug}/
    │   ├── idea.yaml
    │   └── source/            (email, trascrizioni, allegati — arrivati via inbox-triage o diretti)
    ├── prds/{slug}/
    │   ├── prd.md              (o prd-1-*.md, prd-2-*.md se spaccato)
    │   └── source/
    ├── ceremonies/{tipo}/{settimana-o-data}/
    │   ├── source/             (trascrizione grezza della riunione)
    │   └── decisions.yaml      (esito strutturato, link a cosa ha impattato)
    ├── roadmap/snapshots/{YYYY-Www}.yaml
    ├── approvals/{pending,decided}/
    └── reference/
        ├── product-lines.yaml
        └── friction-log.yaml
```

**Il punto d'ingresso per il materiale grezzo non ordinato è
`product/inbox/`**: il PM ci butta dentro qualsiasi cosa arrivi (una
mail, un thread, la trascrizione di un workshop, immagini) senza doverla
pre-classificare. La skill **`inbox-triage`** la analizza e decide, per
ciascun elemento: nuova idea, aggiornamento di un'idea/PRD già
esistente, bug, Strategic Exception, o — se è troppo ambiguo — un'idea
con `status: needs_clarification` e una bozza di domanda pronta da
rispedire a chi l'ha mandato. Alla fine del run, `product/inbox/` resta
vuota: tutto quello che deve sopravvivere è già stato spostato in una
cartella tracciata.

`product/inbox/` è una comodità, **non un passaggio obbligato**: un PM
può sempre creare/modificare file sotto `product/ideas/` o
`product/prds/` direttamente (a mano, o chiedendo a `idea-intake`/
`prd-draft` di processare del materiale senza mai passare da lì).

`inbox-triage` è deliberatamente **garantista**: nel dubbio chiede,
invece di scrivere un record con dati inferiti o indovinati — un'idea
piena di errori fa lavorare il team su basi sbagliate, il che costa più
di una domanda in più (vedi il principio guida nella skill stessa).

Perché non si chiama tutto "governance": quella parola qui indica solo la
*configurazione* di come questa istanza è impostata, non il contenitore dei
dati. Il codice va in `apps/`, gli artefatti di prodotto in `product/` —
nomi che dicono cosa contengono.

**Regola non negoziabile:** nessuna skill scrive mai direttamente in
`product/ideas`, `product/prds` o `product/roadmap` senza passare prima da
`product/approvals/pending/`. L'automazione propone, un umano approva.
Vedi `CLAUDE.md` e il playbook per il dettaglio.

## Il metodo

Il playbook genericizzato è in
[`framework/playbook.md`](framework/playbook.md) — RICE, A3 Thinking sui
PRD, cerimonie, meccanismo di approvazione, gestione delle frizioni con gli
stakeholder. È la fonte normativa che ogni skill deve rispettare.

Per un esempio completo e realistico di come tutto questo si applica in un
caso vero (con tanto di narrativa passo-passo), vedi
[`examples/epassi-ita/`](examples/epassi-ita/) — la prima istanza per cui
questo framework è stato disegnato.

## Aggiornare un'istanza col metodo più recente

```bash
# dentro un'istanza già inizializzata
git fetch upstream
```

poi usa la skill **`sync-framework-updates`**, che fa il merge e spiega in
linguaggio PM cosa è cambiato nel metodo (non solo il diff grezzo).

## Protezione del repo canonico

Gli hook in `.githooks/` (attivati da `bootstrap.sh`) sono un livello di
allerta precoce: bloccano localmente i push verso il repo canonico e
avvisano se un'istanza non è ancora inizializzata. **Non sono la vera
protezione** — sono aggirabili (`--no-verify`, o non installandoli affatto).

La protezione reale va configurata lato server, sul repo canonico:

- Branch protection su `main`: nessun push diretto, solo Pull Request
- Review obbligatoria prima del merge
- (Opzionale) restrizione di chi può fare merge

Chi amministra il repo canonico su GitHub deve configurare questo
separatamente — non è qualcosa che un file in questo repository può
garantire da solo.

## Cosa NON fare in questo repo (canonico)

- Non creare cartelle `apps/` o `product/` qui: sono solo il risultato
  dell'inizializzazione di un'istanza (un fork), non appartengono al
  framework.
- Non aggiungere dati specifici di un progetto reale (idee, PRD, roadmap,
  stakeholder) — quelli vivono solo nei fork.
- Le uniche eccezioni sono i contenuti sotto `examples/`, che sono
  dichiaratamente un caso di studio, non dati operativi.
