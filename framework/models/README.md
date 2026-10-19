# Modelli di reporting standard

Modelli semplici con cui un'istanza trasforma i propri dati (Piano di
Iterazione, snapshot, idee, NSM, misurazioni) in viste per un pubblico.
Sono pensati per i **progetti nascenti**, che non hanno ancora un formato
aziendale da rispettare. Un'azienda strutturata trascrive invece i propri
formati in `product/reference/models/` (stessa struttura,
`framework/schema/report-model.template.md`).

Fonte normativa: playbook, "Modelli di reporting". Generazione: skill
`report-render`. Dichiarazione delle viste di un'istanza:
`product/reference/reporting-models.yaml`.

| Modello | Tipo | Pubblico tipico | Cadenza | Domanda a cui risponde |
|---|---|---|---|---|
| [`roadmap-di-lavoro`](roadmap-di-lavoro.md) | roadmap | team, owner di Product Line | a ogni cerimonia (`per_ceremony`) | Com'è la roadmap dopo l'ultima cerimonia — scadenze, RICE e perché ogni voce è dove è? |
| [`roadmap-now-next-later`](roadmap-now-next-later.md) | roadmap | stakeholder, leadership | mensile | Su cosa lavoriamo, cosa viene dopo (entro il trimestre, nella capacità del team), cosa è in coda? |
| [`roadmap-trimestrale`](roadmap-trimestrale.md) | roadmap | leadership (MBR/MTR) | trimestrale | Cosa arriva in quale mese, quali scadenze, quali rischi? |
| [`metriche-scorecard`](metriche-scorecard.md) | metrics | leadership, owner di Product Line | mensile | Il prodotto sta muovendo le metriche che contano? |
| [`aggiornamento-settimanale`](aggiornamento-settimanale.md) | update | stakeholder di business | settimanale | Cosa è cambiato questa settimana? |

Set minimo consigliato per un progetto nascente: `roadmap-di-lavoro`
(`cadence: per_ceremony`) + `metriche-scorecard`.

**La roadmap aggiornata a ogni cerimonia** è la vista con `cadence:
per_ceremony`, qualunque sia il suo modello: `log-ceremony` la rigenera
alla chiusura di ogni cerimonia e `pending-approval` a ogni approvazione
che tocca piano o RICE. `roadmap-di-lavoro` è il formato di partenza; se
l'istanza ha il proprio formato di roadmap, lo trascrive come modello
aziendale e gli dà quella cadenza — il meccanismo non cambia.

Questi file sono di proprietà del framework: un'istanza non li modifica.
Per adattarne uno, si crea un modello aziendale con
`extends: framework:<id>` in `product/reference/models/` e lo si
dichiara come `company:<id>`.
