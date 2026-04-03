# Référentiel des messages HPK - Gestion Économique et Financière (GEF)

Spécification de référence des messages HPK pour la gestion économique et financière dans Hexagone. Ce document decrit les formats de messages entrants et sortants (produits, fournisseurs, commandes, livraisons, etc.).

> **Note technique** : ce document est une conversion automatique de la specification Word officielle. Il sert de référence pour le skill `hpk-parser`.

## Introduction et présentation du document

## 1 Mécanisme de communication

### ➢ Fonctionnement

Chaque événement concernant un utilisateur pour le serveur d’accréditation ou d’un patient
pour les serveurs d’identité, de mouvement ou d’acte est enregistré dans la base de données
HEXAGONE WEB, et génère un message dans la base ORACLE HEXAGONE WEB.
Ce message est pris en charge par le Service Echange ou Hexaflux qui ont en charge l’envoi de
ce message aux autres applications (celles qui seront référencées). Ce service se charge suivant
le message envoyé d’activer le composant qui nous sera fourni pour chacune des applications
et qui sera en mesure de comprendre et de traiter ce message.
Chaque application reçoit le message et renvoie un accusé de réception. Cette information
servira en cas d’interruption de la communication pour savoir quels sont les messages qui n’ont
jamais été reçus et le cas échéant de les renvoyer.

#### 1.1.1 Processus de communication

Il existe deux types de processus :

1. L’envoi de messages liés à des évènements détectés dans la base HEXAGONE WEB.
    Dans ce cas de figure, l’événement détecté active le Service Echange ou Hexaflux, pour la
    prise en charge du message. Ce dernier renvoie un accusé de réception pour indiquer la
    prise en charge et laisse l’application continuer.
    Un processus permanent sur le serveur scrute en permanence les messages stockés. Pour
    chaque message détecté, la liste des messages par destinataire est créée en prenant en
    compte le composant de communication. Un processus par destinataire est chargé de
    gérer l’expédition pour chaque destinataire, ceci permettant de limiter le temps de
    communication pour chaque application au temps d’exécution du composant de cette
    même application.
    Le composant appelé renvoie ou non un accusé de réception suivant ces fonctionnalités
    propres.
    Les messages sont mis en historiques et épurés en fonction du paramétrage. De même, en
    cas de non réponse des composants externes, la communication sera automatiquement

interrompue après un nombre de tentatives paramétré, et le ou les administrateurs sont
prévenus par courrier électronique.
Il est aussi possible de planifier des arrêts de la communication pour la maintenance, ou
de faire des arrêts immédiats.

2. Les demandes de création des applications externes.

La demande est prise en compte en mode synchrone, et l’information est retournée en
temps réel. L’application HEXAGONE WEB génère des évènements et les gère selon le
principe évoqué ci-dessus, mais en gérant un niveau de priorité maximal pour ce type de
message.

#### 1.1.2 Format des messages

Rubrique Long. Format Oblig. Commentaires
Type 2 S O PR = Produits
FO = Fournisseurs
MA = Marchés
CO = Commandes
RO = Réceptions
FA = Factures
SO = Sorties
IO = Immobilisations Inventaires
RD = Recettes diverses
Message 2 S O Ce message sera fonction du type de
message. Dans la documentation vous
trouverez le détail des messages.
Mode 1 S O C = Création, M = Modification, S =
Suppression.
Emetteur 15 S O HEXAGONE
Date de l’envoi 16 Date O Date de l’envoi au format :
YYYYMMDDHHMISSnn

Individu 50 S O Individu au sens S3A qui a généré le
message.
Le reste est fonction du message.

#### 1.1.3 Normes à respecter lors de la constitution de messages

Il faut impérativement que la partie constante du message (c’est à dire les 6 premières zones)
soit en MAJUSCULES.

Le caractère séparateur des zones est le “ | ” (pipe). Les longueurs indiquées sont des longueurs
maximales. Si le nom du patient est sur 10 caractères on aura :

|NOMPATIENT|

Quand une information n’est pas connue on met le “ | ” séparateur de champ sans aucune
information. Par exemple, si la date de naissance n’est pas connue on aura :

...|IPP_ATIENT|NOM|PRENOM|||D|Mr|...

## Produits

## 2 Création d’un Produit

Uniquement prévu en envoi d’Hexagone WEB vers un autre logiciel.

### ➢ Message 0 : Données générales du produit

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :PR = Produits
**Message** (^2) S O M
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code Produit** (^8) S O Numéro Identifiant Produit (Unique)
**Libellé Court
produit
40** S O Libellé produit (Unique)
**Date début** (^8) S O Date de création du produit :
YYYYMMDD
**Date de fin** (^8) S N Date de fin d’utilisation du produit
**Code pharmacie** (^1) S O **O** si géré par la pharmacie, **N** sinon
**Code CIP** (^13) N N Code CIP associé au produit
**Code ATC** (^7) N N Rattachement à la codification ATC
**Code UCD** (^13) N N Code Unité commune dispensation Obligatoire si
type Médicament

Code
Médicament

1 S N Plus utilisé depuis la version D.02 de GREF

Niveau ATC de
rattachement

1 N N Obligatoire si Code ATC renseigné. Niveau
d’arborescence :
2 si Usage thérapeutique
3 si sous-groupe thérapeutique
4 si sous-groupe chimique
5 si substance chimique

**Code Matériel** (^1) S N Plus utilisé depuis la version D.02 de GREF (Vide)
**Type produit** (^3) S N Type de produit : **MED** = Médicament
**MAT** = Matériel Médical
**DM** = Dispositif Médical
**FIL** = Film Radiologie
**PCO** = Produits de contraste
**CUI** = Cuisine
**LAB** = Laboratoire
**LOG** = Logistique
Champ vide pour autres produits.
**Libellé Long** (^150) S O Libellé long du produit.
**Gestion des lots** (^1) S O Gestion des lots et dates de péremption dans la
Gestion Economique et Financière.
**T** pour Vrai, **F** pour Faux

### ➢ Message 1 : Informations produit pharmacie

Emis si « Code pharmacie » est à O

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :PR = Produits
**Message** (^2) S O M

**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code Produit** (^8) S O Numéro Identifiant Produit (Unique)
**Code Tableau** (^4) S N Code liste valeurs possibles : **1** , **2** , **STUP** ou champ
Vide
**Code forme** (^8) S N Plus utilisé à partir de la version D.03 de GREF
(Vide)
**Catégorie
thérapeutique
4** S N Classification interne de l’établissement pour états
de consommations
**Code RUH** (^1) S O Plus envoyé à partir de la version 9 .0 2 de GREF
(Vide)
**Conditionnement
Unitaire
1** S O Plus envoyé à partir de la version 9 .0 2 de GREF
(Vide)
**Agréé Collectivité** (^1) S O Plus envoyé à partir de la version 9 .0 2 de GREF
(Vide)
**Usage Unique** (^1) S O Matériel à usage unique :
Valeurs **T** pour Vrai, **F** pour Faux
**Code condition
Stérilité
1** S N Code condition de conservation
**Remboursé SS** (^1) S O Plus utilisé à partir de la version D.03 de GREF
(Vide)
**Taux allopathique** (^7) N N **Obligatoire** si Produit Rétrocédé est égal à T.
Valeurs autorisées : **35** , **65** et **100
Attestation** (^1) S O Plus utilisé à partir de la version D.03 de GREF
(Vide)

**Code
Fractionnable**

1 S O Plus utilisé à partir de la version D.03 de GREF
(Vide)

**Taux de
Majoration**

1 N N Obligatoire si produit rétrocédé. Valeurs :
2 si 35%, 4 si 65% et 5 si 100%

**Prix Rétrocession** (^14) N N **Obligatoire** si produit rétrocédé. Le prix est TTC
**Code édition
Livret
1** S O Code édition sur le livret thérapeutique ou non.
Valeurs **T** pour Vrai, **F** pour Faux
**Code Véhicule** (^1) S O Plus utilisé à partir de la version D.03 de GREF
(Vide)
**Code diluable** (^1) S O Plus utilisé à partir de la version D.03 de GREF
(Vide)
**Code Mono
malade
1** S O Plus utilisé à partir de la version D.03 de GREF
(Vide)
**Produit de dilution** (^1) S O Plus utilisé à partir de la version D.03 de GREF
(Vide)
**MDS** (^1) S O Médicament dérivé du sang. Ne peut être à T que
si médicament = **T**. Valeurs T pour Vrai, **F** pour
Faux
**DMI** (^1) S O Dispositif médical Implantable. **T** pour Vrai, **F** pour
Faux
**Code Rétrocédé** (^1) S O Produit pouvant être rétrocédé. **T** pour Vrai, **F**
pour Faux
**Gestion des lots** (^1) S O Gestion des lots et dates de péremption dans la
Gestion Economique et Financière.
**T** pour Vrai, **F** pour Faux
**Durée
prescription
3** N N Plus utilisé à partir de la version D.03 de GREF
(Vide)
**Code Norme B2** (^5) S N **Obligatoire** si produit Rétrocédé
**Code Hors T2A** (^1) S O **T** pour oui, **F** pour Non
**Code LPP** (^13) S N Code transmis pour B2 à partir du 01/01/

Taux majoration
Rétrocession

5 .2 N N Taux de majoration de rétrocession

**Liste traceur** (^1) S N Plus envoyé à partir de la version 9 .0 2 de GREF
(Vide)

### ➢ Message 2 : Informations pour édition livret thérapeutique

Emis uniquement si code Edition livret thérapeutique est à T sur message précédent (message
1)

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :PR = Produits
**Message** (^2) S O M
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code Produit** (^8) S O Numéro Identifiant Produit (Unique)
**Exercice** (^4) S O Exercice de référence
**Code DCI** (^6) S N Code DCI du livret thérapeutique
**Code Regroupé** (^7) S N Ne peut être renseigné que si le code DCI est
renseigné, correspond au dernier niveau du livret
thérapeutique.
**Libellé DCI** (^80) S N Ne peut être renseigné que si le code DCI est
renseigné

### ➢ Message 3 : Informations comptables pour Gestion Economique

Emis si le domaine Gestion Economique et Financière est installé.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :PR = Produits

**Message** (^2) S O M
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code Produit** (^8) S O Numéro Identifiant Produit (Unique)
**Exercice en cours** (^4) N O Exercice comptable en cours dans la Gestion
Economique et Financière
**Code
regroupement
comptable Ex
8** S O Code regroupement comptable de l’exercice en
cours
**Compte d’achat
Ex
13** S O Compte d’achat de l’exercice en cours
Format Lettre budget + Numéro
**Exercice + 1** (^4) N O Exercice comptable + 1 dans la Gestion
Economique et Financière
**Code
regroupement
comptable EX+
8** S O Code regroupement comptable de l’exercice +
**Compte d’achat
EX+
13** S O Compte d’achat de l’exercice +
Format Lettre budget + Numéro
**Code CMP Ex** (^10) S O Code nomenclature code des marchés public
exercice en cours
**Code CMP Ex + 1** (^10) S O Code nomenclature code des marchés publics
exercice + 1
**Code E/S** (^1) S O Code Entrée / Sortie simultanée : Valeur **T** ou **F
Code Stock** (^1) S O Code produit stocké **T** / **F
Code gratuit** (^1) S O Produit gratuit ou pas. Valeurs T pour True, F pour
False.

