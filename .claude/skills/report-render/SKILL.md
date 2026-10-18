---
name: report-render
description: Genera le viste per gli stakeholder (roadmap Now/Next/Later o trimestrale, scorecard delle metriche, aggiornamento settimanale, o un formato aziendale trascritto) a partire dai modelli di reporting dichiarati in product/reference/reporting-models.yaml. Scrive il report derivato in product/reports/ e, per un pubblico fuori dal team, prepara la comunicazione in product/approvals/pending/ (outbound_comm) — non pubblica né invia mai nulla. In modalità setup aggiunge, modifica o rimuove una vista, o trascrive un modello aziendale (slide, pagina Confluence, foglio) mappandone i campi sui dati del framework. Usala dopo l'approvazione di Piano di Iterazione/snapshot, quando un report è in scadenza, o per configurare i modelli.
---

# report-render

Trasforma i dati già decisi dell'istanza in **viste per un pubblico**,
secondo un modello di reporting. Fonte normativa: playbook, "Modelli di
reporting" — leggila prima di generare.

Due modalità:

- **render** (default) — genera una o più viste dichiarate.
- **setup** — crea `product/reference/reporting-models.yaml` se manca,
  aggiunge/modifica/rimuove una vista, trascrive un modello aziendale.

> **Dry-run.** Se invocata in simulazione (argomento `dry-run`, o
> `dry_run: true` in `.governance/config.yaml`), applica il contratto
> della sezione "Modalità dry-run (simulazione)" del playbook: leggi e
> componi normalmente, **non** scrivere in `product/` (né report, né
> proposte, né `reporting-models.yaml`, né modelli aziendali), **non**
> invocare `governance-sync.sh push`, mostra come testo ciò che avresti
> scritto, e chiudi con `🔍 DRY-RUN — nessun file scritto, nessun commit,
> nessun push.`

## Modalità render

0. **Sincronizza e leggi in blocco**: `bash
   .claude/hooks/governance-sync.sh pull` (fermati e riferisci se segnala
   un non-fast-forward), poi `bash .claude/hooks/governance-dump.sh
   reports` — viste dichiarate, ultimi report generati, idee, piani,
   ultimo snapshot, misurazioni, NSM in una tool call.

1. **Quali viste.** Se l'utente ne nomina una (per `name`), quella. Se
   dice "quelle in scadenza", le viste con `cadence` diversa da
   `on_demand` il cui ultimo report in `product/reports/<name>/` copre un
   periodo precedente a quello corrente (o che non hanno ancora un
   report). Se `reporting-models.yaml` non esiste, **non inventare
   viste**: proponi di passare alla modalità setup.

2. **Carica il modello** di ciascuna vista:
   - `framework:<id>` → `framework/models/<id>.md`;
   - `company:<id>` → `product/reference/models/<id>.md` (se ha
     `extends: framework:<id>`, leggi anche il modello di base: il modello
     aziendale ne sovrascrive solo ciò che dichiara).
   Unisci le `options`: quelle della vista vincono su quelle del modello.
   Se il file del modello non esiste, fermati su quella vista e dillo.

3. **Verifica la freschezza delle fonti** prima di comporre, con le
   soglie del modello. Tipicamente: ultimo Piano di Iterazione approvato,
   ultimo snapshot approvato, data dell'ultima lettura di ogni NSM/KPI. Se
   una fonte è vecchia, **dillo e chiedi** se procedere o aggiornare
   prima (`roadmap-snapshot`, `nsm-watch`, `measurement-watch`) — mai un
   report che sembra aggiornato e non lo è. Le proposte ancora in
   `pending/` **non** sono fonti: si usa solo ciò che è approvato.

4. **Componi** seguendo lo `Scheletro` e le `Regole di composizione` del
   modello, campo per campo secondo `fields`, applicando
   `filters.product_lines`. Per ogni voce in `gaps`:
   - `ask_pm` → chiedi il valore al PM in conversazione; se non lo dà,
     scrivi "da compilare" in modo visibile;
   - `leave_blank` → "da compilare" visibile;
   - `omit` → togli il campo.
   Mai un valore stimato o dedotto per riempire una lacuna. Ogni elenco
   porta l'identificatore in prima colonna (`short_ref` o slug — playbook,
   "Ogni elenco prodotto dal sistema è indirizzabile").

