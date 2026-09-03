# Esempio: Epassi ITA

Questa cartella **non è un'istanza viva** del framework (niente
`.governance/config.yaml`, niente `apps/` con submodule reali) — è un
caso di studio completo, la prima istanza per cui questo framework è
stato disegnato, incluso a scopo di documentazione e validazione dello
schema.

- `docs/vision-brief.md` — il brief originale che ha motivato l'evoluzione
  da Aha! a un sistema fondato su Claude Code.
- `docs/playbook-v4.md` — il playbook completo, specifico per Epassi ITA
  (con le Cronache, i nomi reali, il glossario di dominio). È il documento
  da cui `framework/playbook.md` è stato genericizzato.
- `product/reference/product-lines.yaml` — le 5 Product Line reali di
  Epassi ITA, popolate dalla tabella del playbook.
- `product/ideas/2026-01-08-approvazione-ricevute-solo-totale/` — un'idea
  ricostruita dalle Cronache (Episodi 1-2: la segnalazione di Filiberto
  sul motore di approvazione ricevute), usata per validare che
  `framework/schema/idea.template.yaml` regga un caso narrativo reale,
  RICE score incluso (Reach 2 × Impact 3 × Confidence 10 / Entanglement 2 = 30,
  con Reach sulla scala 1-10: ≈15% della popolazione → `ceil(15/10)` = 2).

Se un domani Epassi ITA diventa un'istanza reale (fork inizializzato con
`init-governance-project`), questo esempio resta qui come riferimento
storico — non va promosso a istanza sostituendo questa cartella.