**CLADIMED** (^7) S N Code CLADIMED
Disponible si le type du produit est DM (dispositif
médical)
**CLADIMED Ex+1** (^7) S N Code CLADIMED Exercice+ 1
Disponible si le type du produit est DM (dispositif
médical)
**Code E/S Ex + 1** (^1) S O Code Entrée / Sortie simultanée : Valeur **T** ou **F**
Exercice + 1
**Code Stock Ex + 1** (^1) S O Code produit stocké **T** / **F**
Exercice + 1
**Nomenclature
d’achat EX**
(^8) S N Nomenclature d’achat exercice en cours
**Nomenclature
d’achat EX + 1**
(^8) S N Nomenclature d’achat exercice + 1
**EMDN Ex** (^13) S N EMDN exercice en cours
**EMDN Ex + 1** (^13) S N EMDN exercice + 1

### ➢ Message 4 : Informations générales pour Gestion Economique

Emis si le domaine Gestion Economique et Financière est installé.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :PR = Produits
**Message** (^2) S O M
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.

**Code Produit** (^8) S O Numéro Identifiant Produit (Unique)
**Code Famille** (^5) S O Famille de rattachement du produit
**Code E/S** (^1) S O Plus envoyé à partir de la version 9 .0 2 de GREF
(Vide)
**Code TVA** (^2) N O Code TVA associé au produit, le taux associé est
dans la table HXTVA
**Code Unité de
gestion
5** S O Code Unité de gestion de stock, existe dans Table
HXUNDIST
**Stock minimum** (^14) N N Plus utilisé en Version D.01 : report sur Magasin
(Vide)
**Stock maximum** (^14) N N Plus utilisé en Version D.01 : report sur Magasin
(Vide)
**Seuil de
commande
14** N N Plus utilisé en Version D.01 : report sur Magasin
(Vide)
**Dernier PU
facturé Hors
taxe
13** N N Décimalisé à 4
**Pourcentage
alerte
6** N N Pourcentage d’alerte sur le PU facturé. Décimalisé
à 2
**PMP** (^13) N N Dernier prix moyen pondéré connu. Décimalisé à
4
**Code gratuit** (^1) S O Plus utilisé en Version D.01 : report sur Magasin
(Vide)
**Code décimalisé** (^1) S O Quantité pouvant être décimalisée ou pas.
Valeurs : **O** pour Vrai, **N** pour Faux
**Code Stock** (^1) S O Plus utilisé en Version D.01 : report sur Magasin
(Vide)
**Date fin
commande
8** Date N Date d’arrêt de saisie de commande. Format
YYYYMMDD
**Code fabriqué** (^1) S O Code produit Fabriqué. **T** pour Vrai, **F** pour Faux
**Code
préconisation
1** S O Produit à utiliser dans la préconisation de
commande. Valeur **O** pour Vrai, **N** pour Faux

Qté
consommation
forcée

14 N N Quantité de consommation forcée pour
préconisation. Décimalisée à 3

**Famille article 27** (^4) N N Plus utilisé à partir de _la version D.0_ 2 _de GEF_ (Vide)
**Code Unité de
transfert
5** S F Code de l’unité de réapprovisionnement des
armoires ou magasins annexes.
**Nombre d’unités
de Gestion pour
l’unité de
Transfert
3** N F Equivalent en Nombre d’unités de gestion dans
l’unité de transfert.
**Gestion numéro
de série
1** S N Gestion numéro de série (F/T)
**Gestion
demande service
1** S N Gestion demande service (F/T)
T : le produit peut être saisi sur les demandes de
services
**Date dernier P.U.
facturé H.T.
10** Date N Date de la mise à jour du dernier prix unitaire
(date de facture)

### ➢ Message 5 : Informations sur les magasins par produit

Emis si le domaine Gestion Economique et Financière est installé.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :PR = Produits
**Message** (^2) S O M
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code Produit** (^8) S O Numéro Identifiant Produit (Unique)

**Exercice
comptable**

4 N O Exercice de gestion

**UF Magasin** (^4) N O UF magasin de stockage
**Armoire** (^4) S N Code armoire de l’UF de stockage
**Code transfert** (^1) S O Code produit autorisé pour les transferts entre
magasins. Valeurs **T** pour Vrai, **F** pour Faux
**Nombre jours
couverture
3** N N Nombre de jours de couverture (préconisation)
**Nombre de jours
de sécurité
3** N N Nombre de jours de sécurité (préconisation)
**Quantité en
dotation
14** N N Quantité de dotation fixée pour alimentation des
magasins annexes ou armoires. Décimalisée à 3
**Lieu de stockage** (^10) S N Identification du lieu de stockage dans le magasin
**Stock minimum** (^14) N N Quantité stock mini (préconisation si magasin
principal ou réapprovisionnement si annexe).
Décimalisé à 3
**Stock maximum** (^14) N N Quantité en stock maximum. Décimalisé à 3
**Quantité seuil de
commande
14** N N Quantité à commander (si préconisation en
quantité)
**Nombre de jours
mini de stock
pour réappro.
3** N N Nombre de jours minimum de stock avant
réapprovisionnement
**Nombre de jours
de réappro.
3** N N Nombre de jours de réapprovisionnement.
**Gestion produit
Plein/vide
1** S N Produit géré en plein/vide : T si gestion produit en
Plein/vide
**Gestion
Quantité/Valeur
1** S N Pour magasin principal, préconisation en Jours ou
en Quantité (J ou Q), pour les annexes
réapprovisionnements en Jours ou Quantité (J ou
Q)

## 3 Modification sur produit

Mêmes messages que les messages de création dès qu’une information est modifiée avec un
mode « MODIFICATION ». Seul le message sur lequel une modification est apportée est émis.

## 4 Suppression d'un produit

Message émis lors de la saisie d’une date de fin sur le produit.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :PR = Produits
**Message** (^2) S O M
**Mode** (^1) S O S
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code Produit** (^8) S O Numéro Identifiant Produit (Unique)
**Date de fin** (^8) Date O Date de fin d’utilisation du produit YYYYMMDD

## Fournisseurs

## 1 Création / Modification / Suppression d'un fournisseur

Uniquement prévu en envoi d’Hexagone WEB vers un autre logiciel.

### ➢ Message 1 : Informations générales liées au fournisseur

Message obligatoire en création de fournisseur.

Rubrique Long. Format Oblig. Commentaires
Type 2 S O Type du message :FO : Fournisseur
Message 2 S O M
Mode 1 S O C
Emetteur 15 S O HEXAGONE
Date de l’envoi 16 Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
Individu
(émetteur du
message)

50 S O Individu au sens S3A qui a généré le message.

Code
Fournisseur

6 S O Numéro Identifiant Fournisseur (Unique)

Code divers
(O/N)

1 S O Code permettant de regrouper des fournisseurs
occasionnels sous un même code divers. Dans ce
cas, toutes les informations utiles dans la pièce
comptable associée à ce code sont
obligatoirement transmises. Valeurs autorisées :
O pour divers, N pour fournisseur identifié.
Raison sociale 38 S O Raison sociale du fournisseur en Majuscules
Adresse 1 38 S N Complément destinataire
Adresse 2 38 S N N° Voie et voie
Code postal 5 N O Code postal

**Ville 38** S O Obligatoire majuscule

**Bureau
distributeur**

27 S O
**No téléphone 16** S N No téléphone du fournisseur

**No de Fax 16** S N No de Fax

**No de client 20** S N No de client de l’établissement chez le fournisseur

**Compte tiers
exploit.**

12 N O No de compte de tiers pour les factures sur la
section d’exploitation.

**No de SIRET 14** S N No de SIRET du fournisseur

**Compte de
tiers
investissement**

12 N O No de compte de tiers pour les factures sur la
section d’investissement

**Code APE 4** S N Code APE du fournisseur

**Délai de
paiement**

3 N N Nombre de jours pour le délai de paiement des
factures de ce fournisseur

**Date de début 8** Date O Date de début d’utilisation de ce fournisseur.
Format YYYYMMDD

**Date de fin 8** Date N Date de fin d’utilisation de ce fournisseur. Format
YYYYMMDD

**Code
regroupement
facture**

1 S O Code permettant d’indiquer si on peut regrouper
plusieurs factures sur les mandats pour ce
fournisseur.. Valeurs T pour Vrai, F pour faux

**Code
concurrentiel**

1 S O Code fournisseur concurrentiel ou pas. T pour
Vrai, F pour faux

**Adresse EMAIL 255** S N Adresse EMAIL de la Maison Mère

**Type de
fournisseur**

10 S N Type de fournisseur

**Adresse 3 38** S N Complément d’adresse

**Type d’adresse 1** S O Adresse ( **P** )rincipale/( **S** )econdaire

**Code pays 3** S O Code pays

**Résident 1** S O Résident en france ( **F** / **T** )

Complément
du nom

38 S N Complément du nom

Prénom 38 S N Prénom
Civilité 10 S N Civilite : MR, MME, MELLE
Nature
identifiant

2 S N Nature de l'identifiant du tiers
exemple : 00 Aucun, 01 SIRET, 02 SIREN, 03
FINESS, 04 NIR, 05 TVAIntraCo, 06 Hors UE, 07
Tahiti, 08 RIDET (Nouvelle Calédonie), 09 En cours
d'immatriculation,10 FRWF, 11 IREP (Identification
des personnes physiques), 12 NFP (Numéro des
finances publiques)
Identifiant du
tiers

18 S N Identifiant du tiers
N° SIREN, SIRET, FINESS ou autre ....
Catégorie du
tiers

2 S O Catégorie du tiers

Nature
juridique du
tiers

2 S O Nature juridique du tiers

**Franco de Port** (^13) N N Décimalisé à 2, montant franco de port

### ➢ Message 2 : Domiciliations bancaires liées au fournisseur

Remarque : Il existe au minimum une domiciliation bancaire par fournisseur, sauf pour les
fournisseurs divers.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :FO : Fournisseur
**Message** (^2) S O M2
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn

Individu
(émetteur du
message)

50 S O Individu au sens S3A qui a généré le message.

Code
Fournisseur

6 S O Numéro Identifiant Fournisseur (Unique)

No de
domiciliation

2 N O Numéro de domiciliation bancaire de 01 à 99

**Clé RIB** (^2) N O Clé RIB associée à la domiciliation bancaire 2
Chiffres
**No de compte
bancaire
11** S O No du compte bancaire. Lettres uniquement si
CCP
**Code banque** (^5) N O 5 chiffres obligatoires.
**Code guichet** (^5) N O 5 chiffres obligatoires.
**Libellé agence** (^24) S N Libellé de l’agence bancaire
**Titulaire** (^32) S O Titulaire du compte bancaire. Majuscules
**Mode de
règlement
1** S O Mode de règlement de la domiciliation, existe
dans la table HXFOUREG
**Nature** (^1) S O E pour domiciliation Etrangère, F pour française
**Date de fin** (^8) Date N Date de fin de validité de la domiciliation bancaire
**Mode de
réglement PES
2** S O Mode de règlement PES

### ➢ Message 3 : Points de commande liés au fournisseur

Remarque : Il existe au minimum un point de commande par fournisseur, sauf pour les
fournisseurs divers.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :FO : Fournisseur
**Message** (^2) S O M3
**Mode** (^1) S O C

