# Evoluzione della Product Governance: da Aha! a un sistema fondato su Claude Code

**A cura di:** Nicola Trincas (Head of Product, Epassi Italia)
**Stato:** Idea di progetto — direzione condivisa, non ancora un piano di rilascio
**Destinatari:** Team Prodotto e Tecnologia Epassi Italia

---

## 1. Il problema

Aha! è stato adottato da tempo ma non è mai stato realmente utilizzato dal team. L'unico impiego rimasto è il backlog "ideas" per il RICE scoring e il contenitore "releases" come metafora dell'iterazione settimanale — le cerimonie di governance si limitano a spostare card senza che questo generi valore reale.

Nel frattempo, il lavoro vero si è già spostato altrove: i PRD vengono scritti prevalentemente con Claude, partendo da email e trascrizioni di riunioni. La Product Governance, così come formalizzata nel playbook interno, resta un framework valido — il problema non è il metodo, è lo strumento che dovrebbe supportarlo.

## 2. La direzione proposta

Non sostituire Aha! con un altro tool "stile Aha!" (dove si aggiungono/spostano card come attività separata dal lavoro reale). Invece: **Claude Code diventa il luogo dove si scrive il PRD**, cioè l'attività a più alto valore che il PM fa comunque ogni giorno. La governance (RICE, roadmap, tracciamento) diventa un sottoprodotto automatico di quel lavoro, non un compito aggiuntivo.

Questo risolve il problema di adozione alla radice: non serve convincere nessuno a usare un tool nuovo, perché il tool coincide con l'attività che il PM svolge comunque per lavorare.

Il differenziale rispetto a qualunque tool di mercato (Aha!, Jira stesso): **il PRD viene scritto con visibilità sulla codebase reale** (via submodule dei repository applicativi), quindi le implicazioni tecniche di ogni scelta sono considerate fin dall'authoring, non scoperte dopo.

## 3. Architettura concettuale

- **Fonte di verità: Git.** Idee, RICE (con storico delle revisioni), PRD, snapshot settimanali di roadmap vivono come file strutturati (YAML/Markdown) in un repository. Versionati, diffabili, auditabili.
- **Livello derivato: applicazione con DB.** Per la fruizione via web (roadmap live, storico dei Gantt settimanali, impatto economico e metriche per iniziativa) i file vengono aggregati in un piccolo database, sempre **rigenerato dai file e mai editato direttamente** — niente doppie fonti da mantenere sincronizzate a mano.
- **Jira: sistema di verità per l'esecuzione, non duplicato.** Nessun sync in tempo reale. Al momento della prioritizzazione, l'iniziativa viene inviata su Jira con link alle risorse (PRD); l'ID della card viene persistito e monitorato via polling occasionale (stato + commenti) fino a risoluzione — sufficiente per l'uso reale (MBR/MTR mensili: "cosa è in agenda, è green o red e perché").
- **Meccanismo unico di "pending approval".** Usato sia per i diff di roadmap proposti automaticamente (es. da una nuova trascrizione che impatta un RICE) sia per ogni comunicazione in uscita (mail settimanale agli stakeholder, roadmap trimestrale Corporate). Nulla viene applicato o inviato senza revisione umana esplicita — l'automazione propone, non decide.

## 4. Decisioni prese durante la discussione

**Sul metodo di lavoro**
- Il flusso operativo parte da materiale grezzo (email, trascrizioni) allegato al progetto; i comandi Claude Code lo interpretano per alimentare idee, RICE, PRD e roadmap.
- Ogni proposta di cambiamento generata automaticamente (es. un RICE che cambia per nuova evidenza) passa per approvazione umana prima di essere applicata: l'"automagia" resta nella proposta, non nell'esecuzione silenziosa — per motivi sia di qualità (falsi positivi/negativi nell'inferenza) sia organizzativi (difendibilità delle decisioni in caso di MBR o dispute con gli stakeholder).

## 5. Prossimi passi

1. Definire lo schema dati completo (idea, RICE con storico, PRD, snapshot roadmap, Strategic Exception, coda di approvazione).
2. Progettare i comandi/skill Claude Code (idea-intake, rice-update, prd-draft, roadmap-snapshot, jira-push/pull).
