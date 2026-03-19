---
name: hexagone-swdoc
description: "Navigue et interroge la documentation des web services Hexagone (Référence Appels Externes). À utiliser quand l'utilisateur pose des questions sur les web services Hexagone, les méthodes SOAP, les services EWPT, les DTD XML, les formats requête/réponse, les codes d'erreur ou l'intégration avec Hexagone. Récupère la documentation depuis GitLab Pages — pas de git clone nécessaire."
version: 1.1.0
license: Proprietary
metadata:
  author: dedalus-erp-pas
  source-repo: erp-pas/hexagone/swdoc
  source-url: https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/swdoc
  pages-url: https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/swdoc/
allowed-tools: WebFetch
---

# Hexagone Web Services Documentation -- Navigation Skill

This skill gives you access to the **Hexagone Web Services documentation** ("Référence Appels Externes") published as GitLab Pages. Your role is to **fetch and read the relevant pages** when answering questions about Hexagone web services, not to rely on memorized knowledge.

## What is Hexagone swdoc

The Hexagone "Appels Externes" module (EW) exposes SOAP web services that allow external applications to invoke Hexagone Web business logic. The documentation is organized by **service module** (EWPT0001, EWPT0002, etc.), each grouping methods for a specific healthcare domain.

The documentation is published at:

```
https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/swdoc/
```

**When to use this skill:**
- The user asks about a Hexagone web service, SOAP method, or EWPT service
- The user needs to understand how to call a specific Hexagone API method
- The user is integrating with Hexagone and needs the service contract (parameters, DTDs)
- The user asks about XML DTD formats (CASE.HEXASERV, PATIENT_INFO.HEXASERV, etc.)
- The user wants to know which methods are available for a given domain (patients, movements, emergencies, etc.)
- The user is debugging an integration issue (error codes, statuts, configuration)
- The user asks about Hexagone API error codes or error handling (RESULT.HEXACALLW)
- Any question mentioning "Hexagone" combined with "web service", "API", "EWPT", "appels externes", "service web", or "WS"

## Service catalog

The base URL for all pages is:

```
BASE_URL = https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/swdoc/
```

### Complete service index

| Service | Domain | URL path | Key methods |
|---------|--------|----------|-------------|
| Introduction | General (auth, errors, data exchange) | `00-introduction/` | — |
| **EWPT0001** | Gestion des patients | `01-ewpt0001-gestion-des-patients/` | READ_PATIENT, FIND_PATIENT, NEW_PATIENT, UPDATE_PATIENT, READ_COVERAGES, READ_KINS, READ_DOCTOR, READ_CHILDLINK, CREATE_CHILDLINK, UPDATE_CHILDLINK, DELETE_CHILDLINK, SET_NEWBORN_STATE, ASSIGN_PROT_PATIENT, UPDATE_PROT_PATIENT, READ_PROT_PATIENT, PATIENT_DEBT, READ_PATIENT_ADDR, NEW_PATIENT_ADDR, UPDATE_PATIENT_ADDR, DELETE_PATIENT_ADDR, LEGAL_REPRESENTATIVES, REQUEST_PATIENT_MERGE, REQUEST_PATIENT_MERGE2, READ_PATIENT_DEMAT |
| **EWPT0002** | Gestion des urgences | `02-ewpt0002-gestion-des-urgences/` | READ_EMERGENCY, NEW_EMERGENCY, UPDATE_EMERGENCY, ENDOF_EMERGENCY, CANCEL_ENDOF_EMERGENCY, TO_OUTPATIENT, TO_INPATIENT, DELETE_EMERGENCY |
| **EWPT0003** | Consultations externes | `03-ewpt0003-gestion-des-consultations-externes/` | NEW_OUTPATIENT, READ_OUTPATIENT, UPDATE_OUTPATIENT, DELETE_OUTPATIENT |
| **EWPT0004** | Dossiers d'hospitalisation | `04-ewpt0004-gestion-des-dossiers-d-hospitalisation/` | READ_INPATIENT, NEW_INPATIENT, UPDATE_INPATIENT, DELETE_INPATIENT, CONFIRM_PREADMIT, READ_MOVEMENT, NEW_MOVEMENT, UPDATE_MOVEMENT, DELETE_MOVEMENT, CREATE_PENDING_VISIT_MVTS, MOVEMENT_AT, HOSP_BABY |
| **EWPT0005** | Lecture des occupations | `05-ewpt0005-lecture-des-occupations/` | ACTIVE_EMERGENCIES, HOUSING_UF_OCC, UF_OCC, RESPCENTER_OCC, SERVICE_OCC, POLE_OCC, LOCALIZATION_OCC, AVAILABLE_BEDS, IN_HOSPITAL |
| **EWPT0007** | Gestion des séjours | `07-ewpt0007-gestion-des-sejours/` | PATIENT_CASES, CASE_MVTS, MVT_HIST, HOSP_MODE_AT, NEW_HOSP_MODE, UPDATE_HOSP_MODE, DELETE_HOSP_MODE, READ_INFORMED_CONSENT, CHG_CASE_TYPE |
| **EWPT0008** | Produits | `08-ewpt0008-produits/` | INIT_ENV, GET_GEST, GET_FAMILY, GET_UNIT, GET_TAXE, GET_ACCOUNT_NUMBER, GET_UFMAINSTORE, GET_CMP, GET_GROUPING, PRODUCT_VERIFICATION, GET_PRODUCT_NUMBER, PRODUCT_CREATION |
| **EWPT0009** | Gestion du DMP | `09-ewpt0009-gestion-du-dmp/` | NEW_REJECTION, UPDATE_REJECTION, ACCESS_CODE, INFO_VITALE, READ_OTP, UPDATE_DMPINFO |
| **EWPT0010** | Gestion des praticiens | `10-ewpt0010-gestion-des-praticiens/` | FIND_PRACT, NEW_PRACT, UPDATE_PRACT |
| **EWPT0014** | Structures physiques | `14-ewpt0014-gestion-des-structures/` | CHACC_LOCALIZATION, FIND/READ/NEW/UPDATE/DELETE_BUILDING, FIND/READ/NEW/UPDATE/DELETE_FLOOR, FIND/READ/NEW/UPDATE/DELETE_BEDROOM, FIND/READ/NEW/UPDATE/DELETE_BED, FIND/READ/NEW/UPDATE/DELETE_LOCALIZATION |
| **EWPT0012** | Intégration d'actes | `12-ewpt0012-integration-d-actes/` | INTEGR_CCAM |
| **EWPT0013** | Re-génération Identités/mouvements | `13-ewpt0013-re-generation-identites-mouvements/` | REGEN_IDMVT |

