---
# Template di un MODELLO DI REPORTING — la forma con cui un dato del
# framework diventa una vista per un pubblico (roadmap, metriche,
# aggiornamento). Vedi playbook, "Modelli di reporting".
#
# Due usi, stessa struttura:
# - i modelli standard del framework (framework/models/*.md) — semplici,
#   pensati per i progetti nascenti che non hanno ancora un formato;
# - i modelli AZIENDALI di un'istanza (product/reference/models/*.md) —
#   la trascrizione di un formato che l'azienda già usa (slide di MBR,
#   pagina Confluence, foglio di roadmap), con la mappatura di ogni suo
#   campo su un dato del framework.
#
# Un modello è un CONTRATTO DI PRESENTAZIONE, non una fonte di dati: ogni
# campo deve puntare a un dato che il framework già tiene (sources /
# fields), oppure essere dichiarato come lacuna (gaps). Mai un campo
# "riempito a mano nel report": se il report è sbagliato si corregge la
# fonte e si rigenera.

id: ""                      # slug stabile, uguale al nome file (senza .md)
kind: roadmap               # roadmap | metrics | update
title: ""                   # nome leggibile del modello
origin: framework           # framework | company
original_ref: null          # SOLO company: dove vive il formato originale (URL Confluence/Drive, nome del deck) — il file grezzo NON si copia nel repo
extends: null               # SOLO company, opzionale: "framework:<id>" se il modello aziendale è un modello standard con varianti
audience_default: ""        # per chi è pensato (es. "leadership", "stakeholder di business", "team")
cadence_default: monthly    # per_ceremony | weekly | monthly | quarterly | on_demand — per_ceremony = rigenerata in automatico a fine di ogni cerimonia (playbook, "Modelli di reporting", "La roadmap si aggiorna da sola")
period_format: "YYYY-MM"    # come si chiama il periodo del report: "YYYY-Www" | "YYYY-MM" | "YYYY-Qn"
horizon: ""                 # cosa copre nel tempo (es. "trimestre corrente + successivo")

# Opzioni che un'istanza può sovrascrivere per singola vista dichiarata
# (product/reference/reporting-models.yaml, campo options).
options: {}

# Dati del framework che il modello legge. Path relativi alla radice
# dell'istanza. report-render li legge con governance-dump.sh reports.
sources: []
#  - "product/roadmap/iterations/{settimana}.yaml"

# Mappatura campo → fonte. Una voce per ogni elemento variabile dello
# scheletro sotto. `rule` dice come si calcola, se non è una copia.
fields: []
#  - field: "Now"
#    source: "iterations: in_development + urgent_priority"
#    rule: "raggruppato per product_line"
#  - field: "Rilascio previsto"
#    source: "slot_plan.slots dell'ultimo snapshot approvato (end_week)"
#    rule: "trimestre in cui cade end_week, marcato 'stima'; senza slot: motivo da slot_plan.unslotted"
#
# Tempi e capacità si mappano SOLO su slot_plan / capacity_allocation
# dello snapshot (playbook, "Capacità del team e slot della roadmap"):
# mai date scritte a mano, mai carico o utilizzo per persona — al più per
# competenza o per squad. Vedi report-render, modalità setup, punto 6.

# Campi del formato che il framework NON tiene (tipico dei modelli
# aziendali: "budget speso", "owner commerciale", "RAG status di
# progetto"). Al render report-render li chiede al PM o li lascia
# visibilmente vuoti — non li inventa mai.
gaps: []
#  - field: ""
#    handling: ask_pm         # ask_pm | leave_blank | omit
#    note: ""
---

# {title}

## Scopo

A chi serve, quale domanda risolve, quale decisione aiuta a prendere.

## Scheletro

Il documento come deve uscire, con i segnaposto `{campo}` che
corrispondono a `fields`/`gaps`.

## Regole di composizione

Cosa includere e cosa escludere, ordinamenti, soglie, cosa fare quando un
dato manca. Le regole valgono per ogni rendering: due run sugli stessi
dati danno lo stesso documento.
