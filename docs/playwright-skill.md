# playwright-skill

Tests et automatisation web avec Playwright (JavaScript/Node.js).

## Quand utiliser ce skill

Utilisez ce skill pour :
- Tester des webapps dynamiques (React, Vue, Angular)
- Capturer des screenshots multi-viewports
- Valider des formulaires, login flows, liens cassés
- Automatiser des interactions navigateur

## Workflow

1. **Vérifier si le serveur tourne** -- Détection automatique ou démarrage
2. **Écrire le script dans `/tmp`** -- Jamais dans le répertoire du projet
3. **Exécuter et analyser** -- Navigateur visible par défaut

## Exemples de scripts

### Test responsive (multi-viewports)

```javascript
const { chromium } = require('playwright');
const TARGET_URL = 'http://localhost:3000';

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();
  const viewports = [
    { name: 'Desktop', width: 1920, height: 1080 },
    { name: 'Tablet', width: 768, height: 1024 },
    { name: 'Mobile', width: 375, height: 667 },
  ];
  for (const vp of viewports) {
    await page.setViewportSize(vp);
    await page.goto(TARGET_URL);
    await page.screenshot({ path: `/tmp/${vp.name}.png` });
  }
  await browser.close();
})();
```

### Test login flow

```javascript
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: false });
  const page = await browser.newPage();
  await page.goto('http://localhost:3000/login');
  await page.fill('input[name="email"]', 'test@example.com');
  await page.fill('input[name="password"]', 'password123');
  await page.click('button[type="submit"]');
  await page.waitForURL('**/dashboard');
  await browser.close();
})();
```

## API essentielle

### Navigation et attentes

```javascript
await page.goto(url, { waitUntil: 'networkidle' });
await page.waitForSelector('.modal');
await page.waitForURL('**/dashboard');
await page.waitForLoadState('networkidle');
```

### Interactions

```javascript
await page.click('button#submit');
await page.fill('input[name="email"]', 'test@example.com');
await page.check('input[type="checkbox"]');
await page.selectOption('select#country', 'france');
```

### Assertions et découverte

```javascript
const isVisible = await page.locator('button').isVisible();
const text = await page.locator('h1').textContent();
const allButtons = await page.locator('button').all();
```

## Bonnes pratiques

| A faire | A éviter |
|---------|----------|
| **Attendre `networkidle`** sur apps dynamiques | Inspecter le DOM avant `networkidle` |
| **Pattern reconnaissance** : screenshot, DOM, action | Timeouts fixes (`waitForTimeout()`) |
| **Navigateur visible** : `headless: false` pour debug | Écrire des fichiers dans le projet |
| **Sélecteurs robustes** : `data-testid`, `aria-label` | URLs hardcodées dans le script |
| **Try-catch** pour la gestion d'erreurs | Oublier de fermer le navigateur |

## Cas d'usage

- **Tests visuels** -- Screenshots multi-viewports, design responsive
- **Tests fonctionnels** -- Login, formulaires, navigation
- **Validation** -- Liens cassés, images, accessibilité
- **Automatisation** -- Remplir formulaires, extraire données

## Démarrage rapide

```bash
npx skills add Dedalus-ERP-PAS/foundation-skills --skill playwright-skill -g -y
```

## Ressources

- [SKILL.md complet](../skills/playwright-skill/SKILL.md) -- Guide détaillé
- [Documentation Playwright](https://playwright.dev/docs/intro) -- Documentation officielle