**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu (émetteur
du message)
50** S O Individu au sens S3A qui a généré le message.
**Code Fournisseur** (^6) S O Numéro Identifiant Fournisseur (Unique)
**No de point de cde** (^2) N O Numéro de point de commande 01 à 99
**Dénomination** (^38) S O Majuscules. Dénomination du point de
commande
**Adresse 1** (^38) S N Adresse 1 du point de commande
**Adresse 2** (^38) S N Suite adresse
**Ville** (^38) S N Ville du point de commande
**Code postal** (^5) N O Code postal du point de commande. 5 chiffres
obligatoires
**Bureau
distributeur
27** S N Bureau distributeur point de commande
**Nom contact** (^35) S N Nom du représentant
**No téléphone** (^16) S N No de téléphone associé
**No fax** (^16) S N No de fax associé
**Franco de Port** (^13) N N Décimalisé à 2, montant franco de port
**Adresse EMAIL** (^255) S N Adresse EMAIL du point de commande
**Code Robot EDI** (^35) S N Obligatoire si EDI liaison avec HOSPITALIS
**Montant minimum
de commande
autorisé
16** N N Montant minimum de commande autorisé (Dont
2 décimale)
**Complément
d’adresse
36** S N Complément d’adresse
**Type d’adresse 1** S O Adresse ( **P** )rincipale/( **S** )econdaire
**Code pays 3** S O Code pays
**Résident 1** S O Résident en france ( **F** / **T** )

Complément du
nom

38 S N Complément du nom

Prénom 38 S N Prénom
Civilité 10 S N Civilite : MR, MME, MELLE

## 2 Modification Fournisseurs

Mêmes messages que les messages de création dès qu’une information est modifiée avec un
mode « MODIFICATION »

## 3 Suppression fournisseur

### ➢ Message 1 : suppression d’un fournisseur

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :FO : Fournisseur
**Message** (^2) S O M1
**Mode** (^1) S O S
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code
Fournisseur
6** S O Numéro Identifiant Fournisseur (Unique)
**Date de fin** (^8) Date O Date de fin d’utilisation du fournisseur format
YYYYMMDD

### ➢ Message 2 : Suppression d’une domiciliation bancaire

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :FO : Fournisseur
**Message** (^2) S O M2
**Mode** (^1) S O S
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code
Fournisseur
6** S O Numéro Identifiant Fournisseur (Unique)
**No de
domicilation
3** N O No de domiciliation bancaire supprimée
**Date de fin** (^8) Date O Date de fin d’utilisation de la domiciliation
bancaire format YYYYMMDD

## Liens Produits / Fournisseurs

## 1 Création / Modification / Suppression d'un lien

Uniquement prévu en envoi d’Hexagone WEB vers un autre logiciel

### ➢ Message 1 : Informations générales liées au lien

Message existant si le lien Produit / Fournisseur est saisi dans le domaine Gestion Economique
et Financière

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message : FP : Fournisseur / Produit.
**Message** (^2) S O M1
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Code Fournisseur** (^6) S O Numéro Identifiant Fournisseur (Unique)
**Code produit** (^8) S O Code identifiant produit
**Date de création** (^8) Date O Format YYYYMMDD
**PU Hors taxe Fixé** (^13) N N Prix fixé fournisseur **hors** marché. Décimalisée à 4
**Quantité
minimum de
commande
14** N N Quantité minimum à commander. Décimalisée à 3
**Code Unité de
conditionnement
5** S N Code unité de conditionnement du fournisseur,
existe dans la table HXUNDIST
**Nombre d’unités** (^14) N N Nombre d’unités de gestion dans l’unité de
conditionnement du fournisseur. Décimalisé à 3

**Délai de livraison** (^3) N N Nombre de jours pour délai de livraison.
**Code fournisseur
principal
1** S O Fournisseur principal du produit. Valeurs T pour
Vrai, F pour Faux.
**No de point de
commande
2** N O Par défaut 01. Point de commande habituel pour
le produit.
**Référence du
produit chez le
fournisseur
1024** S N Texte permettant l’identification du produit chez le
fournisseur, il sera repris sur les bons de
commande
**Référence
fournisseur
30** S N Références exactes du produit chez le fournisseur
sans annotation personnelle.
**Code fabricant** (^13) S N Code fabricant lié au LPPR (liste des produits et
prestations remboursables, ancien nom LPP).
**No de marché** (^6) N N No de marché attribué par l’établissement.
Renseigné uniquement si le message est envoyé
depuis la saisie des marchés/avenants ou sur la
saisie du lien produit/fournisseur pour le
fournisseur principal.

### ➢ MESSAGE 2 : INFORMATIONS GENERALES LIEES AU LIEN PRODUIT FOURNISSEUR

### CIP

Message existant si le lien Produit / Fournisseur/CIP est saisi dans le domaine Gestion
Economique et Financière. N’existe que pour les produits de type « MED – Médicament »

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message : FP : Fournisseur / Produit.
**Message** (^2) S O M2
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn

**Individu
(émetteur du
message)**

50 S O Individu au sens S3A qui a généré le message.

**Code Fournisseur** (^6) S O Numéro Identifiant Fournisseur (Unique)
**Code produit** (^8) S O Code identifiant produit
**Code Unité de
conditionnement
5** S N Code unité de conditionnement du fournisseur,
existe dans la table HXUNDIST
**Nombre d’unités** (^14) N N Nombre d’unités de gestion dans l’unité de
conditionnement du fournisseur. Décimalisé à 3
**Code CIP** (^13) S O Code CIP associé au produit pour le fournisseur
**Code CIP par
défaut
1** S O Code par défaut du produit. Un lien produit
fournisseur peut avoir plusieurs CIP.
Valeurs T pour Vrai, F pour Faux.

## Gestion des Marchés

## 1 Création d’un marché dans la Gestion Economique et Financière

Ces enregistrements sont uniquement envoyés par un logiciel de Gestion de Marchés dans la
Gestion Economique et Financière.

Les fournisseurs doivent obligatoirement exister dans Hexagone WEB : si tel n’est pas le cas, le
marché sera rejeté.

### ➢ Message 1 : Entête de Marché

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :MT : Marchés Transmis
**Message** (^2) S O M1
**Mode** (^1) S O C
**Emetteur** (^15) S O Nom de l’émetteur (ex : EPICURE)
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**No de marché** (^8) S O No de marché attribué par le logiciel émetteur.
**ATTENTION dans la Gestion Economique et
Financière :** No sur 6 en numérique avec les 2
premiers correspondants à l’exercice (exemple sur
2003, no 030001)
**Code fournisseur** (^6) S O Doit exister dans Hexagone WEB
**Raison sociale** (^38) S O Doit exister dans Hexagone WEB
**Code banque** (^5) N O Doit exister dans les domiciliations bancaires
fournisseur

**Code guichet** (^5) N O Doit exister dans les domiciliations bancaires
fournisseur
**No du compte
bancaire
11** S O Doit exister dans les domiciliations bancaires
fournisseur
**Clé RIB** (^2) N O Doit exister dans les domiciliations bancaires
fournisseur
**Délai de
Paiement
3** N N Nombre de jours. Compris entre 001 et 999
**Date de
Consultation
8** Date O Date de lancement de la consultation du marché.
Format YYYYMMDD
**Date de
Notification
8** Date O Date de notification au titulaire. Format
YYYYMMDD
**Date début de
marché
8** Date O Format YYYYMMDD
**Date de fin
marché
8** Date O Format YYYYMMDD
**Marché alloti** (^1) S O **T** : pour marché alloti, **F** sinon
**Nbre de lots** (^4) N N Si marché alloti, donne le nombre de lots associés
**Marché à bon de
commande 1** S^ O^ Valeurs **F**^ pour Non, **T**^ pour Oui^
**Reconductible** (^1) S O Valeurs **F** pour Non, **T** pour Oui
**Nbre de
reconductions
3** N O Obligatoire sir code « Reconductible » est à T.
Compris entre 001 et 999.
**Gestion Interne** (^1) S O Valeur F pour Non, T pour Oui.
**Pourcentage
maxi de blocage
5** N N Décimalisé à 2.
**Type de marché** (^1) S O Permet d’identifier les contrôles associés. Valeurs
autorisées :
M : Mixte
C : Négocié sans concurrence
T : Travaux
A : Article 30

U : Besoin unique
N : Autres

**Nature** (^1) S O Obligatoire si type = ‘T’(Travaux). Valeurs
autorisées :
T : Opération de Travaux
O : Ouvrage
Si type de marché différent de ‘T’: valeur N
**Code CMP
dominant
10** S F Obligatoire si type marché = ‘M’.
**Groupement
d’achat
1** S O T si marché dans le cadre d’un groupement
d’achat, F si marché propre à l’établissement.
**Taux des
Intérêts
moratoires
5** N F Numérique décimalisé à 2. Taux spécifique pour le
marché
**Code IBAN** (^34) S N Code IBAN ( _International Bank Account Number_ .)
**Code BIC** (^11) S N Code BIC ( _Bank Identifier Code_ .)
**Mini/Maxi (O/N)** (^1) S O Marché en Mini/Maxi
F pour non, T pour oui
**Gpt Achat (O/N)** (^1) S O Marché en groupement d’achat
F pour non, T pour oui
**Accord cadre
(O/N)
1** S O Marché accord cadre
F pour non, T pour oui
**Marché
subséquent
(O/N)
1** S O Marché subséquent
F pour non, T pour oui
**Montant
minimum de
commande
9** N N Montant minimum de commande
**Franco de port** (^9) N N Monétaire décimalisé à 2 (montant HT)
**Montant HT du
Marché
11** N O Monétaire décimalisé à 2 (par n° de marché)
Si Marché en Mini/Maxi, Montant maxi HT

par n° de marché, par fournisseur
Montant TTC du
Marché

11 N O Monétaire décimalisé à 2 (par n° de marché)
Si Marché en Mini/Maxi, Montant maxi TTC
par n° de marché, par fournisseur
Date de début de
période

8 Date O Date de début de période. Format YYYYMMDD

Date de fin de
période

8 Date O Date de fin de période. Format YYYYMMDD

Durée de la
période

2 N O Nombre de mois de la période

Type de
procédure

2 S O Type de procédure à saisir avant l’export

Remarque : Si le marché porte sur plusieurs fournisseurs, on aura autant d’enregistrements

que de fournisseurs différents avec le même numéro de marché.

### ➢ Message 2 : Lignes de Marché transmises

Si le code produit et le compte n’existe pas, la procédure de génération de marchés dans
Gestion Economique et Financière permettra la saisie sur ces lignes d’un code produit ou d’un
compte (hors consommables). Le produit doit alors avoir été créé dans Hexagone WEB, pour
pouvoir être associé à la ligne de marché.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :MT : Marchés Transmis
**Message** (^2) S O M2
**Mode** (^1) S O C
**Emetteur** (^15) S O Nom de l’émetteur : (Ex EPICURE)
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn

**Individu
(émetteur du
message)**

50 S O Individu au sens S3A qui a généré le message.

**No de marché** (^8) S O No de marché attribué par le logiciel émetteur
**ATTENTION dans la Gestion Economique et
Financière :** No sur 6 en numérique avec les 2
premiers correspondants à l’exercice (exemple sur
2003, no 030001)
**No ligne de
marché
3** N O No de ligne
**No de lot** (^4) N N Obligatoire si marché alloti^
**Type de besoin** (^1) S N pour normal, U pour marché^ de type besoin
unique. Cette valeur est associée au lot
**Code produit** (^8) S N Obligatoirement renseigné si ligne sur produit
**Compte
ordonnateur
13** S N Obligatoirement renseigné si ligne sur compte
(marché hors consommables)
**Quantité
minimum
retenue
14** N N Quantité minimum pour les marchés à bon de
commande Décimalisée à 3
**Quantité
moyenne
14** N N Quantité moyenne. Décimalisée à 3. Non utilisée
dans la Gestion Economique et Financière
**Quantité
maximum
retenue
14** N N Quantité maximum pour les marchés à bon de
commande Décimalisée à 3. Non utilisée dans la
Gestion Economique et Financière
**PU Hors taxe** (^13) N N Prix unitaire Hors taxe ligne Décimalisé à 4
**Date révision
prix
8** Date N Date de révision éventuelle du prix format
YYYYMMDD
**Taux de TVA
ligne
5** N O Le taux de TVA est obligatoire. Il doit exister dans
les tables d’HEXAGONE WEB Décimalisé à 2
**Taux Taxe
supplémentaire
5** N N Si un taux est indiqué, le taux de TVA+le taux de
Taxe doit exister sans les tables des taux
Hexagone WEB. Décimalisé à 2
**Désignation
ligne
70** S O Désignation de la ligne^

