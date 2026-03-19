# security-review

Audit de sécurité couvrant l'authentification, l'injection SQL, l'exposition de secrets, CSRF (Cross-Site Request Forgery) et les vulnérabilités OWASP (Open Web Application Security Project) Top 10.

## Quand utiliser ce skill

Utilisez ce skill pour :
- Implémenter de l'authentification ou de l'autorisation
- Traiter des entrées utilisateur ou des uploads de fichiers
- Créer de nouveaux endpoints API
- Manipuler des secrets ou credentials
- Implémenter des fonctionnalités de paiement
- Stocker ou transmettre des données sensibles
- Intégrer des APIs tierces

## 10 catégories de sécurité

| # | Catégorie | Points clés |
|---|-----------|-------------|
| 1 | **Gestion des secrets** | Variables d'environnement, jamais de credentials en dur |
| 2 | **Validation des entrées** | Schémas Zod, restrictions sur les uploads |
| 3 | **Injection SQL** | Requêtes paramétrées, utilisation d'ORM (Object-Relational Mapping) |
| 4 | **Authentification & Autorisation** | JWT (JSON Web Token), RBAC (Role-Based Access Control), Row Level Security |
| 5 | **Prévention XSS** (Cross-Site Scripting) | Sanitization HTML, CSP (Content Security Policy) |
| 6 | **Protection CSRF** | Tokens CSRF, cookies SameSite |
| 7 | **Rate Limiting** | Throttling API, limites sur les opérations coûteuses |
| 8 | **Exposition de données** | Logging sûr, messages d'erreur génériques |
| 9 | **Sécurité blockchain** | Vérification de wallet, validation de transactions |
| 10 | **Dépendances** | Scan de vulnérabilités, mises à jour régulières |

## Checklist pré-déploiement

Le skill inclut une checklist de **17 points critiques** à vérifier avant chaque mise en production :

- Aucun secret en dur dans le code
- Validation de tous les inputs utilisateur
- Requêtes SQL paramétrées uniquement
- JWT avec expiration et rotation
- Protection XSS et CSP en place
- CSRF tokens sur les mutations
- Rate limiting sur les endpoints publics
- Logging sans données sensibles
- Dépendances à jour sans vulnérabilités connues

## Tests de sécurité

Le skill fournit des exemples de tests automatisés pour :
- Vérification des exigences d'authentification
- Contrôle des autorisations
- Validation des entrées
- Enforcement du rate limiting

## Exemples d'utilisation

```
@workspace avec security-review, audite ce endpoint d'authentification
@workspace avec security-review, vérifie la sécurité de ce formulaire d'upload
@workspace avec security-review, checklist pré-déploiement pour ce service
```

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill security-review -g -y
```

## Ressources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Next.js Security](https://nextjs.org/docs/security)
- [Web Security Academy](https://portswigger.net/web-security)
- [SKILL.md complet](../skills/security-review/SKILL.md) — Checklist complète avec exemples de code