### Method-to-service quick lookup

Use this table to quickly find which page to fetch when the user mentions a method name:

| Method pattern | Service page |
|----------------|-------------|
| `*_PATIENT*`, `*_CHILDLINK*`, `*_KIN*`, `*_COVERAGE*`, `*_DOCTOR*`, `PATIENT_DEBT`, `*_PROT_*`, `*_PATIENT_ADDR*`, `*_PATIENT_MERGE*`, `*_PATIENT_DEMAT*`, `LEGAL_REPRESENTATIVES` | EWPT0001 |
| `*_EMERGENCY*`, `TO_OUTPATIENT`, `TO_INPATIENT` | EWPT0002 |
| `*_OUTPATIENT*` | EWPT0003 |
| `*_INPATIENT*`, `*_MOVEMENT*`, `CONFIRM_PREADMIT`, `CREATE_PENDING_VISIT_MVTS`, `MOVEMENT_AT`, `HOSP_BABY` | EWPT0004 |
| `*_OCC`, `ACTIVE_EMERGENCIES`, `AVAILABLE_BEDS`, `IN_HOSPITAL` | EWPT0005 |
| `PATIENT_CASES`, `CASE_MVTS`, `MVT_HIST`, `*_HOSP_MODE*`, `READ_INFORMED_CONSENT`, `CHG_CASE_TYPE` | EWPT0007 |
| `INIT_ENV`, `GET_*`, `PRODUCT_*` | EWPT0008 |
| `*_REJECTION`, `ACCESS_CODE`, `INFO_VITALE`, `READ_OTP`, `UPDATE_DMPINFO` | EWPT0009 |
| `*_PRACT*` | EWPT0010 |
| `*_BUILDING*`, `*_FLOOR*`, `*_BEDROOM*`, `*_BED*`, `*_LOCALIZATION*`, `CHACC_LOCALIZATION` | EWPT0014 |
| `INTEGR_CCAM` | EWPT0012 |
| `REGEN_IDMVT` | EWPT0013 |

### Key DTD formats

| DTD | Used by | Description |
|-----|---------|-------------|
| RESULT.HEXACALLW | All methods | Standard error/result envelope (code, status, descr, when) |
| PATIENT_INFO.HEXASERV | EWPT0001 | Patient demographic data |
| PATPROT.HEXASERV | EWPT0001 | Patient protection data |
| LIST_PAT.HEXASERV | EWPT0001 | Patient search results |
| CHILD_LINK.HEXASERV | EWPT0001 | Mother-child link |
| LIST_COVERAGE.HEXASERV | EWPT0001 | Patient coverage list |
| LIST_KIN.HEXASERV | EWPT0001 | Patient next-of-kin list |
| LIST_ADR.HEXASERV | EWPT0001 | Patient addresses |
| PAT_RMERGE.HEXASERV | EWPT0001 | Patient merge request |
| LIST_DOCPAT.HEXASERV | EWPT0001 | Dematerialized patient documents |
| CASE.HEXASERV | EWPT0002, EWPT0004 | Inpatient case/visit + movements |
| CX_CASE.HEXASERV | EWPT0003 | Outpatient (consultation) case |
| MVT_CASE.HEXASERV | EWPT0004 | Movement data within a case |
| LIST_OCC.HEXASERV | EWPT0005 | Occupation list (beds, units) |
| LIST_BED.HEXASERV | EWPT0005 | Available beds list |
| LIST_CASE.HEXASERV | EWPT0007 | Patient cases list |
| LIST_MVT.HEXASERV | EWPT0007 | Movements list for a case |
| MVT_HIST.HEXASERV | EWPT0007 | Movement history |
| HOSP_MODE.HEXAGHP | EWPT0007 | Hospitalization mode |
| INF_CONS.HEXASERV | EWPT0007 | Informed consent |
| LIST_PRACT.HEXAGHP | EWPT0010 | Practitioner list |
| DMP_*.HEXASERV | EWPT0009 | DMP-related DTDs |