**Code CMP** (^10) S O Obligatoire code nomenclature du nouveau code
des marchés publics.
**Quantité
minimum
livrable
14** N N Décimalisée à 3. Permettra d’alimenter le lien
produit/fournisseur si information présente
**Quantité unités
gratuites
14** N N Décimalisée à 3.^
**Code Interne ou
Externe
1** S N Obligatoire si quantité unités gratuites
renseignée. Valeur I si la quantité gratuite est
comprise dans la quantité négociée. Valeur E si la
quantité gratuite non comprise dans la quantité
négociée.
**Quantité
négociée
14** N O Quantité négociée sur la ligne.^
**N° de sous-lot** (^3) N O Numéro de sous lot^
**Mode de calcul** (^1) S O «^0 »^ : Montant Ignoré^
« 1 » : Calcul d’une moyenne
« 2 » : Calcul d’une somme
Rupture sur N° ligne de marché+N°lot+N°sous
lot :
Montant proposé =
Cumul de tous les produits au mode de calcul
« Somme »
+
Moyenne de tous les produits au mode de calcul
« Moyenne »
**Code fournisseur** (^6) S O Doit exister dans Hexagone WEB (10 car maxi
dans Epicure+)
**Code classe** (^6) S N Code classe^
**Libellé classe** (^100) S N Libellé classe^
**Conditionnemen
t
9** N N Conditionnement (en nbre d’unité)^
**Régime de prix** (^4) S N Régime de prix (exemple «^ Aju.^ », «^ Rév.^ », «^ Fer.^ »,
« F- 6 », « F- 12 », « F- 24 », ... « F- 99 »). La valeur
numérique pour « F- » est comprise entre 1 et 99.
**Mercuriale (O/N)** (^1) S N Prix fixé sur un cours^
F pour non, T pour oui
**Code UCD** (^13) S N Code UCD^
**Code CIP** (^13) S N Code CIP^

**Code DCI** (^20) S N Code DCI^
**Code ATC** (^7) S N Code ATC^
**Code EAN** (^16) S N Code EAN^
**Code CIS** (^8) S N Code CIS^
**Code AMM** (^11) S N Code AMM^
**Code LPPR** (^7) S N Code LPPR^
**Réf. Fournisseur** (^20) S N Référence du produit dans le catalogue du
fournisseur
**Libellé
Nomenclature
150** S N Libellé nomenclature^
**Code Unité** (^3) S N Code de l'unité (exemple : UN / FL / KG...)^
Une table des unités « par défaut » est proposée
avec Epicure +. Mais cette table est modifiable
par l'établissement.
**Libellé Unité** (^15) S N Libellé de l'unité (exemple : UN / FL / KG...)^
Une table des unités « par défaut » est proposée
avec Epicure +. Mais cette table est modifiable
par l'établissement.

## EPICURE (web) 2 Création d’un marché dans la Gestion Economique et Financière avec la nouvelle interface

## NOUVELLE INTERFACE EPICURE (WEB)

Ces enregistrements sont uniquement envoyés par un logiciel de Gestion de Marchés dans la
Gestion Economique et Financière.

Les fournisseurs doivent obligatoirement exister dans Hexagone WEB: si tel n’est pas le cas, le
marché sera rejeté.

### ➢ Message 1 : Entête de Marché

Rubrique Long. Forma
t

Obli
g.

Commentaires

Type 2 S O Type du message :MT : Marchés Transmis
Message 2 S O M1

**Mode 1** S O C

**Emetteur 15** S O Nom de l’émetteur (ex : EPICURE)

**Date de l’envoi 16** Date^ O Date de l’envoi au format :

YYYYMMDDHHMISSnn

**Individu
(émetteur du
message)**

50 S O Individu au sens S3A qui a généré le message.

**No de marché 8** S O No de marché attribué par le logiciel émetteur.

ATTENTION dans la Gestion Economique et
Financière : No sur 6 en numérique avec les 2
premiers correspondants à l’exercice (exemple sur
2003, no 030001)

**Code
fournisseur**

6 S O Doit exister dans Hexagone WEB

**Raison sociale 38** S O Doit exister dans Hexagone WEB

**Code banque 5** N O

**Code guichet 5** N O

**No du compte
bancaire**

11 S O
**Clé RIB 2** N O

**Délai de
Paiement**

3 N N Nombre de jours. Compris entre 001 et 999

**Date de
Consultation**

8 Date O Date de lancement de la consultation du marché.
Format YYYYMMDD

**Date de
Notification**

8 Date O Date de notification au titulaire. Format
YYYYMMDD

**Date début de
marché**

8 Date O Format YYYYMMDD

**Date de fin
marché**

8 Date O Format YYYYMMDD

**Marché alloti 1** S O T : pour marché alloti, F sinon

**Nombre de lots**

**(retenus)**

4 N N Si marché alloti, donne le nombre de lots associés

**Marché à bon
de commande**

1 S O Valeurs F pour Non, T pour Oui

**Reconductible 1** S O Valeurs F pour Non, T pour Oui

**Nombre de
reconductions**

3 N O Obligatoire sir code « Reconductible » est à T.
Compris entre 001 et 999.

**Gestion
Interne**

1 S O Valeur F pour Non, T pour Oui.

**Pourcentage
maxi de
blocage**

5 N N Décimalisé à 2.

**Type de
marché**

1 S N Positionnement non utilisé dans cette version

**Nature 1** S N Positionnement non utilisé dans cette version

**Code CMP
dominant**

10 S F Obligatoire si type marché = ‘M’.

**Groupement
d’achat**

1 S O T si marché dans le cadre d’un groupement
d’achat, F si marché propre à l’établissement.

**Taux des
Intérêts
moratoires**

5 N F Numérique décimalisé à 2. Taux spécifique pour le
marché

**Code IBAN 34** S N Code IBAN ( _International Bank Account Number_ .)

**Code BIC 11** S N Code BIC ( _Bank Identifier Code_ .)

**Mini/Maxi
(O/N)**

1 S O Marché en Mini/Maxi
F pour non, T pour oui

**Gpt Achat
(O/N)**

1 S O Marché en groupement d’achat
F pour non, T pour oui

**Accord cadre
(O/N)**

1 S O Marché accord cadre
F pour non, T pour oui

**Marché
subséquent
(O/N)**

1 S N Marché subséquent
F pour non, T pour oui (non utilisé actuellement)

**Montant
minimum de
commande**

9 N N Montant minimum de commande

**Franco de port 9** N N Monétaire décimalisé à 2 (montant HT)

**Montant HT du
Marché**

11 N O Monétaire décimalisé à 2 (par n° de marché)
Si Marché en Mini/Maxi, Montant maxi HT
par n° de marché, par fournisseur

**Montant TTC
du Marché**

11 N O Monétaire décimalisé à 2 (par n° de marché)
Si Marché en Mini/Maxi, Montant maxi TTC
par n° de marché, par fournisseur

**Date de début
de période**

8 Date N Date de début de période. Format YYYYMMDD
(non utilisé actuellement)

**Date de fin de
période**

8 Date N Date de fin de période. Format YYYYMMDD (non
utilisé actuellement)

**Durée de la
période**

2 N O Nombre de mois de la période

**Type de
procédure**

2 S O Type de procédure à saisir avant l’export

**Caractéristique
s du marché**

1 S O Caractéristiques M = mixte, C = négocié sans
concurrence, A = article 30, N = aucune
caractéristique (normal)
Obligatoirement à N si Nature = T

**Type de
marché**

1 S O Types T = travaux, F = fourniture, S = service
Obligatoirement à T si nature = T

**Nature 1** S O Nature du marché T = travaux, B = à bon de
commande, A = autre

**Distribué 1** S O Distribué par un fournisseur principal (F our non,
T pour oui)

Remarque : Si le marché porte sur plusieurs fournisseurs, on aura autant d’enregistrements

que de fournisseurs différents avec le même numéro de marché.

### ➢ Message 2 : Lignes de Marché transmises

Si le code produit et le compte n’existe pas, la procédure de génération de marchés dans la
Gestion Economique et Financière permettra la saisie sur ces lignes d’un code produit ou d’un
compte (hors consommables). Le produit doit alors avoir été créé dans Hexagone WEB, pour
pouvoir être associé à la ligne de marché.

**Rubrique** (^) **Long. Forma
t
Obli
g.
Commentaires
Type** (^2) S O Type du message :MT : Marchés Transmis
**Message** (^2) S O M2
**Mode** (^1) S O C
**Emetteur** (^15) S O Nom de l’émetteur : (Ex EPICURE)
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu (émetteur
du message)
50** S O Individu au sens S3A qui a généré le message.
**No de marché** (^8) S O No de marché attribué par le logiciel émetteur
**ATTENTION dans la Gestion Economique et
Financière :** No sur 6 en numérique avec les 2
premiers correspondants à l’exercice (exemple sur
2003, no 030001)
**No ligne de marché** (^3) N O No de ligne
**No de lot** (^4) N N Obligatoire si marché alloti^
**Type de besoin** (^1) S N pour normal, U pour marché de type besoin
unique. Cette valeur est associée au lot
**Code produit** (^8) S N Obligatoirement renseigné si ligne sur produit
**Compte
ordonnateur
13** S N Obligatoirement renseigné si ligne sur compte
(marché hors consommables)

**Quantité minimum
retenue**

14 N N Quantité minimum pour les marchés à bon de
commande Décimalisée à 3

**Quantité moyenne** (^14) N N Quantité moyenne. Décimalisée à 3. Non utilisée
dans la Gestion Economique et Financière
**Quantité maximum
retenue
14** N N Quantité maximum pour les marchés à bon de
commande Décimalisée à 3. Non utilisée dans la
Gestion Economique et Financière
**PU Hors taxe** (^13) N N Prix unitaire Hors taxe ligne Décimalisé à 4
**Date révision prix** (^8) Date N Date de révision éventuelle du prix format
YYYYMMDD
**Taux de TVA ligne** (^5) N O Le taux de TVA est obligatoire. Il doit exister dans
les tables d’HEXAGONE WEB Décimalisé à 2
**Taux Taxe
supplémentaire
5** N N Si un taux est indiqué, le taux de TVA + le taux de
Taxe doit exister sans les tables des taux
Hexagone WEB. Décimalisé à 2
**Désignation ligne** (^70) S O Désignation de la ligne^
**Code CMP** (^10) S O Obligatoire code nomenclature du nouveau code
des marchés publics.
**Quantité minimum
livrable
14** N N Décimalisée à 3. Permettra d’alimenter le lien
produit/fournisseur si information présente
**Quantité unités
gratuites
14** N N Décimalisée à 3.^
**Code Interne ou
Externe
1** S N Obligatoire si quantité unités gratuites
renseignée. Valeur I si la quantité gratuite est
comprise dans la quantité négociée. Valeur E si la
quantité gratuite non comprise dans la quantité
négociée.
**Quantité négociée** (^14) N O Quantité négociée sur la ligne.^
**N° de sous-lot** (^3) N N Numéro de sous lot (non utilisé actuellement)^
**Mode de calcul** (^1) S N «^0 »^ : Montant Ignoré^
« 1 » : Calcul d’une moyenne
« 2 » : Calcul d’une somme
Rupture sur N° ligne de marché + N°lot + N°sous
lot :
Montant proposé =

