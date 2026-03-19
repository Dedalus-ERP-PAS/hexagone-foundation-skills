---
name: hexagone-web-feature-extractor
description: "Skill pour se connecter à Hexagone Web via Claude in Chrome, parcourir systématiquement un espace applicatif, capturer des screenshots de chaque page/onglet, et produire un document Word (.docx) orienté Product Owner avec descriptions fonctionnelles et captures d'écran embarquées. Utiliser ce skill dès que l'utilisateur demande d'explorer Hexagone Web, d'extraire des features, de documenter un espace fonctionnel, de produire une fiche produit ou une présentation client depuis Hexagone Web. Fonctionne aussi pour tout autre espace que Structures/Nomenclatures."
---

# Hexagone Web Feature Extractor

Skill permettant d'explorer un espace Hexagone Web, d'en capturer les écrans et de produire un document Word orienté PO/client.

## Prérequis

- **Claude in Chrome** activé et connecté
- Accès réseau au serveur Hexagone Web (par défaut : `https://ws004202.dedalus.lan:8065/hexagone-01/vue/login`)
- Acceptation manuelle du certificat SSL si auto-signé (l'utilisateur doit le faire avant de lancer le skill)
- Le skill **docx** doit être disponible pour la génération du document final

## Vue d'ensemble du workflow

```
1. CONNEXION     → Se connecter à Hexagone Web via Chrome
2. NAVIGATION    → Accéder à l'espace cible
3. DÉCOUVERTE    → Lister toutes les pages/menus du sidebar
4. EXPLORATION   → Parcourir chaque page, capturer screenshots + texte
5. TRANSFERT     → Transférer les screenshots vers le conteneur
6. GÉNÉRATION    → Produire le document Word avec captures embarquées
```

---

## Étape 1 : Connexion à Hexagone Web

### 1.1 Préparer l'onglet Chrome

```
1. Appeler tabs_context_mcp(createIfEmpty=true) pour obtenir un onglet
2. Créer un nouvel onglet dédié : tabs_create_mcp()
3. Naviguer vers l'URL de login (par défaut `https://ws004202.dedalus.lan:8065/hexagone-01/vue/login`, sauf si l'utilisateur en fournit une autre)
```

**IMPORTANT** : La navigation initiale peut échouer (timeout) si le certificat SSL n'est pas accepté. Dans ce cas :
- Demander à l'utilisateur de cliquer manuellement sur "Paramètres avancés" > "Continuer vers le site"
- Attendre que la page de login soit affichée
- Reprendre le contrôle

### 1.2 Remplir le formulaire de login

Le formulaire Hexagone Web a 3 champs : Nom utilisateur, Mot de passe, Code gestionnaire. Par défaut, utiliser l'utilisateur `apvhn` avec un mot de passe aléatoire, sauf si l'utilisateur en fournit d'autres.

**Méthode recommandée** : Utiliser JavaScript natif pour remplir les champs. La méthode `form_input` fonctionne mais le clic sur le bouton peut échouer (`chrome-extension:// URL` error). Utiliser JavaScript pour tout le processus :

```javascript
// Remplir via JavaScript avec dispatch d'événements (nécessaire pour Vue.js)
const nativeSetter = Object.getOwnPropertyDescriptor(
  window.HTMLInputElement.prototype, 'value'
).set;

// Username (default: apvhn, unless user specifies another)
const userInput = document.querySelector('input[type="text"]');
nativeSetter.call(userInput, 'apvhn');
userInput.dispatchEvent(new Event('input', { bubbles: true }));
userInput.dispatchEvent(new Event('change', { bubbles: true }));

// Password (random by default, unless user specifies one)
const pwdInput = document.querySelector('input[type="password"]');
nativeSetter.call(pwdInput, 'Rand' + Math.random().toString(36).slice(2, 10));
pwdInput.dispatchEvent(new Event('input', { bubbles: true }));
pwdInput.dispatchEvent(new Event('change', { bubbles: true }));

// Cliquer sur "Se connecter"
document.querySelector('button').click();
```

**Pourquoi JavaScript ?** Le framework Vue.js d'Hexagone Web ne détecte pas les changements de valeur injectés directement. Le `nativeInputValueSetter` + `dispatchEvent('input')` simule une saisie utilisateur réelle.

### 1.3 Vérifier la connexion

Après le clic, attendre 5s puis vérifier :
- Le titre de l'onglet change (ex: "Hexagone Web - Portail patient")
- Un screenshot montre la page d'accueil avec le message "Bienvenue sur l'espace..."

---

## Étape 2 : Navigation vers l'espace cible

### 2.1 Ouvrir le sélecteur d'espaces

L'espace actif est affiché dans la barre orange en haut (ex: "PORTAIL PATIENT"). Cliquer dessus pour ouvrir la liste déroulante de tous les espaces disponibles.

```
Coordonnée approximative : cliquer sur le texte orange de l'espace actif dans le breadcrumb
```

### 2.2 Sélectionner l'espace

La liste déroulante (fond orange) peut nécessiter un scroll. Les espaces sont listés alphabétiquement. Scroller et cliquer sur l'espace souhaité (ex: "STRUCTURES / NOMENCLATURES").

### 2.3 Attendre le chargement

Hexagone Web redirige via une page intermédiaire "Connexion... Redirection...". Attendre 5s minimum et vérifier que l'URL a changé et que le breadcrumb affiche le nouvel espace.

---

## Étape 3 : Découverte des pages

### 3.1 Identifier les entrées du menu latéral

Le menu latéral (sidebar gauche) contient des icônes sans texte visible par défaut. Utiliser JavaScript pour les lister :

```javascript
const links = document.querySelectorAll('a.hexa');
const items = [];
links.forEach(el => {
  const rect = el.getBoundingClientRect();
  if (rect.left < 250 && rect.top > 60) {
    const raw = el.textContent.trim();
    items.push({
      label: raw,
      y: Math.round(rect.top)
    });
  }
});
JSON.stringify(items, null, 2);
```

**Structure typique du sidebar** : Les liens ont la classe CSS `hexa`. Le texte est préfixé par le nom de l'icône (ex: `tdbTableau de bord`, `lettres_budgetLettres budgets`). Extraire la partie après le préfixe d'icône.

### 3.2 Construire le plan d'exploration

Créer une liste ordonnée de toutes les pages à visiter, avec leurs coordonnées Y pour le clic. Exclure les pages utilitaires (Tableau de bord, Mes post-its) si non pertinentes pour le livrable PO.

---

## Étape 4 : Exploration et capture

### 4.1 Pour chaque page du menu

```
1. Cliquer sur l'entrée du menu (utiliser la coordonnée Y avec x=38)
   - Si le clic direct échoue, utiliser JavaScript : el.click()
2. Attendre 3 secondes le chargement
3. Prendre un screenshot : computer(action="screenshot", save_to_disk=true)
4. Extraire les informations textuelles clés via read_page ou JavaScript
5. Si la page a des onglets, les parcourir un par un
6. Si la page a des sous-pages (ex: Paramétrages > Banques), les explorer
7. Stocker l'ID du screenshot et les métadonnées dans une liste
```

### 4.2 Identifier les onglets internes

Certaines pages ont des onglets internes (ex: Plan comptable → Comptes de résultat / Tableau de financement / Comptes de tiers). Les trouver avec :

```javascript
// Chercher les onglets
const tabs = document.querySelectorAll('[role="tab"], .tab-link, a[href="javascript:;"]');
```

Ou utiliser `find(query="tab")` pour les localiser.

### 4.3 Stocker les métadonnées

Maintenir un tableau JSON des pages explorées :

```json
[
  {
    "id": 1,
    "page": "Tableau de bord",
    "screenshotId": "ss_XXXXX",
    "description": "Vue synthétique par exercice...",
    "tabs": [],
    "subpages": []
  }
]
```

---

## Étape 5 : Transfert des screenshots vers le conteneur

### Problème connu

Les screenshots pris via `computer(action="screenshot")` sont stockés en mémoire par l'extension Chrome avec un ID (ex: `ss_49478g4in`). Ils ne sont **pas** directement accessibles depuis le filesystem du conteneur (`/home/claude/`).

### Solution : Bridge HTTP

Lire le fichier `scripts/screenshot-bridge.md` pour la procédure complète de transfert des screenshots du navigateur vers le conteneur.

**Résumé** :
1. Lancer un serveur HTTP dans le conteneur (`scripts/screenshot-server.js`)
2. Naviguer un onglet Chrome vers la page bridge (`http://localhost:PORT/bridge.html`)
3. Pour chaque screenshot, utiliser `upload_image(imageId, tabId, ref)` pour l'uploader via le file input de la page bridge
4. JavaScript sur la page envoie le fichier au serveur qui le sauvegarde
5. Les fichiers sont disponibles dans `/home/claude/screenshots/`

---

## Étape 6 : Génération du document Word

### 6.1 Lire le skill docx

Toujours lire `/mnt/skills/public/docx/SKILL.md` avant de générer le document.

### 6.2 Générer le document

Utiliser le script `scripts/generate-docx.js` comme base. Le script :
- Prend en entrée un fichier JSON de métadonnées (pages, descriptions, chemins screenshots)
- Génère un .docx avec page de couverture, sommaire, et une section par feature
- Chaque section inclut : titre, description PO, tableau des fonctionnalités clés, valeur métier, et screenshot embarqué

### 6.3 Structure du document

```
Page de couverture (couleurs Dedalus teal/orange)
Sommaire
Pour chaque feature :
  - Titre (Heading 2, orange)
  - Description fonctionnelle
  - Screenshot de la page
  - Tableau "Fonctionnalités clés" (numéroté, fond teal)
  - Section "Valeur métier" (titre orange)
[Pas de synthèse finale - le document est auto-porteur par feature]
```

### 6.4 Validation et sortie

```bash
python /mnt/skills/public/docx/scripts/office/validate.py output.docx
cp output.docx /mnt/user-data/outputs/
```

---

## Paramètres d'entrée attendus

L'utilisateur doit fournir :
- **URL de login** *(optionnel)* : par défaut `https://ws004202.dedalus.lan:8065/hexagone-01/vue/login` (environnement de développement). L'utilisateur peut fournir une autre URL si nécessaire.
- **Nom utilisateur** *(optionnel)* : par défaut `apvhn`. L'utilisateur peut fournir un autre code si nécessaire.
- **Mot de passe** *(optionnel)* : par défaut une valeur aléatoire. L'utilisateur peut fournir un mot de passe spécifique si nécessaire.
- **Espace cible** : nom exact de l'espace à explorer (ex: "STRUCTURES / NOMENCLATURES")

## Troubleshooting

| Problème | Cause | Solution |
|----------|-------|----------|
| Navigation timeout | Certificat SSL | Utilisateur accepte manuellement |
| `chrome-extension:// URL` error | Focus sur popup extension | Utiliser JavaScript au lieu de click direct |
| Champs non détectés par Vue.js | Injection directe sans events | Utiliser `nativeInputValueSetter` + `dispatchEvent` |
| Menu déroulant non visible | Scroll nécessaire | `scroll(direction="down")` dans le menu |
| Screenshot non accessible | Stockage en mémoire extension | Utiliser le bridge HTTP (étape 5) |