## How to answer questions

### Step 1: Identify the relevant page

Map the user's question to one or more service pages using the tables above:

- **Specific method name** (e.g., "READ_PATIENT") → use the method-to-service lookup
- **Domain keyword** (e.g., "patient", "urgence", "hospitalisation") → match to the service catalog
- **DTD name** (e.g., "CASE.HEXASERV") → use the DTD table to find the service page
- **Error handling / general architecture** → fetch the Introduction page
- **General "list all services"** → use the catalog above, no fetch needed

### Step 2: Fetch the page

Use the WebFetch tool to retrieve the relevant page:

```
WebFetch: url="${BASE_URL}<page-path>" format="markdown"
```

For example:
- Introduction: `WebFetch: url="https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/swdoc/00-introduction/" format="markdown"`
- Patient management: `WebFetch: url="https://erp-pas.gitlab-pages-erp-pas.dedalus.lan/hexagone/swdoc/01-ewpt0001-gestion-des-patients/" format="markdown"`

**Fetch only the page(s) you need.** Do not fetch all pages at once -- each service page can be large.

**If WebFetch fails** (network error, timeout), inform the user that the GitLab Pages site is unreachable and suggest they access it directly in their browser.

### Step 3: Extract and present the answer

After fetching, extract the relevant section from the page content:

1. **For a specific method:** find the `Méthode <NAME>` section, extract parameters, SOAP interface, and related DTD
2. **For a DTD format:** find the `DTD <NAME>` section, extract all field definitions
3. **For error codes:** find the `Gestion des codes retour et statuts` section
4. **For configuration:** find the `Configuration de l'application` section

Present the information clearly. Preserve the original structure (parameter tables, DTD field lists, error code tables) from the documentation.

### Step 4: Cross-reference if needed

If the user's question spans multiple services (e.g., "how do I create an emergency case and then transfer to inpatient?"), fetch multiple pages and compose a coherent answer showing the workflow across services.

## Response guidelines

When presenting web service documentation, keep the original structure from the fetched page. Hexagone web services follow a consistent pattern:

```markdown
## Méthode <METHOD_NAME>

**Service:** EWPT000X – <Domain>
**Source:** [page URL]

### Description
[What the method does]

### Parameters
| Type | Name | Direction | Required | Description |
|------|------|-----------|----------|-------------|
| string | application | IN | Yes | Caller application ID |
| ... | ... | ... | ... | ... |

### SOAP Interface
[Request/Response message structure]

### Related DTD
[XML format used for data exchange]

### Error Codes
[Specific error codes for this method, if any]

### Configuration
[Required application configuration, if any]
```

## Important rules

1. **Always fetch from the GitLab Pages site** -- never answer from memory or general knowledge about web services. The Hexagone API has specific conventions, SOAP-based interfaces with XML DTDs, that do not follow standard REST patterns.

2. **Quote the source URL** when presenting information: always mention which page the information comes from (e.g., "Source: EWPT0001 -- Gestion des patients").

3. **Do not invent methods or parameters** -- if the information is not found on the fetched page, say so explicitly. Do not guess or extrapolate.

4. **Handle missing documentation gracefully** -- if a method is not documented, inform the user and suggest they check with the Hexagone development team or open an issue in the swdoc repository at `https://gitlab-erp-pas.dedalus.lan/erp-pas/hexagone/swdoc`.

5. **Respect the source of truth** -- if there is a conflict between what the user believes and what the documentation says, trust the documentation and point out the discrepancy.

6. **Cross-reference with HPK/HL7** -- if the web service relates to interoperability messages (HPK, HL7), mention the connection and suggest using the `hpk-parser` or `hl7-pam-parser` skills for message-level details.

7. **Common patterns to highlight:**
   - All methods require an `application` parameter (caller identification, configured in Hexagone Web)
   - All methods return a `result` buffer in `RESULT.HEXACALLW` format (code + status + description)
   - Code `0` = success; any other code = error (check status for details)
   - Data exchange uses XML buffers with specific DTD formats per domain
   - Application configuration (CODEGEST, PSACC, etc.) affects behavior per caller
