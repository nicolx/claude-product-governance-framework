---
# Template per product/prds/{slug}/README.md — il BRIEF D'INIZIATIVA.
#
# Il documento da leggere per primo, per chiunque (stakeholder, design,
# sviluppo, persone o agenti), che racconta la storia dell'iniziativa UNA
# SOLA VOLTA. I PRD restano A3 perché il contesto sta qui: ogni PRD della
# cartella lo dichiara in brief_ref e lo richiama invece di riscriverlo.
# Playbook, "Scrivere per il lettore: dalla fonte all'artefatto".
#
# Obbligatorio quando l'iniziativa ha più di un PRD, oppure quando un PRD ha
# primary_reader diverso da stakeholder/pm. Facoltativo altrimenti.
#
# Vincolo dimensionale: come un PRD, ~2 facciate A4 (le tabelle aiutano).
#
# Portabilità (P7): deve reggersi senza la sessione che l'ha scritto, senza la
# memoria dell'agente, senza accesso al repository. Nel corpo niente percorsi
# locali, niente rimandi a context/*.md (i fatti si RIPORTANO in sintesi),
# niente id interni non spiegati (PG-…, ticket): se servono, si spiegano a
# parole e l'id va tra parentesi o nella riga finale "Materiale di origine".
#
# Il RICE non si ripete qui (resta nell'idea). idea.yaml resta il registro;
# questo è la versione leggibile.
idea_id: ""
owner: ""
stage: preliminary        # preliminary (scritto in Preliminary analysis) | complete (Complete analysis)
key_points_ref: ""        # percorso relativo al registro dei punti chiave, se esiste
created_at: ""
updated_at: ""
---

# {Titolo dell'iniziativa}: il brief

*Il documento da leggere per primo, per chiunque. Si legge in 5 minuti e non richiede di
aver partecipato a nessuna riunione. Responsabile: {owner}.*

## La storia in un minuto

<!-- Il problema raccontato dal punto di vista delle persone coinvolte, con un caso
     concreto. Prosa, non bullet. Chi non sa nulla deve capire perché questa cosa conta.
     Se il caso concreto viene da un esempio della fonte, è "illustrativo": va benissimo
     qui, purché marcato come tale dove contiene numeri. -->

## Chi è coinvolto e in quale momento

<!-- Tabella: Chi | Momento | Cosa deve succedere dopo.
     Includi gli attori INDIRETTI: chi va convinto senza usare il prodotto (es. un
     direttore finanziario), chi riceve l'output, chi paga, chi non è ancora cliente. -->

## Come produce valore

<!-- La catena causale fino alla NSM / metrica di business, una riga per anello. -->

## Da dove partiamo

<!-- Cosa esiste già (prototipi, mockup, iniziative collegate, precedenti), detto a
     parole. Per i materiali visivi: copiali in assets/ accanto al brief, non linkarli
     a percorsi che il lettore non vede. -->

## Esempi (illustrativi)

<!-- Esempi concreti, marcati come illustrativi, coerenti con l'eventuale allegato dati.
     Sono materiale per chi progetta e scrive, NON stime. -->

## Cosa sappiamo, cosa ipotizziamo, cosa non sappiamo

<!-- Tre liste brevi. Fatti verificati / ipotesi / domande aperte (anche legali). -->

## Cosa chiediamo, a chi, e quando

<!-- Tabella: A chi | Cosa | Quando. Senza questa sezione uno stakeholder non sa cosa
     gli si chiede e non dà il suo appoggio. Le date non note si scrivono "da definire"
     (azione aperta), non si inventano. -->

## Vincoli che valgono per tutto

<!-- Vincoli trasversali (legali, di brand, tecnici) in linguaggio comprensibile a un non
     specialista: cosa non si può fare e perché, in una riga ciascuno. -->

## Parole che usiamo

<!-- Termini di dominio e sigle che il lettore potrebbe non conoscere (compresi PoC, v0/v1,
     sigle di ruolo). Allineati al glossario dell'istanza (product/reference/glossary.yaml),
     ma riportati qui: il lettore del brief non apre il glossario. -->

## Mappa dei documenti

<!-- Tabella: Ordine | Documento | Per chi (primary_reader) | Cosa decide o abilita | Fase.
     Spiega in una riga cosa significano le colonne. Includi allegati e assets. -->

---
*Materiale di origine (per chi ha accesso al repository di governance): {percorso della
fonte e del registro dei punti chiave}.*
