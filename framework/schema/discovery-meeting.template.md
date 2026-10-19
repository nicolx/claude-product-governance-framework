---
# Template per product/ideas/{slug}/discovery/{YYYY-MM-DD}-{interlocutore}.md —
# la GUIDA DI UN INCONTRO DI DISCOVERY.
#
# È lo strumento del PM (o di chi conduce) per l'incontro: cosa vogliamo
# decidere, cosa sappiamo già (per non chiederlo), le domande in ordine con la
# loro scala socratica, le ipotesi da mettere alla prova, come chiudere. Dopo
# l'incontro, la sezione "Esito" la compila discovery-questions in modalità
# recepisci. Playbook, "Discovery socratica: le domande agli stakeholder".
#
# Il registro (discovery/questions.yaml) resta la fonte strutturata: qui le
# domande si richiamano per id (DQ-..) e si riportano in forma parlata.
#
# Si regge da sola (P7): un altro PM deve poter condurre l'incontro leggendo
# solo questa guida. Nessun contenuto del rapporto individuale
# (.governance/stakeholder-relationships.local.yaml) entra mai qui: il file è
# tracciato. La calibrazione si mostra solo in conversazione.
idea_id: ""
meeting_id: "M-01"
with: []                 # id identikit o "Nome — ruolo"
phase: preliminary       # deep_dive | preliminary | complete | prd_review | measurement
planned_for: null
duration_minutes: 30     # una guida per 30 minuti ha 5-7 domande, non 20
prepared_at: ""
status: prepared         # prepared | held | ingested | cancelled
---

# {Titolo dell'iniziativa}: incontro con {interlocutore}

## Cosa deve rendere possibile

<!-- Una frase: la decisione che dopo l'incontro si potrà prendere (procedere o
     abortire, il Reach del RICE, lo scope del PoC, chi va convinto…). Se l'incontro
     non serve a una decisione, non serve. -->

## Cosa sappiamo già (non chiederlo)

<!-- Tre-cinque righe: ciò che è documentato (fonte, contesto, codice, risposte di
     incontri precedenti). Chiederlo di nuovo costa fiducia. Se serve confermarlo,
     dillo come conferma ("ho capito che…, è corretto?"), non come domanda aperta. -->

## Apertura: lascia raccontare

<!-- Una domanda larga e aperta, sul passato e sul suo punto di vista, prima di
     qualunque domanda mirata (maieutica: l'interlocutore arriva da solo al problema).
     Es. "Mi racconti l'ultima volta che questo problema le è costato qualcosa?" -->

## Le domande

<!-- In ordine, dalla più bloccante. Per ciascuna:

### DQ-03 · {gap in breve} · {famiglia socratica} · {blocking|important|nice}
**Domanda.** "…" (aperta, nel suo linguaggio, senza suggerire la risposta)
**Perché conta.** Cosa cambia a seconda della risposta (artefatto, decisione).
**Se risponde…** la scala:
- con un'opinione o un "tutti/sempre" → "Mi fa un esempio recente? Chi c'era?"
- con un numero detto a voce → "Da dove viene? Chi lo misura?" (resta una stima)
- …
**Evita.** La formulazione che suggerirebbe la risposta (es. "Non pensa che…?").
-->

## Ipotesi da mettere alla prova

<!-- Le ipotesi del brief/RICE che questo interlocutore può confermare o smentire.
     Per ciascuna: l'ipotesi, cosa dovrebbe essere vero SE regge (conseguenza
     osservabile), la domanda che la verifica. Se emerge una contraddizione, si
     mostra con rispetto ("prima diceva X, ora Y: come stanno insieme?") — lo scopo è
     capire, non vincere. -->

## Chiusura

- **Riformula** in tre righe cosa hai capito e chiedi se è corretto (teach-back).
- **Chi altro** dovremmo sentire? Chi la vede diversamente?
- **Cosa non ho chiesto** che avrei dovuto chiedere?
- **Prossimo passo** concordato (cosa, chi, entro quando) — nessuna promessa su date di
  rilascio o priorità.

## Invito e pre-read (se serve)

<!-- Bozza che il PM manda a mano, calibrata sul destinatario: tre blocchi A / Oggetto /
     Testo, testo semplice (playbook, "Testi che il PM manda a mano"). Contiene lo
     scopo e i 2-3 temi, NON la scala socratica né le ipotesi da mettere alla prova.
     invite_status sul registro. Assente se l'incontro è già fissato e non serve
     nulla. -->

---

## Esito (compilato dopo l'incontro)

<!-- Scritto da discovery-questions in modalità recepisci, da trascrizione/appunti in
     source/ (riferimento) o da quanto dichiarato dal PM:
     - per ogni DQ: answered / partially_answered / non posta, sintesi, tipo
       d'informazione;
     - domande nuove nate dall'incontro;
     - contraddizioni o sorprese rispetto al brief;
     - dove è stata propagata ogni risposta (punti chiave, brief, PRD, proposta
       RICE in coda, scadenza, glossario);
     - prossimo incontro suggerito, con chi e su cosa. -->
