---
name: test-accounts
description: Crea e fa evolvere il registro degli ambienti (dev, stg, prod, preview) e degli utenti di prova dell'istanza (product/reference/test-environments.yaml), con le credenziali tenute fuori da git (file locale non tracciato, Portachiavi o password manager — nel registro solo il riferimento). Registra un utente appena creato, collega credenziali nuove trovate nel file locale, attiva gli utenti richiesti (wanted) quando qualcuno li crea, verifica con un login vero che funzionino, ruota e ritira. Da qui in poi app-test e demo-capture sanno usarli. Usala quando nasce, cambia o si rompe un utente di prova, o quando l'hook di sessione segnala credenziali nuove.
---

# test-accounts

Il framework naviga le applicazioni dell'istanza con **utenti di prova**
per testare, fare debug, riprodurre un bug, verificare una consegna e
fare screenshot (`app-test`, `demo-capture`). Per farlo deve sapere quali
ambienti esistono, quali utenti ci sono su ciascuno, a cosa servono e
dove stanno le loro credenziali. Questa skill tiene quel registro.

Fonte normativa: playbook, "Ambienti e utenti di prova". Leggila prima di
modificare il registro.

## Due posti, mai confusi

| Cosa | Dove | Tracciato |
|---|---|---|
| Ambienti, utenti, persona, ruoli, stato, **riferimento** alle credenziali | `product/reference/test-environments.yaml` (da `framework/schema/test-environments.template.yaml`) | sì |
| Il **valore** delle credenziali | `.governance/test-credentials.local.env` (riferimenti `local:`), variabili d'ambiente (`env:`), Portachiavi macOS (`keychain:`), 1Password (`op://`) | **mai** |

L'helper `.claude/hooks/test-credentials.sh` è l'unico ponte: `check`
dice se un riferimento si risolve su questo clone senza stampare nulla,
`resolve` restituisce il valore al momento del login, `status` fa il
quadro, `init-local` crea il file locale con permessi 600.

## Prerequisiti

- Istanza inizializzata (`.governance/config.yaml` presente).
- Per la verifica con login (modalità `verify`): un driver browser
  dichiarato nel blocco `browser:` della config (tipicamente
  `claude-in-chrome`), verificato come ogni connettore (playbook,
  "Connettori esterni").

## Modalità

- **setup** — primo popolamento, se `init-governance-project` non l'ha
  fatto o ha lasciato `accounts: []`.
- **add** — un utente nuovo (appena creato da qualcuno, o già esistente
  e mai registrato).
- **activate** — un utente `wanted` è stato creato: si collegano le
  credenziali e passa a `active`.
- **adopt** — l'hook di sessione ha segnalato chiavi nel file locale non
  citate da nessun utente: si chiede al PM a chi appartengono.
- **verify** — login vero di uno o più utenti, aggiorna `status` e
  `last_verified_at`.
- **rotate** — la password è cambiata: si aggiorna il valore nell'archivio
  (non nel registro, che ha solo il riferimento) e si verifica.
- **retire** — l'utente non serve più: `status: retired`, resta come
  storico.

Se l'utente non dice quale, deducila dalla richiesta o dal messaggio
dell'hook; nel dubbio chiedi.

## Passi

> **Dry-run.** In simulazione (argomento `dry-run`, o `dry_run: true` in
> `.governance/config.yaml`) applica il contratto della sezione
> "Modalità dry-run (simulazione)" del playbook: leggi, verifica con
> `check` (e con un login, se richiesto), mostra il diff del registro
> che scriveresti, ma **non** scrivere `test-environments.yaml`, **non**
> toccare l'archivio delle credenziali e **non** fare push. Chiudi con
> `🔍 DRY-RUN — nessun file tracciato scritto, nessun commit, nessun push.`

0. **Sincronizza da `origin`**: `bash .claude/hooks/governance-sync.sh pull`.

1. **Fai il quadro**: `bash .claude/hooks/test-credentials.sh status`.
   Mostra al PM quali utenti hanno credenziali pronte su questo clone,
   quali mancano, quali `wanted` sono diventati risolvibili, quali chiavi
   locali sono orfane. Se il registro non esiste, crealo da
   `framework/schema/test-environments.template.yaml` (modalità setup).