Cumul de tous les produits au mode de calcul
« Somme »
+
Moyenne de tous les produits au mode de calcul
« Moyenne »
(non utilisé actuellement)

**Code fournisseur** (^6) S O Doit exister dans Hexagone WEB (10 car maxi
dans Epicure+)
**Code classe** (^6) S N Code classe (non utilisé actuellement)^
**Libellé classe** (^100) S N Libellé classe (non utilisé actuellement)^
**Conditionnement** (^9) N N Conditionnement (en nombre d’unité)^
**Régime de prix** (^4) S N Régime de prix (exemple «^ Aju.^ », «^ Rév.^ », «^ Fer.^ »,
« F- 6 », « F- 12 », « F- 24 », ... « F- 99 »). La valeur
numérique pour « F- » est comprise entre 1 et 99.
(non utilisé actuellement)
**Mercuriale (O/N)** (^1) S N Prix fixé sur un cours^
F pour non, T pour oui
(non utilisé actuellement)
**Code UCD** (^13) S N Code UCD^
**Code CIP** (^13) S N Code CIP^
**Code DCI** (^20) S N Code DCI (non utilisé actuellement)^
**Code ATC** (^7) S N Code ATC (non utilisé actuellement)^
**Code EAN** (^16) S N Code EAN^
**Code CIS** (^8) S N Code CIS (non utilisé actuellement)^
**Code AMM** (^11) S N Code AMM^
**Code LPPR** (^7) S N Code LPPR^
**Réf. Fournisseur** (^20) S N Référence du produit dans le catalogue du
fournisseur
**Libellé
Nomenclature
150** S N Libellé nomenclature^
(non utilisé actuellement)
**Code Unité** (^3) S N Code de l'unité (exemple : UN / FL / KG...)^
Une table des unités « par défaut » est proposée
avec Epicure +. Mais cette table est modifiable
par l'établissement.
**Libellé Unité** (^15) S N Libellé de l'unité (exemple : UN / FL / KG...)^
Une table des unités « par défaut » est proposée
avec Epicure +. Mais cette table est modifiable
par l'établissement.

## 3 Transmission des consommations des produits

Ces enregistrements sont uniquement envoyés par la Gestion Economique et Financière pour
un logiciel extérieur.
Ces messages sont notamment destinés à alimenter les logiciels de gestion des marchés avec
les consommations des produits stockés constatées dans Hexagone WEB, pour un magasin
donné, sur une période donnée.

### ➢ Message 1 : Consommations par produit

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :
MC : Consommations des produits stockés
**Message** (^2) S O M1
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**UF Magasin** (^4) N O Code UF magasin sélectionné lors de l’extraction
**Code produit** (^8) S O Code du produit dans HEXAGONE WEB
**Libellé produit** (^40) S O Libellé du produit dans Hexagone WEB
**Unité de gestion** (^5) S O Ex : BTE, CP, UN ; CARTON. Dans Hexagone WEB
table de paramétrage propre au site.
**Quantité
consommée sur
la période
14** N O Décimalisée à 3.
**Nombre de mois
d’historique
2** N O Nombre de mois sélectionné lors de l’extraction

**Code
fournisseur du
marché**

6 S N Si marché en cours sur ce produit lors de
l’extraction, le code fournisseur est transmis. C’est
le code Hexagone

**Raison sociale** (^38) S N Raison sociale du fournisseur du marché
**PU HT du
produit
13** N N Prix unitaire du marché, Décimalisé en 4.
**Unité** (^5) **S N** Code Unité (correspondant au prix du produit)
**Date
d'actualisation
du PUHT
8 Date O** Dernière date de mise à jour du PUHT. Format
YYYYMMDD
**Code UCD** (^13) **S N** Code UCD
**Code CIP** (^13) **S N** Code CIP
**Code ATC** (^7) **S N** Code ATC
**Code LPPR** (^13) **S N** Code LPPR
**Code DCI** (^6) **S N** Code DCI
**Libellé court** (^40) **S N** Libellé court produit Hexagone WEB
**Réf fournisseur** (^20) **S N** Référence du produit chez le fournisseur
**Quantité en
stock mensuel
14 N N** Quantité en stock du produit à la fin du mois
Décimalisée à 3.

## 4 Création d’un marché

Les marchés peuvent être uniquement envoyés depuis la Gestion Economique et Financière
vers un autre destinataire.

### ➢ Message 1 : Entête de Marché

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :MA : Marchés
**Message** (^2) S O M1
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Exercice** (^4) N O Exercice comptable de saisie
**No de marché** (^6) N O No de marché attribué par l’établissement
**Code du titulaire** (^6) S O Code Hexagone WEB du fournisseur titulaire du
marché
**No de
domiciliation
bancaire
3** N O Numéro de domiciliation bancaire du titulaire.
Pour règlement.
**Délai de
Paiement
3** N F Nombre de jours. Compris entre 001 et 999
**Date de
Consultation
8** Date O Date de lancement de la consultation du marché.
Format YYYYMMDD
**Date de
Notification
8** Date O Date de notification au titulaire. Format
YYYYMMDD
**Date début de
marché
8** Date O Format YYYYMMDD

**Date de fin
marché**

8 Date O Format YYYYMMDD

**Marché alloti** (^1) S O **T** : pour marché alloti, **F** sinon
**Nbre de lots** (^4) N F Si marché alloti, donne le nombre de lots associés
**Multi
fournisseurs
1** S O **O** : si marché multi fournisseur, **N** si mono
fournisseur
**Montant Initial** (^15) N O Montant initial TTC marché (décimalisé à 2)
**Montant
avenants
15** N O Montant cumulé des avenants (décimalisé à 2)
**A bon de cde** (^1) S O Valeurs **F** pour Non, **T** pour Oui
**Reconductible** (^1) S O Valeurs **F** pour Non, **T** pour Oui
**Nbre de
reconductions
3** N O Obligatoire sir code « Reconductible » est à T.
Compris entre 001 et 999.
**Gestion Interne** (^1) S O Valeur **F** pour Non, **T** pour Oui.
**Pourcentage
maxi de blocage
5** N N Décimalisé à 2.
**Type de marché** (^1) S O Caractéristiques
**M** = mixte
**C** = négocié sans concurrence
**A** = article 30
**N** = aucune caractéristique (normal)
**Nature** (^1) S O Obligatoire si type = ‘T (Travaux).
Valeurs autorisées :
**T** : Opération de Travaux
Si type de marché différent de ‘T’: valeur **N
Code CMP** (^10) S F Obligatoire si type marché = ‘M’. Code
nomenclature cadre des marchés publics
**Groupement
d’achat
1** S O **T** si marché dans le cadre d’un groupement
d’achat, **F** si marché propre à l’établissement.

**Taux des
Intérêts
moratoires**

5 N F Numérique décimalisé à 2. Taux spécifique pour le
marché

**Observations** (^80) S F Observations

### ➢ Message 2 : Lignes de Marché

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :MA : Marchés
**Message** (^2) S O M2
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**No de marché** (^6) N O No de marché attribué par l’établissement
**No ligne de
marché
3** N O No de ligne
**No de lot** (^4) N N Obligatoire si marché alloti^
**Type de besoin** (^1) S Plus envoyé à partir de la version 9.02 de GREF
(Vide)
**Code produit** (^8) S N Obligatoirement renseigné si ligne sur produit
**Compte
ordonnateur
13** S N Obligatoirement renseigné si ligne sur compte
(sans produit)
**Qté initiale** (^14) N N Quantité initiale ligne de marché Décimalisée à 3
**PU Hors taxe** (^13) N N Prix unitaire Hors taxe ligne Décimalisé à 4
**Date révision prix** (^8) Date N Plus envoyé à partir de la version 9.02 de GREF
(Vide)

**Code TVA ligne** (^2) N N Code TVA à appliquer sur la ligne. Code Hexagone
WEB, doit exister dans HXTVA
**Montant TTC ligne** (^15) N N Montant TTC ligne. Décimalisé à 2
**Désignation ligne** (^40) S O Désignation de la ligne^
**Code CMP** (^10) S O Obligatoire code nomenclature du nouveau code
des marchés publics.
**Code fournisseur** (^6) S O Code fournisseur de la ligne^
**Libellé du lot 150** S N Libellé du lot^
**Date de création** (^8) Date O Format YYYYMMDD^
**Quantité
minimum de
commande**

14 N N

Quantité minimum à commander. Décimalisée à 3

Code Unité de
conditionnement

5 S N Code unité de conditionnement du fournisseur, existe dans la table HXUNDIST

**Nombre d’unités** (^14) N N Nombre d’unités de gestion dans fournisseur. Décimalisé à 3 l’unité de conditionnement du
**Délai de livraison** (^3) N N Nombre de jours pour délai de livraison.^
**Code fournisseur
principal
1** S O Fournisseur principal du produit. Valeurs T pour Vrai, F pour Faux.
**No de point de
commande**

2 N O

Par défaut 01. Point de commande habituel pour le produit.

Référence du
produit chez le
fournisseur

1024 S N

Texte permettant l’identification du produit chez le fournisseur,
il sera repris sur les bons de commande

Référence
fournisseur

30 S N Références exactes du produit chez le fournisseur sans annotation personnelle.

**Code fabricant** (^13) S N Code fabricant lié au LPPR (liste des produits et prestations remboursables, ancien nom LPP).

### ➢ Message 3 : Fournisseurs par marché

Uniquement si marché multi fournisseurs et/ou marché alloti

Rubrique Long. Format Oblig. Commentaires
Type 2 S O Type du message :MA : Marchés

Message 2 S O M3
Mode 1 S O C
Emetteur 15 S O HEXAGONE
Date de l’envoi 16 Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
Individu
(émetteur du
message)

50 S O Individu au sens S3A qui a généré le message.

No de marché 6 N O No de marché attribué par l’établissement
No de lot 4 N O No de lot associé au fournisseur
Code
fournisseur

6 S O Code fournisseur Hexagone WEB associé

No de
domiciliation
bancaire

2 N O No de domiciliation bancaire du fournisseur, pour
gestion des règlements.

Date début 8 Date O Format YYYYMMDD
Date de fin 8 Date O Format YYYYMMDD
Libellé du lot 150 S N Libellé du lot

## 5 Modification de marché

Mêmes messages que les messages de création dès qu’une information est modifiée avec un
mode « MODIFICATION »

## 6 Suppression de marché

### ➢ Message 1 : Arrêt d’un marché

Rubrique Long. Format Oblig. Commentaires
Type 2 S O Type du message :MA : Marchés

**Message 2** S O M1

**Mode 1** S O S

**Emetteur 15** S O HEXAGONE

**Date de l’envoi 16**
Date
O Date de l’envoi au format :
YYYYMMDDHHMISSnn

**Individu
(émetteur du
message)**

50 S O Individu au sens S3A qui a généré le message.

**No de marché 6** N O No de marché attribué par l’établissement

**Code clôturée 1** S O **O**^ : pour marché clôturé^

### ➢ Message 2 : Arrêt d’une ligne de marché

**Rubrique Long. Format Oblig. Commentaires**

**Type 2** S O Type du message :
MA : Marchés

