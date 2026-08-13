---
name: log-ceremony
description: Registra una cerimonia collettiva (Backlog Refinement, Roadmap & Iteration Planning, ecc.) a partire dalla sua trascrizione grezza, producendo un record strutturato di decisioni collegato a idee/roadmap impattati. Usala dopo una riunione di team.
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

7. Mostra un riepilogo delle decisioni estratte all'utente prima di
   considerare il log completo — è più facile correggere un
   fraintendimento ora che scoprirlo settimane dopo in una revisione.