2. **Ambienti** (setup, o quando un utente cita un ambiente che non c'è).
   Per ogni app di `apps[]` in `.governance/config.yaml` chiedi quali
   livelli esistono (dev, stg, prod, preview per-PR…) e, per ciascuno:
   `base_url`, `allowed_hosts` (incluso il dominio del login federato, se
   c'è), `tier`, che dati contiene (`data_note`), come ci si arriva
   (`access_note`: VPN, IP allowlist). Se un ambiente ha un'autenticazione
   **davanti** all'app (basic auth, VPN con credenziali), quella è una
   credenziale come le altre: un riferimento, mai il valore. Non inventare
   URL: se il PM non li sa, lascia l'ambiente con `base_url: ""` e una
   nota — app-test non lo userà finché non è completo.

3. **Utenti** (setup, add). Per ciascuno raccogli, senza presumere:
   ambiente, persona in parole (chi è, cosa vede), ruoli applicativi, lo
   stato dei dati che lo rende utile (`data_profile`), metodo di login,
   MFA, owner. Il **valore** della password **non** va scritto in
   conversazione se si può evitare: proponi al PM, in ordine,
   1. un riferimento al password manager del team (`op://…`) o al
      Portachiavi (`keychain:servizio/account`) — l'unico modo in cui i
      colleghi che clonano ritrovano le credenziali;
   2. una riga nel file locale, che il PM aggiunge **lui** con un editor
      (`bash .claude/hooks/test-credentials.sh init-local` lo crea se
      manca; suggerisci la chiave `<APP>_<LIVELLO>_<PERSONA>_PASSWORD`);
   3. solo se il PM la incolla comunque in conversazione: scrivila tu
      nel file locale (mai altrove), e ricordagli che il valore ora sta
      anche nella trascrizione della sessione.
   Poi `check` sul riferimento: se non si risolve, l'utente resta
   `wanted` (o `broken`, se esisteva) con una `status_note`, non `active`.

4. **Utenti in produzione.** Chiedi esplicitamente se l'utente è stato
   creato apposta per **agire** in produzione (merchant di test, carta di
   test, flag "utente interno" che esclude i suoi dati dalle metriche):
   solo allora `production_writes: true`. Ricorda al PM che anche così
   ogni azione di scrittura in produzione chiederà la sua conferma, una
   per una (playbook, "Ambienti e utenti di prova", regole di
   produzione). Se l'identificativo stesso è riservato, usa
   `username_ref` invece di `username`. Se l'utente vede dati di clienti
   reali (es. un admin), annotalo in `notes`: gli screenshot fatti con lui
   vanno trattati come dati personali.

5. **activate / adopt.** Per un `wanted` diventato risolvibile: conferma
   col PM che è l'utente giusto, completa i campi mancanti, `status:
   active`, svuota `wanted_since`/`wanted_by` spostando il motivo in
   `notes`. Per una chiave orfana: chiedi a quale utente appartiene (uno
   esistente da collegare, uno `wanted`, uno nuovo → modalità add); se è
   un refuso o una chiave vecchia, suggerisci al PM di toglierla dal file
   locale. Mai indovinare l'abbinamento dal nome della chiave senza
   conferma.

6. **verify.** Per ogni utente richiesto (default: tutti gli `active` con
   credenziali pronte, mai i `retired`): segui la procedura di login di
   `app-test` (passi 3-5) senza fare altro, poi fai logout. Login riuscito
   → `last_verified_at` = oggi, `status: active`. Login fallito →
   `status: broken` con `status_note` (cosa è successo: password errata,
   utente bloccato, MFA cambiata, ambiente irraggiungibile). Ambiente
   irraggiungibile → è dell'ambiente, non dell'utente: `environments[].status:
   unreachable` e lascia l'utente com'è. Non ritentare un login fallito più
   di una volta: molti sistemi bloccano l'utente dopo pochi errori.

7. **rotate / retire.** Rotazione: il PM aggiorna il valore nel suo
   archivio (o te lo dice, e lo scrivi solo nel file locale); il
   riferimento nel registro di solito non cambia; poi verify. Ritiro:
   `status: retired` + motivo in `status_note`; suggerisci al PM di
   togliere la riga dal file locale / l'elemento dal password manager.

8. **Scrivi il registro** con `updated_at` = oggi. Scrittura diretta, non
   passa da `product/approvals/pending/` (dato di riferimento condiviso,
   come `team.yaml`). Prima di salvare, rileggi il diff e verifica che non
   contenga **nessun valore** di credenziale: se ne trovi uno, toglilo,
   spostalo nell'archivio e avvisa il PM.

9. **Sincronizza**:
   `bash .claude/hooks/governance-sync.sh push "test-accounts: <modalità> <id>" product/reference/test-environments.yaml`.
   Il file locale delle credenziali non si committa mai (è escluso dal
   `.gitignore` di root).

10. **Riepilogo al PM**: utenti aggiunti/attivati/rotti/ritirati, chi
    resta `wanted` e per cosa serve (così può chiederlo a chi crea gli
    utenti), e se qualche utente ha credenziali solo nel file locale di
    questo clone (i colleghi non le avranno: suggerisci il password
    manager).

## Cosa NON fare

- **Non scrivere mai un valore di credenziale** nel registro, in una
  nota, in un'idea, in un commit, in un messaggio di riepilogo. Nemmeno
  "mascherato a metà".
- **Non registrare account personali** di colleghi o account di clienti
  reali come utenti di prova. Se è l'unico modo di testare, segnalalo
  come `wanted` e fermati.
- **Non usare `cmd:` o altri schemi di riferimento** oltre a quelli
  ammessi (`local:`, `env:`, `keychain:`, `op://`): il registro è
  tracciato, un comando lì sarebbe eseguito su ogni clone.
- **Non creare utenti nelle applicazioni.** Questa skill registra utenti
  che il team ha creato; crearli è un'azione sull'applicazione (e in
  produzione, sui dati) che spetta al team tech.
- **Non insistere su un login fallito**: un tentativo, poi `broken` e la
  nota.