**Message 2** S O M2

**Mode 1** S O S

**Emetteur 15** S O HEXAGONE

**Date de l’envoi 16** Date^ O Date de l’envoi au format :

YYYYMMDDHHMISSnn

**Individu
(émetteur du
message)**

50 S O Individu au sens S3A qui a généré le message.

**No de marché 6** N O No de marché attribué par l’établissement

**No ligne
marché**

3 N O No de ligne clôturée.

**Code produit 8** S N Obligatoirement renseigné si ligne sur produit

**Compte
ordonnateur**

13 S N Obligatoirement renseigné si ligne sur compte

**Code CMP 10** S O Obligatoire code nomenclature du nouveau code
des marchés publics.

**No de lot 4** N N Obligatoire si marché alloti^

**Code clôturée 1** S O **O**^ : pour ligne de marché clôturée^

## Demandes d’approvisionnements externes

## 1 Création d’une demande

Les demandes sont envoyées d’un destinataire vers la Gestion Economique et Financière. Elles
permettent de générer **des commandes** après contrôles dans GREF. Les commandes générées
dans GREF pourront alors être récupérées par l’émetteur de la demande.

### ➢ Message 1 : Entête de demande d’approvisionnement

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message DA : Demandes
d’approvisionnements
**Message** (^2) S O DE
**Mode** (^1) S O C
**Emetteur** (^15) S O NOM EMETTEUR
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Date de
demande
8** Date O Format YYYYMMDD
**No de demande** (^10) N O No de la demande propre à l’émetteur
**UF de gestion** (^4) N O Code UF de gestion de la commande
**Code
Fournisseur
6** S O Code fournisseur Hexagone WEB de la
commande.
**Code point de
commande
2** N O Point de commande sur lequel on doit générer la
commande. Par défaut la valeur est 01
**Objet demande** (^40) S N Objet de demande

**Date de livraison** (^8) Date N Date de livraison souhaitée. Doit être supérieure
ou égale à la date de demande. Format
YYYYMMDD
**Nature
commande
1** S O P : demande sur produits, C : demande sur
comptes.
**Code à
Réceptionner
1** S O O si type de demande Produits ou Compte à
réceptionner dans la Gestion Economique et
Financière (donc saisie d’une livraison avant la
facture)
N : Si demande sur compte sans saisie obligatoire
de réception.
**Type de
demande
1** S O Permet d’identifier les cas particuliers pour le
CMP :
F : demande Normale
T : demande de travaux
**Exercice
d’imputation
4** N O Exercice comptable d’imputation des
engagements
**Code service** (^100) S N Références du Service destinataire CHORUS
**Nom du service** (^100) S N Nom du service destinataire CHORUS
**N° SIRET** (^14) N N N° SIRET
**Code Transitaire 8 N N Code du transitaire de commande (Ex 1 = Air
France )**

### ➢ Message 2 : Lignes de demande d’approvisionnement externe

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message DA : Demandes
d’approvisionnements
**Message** (^2) S O DL
**Mode** (^1) S O C
**Emetteur** (^15) S O NOM EMETTEUR

**Date de l’envoi 16** Date^ O Date de l’envoi au format :

YYYYMMDDHHMISSnn

**Individu
(émetteur du
message)**

50 S O Individu au sens S3A qui a généré le message.

**Date de
demande**

8 Date O Format YYYYMMDD

**No de demande** (^10) S O
**No de ligne** (^3) N O No de ligne de demande : 001 à 999 maximum.
**Code produit** (^8) S O Obligatoire si demande de type Produits, Vide
sinon. Code produit d’Hexagone WEB
**Compte
ordonnateur
13** S O Obligatoire si demande de type Comptes : Format
Lettre budget + No de compte
**No de Marché** (^6) N N Obligatoire si l’établissement gère les marchés :
indiquer le numéro de marché Hexagone WEB.
Sinon vide
**No ligne interne
du marché
3** N N Obligatoire si No de marché renseigné
**No de lot
marché
4** N N Obligatoire si marché renseigné et marché géré
avec des lots.
**Quantité
demandée
14** N O Décimalisée à 3. Quantité > 0, si ligne produit doit
être exprimée dans l’unité de gestion associée au
message 4 du produit
**PU Hors taxe** (^13) N N **Obligatoire pour demande sur compte**.
Décimalisé à 4.
**Montant Hors
taxe
16** N N **Obligatoire pour demande sur compte**.
Montant ligne en Hors taxe. Décimalisé à 2
**Code TVA** (^2) N N **Obligatoire pour demande sur compte**. Code
TVA appliqué à la ligne. Le code donne le taux
associé dans HEXAGONE WEB. Doit exister dans
HXTVA
**Code CMP** (^10) S O Obligatoire si produit et/ou commande service

**No projet** (^6) N N Envoyer un numéro de projet géré dans Hexagone
WEB.
**Ligne de texte 1** (^256) S N Ligne de texte associée à la demande destinée au
fournisseur
Peut commencer par #+numéro pour indiquer le
code transitaire de la commande. Seule celui de la
première ligne est pris en compte. Cette
information n’est pas prise en compte si le code
transitaire est renseigné dans le DA|DE
**Ligne de texte 2** (^256) S N Suite de la ligne de texte 1
**Code Dépense
Imprévisible
1** S O Plus utilisé à partir de la version D.02 de GREF
(vide)
**UF Destinatrice** (^4) N N A ne renseigner que pour les produits en
Entrée/Sortie. UF de consommation
Les demandes envoyées sont considérées comme valides.
La modification ou suppression d’une demande implique la suppression ou modification de la
commande dans la Gestion Economique et Financière qui renvoie les modifications ou
suppression de commande.

## Commandes

## 1 Création d’une commande

Les commandes sont envoyées depuis la Gestion Economique et Financière vers un autre
destinataire.

### ➢ Message 1 : Entête de commande

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :CO : Commande
**Message** (^2) S O CE
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Exercice** (^4) N O Exercice comptable d’imputation de la commande
**N° de
commande
HEXAGONE WEB
8** N O No de commande dans la Gestion Economique et
Financière
**No de demande** (^10) S O No de demande de l’émetteur si commande
générée à partir d’une demande externe
**Nom émetteur
dde
15** S N Renseigné si commande générée par une
demande externe.
**UF de gestion** (^4) N O Code UF de gestion de la commande
**Code
Fournisseur
6** S O Code fournisseur de la commande.
**Code point de
commande
2** N O Point de commande auquel on destine la
commande.

**Objet
commande**

40 S N Objet de commande

**Date de
commande**

8 Date O Format YYYYMMDD

**Date de livraison** (^8) Date N Date de livraison. Format YYYYMMDD
**Montant TTC de
la commande
16** N O Correspond au cumul TTC des lignes de
commande associées. Décimalisé à 2.
**Nature
commande
1** S N Plus envoyé à partir de la version D.0 4 de GREF
Désormais Vide car les commandes peuvent être
à la fois produit et compte
**Code lieu de
livraison
8** S N Code lieu de livraison.
**Code lieu de
facturation
8** S N Code lieu de facturation
**Observations** (^100) S N Zone d’observations destinées au fournisseur
**Code à
Réceptionner
1** S O Valeurs transmises :
**O** si type de commande Produits ou Compte à
réceptionner (donc saisie d’une livraison avant la
facture)
**N** : Si commande sur compte sans saisie
obligatoire de réception.
**Code à Faxer** (^1) S O Commande à faxer par HEXAGONE WEB : T pour
Oui, F pour Non
**Type de
Commande
1** S O Permet d’identifier les cas particuliers pour le
CMP :
**F** : Commande classique
**T** : Commande de travaux
**Code générée
O/N
1** S O Générée par bordereau de livraison **O** (Oui) /
**N** (Non)
**Raison sociale
Four
38** S O Raison sociale du fournisseur
**No Fax** (^16) S F No de Fax du point de commande

**Code robot EDI** (^35) S F Code identifiant fournisseur pour EDI
**Envoi EDI** (^1) S O Code commande transmise par EDI : T pour Vrai, F
pour Faux
**Transférée EDI** (^1) S O Code déjà transférée EDI : T pour vrai, F pour Faux
**Individu
transfert EDI
50** S N Renseigné si transfert EDI déjà fait. Référence de
l’utilisateur ayant lancé le transfert EDI.
**Nombre de
lignes de
commande
3** N O Nombre de lignes associées à la commande (
Format 999 maximum)
**Code service de
la commande
100** S N Références du Service destinataire CHORUS pour
la commande
**Nom du service** (^100) S N Nom du service destinataire CHORUS pour la
commande
**N° SIRET** (^14) N N N° SIRET établissement géographique

### ➢ Message 2 : Lignes de commande

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :CO : Commande
**Message** (^2) S O CL
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Exercice** (^4) N O Exercice comptable d’imputation de la commande
**N° commande
HEXAGONE WEB
8** N O No de commande dans la Gestion Economique et
Financière
**No de ligne cde** (^3) N O No de ligne de commande : 001 à 999 maximum.

**Code produit** (^8) S O Obligatoire si Commande de type Produits, Vide si
commande de type Comptes. Code HEXAGONE
WEB
**Compte
ordonnateur
13** S O Obligatoire si Commande de type Comptes :
Format Lettre budget + No de compte
**No de Marché** (^6) N N Obligatoire si l’établissement gère les marchés :
numéro de marché HEXAGONE WEB
**No ligne interne
du marché
3** N N Obligatoire si No de marché renseigné
**No de lot
marché
4** N N Obligatoire si marché renseigné et marché géré
avec des lots.
**UF
d’engagement
4** N O UF d’engagement comptable.
**Quantité
commandée
14** N O Décimalisée à 3. Quantité > 0, pour ligne produit
est exprimée dans l’unité de conditionnement
fournisseur
**PU Hors taxe** (^13) N O Décimalisé à 4.
**Montant Hors
taxe
16** N O Montant ligne en Hors taxe. Décimalisé à 2
**Pourcentage de
remise
5** N N Pourcentage de remise appliqué sur le Hors taxe.
Décimalisé à 2
**Code TVA** (^2) N O Code TVA appliqué à la ligne.
**Montant TTC
Ligne
16** N O Montant TTC de la ligne après calcul de la remise
et de la TVA. Décimalisé à 2
**Code CMP** (^10) S O Obligatoire si produit et/ou commande service
**No projet** (^6) N N Projet
**Ligne de texte 1** (^256) S N Ligne de texte associée à la commande destinée
au fournisseur
**Ligne de texte 2** (^256) S N Suite de la ligne de texte 1
**Code Dépense
Imprévisible
1** S O Plus envoyé à partir de la version 9.02 de GREF
(Vide)

Libellé long
produit

150 S N Renseigné si code produit présent

**Type produit** (^3) D N Type de produit : **MED** = Médicament
**MAT** = Matériel Médical
**DM** = Dispositif Médical
**FIL** = Film Radiologie
**PCO** = Produits de contraste
**CUI** = Cuisine
**LAB** = Laboratoire
**LOG** = Logistique
Champ vide pour autres produits.
**Code UCD** (^7) N N Envoyé si champ renseigné dans la fiche produit
**Quantité en
unité de gestion
14** N O Décimalisée à 3. Quantité > 0, pour ligne produit
est exprimée dans l’unité de gestion du produit
dans l’établissement
**Code LPP** (^13) S N Envoyé si champ renseigné dans la fiche produit
**Référence DM** (^30) N N Envoyé si champ renseigné dans la fiche produit
et produit de type Dispositif Médical

## 2 Modification de Commande

Mêmes messages que les messages de création dès qu’une information est modifiée avec un
mode « MODIFICATION »

