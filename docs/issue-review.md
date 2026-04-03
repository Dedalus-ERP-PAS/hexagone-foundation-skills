# Issue Review

Revue autonome d'issues GitLab/GitHub par personas IA. Analyse multi-angle de la faisabilité, complétude, risques et architecture, avec publication automatique du rapport sur l'issue.

## Quand l'utiliser

- Vous voulez un avis structuré sur une issue avant de lancer l'implémentation
- Vous voulez vérifier que l'issue est suffisamment bien définie, complète et réalisable
- Vous voulez identifier les risques et les points techniques à considérer avant de coder

## Différence avec les autres skills

| | meeting | fast-meeting | issue-review |
|---|---|---|---|
| **Entrée** | Sujet libre | Sujet libre ou issue | Issue obligatoire (#ID ou URL) |
| **Personas** | Sélection manuelle | Automatique | Automatique |
| **Tours de réunion** | 3 tours | 1 tour + synthèse | 3 tours (positions, débat, convergence) |
| **Validation utilisateur** | Obligatoire | Aucune | Aucune (sauf issue fermée) |
| **Implémentation** | Après validation | Immédiate | Aucune — analytique uniquement |
| **MR/PR** | Après validation | Automatique | Aucune |
| **Commentaire issue** | Sur demande | Automatique (PO) | Automatique (PO + technique si pertinent) |
| **Exploration codebase** | Non | Si code concerné | Systématique |

## Comment l'utiliser

Demandez simplement à votre agent IA de lancer une revue d'issue :

```
issue-review #42
```

```
issue-review https://gitlab.example.com/group/project/-/issues/42
```

```
issue-review https://github.com/org/repo/issues/15
```

## Ce que le skill fait

1. **Récupère l'issue complète** — Titre, description, tous les commentaires, labels
2. **Détecte le remote** — GitLab ou GitHub pour la publication du commentaire
3. **Vérifie le contenu** — Si l'issue est trop vague, poste un commentaire listant les éléments manquants et s'arrête
4. **Récupère le contexte lié** — Diff de la branche liée si elle existe
5. **Explore le codebase** — Lit les fichiers et modules pertinents pour donner du contexte aux personas
6. **Sélectionne 3-4 personas automatiquement** — Selon le domaine de l'issue
7. **Anime une réunion en 3 tours** — Positions initiales, débat entre personas, convergence pondérée
8. **Vérifie le consensus** — Lance un avocat du diable si toutes les personas sont d'accord
9. **Produit une analyse structurée** — Faisabilité, complétude, risques, points techniques, prochaines étapes
10. **Publie le rapport sur l'issue** — Commentaire en français, orienté PO/consultant avec points techniques si nécessaire

## Personas disponibles

| Persona | Rôle | Ce qui compte pour elle |
|---------|------|------------------------|
| SOLID Alex | Ingénieur Backend Senior | Qualité de code, maintenabilité |
| Sprint Zero Sarah | Product Owner (PO) | Valeur utilisateur, rapidité de livraison |
| Paranoid Shug | Ingénieur Sécurité (certifié OWASP) | Surface d'attaque, sécurité web |
| Pipeline Mo | Ingénieur DevOps / SRE | Opérabilité, déploiement, scalabilité |
| Pixel-Perfect Hugo | Ingénieur Frontend | Expérience utilisateur, Vue.js, React, PrimeVue |
| Whiteboard Damien | Tech Lead / Architecte | Vision long terme, capacité de l'équipe |
| Edge-Case Nico | Ingénieur QA | Testabilité, cas limites, Playwright, Vitest |
| EXPLAIN PLAN Isabelle | Ingénieure Base de Données Senior (Oracle) | Administration Oracle, PL/SQL, tuning |
| Schema JB | Ingénieur Data | Intégrité des données, migrations |
| RFC Santiago | PO Interopérabilité Senior | Standards HL7, FHIR, HPK |
| Legacy Larry | Développeur Fullstack Senior (Uniface) | Modernisation legacy, patterns 4GL/RAD |
| HL7 Victor | Développeur Fullstack Interopérabilité Senior | Intégration bout-en-bout, parsing de messages |
| RGPD Raphaël | DPO / Compliance | RGPD, HDS, consentement |
| Dr. Workflow Wendy | Experte Domaine Santé | Workflows hospitaliers, administration patient |
| Figma Fiona | Designer UX/UI | Recherche utilisateur, tokens de design, WCAG |
| Dashboard Estelle | Senior BI / Data Analyst — Finance & Comptabilité | Reporting financier, KPIs, datatables complexes |

La sélection est automatique selon le contenu et les labels de l'issue.

## Garde-fous

| Protection | Comportement |
|---|---|
| **Issue vide ou trop vague** | Poste un commentaire listant les éléments manquants, pas de réunion |
| **Issue fermée** | Avertit l'utilisateur et demande confirmation avant de continuer |
| **Consensus trop facile** | Lancement d'un avocat du diable si toutes les personas sont d'accord |
| **Échec de publication** | Affiche le rapport dans la conversation + commande manuelle |

## Verdicts possibles

| Verdict | Signification |
|---|---|
| ✅ **Prête pour implémentation** | Issue bien définie, faisable, risques gérables |
| ⚠️ **Nécessite des ajustements** | Faisable mais éléments manquants ou risques à mitiger |
| ❌ **Nécessite une refonte significative** | Lacunes majeures, scope flou, préoccupations architecturales non résolues |

## Exemple de résultat

Le skill produit :
- Une **analyse affichée** dans la conversation (contexte, participants, faisabilité, complétude, risques, points techniques, prochaines étapes, verdict)
- Un **commentaire sur l'issue** en français, orienté PO/consultant avec points techniques si pertinent, incluant des prochaines étapes sous forme de checklist actionnable
