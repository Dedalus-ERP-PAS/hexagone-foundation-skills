# AGENT.md — Foundation Skills

## Project Summary

Foundation Skills est un dépôt centralisé de skills pour agents IA de développement (Copilot, Claude, Cursor, Windsurf). Chaque skill est un fichier SKILL.md contenant des instructions que les agents chargent dynamiquement. Le projet suit le standard ouvert Agent Skills.

## Structure

```
skills/<nom>/SKILL.md          # Définition du skill
skills/<nom>/reference/        # Matériaux de référence (optionnel)
docs/<nom>.md                  # Documentation du skill
docs/comment-utiliser.md       # Guide d'installation
README.md                      # README principal (français)
```

## Commandes Essentielles

```bash
# Installer les skills dans un projet
npx skills add Dedalus-ERP-PAS/foundation-skills -g -y
```

## Conventions à Respecter

- Un répertoire par skill dans `skills/`, contenant un `SKILL.md`
- Un fichier de documentation par skill dans `docs/<nom>.md`
- Les SKILL.md sont rédigés en anglais (instructions pour agents IA)
- Le README.md et les docs sont en français
- Les messages de commit suivent le format conventional commits : `feat(scope): description`

## Workflow de Développement

- Branche principale : `main`
- Remote : `https://github.com/Dedalus-ERP-PAS/foundation-skills.git`
- Pas de CI/CD configuré
- Pas de tests automatisés (le contenu est du Markdown)

## Ajouter un Nouveau Skill

1. Créer `skills/<nom>/SKILL.md` avec les instructions du skill
2. Créer `docs/<nom>.md` avec la documentation utilisateur
3. Mettre à jour le tableau des skills dans `README.md`
4. Commit avec `feat(<nom>): description`

## Fichiers à Ne Pas Modifier

- `LICENSE` — Licence MIT, ne pas modifier
- Les fichiers dans `skills/*/reference/` contiennent des spécifications de référence, ne les modifier qu'en connaissance de cause

## Notes Importantes

- Ce dépôt ne contient pas de code exécutable, uniquement du Markdown
- Pas de dépendances npm/pip à installer pour le développement
- La distribution se fait via le CLI `skills` de Vercel Labs
- 24 skills disponibles répartis en 5 catégories : développement, parseurs santé, gestion d'issues, documents, utilitaires