## 3 Suppression de Commande

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :CO : Commande
**Message** (^2) S O CL
**Mode** (^1) S O S

**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Exercice** (^4) N O Exercice comptable d’imputation de la commande
**No de
commande
HEXAGONE WEB
8** N O Si émetteur = HEXAGONE : No de commande dans
la Gestion Economique et Financière
Sinon : 0
**No de ligne
annulée
3** N O No de ligne de commande : 001 à 999 maximum.
**Code produit** (^8) S O Obligatoire si Commande de type Produits, Vide si
commande de type Comptes. Code HEXAGONE
WEB
**Compte
ordonnateur
13** S O Obligatoire si Commande de type Comptes :
Format Lettre budget + No de compte
**Quantité
commandée
annulée
14** N O Décimalisée à 3. Quantité > 0, si ligne produit doit
être exprimée dans l’unité de gestion associée au
message 4 du produit

## Livraisons provenant de l’extérieur

## 1 Création d’une livraison externe

Elles sont envoyées par un autre émetteur dans la Gestion Economique et Financière, le nom
de l’émetteur doit être renseigné et il sera stocké dans la réception de la Gestion Economique
et Financière qui sera générée si tous les contrôles sont corrects.

### ➢ Message 1 : Lignes de Livraison externe

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message : LI : Livraisons externes
**Message** (^2) S O M1
**Mode** (^1) S O C
**Emetteur** (^15) S O NOM EMETTEUR
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Date de livraison** (^8) Date O Format YYYYMMDD
**No de réception
de l’émetteur
10** S O No de réception de l’émetteur
**No de
commande de
l’émetteur
10** S O No de commande de l’émetteur
**No de
commande
HEXAGONE WEB
8** N O A préciser si la commande a déjà été générée dans
la Gestion Economique et Financière
**No de ligne cde
HEXAGONE WEB
3** N O No de ligne de commande : 001 à 999 maximum.
Permet de faire le lien avec le numéro de ligne de
commande associée la ligne de livraison

No de Bordereau
de livraison

10 S N No du BL du fournisseur

**Code fournisseur** (^6) S O Fournisseur HEXAGONE WEB effectuant la
livraison
**UF magasin de
réception
4** N O Doit exister dans HEXAGONE WEB et être associée
comme UF magasin principale sur les produits
**Code produit** (^8) S N **Obligatoire** si ligne sur produit
**Compte
ordonnateur
13** S N **Obligatoire** si ligne sur compte
**Quantité livrée** (^14) N O Décimalisée à 3. Quantité > 0, doit être exprimée dans l’unité de gestion de stock du magasin. (CF message 4
du produit)
**Code ligne de cde
soldée
1** S O Valeurs autorisées : **O** pour Oui, **N** pour Non.
Valeur à O permet de savoir si la ligne de
commande est soldée en livraison (cas ou la
quantité livrée est strictement inférieure à la
quantité commandée et pas de livraison du solde
prévue).
**No Marché** (^6) N N Uniquement renseigné si ligne porte sur un
marché
**No Lot** (^4) N N Uniquement si marché alloti
**Code CMP** (^10) S O Obligatoire si produit et/ou commande service
**No projet** (^6) N N Numéro de projet si gestion des projets dans la
Gestion Economique et Financière
**Code Dépense
Imprévisible
1** S O **T**^ pour Oui, **F**^ pour Non^
**Point de cde
Four.
2** N N Peut être renseigné si réception sans référence à
une commande HEXAGONE WEB. Sera utilisé
pour générer la commande.
**No de ligne
Marché
8** N N No de ligne du marché^ : Obligatoire si no de
marché transmis

### ➢ Message 2 : Lignes de Livraison sur produit avec gestion de lot

Ces messages ne sont reçus que pour les lignes de produits ayant un code Gestion des lots et
date de péremption positionné à T. La gestion des lots n’est pas implémentée dans la Gestion

Economique et Financière pour les versions en cours. Ces messages seront traités dès que le
fonctionnel associé sera géré.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message : LI : Livraisons externes
**Message** (^2) S O M2
**Mode** (^1) S O C
**Emetteur** (^15) S O NOM EMETTEUR
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le
message.
**Date de
livraison
8** Date O Format YYYYMMDD
**No de réception
de l’émetteur
10** S O No de réception de l’émetteur
**No de
commande de
l’émetteur
10** S O No de commande de l’émetteur
**No de
commande
HEXAGONE
WEB
8** N O Si la commande a déjà été générée dans la
Gestion Economique et Financière
**No de ligne cde
HEXAGONE
WEB
3** N O No de ligne de commande : 001 à 999
maximum. Permet de faire le lien avec le
numéro de ligne de commande associée la
ligne de livraison
**Code produit** (^8) S O Code produit HEXAGONE WEB concerné
**No de lot** (^30) S O No du lot - Alimenté par le n° de série si le
produit n'a pas de lot
**No de série** (^30) S F N° de série - Obligatoire si le produit
HEXAGONE WEB le gère.

Date de
péremption

8 Date O Date de péremption du lot reçu

**Quantité reçue** (^14) N O Le total des lignes par produit doit être égal
à la quantité totale reçue. Décimalisée à 3.
Quantité > 0
Contrôle :
➢ Si le produit de la ligne à réceptionner est géré en lot et que le message M2 n'est
pas présent, aucun blocage de l'intégration.
➢ Si un message M2 est envoyé et que le produit ne gère pas les lots, blocage de
l'intégration de la réception.
➢ Si un message M2 est envoyé avec un numéro de série vide alors que le produit
gère le numéro de série, blocage de l'intégration de la réception.
➢ Le produit doit être le même que celui de la ligne M1
➢ Si la somme des quantités des messages M2 pour le même produit, la même
commande et la même ligne n'est pas la même que celle de la ligne M1, blocage de
l'intégration de la réception.

## 2 Modification de lignes de Livraison

Mêmes messages que les messages de création dès qu’une ligne est modifiée avec un code
mode a « M » pour « MODIFICATION »

Pour des rectifications de quantités envoyer la nouvelle valeur à prendre en compte.

Pour une remise à zéro d’une ligne mettre la quantité à zéro. Attention au code « ligne de
commande soldée »

Si code = O la ligne de commande sera considérée dans GREF comme soldée en livraison
et donc ne pourra plus être associée à une autre réception.

Si code = N La ligne de commande reste en attente de livraison pour la différence entre
la quantité commandée et le cumul des quantités livrées (si ce cumul est inférieur à la quantité
en commande).

## 3 Annulation de Livraison

Message permettant d’annuler une livraison provenant de l’extérieur avant ou après son
intégration. Fonctionne uniquement avec HEXAFLUX.

**Rubrique Long. Format Oblig. Commentaires**

**Type 2** S O Type du message : LI : Livraisons externes

**Message 2** S O M1

**Mode 1** S O Suppression : S

**Emetteur 15** S O NOM EMETTEUR

**Date de
l’envoi**

16 Date O Date de l’envoie au format :
YYYYMMDDHHMISSnn

**Individu
(émetteur
du message)**

50 S O Individu au sens S3A qui a généré le message.

**Date
D’annulatio
n**

8 Date O Format YYYYMMDD

**No de
réception de
l’émetteur**

10 S O No de réception de l’émetteur

**No de
commande
de
l’émetteur**

10 S O No de commande de l’émetteur

## Echantillons

## 1 Création d’une livraison externe d’échantillon

Elles sont envoyées par un autre émetteur dans la Gestion Economique et Financière, le nom
de l’émetteur doit être renseigné et il sera stocké **comme un mouvement de régularisation
d’entrée** de la Gestion Economique et Financière qui sera généré si tous les contrôles sont
corrects. Fonctionne uniquement avec HEXAFLUX.

Rubrique Long. Format Oblig. Commentaires
Type 2 S O Type du message : EC : Echantillons
Message 2 S O M1
Mode 1 S O Création
Emetteur 15 S O PHARMA
Date de l’envoi 16 Date^ O Date de l’envoie au format :
YYYYMMDDHHMISSnn
Individu
(émetteur du
message)

50 S O PHARMA
Date de
livraison des
échantillons

8 Date O Format YYYYMMDD

No de
réception de
l’émetteur

10 S O No de réception des échantillons de l’émetteur

Code
fournisseur

6 S O Fournisseur HEXAGONE WEB effectuant la
livraison
UF magasin de
réception

4 N O Doit exister dans HEXAGONE WEB et être associée
comme UF magasin principale sur les produits
Code produit 8 S O Obligatoire
Signe du
Mouvement

1 S O P pour positif – N pour Négatif

**Quantité livrée 14** N O Décimalisée à 3.^
Quantité > 0 (Positive) , doit être exprimée dans
l’unité de gestion de stock du magasin

**No Marché 6** N N Uniquement renseigné si ligne porte sur un
marché

**No Lot de
Marché**

2 N N Uniquement si marché alloti

**No de Lot du
Produit**

30 S N No de lot de l’échantillon

**Date de
Péremption du
lot**

8 Date N Obligatoire si No de lot renseigné

**Commentaire 40** S N Permet d’identifier le mouvement

## Receptions

## 1 Création d’une réception

Les réceptions sont envoyées depuis la Gestion Economique et Financière vers un autre
destinataire.

### ➢ Message 1 : Lignes de Réception

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :RO : Réceptions
**Message** (^2) S O M1
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format : YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Exercice
comptable
4** N O Exercice comptable d’imputation
**No réception
HEXAGONE WEB
8** N O No de réception dans la Gestion Economique et
Financière
**No de réception
de l’expéditeur
10** S N Si réception générée par une livraison externe,
alimenté avec le numéro transmis par l’expéditeur
**Code expéditeur** (^15) S N Si réception générée par une livraison externe,
alimenté avec la référence transmise dans le
message de l’expéditeur
**No de ligne
réception
3** N O No de ligne de réception : 001 à 999 maximum.
**Type de
Réception
1** S O Permet d’identifier les cas particuliers pour le
CMP :
**F** : Réception Normale

T : Réception Travaux

**No de
commande
HEXAGONE WEB**

8 N O No de commande dans la Gestion Economique et
Financière associé à la réception

**No de ligne cde** (^3) N O No de ligne de commande : 001 à 999 maximum.
**No de Bordereau
de livraison
10** S N No du BL du fournisseur
**Code fournisseur** (^6) S O Fournisseur HEXAGONE WEB effectuant la
livraison
**Date de livraison** (^8) Date O Format YYYYMMDD
**UF magasin de
réception
4** N O Doit exister dans HEXAGONE WEB et être associée
comme UF magasin principale sur les produits
**Code produit** (^8) S N **Obligatoire** si ligne sur produit
**Compte
ordonnateur
13** S N **Obligatoire** si ligne sur compte
**Quantité livrée** (^14) N O Décimalisée à 3. Quantité > 0, est exprimée^ dans
l’unité de gestion de stock du magasin. (CF
message 4 du produit)
**Code ligne de cde
soldée
1** S O Valeurs autorisées : **O** pour Oui, **N** pour Non.
Valeur à O permet de savoir si la ligne de
commande est soldée en livraison (cas ou la
quantité livrée est strictement inférieure à la
quantité commandée et pas de livraison du solde
prévue).
**No Marché** (^6) N N Uniquement renseigné si ligne porte sur un
marché
**No Lot** (^4) N N Uniquement si marché alloti
**Code CMP** (^10) S O Obligatoire si produit et/ou commande service
**Code projet** (^6) N N Numéro du projet^
**Code Dépense
Imprévisible
1** S O Plus envoyé à partir de la^ version 9.02 de GREF (Vide)^

