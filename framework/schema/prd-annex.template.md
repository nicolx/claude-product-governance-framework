# {Allegato X} · {Titolo}

<!--
Template per product/prds/{slug}/allegato-{lettera}-{sub-slug}.md — ALLEGATO DATI.

Usato soprattutto per i PRD di discovery (prd_kind: discovery): un PoC ha bisogno
di un dataset dimostrativo COERENTE e VERIFICABILE, che non sta nel vincolo A3 di
un PRD. L'allegato è comune ai PRD che lo usano (tipicamente quello di esperienza
per il design e quello di costruzione per lo sviluppo): una sola fonte di verità
per numeri, parametri e testi, così design e sviluppo non li inventano.

Senza allegato, chi disegna o costruisce riempie i vuoti con valori plausibili
ma incoerenti — ed è ciò che la lettura a freddo trova per primo.

Regole:
- Tutti i valori dichiarati "dimostrativi" in testa: coerenti tra loro, non stime.
- Definizioni prima dei dati (base delle percentuali, periodo, cosa significa
  ogni etichetta, regole di arrotondamento).
- Dati in unità assolute (persone, euro), non solo percentuali: le percentuali
  si derivano.
- Risultati attesi espliciti: diventano criteri di accettazione (test).
- Testi pronti all'uso; dove manca una fonte reale, un segnaposto visibile
  ("Fonte in validazione"), mai un riempitivo plausibile.
- Portabilità (P7): nessun rimando a materiale che il lettore non vede; i
  materiali visivi stanno in assets/.
-->

*Allegato comune a {PRD che lo usano}. **Tutti i valori sono dimostrativi**: coerenti tra
loro, non stime. I valori reali li produce {PRD/fonte che li produrrà}.*

## X.1 Definizioni

<!-- Base delle percentuali, periodo, significato di ogni etichetta, soglie, formule,
     arrotondamenti (quando si arrotonda: "solo alla fine" evita discrepanze). -->

## X.2 Dati

<!-- Tabelle in unità assolute. Casi che esercitano le regole (es. un caso sotto soglia). -->

## X.3 Parametri

<!-- Tutti i parametri delle formule, in un posto solo. -->

## X.4 Risultati attesi

<!-- I valori che il codice deve produrre: sono i criteri di accettazione numerici. -->

## X.5 Testi

<!-- Copy pronto all'uso, etichette ammesse, parole vietate (se ci sono vincoli). -->

## X.6 Materiali visivi

<!-- Cosa c'è in assets/ e cosa manca ancora (azione aperta, con responsabile). -->