5. **Scrivi il report** in `product/reports/<name>/<periodo>.md`
   (`periodo` nel `period_format` del modello). In testa, un blocco di
   provenienza:

   ```markdown
   <!-- report-render · vista: <name> · modello: <model> · generato: <data>
        fonti: <path del piano/snapshot usati> · NON modificare a mano:
        correggi la fonte e rigenera -->
   ```

   Se il file del periodo esiste già, rigeneralo (è derivato): mostra al
   PM cosa cambia rispetto alla versione precedente prima di
   sovrascrivere.

6. **Distribuzione.** Se `audience` è `team`, fermati qui: il report è
   interno. Altrimenti prepara una proposta
   `product/approvals/pending/{data}-report-<name>-<periodo>.yaml`
   (`framework/schema/approval.template.yaml`, `type: outbound_comm`,
   `proposed_by: report-render`, `target_file: null`) con `payload`:
   `report_ref` (il path del report), `recipients`, `destination`,
   `subject` e il corpo pronto all'invio/pubblicazione. Il framework
   **non pubblica né invia**: dopo l'approvazione è il PM a mandare la
   mail o aggiornare la pagina/il deck.

7. Mostra il report (o un estratto, se lungo), le lacune rimaste "da
   compilare" e le proposte create.

8. **Sincronizza il repo**:
   `bash .claude/hooks/governance-sync.sh push "report-render: <viste> <periodo>" product/reports/ product/approvals/pending/`.
   Se l'helper segnala un push fallito, riferiscilo.

## Modalità setup

Riusa le domande del passo "Modelli di reporting" di
`init-governance-project` — è lo stesso dialogo, per un'istanza già
inizializzata o per aggiungere viste dopo.

- **Nessun `reporting-models.yaml`**: chiedi se l'azienda ha già formati
  propri. Se no, proponi il set minimo standard (`roadmap-now-next-later`
  + `metriche-scorecard`, catalogo in `framework/models/README.md`) e
  chiedi per ciascuna vista pubblico, destinatari, cadenza, destinazione,
  Product Line. Crea il file da
  `framework/schema/reporting-models.template.yaml` **solo su conferma
  del PM** della lista finale.
- **Aggiungi / modifica / rimuovi una vista**: scrittura diretta su
  conferma. Rimuovere una vista non cancella i report già in
  `product/reports/<name>/` (sono storico).
- **Trascrivi un modello aziendale.** Il PM fornisce il formato che
  l'azienda usa (file droppato, link a una pagina o a una cartella di un
  connettore dichiarato, o una descrizione):
  1. leggilo (se è un file droppato, trattalo come in `context-intake`:
     non resta nel repo dopo la trascrizione; se è un link, va in
     `original_ref`);
  2. scrivi `product/reference/models/<id>.md` da
     `framework/schema/report-model.template.md`, `origin: company`,
     con lo `Scheletro` che riproduce **sezioni e ordine** del formato
     aziendale (non lo stile grafico);
  3. **mappa ogni campo** su un dato del framework (`fields`). I campi che
     il framework non tiene vanno in `gaps` con la gestione scelta dal
     PM — chiedila, non presumerla. Mostra la mappatura completa al PM
     prima di scrivere;
  4. se il formato aziendale è un modello standard con varianti, usa
     `extends: framework:<id>` e dichiara solo le differenze;
  5. dichiara la vista che lo usa (`model: company:<id>`).
  Se più di un terzo dei campi finisce in `gaps`, dillo: il formato
  chiede dati che il processo non produce, ed è una conversazione da
  fare con chi lo ha imposto, non un buco da tappare a ogni report.

Chiudi con `governance-sync.sh push "report-render: setup <cosa>" product/reference/`.

## Cosa non fa

- Non modifica idee, piani, snapshot o metriche: se un report è
  sbagliato, si corregge la fonte (con la skill che la possiede) e si
  rigenera.
- Non legge le metriche dalla fonte di produzione: usa le letture
  registrate da `nsm-watch`/`measurement-watch`.
- Non produce file nel formato grafico aziendale (.pptx, pagina
  Confluence impaginata): produce il contenuto strutturato, nell'ordine
  del modello, pronto da incollare. Vedi `framework/docs/future-work.md`.
