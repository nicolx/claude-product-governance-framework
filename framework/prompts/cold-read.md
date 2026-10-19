# Prompt · Lettura a freddo (cold read)

Usato da `prd-draft` (playbook, "Scrivere per il lettore: dalla fonte all'artefatto",
sottosezione "Lettura a freddo"). Chiede "si capisce?"; il passo successivo, "regge?", è
il panel di revisione (`review-panel.md`). Un subagent a **contesto vergine** impersona un lettore e
riceve **solo** i documenti destinati a quel lettore. Serve a far emergere quello che
l'autore non vede, perché ha in testa il contesto: lacune, fraintendimenti, rimandi a
materiale che il lettore non ha, numeri incoerenti, decisioni non ancora prese.

## Come si usa

1. **Prepara un pacchetto isolato.** Copia in una cartella temporanea fuori dal repository
   (lo scratchpad della sessione) i documenti del lettore, **senza frontmatter**, più
   `assets/` se il lettore è `design`. Il lettore non deve poter "barare" leggendo idea,
   registro o `context/`.
2. **Scegli i ruoli.** Almeno il `primary_reader` di ciascun PRD. Per un'iniziativa con
   brief e più PRD, questa combinazione è risultata la più efficace:

   | Ruolo simulato | Riceve | Trova soprattutto |
   |---|---|---|
   | stakeholder | solo il brief | problemi di **sostanza**: liceità, termine di paragone dei numeri, cosa gli si chiede, quick win |
   | design | brief + PRD di esperienza + allegato + `assets/` | problemi di **esperienza**: cosa imitare, confini, gerarchia |
   | tech | brief + PRD di esperienza + PRD di costruzione + allegato | problemi **numerici** (ricalcola) e di specifica |
   | legal_finance | brief + PRD del modello | claim non difendibili, ipotesi non dichiarate |

3. **Lancia i ruoli in parallelo** (tool Agent, `general-purpose`), con il testo qui sotto.
   Sostituisci `{RUOLO}`, `{PERCORSI}` e la sezione 3 secondo il ruolo.
4. **Confronta** le risposte con il registro dei punti chiave e con l'intento del PM, e
   classifica ogni rilievo:
   - **lacuna**: un punto `problem`/`scenario`/`actor`/`constraint` che non è arrivato;
   - **fraintendimento**;
   - **incoerenza** (numeri, testi tra documenti);
   - **decisione del PM**: una domanda che solo il PM può chiudere (es. termine di paragone,
     scope, date). **Va portata al PM prima della seconda iterazione**, non risolta
     dall'autore;
   - **ipotesi accettabile**: il lettore la può fare da solo; si dichiara e basta.
5. **Correggi, poi esegui la seconda iterazione** (al massimo 2). Se alla seconda restano
   domande bloccanti su `problem` o `scenario`, è un problema di contenuto: si dice al PM.
6. **Registra** l'esito in `product/prds/{slug}/.reviews/cold-read-{YYYY-MM-DD}-iterazione-{N}.md`:
   chi ha letto cosa, cosa ha capito, la tabella lacune → correzioni, le domande residue
   accettate e le azioni aperte del PM.

## Testo del prompt

```
Sei {RUOLO, descritto come una persona: es. "un product designer senior a cui è stato
assegnato il design di una demo"}. Ricevi questi documenti e nient'altro: non hai partecipato
a nessuna riunione e non conosci il progetto né l'azienda.

Leggi SOLO questi file, in quest'ordine: {PERCORSI}. Non leggere nessun altro file, non
cercare altro contesto, non usare altri strumenti oltre alla lettura di quei file
{solo per il ruolo tech: ", salvo un interprete da riga di comando per rifare i calcoli"}.

Rispondi in italiano, senza preamboli:
1. Il problema e l'obiettivo, con parole tue (3-4 righe).
2. Chi è coinvolto, in quale momento, e cosa deve succedere dopo.
3. {Secondo il ruolo:
   - stakeholder: "Cosa ti viene chiesto di sostenere o decidere, e cosa faresti dopo
     averlo letto."
   - design: "COSA PRODURRESTI: l'elenco delle schermate, con contenuto principale,
     gerarchia e interazioni, come se dovessi iniziare domani."
   - tech: "COSA PRODURRESTI: struttura, componenti, dati con i tipi essenziali, logica di
     calcolo in pseudo-codice. Poi RICALCOLA tutti i numeri dichiarati e dimmi quali
     tornano e quali no."
   - legal_finance: "Quali affermazioni non sono difendibili così come sono scritte, e
     perché."}
4. Le domande che faresti prima di procedere, ordinate per importanza, separando le
   BLOCCANTI da quelle che risolveresti con un'ipotesi (dichiara l'ipotesi).
5. Termini, numeri o passaggi che non hai capito o che sono incoerenti tra i documenti.
6. Cosa manca per lavorare senza tornare a chiedere. In una riga: potresti iniziare domani?

Sii onesto e critico: il tuo compito è trovare dove i documenti non si reggono da soli.
```

## Fallback

Se l'ambiente non permette subagent, la skill lo dice e propone al PM una lettura a freddo
umana: si mandano gli stessi documenti a una persona del ruolo, con le stesse sei domande.
**Mai saltata in silenzio.** In dry-run la lettura si esegue, ma `.reviews/` non si scrive.