## 2 Modification de Réception

Mêmes messages que les messages de création dès qu’une information est modifiée avec un
mode « MODIFICATION »

## 3 Suppression de Réception

La suppression concerne soit la totalité de la réception, soit toutes les lignes associées à une
commande.

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :RO : Réceptions
**Message** (^2) S O M1
**Mode** (^1) S O S
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format : YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Exercice
comptable
4** N O Exercice comptable d’imputation
**No réception
HEXAGONE WEB
8** N O No de réception dans la Gestion Economique et
Financière
**No de réception
de l’expéditeur
10** S O No de réception de l’expéditeur
**Ligne réception** (^3) N O No de ligne de réception : 001 à 999 maximum.
**No de
commande
HEXAGONE WEB
8** N O No de commande dans la Gestion Economique et
Financière
**No de
commande de
l’expéditeur
10** S O No de commande de l’expéditeur

## Mouvements de stocks internes

## 1 Création d’un Mouvement de stock interne

Ces mouvements sont transmis par un autre émetteur dans la Gestion Economique et
Financière, ou par un système de lecture code barre, dans ce cas le nom de l’émetteur doit être
renseigné et stocké dans les pièces générées dans la Gestion Economique et Financière si tous
les contrôles sont corrects.

**_Ces messages concernent uniquement les produits gérés en stock et non gérés en
entrées/sorties simultanées :_**

A - Les sorties de stock classiques des magasins et / ou armoires de service :
Consommations de produits par les services, et gestion des retours de service. Dans ce
cas, 2 possibilités sont offertes :
1 - Soit les mouvements transmis sont déjà valorisés par le système émetteur,
dans ce cas la valorisation du mouvement sera comptabilisée telle quelle dans la
Gestion Economique et Financière. L’intégration de ce mouvement génère un bon
de régularisation de sortie de stock.
(Message de type SO, code Message S1 avec champ Valeur de la sortie
renseignée)
2 - Soit les mouvements transmis sont uniquement quantitatifs, dans ce cas la
valorisation sera effectuée dans la Gestion Economique et Financière lors de
l’arrêté de balance définitive : L’intégration de ces mouvements génère des bons
de sorties normaux..
(Message de type SO, code Message S1 avec champ Valeur de la sortie non
renseignée)

**B - Les inventaires de stock par magasin et / ou armoire de service** :

Ces mouvements permettront de générer un état d’inventaire qui sera rapproché du
stock géré dans la Gestion Economique et Financière dans les procédures de gestion des
inventaires des stocks. Ces messages sont purement quantitatifs.
(Message de type SO, code Message I1 avec champ Valeur de la sortie non
renseignée)

**C - Les transferts entre magasins de l ‘établissement**

Ces mouvements permettront de gérer dans la Gestion Economique et Financière les
mouvements entre magasins et / ou armoires de service à l’intérieur de l’établissement.
Ces mouvements ne rentrent pas dans la comptabilisation des consommations.
(Message de type SO, code Message T1 avec champ Valeur de la sortie non
renseignée)

### ➢ Message 1 : Mouvements de STOCK

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :
SO : Mouvements de stock
**Message** (^2) S O S1 ou I1 ou T1
**Mode** (^1) S O C
**Emetteur** (^15) S O NOM EMETTEUR
**Date de l’envoi 16** D^ O Date de l’envoi au format : YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Date
Mouvement
8** Date O Date du mouvement : format YYYYMMDD
**Code UF magasin** (^4) N O Pour tous les types de codes Messages :
Code de l’UF magasin effectuant la sortie de stock
ou l’inventaire ou le transfert
**Code armoire** (^4) S N Pour tous les types de codes Messages et si
gestion des armoires dans la Gestion Economique
et Financière : Code de l’armoire associée à l’UF
magasin effectuant la sortie de stock ou
l’inventaire ou le transfert
**No de bon** (^10) N N No de bon attribué par le système émetteur.
**Code UF
destinatrice
4** N O Pour les messages S1 : UF destinatrice de la sortie
ou faisant le retour

Pour les messages I1 : Mettre 0000
Pour les messages T1 : UF magasin réceptionnant
le produit transféré

**Code Armoire de
l’UF destinatrice**

4 S N Uniquement renseigné si gestion des armoires
dans la Gestion Economique et Financière.
Pour les messages S1 : Code armoire associé à UF
destinatrice de la sortie ou faisant le retour
Pour les messages I1 : Mettre 0000
Pour les messages T1 : Code armoire de l’ UF
magasin réceptionnant le produit transféré

**Code produit** (^8) S O Identifiant du produit dans la Gestion Economique
et Financière : peut-être soit le code produit soit le
code CIP paramétré sur la fiche produit.
**Quantité produit** (^14) N O Décimalisée à 3. Peut être négative dans le cas
d’un message S1 (retour). Elle doit être exprimée
dans l’unité de gestion associée au message 4 du
produit
**Valeur produit** (^16) N N Peut-être renseignée uniquement si message S1
et peut être négative.
Décimalisée à 2
**Numéro du lot** (^30) S N Obligatoire uniquement si produit est codé avec
une gestion des lots et dates de péremption
**No dossier
Patient
9** S N No dossier patient HEXAGONE WEB si connu
**N° de Série** (^30) S N N° série - Obligatoire uniquement si le produit est
codé avec une gestion du n° de série
**IUD** (^150) S N Le code IUD pour les DM (Dispositifs Médicaux). Il
est constitué du code IUD-ID (Identifiant Dispositif
: code fabricant, modèle, conditionnement) et du
code IUD-IP (Identifiant Production : numéro de
série, numéro de lot, date de fabrication, date
d'expiration).

Il y a 4 types selon le standard choisi pour le code
IUD-ID : GTIN (standard GS1), UPN (standard
HIBC), PPN (standard IFA) et PPIC (standard ISBT
128).

**IUDID** (^25) S N Le code IUD-ID (Identifiant Dispositif : code
fabricant, modèle, conditionnement) est le
premier élément du code IUD.

## 2 Envoi des listes pré établies

Les listes Pré établies sont envoyées depuis la Gestion Economique et Financière vers un autre
destinataire.

Elles sont élaborées par Magasin pour chaque UF cliente et elles donnent la liste des produits
disponibles avec éventuellement les quantités de dotations préconisées

### ➢ Message 1 : Listes pré établies

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :
SO : Sorties
**Message** (^2) S O L1 : liste préétablie
**Mode** (^1) S O C
**Emetteur** (^15) S O HEXAGONE
**Date de l’envoi 16** Date^ O Date de l’envoi au format : YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**Exercice** (^4) N O Exercice de la liste
**UF Magasin** (^4) N O UF magasin émetteur
**Code Armoire** (^4) S N Code armoire (si pas de gestion des armoires
0000)
**UF cliente** (^4) N O UF cliente associée à la liste

Code Armoire
Cliente

4 S N Code de l’armoire associée à l’UF cliente. Si pas de
gestion des armoires valeur 0000

**Code liste** (^8) S O Nom de la liste
**Code produit** (^8) S O Code produit
**No de ligne** (^3) N O No de ligne de la liste
**Libellé produit** (^40) S O
**Quantité
dotation
12** N F Décimalisé à 3. Quantité de dotation calculée ou
saisie
**Consommation
Moyenne
12** N F Consommation moyenne journalière calculée si
génération par le calcul de dotation
**Nombre de
lignes de sortie
8** N F Nombre de lignes de sorties prise en compte dans
le calcul de dotation
**Libellé de la liste** (^40) S F Libellé de la liste paramétrée

## Recettes diverses

## 1 Création d’un Mouvement de recettes diverses

Ces mouvements sont transmis par un autre émetteur dans HEXAGONE WEB.

Dans ce cas le nom de l’émetteur doit être renseigné et stocké dans les pièces générées dans
HEXAGONE WEB si tous les contrôles sont corrects.

### ➢ Message 1 : Entête de pièce

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :
RD : Pièce de recettes diverses
**Message** (^2) S O E1
**Mode** (^1) S O C
**Emetteur** (^15) S O NOM EMETTEUR

**Date de l’envoi 16** Date^ O Date de l’envoi au format :

YYYYMMDDHHMISSnn

**Individu
(émetteur du
message)**

50 S O Individu au sens S3A qui a généré le message.

**No de pièce de
l’expéditeur**

10 S O No d’identifiant unique de la pièce

**Exercice** (^4) N O Exercice comptable d’imputation de la pièce
**Code débiteur** (^6) S O Code débiteur destinataire du titre à émettre.
Majuscules uniquement
**Nom Débiteur** (^35) S O Dénomination du débiteur : Majuscules
**Adresse 1** (^38) S N Adresse 1 du débiteur
**Adresse 2** (^38) S N Suite adresse
**Code postal** (^5) N O Code postal débiteur
**Ville** (^38) S N Ville débiteur
**Compte de tiers** (^12) N O Compte de tiers associé au débiteur
**Type débiteur** (^1) N O Valeurs autorisées :
1 & 2 : Sécurité sociale
3 & 4 : Mutuelle
5 & 6 : DDASS
7 : Particulier
8 : Débiteur en instance
**Code transfert
HTITRE débiteur
4** S N Obligatoire si type débiteur différent de 7 et 8
**Montant TTC
pièce
16** N O Obligatoirement positif. Décimalisé à 2, doit être
égal au cumul des montants TTC lignes
**Code soumis à
reversement de
TVA
1** N O Valeurs autorisées :
O = Pièce soumise reversement de TVA
N = Pièce non soumise à reversement TVA
**Objet** (^100) S N Objet de la pièce

**Type de recette** (^1) N O Valeurs autorisées :
0 : Titre à recouvrer
1 : Perçue avant émission
2 Opération d’Ordre
**Date de pièce** (^8) Date O YYYYMMDD
**Code Avis des
sommes à payer
1** S O Code édition d’un avis des sommes à payer en plus
du titre : **O** pour Oui, **N** pour Non

### ➢ Message 2 : Lignes de pièce

**Rubrique** (^) **Long. Format Oblig. Commentaires
Type** (^2) S O Type du message :
RD : Pièce de recettes diverses
**Message** (^2) S O L1
**Mode** (^1) S O C
**Emetteur** (^15) S O NOM EMETTEUR
**Date de l’envoi 16** Date^ O Date de l’envoi au format :
YYYYMMDDHHMISSnn
**Individu
(émetteur du
message)
50** S O Individu au sens S3A qui a généré le message.
**No de pièce de
l’expéditeur
10** S O No d’identifiant unique de la pièce
**No de ligne** (^3) N O Numéro de ligne 001 à 999
**Compte
budgétaire
13** S O Format Lettre budget + No compte
**Code UF** (^4) N O Code UF d’affectation de la recette, doit appartenir
au même établissement géographique que les
autres lignes de cette pièce
**Quantité** (^11) N N Quantité de la ligne. Décimalisé à 3

**PU Hors taxe** (^16) N O Montant Hors taxe si le code reversement TVA de
l’entête est positionné à O et ligne soumise à
reversement de TVA. Montant TTC sinon.
Décimalisé à 4
**Code TVA** (^2) N N Obligatoire si code reversement TVA de l’entête
est positionné et ligne soumise à reversement de
TVA. Doit exister dans HEXAGONE WEB, Table
HXTVA
**Montant TTC
ligne
16** N O Le cumul des TTC lignes doit correspondre au TTC
de l’entête. Décimalisé à 2
**Désignation** (^31) S F Désignation de la ligne de pièce qui est reprise sur
les titres.
