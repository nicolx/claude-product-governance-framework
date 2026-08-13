# Materiale di origine (ricostruito dalle Cronache di EPASSI ITA, Episodi 1-2)

**Tipo:** email + follow-up meeting
**Da:** Filiberto (Head of Operations)
**A:** Gennaro (Product Manager)

## Email originale (Episodio 1)

Oggetto: *Idea per il motore di approvazione ricevute*

Filiberto segnala di aver notato che il motore di approvazione automatica
delle ricevute dei beneficiari (già basato su AI) fallisce spesso in un
caso specifico: ricevute in cui non sono indicate nel dettaglio le singole
voci di spesa, ma solo il totale (lo "scontrino sbrigativo" del negozio
locale). Allega una dozzina di casi concreti.

Nella pratica, gli operatori già approvano manualmente questi casi quando
c'è corrispondenza tra il totale e il nome del Merchant indicato nella
richiesta di rimborso — Filiberto propone di automatizzare anche questo
caso, invece di lasciarlo cadere sempre in revisione manuale.

## Follow-up meeting (Episodio 2)

Partecipanti: Filiberto, Franco (referente tecnico), Gennaro (PM).

Emerso dalla discussione:
- Il problema si verifica nel 30% delle ricevute non riconosciute, che
  sono a loro volta il 30% del totale — Reach totale stimato: **15%**.
- Se risolto del tutto, si stima un risparmio di **4 FTE al backoffice**
  (~100k/anno di EBITDA salvato).
- Le analisi sono quantitative e con evidenze chiare (dati verificati).
- L'effort stimato è molto basso: basta escludere una regola che fa da
  filtro nel motore esistente.
