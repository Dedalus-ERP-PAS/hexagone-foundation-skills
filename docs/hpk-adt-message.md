# Spécification des messages HPK ADT - Service Échange

Spécification de référence des messages HPK ADT (Admission, Discharge, Transfer) du Service Échange Hexagone. Ce document décrit les structures de données pour les messages d'identité (ID), mouvements (MV), couverture (CV) et autres types HPK.

> **Note technique** : ce document est une conversion automatique de la spécification Word officielle. Il sert de référence pour le skill `hpk-parser`.

# Introduction et présentation du document

-   ## Généralités

Ce document est destiné à toutes les personnes chargées du développement
et de l\'intégration des procédures de communication entre le S.I.H.
HEXAGONE et toute application communicante, autour des serveurs
d\'accréditation, de mouvements, d\'identité, et d\'actes.

L\'objectif est de décrire le fonctionnement du Service Echange, les
structures utilisées pour ce service, son implantation, ses
fonctionnalités, ainsi que la liste des messages véhiculés à ce jour.

L'écriture initiale du document fait suite à l\'analyse des besoins
exprimés par les sites quant à la communication des diverses
applications, notamment le *C.H. Région Annecienne*.

Ce document est transmis aux sociétés désirant utiliser les messages
pour assurer l\'intégrité des informations dans le cadre du S.I.H..

Le document est découpé en deux grandes parties :

1.  Le descriptif du Service Echange.

2.  La liste des messages gérés à ce jour.

# Terminologie

-   ## Composants

La communication entre les diverses applications s\'appuie sur
l\'utilisation de divers types de composants, répartis comme suit :

  -------------------- --------------------------------------------------
  Procédure C UNIX     Ces procédures permettent un déclenchement sur des
                       serveurs de type *UNIX*.

  Dll / Com / DCom     Ces fichiers contiennent des fonctions ou objets
                       qui sont appelés uniquement dans un environnement
                       *WINDOWS*.

  Procédure stockée    Il s\'agit d\'une procédure *ORACLE*, compilée
                       dans la base de données et activée avec les
                       paramètres adéquats.

  Exécutable / Script  Fichiers exécutables dans un environnement
  shell                *WINDOWS*, ou fichiers de script shell dans un
                       environnement *UNIX*, avec passage de paramètres.

  Fichier Texte        Il s\'agit de fichiers plats générés par les
                       applications. Ce type est celui de plus bas niveau
                       et ne permet pas de faire de la communication en
                       temps réel.

  Fichiers IHE/HL7     La communication peut se faire par fichiers texte
                       ou directement par ports réseaux, avec le standard
                       *HL7* en suivant les préconisations *IHE*.
  -------------------- --------------------------------------------------

-   ## Propriétés

Les divers composants utilisés pour la communication sont activés comme
décrit par le document, par le Service Echange. Ils sont fournis par la
société destinatrice, en respectant les normes des messages, ceci afin
de permettre à chaque société de dialoguer sur une même base tout en
gardant le respect des données privées de chaque application.

Le Service Echange activera les composants destinataires, mais en aucun
cas mettra à jour ou inscrira des données dans les bases de données des
diverses applications.

# Mécanisme de communication

-   ## Fonctionnement

Chaque événement concernant un utilisateur pour le serveur
d\'accréditation ou d\'un patient pour les serveurs d\'identité, de
mouvement ou d\'acte est enregistré dans la base de données HEXAGONE, et
génère un message dans la base ORACLE HEXAGONE.

Ce message est pris en charge par le Service Echange qui a en charge
l\'envoi de ce message aux autres applications (celles qui seront
référencées dans le Service Echange). Ce service se charge suivant le
message envoyé d\'activer le composant qui nous sera fourni pour chacune
des applications et qui sera en mesure de comprendre et de traiter ce
message.

Chaque application reçoit le message et renvoie un accusé de réception
au Service Echange. Cette information servira en cas d\'interruption de
la communication pour savoir quels sont les messages qui n\'ont jamais
été reçus et le cas échéant de les renvoyer.

### Processus de communication

Il existe deux type de processus :

1.  L\'envoi de messages liés à des évènements détectés dans la base
    HEXAGONE.

> Dans ce cas de figure, l\'évènement détecté active le Service Echange,
> pour la prise en charge du message. Ce dernier renvoie un accusé de
> réception pour indiquer la prise en charge et laisse l\'application
> continuer.
>
> Un processus permanent sur le serveur scrute en permanence les
> messages stockés par le Service Echange. Pour chaque message détecté,
> la liste des messages par destinataire est créée en prenant en compte
> le composant de communication. Un processus par destinataire est
> chargé de gérer l\'expédition pour chaque destinataire, ceci
> permettant de limiter le temps de communication pour chaque
> application au temps d\'exécution du composant de cette même
> application.
>
> Le composant appelé renvoie ou non un accusé de réception suivant ces
> fonctionnalités propres.
>
> Les messages sont mis en historiques et épurés en fonction du
> paramétrage du Service Echange. De même, en cas de non réponse des
> composants externes, la communication sera automatiquement interrompue
> après un nombre de tentatives paramétré, et le ou les administrateurs
> sont prévenus par courrier électronique.
>
> Il est aussi possible de planifier des arrêts de la communication pour
> la maintenance, ou de faire des arrêts immédiats.

2.  Les demandes de création des applications externes.

> La demande est prise en compte en mode synchrone, et l\'information de
> type IPP est retourné en temps réel. L\'application HEXAGONE génère
> des évènements et les gère selon le principe évoqué ci-dessus, mais en
> gérant un niveau de priorité maximal pour ce type de message.

### Schéma de communication :


\

### Format des messages :

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | UT = Utilisateur              |
|             | *2 |           |     |                               |
|             | ** |           |     | AC = Accréditation            |
|             |    |           |     |                               |
|             |    |           |     | ID = Identification patient   |
|             |    |           |     |                               |
|             |    |           |     | MV = Mouvements patients      |
|             |    |           |     |                               |
|             |    |           |     | KA = Actes patients           |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | Ce message sera fonction du   |
|             | *2 |           |     | type de message. Dans la      |
|             | ** |           |     | documentation vous trouverez  |
|             |    |           |     | le détail des messages ID et  |
|             |    |           |     | MV.                           |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression, Lecture.         |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
|             |    |           |     |                               |
|             |    |           |     | nn, est un chrono permettant  |
|             |    |           |     | d'identifier des messages     |
|             |    |           |     | émis dans la même seconde.    |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Le reste  |    |           |     |                               |
| est         |    |           |     |                               |
| fonction du |    |           |     |                               |
| message     |    |           |     |                               |
| vous        |    |           |     |                               |
| trouverez   |    |           |     |                               |
| le détail   |    |           |     |                               |
| des         |    |           |     |                               |
| messages MV |    |           |     |                               |
| et ID.**    |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Normes à respecter lors de la constitution de messages :

Il faut impérativement que la partie constante du message (c'est à dire
les 6 premières zones) soit en MAJUSCULES.

Le caractère séparateur des zones est le " \| " (pipe). Les longueurs
indiquées sont des longueurs maximales. Si le nom du patient est sur 10
caractères on aura :

\|NOMPATIENT\|

Quand une information n'est pas connue on met le " \| " séparateur de
champ sans aucune information. Par exemple, si la date de naissance
n'est pas connue on aura :

...\|IPP_ATIENT\|NOM\|PRENOM\|\|\|D\|Mr\|...

Attention

Des champs peuvent être rajoutés par Symphonie *On Line* à la fin des
messages, sans gêner la communication. Les applications destinataires ne
doivent donc pas se baser sur le nombre de champs dans le message, mais
uniquement sur les champs connus.

\

### Description des fonctions du service échange :

    ENVOI :\
    Cette fonction traite les messages en provenance d'HEXAGONE et à
    destination des applications externes. Elle stocke le message reçu
    dans la table des messages en attente et envoie un accusé de
    réception à HEXAGONE

    RECEPTION :\
    Cette fonction traite les messages en provenance des applications
    externes et à destination d'HEXAGONE. Elle stocke le message reçu
    dans la table des messages en attente et envoie un accusé de
    réception à l'application externe expéditrice, avec les informations
    clés nécessaire (N° IPP, par exemple).

    ACCUSE DE RECEPTION :\
    Cet accusé de réception du Service Echange consiste en trois
    paramètres.

> Prend
> les valeurs :
>
> 0 Reçu et pris en charge par le Service Echange.
>
> 1 Nombre de paramètres envoyés dans le message incorrects.

2.  Problème lors du stockage dans la base.

> 50 Problème mais demande de ré-envoi
>
> Statut
>
> Contexte de l'erreur survenue dans le Service Echange. Cette erreur
> pourra ou non être traitée par l'application qui a envoyé le message.
> Dans tous les cas, un fichier texte (d\'extension .log) sera alimenté
> lors de la détection d'une erreur par le Service Echange.

    MOTEUR DE GESTION DES MESSAGES :

> Cette
> fonction consiste en une application autonome qui tourne en
> permanence, qui scrute la table des messages en attente dans l'ordre
> chronologique d'émission, qui génère par destinataire les messages
> choisis, et qui active le composant sachant analyser et intégrer le
> message. Ensuite il supprime ou tope "à traiter" (suivant paramétrage)
> les messages dans la table des messages en attente.
>
> Le
> moteur essaiera de traiter toutes les demandes qu'il recevra. Dans le
> cas où il ne pourrait pas lancer le composant paramétré comme
> destinataire, le message sera laissé en attente, ou la communication
> sera désactivée suivant le paramétrage. Quand le Service Echange devra
> renvoyer un autre message à ce destinataire il renverra tous les
> messages antérieurs en attente (dont ceux qui n'auront pu être
> traités) afin d'assurer l'intégrité de la chronologie.
>
> Exemple : il ne faut pas qu'une application reçoive un message M6
> d'entrée dans une unité de soin si le message M1 de création du
> patient n'a pu être traité par cette même application.
>
> Dans
> le cas d\'envoi d\'informations au Service Echange (retour), il n'est
> pas nécessaire d'avoir le composant du destinataire sur tous les
> postes. Par contre, il peut être intéressant, pour des questions de
> performance de faire tourner ce composant sur plusieurs postes
> différents. Ceci est vrai dans le cas où les composants appelés ne
> fonctionnent que dans un environnement *Windows*. Si ce n\'est pas le
> cas, les composants sont directement activés depuis le serveur.
>
> Le
> run-time HEXAGONE doit être déployé sur tous les postes des
> applications communicantes s'il n'y a pas de poste dédié à la
> communication. Et aux seuls postes faisant des demandes au serveur
> dans le cas contraire.

# Messages Ressources Humaines

## Bulletins de salaire

### Mise au coffre-fort Digiposte d'un bulletin de salaire

Ce message est envoyé lorsqu'un bulletin est archivé à la clôture
mensuelle de la paie.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | RH = Ressources humaine.      |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | BS (Bulletin de salaire)      |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | \(C\) création                |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Poste**   | ** | S         | O   | Poste de travail ou ip        |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   |                               |
| *Metadata** | *2 |           |     |                               |
|             | 55 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **ARCHID**  | ** | S         | O   | AGENTDOC                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | O   | O                             |
| *ARCHETAT** | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **ARCHV1**  | *  | S         | O   | Matricule de l'agent          |
|             | *1 |           |     |                               |
|             | 00 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **ARCHV2**  | *  | S         | O   | BULLETIN                      |
|             | *1 |           |     |                               |
|             | 00 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **ARCHV5**  | *  | S         | O   | Année bulletin (YYYY)         |
|             | *1 |           |     |                               |
|             | 00 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **ARCHV6**  | *  | S         | O   | Mois bulletin \[1-12\]        |
|             | *1 |           |     |                               |
|             | 00 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
|             |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
|             |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
|             |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
|             |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
|             |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

#  Messages Structures et nomenclatures

-   ## Nomenclature : Utilisateur

### Création d\'un Utilisateur

Ce message est envoyé dès qu'un nouvel utilisateur est créé dans le
S.I.H. HEXAGONE.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | UT = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | A1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création                      |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Id        | ** | S         | N   | Numéro Identifiant personne   |
| Personne**  | 20 |           |     | (Unique)                      |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | ** | S         | O   | Code Utilisateur (Unique)     |
| Utilisateur | 50 |           |     |                               |
| (Individu   | ** |           |     |                               |
| créé)**     |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mot de    | ** | S         | O   | Mot de passe de               |
| passe**     | 50 |           |     | l\'utilisateur.\              |
|             | ** |           |     | **Attention** :\              |
|             |    |           |     | Le code utilisateur est       |
|             |    |           |     | transmis en clair pour        |
|             |    |           |     | permettre à chaque            |
|             |    |           |     | destinataire d\'utiliser sa   |
|             |    |           |     | procédure de cryptage privée. |
|             |    |           |     | Par contre les messages       |
|             |    |           |     | stockés, le sont avec le mot  |
|             |    |           |     | de passe crypté.              |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé   | ** | S         | N   | Libellé complet de            |
| complet**   | 50 |           |     | l\'utilisateur.               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé   | ** | S         | N   | Libellé court de              |
| court**     | 25 |           |     | l\'utilisateur.               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Durée de  | *  | N         | O   | Durée de vie du mot de passe  |
| validité du | *3 |           |     | de l\'utilisateur. La valeur  |
| mot de      | ** |           |     | est à 999 pour un mot de      |
| passe**     |    |           |     | passe qui n\'expire jamais.   |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse   | ** | S         | N   | Adresse E-mail de             |
| Ele         | 50 |           |     | l\'utilisateur                |
| ctronique** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | U Utilisateur                 |
|             | *1 |           |     |                               |
|             | ** |           |     | P Profil                      |
+-------------+----+-----------+-----+-------------------------------+
| **Profil**  | ** | S         | N   | Renseigné que si              |
|             | 50 |           |     | l'utilisateur appartient à un |
|             | ** |           |     | profil                        |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | N   | Date de fin de validité d'un  |
| fin de      | 10 |           |     | utilisateur. Format YYYYMMDD  |
| validité    | ** |           |     |                               |
| d'un        |    |           |     |                               |
| ut          |    |           |     |                               |
| ilisateur** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Activé ou | *  | S         | N   | La connexion à l'application  |
| désactivé** | *1 |           |     | peut-être désactivée          |
|             | ** |           |     | temporairement.               |
+-------------+----+-----------+-----+-------------------------------+
| **          | ** | S         | N   | Matricule de l\'utilisateur   |
| Matricule** | 10 |           |     | (Ref : agent)                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **ID CPS**  | ** | S         | N   | Identifiant CPS               |
|             | 50 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Modification d\'un Utilisateur 

Ce message est envoyé dès qu'une information de l\'utilisateur est
modifiée (libellé, mot de passe, adresse E-mail, etc..)

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | UT = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | A1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Modification                  |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Id        | ** | S         | N   | Numéro Identifiant personne   |
| Personne**  | 20 |           |     | (Unique)                      |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | ** | S         | O   | Code Utilisateur (Unique)l    |
| Utilisateur | 50 |           |     |                               |
| (individu   | ** |           |     |                               |
| modifié)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mot de    | ** | S         | O   | Mot de passe de               |
| passe**     | 50 |           |     | l\'utilisateur.\              |
|             | ** |           |     | **Attention** :\              |
|             |    |           |     | Le code utilisateur est       |
|             |    |           |     | transmis en clair pour        |
|             |    |           |     | permettre à chaque            |
|             |    |           |     | destinataire d\'utiliser sa   |
|             |    |           |     | procédure de cryptage privée. |
|             |    |           |     | Par contre les messages       |
|             |    |           |     | stockés, le sont avec le mot  |
|             |    |           |     | de passe crypté.              |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé   | ** | S         | N   | Libellé complet de            |
| complet**   | 50 |           |     | l\'utilisateur.               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé   | ** | S         | N   | Libellé court de              |
| court**     | 25 |           |     | l\'utilisateur.               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Durée de  | *  | N         | O   | Durée de validitéie du mot de |
| validité du | *3 |           |     | passe de l\'utilisateur. La   |
| mot de      | ** |           |     | valeur est à 999 pour un mot  |
| passe**     |    |           |     | de passe qui n\'expire        |
|             |    |           |     | jamais.                       |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse   | ** | S         | N   | Adresse E-mail de             |
| Ele         | 50 |           |     | l\'utilisateur                |
| ctronique** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | U Utilisateur                 |
|             | *1 |           |     |                               |
|             | ** |           |     | P Profil                      |
+-------------+----+-----------+-----+-------------------------------+
| **Profil**  | ** | S         | N   | Renseigné que si              |
|             | 50 |           |     | l'utilisateur appartient à un |
|             | ** |           |     | profil                        |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | N   | Date de fin de validité d'un  |
| fin de      | 10 |           |     | utilisateur. Format YYYYMMDD  |
| validité    | ** |           |     |                               |
| d'un        |    |           |     |                               |
| ut          |    |           |     |                               |
| ilisateur** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Activé ou | *  | S         | N   | La connexion à l'application  |
| désactivé** | *1 |           |     | peut-être désactivée          |
|             | ** |           |     | temporairement.               |
+-------------+----+-----------+-----+-------------------------------+
| **          | ** | S         | N   | Matricule de l\'utilisateur   |
| Matricule** | 10 |           |     | (Ref : agent)                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **ID CPS**  | ** | S         | N   | Identifiant CPS               |
|             | 50 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

\

### Suppression d\'un Utilisateur 

Ce message est envoyé dès qu\'un individu HEXAGONE est supprimé.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | UT = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | A1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Suppression                   |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Id        | ** | S         | N   | Numéro Identifiant personne   |
| Personne**  | 20 |           |     | (Unique)                      |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | ** | S         | O   | Code Utilisateur (Unique)l    |
| Utilisateur | 50 |           |     |                               |
| (individu   | ** |           |     |                               |
| supprimé)** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

-   ## Structure : Etablissement juridique

L'établissement juridique est émis à la première mise a jour en création
(ou en synchronisation de démarrage). Ensuite, il n'y a que des messages
de modifications.

### Création ou modification d'un établissement juridique

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | ST = Structures.              |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | EJ (Etablissement Juridique)  |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | C(création) ou M              |
|             | *1 |           |     | (modification)                |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | O   | Numéro identifiant            |
| étab        | *3 |           |     | l'établissement juridique     |
| lissement** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libelle** | ** | S         | N   | Libelle de l'établissement    |
|             | 50 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse   | ** | S         | N   | Adresse 1 de l'établissement  |
| 1**         | 32 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse   | ** | S         | N   | Adresse 2 de l'établissement  |
| 2**         | 32 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Ville**   | ** | S         | N   |                               |
|             | 32 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   | Code postal de                |
| postal**    | *5 |           |     | l'établissement               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Bureau    | ** | S         | N   |                               |
| dis         | 27 |           |     |                               |
| tributeur** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Cedex**   | ** | S         | N   | Code cedex de l'établissement |
|             | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Dé        | *  | S         | N   | Code département INSEE de     |
| partement** | *3 |           |     | l'établissement               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Commune** | *  | S         | N   | Code commune INSEE de         |
|             | *3 |           |     | l'établissement               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Région**  | *  | S         | N   | Code région INSEE de          |
|             | *3 |           |     | l'établissement               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Comptable | ** | S         | N   | Nom du comptable assignataire |
| ass         | 50 |           |     | de l'établissement (Mr Le     |
| ignataire** | ** |           |     | Receveur, M. Le trésorier, M. |
|             |    |           |     | Le comptable en chef etc.)    |
+-------------+----+-----------+-----+-------------------------------+
| **Compte    | ** | S         | N   | N° du compte de               |
| CCP**       | 11 |           |     | l'établissement postal.       |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Agence**  | ** | S         | N   | Nom de l'agence               |
|             | 24 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **FINESS**  | *  | N         | N   | N° FINESS de l'établissement  |
|             | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **SIREN**   | *  | S         | N   | N° SIREN de l'établissement   |
|             | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **APE**     | *  | S         | N   | Code APE                      |
|             | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | S         | N   | Catégorie d'établissement     |
| Catégorie** | *3 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Statut    | *  | S         | N   |                               |
| juridique** | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **PSIH**    | *  | S         | N   | 1 pour les PSIH               |
|             | *1 |           |     |                               |
|             | ** |           |     | 2 pour les PSPH               |
|             |    |           |     |                               |
|             |    |           |     | 3 pour les Centres de santé   |
|             |    |           |     |                               |
|             |    |           |     | 4 pour les Cliniques          |
+-------------+----+-----------+-----+-------------------------------+
| **PSPH**    | *  | S         | N   | (Réservé)                     |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Secteur   | *  | S         | N   |                               |
| Sanitaire** | *3 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **INSEE**   | *  | S         | N   |                               |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Horaire   | ** | N         | N   | Nombres d'heures de           |
| de          | 10 |           |     | références                    |
| référence** | .2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | S         | N   |                               |
| URSSAF**    | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse 1 | ** | S         | N   |                               |
| URSSAF**    | 32 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse 2 | ** | S         | N   |                               |
| URSSAF**    | 32 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   |                               |
| postal      | *5 |           |     |                               |
| URSSAF**    | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Ville     | ** | S         | N   |                               |
| URSSAF**    | 32 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Bureau    | ** | S         | N   |                               |
| d           | 27 |           |     |                               |
| istributeur | ** |           |     |                               |
| URSSAF**    |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   |                               |
| banque**    | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   |                               |
| guichet**   | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Clé RIB** | *  | N         | N   |                               |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **          | ** | S         | N   | N° de téléphone de            |
| Telephone** | 16 |           |     | l'établissement               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Télex**   | ** | S         | N   | N° de télex de                |
|             | 16 |           |     | l'établissement               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Fax**     | ** | S         | N   | N° de Fax de l'établissement  |
|             | 16 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **E-mail**  | ** | S         | N   | Adresse E-mail de             |
|             | 50 |           |     | l'établissement (Ex :         |
|             | ** |           |     | info@etablissement.fr)        |
+-------------+----+-----------+-----+-------------------------------+
| **Site      | ** | S         | N   | Adresse de site web (URL)     |
| web**       | 50 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | *  | D         | N   | YYYYMMDD                      |
| mise en     | *8 |           |     |                               |
| oeuvre**    | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IBAN**    | ** | S         | N   | IBAN = International Bank     |
|             | 32 |           |     | Account Number                |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **BIC**     | ** | S         | N   | BIC = Bank Identifier Code    |
|             | 11 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Suppression d'un établissement juridique

Il n'existe pas de message de suppression d'un établissement juridique.
Il ne peut y avoir qu'un seul établissement juridique, créé une fois, et
ensuite uniquement modifié.

-   ## Structure : Etablissements géographiques

### Création d'un établissement géographique

Ce message est envoyé lors de la création d'un établissement
géographique.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | ST = Structures.              |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | EG (Etablissement             |
|             | *2 |           |     | géographique)                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | C (création)                  |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | O   |                               |
| ét          | *2 |           |     |                               |
| ablissement | ** |           |     |                               |
| géo         |    |           |     |                               |
| graphique** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libelle   | ** | S         | N   |                               |
| ét          | 50 |           |     |                               |
| ablissement | ** |           |     |                               |
| géo         |    |           |     |                               |
| graphique** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse   | ** | S         | N   | Adresse 1 de l'établissement  |
| 1**         | 32 |           |     | géographique                  |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse   | ** | S         | N   | Adresse 2 de l'établissement  |
| 2**         | 32 |           |     | géographique.                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Ville**   | ** | S         | N   |                               |
|             | 32 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   | Code postal de                |
| postal**    | *5 |           |     | l'établissement géographique  |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Bureau    | ** | S         | N   |                               |
| dis         | 27 |           |     |                               |
| tributeur** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **FINESS**  | *  | N         | N   | N° FINESS                     |
|             | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **SIRET**   | ** | S         | N   | N° SIRET                      |
|             | 14 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nombre de | *  | N         | N   |                               |
| lits        | *5 |           |     |                               |
| ouverts**   | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Et        | *  | S         | O   | T/F valeur booléenne          |
| ablissement | *1 |           |     |                               |
| compl       | ** |           |     |                               |
| émentaire** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Budget    | *  | S         | O   | T/F valeur booléenne,         |
| global**    | *1 |           |     | établissement au budget       |
|             | ** |           |     | global.                       |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | *  | D         | O   | YYYYMMDD                      |
| début de    | *8 |           |     |                               |
| validité**  | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | *  | D         | N   | YYYYMMDD                      |
| fin de      | *8 |           |     |                               |
| validité**  | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Et        | *  | N         | O   | Code établissement juridique  |
| ablissement | *3 |           |     |                               |
| juridique** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Modification d'un établissement géographique

Ce message est envoyé pour chaque modification d'un établissement
géographique.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | ST = Structures.              |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | EG (Etablissement             |
|             | *2 |           |     | géographique)                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | M (modification)              |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | O   |                               |
| ét          | *2 |           |     |                               |
| ablissement | ** |           |     |                               |
| géo         |    |           |     |                               |
| graphique** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libelle   | ** | S         | N   |                               |
| ét          | 50 |           |     |                               |
| ablissement | ** |           |     |                               |
| géo         |    |           |     |                               |
| graphique** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse   | ** | S         | N   | Adresse 1 de l'établissement  |
| 1**         | 32 |           |     | géographique                  |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Adresse   | ** | S         | N   | Adresse 2 de l'établissement  |
| 2**         | 32 |           |     | géographique.                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Ville**   | ** | S         | N   |                               |
|             | 32 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   | Code postal de                |
| postal**    | *5 |           |     | l'établissement géographique  |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Bureau    | ** | S         | N   |                               |
| dis         | 27 |           |     |                               |
| tributeur** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **FINESS**  | *  | N         | N   | N° FINESS                     |
|             | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **SIRET**   | ** | S         | N   | N° SIRET                      |
|             | 14 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nombre de | *  | N         | N   |                               |
| lits        | *5 |           |     |                               |
| ouverts**   | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Et        | *  | S         | O   | T/F valeur booléenne          |
| ablissement | *1 |           |     |                               |
| compl       | ** |           |     |                               |
| émentaire** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Budget    | *  | S         | O   | T/F valeur booléenne,         |
| global**    | *1 |           |     | établissement au budget       |
|             | ** |           |     | global.                       |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | *  | D         | O   | YYYYMMDD                      |
| début de    | *8 |           |     |                               |
| validité**  | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | *  | D         | N   | YYYYMMDD                      |
| fin de      | *8 |           |     |                               |
| validité**  | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Et        | *  | N         | O   | Code établissement juridique  |
| ablissement | *3 |           |     |                               |
| juridique** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Suppression d'un établissement géographique

Il n'existe pas de message de suppression d'établissement géographique.
La mise hors service est réalisée avec les dates de fin de validité.

-   ## Structure : Bâtiment

### Création d\'un bâtiment

Ce message est émis à chaque création d'un nouveau bâtiment.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | BA                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom de   | ** | S         | N   | Nom du bâtiment                 |
| bâtiment** | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Modification d\'un bâtiment

Ce message est émis à chaque modification d'un bâtiment.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | BA                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom de   | ** | S         | N   | Nom du bâtiment                 |
| bâtiment** | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### 

###  Suppression d\'un bâtiment

Ce message est émis à chaque suppression d'un bâtiment.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | BA                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom de   | ** | S         | N   | Nom du bâtiment                 |
| bâtiment** | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

-   ## Structure : Etage

### Création d\'un étage

Ce message est émis à chaque création d'un nouvel étage.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | ET                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | O   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom de   | ** | S         | N   | Nom de l'étage                  |
| l'étage**  | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Modification d\'un étage

Ce message est émis à chaque modification d'un étage.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | ET                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | O   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom de   | ** | S         | N   | Nom de l'étage                  |
| l'étage**  | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### 

###  Suppression d\'un étage

Ce message est émis à chaque suppression d'un étage.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | ET                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | O   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom de   | ** | S         | N   | Nom de l'étage                  |
| l'étage**  | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

-   ##  Structure : Pièces

### Création d\'une pièce

Ce message est émis à chaque création d'une nouvelle pièce.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | CH                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code pièce                      |
| pièce**    | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgences                    |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **NB lit** | *  | N         | N   | Nombre de lit                   |
|            | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### 

###  Modification d\'une pièce

Ce message est émis à chaque modification d'une pièce

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | CH                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code pièce                      |
| pièce**    | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgences                    |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **NB lit** | *  | N         | N   | Nombre de lit                   |
|            | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### 

###  Suppression d\'une pièce

Ce message est émis à chaque suppression d'une pièce.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | CH                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code pièce                      |
| pièce**    | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgences                    |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **NB lit** | *  | N         | N   | Nombre de lit                   |
|            | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

-   ## Structure : Pièces/UF

### Création d\'un lien Pièce/UF

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | UP                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code pièce                      |
| pièce**    | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | N   | Exercice                        |
| Exercice** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Liste    | ** | S         | N   | Liste d'UF séparées par des \~  |
| d'UF**     | \* |           |     | (Ex : 2203\~2204)               |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgence Box                 |
+------------+----+-----------+-----+---------------------------------+

### 

###  

### Modification d\'un lien Pièce/UF

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | UP                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code pièce                      |
| pièce**    | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | N   | Exercice                        |
| Exercice** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Liste    | ** | S         | N   | Liste d'UF séparées par des \~  |
| d'UF**     | \* |           |     | (Ex : 2203\~2204)               |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgence Box                 |
+------------+----+-----------+-----+---------------------------------+

###  Suppression Pièces/UF

Ce message est émis à chaque fois qu'une pièce n'est plus rattachée à
aucune UF.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | UP                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code pièce                      |
| pièce**    | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | N   | Exercice                        |
| Exercice** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Liste    | ** | S         | N   | = « «                           |
| d'UF**     | \* |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgence Box                 |
+------------+----+-----------+-----+---------------------------------+

-   ## Structure : Lit

### Création d\'un lit

Ce message est émis à chaque création d'un nouveau lit.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | LI                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lit**    | *  | S         | O   | Lit                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | N   | Chambre                         |
| *Chambre** | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **T        | ** | S         | N   | Téléphone                       |
| éléphone** | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lit      | *  | S         | N   | Lit supprimé O/N                |
| sup**      | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgence Box                 |
+------------+----+-----------+-----+---------------------------------+

### 

###  

### Modification d\'un lit

Ce message est émis à chaque modification d'un lit.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | LI                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lit**    | *  | S         | O   | Lit                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | N   | Chambre                         |
| *Chambre** | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **T        | ** | S         | N   | Téléphone                       |
| éléphone** | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lit      | *  | S         | N   | Lit supprimé O/N                |
| sup**      | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgence Box                 |
+------------+----+-----------+-----+---------------------------------+

### 

###  Suppression d\'un lit

Ce message est émis à chaque suppression d'un lit.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | LI                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lit**    | *  | S         | O   | Lit                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | N   | Chambre                         |
| *Chambre** | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **T        | ** | S         | N   | Téléphone                       |
| éléphone** | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lit      | *  | S         | N   | Lit supprimé O/N                |
| sup**      | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type : C = Chambre              |
|            | *1 |           |     |                                 |
|            | ** |           |     | T = en attente                  |
|            |    |           |     |                                 |
|            |    |           |     | S = Salle                       |
|            |    |           |     |                                 |
|            |    |           |     | B = Bureau                      |
|            |    |           |     |                                 |
|            |    |           |     | X = Examen                      |
|            |    |           |     |                                 |
|            |    |           |     | U = Urgence Box                 |
+------------+----+-----------+-----+---------------------------------+

-   ## Structure Box

Ce message est envoyé lors d'une création, modification ou suppression
d'un box.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | B1                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (création) ou M               |
|            | *1 |           |     | (modification) ou S             |
|            | ** |           |     | (suppression)                   |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Box**    | *  | S         | O   | Box                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Salle    | *  | S         | N   | Salle d'urgence                 |
| d          | *6 |           |     |                                 |
| 'urgence** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché le bâtiment |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Code bâtiment                   |
| Bâtiment** | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Etage**  | *  | S         | N   | Etage                           |
|            | *8 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Accueil  | *  | Boolean   | N   | Accueil illimité                |
| illimité** | *B |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nombre   | *  | N         | N   | Nombre de patient               |
| de         | *3 |           |     |                                 |
| patient**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type de  | *  | S         | N   | Type de patient :               |
| patient**  | *1 |           |     |                                 |
|            | ** |           |     | -   C (Consultant)              |
|            |    |           |     |                                 |
|            |    |           |     | -   H (Hospitalisés)            |
|            |    |           |     |                                 |
|            |    |           |     | -   T (Tous)                    |
+------------+----+-----------+-----+---------------------------------+
| **Zone**   | ** | S         | N   | Zone à laquelle appartient le   |
|            | 10 |           |     | box                             |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | N   | Secteur auquel appartient le    |
| *Secteur** | 10 |           |     | box                             |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

-   ##  Structure Zone

Ce message est envoyé lors d'une création, modification ou suppression
d'une zone.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | ZO                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (création) ou M               |
|            | *1 |           |     | (modification) ou S             |
|            | ** |           |     | (suppression)                   |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Zone**   | ** | S         | O   | Zone                            |
|            | 10 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé long                    |
| long**     | 30 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé court                   |
| court**    | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

-   ## Structure Secteur

Ce message est envoyé lors d'une création, modification ou suppression
d'un secteur.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | SC                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (création) ou M               |
|            | *1 |           |     | (modification) ou S             |
|            | ** |           |     | (suppression)                   |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Zone**   | ** | S         | O   | Zone à laquelle est rattachée   |
|            | 10 |           |     | le secteur                      |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | O   | Secteur                         |
| *Secteur** | 10 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | N   | Libellé                         |
| *Libellé** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | N   | Type de secteur :               |
|            | *1 |           |     |                                 |
|            | ** |           |     | C = Chambre                     |
|            |    |           |     |                                 |
|            |    |           |     | P = Visualisation radio         |
|            |    |           |     |                                 |
|            |    |           |     | U = Salle d'urgence             |
|            |    |           |     |                                 |
|            |    |           |     | T = Attente                     |
|            |    |           |     |                                 |
|            |    |           |     | L = Localisation                |
+------------+----+-----------+-----+---------------------------------+
| **Loca     | ** | S         | N   | Localisation à renseigner       |
| lisation** | 10 |           |     | uniquement si type = L          |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

-   ## Structure : Services

### Création d\'un service

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | SV                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | N         | O   | Service                         |
| *Service** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé long                    |
| long**     | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé court                   |
| court**    | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | N   | Exercice                        |
| Exercice** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lettre   | *  | S         | N   | Lettre budget                   |
| budget**   | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Discipline d\'équipement        |
| Discipline | *3 |           |     |                                 |
| d\'éq      | ** |           |     |                                 |
| uipement** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type     | *  | S         | O   | Type d\'activité                |
| d\'        | *2 |           |     |                                 |
| activité** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nbre de  | *  | N         | N   | Nbre de lits ouverts            |
| lits       | *5 |           |     |                                 |
| ouverts**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Modification d\'un service

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | SV                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | N         | O   | Service                         |
| *Service** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé long                    |
| long**     | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé court                   |
| court**    | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | N   | Exercice                        |
| Exercice** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lettre   | *  | S         | N   | Lettre budget                   |
| budget**   | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Discipline d\'équipement        |
| Discipline | *3 |           |     |                                 |
| d\'éq      | ** |           |     |                                 |
| uipement** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type     | *  | S         | O   | Type d\'activité                |
| d\'        | *2 |           |     |                                 |
| activité** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nbre de  | *  | N         | N   | Nbre de lits ouverts            |
| lits       | *5 |           |     |                                 |
| ouverts**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

###  Suppression d\'un service

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ST = Structure.                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | SV                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S (Suppression)                 |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | N         | O   | Service                         |
| *Service** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé long                    |
| long**     | 35 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé court                   |
| court**    | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | N   | Exercice                        |
| Exercice** | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lettre   | *  | S         | N   | Lettre budget                   |
| budget**   | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | Discipline d\'équipement        |
| Discipline | *3 |           |     |                                 |
| d\'éq      | ** |           |     |                                 |
| uipement** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type     | *  | S         | O   | Type d\'activité                |
| d\'        | *2 |           |     |                                 |
| activité** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nbre de  | *  | N         | N   | Nbre de lits ouverts            |
| lits       | *5 |           |     |                                 |
| ouverts**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Code établissement juridique    |
| blissement | *3 |           |     |                                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

-   ## Structure : Unités fonctionnelles

### Création d\'une Unité fonctionnelle (UF)

Les unités fonctionnelles ne sont émises qu'après avoir été validées
dans le S.I.H. Hexagone. Un message de création d'Unité Fonctionnelle
est émis lors du changement d'exercice toujours après validation de ce
nouvel exercice. A ce jour, ce message n'est disponible qu'en émission.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | UF = Unité fonctionnelle.       |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | U1                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | O   | Exercice comptable de validité  |
| Exercice** | *4 |           |     | de l'UF                         |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **UF**     | *  | N         | O   | Code Unité fonctionnelle        |
|            | *4 |           |     | (Unique pour un exercice        |
|            | ** |           |     | comptable)                      |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | N   | Libellé de l'unité              |
| *Libelle** | 30 |           |     | fonctionnelle.                  |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé court de l'unité        |
| court**    | 15 |           |     | fonctionnelle.                  |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lettre   | *  | S         | O   | Lettre correspondant au budget  |
| budget**   | *1 |           |     | de l'unité fonctionnelle.       |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Centre   | *  | N         | O   | Centre de responsabilité auquel |
| de         | *4 |           |     | est rattaché l'UF.              |
| respon     | ** |           |     |                                 |
| sabilité** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | UF magasin O Magasin principal\ |
| magasin**  | *1 |           |     | A Magasin Auxiliaire\           |
|            | ** |           |     | N Non magasin.                  |
+------------+----+-----------+-----+---------------------------------+
| **Unité    | *  | N         | N   | Unité médicale de rattachement  |
| médicale** | *4 |           |     | si elle existe.                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **UF       | *  | S         | O   | UF médicale (oui ou Non)        |
| Médicale** | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Service  | *  | N         | N   | S'il s'agit d'une UF médicale,  |
| Médical**  | *4 |           |     | alors le service médical est    |
|            | ** |           |     | renseigné dans cette zone.      |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché l'UF        |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Section  | ** | S         | N   | Section analytique a objectif   |
| d          | 10 |           |     | de comptabilité analytique.     |
| 'analyse** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type     | *  | S         | N   | Type d'activité de l'UF         |
| d'         | *2 |           |     |                                 |
| activité** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | N   | Code discipline d'équipement de |
| Discipline | *3 |           |     | l'UF                            |
| d'éq       | ** |           |     |                                 |
| uipement** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **UF       | *  | S         | O   | L'UF est une UF d'URGENCE (Oui  |
| d          | *1 |           |     | Non)                            |
| 'urgence** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Séjour   | *  | S         | O   | L'UF gère des séjours           |
| co         | *1 |           |     | consécutifs (Oui Non)           |
| nsécutif** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Venue**  | *  | S         | O   | L'UF gère des venue (Oui Non)   |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Séance** | *  | S         | O   | L'UF gère des séances (Oui Non) |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **P        | *  | S         | O   | L'UF produit des actes (Oui     |
| roductrice | *1 |           |     | Non)                            |
| d'actes**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | L'UF produit des prestations    |
| Prestation | *1 |           |     | Hôtelière (Oui Non).            |
| H          | ** |           |     |                                 |
| ôtelière** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nombre   | *  | N         | N   | Nombre de lits ouverts pour     |
| de lits    | *5 |           |     | cette UF.                       |
| ouverts**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **N°       | *  | N         | N   | N° finess                       |
| Finess**   | *9 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type de  | *  | N         | N   | 1 : Séjour de courte durée (CS) |
| séjour**   | *1 |           |     |                                 |
|            | ** |           |     | 2 : Soins de suite (MS)         |
|            |    |           |     |                                 |
|            |    |           |     | 3 : Soins longue durée (LS/MR)  |
|            |    |           |     |                                 |
|            |    |           |     | 4 : Psychiatrie                 |
|            |    |           |     |                                 |
|            |    |           |     | 5 : Externes                    |
|            |    |           |     |                                 |
|            |    |           |     | 6 : Hospit de jour              |
|            |    |           |     |                                 |
|            |    |           |     | 7 : Hospit de nuit              |
|            |    |           |     |                                 |
|            |    |           |     | 8 : Séances                     |
+------------+----+-----------+-----+---------------------------------+
| **Type de  | *  | S         | N   | Le type de PMSI est déduit du   |
| PMSI**     | *3 |           |     | type de séjour.                 |
|            | ** |           |     |                                 |
|            |    |           |     | Type séjour = 1,6,7,8  MCO     |
|            |    |           |     |                                 |
|            |    |           |     | =2 SSR                       |
|            |    |           |     |                                 |
|            |    |           |     | = 4 PSY                      |
|            |    |           |     |                                 |
|            |    |           |     | Pour le HAD : Si le type        |
|            |    |           |     | d'activité =06 on envoie en     |
|            |    |           |     | type PMSI : HAD                 |
|            |    |           |     |                                 |
|            |    |           |     | Dans tous les autres cas on     |
|            |    |           |     | envoie la valeur nul.           |
+------------+----+-----------+-----+---------------------------------+

### 

###  Modification d\'une Unité fonctionnelle (UF)

Ce message n'est disponible qu'en émission. Il sera émis a chaque
modification d'une UF, et uniquement si cette modification porte sur des
UF validées dans le S.I.H. Hexagone v7.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | UF = Unité fonctionnelle.       |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | U1                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | O   | Exercice comptable de validité  |
| Exercice** | *4 |           |     | de l'UF                         |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **UF**     | *  | N         | O   | Code Unité fonctionnelle        |
|            | *4 |           |     | (Unique pour un exercice        |
|            | ** |           |     | comptable)                      |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | N   | Libellé de l'unité              |
| *Libelle** | 30 |           |     | fonctionnelle.                  |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé court de l'unité        |
| court**    | 15 |           |     | fonctionnelle.                  |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lettre   | *  | S         | O   | Lettre correspondant au budget  |
| budget**   | *1 |           |     | de l'unité fonctionnelle.       |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Centre   | *  | N         | O   | Centre de responsabilité auquel |
| de         | *4 |           |     | est rattaché l'UF.              |
| respon     | ** |           |     |                                 |
| sabilité** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | UF magasin O Magasin proncipal\ |
| magasin**  | *1 |           |     | A Magasin Auxiliaire\           |
|            | ** |           |     | N Non magasin.                  |
+------------+----+-----------+-----+---------------------------------+
| **Unité    | *  | N         | N   | Unité médicale de rattachement  |
| médicale** | *4 |           |     | si elle existe.                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **UF       | *  | S         | O   | UF médicale (oui ou Non)        |
| Médicale** | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Service  | *  | N         | N   | S'il s'agit d'une UF médicale,  |
| Médical**  | *4 |           |     | alors le service médical est    |
|            | ** |           |     | renseigné dans cette zone.      |
+------------+----+-----------+-----+---------------------------------+
| **Eta      | *  | N         | O   | Etablissement géographique      |
| blissement | *2 |           |     | auquel est rattaché l'UF        |
| géog       | ** |           |     |                                 |
| raphique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Section  | ** | S         | N   | Section analytique a objectif   |
| d          | 10 |           |     | de comptabilité analytique.     |
| 'analyse** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type     | *  | S         | N   | Type d'activité de l'UF         |
| d'         | *2 |           |     |                                 |
| activité** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | N   | Code discipline d'équipement de |
| Discipline | *3 |           |     | l'UF                            |
| d'éq       | ** |           |     |                                 |
| uipement** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **UF       | *  | S         | O   | L'UF est une UF d'URGENCE (Oui  |
| d          | *1 |           |     | Non)                            |
| 'urgence** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Séjour   | *  | S         | O   | L'UF gère des séjours           |
| co         | *1 |           |     | consécutifs (Oui Non)           |
| nsécutif** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Venue**  | *  | S         | O   | L'UF gère des venue (Oui Non)   |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Séance** | *  | S         | O   | L'UF gère des séances (Oui Non) |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **P        | *  | S         | O   | L'UF produit des actes (Oui     |
| roductrice | *1 |           |     | Non)                            |
| d'actes**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | O   | L'UF produit des prestations    |
| Prestation | *1 |           |     | Hôtelière (Oui Non).            |
| H          | ** |           |     |                                 |
| ôtelière** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nombre   | *  | N         | N   | Nombre de lits ouverts pour     |
| de lits    | *5 |           |     | cette UF.                       |
| ouverts**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **N°       | *  | N         | N   | N° finess                       |
| Finess**   | *9 |           |     |                                 |
|            | ** |           |     | (Alimenté dés que la            |
|            |    |           |     | comptabilité est géré par       |
|            |    |           |     | Sigale)                         |
+------------+----+-----------+-----+---------------------------------+
| **Type de  | *  | N         | N   | 1 : Séjour de courte durée (CS) |
| séjour**   | *1 |           |     |                                 |
|            | ** |           |     | 2 : Soins de suite (MS)         |
|            |    |           |     |                                 |
|            |    |           |     | 3 : Soins longue durée (LS/MR)  |
|            |    |           |     |                                 |
|            |    |           |     | 4 : Psychiatrie                 |
|            |    |           |     |                                 |
|            |    |           |     | 5 : Externes                    |
|            |    |           |     |                                 |
|            |    |           |     | 6 : Hospit de jour              |
|            |    |           |     |                                 |
|            |    |           |     | 7 : Hospit de nuit              |
|            |    |           |     |                                 |
|            |    |           |     | 8 : Séances                     |
+------------+----+-----------+-----+---------------------------------+
| **Type de  | *  | S         | N   | Le type de PMSI est déduit du   |
| PMSI**     | *3 |           |     | type de séjour.                 |
|            | ** |           |     |                                 |
|            |    |           |     | Type séjour = 1,6,7,8  MCO     |
|            |    |           |     |                                 |
|            |    |           |     | =2 SSR                       |
|            |    |           |     |                                 |
|            |    |           |     | = 4 PSY                      |
|            |    |           |     |                                 |
|            |    |           |     | Pour le HAD : Si                |
|            |    |           |     | TAACC.HXUNITE=06 on envoie en   |
|            |    |           |     | TYPE PMSI : HAD                 |
|            |    |           |     |                                 |
|            |    |           |     | Dans tous les autres cas on     |
|            |    |           |     | envoie la valeur nul.           |
+------------+----+-----------+-----+---------------------------------+

### Mise hors service d\'une Unité fonctionnelle (UF)

Ce message n'est émis que si une UF est annulée logiquement (mise hors
service). Ce message peut être émis en prévisionnel, il faut donc
regarder la date de mise hors service.. A ce jour, ce message n'est
disponible qu'en émission.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | UF = Unité fonctionnelle.       |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | U1                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S (Mise hors service            |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | N         | O   | Exercice comptable de validité  |
| Exercice** | *4 |           |     | de l'UF                         |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **UF**     | *  | N         | O   | Code Unité fonctionnelle        |
|            | *4 |           |     | (Unique pour un exercice        |
|            | ** |           |     | comptable)                      |
+------------+----+-----------+-----+---------------------------------+
| **Date     | *  | D         | N   | Ce code indique a compter de    |
| d'an       | *8 |           |     | quelle date l'UF sera annulée.  |
| nulation** | ** |           |     | Le format est YYYYMMDD.         |
+------------+----+-----------+-----+---------------------------------+

-   ## Structure : Centres de responsabilité

### Création d'un centre de responsabilité

  ------------------ ----------- ------------ ------------ ----------------------------------
  **Rubrique**       **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**           **2**       S            O            ST = Structure

  **Message**        **2**       S            O            CR (Centres de responsabilités)

  **Mode**           **1**       S            O            C (Création)

  **Emetteur**       **15**      S            O            HEXAGONE

  **Date de          **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                                YYYYMMDDHHMISSnn

  **Individu         **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                             le message.
  message)**                                               

  **Exercice**       **4**       N            O            Exercice comptable

  **Centre de        **4**       N            O            Centre de reponsabilité
  responsabilité**                                         

  **Libellé**        **30**      S            O            Libellé

  **Responsable**    **30**      S            N            Nom du responsable

  **Lettre budget**  **1**       S            O            Lettre budget

  **Date de début de **8**       D            O            YYYYMMDD
  validité**                                               

  **Date de fin de   **8**       D            N            YYYYMMDD
  validité**                                               
  ------------------ ----------- ------------ ------------ ----------------------------------

### Modification d'un centre de responsabilité

  ------------------ ----------- ------------ ------------ ----------------------------------
  **Rubrique**       **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**           **2**       S            O            ST = Structure

  **Message**        **2**       S            O            CR (Centres de responsabilités)

  **Mode**           **1**       S            O            M (Modification)

  **Emetteur**       **15**      S            O            HEXAGONE

  **Date de          **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                                YYYYMMDDHHMISSnn

  **Individu         **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                             le message.
  message)**                                               

  **Exercice**       **4**       N            O            Exercice comptable

  **Centre de        **4**       N            O            Centre de responsabilité
  responsabilité**                                         

  **Libellé**        **30**      S            O            Libellé

  **Responsable**    **30**      S            N            Nom du responsable

  **Lettre budget**  **1**       S            O            Lettre budget

  **Date de début de **8**       D            O            YYYYMMDD
  validité**                                               

  **Date de fin de   **8**       D            N            YYYYMMDD
  validité**                                               
  ------------------ ----------- ------------ ------------ ----------------------------------

###  Mise hors service d'un centre de responsabilité

  ------------------ ----------- ------------ ------------ ----------------------------------
  **Rubrique**       **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**           **2**       S            O            ST = Structure

  **Message**        **2**       S            O            CR (Centres de responsabilités)

  **Mode**           **1**       S            O            S (Mise hors service)

  **Emetteur**       **15**      S            O            HEXAGONE

  **Date de          **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                                YYYYMMDDHHMISSnn

  **Individu         **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                             le message.
  message)**                                               

  **Exercice**       **4**       N            O            Exercice comptable

  **Centre de        **4**       N            O            Centre de responsabilité
  responsabilité**                                         

  **Date de fin de   **8**       D            O            YYYYMMDD
  validité**                                               
  ------------------ ----------- ------------ ------------ ----------------------------------

-   ## Nomenclature : Civilités

### Création d'une civilité

Ce message est émis à chaque création d'un nouveau code civilité ou un
code pour une nouvelle version.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | CI                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C                               |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code**   | *  | S         | O   | Code civilité                   |
|            | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | O   | Libellé                         |
| *Libellé** | 40 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type de  | *  | S         | O   | M civilité masculine            |
| civilité** | *1 |           |     |                                 |
|            | ** |           |     | F civilité féminine             |
|            |    |           |     |                                 |
|            |    |           |     | A autre type                    |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | O   | T/F                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *4 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Modification d'une civilité

Ce message est émis à chaque modification d'un nouveau code civilité
pour toute version en service.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | CI                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M                               |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code**   | *  | S         | O   | Code civilité                   |
|            | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | O   | Libellé                         |
| *Libellé** | 40 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type de  | *  | S         | O   | M civilité masculine            |
| civilité** | *1 |           |     |                                 |
|            | ** |           |     | F civilité féminine             |
|            |    |           |     |                                 |
|            |    |           |     | A autre type                    |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | O   | T/F                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *4 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

###  Mise hors service d'une civilité

Ce message mise hors service d'un item civilité.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | CI                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S                               |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code**   | *  | S         | O   | Code civilité                   |
|            | *4 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Mise hors service d'une version

Ce message n'est émis que pour une mise hors service d'une version
complète.

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            CI

  **Mode**       **1**       S            O            V

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Version**    **5**       S            O            Version

  **Date de      **16**      D            O            Date de fin de la version au
  fin**                                                format YYYYMMDD
  -------------- ----------- ------------ ------------ ----------------------------------

Remarque

Si la version n'est pas une version encore en production, il est
nécessaire d'envoyer un message de mise hors service pour chaque
civilité de la version en plus du message de mise hors service de la
version.

-   ##  Nomenclature : Situations Familiales

### Création d'une situation familiale

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | SI                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C                               |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code**   | *  | S         | O   | Code situation de famille       |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | O   | Libellé                         |
| *Libellé** | 40 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | O   | T/F                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *1 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Modification d'une situation familiale

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            SI

  **Mode**       **1**       S            O            M

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **1**       S            O            Code situation de famille

  **Version**    **5**       S            O            Version

  **Libellé**    **40**      S            O            Libellé

  **Actif**      **1**       B            O            T/F

  **Valeur       **1**       S            N            Code dans la version précédente
  précédente**                                         
  -------------- ----------- ------------ ------------ ----------------------------------

###  Mise hors service d'une situation familiale

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            SI

  **Mode**       **1**       S            O            S

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **1**       S            O            Code situation de famille

  **Version**    **5**       S            O            Version
  -------------- ----------- ------------ ------------ ----------------------------------

### Mise hors service d'une version

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            SI

  **Mode**       **1**       S            O            V

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Version**    **5**       S            O            Version

  **Date de      **16**      D            O            Date de fin de la version
  fin**                                                
  -------------- ----------- ------------ ------------ ----------------------------------

Remarque

Si la version n'est pas une version encore en production, il est
nécessaire d'envoyer un message de mise hors service pour chaque
civilité de la version en plus du message de mise hors service de la
version.

-   ##  Nomenclature : Nationalité

### Création d'une nationalité

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | NA                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C                               |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code**   | *  | S         | O   | Code nationalité                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | O   | Libellé                         |
| *Libellé** | 40 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | O   | T/F                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *1 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Modification d'une nationalité

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            NA

  **Mode**       **1**       S            O            M

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **1**       S            O            Code nationalité

  **Version**    **5**       S            O            Version

  **Libellé**    **40**      S            O            Libellé

  **Actif**      **1**       B            O            T/F

  **Valeur       **1**       S            N            Code dans la version précédente
  précédente**                                         
  -------------- ----------- ------------ ------------ ----------------------------------

###  Mise hors service d'une nationalité

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            NA

  **Mode**       **1**       S            O            S

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **1**       S            O            Code nationalité

  **Version**    **5**       S            O            Version
  -------------- ----------- ------------ ------------ ----------------------------------

### Mise hors service d'une version

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            NA

  **Mode**       **1**       S            O            V

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Version**    **5**       S            O            Version

  **Date de      **16**      D            O            Date de fin de la version
  fin**                                                
  -------------- ----------- ------------ ------------ ----------------------------------

Remarque

Si la version n'est pas une version encore en production, il est
nécessaire d'envoyer un message de mise hors service pour chaque code
nationalité de la version en plus du message de mise hors service de la
version.

-   ##  Nomenclature : Pays

### Création d'un pays

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | PA                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C                               |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code**   | *  | S         | O   | Code pays                       |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Libellé                         |
| *Libellé** | *1 |           |     |                                 |
|            | 00 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | ** | S         | N   | Code langue par défaut (doit    |
| langue**   | 10 |           |     | appartenir à la table HXLANG)   |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Long     | *  | N         | N   | Longueur IBAN                   |
| IBAN**     | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | O   | T/F                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *1 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Long     | *  | N         | N   | Longueur de code postal         |
| CP**       | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | N   | Code insee du pays              |
| insee**    | *3 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Modification d'un pays

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            PA

  **Mode**       **1**       S            O            M

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **2**       S            O            Code pays

  **Version**    **5**       S            O            Version

  **Libellé**    **100**     S            O            Libellé

  **Code         **10**      S            N            Code langue par défaut (doit
  langue**                                             appartenir à la table HXLANG)

  **Long IBAN**  **2**       N            N            Longueur IBAN

  **Actif**      **1**       B            O            T/F

  **Valeur       **1**       S            N            Code dans la version précédente
  précédente**                                         

  **Long CP**    **2**       N            N            Longueur de code postal

  **Code insee** **3**       S            N            Code insee du pays
  -------------- ----------- ------------ ------------ ----------------------------------

###  Mise hors service d'un pays

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            PA

  **Mode**       **1**       S            O            S

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **2**       S            O            Code pays

  **Version**    **5**       S            O            Version
  -------------- ----------- ------------ ------------ ----------------------------------

### Mise hors service d'une version

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            PA

  **Mode**       **1**       S            O            V

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Version**    **5**       S            O            Version

  **Date de      **16**      D            O            Date de fin de la version
  fin**                                                
  -------------- ----------- ------------ ------------ ----------------------------------

Remarque

Si la version n'est pas une version encore en production, il est
nécessaire d'envoyer un message de mise hors service pour chaque code
pays de la version en plus du message de mise hors service de la
version.

##  Nomenclature : Spécialités Médicales

### Création d'une spécialité médicale

Ce message est émis à chaque création d'un nouveau code spécialité
médicale ou un code pour une nouvelle version.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO = Nomenclature               |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | SP (spécialité médicale)        |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C (Création)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code spécialité médicale        |
| sp         | *2 |           |     |                                 |
| écialité** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | O   | Libellé                         |
| *Libellé** | 40 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé pour les titres         |
| titre**    | 30 |           |     | (éditions)                      |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Anes     | *  | S         | N   | O : Oui                         |
| thésiste** | *1 |           |     |                                 |
|            | ** |           |     | N : Non                         |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | O   | T/F                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *4 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Modification d'une spécialité médicale

Ce message est émis à chaque modification d'un nouveau code spécialité
médicale.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO = Nomenclature               |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | SP (spécialité médicale)        |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M (Modification)                |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code spécialité médicale        |
| sp         | *2 |           |     |                                 |
| écialité** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | ** | S         | O   | Libellé                         |
| *Libellé** | 40 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | N   | Libellé pour les titres         |
| titre**    | 30 |           |     | (éditions)                      |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Anes     | *  | S         | N   | O : Oui                         |
| thésiste** | *1 |           |     |                                 |
|            | ** |           |     | N : Non                         |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | O   | T/F                             |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *4 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

###  Mise hors service d'une spécialité médicale

Ce message est émis à chaque mise hors service d'une code spécialité
médicale.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO = Nomenclature               |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | SP (spécialité médicale)        |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | S (mise hors service)           |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | O   | Code spécialité médicale        |
| sp         | *2 |           |     |                                 |
| écialité** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Mise hors service d'une version de spécialités médicales

Ce message est émis à chaque mise hors service d'une version complète de
spécialités médicales.

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO = Nomenclature

  **Message**    **2**       S            O            SP (spécialité médicale)

  **Mode**       **1**       S            O            V (mise hors service d'une
                                                       version)

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Version**    **5**       S            O            Version

  **Date de      **16**      D            O            Date de fin de la version au
  fin**                                                format YYYYMMDD
  -------------- ----------- ------------ ------------ ----------------------------------

Remarque

Si la version n'est pas une version encore en production, il est
nécessaire d'envoyer un message de mise hors service pour chaque
spécialité médicale de la version en plus du message de mise hors
service de la version.

-   ## Nomenclature : Langues Maternelles

### Création d'une langue maternelle

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            LG

  **Mode**       **1**       S            O            C

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **10**      S            O            Code langue

  **Version**    **5**       S            O            Version

  **Libellé      **20**      S            O            Libellé court
  court**                                              

  **Libellé      **40**      S            O            Libellé long
  long**                                               

  **Actif**      **1**       B            O            T/F

  **Valeur       **10**      S            N            Code dans la version précédente
  précédente**                                         
  -------------- ----------- ------------ ------------ ----------------------------------

### Modification d'une langue maternelle

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            LG

  **Mode**       **1**       S            O            M

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **10**      S            O            Code langue

  **Version**    **5**       S            O            Version

  **Libellé      **20**      S            O            Libellé court
  court**                                              

  **Libellé      **40**      S            O            Libellé long
  long**                                               

  **Actif**      **1**       B            O            T/F

  **Valeur       **10**      S            N            Code dans la version précédente
  précédente**                                         
  -------------- ----------- ------------ ------------ ----------------------------------

###  Mise hors service d'une langue maternelle

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            LG

  **Mode**       **1**       S            O            S

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Code**       **10**      S            O            Code langue

  **Version**    **5**       S            O            Version
  -------------- ----------- ------------ ------------ ----------------------------------

### Mise hors service d'une version de langue maternelle

  -------------- ----------- ------------ ------------ ----------------------------------
  **Rubrique**   **Long.**   **Format**   **Oblig.**   **Commentaires**

  **Type**       **2**       S            O            NO

  **Message**    **2**       S            O            LG

  **Mode**       **1**       S            O            V

  **Emetteur**   **15**      S            O            HEXAGONE

  **Date de      **16**      Date         O            Date de l'envoi au format :
  l'envoi**                                            YYYYMMDDHHMISSnn

  **Individu     **50**      S            O            Individu au sens S3A qui a généré
  (émetteur du                                         le message.
  message)**                                           

  **Version**    **5**       S            O            Version

  **Date de      **16**      D            O            Date de fin de la version
  fin**                                                
  -------------- ----------- ------------ ------------ ----------------------------------

Remarque

Si la version n'est pas une version encore en production, il est
nécessaire d'envoyer un message de mise hors service pour chaque langue
maternelle de la version en plus du message de mise hors service de la
version.

-   ## Nomenclature : Pièces justificatives

### Création d'une pièce justificative

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | PI                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | C                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code pièce                    |
|             | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé** | ** | S         | O   | Libellé                       |
|             | 30 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Justifie  | *  | S         | N   | T/F (True ou False)           |
| l           | *1 |           |     |                               |
| 'identité** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Actif**   | *  | B         | O   | T/F                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Valeur    | *  | S         | N   | Code dans la version          |
| p           | *4 |           |     | précédente                    |
| récédente** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Modification d'une pièce justificative

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | PI                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | M                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code pièce                    |
|             | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé** | ** | S         | O   | Libellé                       |
|             | 30 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Justifie  | *  | S         | N   | T/F (True ou False)           |
| l           | *1 |           |     |                               |
| 'identité** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Actif**   | *  | B         | O   | T/F                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Valeur    | *  | S         | N   | Code dans la version          |
| p           | *4 |           |     | précédente                    |
| récédente** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Mise hors service d'une pièce justificative

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | PI                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | S                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code pièce                    |
|             | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Mise hors service d'une version des pièces justificatives

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | PI                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | V                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | D         | O   | Date de fin de la version au  |
| fin**       | 16 |           |     | format YYYYMMDD               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

-   ## Nomenclature : Catégories Socioprofessionnelles

### Création d'une catégorie socioprofessionnelle

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | CS                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | C                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code catégorie                |
|             | *2 |           |     | socioprofessionnelle          |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé** | ** | S         | O   | Libellé                       |
|             | 95 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Actif**   | *  | B         | O   | T/F                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Valeur    | *  | S         | N   | Code dans la version          |
| p           | *2 |           |     | précédente                    |
| récédente** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Modification d'une catégorie socioprofessionnelle

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | CS                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | M                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code catégorie                |
|             | *2 |           |     | socioprofessionnelle          |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé** | ** | S         | O   | Libellé                       |
|             | 95 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Actif**   | *  | B         | O   | T/F                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Valeur    | *  | S         | N   | Code dans la version          |
| p           | *2 |           |     | précédente                    |
| récédente** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Mise hors service d'une catégorie socioprofessionnelle

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | CS                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | S                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code catégorie                |
|             | *2 |           |     | socioprofessionnelle          |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Mise hors service d'une version des catégories socioprofessionnelles

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | CS                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | V                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | D         | O   | Date de fin de la version     |
| fin**       | 16 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

-   ## *** ***Nomenclature : Situations Professionnelles

### Création d'une situation professionnelle

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | SF                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | C                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code situation                |
|             | *3 |           |     | professionnelle               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé** | ** | S         | O   | Libellé                       |
|             | 90 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Actif**   | *  | B         | O   | T/F                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Valeur    | *  | S         | N   | Code dans la version          |
| p           | *3 |           |     | précédente                    |
| récédente** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Modification d'une situation professionnelle

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | SF                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | M                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code situation                |
|             | *3 |           |     | professionnelle               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Libellé** | ** | S         | O   | Libellé                       |
|             | 90 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Actif**   | *  | B         | O   | T/F                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Valeur    | *  | S         | N   | Code dans la version          |
| p           | *3 |           |     | précédente                    |
| récédente** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

###  Mise hors service d'une situation professionnelle

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | SF                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | S                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code situation                |
|             | *3 |           |     | professionnelle               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Mise hors service d'une version des situations professionnelles

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | SF                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | V                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | D         | O   | Date de fin de la version     |
| fin**       | 16 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

-   ##  Nomenclature : Statuts de parcours

### Création d'un statut de parcours

Ce message est émis à chaque création d'un nouveau code statut de
parcours ou un code pour une nouvelle version.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | ET                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C                               |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code**   | *  | S         | O   | Code statut de parcours         |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Libellé                         |
| *Libellé** | *2 |           |     |                                 |
|            | 00 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | N   | Code à transférer en B2         |
| B2**       | *3 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **In       | *  | S         | N   | Indicateur parcours de soin B2  |
| dicateur** | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Taux**   | *  | S         | N   | Taux hors parcours O/N          |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | N   | Code est Actif                  |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *2 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Origine  | *  | S         | N   | Code origine de prescription    |
| de         | *1 |           |     | (code appartenant à la table    |
| pres       | ** |           |     | HXOPRS)                         |
| cription** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Saisie   | *  | B         | N   | Saisie du médecin obligatoire   |
| médecin**  | *1 |           |     | suivant le code                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### 

###  Modification d'un statut de parcours

Ce message est émis à chaque modification d'un statut de parcours.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | NO                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | ET                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | M                               |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code**   | *  | S         | O   | Code statut de parcours         |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Version                         |
| *Version** | *5 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | Libellé                         |
| *Libellé** | *2 |           |     |                                 |
|            | 00 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | N   | Code à transférer en B2         |
| B2**       | *3 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **In       | *  | S         | N   | Indicateur parcours de soin B2  |
| dicateur** | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Taux**   | *  | S         | N   | Taux hors parcours O/N          |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Actif**  | *  | B         | N   | Code est Actif                  |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Valeur   | *  | S         | N   | Code dans la version précédente |
| pr         | *2 |           |     |                                 |
| écédente** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Origine  | *  | S         | N   | Code origine de prescription    |
| de         | *1 |           |     | (code appartenant à la table    |
| pres       | ** |           |     | HXOPRS)                         |
| cription** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Saisie   | *  | B         | N   | Saisie du médecin obligatoire   |
| médecin**  | *1 |           |     | suivant le code                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Mise hors service d'un statut de parcours

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | ET                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | S                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code**    | *  | S         | O   | Code statut du parcours       |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

###  Mise hors service d'une version des statuts de parcours

Ce message est émis à chaque mise hors service d'une version complète
des statuts de parcours.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | NO                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | ET                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | V                             |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Version** | *  | S         | O   | Version                       |
|             | *5 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | D         | O   | Date de fin de la version     |
| fin**       | 16 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

-   ## Nomenclature : Praticiens

### Création d'un praticien

+----------+----+---------+---------+---------------------------------+
| **Ru     | *  | **F     | **O     | **Commentaires**                |
| brique** | *L | ormat** | blig.** |                                 |
|          | on |         |         |                                 |
|          | g. |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Type** | *  | S       | O       | NO                              |
|          | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **M      | *  | S       | O       | PR                              |
| essage** | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Mode** | *  | S       | O       | C (Création)                    |
|          | *1 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Em     | ** | S       | O       | HEXAGONE                        |
| etteur** | 15 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Date   | ** | Date    | O       | Date de l'envoi au format :     |
| de       | 16 |         |         |                                 |
| l        | ** |         |         | YYYYMMDDHHMISSnn                |
| 'envoi** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **In     | ** | S       | O       | Individu au sens S3A qui a      |
| dividu** | 50 |         |         | généré le message.              |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Code   | *  | S       | O       | Code PRAACC de HRPRA            |
| pra      | *7 |         |         |                                 |
| ticien** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Type   | *  | S       | O       | P = praticien interne           |
| de       | *2 |         |         |                                 |
| pra      | ** |         |         | PX = praticien externe          |
| ticien** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Nom    | ** | S       | O       | Nom du praticien                |
| pra      | 20 |         |         |                                 |
| ticien** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | *  | N       | O       | No FINESS : c'est le n° ADELI   |
| FINESS** | *9 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | ** | N       | N       | Première ligne adresse          |
| *Adresse | 40 |         |         |                                 |
| ligne1** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | ** | N       | N       | Deuxième ligne adresse          |
| *Adresse | 40 |         |         |                                 |
| ligne2** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Code   | *  | N       | N       |                                 |
| postal** | *5 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | ** | N       | N       |                                 |
| *Ville** | 40 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Spéc   | *  | N       | N       | Référencé dans HXSPEC           |
| ialité** | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Anesth | *  | S       | N       | Anesthésiste O/N                |
| ésiste** | *1 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Tel**  | ** | S       | N       | 40 premiers caractères de       |
|          | 40 |         |         | PRATEL , zone téléphonique.     |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | *  | S       | N       | Code tarif édité sur la feuille |
| *Tarif** | *2 |         |         | de soin                         |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Conv   | *  | S       | N       | Code convention édité sur la    |
| ention** | *1 |         |         | feuille de soin.                |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Zone   | *  | S       | N       | Zone ISD édité sur la feuille   |
| ISD**    | *2 |         |         | de soin.                        |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **IK**   | *  | S       | N       | IK édité sur la feuille de soin |
|          | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | *  | S       | N       | Activité libérale O/N           |
| Activité | *1 |         |         |                                 |
| li       | ** |         |         |                                 |
| bérale** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Dep.   | *  | S       | N       | Pratique le dépassement         |
| Hono     | *1 |         |         | d'honoraires                    |
| raires** | ** |         |         |                                 |
|          |    |         |         | (O/N)                           |
+----------+----+---------+---------+---------------------------------+
| **Ide    | ** | S       | N       |                                 |
| ntifiant | 31 |         |         |                                 |
| carte    | ** |         |         |                                 |
| profess  |    |         |         |                                 |
| ionnelle |    |         |         |                                 |
| de       |    |         |         |                                 |
| santé**  |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Liste  | ** | S       | N       | Champ de la forme               |
| des      | \* |         |         | UF\~FINES                       |
| UF-      | ** |         |         | S\^UF\~FINESS\^UF\~FINESS...... |
| Finess** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Liste  | ** | S       | N       | Champ de la forme               |
| des      | \* |         |         |                                 |
| spéci    | ** |         |         | SPE1\^SPE2\^SPE3......          |
| alités** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | ** | S       | N       | e-mail du praticien             |
| E-mail** | 50 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Prod.  | *  | S       | N       | Producteur d'actes O/N          |
| Actes**  | *1 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Nom**  | ** | S       | N       | Nom du praticien                |
|          | 50 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | ** | S       | N       | Prénom du praticien             |
| Prénom** | 50 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Ci     | *  | S       | N       | Civilité du praticien (pointe   |
| vilité** | *4 |         |         | sur HXCIV)                      |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | *  | S       | N       | Titre du praticien (pointe sur  |
| *Titre** | *6 |         |         | HXTIPRA)                        |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **RPPS** | ** | S       | N       | N° RPPS                         |
|          | 11 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Date   | *  | Date    | N       | Date de fin de validité du      |
| de fin   | *8 |         |         | praticien au format AAAAMMJJ    |
| de       | ** |         |         |                                 |
| va       |    |         |         |                                 |
| lidité** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **S      | *  | S       | N       | Secteur du praticien            |
| ecteur** | *3 |         |         |                                 |
|          | ** |         |         | Secteur 1 : 1                   |
|          |    |         |         |                                 |
|          |    |         |         | Secteur 2 : 2                   |
|          |    |         |         |                                 |
|          |    |         |         | Non conventionné: NC            |
|          |    |         |         |                                 |
|          |    |         |         | Secteur 1DP : 1DP               |
+----------+----+---------+---------+---------------------------------+
| **C      | ** | S       | N       | Contrat du praticien            |
| ontrat** | 10 |         |         |                                 |
|          | ** |         |         | Contrat OPTAM                   |
|          |    |         |         |                                 |
|          |    |         |         | Contrat OPTAM-CO                |
+----------+----+---------+---------+---------------------------------+

### Modification d'un praticien

+----------+----+---------+---------+---------------------------------+
| **Ru     | *  | **F     | **O     | **Commentaires**                |
| brique** | *L | ormat** | blig.** |                                 |
|          | on |         |         |                                 |
|          | g. |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Type** | *  | S       | O       | NO                              |
|          | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **M      | *  | S       | O       | PR                              |
| essage** | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Mode** | *  | S       | O       | M (Modification)                |
|          | *1 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Em     | ** | S       | O       | HEXAGONE                        |
| etteur** | 15 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Date   | ** | Date    | O       | Date de l'envoi au format :     |
| de       | 16 |         |         |                                 |
| l        | ** |         |         | YYYYMMDDHHMISSnn                |
| 'envoi** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **In     | ** | S       | O       | Individu au sens S3A qui a      |
| dividu** | 50 |         |         | généré le message.              |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Code   | *  | S       | O       | Code PRAACC de HRPRA            |
| pra      | *7 |         |         |                                 |
| ticien** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Type   | *  | S       | O       | P = praticien interne           |
| de       | *2 |         |         |                                 |
| pra      | ** |         |         | PX = praticien externe          |
| ticien** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Nom    | ** | S       | O       | Nom du praticien                |
| pra      | 20 |         |         |                                 |
| ticien** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | *  | N       | O       | No FINESS : c'est le n° ADELI   |
| FINESS** | *9 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | ** | N       | N       | Première ligne adresse          |
| *Adresse | 40 |         |         |                                 |
| ligne1** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | ** | N       | N       | Deuxième ligne adresse          |
| *Adresse | 40 |         |         |                                 |
| ligne2** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Code   | *  | N       | N       |                                 |
| postal** | *5 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | ** | N       | N       |                                 |
| *Ville** | 40 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Spéc   | *  | N       | N       | Référencé dans HXSPEC           |
| ialité** | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Anesth | *  | S       | N       | Anesthésiste O/N                |
| ésiste** | *1 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Tel**  | ** | S       | N       | 40 premiers caractères de       |
|          | 40 |         |         | PRATEL , zone téléphonique.     |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | *  | S       | N       | Code tarif édité sur la feuille |
| *Tarif** | *2 |         |         | de soin                         |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Conv   | *  | S       | N       | Code convention édité sur la    |
| ention** | *1 |         |         | feuille de soin.                |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Zone   | *  | S       | N       | Zone ISD édité sur la feuille   |
| ISD**    | *2 |         |         | de soin.                        |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **IK**   | *  | S       | N       | IK édité sur la feuille de soin |
|          | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | *  | S       | N       | Activité libérale O/N           |
| Activité | *1 |         |         |                                 |
| li       | ** |         |         |                                 |
| bérale** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Dep.   | *  | S       | N       | Pratique le dépassement         |
| Hono     | *1 |         |         | d'honoraires                    |
| raires** | ** |         |         |                                 |
|          |    |         |         | (O/N)                           |
+----------+----+---------+---------+---------------------------------+
| **Ide    | ** | S       | N       |                                 |
| ntifiant | 31 |         |         |                                 |
| carte    | ** |         |         |                                 |
| profess  |    |         |         |                                 |
| ionnelle |    |         |         |                                 |
| de       |    |         |         |                                 |
| santé**  |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Liste  | ** | S       | N       | Champ de la forme               |
| des      | \* |         |         | UF\~FINES                       |
| UF-      | ** |         |         | S\^UF\~FINESS\^UF\~FINESS...... |
| Finess** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Liste  | ** | S       | N       | Champ de la forme               |
| des      | \* |         |         |                                 |
| spéci    | ** |         |         | SPE1\^SPE2\^SPE3......          |
| alités** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | ** | S       | N       | e-mail du praticien             |
| E-mail** | 50 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Prod.  | *  | S       | N       | Producteur d'actes O/N          |
| Actes**  | *1 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Nom**  | ** | S       | N       | Nom du praticien                |
|          | 50 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | ** | S       | N       | Prénom du praticien             |
| Prénom** | 50 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Ci     | *  | S       | N       | Civilité du praticien (pointe   |
| vilité** | *4 |         |         | sur HXCIV)                      |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | *  | S       | N       | Titre du praticien (pointe sur  |
| *Titre** | *6 |         |         | HXTIPRA)                        |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **RPPS** | ** | S       | N       | N° RPPS                         |
|          | 11 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Date   | *  | Date    | N       | Date de fin de validité du      |
| de fin   | *8 |         |         | praticien au format AAAAMMJJ    |
| de       | ** |         |         |                                 |
| va       |    |         |         |                                 |
| lidité** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **S      | *  | S       | N       | Secteur du praticien            |
| ecteur** | *3 |         |         |                                 |
|          | ** |         |         | Secteur 1 : 1                   |
|          |    |         |         |                                 |
|          |    |         |         | Secteur 2 : 2                   |
|          |    |         |         |                                 |
|          |    |         |         | Non conventionné: NC            |
|          |    |         |         |                                 |
|          |    |         |         | Secteur 1DP : 1DP               |
+----------+----+---------+---------+---------------------------------+
| **C      | ** | S       | N       | Contrat du praticien            |
| ontrat** | 10 |         |         |                                 |
|          | ** |         |         | Contrat OPTAM                   |
|          |    |         |         |                                 |
|          |    |         |         | Contrat OPTAM-CO                |
+----------+----+---------+---------+---------------------------------+

### 

### Suppression d'un praticien

+----------+----+---------+---------+---------------------------------+
| **Ru     | *  | **F     | **O     | **Commentaires**                |
| brique** | *L | ormat** | blig.** |                                 |
|          | on |         |         |                                 |
|          | g. |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Type** | *  | S       | O       | NO                              |
|          | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **M      | *  | S       | O       | PR                              |
| essage** | *2 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Mode** | *  | S       | O       | S (Suppression)                 |
|          | *1 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Em     | ** | S       | O       | HEXAGONE                        |
| etteur** | 15 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Date   | ** | Date    | O       | Date de l'envoi au format :     |
| de       | 16 |         |         |                                 |
| l        | ** |         |         | YYYYMMDDHHMISSnn                |
| 'envoi** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **In     | ** | S       | O       | Individu au sens S3A qui a      |
| dividu** | 50 |         |         | généré le message.              |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Code   | *  | S       | O       | Code PRAACC de HRPRA            |
| pra      | *7 |         |         |                                 |
| ticien** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Type   | *  | S       | O       | P = praticien interne           |
| de       | *2 |         |         |                                 |
| pra      | ** |         |         | PX = praticien externe          |
| ticien** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Nom    | ** | S       | O       | Nom du praticien                |
| pra      | 20 |         |         |                                 |
| ticien** | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | *  | N       | O       | No FINESS : c'est le n° ADELI   |
| FINESS** | *9 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Ide    | ** | S       | N       |                                 |
| ntifiant | 31 |         |         |                                 |
| carte    | ** |         |         |                                 |
| profess  |    |         |         |                                 |
| ionnelle |    |         |         |                                 |
| de       |    |         |         |                                 |
| santé**  |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Date   | ** | Date    | O       | Date de la mise hors service    |
| de mise  | 14 |         |         | auformat :                      |
| hors     | ** |         |         |                                 |
| s        |    |         |         | YYYYMMDDHHMISS                  |
| ervice** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Prod.  | *  | S       | N       | Producteur d'actes O/N          |
| Actes**  | *1 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Nom**  | ** | S       | N       | Nom du praticien                |
|          | 50 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **       | ** | S       | N       | Prénom du praticien             |
| Prénom** | 50 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Ci     | *  | S       | N       | Civilité du praticien (pointe   |
| vilité** | *4 |         |         | sur HXCIV)                      |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| *        | *  | S       | N       | Titre du praticien (pointe sur  |
| *Titre** | *6 |         |         | HXTIPRA)                        |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **RPPS** | ** | S       | N       | N° RPPS                         |
|          | 11 |         |         |                                 |
|          | ** |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **Date   | *  | Date    | N       | Date de fin de validité du      |
| de fin   | *8 |         |         | praticien au format AAAAMMJJ    |
| de       | ** |         |         |                                 |
| va       |    |         |         |                                 |
| lidité** |    |         |         |                                 |
+----------+----+---------+---------+---------------------------------+
| **S      | *  | S       | N       | Secteur du praticien            |
| ecteur** | *3 |         |         |                                 |
|          | ** |         |         | Secteur 1 : 1                   |
|          |    |         |         |                                 |
|          |    |         |         | Secteur 2 : 2                   |
|          |    |         |         |                                 |
|          |    |         |         | Non conventionné: NC            |
|          |    |         |         |                                 |
|          |    |         |         | Secteur 1DP : 1DP               |
+----------+----+---------+---------+---------------------------------+
| **C      | ** | S       | N       | Contrat du praticien            |
| ontrat** | 10 |         |         |                                 |
|          | ** |         |         | Contrat OPTAM                   |
|          |    |         |         |                                 |
|          |    |         |         | Contrat OPTAM-CO                |
+----------+----+---------+---------+---------------------------------+

-   ## Nomenclature : Organismes

### Création d'un organisme

+---------------+----+-------+------+--------------------------------+
| **Rubrique**  | *  | **For | **   | **Commentaires**               |
|               | *L | mat** | Obli |                                |
|               | on |       | g.** |                                |
|               | g. |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Type**      | *  | S     | O    | NO                             |
|               | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Message**   | *  | S     | O    | OR                             |
|               | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Mode**      | *  | S     | O    | C (Création )                  |
|               | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Emetteur**  | ** | S     | O    | HEXAGONE                       |
|               | 15 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Date de     | ** | Date  | O    | Date de l'envoi au format :    |
| l'envoi**     | 16 |       |      |                                |
|               | ** |       |      | YYYYMMDDHHMISSnn               |
+---------------+----+-------+------+--------------------------------+
| **Individu**  | ** | S     | O    | Individu au sens S3A qui a     |
|               | 50 |       |      | généré le message.             |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Type        | *  | S     | O    | A = Sécu                       |
| organisme**   | *1 |       |      |                                |
|               | ** |       |      | C = Complémentaire             |
|               |    |       |      |                                |
|               |    |       |      | D = DAS / DDASS                |
+---------------+----+-------+------+--------------------------------+
| **Code        | ** | S     | O    | Code orgacc de HRORG           |
| organisme**   | 10 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Nom         | ** | S     | O    | Libellé                        |
| organisme**   | 35 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Adresse     | ** | N     | N    | Première ligne adresse         |
| ligne1**      | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Adresse     | ** | N     | N    | Deuxième ligne adresse         |
| ligne2**      | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | N     | N    |                                |
| postal**      | *5 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Ville**     | ** | N     | N    |                                |
|               | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Téléphone** | ** | S     | N    | Zone Télécom non structurée    |
|               | 50 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Grand       | *  | S     | N    | Code grand régime              |
| régime**      | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | S     | N    |                                |
| caisse**      | *3 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | S     | N    |                                |
| centre**      | *3 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Clé**       | *  | S     | N    | Clé de la combinaison grand    |
|               | *1 |       |      | régime+caisse+centre           |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Régime      | *  | S     | N    | Régime Alsace/Moselle (O/N)    |
| Local**       | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **CMU**       | *  | S     | N    | O/N                            |
|               | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | T ou F                         |
| norme NOE**   | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert norme B2 O/N         |
| norme B2**    | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Infos       | *  | S     | N    | Info complémentaires           |
| comp          | *3 |       |      |                                |
| lémentaires** | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert informations de      |
| IS**          | *1 |       |      | séjour                         |
|               | ** |       |      |                                |
|               |    |       |      | (O/N)                          |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert B615                 |
| B615**        | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert sécu pour les        |
| CX**          | *1 |       |      | consultations externes         |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Compte de   | *  | N     | N    | Compte de tiers associé        |
| tiers**       | *7 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Accord      | *  | S     | N    | Accord tacite après délai      |
| tacite**      | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Délai nbre  | *  | N     | N    | Nombre de jours avant la       |
| jours**       | *3 |       |      | génération de l'accord tacite  |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | ** | S     | N    | Code organisme destinataire    |
| d             | 10 |       |      | des émissions                  |
| estinataire** | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | *  | S     | N    | Indique s'il s'agit d'un       |
| mutualiste**  | *1 |       |      | organisme mutualiste ou non    |
|               | ** |       |      | (O/N)                          |
+---------------+----+-------+------+--------------------------------+
| **Org div**   | *  | S     | N    | D=Divers (ROD)/ \'\' = régime  |
|               | *1 |       |      | obligatoire standard           |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Date de fin | ** | Date  | N    | Date de fin de validité de     |
| de validité** | 16 |       |      | l'organisme au format YYYMMDD  |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | ** | S     | N    | Nouveau code organisme         |
| remplaçant**  | 10 |       |      | (Héxagone) qui remplace celui  |
|               | ** |       |      | qui n'est plus valide.         |
+---------------+----+-------+------+--------------------------------+

###  Modification d'un organisme

+---------------+----+-------+------+--------------------------------+
| **Rubrique**  | *  | **For | **   | **Commentaires**               |
|               | *L | mat** | Obli |                                |
|               | on |       | g.** |                                |
|               | g. |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Type**      | *  | S     | O    | NO                             |
|               | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Message**   | *  | S     | O    | OR                             |
|               | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Mode**      | *  | S     | O    | M ( Modification )             |
|               | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Emetteur**  | ** | S     | O    | HEXAGONE                       |
|               | 15 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Date de     | ** | Date  | O    | Date de l'envoi au format :    |
| l'envoi**     | 16 |       |      |                                |
|               | ** |       |      | YYYYMMDDHHMISSnn               |
+---------------+----+-------+------+--------------------------------+
| **Individu**  | ** | S     | O    | Individu au sens S3A qui a     |
|               | 50 |       |      | généré le message.             |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Type        | *  | S     | O    | A = Sécu                       |
| organisme**   | *1 |       |      |                                |
|               | ** |       |      | C = Complémentaire             |
|               |    |       |      |                                |
|               |    |       |      | D = DAS / DDASS                |
+---------------+----+-------+------+--------------------------------+
| **Code        | ** | S     | O    | Code orgacc de HRORG           |
| organisme**   | 10 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Nom         | ** | S     | O    | Libellé                        |
| organisme**   | 35 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Adresse     | ** | N     | N    | Première ligne adresse         |
| ligne1**      | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Adresse     | ** | N     | N    | Deuxième ligne adresse         |
| ligne2**      | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | N     | N    |                                |
| postal**      | *5 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Ville**     | ** | N     | N    |                                |
|               | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Téléphone** | ** | S     | N    | Zone Télécom non structurée    |
|               | 50 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Grand       | *  | S     | N    | Code grand régime              |
| régime**      | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | S     | N    |                                |
| caisse**      | *3 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | S     | N    |                                |
| centre**      | *3 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Clé**       | *  | S     | N    | Clé de la combinaison grand    |
|               | *1 |       |      | régime+caisse+centre           |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Régime      | *  | S     | N    | Régime Alsace/Moselle (O/N)    |
| Local**       | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **CMU**       | *  | S     | N    | O/N                            |
|               | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | T ou F                         |
| norme NOE**   | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert norme B2 O/N         |
| norme B2**    | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Infos       | *  | S     | N    | Infos complémentaires          |
| comp          | *3 |       |      |                                |
| lémentaires** | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert informations de      |
| IS**          | *1 |       |      | séjour                         |
|               | ** |       |      |                                |
|               |    |       |      | (O/N)                          |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert B615                 |
| B615**        | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert sécu pour les        |
| CX**          | *1 |       |      | consultations externes         |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Compte de   | *  | N     | N    | Compte de tiers associé        |
| tiers**       | *7 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Accord      | *  | S     | N    | Accord tacite après délai      |
| tacite**      | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Délai nbre  | *  | N     | N    | Nombre de jours avant la       |
| jours**       | *3 |       |      | génération de l'accord tacite  |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | ** | S     | N    | Code organisme destinataire    |
| d             | 10 |       |      | des émissions                  |
| estinataire** | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | *  | S     | N    | Indique s'il s'agit d'un       |
| mutualiste**  | *1 |       |      | organisme mutualiste ou non    |
|               | ** |       |      | (O/N)                          |
+---------------+----+-------+------+--------------------------------+
| **Org div**   | *  | S     | N    | D=Divers (ROD)/ \'\' = régime  |
|               | *1 |       |      | obligatoire standard           |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Date de fin | ** | Date  | N    | Date de fin de validité de     |
| de validité** | 16 |       |      | l'organisme au format YYYMMDD  |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | ** | S     | N    | Nouveau code organisme         |
| remplaçant**  | 10 |       |      | (Héxagone) qui remplace celui  |
|               | ** |       |      | qui n'est plus valide.         |
+---------------+----+-------+------+--------------------------------+

###  Suppression d'un organisme

+---------------+----+-------+------+--------------------------------+
| **Rubrique**  | *  | **For | **   | **Commentaires**               |
|               | *L | mat** | Obli |                                |
|               | on |       | g.** |                                |
|               | g. |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Type**      | *  | S     | O    | NO                             |
|               | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Message**   | *  | S     | O    | OR                             |
|               | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Mode**      | *  | S     | O    | S (Suppression )               |
|               | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Emetteur**  | ** | S     | O    | HEXAGONE                       |
|               | 15 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Date de     | ** | Date  | O    | Date de l'envoi au format :    |
| l'envoi**     | 16 |       |      |                                |
|               | ** |       |      | YYYYMMDDHHMISSnn               |
+---------------+----+-------+------+--------------------------------+
| **Individu**  | ** | S     | O    | Individu au sens S3A qui a     |
|               | 50 |       |      | généré le message.             |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Type        | *  | S     | O    | A = Sécu                       |
| organisme**   | *1 |       |      |                                |
|               | ** |       |      | C = Complémentaire             |
|               |    |       |      |                                |
|               |    |       |      | D = DAS / DDASS                |
+---------------+----+-------+------+--------------------------------+
| **Code        | ** | S     | O    | Code orgacc de HRORG           |
| organisme**   | 10 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Nom         | ** | S     | O    | Libellé                        |
| organisme**   | 35 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Adresse     | ** | N     | N    | Première ligne adresse         |
| ligne1**      | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Adresse     | ** | N     | N    | Deuxième ligne adresse         |
| ligne2**      | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | N     | N    |                                |
| postal**      | *5 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Ville**     | ** | N     | N    |                                |
|               | 40 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Téléphone** | ** | S     | N    | Zone Télécom non structurée    |
|               | 50 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Grand       | *  | S     | N    | Code grand régime              |
| régime**      | *2 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | S     | N    |                                |
| caisse**      | *3 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Code        | *  | S     | N    |                                |
| centre**      | *3 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Clé**       | *  | S     | N    | Clé de la combinaison grand    |
|               | *1 |       |      | régime+caisse+centre           |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Régime      | *  | S     | N    | Régime Alsace/Moselle (O/N)    |
| Local**       | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **CMU**       | *  | S     | N    | O/N                            |
|               | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | T ou F                         |
| norme NOE**   | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert norme B2 O/N         |
| norme B2**    | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Infos       | *  | S     | N    | Infos complémentaires          |
| comp          | *3 |       |      |                                |
| lémentaires** | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert informations de      |
| IS**          | *1 |       |      | séjour                         |
|               | ** |       |      |                                |
|               |    |       |      | (O/N)                          |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert B615                 |
| B615**        | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Transfert   | *  | S     | N    | Transfert sécu pour les        |
| CX**          | *1 |       |      | consultations externes         |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Compte de   | *  | N     | N    | Compte de tiers associé        |
| tiers**       | *7 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Accord      | *  | S     | N    | Accord tacite après délai      |
| tacite**      | *1 |       |      |                                |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Délai nbre  | *  | N     | N    | Nombre de jours avant la       |
| jours**       | *3 |       |      | génération de l'accord tacite  |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | ** | S     | N    | Code organisme destinataire    |
| d             | 10 |       |      | des émissions                  |
| estinataire** | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | *  | S     | N    | Indique s'il s'agit d'un       |
| mutualiste**  | *1 |       |      | organisme mutualiste ou non    |
|               | ** |       |      | (O/N)                          |
+---------------+----+-------+------+--------------------------------+
| **Org div**   | *  | S     | N    | D=Divers (ROD)/ \'\' = régime  |
|               | *1 |       |      | obligatoire standard           |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Date de fin | ** | Date  | N    | Date de fin de validité de     |
| de validité** | 16 |       |      | l'organisme au format YYYMMDD  |
|               | ** |       |      |                                |
+---------------+----+-------+------+--------------------------------+
| **Organisme   | ** | S     | N    | Nouveau code organisme         |
| remplaçant**  | 10 |       |      | (Héxagone) qui remplace celui  |
|               | ** |       |      | qui n'est plus valide.         |
+---------------+----+-------+------+--------------------------------+

-   ## Nomenclature : Gestion des contrats

Chaque contrat (message NO/CT) peut contenir une ou plusieurs lignes de
prestations (message NO/CP). Le contrat auquel appartient la prestations
est défini par la codification de ce contrat (Type d'organisme, Code
organisme).

### Création d'un contrat

-   Table des contrats :

+------------+--------+----------+---------+-------------------------+
| > **       | > **L  | > **     | > **O   | > **Commentaires**      |
| Rubrique** | ong.** | Format** | blig.** |                         |
+------------+--------+----------+---------+-------------------------+
| > **Type** | >      | > S      | > O     | > NO                    |
|            |  **2** |          |         |                         |
+------------+--------+----------+---------+-------------------------+
| > *        | >      | > S      | > O     | > CT                    |
| *Message** |  **2** |          |         |                         |
+------------+--------+----------+---------+-------------------------+
| > **Mode** | >      | > S      | > O     | > C (Création )         |
|            |  **1** |          |         |                         |
+------------+--------+----------+---------+-------------------------+
| > **       | >      | > S      | > O     | > HEXAGONE              |
| Emetteur** | **15** |          |         |                         |
+------------+--------+----------+---------+-------------------------+
| > **Date   | >      | > Date   | > O     | > Date de l'envoi au    |
| > de       | **16** |          |         | > format :              |
| >          |        |          |         | >                       |
|  l'envoi** |        |          |         | > YYYYMMDDHHMISSnn      |
+------------+--------+----------+---------+-------------------------+
| > **       | >      | > S      | > O     | > Individu au sens S3A  |
| Individu** | **50** |          |         | > qui a généré le       |
|            |        |          |         | > message.              |
+------------+--------+----------+---------+-------------------------+
| > **Type   | >      | > S      | > O     | > A = Sécu              |
| > o        |  **1** |          |         | >                       |
| rganisme** |        |          |         | > C = Complémentaire    |
|            |        |          |         | >                       |
|            |        |          |         | > D = DAS / DDASS       |
+------------+--------+----------+---------+-------------------------+
| > **Code   | >      | > S      | > O     | > Code orgacc de HRORG  |
| > o        | **10** |          |         |                         |
| rganisme** |        |          |         |                         |
+------------+--------+----------+---------+-------------------------+
| > **Nom du | >      | > S      | > O     | > Nom du contrat        |
| >          | **35** |          |         |                         |
|  contrat** |        |          |         |                         |
+------------+--------+----------+---------+-------------------------+
| > **Code   | >      | > S      | > O     | > Code contrat          |
| >          | **10** |          |         |                         |
|  contrat** |        |          |         |                         |
+------------+--------+----------+---------+-------------------------+
| > **Début  | >      | > D      | > O     | > Date de début de      |
| >          | **10** |          |         | > validité (YYYYMMDD)   |
| validité** |        |          |         |                         |
+------------+--------+----------+---------+-------------------------+
| > **Fin    | >      | > D      | > O     | > Date de fin de        |
| >          | **10** |          |         | > validité              |
| validité** |        |          |         |                         |
+------------+--------+----------+---------+-------------------------+

-   Détail des prestations prises en charge par le contrat :

+-------------+--------+----------+---------+-------------------------+
| > *         | > **L  | > **     | > **O   | > **Commentaires**      |
| *Rubrique** | ong.** | Format** | blig.** |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Type**  | >      | > S      | > O     | > NO                    |
|             |  **2** |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| >           | >      | > S      | > O     | > CP                    |
| **Message** |  **2** |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Mode**  | >      | > S      | > O     | > C (Création)          |
|             |  **1** |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > *         | >      | > S      | > O     | > HEXAGONE              |
| *Emetteur** | **15** |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Date de | >      | > Date   | > O     | > Date de l'envoi au    |
| > l'envoi** | **16** |          |         | > format :              |
|             |        |          |         | >                       |
|             |        |          |         | > YYYYMMDDHHMISSnn      |
+-------------+--------+----------+---------+-------------------------+
| > *         | >      | > S      | > O     | > Individu au sens S3A  |
| *Individu** | **50** |          |         | > qui a généré le       |
|             |        |          |         | > message.              |
+-------------+--------+----------+---------+-------------------------+
| > **Type    | >      | > S      | > O     | > A = Sécu              |
| >           |  **1** |          |         | >                       |
| organisme** |        |          |         | > C = Complémentaire    |
|             |        |          |         | >                       |
|             |        |          |         | > D = DAS / DDASS       |
+-------------+--------+----------+---------+-------------------------+
| > **Code    | >      | > S      | > O     | > Code orgacc de HRORG  |
| >           | **10** |          |         |                         |
| organisme** |        |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Nom du  | >      | > S      | > O     | > Nom du contrat        |
| > contrat** | **35** |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Code    | >      | > S      | > O     | > Code contrat          |
| > contrat** | **10** |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Type de | >      | > S      | > O     | > P=prestation K=acte   |
| > pec**     |  **1** |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Code    | >      | > S      | > N     | > Code prestation ou    |
| > p         | **10** |          |         | > code acte référencés  |
| restation** |        |          |         | > respectivement dans   |
|             |        |          |         | > les tables HRPRS et   |
|             |        |          |         | > HRACT                 |
+-------------+--------+----------+---------+-------------------------+
| > **C       | >      | > S      | > O     | > Consultant externe    |
| onsultant** |  **1** |          |         | > O/N                   |
+-------------+--------+----------+---------+-------------------------+
| > **Demande | >      | > S      | > O     | > D/A Demande à faire   |
| > ou        |  **1** |          |         | > ou accord avec la     |
| > accord**  |        |          |         | > complémentaire        |
+-------------+--------+----------+---------+-------------------------+
| > **Prise   | >      | > S      | > O     | > **T+%** T +           |
| > en        |  **4** |          |         | > pourcentage           |
| > charge**  |        |          |         | >                       |
|             |        |          |         | > **TM** Ticket         |
|             |        |          |         | > modérateur            |
|             |        |          |         | >                       |
|             |        |          |         | > **OUI** Le code       |
|             |        |          |         | > prestation est p.e.c. |
|             |        |          |         | >                       |
|             |        |          |         | > **NON** le code       |
|             |        |          |         | > prest. N'est pas PEC  |
|             |        |          |         | >                       |
|             |        |          |         | > **REST** Par rapport  |
|             |        |          |         | > à ce que prend la     |
|             |        |          |         | > sécu                  |
|             |        |          |         | >                       |
|             |        |          |         | > **FORF**              |
|             |        |          |         | > Complémentaire prend  |
|             |        |          |         | > en charge un forfait  |
|             |        |          |         | >                       |
|             |        |          |         | > **APL**               |
|             |        |          |         | >                       |
|             |        |          |         | > **PART** Une          |
|             |        |          |         | > participation         |
|             |        |          |         | >                       |
|             |        |          |         | > **PARTJ** Une         |
|             |        |          |         | > participation         |
|             |        |          |         | > journalière           |
+-------------+--------+----------+---------+-------------------------+
| > **Nombre  | >      | > N      | > N     | > **Nbr de jours avant  |
| > de jours  |  **3** |          |         | > PEC**                 |
| > de        |        |          |         |                         |
| > carence** |        |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Durés   | >      | > N      | > N     | > **Nbre de jours de    |
| > de la     |  **3** |          |         | > PEC**                 |
| > PEC**     |        |          |         |                         |
+-------------+--------+----------+---------+-------------------------+
| > **Tarif   | > **   | > N      | > N     | > **Montant max         |
| > limité**  | 10,2** |          |         | > remboursé**           |
+-------------+--------+----------+---------+-------------------------+

### Modification d'un contrat

-   Table des contrats :

+---------------+-----+-------+------+-------------------------------+
| **Rubrique**  | **L | **For | **   | **Commentaires**              |
|               | ong | mat** | Obli |                               |
|               | .** |       | g.** |                               |
+---------------+-----+-------+------+-------------------------------+
| **Type**      | **  | S     | O    | NO                            |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Message**   | **  | S     | O    | CT                            |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Mode**      | **  | S     | O    | M ( Modification )            |
|               | 1** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Emetteur**  | **1 | S     | O    | HEXAGONE                      |
|               | 5** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Date de     | **1 | Date  | O    | Date de l'envoi au format :   |
| l'envoi**     | 6** |       |      |                               |
|               |     |       |      | YYYYMMDDHHMISSnn              |
+---------------+-----+-------+------+-------------------------------+
| **Individu**  | **5 | S     | O    | Individu au sens S3A qui a    |
|               | 0** |       |      | généré le message.            |
+---------------+-----+-------+------+-------------------------------+
| **Type        | **  | S     | O    | A = Sécu                      |
| organisme**   | 1** |       |      |                               |
|               |     |       |      | C = Complémentaire            |
|               |     |       |      |                               |
|               |     |       |      | D = DAS / DDASS               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | O    | Code orgacc de HRORG          |
| organisme**   | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Nom du      | **3 | S     | O    | Nom du contrat                |
| contrat**     | 5** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | O    | Code contrat                  |
| contrat**     | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Début       | **1 | D     | O    | Date de début de validité     |
| validité**    | 0** |       |      | (YYYYMMDD)                    |
+---------------+-----+-------+------+-------------------------------+
| **Fin         | **1 | D     | O    | Date de fin de validité       |
| validité**    | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+

-   Détail des prestations prises en charge par le contrat :

+---------------+-----+-------+------+-------------------------------+
| **Rubrique**  | **L | **For | **   | **Commentaires**              |
|               | ong | mat** | Obli |                               |
|               | .** |       | g.** |                               |
+---------------+-----+-------+------+-------------------------------+
| **Type**      | **  | S     | O    | NO                            |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Message**   | **  | S     | O    | CP                            |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Mode**      | **  | S     | O    | M ( Modification )            |
|               | 1** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Emetteur**  | **1 | S     | O    | HEXAGONE                      |
|               | 5** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Date de     | **1 | Date  | O    | Date de l'envoi au format :   |
| l'envoi**     | 6** |       |      |                               |
|               |     |       |      | YYYYMMDDHHMISSnn              |
+---------------+-----+-------+------+-------------------------------+
| **Individu**  | **5 | S     | O    | Individu au sens S3A qui a    |
|               | 0** |       |      | généré le message.            |
+---------------+-----+-------+------+-------------------------------+
| **Type        | **  | S     | O    | A = Sécu                      |
| organisme**   | 1** |       |      |                               |
|               |     |       |      | C = Complémentaire            |
|               |     |       |      |                               |
|               |     |       |      | D = DAS / DDASS               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | O    | Code orgacc de HRORG          |
| organisme**   | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Nom du      | **3 | S     | O    | Nom du contrat                |
| contrat**     | 5** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | O    | Code contrat                  |
| contrat**     | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Type de     | **  | S     | O    | P=prestation K=acte           |
| pec**         | 1** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | N    | Code prestation ou code acte  |
| prestation**  | 0** |       |      | référencés respectivement     |
|               |     |       |      | dans les tables HRPRS et      |
|               |     |       |      | HRACT                         |
+---------------+-----+-------+------+-------------------------------+
| *             | **  | S     | O    | Consultant externe O/N        |
| *Consultant** | 1** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Demande ou  | **  | S     | O    | D/A Demande à faire ou accord |
| accord**      | 1** |       |      | avec la complémentaire        |
+---------------+-----+-------+------+-------------------------------+
| **Prise en    | **  | S     | O    | **T+%** T + pourcentage       |
| charge**      | 4** |       |      |                               |
|               |     |       |      | **TM** Ticket modérateur      |
|               |     |       |      |                               |
|               |     |       |      | **OUI** Le code prestation    |
|               |     |       |      | est p.e.c.                    |
|               |     |       |      |                               |
|               |     |       |      | **NON** le code prest. N'est  |
|               |     |       |      | pas PEC                       |
|               |     |       |      |                               |
|               |     |       |      | **REST** Par rapport à ce que |
|               |     |       |      | prend la sécu                 |
|               |     |       |      |                               |
|               |     |       |      | **FORF** Complémentaire prend |
|               |     |       |      | en charge un forfait          |
|               |     |       |      |                               |
|               |     |       |      | **APL**                       |
|               |     |       |      |                               |
|               |     |       |      | **PART** Une participation    |
|               |     |       |      |                               |
|               |     |       |      | **PARTJ** Une participation   |
|               |     |       |      | journalière                   |
+---------------+-----+-------+------+-------------------------------+
| **Nombre de   | **  | N     | N    | **Nbr de jours avant PEC**    |
| jours de      | 3** |       |      |                               |
| carence**     |     |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Durés de la | **  | N     | N    | **Nbre de jours de PEC**      |
| PEC**         | 3** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Tarif       | **  | N     | N    | **Montant max remboursé**     |
| limité**      | 10, |       |      |                               |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+

### Suppression d'un contrat

-   Table des contrats :

+---------------+-----+-------+------+-------------------------------+
| **Rubrique**  | **L | **For | **   | **Commentaires**              |
|               | ong | mat** | Obli |                               |
|               | .** |       | g.** |                               |
+---------------+-----+-------+------+-------------------------------+
| **Type**      | **  | S     | O    | NO                            |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Message**   | **  | S     | O    | CT                            |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Mode**      | **  | S     | O    | S (Suppression )              |
|               | 1** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Emetteur**  | **1 | S     | O    | HEXAGONE                      |
|               | 5** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Date de     | **1 | Date  | O    | Date de l'envoi au format :   |
| l'envoi**     | 6** |       |      |                               |
|               |     |       |      | YYYYMMDDHHMISSnn              |
+---------------+-----+-------+------+-------------------------------+
| **Individu**  | **5 | S     | O    | Individu au sens S3A qui a    |
|               | 0** |       |      | généré le message.            |
+---------------+-----+-------+------+-------------------------------+
| **Type        | **  | S     | O    | A = Sécu                      |
| organisme**   | 1** |       |      |                               |
|               |     |       |      | C = Complémentaire            |
|               |     |       |      |                               |
|               |     |       |      | D = DAS / DDASS               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | O    | Code orgacc de HRORG          |
| organisme**   | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Nom du      | **3 | S     | O    | Nom du contrat                |
| contrat**     | 5** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | O    | Code contrat                  |
| contrat**     | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Début       | **1 | D     | O    | Date de début de validité     |
| validité**    | 0** |       |      | (YYYYMMDD)                    |
+---------------+-----+-------+------+-------------------------------+
| **Fin         | **1 | D     | O    | Date de fin de validité       |
| validité**    | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+

-   Détail des prestations prises en charge par le contrat :

+---------------+-----+-------+------+-------------------------------+
| **Rubrique**  | **L | **For | **   | **Commentaires**              |
|               | ong | mat** | Obli |                               |
|               | .** |       | g.** |                               |
+---------------+-----+-------+------+-------------------------------+
| **Type**      | **  | S     | O    | NO                            |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Message**   | **  | S     | O    | CP                            |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Mode**      | **  | S     | O    | S (Suppression )              |
|               | 1** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Emetteur**  | **1 | S     | O    | HEXAGONE                      |
|               | 5** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Date de     | **1 | Date  | O    | Date de l'envoi au format :   |
| l'envoi**     | 6** |       |      |                               |
|               |     |       |      | YYYYMMDDHHMISSnn              |
+---------------+-----+-------+------+-------------------------------+
| **Individu**  | **5 | S     | O    | Individu au sens S3A qui a    |
|               | 0** |       |      | généré le message.            |
+---------------+-----+-------+------+-------------------------------+
| **Type        | **  | S     | O    | A = Sécu                      |
| organisme**   | 1** |       |      |                               |
|               |     |       |      | C = Complémentaire            |
|               |     |       |      |                               |
|               |     |       |      | D = DAS / DDASS               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | O    | Code orgacc de HRORG          |
| organisme**   | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Nom du      | **3 | S     | O    | Nom du contrat                |
| contrat**     | 5** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | O    | Code contrat                  |
| contrat**     | 0** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Type de     | **  | S     | O    | P=prestation K=acte           |
| pec**         | 1** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Code        | **1 | S     | N    | Code prestation ou code acte  |
| prestation**  | 0** |       |      | référencés respectivement     |
|               |     |       |      | dans les tables HRPRS et      |
|               |     |       |      | HRACT                         |
+---------------+-----+-------+------+-------------------------------+
| *             | **  | S     | O    | Consultant externe O/N        |
| *Consultant** | 1** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Demande ou  | **  | S     | O    | D/A Demande à faire ou accord |
| accord**      | 1** |       |      | avec la complémentaire        |
+---------------+-----+-------+------+-------------------------------+
| **Prise en    | **  | S     | O    | **T+%** T + pourcentage       |
| charge**      | 4** |       |      |                               |
|               |     |       |      | **TM** Ticket modérateur      |
|               |     |       |      |                               |
|               |     |       |      | **OUI** Le code prestation    |
|               |     |       |      | est p.e.c.                    |
|               |     |       |      |                               |
|               |     |       |      | **NON** le code prest. N'est  |
|               |     |       |      | pas PEC                       |
|               |     |       |      |                               |
|               |     |       |      | **REST** Par rapport à ce que |
|               |     |       |      | prend la sécu                 |
|               |     |       |      |                               |
|               |     |       |      | **FORF** Complémentaire prend |
|               |     |       |      | en charge un forfait          |
|               |     |       |      |                               |
|               |     |       |      | **APL**                       |
|               |     |       |      |                               |
|               |     |       |      | **PART** Une participation    |
|               |     |       |      |                               |
|               |     |       |      | **PARTJ** Une participation   |
|               |     |       |      | journalière                   |
+---------------+-----+-------+------+-------------------------------+
| **Nombre de   | **  | N     | N    | **Nbr de jours avant PEC**    |
| jours de      | 3** |       |      |                               |
| carence**     |     |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Durés de la | **  | N     | N    | **Nbre de jours de PEC**      |
| PEC**         | 3** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+
| **Tarif       | **  | N     | N    | **Montant max remboursé**     |
| limité**      | 10, |       |      |                               |
|               | 2** |       |      |                               |
+---------------+-----+-------+------+-------------------------------+

-   ## Nomenclature : Produits

### Création d'un Produit :

Uniquement prévu en envoi d'Hexagone vers un autre logiciel.

#### Message 0 : Données générales du produit.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits                         |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M0                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Produit(Unique)    |
| Produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Libellé  | ** | S    | O   | Libellé produit (Unique)              |
| Court      | 40 |      |     |                                       |
| produit**  | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | S    | O   | Date de création du produit :         |
| début**    | *8 |      |     |                                       |
|            | ** |      |     | YYYYMMDD                              |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | S    | N   | Date de fin d'utilisation du produit  |
| fin**      | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Oui si géré par la pharmacie, N sinon |
| p          | *1 |      |     |                                       |
| harmacie** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | N   | Code CIP associé au produit           |
| CIP**      | *7 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | N   | Rattachement à la codification ATC    |
| ATC**      | *7 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | N   | Code Unité commune dispensation       |
| UCD**      | *7 |      |     | Obligatoire si type Médicament        |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Plus utilisé depuis la version D.02   |
| Mé         | *1 |      |     |                                       |
| dicament** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Niveau   | *  | N    | N   | Obligatoire si Code ATC renseigné.    |
| ATC de     | *1 |      |     | Niveau d'arborescence :               |
| ratt       | ** |      |     |                                       |
| achement** |    |      |     | 2 si Usage thérapeutique              |
|            |    |      |     |                                       |
|            |    |      |     | 3 si sous groupe thérapeutique        |
|            |    |      |     |                                       |
|            |    |      |     | 4 si sous groupe chimique             |
|            |    |      |     |                                       |
|            |    |      |     | 5 si substance chimique               |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Plus utilisé depuis la version D.02   |
| Matériel** | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type     | *  | S    | N   | Type de produit : MED = Médicament    |
| produit**  | *3 |      |     |                                       |
|            | ** |      |     | MAT = Matériel Médical                |
|            |    |      |     |                                       |
|            |    |      |     | DM = Dispositif Médical               |
|            |    |      |     |                                       |
|            |    |      |     | FIL = Film Radiologie                 |
|            |    |      |     |                                       |
|            |    |      |     | PCO = Produits de contraste           |
|            |    |      |     |                                       |
|            |    |      |     | Champ vide pour autres produits.      |
+------------+----+------+-----+---------------------------------------+
| **Libellé  | *  | S    | O   | Libellé long du produit.              |
| Long**     | *1 |      |     |                                       |
|            | 50 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 1 : Informations produit pharmacie

Emis si « Code pharmacie » est à O

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Produit(Unique)    |
| Produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code liste valeurs possibles : 1, 2,  |
| Tableau**  | *4 |      |     | STUP ou champ Vide                    |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Plus utilisé à partir de la version   |
| forme**    | *8 |      |     | D.03                                  |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | N   | Classification interne de             |
| *Catégorie | *4 |      |     | l'établissement pour états de         |
| théra      | ** |      |     | consommations                         |
| peutique** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code Réservé à l'usage hospitalier,   |
| RUH**      | *1 |      |     | valeurs T pour Vrai, F pour Faux      |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Condi    | *  | S    | O   | Valeurs T pour Vrai, F pour Faux      |
| tionnement | *1 |      |     |                                       |
| Unitaire** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Agréé    | *  | S    | O   | Valeurs T pour Vrai, F pour Faux      |
| Coll       | *1 |      |     |                                       |
| ectivité** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Usage    | *  | S    | O   | Matériel à usage unique :             |
| Unique**   | *1 |      |     |                                       |
|            | ** |      |     | Valeurs T pour Vrai, F pour Faux      |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code condition de conservation        |
| condition  | *1 |      |     |                                       |
| S          | ** |      |     |                                       |
| térilité** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | Plus utilisé à partir de la version   |
| *Remboursé | *1 |      |     | D.03                                  |
| SS**       | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Taux     | *  | N    | N   | Obligatoire si Produit Rétrocédé est  |
| allo       | *7 |      |     | égal à T. Valeurs autorisées : 35%,   |
| pathique** | ** |      |     | 65% et 100%                           |
+------------+----+------+-----+---------------------------------------+
| **Att      | *  | S    | O   | Plus utilisé à partir de la version   |
| estation** | *1 |      |     | D.03                                  |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Valeurs T pour Vrai, F pour Faux      |
| Frac       | *1 |      |     |                                       |
| tionable** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Taux de  | *  | N    | N   | Obligatoire si produit rétrocédé.     |
| Ma         | *1 |      |     | Valeurs :                             |
| joration** | ** |      |     |                                       |
|            |    |      |     | 2 si 35%, 4 si 65% et 5 si 100%       |
+------------+----+------+-----+---------------------------------------+
| **Prix     | ** | N    | N   | Obligatoire si produit rétrocédé. Le  |
| Rétr       | 14 |      |     | prix est TTC                          |
| ocession** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code édition sur le livret            |
| édition    | *1 |      |     | thérapeutique ou non.                 |
| Livret**   | ** |      |     |                                       |
|            |    |      |     | Valeurs T pour Vrai, F pour Faux      |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Produit pouvant être utilisé comme    |
| Véhicule** | *1 |      |     | véhicule pour les perfusions. T pour  |
|            | ** |      |     | vrai, F pour Faux                     |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Produit pouvant être dilué. T pour    |
| diluable** | *1 |      |     | Vrai, F pour Faux                     |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Produit ne pouvant être dispensé à    |
| Mono       | *1 |      |     | plusieurs patients . T pour Vrai, F   |
| malade**   | ** |      |     | pour Faux                             |
+------------+----+------+-----+---------------------------------------+
| **Produit  | *  | S    | O   | Produit pouvant être utiliser dans    |
| de         | *1 |      |     | les perfusions : T pour Vrai, F pour  |
| dilution** | ** |      |     | Faux                                  |
+------------+----+------+-----+---------------------------------------+
| **MDS**    | *  | S    | O   | Médicament dérivé du sang. Ne peut    |
|            | *1 |      |     | être à T que si médicament = T.       |
|            | ** |      |     | Valeurs T pour Vrai, F pour Faux      |
+------------+----+------+-----+---------------------------------------+
| **DMI**    | *  | S    | O   | Dispositif médical Implantable. T     |
|            | *1 |      |     | pour Vrai, F pour Faux                |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Produit pouvant être rétrocédé ; T    |
| R          | *1 |      |     | pour Vrai, F pour Faux                |
| étrocédé** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Gestion  | *  | S    | O   | Gestion des lots et dates de          |
| des lots** | *1 |      |     | péremption dans ELITE.S.              |
|            | ** |      |     |                                       |
|            |    |      |     | T pour Vrai, F pour Faux              |
+------------+----+------+-----+---------------------------------------+
| **Durée    | *  | N    | N   | Durée du traitement par défaut        |
| pres       | *3 |      |     |                                       |
| cription** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Obligatoire si produit Rétrocédé      |
| Norme B2** | *5 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Informations pour édition livret thérapeutique

Emis uniquement si code Edition livret thérapeutique est à T sur message
précédent (message 1)

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M2                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Produit(Unique)    |
| Produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | S    | O   | Exercice de référence                 |
| Exercice** | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code DCI du livret thérapeutique      |
| DCI**      | *6 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Ne peut être renseigné que si le code |
| Regroupé** | *7 |      |     | DCI est renseigné, correspond au      |
|            | ** |      |     | dernier niveau du livret              |
|            |    |      |     | thérapeutique.                        |
+------------+----+------+-----+---------------------------------------+

#### Message 3 : Informations comptables pour Gestion Economique.

Emis si le domaine gestion économique ELITE.S est installé.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M3                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Produit(Unique)    |
| Produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Exercice | *  | N    | O   | Exercice comptable en cours dans      |
| en cours** | *4 |      |     | ELITE.S                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code regroupement comptable de        |
| re         | *8 |      |     | l'exercice en cours                   |
| groupement | ** |      |     |                                       |
| comptable  |    |      |     |                                       |
| Ex**       |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | O   | Compte d'achat de l'exercice en cours |
| d'achat    | 10 |      |     |                                       |
| Ex**       | ** |      |     | format Lettre budget+Numéro           |
+------------+----+------+-----+---------------------------------------+
| **         | *  | N    | O   | Exercice comptable + 1 dans ELITE.S   |
| Exercice + | *4 |      |     |                                       |
| 1**        | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code regroupement comptable sde       |
| re         | *8 |      |     | Exercice +1                           |
| groupement | ** |      |     |                                       |
| comptable  |    |      |     |                                       |
| EX+1**     |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | O   | Compte d'achat de l'exercice +1       |
| d'achat    | 10 |      |     |                                       |
| EX+1**     | ** |      |     | format Lettre budget+Numéro           |
+------------+----+------+-----+---------------------------------------+
| **Code CMP | ** | S    | O   | Code nomenclature code des marchés    |
| Ex**       | 10 |      |     | public exercice en cours              |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code CMP | ** | S    | O   | Code nomenclature code des marchés    |
| Ex + 1**   | 10 |      |     | public exercice + 1                   |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### 

####  

#### Message 4 : Informations générales pour Gestion Economique.

Emis si le domaine gestion économique ELITE.S est installé.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M4                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Produit(Unique)    |
| Produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Famille de rattachement du produit    |
| Famille**  | *5 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code Entrée / Sortie simultanée :     |
| E/S**      | *1 |      |     | Valeur O ou N                         |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Code TVA associé au produit, le taux  |
| TVA**      | *2 |      |     | associé est dans la table HXTVA       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code Unité de gestion de stock,       |
| Unité de   | *5 |      |     | existe dans Table HEUNDIST            |
| gestion**  | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Stock    | ** | N    | N   | Plus utilisé en Version D.01 : report |
| minimum**  | 14 |      |     | sur Magasin                           |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Stock    | ** | N    | N   | Plus utilisé en Version D.01 : report |
| maximum**  | 14 |      |     | sur Magasin                           |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Seuil de | ** | N    | N   | Plus utilisé en Version D.01 : report |
| commande** | 14 |      |     | sur Magasin                           |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Dernier  | ** | N    | N   | Décimalisé à 4                        |
| PU facturé | 13 |      |     |                                       |
| Hors       | ** |      |     |                                       |
| taxe**     |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **P        | *  | N    | N   | Pourcentage d'alerte sur le PU        |
| ourcentage | *6 |      |     | facturé. Décimalisé à 2               |
| alerte**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **PMP**    | ** | N    | N   | Dernier prix moyen pondéré connu.     |
|            | 13 |      |     | Décimalisé à 4                        |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Produit gratuit ou pas. Valeurs O     |
| gratuit**  | *1 |      |     | pour Vrai, N pour faux.               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Quantité pouvant être décimalisée ou  |
| dé         | *1 |      |     | pas. Valeurs : O pour Vrai, N pour    |
| cimalisé** | ** |      |     | Faux                                  |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code produit stocké O/N               |
| Stock**    | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date fin | *  | Date | N   | Date d'arrêt de saisie de commande.   |
| commande** | *8 |      |     | Format YYYYMMDD                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code produit Fabriqué. T pour Vrai, F |
| fabriqué** | *1 |      |     | pour Faux                             |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Produit à utiliser dans la            |
| préco      | *1 |      |     | préconisation de commande. Valeur O   |
| nisation** | ** |      |     | pour Vrai, N pour Faux                |
+------------+----+------+-----+---------------------------------------+
| **Qté      | ** | N    | N   | Quantité de consommation forcée pour  |
| co         | 14 |      |     | préconisation. Décimalisée à 3        |
| nsommation | ** |      |     |                                       |
| forcée**   |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Famille  | *  | N    | N   | Plus utilisé à partir de la version   |
| article    | *4 |      |     | D.02                                  |
| 27**       | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | F   | Code de l'unité de                    |
| Unité de   | *5 |      |     | réapprovisionnement des armoires ou   |
| t          | ** |      |     | magasins annexes.                     |
| ransfert** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nombre   | *  | N    | F   | Equivalent en Nombre d'unités de      |
| d'unités   | *3 |      |     | gestion dans l'unité de transfert.    |
| de Gestion | ** |      |     |                                       |
| pour       |    |      |     |                                       |
| l'unité de |    |      |     |                                       |
| T          |    |      |     |                                       |
| ransfert** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 5 : Informations sur les magasins par produit.

Emis si le domaine gestion Economique ELITE.S est installé.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M5                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Produit(Unique)    |
| Produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Exercice | *  | N    | O   | Exercice de gestion                   |
| c          | *4 |      |     |                                       |
| omptable** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF       | *  | N    | O   | UF magasin de stockage                |
| Magasin**  | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | N   | Code armoire de l'UF de stockage      |
| *Armoire** | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code produit autorisé pour les        |
| t          | *1 |      |     | transferts entre magasins. Valeurs T  |
| ransfert** | ** |      |     | pour Vrai, F pour Faux                |
+------------+----+------+-----+---------------------------------------+
| **Nombre   | *  | N    | N   | Nombre de jours de couverture (       |
| jours      | *3 |      |     | préconisation)                        |
| co         | ** |      |     |                                       |
| uverture** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nombre   | *  | N    | N   | Nombre de jours de sécurité           |
| de jours   | *3 |      |     | (préconisation)                       |
| de         | ** |      |     |                                       |
| sécurité** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | N   | Quantité de dotation fixée pour       |
| en         | 14 |      |     | alimentation des magasins annexes ou  |
| dotation** | ** |      |     | armoires. Décimalisée à 3             |
+------------+----+------+-----+---------------------------------------+
| **Lieu de  | ** | S    | N   | Identification du lieu de stockage    |
| stockage** | 10 |      |     | dans le magasin                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Stock    | ** | N    | N   | Quantité stock mini ( préconisation   |
| minimum**  | 14 |      |     | si magasin principal ou               |
|            | ** |      |     | réapprovisionnement si annexe).       |
|            |    |      |     | Décimalisé à 3                        |
+------------+----+------+-----+---------------------------------------+
| **Stock    | ** | N    | N   | Quantité en stock maximum. Décimalisé |
| maximum**  | 14 |      |     | à 3                                   |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | N   | Quantité à commander ( si             |
| seuil de   | 14 |      |     | préconisation en quantité)            |
| commande** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nombre   | *  | N    | N   | Nombre de jours minimum de stock      |
| de jours   | *3 |      |     | avant réapprovisionnement             |
| mini de    | ** |      |     |                                       |
| stock pour |    |      |     |                                       |
| réappro.** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nombre   | *  | N    | N   | Nombre de jours de                    |
| de jours   | *3 |      |     | réapprovisionnement.                  |
| de         | ** |      |     |                                       |
| réappro.** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Gestion  | *  | S    | N   | Produit géré en plein/vide : T si     |
| produit    | *1 |      |     | gestion produit en Plein/vide         |
| Pl         | ** |      |     |                                       |
| ein/vide** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Gestion  | *  | S    | N   | Pour magasin principal, préconisation |
| Quantit    | *1 |      |     | en Jours ou en Quantité (J ou Q),     |
| é/Valeur** | ** |      |     | pour les annexes réapprovisionnement  |
|            |    |      |     | en Jours ou Quantité (J ou Q)         |
+------------+----+------+-----+---------------------------------------+

#### Message 6 : Informations sur les conditions de prescription.

Message facultatif.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M6                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     | YYYYMMDDHHMISSnn                      |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Produit(Unique)    |
| Produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | O   | Code de l'unité de prescription       |
| Unité de   | 12 |      |     |                                       |
| pres       | ** |      |     |                                       |
| cription** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code par | *  | S    | O   | Valeur T pour Vrai, F pour Faux.      |
| défaut**   | *1 |      |     | Identifie la valeur du code unité de  |
|            | ** |      |     | prescription par défaut               |
+------------+----+------+-----+---------------------------------------+
| **Qté en   | ** | N    | O   | Nombres d'unités correspondantes dans |
| Unité de   | 14 |      |     | une unité de gestion. Décimalisée à 3 |
| gestion**  | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code pour gérer les                   |
| calcul     | *1 |      |     | approvisionnements de la pharmacie    |
| r          | ** |      |     | vers le service en nombre correct     |
| éapprovisi |    |      |     | d'unité par rapport à la quantité     |
| onnement** |    |      |     | prescrite. Valeurs autorisées E       |
|            |    |      |     | entier, D pour décimalisé             |
+------------+----+------+-----+---------------------------------------+
| **Nb       | ** | N    | O   | Nombre d'unités de la sous forme      |
| d'unités   | 14 |      |     | prescrit par défaut le soir           |
| prescrites | ** |      |     | Décimalisé à 3                        |
| Soir**     |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nb       | ** | N    | O   | Nombre d'unités de la sous forme      |
| d'unités   | 14 |      |     | prescrit par défaut le Matin          |
| prescrites | ** |      |     | Décimalisé à 3                        |
| Matin**    |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nb       | ** | N    | O   | Nombre d'unités de la sous forme      |
| d'unités   | 14 |      |     | prescrit par défaut l'après midi      |
| prescrites | ** |      |     | Décimalisé à 3                        |
| A . Midi** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nb       | ** | N    | O   | Nombre d'unités de la sous forme      |
| d'unités   | 14 |      |     | prescrit par défaut au coucher        |
| prescrites | ** |      |     | Décimalisé à 3                        |
| Coucher**  |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | N   | Code sélectionné dans une liste de    |
| *Fréquence | *3 |      |     | valeurs                               |
| jou        | ** |      |     |                                       |
| rnalière** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Com      | *  | S    | N   |                                       |
| mentaire** | *2 |      |     |                                       |
|            | 50 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

**[\
]{.underline}**

#### Message 7 : Informations sur les formes associées aux médicaments.

Message facultatif.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M7                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     | YYYYMMDDHHMISSnn                      |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Médicament         |
| Produit**  | *8 |      |     | Hexagone                              |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code forme du médicament              |
| Forme**    | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

-   ### Modification sur produit

Mêmes messages que les message de création dès qu'une information est
modifiée avec un mode « MODIFICATION » . Seul le message sur lequel une
modification est apportée est émis.

-   ### Suppression d\'un produit

Message émis lors de la saisie d'une date de fin sur le produit

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | PR = Produits.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Suppression                           |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Produit(Unique)    |
| Produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de fin d'utilisation du produit  |
| fin**      | *8 |      |     | YYYYMMDD                              |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

-   ## Nomenclature : Fournisseurs :

    -   ### Création / Modification / Suppression d\'un fournisseur

Uniquement prévu en envoi d'Hexagone vers un autre logiciel.

#### Message 1 : Informations générales liées au fournisseur .

Message obligatoire en création de fournisseur.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | FO : Fournisseur.                     |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Fournisseur        |
| Fou        | *6 |      |     | (Unique)                              |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code permettant de regrouper des      |
| divers     | *1 |      |     | fournisseurs occasionnels sous un     |
| (O/N)**    | ** |      |     | même code divers. Dans ce cas, toutes |
|            |    |      |     | les informations utiles dans la pièce |
|            |    |      |     | comptable associée à ce code sont     |
|            |    |      |     | obligatoirement transmises. Valeurs   |
|            |    |      |     | autorisées : O pour divers, N pour    |
|            |    |      |     | fournisseur identifié.                |
+------------+----+------+-----+---------------------------------------+
| **Raison   | ** | S    | O   | Raison sociale du fournisseur en      |
| sociale**  | 35 |      |     | Majuscules                            |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Adresse  | ** | S    | N   | Adresse 1 fournisseur                 |
| 1**        | 32 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Adresse  | ** | S    | N   | Suite Adresse fournisseur             |
| 2**        | 32 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Code postal                           |
| postal**   | *5 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Ville**  | ** | S    | O   | Obligatoire majuscule                 |
|            | 32 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Bureau   | ** | S    | O   |                                       |
| dist       | 27 |      |     |                                       |
| ributeur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No       | ** | S    | N   | No téléphone du fournisseur           |
| t          | 16 |      |     |                                       |
| éléphone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | N   | No de Fax                             |
| Fax**      | 16 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | N   | No de client de l'établissement chez  |
| client**   | 10 |      |     | le fournisseur                        |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | *  | N    | O   | No de compte de tiers pour les        |
| tiers      | *8 |      |     | factures sur la section               |
| exploit.** | ** |      |     | d'exploitation.                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | N   | No de SIRET du fournisseur            |
| SIRET**    | 14 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | *  | N    | O   | No de compte de tiers pour les        |
| de tiers   | *8 |      |     | factures sur la section               |
| invest     | ** |      |     | d'investissement                      |
| issement** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code APE du fournisseur               |
| APE**      | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Délai de | *  | N    | N   | Nombre de jours pour le délai de      |
| paiement** | *3 |      |     | paiement des factures de ce           |
|            | ** |      |     | fournisseur                           |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de début d'utilisation de ce     |
| début**    | *8 |      |     | fournisseur. Format YYYYMMDD          |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | N   | Date de fin d'utilisation de ce       |
| fin**      | *8 |      |     | fournisseur. Format YYYYMMDD          |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code permettant d'indiquer si on peut |
| re         | *1 |      |     | regrouper plusieurs factures sur les  |
| groupement | ** |      |     | mandats pour ce fournisseur.. Valeurs |
| facture**  |    |      |     | T pour Vrai, F pour faux              |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code fournisseur concurrentiel ou     |
| concu      | *1 |      |     | pas. T pour Vrai, F pour faux         |
| rrentiel** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Adresse  | ** | S    | N   | Adresse EMAIL de la Maison Mère       |
| EMAIL**    | 50 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Domiciliations bancaires liées au fournisseur .

Remarque

Il existe au minimum une domiciliation bancaire par fournisseur, sauf
pour les fournisseurs divers.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | FO : Fournisseur.                     |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M2                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Fournisseur        |
| Fou        | *6 |      |     | (Unique)                              |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | Numéro de domiciliation bancaire de   |
| domic      | *2 |      |     | 01 à 99                               |
| iliation** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Clé      | *  | N    | O   | Clé RIB associée à la domiciliation   |
| RIB**      | *2 |      |     | bancaire 2 Chiffres                   |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No du compte bancaire. Lettres        |
| compte     | 11 |      |     | uniquement si CCP                     |
| bancaire** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | 5 chiffres obligatoires.              |
| banque**   | *5 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | 5 chiffres obligatoires.              |
| guichet**  | *5 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Libellé  | ** | S    | N   | Libellé de l'agence bancaire          |
| agence**   | 24 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **T        | ** | S    | O   | Titulaire du compte bancaire.         |
| itulaire** | 24 |      |     | Majuscules                            |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode de  | *  | S    | O   | Mode de règlement de la               |
| r          | *1 |      |     | domiciliation, existe dans la table   |
| èglement** | ** |      |     | HXFOUREG                              |
+------------+----+------+-----+---------------------------------------+
| **Nature** | *  | S    | O   | E pour domiciliation Etrangère, F     |
|            | *1 |      |     | pour française                        |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | N   | Date de fin de validité de la         |
| fin**      | *8 |      |     | domiciliation bancaire                |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

.

#### Message 3 : Points de commande liés au fournisseur.

Remarque

Il existe au minimum un point de commande par fournisseur, sauf pour les
fournisseurs divers.

+-------------+---+------+-----+---------------------------------------+
| *           | * | **   | *   | **Commentaires**                      |
| *Rubrique** | * | Form | *Ob |                                       |
|             | L | at** | lig |                                       |
|             | o |      | .** |                                       |
|             | n |      |     |                                       |
|             | g |      |     |                                       |
|             | . |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Type**    | * | S    | O   | Type du message :                     |
|             | * |      |     |                                       |
|             | 2 |      |     | FO : Fournisseur.                     |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Message** | * | S    | O   | M3                                    |
|             | * |      |     |                                       |
|             | 2 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Mode**    | * | S    | O   | Création                              |
|             | * |      |     |                                       |
|             | 1 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| *           | * | S    | O   | HEXAGONE                              |
| *Emetteur** | * |      |     |                                       |
|             | 1 |      |     |                                       |
|             | 5 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Date de   | * | Date | O   | Date de l'envoie au format :          |
| l'envoi**   | * |      |     |                                       |
|             | 1 |      |     | YYYYMMDDHHMISSnn                      |
|             | 6 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Individu  | * | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur   | * |      |     | message.                              |
| du          | 5 |      |     |                                       |
| message)**  | 0 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Code      | * | S    | O   | Numéro Identifiant Fournisseur        |
| Fo          | * |      |     | (Unique)                              |
| urnisseur** | 6 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **No de     | * | N    | O   | Numéro de point de commande 01 à 99   |
| point de    | * |      |     |                                       |
| cde**       | 2 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Dén       | * | S    | O   | Majuscules. Dénomination du point de  |
| omination** | * |      |     | commande                              |
|             | 3 |      |     |                                       |
|             | 5 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Adresse   | * | S    | N   | Adresse 1 du point de commande        |
| 1**         | * |      |     |                                       |
|             | 3 |      |     |                                       |
|             | 2 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Adresse   | * | S    | N   | Suite adresse                         |
| 2**         | * |      |     |                                       |
|             | 3 |      |     |                                       |
|             | 2 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Ville**   | * | S    | N   | Ville du point de commande            |
|             | * |      |     |                                       |
|             | 3 |      |     |                                       |
|             | 2 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Code      | * | N    | O   | Code postal du point de commande. 5   |
| postal**    | * |      |     | chiffres obligatoires                 |
|             | 5 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Bureau    | * | S    | N   | Bureau distributeur point de commande |
| dis         | * |      |     |                                       |
| tributeur** | 2 |      |     |                                       |
|             | 7 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Nom       | * | S    | N   | Nom du représentant                   |
| contact**   | * |      |     |                                       |
|             | 3 |      |     |                                       |
|             | 5 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **No        | * | S    | N   | No de téléphone associé               |
| téléphone** | * |      |     |                                       |
|             | 1 |      |     |                                       |
|             | 6 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **No fax**  | * | S    | N   | No de fax associé                     |
|             | * |      |     |                                       |
|             | 1 |      |     |                                       |
|             | 6 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Franco de | * | N    | N   | Décimalisé à 2, montant franco de     |
| Port**      | * |      |     | port                                  |
|             | 1 |      |     |                                       |
|             | 3 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Adresse   | * | S    | N   | Adresse EMAIL du point de commande    |
| EMAIL**     | * |      |     |                                       |
|             | 5 |      |     |                                       |
|             | 0 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+
| **Code      | * | S    | N   | Obligatoire si EDI liaison avec       |
| Robot EDI** | * |      |     | HOSPITALIS                            |
|             | 3 |      |     |                                       |
|             | * |      |     |                                       |
|             | * |      |     |                                       |
+-------------+---+------+-----+---------------------------------------+

-   ### Modification Fournisseurs

Mêmes messages que les messages de création dès qu'une information est
modifiée avec un mode « MODIFICATION »

-   ### Suppression fournisseur :

#### Message 1 : suppression d'un fournisseur

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | FO : Fournisseur.                     |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Suppression                           |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Fournisseur        |
| Fou        | *6 |      |     | (Unique)                              |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de fin d'utilisation du          |
| fin**      | *8 |      |     | fournisseur format YYYYMMDD           |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Suppression d'une domiciliation bancaire.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | FO : Fournisseur.                     |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M2                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Suppression                           |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Fournisseur        |
| Fou        | *6 |      |     | (Unique)                              |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de domiciliation bancaire          |
| domi       | *3 |      |     | supprimée                             |
| cilation** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de fin d'utilisation de la       |
| fin**      | *8 |      |     | domiciliation bancaire format         |
|            | ** |      |     | YYYYMMDD                              |
+------------+----+------+-----+---------------------------------------+

-   ## Nomenclature : Liens Produits / Fournisseurs :

### Création / Modification / Suppression d\'un lien 

Uniquement prévu en envoi d'Hexagone vers un autre logiciel

#### Message 1 : Informations générales liées au lien:

Message existant si le lien Produit / Fournisseur est saisi dans le
domaine Gestion Economique ELITE.S

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | FP : Fournisseur / Produit.           |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Numéro Identifiant Fournisseur        |
| Fou        | *6 |      |     | (Unique)                              |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code identifiant produit              |
| produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| création** | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **PU Hors  | ** | N    | N   | Prix fixé fournisseur **hors**        |
| taxe       | 13 |      |     | marché. Décimalisée à 4               |
| Fixé**     | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | N   | Quantité minimum à commander.         |
| minimum de | 14 |      |     | Décimalisée à 3                       |
| commande** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code unité de conditionnement du      |
| Unité de   | *5 |      |     | fournisseur, existe dans la table     |
| conditi    | ** |      |     | HEUNDIST                              |
| onnement** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nombre   | ** | N    | N   | Nombre d'unités de gestion dans       |
| d'unités** | 14 |      |     | l'unité de conditionnement du         |
|            | ** |      |     | fournisseur. Décimalisé à 3           |
+------------+----+------+-----+---------------------------------------+
| **Délai de | *  | N    | N   | Nombre de jours pour délai de         |
| l          | *3 |      |     | livraison.                            |
| ivraison** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Fournisseur principal du produit.     |
| f          | *1 |      |     | Valeurs T pour Vrai, F pour Faux.     |
| ournisseur | ** |      |     |                                       |
| p          |    |      |     |                                       |
| rincipal** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | Par défaut 01. Point de commande      |
| point de   | *2 |      |     | habituel pour le produit.             |
| commande** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| *          | ** | S    | N   | Texte permettant l'identification du  |
| *Référence | 10 |      |     | produit chez le fournisseur, il sera  |
| du produit | 24 |      |     | repris sur les bons de commande       |
| chez le    | ** |      |     |                                       |
| fou        |    |      |     |                                       |
| rnisseur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

# Messages Patient

-   ## Serveur d\'Identité, Mouvements, Actes :

### Création / Modification / Suppression d\'Identité Patient (ID M1)

Evènements déclenchant l'émission de ce message:

> Création d'un patient: Dès qu'un nouvel IPP est affecté dans
> l'établissement un message est envoyé. Dans le cas de la dé-fusion
> d'un patient qui réactivera un IPP supprimé.
>
> Modification: Dès qu'une information liée au patient est modifiée.
>
> Suppression: Dès qu'une suppression d'IPP ou une fusion de deux IPP
> est réalisée dans l'établissement.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | Type du message :               |
|            | *2 |           |     |                                 |
|            | ** |           |     | ID = Identification.            |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | M1                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | Création, Modification,         |
|            | *1 |           |     | Suppression                     |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | Individu au sens S3A qui a      |
| Individu** | 50 |           |     | généré le message.              |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **No IPP** | ** | S         | O   | No identifiant permanent du     |
|            | 20 |           |     | patient.                        |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom**    | ** | S         | N   | Nom usuel                       |
|            | 50 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Prénom** | ** | S         | N   | Prénom usuel                    |
|            | 50 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date     | *  | Date      | N   | Au format : YYYYMMDD            |
| n          | *8 |           |     |                                 |
| aissance** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom      | ** | S         | N   | Nom patronymique n'est          |
| jeune      | 50 |           |     | renseigné que dans le cas de    |
| fille**    | ** |           |     | femmes mariées.                 |
+------------+----+-----------+-----+---------------------------------+
| **Statut** | *  | S         | O   | Qualifie l'identité :           |
|            | *1 |           |     |                                 |
|            | ** |           |     | P Provisoire                    |
|            |    |           |     |                                 |
|            |    |           |     | D Définitive                    |
|            |    |           |     |                                 |
|            |    |           |     | N Non qualifiée                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | S         | N   | Abréviation recensée dans la    |
| Civilité** | *4 |           |     | table des civilités HEXAGONE    |
|            | ** |           |     | (HRCIV).                        |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | N   | Situation de famille abrégée    |
| *Situation | *1 |           |     | recensée dans la table HEXAGONE |
| fam.**     | ** |           |     | (HRSFA).                        |
+------------+----+-----------+-----+---------------------------------+
| **Nbre     | *  | N         | N   |                                 |
| d          | *2 |           |     |                                 |
| 'enfants** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nat      | *  | S         | N   | Nomenclature INSEE              |
| ionalité** | *3 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Lieu de  | ** | S         | N   | Lieu de naissance               |
| naiss.**   | 64 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| Adresse :  | 40 | S         | N   | Première ligne adresse          |
|            |    |           |     |                                 |
| Ligne 1    | 40 | S         | N   | Deuxième ligne adresse          |
|            |    |           |     |                                 |
| Ligne 2    | 5  | N         | N   | Code postal                     |
|            |    |           |     |                                 |
| Code       | 40 | S         | N   | Ville                           |
| postal     |    |           |     |                                 |
|            | 5  | N         | N   | Code canton                     |
| Ville      |    |           |     |                                 |
|            |    |           |     |                                 |
| Canton     |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Zone     | *  | S         | N   | Zone libre de 100 caractères    |
| t          | *1 |           |     | pour indiquer un ou plusieurs   |
| éléphone** | 00 |           |     | no de téléphones.               |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Médecin  | ** | S         | N   | Médecin traitant en cours (Nom  |
| traitant** | 35 |           |     | prénom du médecin)              |
|            | ** |           |     |                                 |
|            |    |           |     | N.B : Cette zone ne devrait     |
|            |    |           |     | plus être utilisée car il       |
|            |    |           |     | existe un nouveau message       |
|            |    |           |     | relatif au médecin ID\|MT       |
+------------+----+-----------+-----+---------------------------------+
| **Catég.   | *  | S         | N   | Catégorie socio professionnelle |
| Socio p**  | *3 |           |     | Nomenclature INSEE              |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Activ.   | *  | S         | N   | Activité socio professionnelle  |
| Socio. P** | *3 |           |     | Nomenclature INSEE              |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date     | *  | Date      | N   | Date de cessation d'activité au |
| cess.      | *8 |           |     | format :                        |
| Act**      | ** |           |     |                                 |
|            |    |           |     | YYYYMMDD                        |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Poids de | *  | 9999.99   | N   | Poids à la naissance            |
| naiss.**   | *7 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Taille   | *  | 999.99    | N   | Taille à la naissance           |
| naiss.**   | *6 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Heure    | *  | N         | N   | Heure de naissance              |
| naiss.**   | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Sexe**   | *  | S         | N   | Sexe du patient                 |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Minutes  | *  | N         | N   | Minutes de naissance            |
| naiss.**   | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **IPP      | ** | S         | N   | Ipp de la mère dans le cas ou   |
| Mère**     | 10 |           |     | l'identité concerne un nouveau  |
|            | ** |           |     | né                              |
+------------+----+-----------+-----+---------------------------------+
| **Patient  | *  | S         | N   | Patient DCD (Oui :Non)          |
| DCD**      | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date du  | ** | Date      | N   | Date de l'envoi au format :     |
| décès**    | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Identité | *  | S         | N   | Identité Confirmée (Oui :Non)   |
| c          | *1 |           |     |                                 |
| onfirmée** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Pièces   | ** | S         | N   | Pièces présentées à l'admission |
| justif     | \* |           |     | pour justifier l'identité du    |
| icatives** | ** |           |     | patient.                        |
|            |    |           |     |                                 |
|            |    |           |     | Format :                        |
|            |    |           |     |                                 |
|            |    |           |     | Patpi1\^dtpi1\^numpi1\~         |
|            |    |           |     | Patpi2\^dtpi2\^numpi2.....      |
|            |    |           |     |                                 |
|            |    |           |     | Avec Patpi = code pièce dont    |
|            |    |           |     | les valeurs sont référencée     |
|            |    |           |     | dans la table HXPI (Noyau)      |
|            |    |           |     |                                 |
|            |    |           |     | Dtpi = date de présentation de  |
|            |    |           |     | la pièce                        |
|            |    |           |     |                                 |
|            |    |           |     | (YYYYMMDDHHMMSS)                |
|            |    |           |     |                                 |
|            |    |           |     | Numpi=Numéro de la pièce        |
+------------+----+-----------+-----+---------------------------------+
| **Langue   | ** | S         | N   | Langue maternelle (HXLANG)      |
| ma         | 10 |           |     |                                 |
| ternelle** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **No       | ** | S         | N   | Numéro de sécurité sociale      |
| sécurité   | 16 |           |     |                                 |
| social**   | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Pays**   | *  | S         | N   | le pays pour l'adresse          |
|            | *3 |           |     | principale (HXNAT).             |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Liste    | *  | S         | N   | Liste des prénoms séparés par   |
| des        | *2 |           |     | des « , ».                      |
| prénoms**  | 00 |           |     |                                 |
|            | ** |           |     | Le premier prénom de la liste   |
|            |    |           |     | doit correspondre au prénom     |
|            |    |           |     | usuel                           |
+------------+----+-----------+-----+---------------------------------+
| **Té       | ** | S         | N   | Champ de la forme :             |
| léphones** | \* |           |     |                                 |
|            | ** |           |     | PATTE                           |
|            |    |           |     | LD\~PATTELP\~PATFAXD\~PATFAXP\~ |
|            |    |           |     |                                 |
|            |    |           |     | PAT                             |
|            |    |           |     | EMAILD\~PATEMAILP\~PATBEEPERD\~ |
|            |    |           |     |                                 |
|            |    |           |     | P                               |
|            |    |           |     | ATBEEPERP\~PATTELCD\~PATTELCP\~ |
|            |    |           |     |                                 |
|            |    |           |     | PATAD                           |
|            |    |           |     | ID\~PATADIP\~PATPORTD\~PATPORTP |
|            |    |           |     |                                 |
|            |    |           |     | Avec :                          |
|            |    |           |     |                                 |
|            |    |           |     | PATTELD : Téléphone domicile    |
|            |    |           |     |                                 |
|            |    |           |     | PATTELP  : Téléphone            |
|            |    |           |     | profesionnel                    |
|            |    |           |     |                                 |
|            |    |           |     | PATFAXD : Fax du domicile       |
|            |    |           |     |                                 |
|            |    |           |     | PATFAXP  : Fax professionel     |
|            |    |           |     |                                 |
|            |    |           |     | PATEMAILD : Email personnel     |
|            |    |           |     |                                 |
|            |    |           |     | PATEMAILP : Email professionel  |
|            |    |           |     |                                 |
|            |    |           |     | PATBEEPERD : Beeper personnel   |
|            |    |           |     |                                 |
|            |    |           |     | PATBEEPERP : Beeper             |
|            |    |           |     | professionel                    |
|            |    |           |     |                                 |
|            |    |           |     | PATTELCD : Téléphone cellulaire |
|            |    |           |     | personnel                       |
|            |    |           |     |                                 |
|            |    |           |     | PATTELCP : Téléphone cellulaire |
|            |    |           |     | professionel                    |
|            |    |           |     |                                 |
|            |    |           |     | PATADID : Adresse internet      |
|            |    |           |     | personelle                      |
|            |    |           |     |                                 |
|            |    |           |     | PATADIP : Adresse internet      |
|            |    |           |     | professionelle                  |
|            |    |           |     |                                 |
|            |    |           |     | PATPORTD : Portable personnel   |
|            |    |           |     |                                 |
|            |    |           |     | PATPORTP : Portable             |
|            |    |           |     | professionnel                   |
+------------+----+-----------+-----+---------------------------------+
| **Autres   | ** | S         | N   | Zone de la forme :              |
| adresses** | \* |           |     |                                 |
|            | ** |           |     | Ad1num\                         |
|            |    |           |     | ~Ad1DateDeb\~Ad1Type\~Ad1Etat\~ |
|            |    |           |     | Ad1L1\~Ad1L2\~Ad1CP\~Ad1Ville\~ |
|            |    |           |     | Ad1Pays\~Ad1Tel\~Ad1Fax\~Ad1Dat |
|            |    |           |     | efin**\^**Ad2num\~Ad2DateDeb\~A |
|            |    |           |     | d2Type\~Ad2Etat\~Ad2L1\~Ad2L2\~ |
|            |    |           |     | Ad2CP\~Ad2Ville\~Ad2Pays\~Ad2Te |
|            |    |           |     | l\~Ad2Fax\~Ad2Datefin**\^....** |
|            |    |           |     |                                 |
|            |    |           |     | Avec :                          |
|            |    |           |     |                                 |
|            |    |           |     | Num : Numéro d'ordre            |
|            |    |           |     |                                 |
|            |    |           |     | DateDeb : Date d'effet          |
|            |    |           |     |                                 |
|            |    |           |     | Type : Type d'adresse           |
|            |    |           |     |                                 |
|            |    |           |     | Etat : Etat (C en cours ou H en |
|            |    |           |     | historique)                     |
|            |    |           |     |                                 |
|            |    |           |     | L1 : première ligne adresse     |
|            |    |           |     |                                 |
|            |    |           |     | L2 : 2^ième^ ligne d'adresse    |
|            |    |           |     |                                 |
|            |    |           |     | CP : Code postal                |
|            |    |           |     |                                 |
|            |    |           |     | Ville : Ville                   |
|            |    |           |     |                                 |
|            |    |           |     | Pays : Pays (HXNAT)             |
|            |    |           |     |                                 |
|            |    |           |     | Tel : Téléphone                 |
|            |    |           |     |                                 |
|            |    |           |     | Fax : Fax                       |
|            |    |           |     |                                 |
|            |    |           |     | Datefin : Date de fin de        |
|            |    |           |     | validité                        |
|            |    |           |     |                                 |
|            |    |           |     | Pays (code iso) : Pays (HXPAYS) |
+------------+----+-----------+-----+---------------------------------+
| **Identité | *  | S         | N   | Les valeurs envoyées sont :     |
| protégée** | *1 | (booléen) |     |                                 |
|            | ** |           |     | \- pas de création/modif sur    |
|            |    |           |     | l\'identité protégée : **F**    |
|            |    |           |     |                                 |
|            |    |           |     | \- création/modif sur identité  |
|            |    |           |     | protégée et normale: **T**      |
|            |    |           |     |                                 |
|            |    |           |     | \- création/modif sur identité  |
|            |    |           |     | protégée seulement: **P**       |
+------------+----+-----------+-----+---------------------------------+
| **Fusion   | ** | S         | N   | Valeurs possibles :             |
| de         | 20 |           |     |                                 |
| patient**  | ** |           |     | Si le message envoyé est ID M1  |
|            |    |           |     | M (message de fusion pour le    |
|            |    |           |     | patient à garder)               |
|            |    |           |     |                                 |
|            |    |           |     | =Ipp du patient à supprimer     |
|            |    |           |     |                                 |
|            |    |           |     | Si le message envoyé est ID M1  |
|            |    |           |     | S (message de fusion pour le    |
|            |    |           |     | patient à supprimer)            |
|            |    |           |     |                                 |
|            |    |           |     | > =Ipp du patient à garder      |
|            |    |           |     |                                 |
|            |    |           |     | Dans tous les autres cas cette  |
|            |    |           |     | zone sera vide                  |
+------------+----+-----------+-----+---------------------------------+
| **Code     | *  | S         | N   | Code postal du lieu de          |
| postal du  | *5 |           |     | naissance                       |
| lieu de    | ** |           |     |                                 |
| n          |    |           |     |                                 |
| aissance** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Pays du  | *  | S         | N   | Pays de naissance (HXNAT)       |
| lieu de    | *3 |           |     |                                 |
| n          | ** |           |     |                                 |
| aissance** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **VIP**    | *  | B         | N   | VIP (T ou F)                    |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Identité | *  | B         | N   | Identité à valider (T ou F)     |
| à          | *1 |           |     |                                 |
| valider**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Adresse  | ** | S         | N   | Adresse Qualité Santé (AQS)     |
| Qualité    | 11 |           |     |                                 |
| Santé**    | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Identité | *  | B         | N   | Identité usurpée (T ou F)       |
| usurpée**  | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Resso    | *  | N         | N   | Ressortissant (HXEXTRES)        |
| rtissant** | *1 |           |     |                                 |
|            | ** |           |     | 1 : Français                    |
|            |    |           |     |                                 |
|            |    |           |     | 2 : CEE                         |
|            |    |           |     |                                 |
|            |    |           |     | 3 : Hors CEE                    |
+------------+----+-----------+-----+---------------------------------+
| **Niveau   | *  | N         | N   | Niveau d'étude (HXNIVET)        |
| d'étude**  | *2 |           |     |                                 |
|            | ** |           |     | 0 : Non scolarisé               |
|            |    |           |     |                                 |
|            |    |           |     | 1 : Primaire                    |
|            |    |           |     |                                 |
|            |    |           |     | 2 : Collège, BEP, CAP           |
|            |    |           |     |                                 |
|            |    |           |     | 3 : Lycée enseignement général  |
|            |    |           |     | ou technique                    |
|            |    |           |     |                                 |
|            |    |           |     | 4 : Enseignement supérieur (\>  |
|            |    |           |     | terminale)                      |
+------------+----+-----------+-----+---------------------------------+
| **Pays     | *  | S         | N   | le pays au format code iso pour |
| (code      | *2 |           |     | l'adresse principale (HXPAYS).  |
| iso)**     | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Pays du  | *  | S         | N   | Pays de naissance au format     |
| lieu de    | *2 |           |     | code iso (HXPAYS)               |
| naissance  | ** |           |     |                                 |
| (code      |    |           |     |                                 |
| iso)**     |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Heure de | *  | N         | N   | Heure de décès                  |
| décès**    | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Minute   | *  | N         | N   | Minute de décès                 |
| de décès** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | B         | N   | Personnel hospitalier           |
| *Personnel | *1 |           |     |                                 |
| hos        | ** |           |     |                                 |
| pitalier** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **INSC**   | ** | S         | N   | INSC du patient                 |
|            | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | N   | CLE INSC du patient             |
| *CLEINSC** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **P        | ** | S         | N   | Ipp fédérateur ( Serveur        |
| ATNUMREG** | 40 |           |     | régional)                       |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

###  Création / Modification / Suppression d'un médecin traitant d'un patient (ID MT)

Evènements déclenchant l'émission de ce message:

> **Création d'un médecin traitant**:
>
> Dès qu'un médecin est affecté à un patient (qui n'en avait pas) le
> message est
>
> envoyé.
>
> **Modification**: 2 cas :

Cas 1 : Changement de médecin traitant

Exemple : Cas où le patient avait MED1 pour médecin et a changé pour
MED2.

Dans ce cas, 2 messages sont envoyés

\- ID\|MT\|M...MED1 avec une date de fin de renseignée (différente de
31/12/2999)

\- ID\|MT\|M...MED2 avec date de fin = 31/12/2999 et ancien médecin =
MED1

Cas 2 : Modification du médecin traitant (suite à une erreur de saisie
par

exemple)

Exemple : Cas où le patient avait MED1 pour médecin et est modifié par
MED2.

Dans ces cas, 2 messages sont envoyés

\- ID\|MT\|S...MED1 avec une date de fin de renseignée (différente de
31/12/2999)

\- ID\|MT\|M...MED2 avec date de fin = 31/12/2999 (si c'est le médecin
en cours)

et ancien médecin = MED1

> **Suppression**: Dès qu'on supprime un médecin lié à un patient.

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | ID                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | MT                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C ou M ou S                     |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **IPP**    | ** | S         | O   | N° IPP du patient               |
|            | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code du  | *  | S         | O   | Code héxagone du médecin        |
| médecin**  | *9 |           |     | (praacc.hrpra)                  |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Nom**    | ** | S         | O   | Nom du médecin traitant         |
|            | 50 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Prénom** | ** | S         | O   | Prénom du médecin traitant      |
|            | 50 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **N°       | *  | N         | N   | N° Adéli                        |
| Adéli**    | *9 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | *  | Date      | N   | Date de création dans hexagone  |
| création** | *8 |           |     | au format YYYYMMDD              |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | *  | Date      | N   | Date de modification au format  |
| modi       | *8 |           |     | YYYYMMDD                        |
| fication** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | *  | Date      | N   | Date au format YYYYMMDD         |
| début de   | *8 |           |     |                                 |
| validité** | ** |           |     | Date de début d'assignation     |
|            |    |           |     | dans hexagone du médecin.       |
|            |    |           |     |                                 |
|            |    |           |     | Cette date doit être égale à la |
|            |    |           |     | date de fin du précédent        |
|            |    |           |     | médecin.                        |
|            |    |           |     |                                 |
|            |    |           |     | Si pas de médecin précédent,    |
|            |    |           |     | cette date sera initialisée pas |
|            |    |           |     | défaut au 01/01/1900 (soit      |
|            |    |           |     | 19000101)                       |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | *  | Date      | N   | Date de fin de validité dans    |
| fin de     | *8 |           |     | hexagone au format YYYYMMDD     |
| validité** | ** |           |     |                                 |
|            |    |           |     | Si = '29991231' cela signifie   |
|            |    |           |     | que c'est le médecin traitant   |
|            |    |           |     | en cours du patient             |
+------------+----+-----------+-----+---------------------------------+
| **Code de  | *  | S         | N   | Code héxagone de l'ancien       |
| l'ancien   | *9 |           |     | médecin traitant à envoyer      |
| médecin    | ** |           |     | uniquement s'il s'agit d'un     |
| traitant** |    |           |     | changement de médecin traitant  |
+------------+----+-----------+-----+---------------------------------+
| **N° Adéli | *  | N         | N   | N° Adéli de l'ancien médecin    |
| de         | *9 |           |     | traitant à envoyer uniquement   |
| l'ancien   | ** |           |     | s'il s'agit d'un changement de  |
| médecin    |    |           |     | médecin traitant.               |
| traitant** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **N° RPPS  | ** | S         | N   | N° RPPS du médecin traitant     |
| du médecin | 11 |           |     |                                 |
| traitant** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **N° RPPS  | ** | S         | N   | N° RPPS de l'ancien médecin     |
| de         | 11 |           |     | traitant à envoyer uniquement   |
| l'ancien   | ** |           |     | s'il s'agit d'un changement de  |
| médecin    |    |           |     | médecin traitant.               |
| traitant** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### Création / Modification du consentement éclairé d'un patient (ID CE)

Evènements déclenchant l'émission de ce message:

> **Création**:
>
> Pour un séjour, dès que le recueil du consentement a été saisi pour la
> première fois, le message est envoyé.
>
> **Modification**
>
> Pour un séjour, si l'une des informations suivantes a été modifiée :

-   Le consentement

-   Opposition au mode d'accès bris de glace

-   Opposition en mode 'centre de régulation'

-   Activation, réinitialisation ou déblocage de l'accès internet du
    > patient (passage False à True seulement

-   Modification des canaux OTP (passage de personnel à professionnel et
    > vice-versa)

+------------+----+-----------+-----+---------------------------------+
| **         | *  | *         | *   | **Commentaires**                |
| Rubrique** | *L | *Format** | *Ob |                                 |
|            | on |           | lig |                                 |
|            | g. |           | .** |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Type**   | *  | S         | O   | ID                              |
|            | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| *          | *  | S         | O   | CE                              |
| *Message** | *2 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Mode**   | *  | S         | O   | C ou M                          |
|            | *1 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | ** | S         | O   | HEXAGONE                        |
| Emetteur** | 15 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :     |
| l'envoi**  | 16 |           |     |                                 |
|            | ** |           |     | YYYYMMDDHHMISSnn                |
+------------+----+-----------+-----+---------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a      |
| (émetteur  | 50 |           |     | généré le message.              |
| du         | ** |           |     |                                 |
| message)** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **IPP**    | ** | S         | O   | N° IPP du patient               |
|            | 20 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **N°       | *  | N         | O   | N° Finess juridique de          |
| Finess     | *9 |           |     | l'établissement                 |
| j          | ** |           |     |                                 |
| uridique** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Libellé  | ** | S         | O   | Signature sinon Libellé long    |
| uti        | 50 |           |     | sinon Libellé court sinon       |
| lisateur** | ** |           |     | identifiant local               |
+------------+----+-----------+-----+---------------------------------+
| **Pr       |    | S         | O   | 1.2.250.12                      |
| ofession** |    |           |     | 13.1.1.4.6\^SECRETARIAT_MEDICAL |
+------------+----+-----------+-----+---------------------------------+
| **Sp       |    |           | N   | Vide                            |
| écialité** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date du  | *  | D         | N   | Au format : YYYYMMDD            |
| recueil du | *8 |           |     |                                 |
| cons       | ** |           |     |                                 |
| entement** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Co       | *  | B         | N   | T ou F                          |
| nsentement | *1 |           |     |                                 |
| éclairé**  | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | B         | N   | T ou F                          |
| Opposition | *1 |           |     |                                 |
| au mode    | ** |           |     |                                 |
| d'accès    |    |           |     |                                 |
| bris de    |    |           |     |                                 |
| glace**    |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **         | *  | B         | N   | T ou F                          |
| Opposition | *1 |           |     |                                 |
| au mode    | ** |           |     |                                 |
| d'accès    |    |           |     |                                 |
| ré         |    |           |     |                                 |
| gulation** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **C        | *  | B         | N   | F ou T                          |
| réation/Ré | *1 |           |     |                                 |
| activation | ** |           |     | Si ce champ est à false, les    |
| du compte  |    |           |     | canaux OTP ne sont pas          |
| internet** |    |           |     | renseignés                      |
+------------+----+-----------+-----+---------------------------------+
| **No du    | ** | S         | N   | S'il y en a un : N° portable    |
| mobile     | 50 |           |     | qui sert de canal OTP           |
| canal OTP  | ** |           |     |                                 |
| SMS**      |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Adresse  | *  | S         | N   | S'il y en a un : Email qui sert |
| Mail du    | *2 |           |     | de canal OTP                    |
| canal OTP  | 00 |           |     |                                 |
| email**    | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Code du  | ** | S         | N   | S'il y en a un : Code proche du |
| Proche     | 10 |           |     | représentant légal              |
| re         | ** |           |     |                                 |
| présentant |    |           |     |                                 |
| légal**    |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **NIR de   | ** | S         | N   | NIR de l'assuré                 |
| l'assuré** | 16 |           |     |                                 |
|            | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Date     | *  | S         | N   | Date de naissance \<B2\> de     |
| naissance  | *8 |           |     | bénéficiaire au format YYYMMDD  |
| du         | ** |           |     |                                 |
| béné       |    |           |     |                                 |
| ficiaire** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Rang de  | *  | S         | N   | Rang de naissance du            |
| naissance  | *1 |           |     | bénéficiaire                    |
| du         | ** |           |     |                                 |
| béné       |    |           |     |                                 |
| ficiaire** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **Qualité  | *  | S         | N   | Qualité du bénéficiaire         |
| du         | *3 |           |     |                                 |
| béné       | ** |           |     |                                 |
| ficiaire** |    |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+
| **NIR du   | ** | S         | N   | NIR du bénéficiaire             |
| béné       | 16 |           |     |                                 |
| ficiaire** | ** |           |     |                                 |
+------------+----+-----------+-----+---------------------------------+

### MPI (ID M5)

Evènements déclenchant l'émission de ce message (uniquement si le module
MPI.S est installé):

> Création d'une référence croisée:Dès qu'un nouvel IPP est affecté dans
> l'établissement et que le traitement de rapprochement à rapprocher des
> IPP avec celui créé, le message est envoyé .
>
> Modification d'une référence croisée: Dès qu'une information liée au
> patient est modifiée qui a impliqué une modification du niveau de
> rapprochement entre cet IPP et un autre.
>
> Suppression d'une référence croisée :Dès qu'une suppression d'IPP ou
> une fusion de deux IPP est réalisée dans l'établissement.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | ID = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M5                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IDP1**    | ** | S         | O   | Identifiant1 rapproché à      |
|             | 20 |           |     | identifiant2                  |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **AANSP1**  | ** | S         | O   | Domaine de l'identifiant1     |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **AAUUI1**  | ** | S         | O   | Identifiant universel de      |
|             | 20 |           |     | l'identifiant1                |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **AAUUIT1** | ** | S         | O   | Type d'identifiant de         |
|             | 20 |           |     | l'identifiant1                |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IDP2**    | ** | S         | O   | Identifiant2 rapproché à      |
|             | 20 |           |     | identifiant1                  |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **AANSP2**  | ** | S         | O   | Domaine de l'identifiant2     |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **AAUUI2**  | ** | S         | O   | Identifiant universel de      |
|             | 20 |           |     | l'identifiant2                |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **AAUUIT2** | ** | S         | O   | Type d'identifiant de         |
|             | 20 |           |     | l'identifiant2                |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **NIVRAP**  | *  | N         |     | Niveau de rapprochement       |
|             | *2 |           |     | renseigné en création ou      |
|             | ** |           |     | modification                  |
+-------------+----+-----------+-----+-------------------------------+
|             |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
|             |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
|             |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Message M1 IY : descriptions des informations psy (Nouveau message version c.06)

Ce message ne sera envoyé que si le du séjour est de la psychiatrie, il
sera précédé par un M1 ID uniquement pour le cas de modification du code
secteur, numéro file active ou code protection civile. Les informations
de mode d'hospitalisation et mode d'admission sont associées à un séjour
mais pas à un mouvement. De ce fait toute modification de ce mouvement
donnera lieu à l'émission d'un message M1 IY seul, il est inutile
d'envoyer un message M1 IY alors qu'il est certain qu'aucune
modification n'est intervenu sur l'identité.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | IY = Informations PSY         |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **No IPP**  | ** | S         | N   | No identifiant permanent du   |
|             | 20 |           |     | patient.                      |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **No file   | ** | S         | N   | No de file active saisie      |
| active**    | 16 |           |     | libre                         |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | S         | N   | Référencé dans la table       |
| protection  | *1 |           |     | HRPROTC                       |
| civile**    | ** |           |     |                               |
|             |    |           |     | T Mise sous tutelle           |
|             |    |           |     |                               |
|             |    |           |     | C Mise sous curatelle         |
|             |    |           |     |                               |
|             |    |           |     | S Mise sous sauvegarde de     |
|             |    |           |     | justice                       |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | S         | N   | Secteur géographique psy      |
| secteur**   | *3 |           |     | référencé dans HRCPSY         |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | N   | Type d'hospitalisation. Un    |
| mode        | *2 |           |     | mode d'hospitalisation se     |
| d'hospit    | ** |           |     | compose du type               |
| alisation** |    |           |     |                               |
|             |    |           |     | HO Hospit. D'office           |
|             |    |           |     |                               |
|             |    |           |     | HL Hospit. Libre              |
|             |    |           |     |                               |
|             |    |           |     | HDT Hospit. Demandée par un   |
|             |    |           |     | tiers                         |
+-------------+----+-----------+-----+-------------------------------+
| **Mode      | *  | S         | N   | Mode référencés dans la table |
| d'hospit    | *4 |           |     | HRPLA                         |
| alisation** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date**    | ** | Date      | N   | Date de prise en compte de ce |
|             | 16 |           |     | mode d'hospitalisation.       |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | N         | O   | Numéro de mode de placement   |
| mode de     | *4 |           |     |                               |
| placement** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Médecin   | *  | S         | N   | Code du médecin responsable   |
| re          | *9 |           |     | (champ PRAACC de la table des |
| sponsable** | ** |           |     | praticiens                    |
+-------------+----+-----------+-----+-------------------------------+

### Admission d\'un Patient (M2)

Evènements déclenchant l'émission de ce message:

Nouvelle venue d'un patient: Dès qu'un n° de séjour (de dossier) est
affecté dans l'établissement; qu'il s'agisse d'une arrivée aux urgences,
d'une hospitalisation de jour ou complète, d'une consultation ou d'une
pré admission.

> Modification: Modification d'une information portant sur cette entrée
> directe (UF, date, mode d'entrée ...)
>
> Suppression: Suppression d'une venue, ce qui revient à la suppression
> d'un dossier.

+-------------+----+--------+-----+----------------------------------+
| *           | *  | **Fo   | *   | **Commentaires**                 |
| *Rubrique** | *L | rmat** | *Ob |                                  |
|             | on |        | lig |                                  |
|             | g. |        | .** |                                  |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Type**    | *  | S      | O   | Type du message :                |
|             | *2 |        |     |                                  |
|             | ** |        |     | MV = Identification.             |
+-------------+----+--------+-----+----------------------------------+
| **Message** | *  | S      | O   | M2                               |
|             | *2 |        |     |                                  |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Mode**    | *  | S      | O   | Création, Modification,          |
|             | *1 |        |     | Suppression                      |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| *           | ** | S      | O   | HEXAGONE                         |
| *Emetteur** | 15 |        |     |                                  |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Date de   | ** | Date   | O   | Date de l'envoi au format :      |
| l'envoi**   | 16 |        |     |                                  |
|             | ** |        |     | YYYYMMDDHHMISSnn                 |
+-------------+----+--------+-----+----------------------------------+
| *           | ** | S      | O   | Individu au sens S3A qui a       |
| *Individu** | 50 |        |     | généré le message.               |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **IPP**     | ** | S      | O   | N° d'IPP                         |
|             | 20 |        |     |                                  |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **N° de     | *  | S      | O   | N° du séjour stable de l'entrée  |
| dossier**   | *9 |        |     | dans l'établissement jusqu'à la  |
|             | ** |        |     | sortie définitive.               |
+-------------+----+--------+-----+----------------------------------+
| **Date      | ** | Date   | O   | Date au format :                 |
| d'entrée**  | 14 | et     |     |                                  |
|             | ** | heure  |     | YYYYMMDDHHMISS                   |
+-------------+----+--------+-----+----------------------------------+
| **Type      | *  | S      | O   | AU Arrivée aux urgences          |
| d'arrivée** | *2 |        |     |                                  |
|             | ** |        |     | HU Hosp. suite urgence non       |
|             |    |        |     | confirmée                        |
|             |    |        |     |                                  |
|             |    |        |     | CU Consult. suite urgence non    |
|             |    |        |     | confirmée                        |
|             |    |        |     |                                  |
|             |    |        |     | ED Entrée Directe                |
|             |    |        |     |                                  |
|             |    |        |     | EX Consultation externe.         |
+-------------+----+--------+-----+----------------------------------+
| **Uf**      | *  | N      | O   | UF d'entrée : les UF sont        |
|             | *4 |        |     | recensées dans la table du noyau |
|             | ** |        |     | HEXAGONE (HXUNITE)               |
+-------------+----+--------+-----+----------------------------------+
| **Pré       | *  | S      | O   | S'agit-il d'une pré admission    |
| admission** | *1 |        |     | O/N                              |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Catégorie | *  | S      | O   | H Hospitalisés                   |
| de séjour** | *1 |        |     |                                  |
|             | ** |        |     | R Résidents                      |
|             |    |        |     |                                  |
|             |    |        |     | U Urgences                       |
|             |    |        |     |                                  |
|             |    |        |     | S Psychiatriques                 |
|             |    |        |     |                                  |
|             |    |        |     | X Consultants                    |
|             |    |        |     |                                  |
|             |    |        |     | N Nouveaux nés                   |
|             |    |        |     |                                  |
|             |    |        |     | P Pré admissions Hospi           |
|             |    |        |     |                                  |
|             |    |        |     | T Psychiatriques programmés      |
|             |    |        |     |                                  |
|             |    |        |     | Q Résidents programmés           |
+-------------+----+--------+-----+----------------------------------+
| **Mode      | *  | S      | O   | Mode d'entrée dont la            |
| d'entrée**  | *4 |        |     | nomenclature est libre pour      |
|             | ** |        |     | l'établissement et recensée dans |
|             |    |        |     | la table HEXAGONE (HREAS).       |
+-------------+----+--------+-----+----------------------------------+
| **Tra       | *  | S      | N   | Transporteur dont la             |
| nsporteur** | *7 |        |     | nomenclature est libre pour      |
|             | ** |        |     | l'établissement et recensée dans |
|             |    |        |     | la table HEXAGONE (HRPRA)        |
+-------------+----+--------+-----+----------------------------------+

+-------------+----+--------+-----+----------------------------------+
| *           | *  | **Fo   | *   | **Commentaires**                 |
| *Rubrique** | *L | rmat** | *Ob |                                  |
|             | on |        | lig |                                  |
|             | g. |        | .** |                                  |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Etab      | *  | S      | N   | Etablissement antérieur dont la  |
| lissement** | *7 |        |     | nomenclature est libre pour      |
|             | ** |        |     | l'établissement et recensée dans |
|             |    |        |     | la table HEXAGONE (HRPRA)        |
+-------------+----+--------+-----+----------------------------------+
| **Date      | *  | D      | N   | Date d'hospitalisation           |
| a           | *8 |        |     | antérieure au format YYYYMMDD.   |
| ntérieure** | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Chambre** | *  | S      | N   | Chambre                          |
|             | *6 |        |     |                                  |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Lit**     | *  | S      | N   | Lit                              |
|             | *1 |        |     |                                  |
|             | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Loc       | ** | S      | N   | Si la chambre est renseignée.    |
| alisation** | 10 |        |     | Ces localisations sont           |
|             | ** |        |     | référencées dans le noyau        |
|             |    |        |     | HEXAGONE (HXLO)                  |
+-------------+----+--------+-----+----------------------------------+
| **UF HEB.** | *  | N      | N   | L'uf d'hébergement ne sera       |
|             | *4 |        |     | envoyée que si la chambre est    |
|             | ** |        |     | renseignée.                      |
+-------------+----+--------+-----+----------------------------------+
| **N°        | *  | N      | O   | No d'ordre pour avoir une clé    |
| d'ordre du  | *4 |        |     | unique dans le cas de la         |
| mouvement** | ** |        |     | modification.                    |
+-------------+----+--------+-----+----------------------------------+
| **No        | *  | S      | N   | Pour les nouveaux nés            |
| dossier     | *9 |        |     |                                  |
| Mère**      | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Statut du | *  | S      | O   | Catégorie de dossier :           |
| séjour**    | *1 |        |     |                                  |
|             | ** |        |     | H Hospitalisés                   |
|             |    |        |     |                                  |
|             |    |        |     | R Résidents                      |
|             |    |        |     |                                  |
|             |    |        |     | U Urgences                       |
|             |    |        |     |                                  |
|             |    |        |     | S Psychiatriques                 |
|             |    |        |     |                                  |
|             |    |        |     | X Consultants                    |
|             |    |        |     |                                  |
|             |    |        |     | N Nouveaux nés                   |
|             |    |        |     |                                  |
|             |    |        |     | P Pré admissions                 |
|             |    |        |     |                                  |
|             |    |        |     | T Psychiatriques programmés      |
|             |    |        |     |                                  |
|             |    |        |     | Q Résidents programmés           |
+-------------+----+--------+-----+----------------------------------+
| **Code      | *  | N      | N   | Celui associé au mode d'entrée   |
| PMSI**      | *2 |        |     |                                  |
|             | ** |        |     | 0 par transfert provisoire       |
|             |    |        |     |                                  |
|             |    |        |     | 6 en provenance d'une autre UM   |
|             |    |        |     |                                  |
|             |    |        |     | 7 depuis une autre établissement |
|             |    |        |     |                                  |
|             |    |        |     | 8 depuis le domicile             |
+-------------+----+--------+-----+----------------------------------+
| **N° FINESS | *  | N      | N   | Référencé dans la table (HRPRA)  |
| du          | *9 |        |     |                                  |
| tra         | ** |        |     |                                  |
| nsporteur** |    |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **N° FINESS | *  | N      | N   | Référencé dans la table (HRPRA)  |
| de          | *9 |        |     |                                  |
| l'ét        | ** |        |     |                                  |
| ablissement |    |        |     |                                  |
| d'origine** |    |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Type      | *  | S      | N   | Valeurs :                        |
| d'hospit    | *1 |        |     |                                  |
| alisation** | ** |        |     | V Venues                         |
|             |    |        |     |                                  |
|             |    |        |     | S Séances                        |
|             |    |        |     |                                  |
|             |    |        |     | Pour les hospis complètes ou les |
|             |    |        |     | CX (Vide ou blanc)               |
+-------------+----+--------+-----+----------------------------------+
| **Date de   | ** | Date   | N   | Date de sortie des urgences      |
| sortie des  | 16 |        |     |                                  |
| urgences**  | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Date du   | ** | Date   | O   | Date du mouvement avant          |
| mouvement   | 16 |        |     | modification (présent seulement  |
| avant       | ** |        |     | en modification)                 |
| mod         |    |        |     |                                  |
| ification** |    |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+
| **Contexte  | ** | S      | N   | Contexte pour lequel la          |
| de          | 10 |        |     | modification du mouvement        |
| m           | ** |        |     | intervient. Valeurs :            |
| odification |    |        |     |                                  |
| du          |    |        |     | MOTIF Changement de motif de     |
| mouvement** |    |        |     | venue                            |
|             |    |        |     |                                  |
|             |    |        |     | Autres cas (Vide ou blanc)       |
+-------------+----+--------+-----+----------------------------------+
| **Médecin   | *  | S      | N   | Code du médecin responsable      |
| re          | *9 |        |     | (champ PRAACC de la table des    |
| sponsable** | ** |        |     | praticiens                       |
+-------------+----+--------+-----+----------------------------------+
| **N° de     | ** | S      | N   | = N° de dossier du premier       |
| passage**   | 20 |        |     | dossier d\'hospit d\'un patient  |
|             | ** |        |     | du moment où il entre dans une   |
|             |    |        |     | entité juridique jusqu\'au       |
|             |    |        |     | moment où il en sort.            |
+-------------+----+--------+-----+----------------------------------+
| **No de     | *  | S      | N   | No de dossier créé à la sortie   |
| dossier     | *9 |        |     | suite à un transfert vers une    |
| créé à la   | ** |        |     | autre entité géo ou suite à une  |
| sortie**    |    |        |     | mutation vers un autre champ     |
|             |    |        |     | PMSI                             |
+-------------+----+--------+-----+----------------------------------+
| **No de     | *  | S      | N   | No de dossier antérieur qui a    |
| dossier     | *9 |        |     | généré la création du dossier.   |
| antérieur** | ** |        |     |                                  |
+-------------+----+--------+-----+----------------------------------+

### Changement de Statut du Séjour (M3)

Evènements déclenchant l'émission de ce message:

> Passage d'un dossier d'un état à un autre:

-   Urgence en hospitalisation

-   Urgence en consultant externe

-   Hospitalisé en consultant

-   Consultant en hospitalisé

-   Nouveau né vers Hospitalisé

Dans l'application des serveurs, ce message ne sera jamais généré seul.
Il s'accompagnera d'un message M6 (entrée dans une unité de soin).

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MV = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M3                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création                      |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | No IPP                        |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **No        | *  | S         | O   |                               |
| dossier**   | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nouveau   | *  | S         | O   | Nouvelle catégorie de         |
| statut**    | *1 |           |     | dossier :                     |
|             | ** |           |     |                               |
|             |    |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Ancien    | *  | S         | O   | Nouvelle catégorie de         |
| statut du   | *1 |           |     | dossier :                     |
| séjour**    | ** |           |     |                               |
|             |    |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | N   | Uniquement dans le cas        |
| fin de      | 16 |           |     | changement de type de dossier |
| suite       | ** |           |     | lié à une suite               |
| donnée**    |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Motif de  | ** | S         | O   | Motif de la venue d'origine   |
| venue       | 10 |           |     |                               |
| d'origine** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF        | *  | N         | O   | UF d'origine                  |
| d'origine** | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nouveau   | ** | S         | O   | Nouveau motif de la venue     |
| motif de    | 10 |           |     |                               |
| venue**     | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nouvelle  | *  | N         | O   | Nouvelle UF                   |
| UF**        | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | ** | Date      | N   | Dans le cas d'une             |
| d'origine   | 14 |           |     | re-génération, date réelle de |
| de saisie** | ** |           |     | saisie de la suite donnée     |
|             |    |           |     | (depuis les urgences) au      |
|             |    |           |     | format YYYYMMDDHHMISS.        |
+-------------+----+-----------+-----+-------------------------------+
| **Date du   | ** | Date      | O   | Date du mouvement avant       |
| mouvement   | 16 |           |     | modification (présent         |
| avant       | ** |           |     | seulement en modification)    |
| mod         |    |           |     |                               |
| ification** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Médecin   | *  | S         | N   | Code du médecin responsable   |
| re          | *9 |           |     | (champ PRAACC de la table des |
| sponsable** | ** |           |     | praticiens)                   |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | ** | S         | N   | = N° de dossier du premier    |
| passage**   | 20 |           |     | dossier d\'hospit d\'un       |
|             | ** |           |     | patient du moment où il entre |
|             |    |           |     | dans une entité juridique     |
|             |    |           |     | jusqu\'au moment où il en     |
|             |    |           |     | sort.                         |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier créé à la       |
| dossier     | *9 |           |     | sortie suite à un transfert   |
| créé à la   | ** |           |     | vers une autre entité géo ou  |
| sortie**    |    |           |     | suite à une mutation vers un  |
|             |    |           |     | autre champ PMSI              |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier antérieur qui a |
| dossier     | *9 |           |     | généré la création du         |
| antérieur** | ** |           |     | dossier.                      |
+-------------+----+-----------+-----+-------------------------------+

\

### Changement de Rattachement du Séjour (M4)

Evènements déclenchant l'émission de ce message:

Lorsqu\'on modifie le rattachement d'IPP d'un dossier. Il s'agit d'une
transaction qui permet après un certain nombre de vérification de
rattacher automatiquement un séjour à un autre IPP.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MV = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M4                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création                      |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nouvel    | ** | S         | O   | Nouveau No IPP                |
| IPP**       | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **No        | *  | S         | O   | No de séjour                  |
| dossier**   | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Ancien    | ** | S         | O   | Ancien rattachement.          |
| IPP**       | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Fusion de | *  | S         | N   | Valeurs possibles :           |
| patient**   | *1 |           |     |                               |
|             | ** |           |     | \- F si c'est une fusion de   |
|             |    |           |     | patient (F pour Fusion et non |
|             |    |           |     | pas pour False)               |
|             |    |           |     |                               |
|             |    |           |     | \- « «  (vide) sinon          |
+-------------+----+-----------+-----+-------------------------------+
| **Date du   | ** | Date      | O   | Date du mouvement avant       |
| mouvement   | 16 |           |     | modification (présent         |
| avant       | ** |           |     | seulement en modification)    |
| mod         |    |           |     |                               |
| ification** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Médecin   | *  | S         | N   | Code du médecin responsable   |
| re          | *9 |           |     | (champ PRAACC de la table des |
| sponsable** | ** |           |     | praticiens)                   |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | ** | S         | N   | = N° de dossier du premier    |
| passage**   | 20 |           |     | dossier d\'hospit d\'un       |
|             | ** |           |     | patient du moment où il entre |
|             |    |           |     | dans une entité juridique     |
|             |    |           |     | jusqu\'au moment où il en     |
|             |    |           |     | sort.                         |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier créé à la       |
| dossier     | *9 |           |     | sortie suite à un transfert   |
| créé à la   | ** |           |     | vers une autre entité géo ou  |
| sortie**    |    |           |     | suite à une mutation vers un  |
|             |    |           |     | autre champ PMSI              |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier antérieur qui a |
| dossier     | *9 |           |     | généré la création du         |
| antérieur** | ** |           |     | dossier.                      |
+-------------+----+-----------+-----+-------------------------------+

\

### Entrée du Patient dans l\'Unité de Soins (M6)

Evénements déclenchant l'émission de ce message:

-   Une entrée directe dans l'établissement provoque en plus du message
    M2 un message M6.

-   Une confirmation de pré admission

-   Une entrée par mutation

-   Une confirmation de pré admission

-   Une suppression de mouvement

-   Une modification de la date du mouvement

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MV = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M6                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | No d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | ** | Date et   | O   | Date au format :              |
| d'entrée**  | 14 | heure     |     |                               |
|             | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | ED Entrée Directe             |
| mouvement** | *2 |           |     |                               |
|             | ** |           |     | EM Entrée par mutation        |
|             |    |           |     |                               |
|             |    |           |     | M mutation                    |
|             |    |           |     |                               |
|             |    |           |     | R Retour d'absence.           |
|             |    |           |     |                               |
|             |    |           |     | V Venue                       |
|             |    |           |     |                               |
|             |    |           |     | S Séance                      |
+-------------+----+-----------+-----+-------------------------------+
| **Uf**      | *  | N         | O   | UF du mouvement : les UF sont |
|             | *4 |           |     | recensées dans la table du    |
|             | ** |           |     | noyau HEXAGONE (HXUNITE)      |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | S         | O   | S'agit-il d'un mouvement de   |
| Prévision** | *1 |           |     | prévision (O/N)               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Chambre** | *  | S         | N   | Chambre                       |
|             | *6 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Lit**     | *  | S         | N   | Lit                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Loc       | ** | S         | N   | Si la chambre est renseignée. |
| alisation** | 10 |           |     | Ces localisations sont        |
|             | ** |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXLO)               |
+-------------+----+-----------+-----+-------------------------------+
| **UF HEB.** | *  | N         | N   | L'uf d'hébergement ne sera    |
|             | *4 |           |     | envoyée que si la chambre est |
|             | ** |           |     | renseignée.                   |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | N         | O   | No d'ordre pour avoir une clé |
| d'ordre du  | *4 |           |     | unique dans le cas de la      |
| mouvement** | ** |           |     | modification.                 |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | Nouvelle catégorie de         |
| séjour**    | *1 |           |     | dossier :                     |
|             | ** |           |     |                               |
|             |    |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Uf        | *  | N         | N   | UF précédente de mouvement,   |
| d           | *4 |           |     | uniquement pour les mutations |
| \'origine** | ** |           |     | et les retours d\'absence si  |
|             |    |           |     | l\'UF de retour est           |
|             |    |           |     | différente de l\'UF de        |
|             |    |           |     | départ.                       |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   | 0                             |
| PMSI**      | *2 |           |     |                               |
|             | ** |           |     | 6 depuis une autre unité      |
|             |    |           |     | médicale                      |
|             |    |           |     |                               |
|             |    |           |     | 7 depuis un autre             |
|             |    |           |     | établissement                 |
|             |    |           |     |                               |
|             |    |           |     | 8 depuis le domicile          |
+-------------+----+-----------+-----+-------------------------------+
| **Date du   | ** | Date      | O   | Date du mouvement avant       |
| mouvement   | 16 |           |     | modification (présent         |
| avant       | ** |           |     | seulement en modification)    |
| mod         |    |           |     |                               |
| ification** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Flag      | *  | Booléen   | N   | = T si demi-venue             |
| d           | *1 |           |     |                               |
| emi-venue** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Médecin   | *  | S         | N   | Code du médecin responsable   |
| re          | *9 |           |     | (champ PRAACC de la table des |
| sponsable** | ** |           |     | praticiens)                   |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | ** | S         | N   | = N° de dossier du premier    |
| passage**   | 20 |           |     | dossier d\'hospit d\'un       |
|             | ** |           |     | patient du moment où il entre |
|             |    |           |     | dans une entité juridique     |
|             |    |           |     | jusqu\'au moment où il en     |
|             |    |           |     | sort.                         |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier créé à la       |
| dossier     | *9 |           |     | sortie suite à un transfert   |
| créé à la   | ** |           |     | vers une autre entité géo ou  |
| sortie**    |    |           |     | suite à une mutation vers un  |
|             |    |           |     | autre champ PMSI              |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier antérieur qui a |
| dossier     | *9 |           |     | généré la création du         |
| antérieur** | ** |           |     | dossier.                      |
+-------------+----+-----------+-----+-------------------------------+

### Changement des Conditions de Séjour du Patient (M7)

Evènements déclenchant l'émission de ce message:

-   Changement de prestation (passage de régime commun à régime
    particulier ou inversement)

-   Changement de chambre ou de lit

-   Changement d'uf d'hébergement

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MV = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M7                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | N° d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Date du   | ** | Date et   | O   | Date au format :              |
| mvt.**      | 14 | heure     |     |                               |
|             | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | C Changement de chambre       |
| mouvement** | *2 |           |     |                               |
|             | ** |           |     | L Changement de lit           |
|             |    |           |     |                               |
|             |    |           |     | P Changement de prestation    |
+-------------+----+-----------+-----+-------------------------------+
| **Uf**      | *  | N         | O   | UF du mouvement : les UF sont |
|             | *4 |           |     | recensées dans la table du    |
|             | ** |           |     | noyau HEXAGONE (HXUNITE)      |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | S         | O   | S'agit-il d'un mouvement de   |
| Prévision** | *1 |           |     | prévision (O/N)               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Chambre** | *  | S         | N   | Chambre                       |
|             | *6 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Lit**     | *  | S         | N   | Lit                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Loc       | ** | S         | N   | Si la chambre est renseignée. |
| alisation** | 10 |           |     | Ces localisations sont        |
|             | ** |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXLO)               |
+-------------+----+-----------+-----+-------------------------------+
| **UF HEB.** | *  | N         | N   | L'uf d'hébergement ne sera    |
|             | *4 |           |     | envoyée que si la chambre est |
|             | ** |           |     | renseignée.                   |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | N         | O   | No d'ordre pour avoir une clé |
| d'ordre du  | *4 |           |     | unique dans le cas de la      |
| mouvement** | ** |           |     | modification.                 |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | Nouvelle catégorie de         |
| séjour**    | *1 |           |     | dossier :                     |
|             | ** |           |     |                               |
|             |    |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Date du   | ** | Date      | O   | Date du mouvement avant       |
| mouvement   | 16 |           |     | modification (présent         |
| avant       | ** |           |     | seulement en modification)    |
| mod         |    |           |     |                               |
| ification** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Médecin   | *  | S         | N   | Code du médecin responsable   |
| re          | *9 |           |     | (champ PRAACC de la table des |
| sponsable** | ** |           |     | praticiens)                   |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | ** | S         | N   | = N° de dossier du premier    |
| passage**   | 20 |           |     | dossier d\'hospit d\'un       |
|             | ** |           |     | patient du moment où il entre |
|             |    |           |     | dans une entité juridique     |
|             |    |           |     | jusqu\'au moment où il en     |
|             |    |           |     | sort.                         |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier créé à la       |
| dossier     | *9 |           |     | sortie suite à un transfert   |
| créé à la   | ** |           |     | vers une autre entité géo ou  |
| sortie**    |    |           |     | suite à une mutation vers un  |
|             |    |           |     | autre champ PMSI              |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier antérieur qui a |
| dossier     | *9 |           |     | généré la création du         |
| antérieur** | ** |           |     | dossier.                      |
+-------------+----+-----------+-----+-------------------------------+

\

### Sortie du Patient de l\'Unité de Soins (M8)

Evènements déclenchant l'émission de ce message:

-   Une Sortie définitive de l'hôpital

-   Une sortie par mutation

-   Une absence

-   Une Mutation

+------------+----+-----------+-----+----------------------------------+---+
| **         | *  | *         | *   | **Commentaires**                 |   |
| Rubrique** | *L | *Format** | *Ob |                                  |   |
|            | on |           | lig |                                  |   |
|            | g. |           | .** |                                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Type**   | *  | S         | O   | Type du message : MV =           |   |
|            | *2 |           |     | Identification.                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| *          | *  | S         | O   | M8                               |   |
| *Message** | *2 |           |     |                                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Mode**   | *  | S         | O   | Création, Modification,          |   |
|            | *1 |           |     | Suppression                      |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **         | ** | S         | O   | HEXAGONE                         |   |
| Emetteur** | 15 |           |     |                                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :      |   |
| l'envoi**  | 16 |           |     | YYYYMMDDHHMISSnn                 |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **         | ** | S         | O   | Individu au sens S3A qui a       |   |
| Individu** | 50 |           |     | généré le message.               |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **IPP**    | ** | S         | O   | N° d'IPP                         |   |
|            | 20 |           |     |                                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **N° de    | *  | S         | O   | N° du séjour stable de l'entrée  |   |
| dossier**  | *9 |           |     | dans l'établissement jusqu'à la  |   |
|            | ** |           |     | sortie définitive.               |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Date de  | ** | Date et   | O   | Date au format : YYYYMMDDHHMISS  |   |
| sortie**   | 14 | heure     |     |                                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Type de  | *  | S         | O   | SD Sortie définitive             |   |
| m          | *2 |           |     |                                  |   |
| ouvement** | ** |           |     | M Mutation                       |   |
|            |    |           |     |                                  |   |
|            |    |           |     | SM Sortie par Mutation           |   |
|            |    |           |     |                                  |   |
|            |    |           |     | A Absence                        |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Uf de    | *  | N         | O   | UF du mouvement : les UF sont    |   |
| présence** | *4 |           |     | recensées dans la table du noyau |   |
|            | ** |           |     | HEXAGONE (HXUNITE)               |   |
+------------+----+-----------+-----+----------------------------------+---+
| *          | *  | S         | N   | Chambre                          |   |
| *Chambre** | *6 |           |     |                                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Lit**    | *  | S         | N   | Lit                              |   |
|            | *1 |           |     |                                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Loca     | ** | S         | N   | Si la chambre est renseignée.    |   |
| lisation** | 10 |           |     | Ces localisations sont           |   |
|            | ** |           |     | référencées dans le noyau        |   |
|            |    |           |     | HEXAGONE (HXLO)                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **UF       | *  | N         | N   | L'uf d'hébergement ne sera       |   |
| HEB.**     | *4 |           |     | envoyée que si la chambre est    |   |
|            | ** |           |     | renseignée.                      |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Uf       | *  | N         | N   | UF de destination : les UF sont  |   |
| dest.**    | *4 |           |     | recensées dans la table du noyau |   |
|            | ** |           |     | HEXAGONE (HXUNITE)               |   |
+------------+----+-----------+-----+----------------------------------+---+
| **P        | *  | S         | O   | S'agit-il d'un mouvement de      |   |
| révision** | *1 |           |     | prévision (O/N)                  |   |
|            | ** |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **N°       | *  | N         | O   | No d'ordre pour avoir une clé    |   |
| d'ordre du | *4 |           |     | unique dans le cas de la         |   |
| m          | ** |           |     | modification.                    |   |
| ouvement** |    |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Statut   | *  | S         | O   | Nouvelle catégorie de dossier :  |   |
| du         | *1 |           |     |                                  |   |
| séjour**   | ** |           |     | H Hospitalisés                   |   |
|            |    |           |     |                                  |   |
|            |    |           |     | R Résidents                      |   |
|            |    |           |     |                                  |   |
|            |    |           |     | U Urgences                       |   |
|            |    |           |     |                                  |   |
|            |    |           |     | S Psychiatriques                 |   |
|            |    |           |     |                                  |   |
|            |    |           |     | X Consultants                    |   |
|            |    |           |     |                                  |   |
|            |    |           |     | N Nouveaux nés                   |   |
|            |    |           |     |                                  |   |
|            |    |           |     | P Pré admissions                 |   |
|            |    |           |     |                                  |   |
|            |    |           |     | T Psychiatriques programmés      |   |
|            |    |           |     |                                  |   |
|            |    |           |     | Q Résidents programmés           |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Code     | *  | N         | N   | 0 sorti pour transfert           |   |
| PMSI**     | *2 |           |     | provisoire                       |   |
|            | ** |           |     |                                  |   |
|            |    |           |     | 6 sorti vers une autre unité     |   |
|            |    |           |     | médicale                         |   |
|            |    |           |     |                                  |   |
|            |    |           |     | 7 vers un autre établissement    |   |
|            |    |           |     |                                  |   |
|            |    |           |     | 8 depuis le domicile             |   |
|            |    |           |     |                                  |   |
|            |    |           |     | 9 sorti par décès                |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Mode     | *  | S         | N   | Motif absence dont la            |   |
| absence**  | *4 |           |     | nomenclature est libre pour      |   |
|            | ** |           |     | l'établissement et recensée dans |   |
|            |    |           |     | la table HEXAGONE                |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Date du  | ** | Date      | O   | Date du mouvement avant          |   |
| mouvement  | 16 |           |     | modification (présent seulement  |   |
| avant      | ** |           |     | en modification)                 |   |
| modi       |    |           |     |                                  |   |
| fication** |    |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Date de  | ** | Date      | O   | Date de retour prévisionnel      |   |
| retour     | 16 |           |     | (présente seulement quand un     |   |
| prév       | ** |           |     | nombre de jours prévu d'absence  |   |
| isionnel** |    |           |     | a été saisi).                    |   |
+------------+----+-----------+-----+----------------------------------+---+
| **Médecin  | *  | S         | N   | Code du médecin responsable      |   |
| res        | *9 |           |     | (champ PRAACC de la table des    |   |
| ponsable** | ** |           |     | praticiens)                      |   |
+------------+----+-----------+-----+----------------------------------+---+
| **N° de    | ** | S         | N   | = N° de dossier du premier       |   |
| passage**  | 20 |           |     | dossier d\'hospit d\'un patient  |   |
|            | ** |           |     | du moment où il entre dans une   |   |
|            |    |           |     | entité juridique jusqu\'au       |   |
|            |    |           |     | moment où il en sort.            |   |
+------------+----+-----------+-----+----------------------------------+---+
| **No de    | *  | S         | N   | No de dossier créé à la sortie   |   |
| dossier    | *9 |           |     | suite à un transfert vers une    |   |
| créé à la  | ** |           |     | autre entité géo ou suite à une  |   |
| sortie**   |    |           |     | mutation vers un autre champ     |   |
|            |    |           |     | PMSI                             |   |
+------------+----+-----------+-----+----------------------------------+---+
| **No de    | *  | S         | N   | No de dossier antérieur qui a    |   |
| dossier    | *9 |           |     | généré la création du dossier.   |   |
| a          | ** |           |     |                                  |   |
| ntérieur** |    |           |     |                                  |   |
+------------+----+-----------+-----+----------------------------------+---+

### Sortie du Patient de l\'Hôpital (M9)

Evènements déclenchant l'émission de ce message:

-   Sortie définitive

-   Saisie d'un nombre de jours pour la durée prévisionnelle du séjour.
    Envoi d'un mouvement de type prévisionnel dans ce cas

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MV = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M9                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | N° d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au                       |
| sortie**    | 14 | heure     |     | format :YYYYMMDDHHMISS        |
|             | ** |           |     |                               |
|             |    |           |     | Correspond à la date de fin   |
|             |    |           |     | de suite donnée pour M9\|S    |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | SD Sortie définitive          |
| mouvement** | *2 |           |     |                               |
|             | ** |           |     | SU Urgence sans suite         |
+-------------+----+-----------+-----+-------------------------------+
| **Uf de     | *  | N         | O   | UF du mouvement : les UF sont |
| présence**  | *4 |           |     | recensées dans la table du    |
|             | ** |           |     | noyau HEXAGONE (HXUNITE)      |
+-------------+----+-----------+-----+-------------------------------+
| **Chambre** | *  | S         | N   | Chambre                       |
|             | *6 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Lit**     | *  | S         | N   | Lit                           |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Loc       | ** | S         | N   | Si la chambre est renseignée. |
| alisation** | 10 |           |     | Ces localisations sont        |
|             | ** |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXLO)               |
+-------------+----+-----------+-----+-------------------------------+
| **UF HEB.** | *  | N         | N   | L'uf d'hébergement ne sera    |
|             | *4 |           |     | envoyée que si la chambre est |
|             | ** |           |     | renseignée.                   |
+-------------+----+-----------+-----+-------------------------------+
| **Mode de   | *  | S         | O   | Mode de sortie dont la        |
| sortie**    | *4 |           |     | nomenclature est libre pour   |
|             | ** |           |     | l'établissement et recensée   |
|             |    |           |     | dans la table HEXAGONE        |
|             |    |           |     | (HREAS).                      |
+-------------+----+-----------+-----+-------------------------------+
| **C         | *  | S         | N   | Circonstance de sortie dont   |
| irconstance | *2 |           |     | la nomenclature est libre     |
| de sortie** | ** |           |     | pour l'établissement et       |
|             |    |           |     | recensée dans la table        |
|             |    |           |     | HEXAGONE (HRCIR)              |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | S         | O   | S'agit-il d'un mouvement de   |
| Prévision** | *1 |           |     | prévision (O/N).              |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | N         | O   | No d'ordre pour avoir une clé |
| d'ordre du  | *4 |           |     | unique dans le cas de la      |
| mouvement** | ** |           |     | modification.                 |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | Nouvelle catégorie de         |
| séjour**    | *1 |           |     | dossier :                     |
|             | ** |           |     |                               |
|             |    |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   | 6 sorti vers une autre unité  |
| PMSI**      | *2 |           |     | médicale                      |
|             | ** |           |     |                               |
|             |    |           |     | 7 vers un autre établissement |
|             |    |           |     |                               |
|             |    |           |     | 8 depuis le domicile          |
|             |    |           |     |                               |
|             |    |           |     | 9 sorti par décès             |
+-------------+----+-----------+-----+-------------------------------+
| **Etab      | *  | S         | N   | Etablissement                 |
| lissement** | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date du   | ** | Date      | O   | Date du mouvement avant       |
| mouvement   | 16 |           |     | modification (présent         |
| avant       | ** |           |     | seulement en modification)    |
| mod         |    |           |     |                               |
| ification** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Médecin   | *  | S         | N   | Code du médecin responsable   |
| re          | *9 |           |     | (champ PRAACC de la table des |
| sponsable** | ** |           |     | praticiens)                   |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | ** | S         | N   | = N° de dossier du premier    |
| passage**   | 20 |           |     | dossier d\'hospit d\'un       |
|             | ** |           |     | patient du moment où il entre |
|             |    |           |     | dans une entité juridique     |
|             |    |           |     | jusqu\'au moment où il en     |
|             |    |           |     | sort.                         |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier créé à la       |
| dossier     | *9 |           |     | sortie suite à un transfert   |
| créé à la   | ** |           |     | vers une autre entité géo ou  |
| sortie**    |    |           |     | suite à une mutation vers un  |
|             |    |           |     | autre champ PMSI              |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | N   | No de dossier antérieur qui a |
| dossier     | *9 |           |     | généré la création du         |
| antérieur** | ** |           |     | dossier.                      |
+-------------+----+-----------+-----+-------------------------------+

Le code PMSI est déduit de la table HREAS dans le cas de l'ED et de la
SD, par contre il est déduit par programme dans le cas des absences et
mutations.

### Couverture d'un patient (CV\|M1)

+-------------+---+-----------+-----+---------------------------------+
| *           | * | *         | *   | **Commentaires**                |
| *Rubrique** | * | *Format** | *Ob |                                 |
|             | L |           | lig |                                 |
|             | o |           | .** |                                 |
|             | n |           |     |                                 |
|             | g |           |     |                                 |
|             | . |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Type**    | * | S         | O   | Type du message :               |
|             | * |           |     |                                 |
|             | 2 |           |     | CV                              |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Message** | * | S         | O   | M1                              |
|             | * |           |     |                                 |
|             | 2 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Mode**    | * | S         | O   | Création, Modification,         |
|             | * |           |     | Suppression                     |
|             | 1 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| *           | * | S         | O   | HEXAGONE                        |
| *Emetteur** | * |           |     |                                 |
|             | 1 |           |     |                                 |
|             | 5 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Date de   | * | Date      | O   | Date de l'envoi au format :     |
| l'envoi**   | * |           |     | YYYYMMDDHHMISSnn                |
|             | 1 |           |     |                                 |
|             | 6 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **TTY**     | * | S         | N   | TTY                             |
|             | * |           |     |                                 |
|             | 5 |           |     |                                 |
|             | 0 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **No IPP**  | * | S         | O   | No identifiant permanent du     |
|             | * |           |     | patient.                        |
|             | 2 |           |     |                                 |
|             | 0 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Type      | * | S         | O   | Type de dossier                 |
| dossier**   | * |           |     |                                 |
|             | 1 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Numéro    | * | S         | O   | Numéro de dossier               |
| dossier**   | * |           |     |                                 |
|             | 9 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Pré       | * | S         | N   | Valeur O(ui) ou N(on)           |
| visionnel** | * |           |     |                                 |
|             | 1 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Type de   | * | S         | O   | Type de couverture :            |
| c           | * |           |     |                                 |
| ouverture** | 1 |           |     | A = Assurance maladie           |
|             | * |           |     |                                 |
|             | * |           |     | C = Complémentaire              |
|             |   |           |     |                                 |
|             |   |           |     | D = Ddass                       |
|             |   |           |     |                                 |
|             |   |           |     | P = Particulier                 |
|             |   |           |     |                                 |
|             |   |           |     | E = Employeur                   |
+-------------+---+-----------+-----+---------------------------------+
| **Numéro de | * | N         | O   | Numéro de couverture            |
| c           | * |           |     |                                 |
| ouverture** | 2 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **          | * | S         | O   | Code Organisme de la couverture |
| Organisme** | * |           |     |                                 |
|             | 1 |           |     | Si type de couverture = P les   |
|             | 0 |           |     | valeurs possibles sont :        |
|             | * |           |     | PATIENT ou ASSURE ou Code       |
|             | * |           |     | PROCHE (PERE, MERE....table     |
|             |   |           |     | HXCPER)                         |
+-------------+---+-----------+-----+---------------------------------+
| **Numéro    | * | S         | N   | Numéro d'immatriculation du     |
| d'immatr    | * |           |     | patient auprès de l'organisme   |
| iculation** | 1 |           |     |                                 |
|             | 6 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Date de   | * | D         | N   | Date de début de validité       |
| début de    | * |           |     | (YYYYMMDD)                      |
| validité**  | 8 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Date de   | * | D         | N   | Date de fin de validité         |
| fin de      | * |           |     | (YYYYMMDD)                      |
| validité**  | 8 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Bén       | * | S         | N   | Code bénéficiaire (code déduit  |
| éficiaire** | * |           |     | de la table HRBEN)              |
|             | 2 |           |     |                                 |
|             | * |           |     | 01 Assure(e)                    |
|             | * |           |     |                                 |
|             |   |           |     | 02 Conjoint(e)                  |
|             |   |           |     |                                 |
|             |   |           |     | 09 Concubin(e)                  |
|             |   |           |     |                                 |
|             |   |           |     | 10 Enfant                       |
|             |   |           |     |                                 |
|             |   |           |     | 11 1er enfant                   |
|             |   |           |     |                                 |
|             |   |           |     | 12 2eme enfant                  |
|             |   |           |     |                                 |
|             |   |           |     | 13 3eme enfant                  |
|             |   |           |     |                                 |
|             |   |           |     | 30 Autre ayant droit            |
|             |   |           |     |                                 |
|             |   |           |     | 50 Rang non précise             |
|             |   |           |     |                                 |
|             |   |           |     | 14 4eme enfant                  |
|             |   |           |     |                                 |
|             |   |           |     | 15 5eme enfant                  |
|             |   |           |     |                                 |
|             |   |           |     | 16 6eme enfant                  |
+-------------+---+-----------+-----+---------------------------------+
| **Rang      | * | S         | N   | Rang laser                      |
| laser**     | * |           |     |                                 |
|             | 1 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Grand     | * | S         | N   | Code grand régime (organisme)   |
| régime**    | * |           |     |                                 |
|             | 2 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Code      | * | S         | N   | Code caisse de l'organisme      |
| caisse**    | * |           |     |                                 |
|             | 3 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Code      | * | S         | N   | Code centre de l'organisme      |
| centre**    | * |           |     |                                 |
|             | 3 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Clé code  | * | S         | N   | Clé code organisme              |
| organisme** | * |           |     |                                 |
|             | 1 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Code      | * | S         | O   | Code pièce présentée à          |
| pièce**     | * |           |     | l\'admission                    |
|             | 4 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Nom**     | * | S         | N   | Nom de l'assuré (si type = A ou |
|             | * |           |     | (type = P et organisme =        |
|             | 5 |           |     | ASSURE)                         |
|             | 0 |           |     |                                 |
|             | * |           |     | ou Nom de l'employeur (si type  |
|             | * |           |     | = E)                            |
|             |   |           |     |                                 |
|             |   |           |     | ou Nom du proche (si type = P   |
|             |   |           |     | et organisme = Code proche )    |
|             |   |           |     |                                 |
|             |   |           |     | ou Nom du patient (si type = P  |
|             |   |           |     | et organisme = PATIENT )        |
+-------------+---+-----------+-----+---------------------------------+
| **Prénom**  | * | S         | N   | Prénom de l'assuré (si type = A |
|             | * |           |     | ou (type = P et organisme =     |
|             | 5 |           |     | ASSURE)                         |
|             | 0 |           |     |                                 |
|             | * |           |     | ou Prénom du proche (si type =  |
|             | * |           |     | P et organisme = Code proche )  |
|             |   |           |     |                                 |
|             |   |           |     | ou Prénom du patient (si type = |
|             |   |           |     | P et organisme = PATIENT )      |
+-------------+---+-----------+-----+---------------------------------+
| **Nom de    | * | S         | N   | Nom de fammile :                |
| famille de  | * |           |     |                                 |
| l'assuré**  | 5 |           |     | de l'assuré (si type = A ou     |
|             | 0 |           |     | (type = P et organisme =        |
|             | * |           |     | ASSURE)                         |
|             | * |           |     |                                 |
|             |   |           |     | ou du patient (si type = P et   |
|             |   |           |     | organisme = PATIENT )           |
+-------------+---+-----------+-----+---------------------------------+
| **Date de   | * | D         | N   | Date de naissance               |
| naissance** | * |           |     |                                 |
|             | 8 |           |     | de l'assuré (si type = A ou     |
|             | * |           |     | (type = P et organisme =        |
|             | * |           |     | ASSURE)                         |
|             |   |           |     |                                 |
|             |   |           |     | ou du proche (si type = P et    |
|             |   |           |     | organisme = Code proche )       |
|             |   |           |     |                                 |
|             |   |           |     | ou du patient (si type = P et   |
|             |   |           |     | organisme = PATIENT )           |
+-------------+---+-----------+-----+---------------------------------+
| *           | * | S         | N   | Civilité                        |
| *Civilité** | * |           |     |                                 |
|             | 4 |           |     | de l'assuré (si type = A ou     |
|             | * |           |     | (type = P et organisme =        |
|             | * |           |     | ASSURE)                         |
|             |   |           |     |                                 |
|             |   |           |     | ou du proche (si type = P et    |
|             |   |           |     | organisme = Code proche )       |
|             |   |           |     |                                 |
|             |   |           |     | ou du patient (si type = P et   |
|             |   |           |     | organisme = PATIENT )           |
+-------------+---+-----------+-----+---------------------------------+
| *           | * | S         | N   | Première ligne d'adresse        |
| *Adresse1** | * |           |     |                                 |
|             | 4 |           |     | de l'assuré (si type = A ou     |
|             | 0 |           |     | (type = P et organisme =        |
|             | * |           |     | ASSURE)                         |
|             | * |           |     |                                 |
|             |   |           |     | ou de l'employeur (si type = E) |
|             |   |           |     |                                 |
|             |   |           |     | ou du proche (si type = P et    |
|             |   |           |     | organisme = Code proche )       |
|             |   |           |     |                                 |
|             |   |           |     | ou du patient (si type = P et   |
|             |   |           |     | organisme = PATIENT )           |
+-------------+---+-----------+-----+---------------------------------+
| *           | * | S         | N   | Deuxième ligne d'adresse        |
| *Adresse2** | * |           |     |                                 |
|             | 4 |           |     | de l'assuré (si type = A ou     |
|             | 0 |           |     | (type = P et organisme =        |
|             | * |           |     | ASSURE)                         |
|             | * |           |     |                                 |
|             |   |           |     | ou l'employeur (si type = E)    |
|             |   |           |     |                                 |
|             |   |           |     | ou du proche (si type = P et    |
|             |   |           |     | organisme = Code proche )       |
|             |   |           |     |                                 |
|             |   |           |     | ou du patient (si type = P et   |
|             |   |           |     | organisme = PATIENT )           |
+-------------+---+-----------+-----+---------------------------------+
| **Code      | * | N         | N   | Code postal                     |
| postal**    | * |           |     |                                 |
|             | 5 |           |     | de l'assuré (si type = A ou     |
|             | * |           |     | (type = P et organisme =        |
|             | * |           |     | ASSURE)                         |
|             |   |           |     |                                 |
|             |   |           |     | ou de l'employeur (si type = E) |
|             |   |           |     |                                 |
|             |   |           |     | ou du proche (si type = P et    |
|             |   |           |     | organisme = Code proche )       |
|             |   |           |     |                                 |
|             |   |           |     | ou du patient (si type = P et   |
|             |   |           |     | organisme = PATIENT )           |
+-------------+---+-----------+-----+---------------------------------+
| **Ville**   | * | S         | N   | Ville                           |
|             | * |           |     |                                 |
|             | 4 |           |     | de l'assuré (si type = A ou     |
|             | 0 |           |     | (type = P et organisme =        |
|             | * |           |     | ASSURE)                         |
|             | * |           |     |                                 |
|             |   |           |     | ou de l'employeur (si type = E) |
|             |   |           |     |                                 |
|             |   |           |     | ou du proche (si type = P et    |
|             |   |           |     | organisme = Code proche )       |
|             |   |           |     |                                 |
|             |   |           |     | ou du patient (si type = P et   |
|             |   |           |     | organisme = PATIENT )           |
+-------------+---+-----------+-----+---------------------------------+
| **Code      | * | S         | N   | Code risque (dossier)           |
| risque**    | * |           |     |                                 |
|             | 2 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Etat      | * | S         | O   | Etat                            |
| (PEC)**     | * |           |     |                                 |
|             | 1 |           |     | P : Présomption                 |
|             | * |           |     |                                 |
|             | * |           |     | D : Demande                     |
|             |   |           |     |                                 |
|             |   |           |     | A : Accord                      |
|             |   |           |     |                                 |
|             |   |           |     | N : Demande non tacite          |
|             |   |           |     |                                 |
|             |   |           |     | R : Refus                       |
|             |   |           |     |                                 |
|             |   |           |     | T : Tacite                      |
|             |   |           |     |                                 |
|             |   |           |     | S : Suspendu                    |
|             |   |           |     |                                 |
|             |   |           |     | U : Dec Urg                     |
|             |   |           |     |                                 |
|             |   |           |     | C : Contest                     |
|             |   |           |     |                                 |
|             |   |           |     | L : Prolongation                |
|             |   |           |     |                                 |
|             |   |           |     | H : Hypothèse                   |
|             |   |           |     |                                 |
|             |   |           |     | F : Accord forcé                |
+-------------+---+-----------+-----+---------------------------------+
| **Date de   | * | D         | N   | Date de début de PEC (YYYYMMDD) |
| début de    | * |           |     |                                 |
| PEC**       | 8 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Date de   | * | D         | N   | Date de fin de PEC (YYYYMMDD)   |
| fin de      | * |           |     |                                 |
| PEC**       | 8 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Valeur    | * | S         | N   | Valeur du taux de PEC           |
| taux PEC**  | * |           |     |                                 |
|             | 4 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Numéro    | * | S         | N   | Numéro d\'accident (dossier)    |
| d\          | * |           |     |                                 |
| 'accident** | 9 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Date      | * | D         | N   | Date d'accident (YYYYMMDD)      |
| d\          | * |           |     |                                 |
| 'accident** | 8 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **Code      | * | S         | N   | Code contrat pour l'organisme   |
| contrat     | * |           |     | complémentaire                  |
| pour        | 1 |           |     |                                 |
| l'organisme | 0 |           |     |                                 |
| compl       | * |           |     |                                 |
| émentaire** | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+
| **No        | * | N         | N   | No validité contrat (organisme  |
| validité    | * |           |     | complémentaire)                 |
| contrat**   | 2 |           |     |                                 |
|             | * |           |     |                                 |
|             | * |           |     |                                 |
+-------------+---+-----------+-----+---------------------------------+

###  Libération de lit pour les séances (MV\|L1)

Evènements déclenchant l'émission de ce message:

-   Libération du lit pour une séance (en création de mouvement).

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MV = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | L1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création                      |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | N° d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | SE        | O   | « SE » : type de mouvement de |
| l           | *2 |           |     | la libération du lit.         |
| ibération** | ** |           |     | Attention, différent du       |
|             |    |           |     | typdacc. SE pour séance car   |
|             |    |           |     | sert pour les autres          |
|             |    |           |     | libérations.                  |
+-------------+----+-----------+-----+-------------------------------+
| **Bureau**  | ** | S         | O   | Bureau sur lequel a été faite |
|             | 10 |           |     | la modification               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| début du    | 14 | heure     |     |                               |
| mvt.**      | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| fin du      | 14 | heure     |     |                               |
| mvt.**      | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | S Séance                      |
| mouvement** | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| libération  | 14 | heure     |     |                               |
| du lit**    | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Uf**      | *  | N         | O   | UF d'appartenance du          |
|             | *4 |           |     | mouvement : les UF sont       |
|             | ** |           |     | recensées dans la table du    |
|             |    |           |     | noyau HEXAGONE (HXUNITE)      |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | S         | O   | S'agit-il d'un mouvement de   |
| Prévision** | *1 |           |     | prévision (O/N)               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Etab      | *  | N         | O   | Etablissement de la chambre   |
| lissement** | *3 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | O   | Code établissement            |
| ét          | *2 |           |     | géographique de la chambre    |
| ablissement | ** |           |     |                               |
| géo         |    |           |     |                               |
| graphique** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | O   | Bâtiment de la chambre        |
| *Bâtiment** | *8 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Chambre** | *  | S         | O   | Chambre : peut être vide      |
|             | *6 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Lit**     | *  | S         | O   | Lit : peut être vide          |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Loc       | ** | S         | O   | Si la chambre est renseignée. |
| alisation** | 10 |           |     | Ces localisations sont        |
|             | ** |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXLO)               |
+-------------+----+-----------+-----+-------------------------------+
| **UF HEB.** | *  | N         | O   | L'uf d'hébergement ne sera    |
|             | *4 |           |     | envoyée que si la chambre est |
|             | ** |           |     | renseignée.                   |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | N         | O   | No d'ordre pour avoir une clé |
| d'ordre du  | *4 |           |     | unique dans le cas de la      |
| mouvement** | ** |           |     | modification.                 |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | Nouvelle catégorie de         |
| séjour**    | *1 |           |     | dossier :                     |
|             | ** |           |     |                               |
|             |    |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | Type de séjour :              |
| séjour**    | *1 |           |     | typdacc.HVMVT                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode      | *  | S         | N   | Mode d'entrée/sortie/nature   |
| d'entrée/so | *4 |           |     | du mouvement                  |
| rtie/nature | ** |           |     |                               |
| du          |    |           |     |                               |
| mouvement** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Pre       | *  | S         | N   | Médecin prescripteur          |
| scripteur** | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Tra       | *  | S         | N   | Transporteur                  |
| nsporteur** | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Et        | *  | S         | N   | Etablissement d'origine       |
| ablissement | *9 |           |     |                               |
| d'origine** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | *  | Date      | N   | Date de l'envoi au format :   |
| d'hospi.    | *8 |           |     |                               |
| A           | ** |           |     | YYYYMMDD                      |
| ntérieure** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Co        | *  | N         | N   | Coefficient ou montant acquis |
| ef./Montant | *8 |           |     | par les hospitalisations      |
| acquis**    | .2 |           |     | antérieures                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Motif de  | ** | S         | N   | Motif de la venue             |
| la venue**  | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Protocole | ** | S         | N   | Protocole d'évènement         |
| d'          | 10 |           |     |                               |
| évènement** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Indicateur de dernier         |
| *Indicateur | *1 |           |     | mouvement du dossier          |
| de dernier  | ** |           |     |                               |
| mouvement** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | O   | Indicateur de venue ou séance |
| *Indicateur | *1 |           |     |                               |
| de venue ou | ** |           |     |                               |
| séance**    |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF        | *  | N         | N   | UF d'origine (en cas de       |
| d'origine** | *4 |           |     | mutation)                     |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **C         | *  | S         | N   | Circonstance de sortie        |
| irconstance | *2 |           |     |                               |
| de sortie** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF de     | *  | N         | N   | UF de transfert               |
| transfert** | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Ne sert que pour les CX :     |
| *Indicateur | *1 |           |     | valeurs : 'O', 'N', 'D'       |
| d'it        | ** |           |     | (dernière)                    |
| érativité** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Durée du  | *  | N         | N   | Durée du mouvement de         |
| mouvement   | *3 |           |     | prévision                     |
| de          | ** |           |     |                               |
| prévision** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Séjour    | *  | B         | N   | True ou False                 |
| con         | *1 |           |     |                               |
| fidentiel** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Exercice  | *  | N         | N   | Exercice du mouvement         |
| du          | *4 |           |     |                               |
| mouvement** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Durée     | *  | N         | N   | Durée normale du séjour       |
| normale du  | *3 |           |     |                               |
| séjour**    | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nombre de | *  | N         | N   | Nombre de séances/venues      |
| séanc       | *3 |           |     |                               |
| es/venues** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

##

### Libération de lit pour les venues (MV\|L1)

Evènements déclenchant l'émission de ce message:

-   Libération du lit pour une venue (en création modification).

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MV = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | L1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création                      |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | N° d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | « VE » : type de mouvement de |
| l           | *2 |           |     | la libération du lit.         |
| ibération** | ** |           |     | Attention, différent du       |
|             |    |           |     | typdacc. VE pour séance car   |
|             |    |           |     | sert pour les autres          |
|             |    |           |     | libérations.                  |
+-------------+----+-----------+-----+-------------------------------+
| **Bureau**  | ** | S         | O   | Bureau sur lequel a été faite |
|             | 10 |           |     | la modification               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| début du    | 14 | heure     |     |                               |
| mvt.**      | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| fin du      | 14 | heure     |     |                               |
| mvt.**      | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | VE        | O   | VE pour venue car sert pour   |
| mouvement** | *2 |           |     | les autres libérations        |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| libération  | 14 | heure     |     |                               |
| du lit**    | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Uf**      | *  | N         | O   | UF d'appartenance du          |
|             | *4 |           |     | mouvement : les UF sont       |
|             | ** |           |     | recensées dans la table du    |
|             |    |           |     | noyau HEXAGONE (HXUNITE)      |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | S         | O   | S'agit-il d'un mouvement de   |
| Prévision** | *1 |           |     | prévision (O/N)               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Etab      | *  | N         | O   | Etablissement de la chambre   |
| lissement** | *3 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | O   | Code établissement            |
| ét          | *2 |           |     | géographique de la chambre    |
| ablissement | ** |           |     |                               |
| géo         |    |           |     |                               |
| graphique** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | O   | Bâtiment de la chambre        |
| *Bâtiment** | *8 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Chambre** | *  | S         | O   | Chambre : peut être vide      |
|             | *6 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Lit**     | *  | S         | O   | Lit : peut être vide          |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Loc       | ** | S         | O   | Si la chambre est renseignée. |
| alisation** | 10 |           |     | Ces localisations sont        |
|             | ** |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXLO)               |
+-------------+----+-----------+-----+-------------------------------+
| **UF HEB.** | *  | N         | O   | L'uf d'hébergement ne sera    |
|             | *4 |           |     | envoyée que si la chambre est |
|             | ** |           |     | renseignée.                   |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | N         | O   | No d'ordre pour avoir une clé |
| d'ordre du  | *4 |           |     | unique dans le cas de la      |
| mouvement** | ** |           |     | modification.                 |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | Nouvelle catégorie de         |
| séjour**    | *1 |           |     | dossier :                     |
|             | ** |           |     |                               |
|             |    |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | Type de séjour :              |
| séjour**    | *1 |           |     | typdacc.HVMVT                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode      | *  | S         | N   | Mode d'entrée/sortie/nature   |
| d'entrée/so | *4 |           |     | du mouvement                  |
| rtie/nature | ** |           |     |                               |
| du          |    |           |     |                               |
| mouvement** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Pre       | *  | S         | N   | Médecin prescripteur          |
| scripteur** | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Tra       | *  | S         | N   | Transporteur                  |
| nsporteur** | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Et        | *  | S         | N   | Etablissement d'origine       |
| ablissement | *9 |           |     |                               |
| d'origine** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | *  | Date      | N   | Date de l'envoi au format :   |
| d'hospi.    | *8 |           |     |                               |
| A           | ** |           |     | YYYYMMDD                      |
| ntérieure** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Co        | *  | N         | N   | Coefficient ou montant acquis |
| ef./Montant | *8 |           |     | par les hospitalisations      |
| acquis**    | .2 |           |     | antérieures                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Motif de  | ** | S         | N   | Motif de la venue             |
| la venue**  | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Protocole | ** | S         | N   | Protocole d'évènement         |
| d'          | 10 |           |     |                               |
| évènement** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Indicateur de dernier         |
| *Indicateur | *1 |           |     | mouvement du dossier          |
| de dernier  | ** |           |     |                               |
| mouvement** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | O   | Indicateur de venue ou séance |
| *Indicateur | *1 |           |     |                               |
| de venue ou | ** |           |     |                               |
| séance**    |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF        | *  | N         | N   | UF d'origine                  |
| d'origine** | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **C         | *  | S         | N   | Circonstance de sortie        |
| irconstance | *2 |           |     |                               |
| de sortie** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF de     | *  | N         | N   | UF de transfert               |
| transfert** | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Ne sert que pour les CX :     |
| *Indicateur | *1 |           |     | valeurs : 'O', 'N', 'D'       |
| d'it        | ** |           |     | (dernière)                    |
| érativité** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Durée du  | *  | N         | N   | Durée du mouvement de         |
| mouvement   | *3 |           |     | prévision                     |
| de          | ** |           |     |                               |
| prévision** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Séjour    | *  | B         | N   | True ou False                 |
| con         | *1 |           |     |                               |
| fidentiel** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Exercice  | *  | N         | N   | Exercice du mouvement         |
| du          | *4 |           |     |                               |
| mouvement** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Durée     | *  | N         | N   | Durée normale du séjour       |
| normale du  | *3 |           |     |                               |
| séjour**    | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nombre de | *  | N         | N   | Nombre de séances/venues      |
| séanc       | *3 |           |     |                               |
| es/venues** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+


###  Libération de fin de consultation externe (MV\|FX)

Evènements déclenchant l'émission de ce message:

-   Sélection de la coche de fin de consultation non itérative (en
    création).

-   Saisie de la date de dernière consultation itérative (en création).

-   Validation de facturation d'une consultation non itérative (en
    création).

-   Modification de la date du dossier d'une consultation non itérative
    (en modification).

-   Modification de la date de dernière consultation itérative (en
    modification).

-   Suppression de la date de dernière consultation itérative (en
    suppression).

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MV = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | FX                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création (C), Modification    |
|             | *1 |           |     | (M), Suppression (S)          |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | N° d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| fin de      | 14 | heure     |     |                               |
| con         | ** |           |     | YYYYMMDDHHMISS                |
| sultation** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Bureau**  | ** | S         | O   | Bureau sur lequel a été faite |
|             | 10 |           |     | la modification               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| début du    | 14 | heure     |     |                               |
| mvt.**      | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| fin du      | 14 | heure     |     |                               |
| mvt.**      | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | CX: consultation externe      |
| mouvement** | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Uf**      | *  | N         | O   | UF d'appartenance du          |
|             | *4 |           |     | mouvement : les UF sont       |
|             | ** |           |     | recensées dans la table du    |
|             |    |           |     | noyau HEXAGONE (HXUNITE)      |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | S         | N   | S'agit-il d'un mouvement de   |
| Prévision** | *1 |           |     | prévision (O/N)               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Etab      | *  | N         | N   | Etablissement de la chambre   |
| lissement** | *3 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | *  | N         | N   | Code établissement            |
| ét          | *2 |           |     | géographique de la chambre    |
| ablissement | ** |           |     |                               |
| géo         |    |           |     |                               |
| graphique** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Bâtiment de la chambre        |
| *Bâtiment** | *8 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Chambre** | *  | S         | N   | Chambre : peut être vide      |
|             | *6 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Lit**     | *  | S         | N   | Lit : peut être vide          |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Loc       | ** | S         | N   | Si la chambre est renseignée. |
| alisation** | 10 |           |     | Ces localisations sont        |
|             | ** |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXLO)               |
+-------------+----+-----------+-----+-------------------------------+
| **UF HEB.** | *  | N         | N   | L'uf d'hébergement ne sera    |
|             | *4 |           |     | envoyée que si la chambre est |
|             | ** |           |     | renseignée.                   |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | N         | O   | No d'ordre pour avoir une clé |
| d'ordre du  | *4 |           |     | unique dans le cas de la      |
| mouvement** | ** |           |     | modification.                 |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | Nouvelle catégorie de         |
| séjour**    | *1 |           |     | dossier :                     |
|             | ** |           |     |                               |
|             |    |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Type de   | *  | S         | O   | Type de séjour :              |
| séjour**    | *1 |           |     | typdacc.HVMVT                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode      | *  | S         | N   | Mode d'entrée/sortie/nature   |
| d'entrée/so | *4 |           |     | du mouvement                  |
| rtie/nature | ** |           |     |                               |
| du          |    |           |     |                               |
| mouvement** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Pre       | *  | S         | N   | Médecin prescripteur          |
| scripteur** | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Tra       | *  | S         | N   | Transporteur                  |
| nsporteur** | *9 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Et        | *  | S         | N   | Etablissement d'origine       |
| ablissement | *9 |           |     |                               |
| d'origine** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | *  | Date      | N   | Date de l'envoi au format :   |
| d'hospi.    | *8 |           |     |                               |
| A           | ** |           |     | YYYYMMDD                      |
| ntérieure** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Co        | *  | N         | N   | Coefficient ou montant acquis |
| ef./Montant | *8 |           |     | par les hospitalisations      |
| acquis**    | .2 |           |     | antérieures                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Motif de  | ** | S         | N   | Motif de la venue             |
| la venue**  | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Protocole | ** | S         | N   | Protocole d'évènement         |
| d'          | 10 |           |     |                               |
| évènement** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Indicateur de dernier         |
| *Indicateur | *1 |           |     | mouvement du dossier          |
| de dernier  | ** |           |     |                               |
| mouvement** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Indicateur de venue ou séance |
| *Indicateur | *1 |           |     |                               |
| de venue ou | ** |           |     |                               |
| séance**    |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF        | *  | N         | N   | UF d'origine                  |
| d'origine** | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **C         | *  | S         | N   | Circonstance de sortie        |
| irconstance | *2 |           |     |                               |
| de sortie** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF de     | *  | N         | N   | UF de transfert               |
| transfert** | *4 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Ne sert que pour les CX :     |
| *Indicateur | *1 |           |     | valeurs : 'O', 'N', 'D'       |
| d'it        | ** |           |     | (dernière)                    |
| érativité** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Durée du  | *  | N         | N   | Durée du mouvement de         |
| mouvement   | *3 |           |     | prévision                     |
| de          | ** |           |     |                               |
| prévision** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Séjour    | *  | B         | N   | True ou False                 |
| con         | *1 |           |     |                               |
| fidentiel** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Exercice  | *  | N         | N   | Exercice du mouvement         |
| du          | *4 |           |     |                               |
| mouvement** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Durée     | *  | N         | N   | Durée normale du séjour       |
| normale du  | *3 |           |     |                               |
| séjour**    | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nombre de | *  | N         | N   | Nombre de séances/venues      |
| séanc       | *3 |           |     |                               |
| es/venues** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

##  Messages mouvements d'urgence

Le but est d'envoyer au service échange les mouvements de box, en se
rapprochant de la forme de message HL7 qui veut que dans un message on
envoie toujours la localisation origine du patient et sa localisation
destination.

En HL7 on distingue deux types de localisation, Temporaires (les
plateaux techniques, salles d'attentes ...) et définitives (Box).

### Mouvements de box B1

Un seul message MU / B1 envoyé pour identifier les évènements suivants :

Arrivée
aux urgences et mise en box directe

Changement de box (passage d'un box à un autre)

Sortie
des urgences si le patient était dans un box.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MU = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | B1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | No d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | catégorie de dossier :        |
| séjour**    | *1 |           |     |                               |
|             | ** |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | ** | Date et   | O   | Date au format :              |
| d'entrée    | 14 | heure     |     |                               |
| dans le     | ** |           |     | YYYYMMDDHHMISS                |
| BOX**       |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF        | *  | N         | O   | UF de responsabilité : les UF |
| respo       | *4 |           |     | sont recensées dans la table  |
| nsabilité** | ** |           |     | du noyau HEXAGONE (HXUNITE)   |
+-------------+----+-----------+-----+-------------------------------+
| **Zone      | ** | S         | N   | La localisation aux urgences  |
| d'urgence   | 10 |           |     | est composée de quatre champs |
| de la       | ** |           |     | Zone d'urgence, le secteur,   |
| l           |    |           |     | le box, no de box. Dans       |
| ocalisation |    |           |     | certains cas les quatre       |
| de          |    |           |     | champs de la localisation de  |
| départ.**   |    |           |     | départ peuvent être nuls, à   |
|             |    |           |     | l'arrivée du patient par      |
|             |    |           |     | exemple.                      |
|             |    |           |     |                               |
|             |    |           |     | Les Zones d'urgence sont      |
|             |    |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXUZONE)            |
+-------------+----+-----------+-----+-------------------------------+
| **Secteur   | ** | S         | N   | Une zones d'urgence est       |
| de départ** | 10 |           |     | composée de secteurs typés    |
|             | ** |           |     | (Box, Plateaux techniques,    |
|             |    |           |     | localisation, attentes...)    |
|             |    |           |     | Les secteurs sont référencées |
|             |    |           |     | dans le noyau HEXAGONE        |
|             |    |           |     | (HXUSEC)                      |
+-------------+----+-----------+-----+-------------------------------+
| **BOX de    | *  | S         | N   | Dans un secteur de type Box   |
| départ**    | *6 |           |     | on retrouve les emplacements  |
|             | ** |           |     | Box référencées dans le noyau |
|             |    |           |     | HEXAGONE (HXCH avec le champ  |
|             |    |           |     | chtype='B')                   |
+-------------+----+-----------+-----+-------------------------------+
| **N° de Box | *  | S         | N   | N° d'un Box référencés dans   |
| de départ** | *1 |           |     | le noyau HEXAGONE (HXBOX)     |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Zone      | ** | S         | N   | La localisation aux urgences  |
| d'urgence   | 10 |           |     | est composée de quatre champs |
| de la       | ** |           |     | Zone d'urgence, le secteur,   |
| l           |    |           |     | le box, no de box.            |
| ocalisation |    |           |     |                               |
| de          |    |           |     | Su nul, les quatre champs de  |
| des         |    |           |     | la localisation destinatrice  |
| tination.** |    |           |     | peuvent être nuls, cas de la  |
|             |    |           |     | sortie des urgences par       |
|             |    |           |     | exemple.                      |
|             |    |           |     |                               |
|             |    |           |     | Les Zones d'urgence sont      |
|             |    |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXUZONE)            |
+-------------+----+-----------+-----+-------------------------------+
| **Secteur   | ** | S         | N   | Une zones d'urgence est       |
| de          | 10 |           |     | composée de secteurs typés    |
| de          | ** |           |     | (Box, Plateaux techniques,    |
| stination** |    |           |     | localisation, attentes...)    |
|             |    |           |     | Les secteurs sont référencées |
|             |    |           |     | dans le noyau HEXAGONE        |
|             |    |           |     | (HXUSEC)                      |
+-------------+----+-----------+-----+-------------------------------+
| **BOX de    | *  | S         | N   | Dans un secteur de type Box   |
| de          | *6 |           |     | on retrouve les emplacements  |
| stination** | ** |           |     | Box référencés dans le noyau  |
|             |    |           |     | HEXAGONE (HXCH avec le champ  |
|             |    |           |     | chtype='B')                   |
+-------------+----+-----------+-----+-------------------------------+
| **N° de Box | *  | S         | N   | N° d'un Box référencés dans   |
| de          | *1 |           |     | le noyau HEXAGONE (HXBOX)     |
| de          | ** |           |     |                               |
| stination** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° ordre  | *  | N         | O   | C'est un n° interne           |
| du          | *4 |           |     | permettant d'avoir une clé    |
| mouvement   | ** |           |     | unique dans HEXAGONE pour les |
| d'urgence** |    |           |     | mouvements d'urgences (part   |
|             |    |           |     | de 1 et on incrémente à       |
|             |    |           |     | chaque mouvement, attention   |
|             |    |           |     | quand le patient est          |
|             |    |           |     | hospitalisé le compteur de    |
|             |    |           |     | mouvement repart à 1 pour la  |
|             |    |           |     | séquence d'hospitalisation).  |
+-------------+----+-----------+-----+-------------------------------+
| **Ancienne  | ** | Date      | N   | Dans le cas de la             |
| date du     | 16 |           |     | modification ou la            |
| mouvement** | ** |           |     | suppression on aura           |
|             |    |           |     | l'ancienne date du mouvement  |
+-------------+----+-----------+-----+-------------------------------+

##  Mouvements temporaires aux urgences MT

Trois messages distincts sont envoyés pour identifier les évènements
suivants :

Départ
d'un emplacement temporaire, quelque soit l'emplacement de destination
même un Box.

Arrivée
dans un emplacement temporaire, quelque soit l'emplacement de départ
même un Box.

Changement d'emplacement temporaire.

### Message M6 (Arrivée dans un emplacement temporaire)

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MT = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M6                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | No d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | catégorie de dossier :        |
| séjour**    | *1 |           |     |                               |
|             | ** |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | ** | Date et   | O   | Date au format :              |
| d'entrée ds | 14 | heure     |     |                               |
| l'          | ** |           |     | YYYYMMDDHHMISS                |
| emplacement |    |           |     |                               |
| t           |    |           |     |                               |
| emporaire** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF        | *  | N         | O   | UF de responsabilité : les UF |
| respo       | *4 |           |     | sont recensées dans la table  |
| nsabilité** | ** |           |     | du noyau HEXAGONE (HXUNITE)   |
+-------------+----+-----------+-----+-------------------------------+
| **Zone      | ** | S         | N   | La localisation aux urgences  |
| d'urgence   | 10 |           |     | est composée de quatre champs |
| de la       | ** |           |     | Zone d'urgence, le secteur,   |
| l           |    |           |     | le box, no de box. Dans       |
| ocalisation |    |           |     | certains cas les quatre       |
| de          |    |           |     | champs de la localisation de  |
| départ.**   |    |           |     | départ peuvent être nuls, à   |
|             |    |           |     | l'arrivée du patient par      |
|             |    |           |     | exemple.                      |
|             |    |           |     |                               |
|             |    |           |     | Les Zones d'urgence sont      |
|             |    |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXUZONE)            |
+-------------+----+-----------+-----+-------------------------------+
| **Secteur   | ** | S         | N   | Une zones d'urgence est       |
| de départ** | 10 |           |     | composée de secteurs typés    |
|             | ** |           |     | (Box, Plateaux techniques,    |
|             |    |           |     | localisation, attentes...)    |
|             |    |           |     | Les secteurs sont référencées |
|             |    |           |     | dans le noyau HEXAGONE        |
|             |    |           |     | (HXUSEC)                      |
+-------------+----+-----------+-----+-------------------------------+
| **          | ** | S         | N   | Si type d'emplacement Box, on |
| Emplacement | 10 |           |     | a le code Box (sur 6          |
| de départ   | ** |           |     | positions) on retrouve les    |
| (exemple    |    |           |     | emplacements Box référencés   |
| BOX)**      |    |           |     | dans le noyau HEXAGONE (HXCH  |
|             |    |           |     | avec le champ chtype='B')     |
|             |    |           |     |                               |
|             |    |           |     | Si type Salle d'attente , on  |
|             |    |           |     | a le code salle (sur 6        |
|             |    |           |     | positions) on retrouve les    |
|             |    |           |     | emplacements salle d'attente  |
|             |    |           |     | référencés dans le noyau      |
|             |    |           |     | HEXAGONE (HXCH avec le champ  |
|             |    |           |     | chtype='T')                   |
|             |    |           |     |                               |
|             |    |           |     | Si type plateaux technique,   |
|             |    |           |     | on peut avoir le code plateau |
|             |    |           |     | technique (sur 10 positions)  |
|             |    |           |     | référencé dans HEXAGONE       |
|             |    |           |     | (HXPLT). Mais attention la    |
|             |    |           |     | référence aux plateaux        |
|             |    |           |     | techniques n'est pas          |
|             |    |           |     | obligatoire dans HEXAGONE     |
|             |    |           |     | auquel cas ce champ est vide. |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | S         | N   | Si type d'emplacement Box ,   |
| emplacement | *6 |           |     | on a le n° de box (sur 1      |
| de départ** | ** |           |     | position)                     |
|             |    |           |     |                               |
|             |    |           |     | Si type d'emplacement Salle   |
|             |    |           |     | d'attente ce champ est vide.  |
|             |    |           |     |                               |
|             |    |           |     | Si type plateaux technique,   |
|             |    |           |     | on peut avoir le code de la   |
|             |    |           |     | salle d'examen (sur 6         |
|             |    |           |     | positions) référencé dans     |
|             |    |           |     | HEXAGONE (HXCHPLT). Mais      |
|             |    |           |     | attention la référence aux    |
|             |    |           |     | salles d'examen n'est pas     |
|             |    |           |     | obligatoire dans HEXAGONE     |
|             |    |           |     | auquel cas ce champ est vide. |
+-------------+----+-----------+-----+-------------------------------+
| **Type      | *  | S         | O   | S= Salle d'attente            |
| d'          | *1 |           |     |                               |
| emplacement | ** |           |     | P= Plateau technique          |
| de          |    |           |     |                               |
| stination** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Zone      | ** | S         | O   | La localisation aux urgences  |
| d'urgence   | 10 |           |     | est composée de quatre champs |
| de la       | ** |           |     | Zone d'urgence, le secteur,   |
| l           |    |           |     | le box, no de box. Dans       |
| ocalisation |    |           |     | certains cas les quatre       |
| des         |    |           |     | champs de la localisation de  |
| tination.** |    |           |     | départ peuvent être nuls, à   |
|             |    |           |     | l'arrivée du patient par      |
|             |    |           |     | exemple.                      |
|             |    |           |     |                               |
|             |    |           |     | Les Zones d'urgence sont      |
|             |    |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXUZONE)            |
+-------------+----+-----------+-----+-------------------------------+
| **Secteur   | ** | S         | O   | Une zones d'urgence est       |
| de          | 10 |           |     | composée de secteurs typés    |
| stination** | ** |           |     | (Box, Plateaux techniques,    |
|             |    |           |     | localisation, attentes...)    |
|             |    |           |     | Les secteurs sont référencées |
|             |    |           |     | dans le noyau HEXAGONE        |
|             |    |           |     | (HXUSEC)                      |
+-------------+----+-----------+-----+-------------------------------+
| **          | ** | S         | N   | Si type Salle d'attente , on  |
| Emplacement | 10 |           |     | a le code salle (sur 6        |
| temporaire  | ** |           |     | positions) on retrouve les    |
| de          |    |           |     | emplacements salle d'attente  |
| stination** |    |           |     | référencés dans le noyau      |
|             |    |           |     | HEXAGONE (HXCH avec le champ  |
|             |    |           |     | chtype='T')                   |
|             |    |           |     |                               |
|             |    |           |     | Si type plateaux technique,   |
|             |    |           |     | on peut avoir le code plateau |
|             |    |           |     | technique (sur 10 positions)  |
|             |    |           |     | référencé dans HEXAGONE       |
|             |    |           |     | (HXPLT). Mais attention la    |
|             |    |           |     | référence aux plateaux        |
|             |    |           |     | techniques n'est pas          |
|             |    |           |     | obligatoire dans HEXAGONE     |
|             |    |           |     | auquel cas ce champ est vide. |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | S         | N   | Si type d'emplacement Salle   |
| emplacement | *6 |           |     | d'attente ce champ est vide.  |
| tem         | ** |           |     |                               |
| porairement |    |           |     | Si type plateaux technique,   |
| de          |    |           |     | on peut avoir le code de la   |
| stination** |    |           |     | salle d'examen (sur 6         |
|             |    |           |     | positions) référencé dans     |
|             |    |           |     | HEXAGONE (HXCHPLT). Mais      |
|             |    |           |     | attention la référence aux    |
|             |    |           |     | salles d'examen n'est pas     |
|             |    |           |     | obligatoire dans HEXAGONE     |
|             |    |           |     | auquel cas ce champ est vide. |
+-------------+----+-----------+-----+-------------------------------+
| **N° ordre  | *  | N         | O   | C'est un n° interne           |
| du          | *4 |           |     | permettant d'avoir une clé    |
| mouvement   | ** |           |     | unique dans HEXAGONE pour les |
| d'urgence** |    |           |     | mouvements d'urgences (part   |
|             |    |           |     | de 1 et on incrémente à       |
|             |    |           |     | chaque mouvement, attention   |
|             |    |           |     | quand le patient est          |
|             |    |           |     | hospitalisé le compteur de    |
|             |    |           |     | mouvement repart à 1 pour la  |
|             |    |           |     | séquence d'hospitalisation).  |
+-------------+----+-----------+-----+-------------------------------+
| **Ancienne  | ** | Date      | N   | Dans le cas de la             |
| date du     | 16 |           |     | modification ou la            |
| mouvement** | ** |           |     | suppression on aura           |
|             |    |           |     | l'ancienne date du mouvement  |
+-------------+----+-----------+-----+-------------------------------+

Ce message est envoyé à chaque fois que le patient est mis dans un
emplacement temporaire.

###  Message M8 (sortie d'un emplacement temporaire)

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | MT = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M8                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | No d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **Statut du | *  | S         | O   | catégorie de dossier :        |
| séjour**    | *1 |           |     |                               |
|             | ** |           |     | H Hospitalisés                |
|             |    |           |     |                               |
|             |    |           |     | R Résidents                   |
|             |    |           |     |                               |
|             |    |           |     | U Urgences                    |
|             |    |           |     |                               |
|             |    |           |     | S Psychiatriques              |
|             |    |           |     |                               |
|             |    |           |     | X Consultants                 |
|             |    |           |     |                               |
|             |    |           |     | N Nouveaux nés                |
|             |    |           |     |                               |
|             |    |           |     | P Pré admissions              |
|             |    |           |     |                               |
|             |    |           |     | T Psychiatriques programmés   |
|             |    |           |     |                               |
|             |    |           |     | Q Résidents programmés        |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Date au format :              |
| sortie de   | 14 | heure     |     |                               |
| l'          | ** |           |     | YYYYMMDDHHMISS                |
| emplacement |    |           |     |                               |
| t           |    |           |     |                               |
| emporaire** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **UF        | *  | N         | O   | UF de responsabilité : les UF |
| respo       | *4 |           |     | sont recensées dans la table  |
| nsabilité** | ** |           |     | du noyau HEXAGONE (HXUNITE)   |
+-------------+----+-----------+-----+-------------------------------+
| **Type      | *  | S         | O   | S= Salle d'attente            |
| d'          | *1 |           |     |                               |
| emplacement | ** |           |     | P= Plateau technique          |
| de départ** |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Zone      | ** | S         | O   | La localisation aux urgences  |
| d'urgence   | 10 |           |     | est composée de quatre champs |
| de la       | ** |           |     | Zone d'urgence, le secteur,   |
| l           |    |           |     | le box, no de box. Dans       |
| ocalisation |    |           |     | certains cas les quatre       |
| de          |    |           |     | champs de la localisation de  |
| départ.**   |    |           |     | départ peuvent être nuls, à   |
|             |    |           |     | l'arrivée du patient par      |
|             |    |           |     | exemple.                      |
|             |    |           |     |                               |
|             |    |           |     | Les Zones d'urgence sont      |
|             |    |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXUZONE)            |
+-------------+----+-----------+-----+-------------------------------+
| **Secteur   | ** | S         | O   | Une zones d'urgence est       |
| de départ** | 10 |           |     | composée de secteurs typés    |
|             | ** |           |     | (Box, Plateaux techniques,    |
|             |    |           |     | localisation, attentes...)    |
|             |    |           |     | Les secteurs sont référencées |
|             |    |           |     | dans le noyau HEXAGONE        |
|             |    |           |     | (HXUSEC)                      |
+-------------+----+-----------+-----+-------------------------------+
| **          | ** | S         | N   | Si type Salle d'attente, on a |
| Emplacement | 10 |           |     | le code salle (sur 6          |
| de départ   | ** |           |     | positions) on retrouve les    |
| (exemple    |    |           |     | emplacements salle d'attente  |
| BOX )**     |    |           |     | référencés dans le noyau      |
|             |    |           |     | HEXAGONE (HXCH avec le champ  |
|             |    |           |     | chtype='T')                   |
|             |    |           |     |                               |
|             |    |           |     | Si type plateaux technique,   |
|             |    |           |     | on peut avoir le code plateau |
|             |    |           |     | technique (sur 10 positions)  |
|             |    |           |     | référencé dans HEXAGONE       |
|             |    |           |     | (HXPLT). Mais attention la    |
|             |    |           |     | référence aux plateaux        |
|             |    |           |     | techniques n'est pas          |
|             |    |           |     | obligatoire dans HEXAGONE     |
|             |    |           |     | auquel cas ce champ est vide. |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | S         | N   | Si type d'emplacement Salle   |
| emplacement | *6 |           |     | d'attente ce champ est vide.  |
| de départ** | ** |           |     |                               |
|             |    |           |     | Si type plateaux technique,   |
|             |    |           |     | on peut avoir le code de la   |
|             |    |           |     | salle d'examen (sur 6         |
|             |    |           |     | positions) référencé dans     |
|             |    |           |     | HEXAGONE (HXCHPLT). Mais      |
|             |    |           |     | attention la référence aux    |
|             |    |           |     | salles d'examen n'est pas     |
|             |    |           |     | obligatoire dans HEXAGONE     |
|             |    |           |     | auquel cas ce champ est vide. |
+-------------+----+-----------+-----+-------------------------------+
| **Type      | *  | S         | N   | = B, Box (on pourra faire     |
| d'          | *1 |           |     | évoluer ce type d'emplacement |
| emplacement | ** |           |     | par la suite et suivant les   |
| de          |    |           |     | besoins futurs)               |
| stination** |    |           |     |                               |
|             |    |           |     | = nul, les quatre champs      |
|             |    |           |     | suivants seront nuls          |
|             |    |           |     | également car cela signifie   |
|             |    |           |     | que le patient n'était pas    |
|             |    |           |     | localisé.                     |
|             |    |           |     |                               |
|             |    |           |     | S= Salle d'attente            |
|             |    |           |     |                               |
|             |    |           |     | P= Plateau technique          |
+-------------+----+-----------+-----+-------------------------------+
| **Zone      | ** | S         | N   | La localisation aux urgences  |
| d'urgence   | 10 |           |     | est composée de quatre champs |
| de la       | ** |           |     | Zone d'urgence, le secteur,   |
| l           |    |           |     | le box, no de box. Dans       |
| ocalisation |    |           |     | certains cas les quatre       |
| des         |    |           |     | champs de la localisation de  |
| tination.** |    |           |     | départ peuvent être nuls, à   |
|             |    |           |     | l'arrivée du patient par      |
|             |    |           |     | exemple.                      |
|             |    |           |     |                               |
|             |    |           |     | Les Zones d'urgence sont      |
|             |    |           |     | référencées dans le noyau     |
|             |    |           |     | HEXAGONE (HXUZONE)            |
+-------------+----+-----------+-----+-------------------------------+
| **Secteur   | ** | S         | N   | Une zones d'urgence est       |
| de          | 10 |           |     | composée de secteurs typés    |
| stination** | ** |           |     | (Box, Plateaux techniques,    |
|             |    |           |     | localisation, attentes...)    |
|             |    |           |     | Les secteurs sont référencées |
|             |    |           |     | dans le noyau HEXAGONE        |
|             |    |           |     | (HXUSEC)                      |
+-------------+----+-----------+-----+-------------------------------+
| **          | ** | S         | N   | Si type d'emplacement Box, on |
| Emplacement | 10 |           |     | a le code Box (sur 6          |
| temporaire  | ** |           |     | positions) on retrouve les    |
| de          |    |           |     | emplacements Box référencés   |
| stination** |    |           |     | dans le noyau HEXAGONE (HXCH  |
|             |    |           |     | avec le champ chtype='B')     |
|             |    |           |     |                               |
|             |    |           |     | Si type Salle d'attente, on a |
|             |    |           |     | le code salle (sur 6          |
|             |    |           |     | positions) on retrouve les    |
|             |    |           |     | emplacements salle d'attente  |
|             |    |           |     | référencés dans le noyau      |
|             |    |           |     | HEXAGONE (HXCH avec le champ  |
|             |    |           |     | chtype='T')                   |
|             |    |           |     |                               |
|             |    |           |     | Si type plateaux technique,   |
|             |    |           |     | on peut avoir le code plateau |
|             |    |           |     | technique (sur 10 positions)  |
|             |    |           |     | référencé dans HEXAGONE       |
|             |    |           |     | (HXPLT). Mais attention la    |
|             |    |           |     | référence aux plateaux        |
|             |    |           |     | techniques n'est pas          |
|             |    |           |     | obligatoire dans HEXAGONE     |
|             |    |           |     | auquel cas ce champ est vide. |
+-------------+----+-----------+-----+-------------------------------+
| **N°        | *  | S         | N   | Si type d'emplacement Box, on |
| emplacement | *6 |           |     | a le n° de box (sur 1         |
| tem         | ** |           |     | position)                     |
| porairement |    |           |     |                               |
| de          |    |           |     | Si type d'emplacement Salle   |
| stination** |    |           |     | d'attente ce champ est vide.  |
|             |    |           |     |                               |
|             |    |           |     | Si type plateaux technique,   |
|             |    |           |     | on peut avoir le code de la   |
|             |    |           |     | salle d'examen (sur 6         |
|             |    |           |     | positions) référencé dans     |
|             |    |           |     | HEXAGONE (HXCHPLT). Mais      |
|             |    |           |     | attention la référence aux    |
|             |    |           |     | salles d'examen n'est pas     |
|             |    |           |     | obligatoire dans HEXAGONE     |
|             |    |           |     | auquel cas ce champ est vide. |
+-------------+----+-----------+-----+-------------------------------+
| **N° ordre  | *  | N         | O   | C'est un n° interne           |
| du          | *4 |           |     | permettant d'avoir une clé    |
| mouvement   | ** |           |     | unique dans HEXAGONE pour les |
| d'urgence** |    |           |     | mouvements d'urgences (part   |
|             |    |           |     | de 1 et on incrémente à       |
|             |    |           |     | chaque mouvement, attention   |
|             |    |           |     | quand le patient est          |
|             |    |           |     | hospitalisé le compteur de    |
|             |    |           |     | mouvement repart à 1 pour la  |
|             |    |           |     | séquence d'hospitalisation).  |
+-------------+----+-----------+-----+-------------------------------+
| **Ancienne  | ** | Date      | N   | Dans le cas de la             |
| date du     | 16 |           |     | modification ou la            |
| mouvement** | ** |           |     | suppression on aura           |
|             |    |           |     | l'ancienne date du mouvement  |
+-------------+----+-----------+-----+-------------------------------+

Ce message est envoyé à chaque fois que le patient sort d'un emplacement
temporaire.

-   ##   Actes

### Message d'envoi de la codification NGAP (Actes)

On envoie un message par code NGAP, Donc plusieurs messages par bon de
saisie. Les codes NGAP sont toujours présents, il est donc possible de
connaître l\'exhaustivité des actes en NGAP.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | MK                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | K1 (NGAP)                     |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn (nn=no       |
|             |    |           |     | ligne)                        |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | N° d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **No bon**  | ** | N         | O   | No de bon de saisie dans      |
|             | 10 |           |     | hexagone                      |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **P         | ** | S         | O   | HEXAGONE                      |
| rovenance** | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Produit** | ** | S         | O   | SERVACT                       |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **N° de la  | ** | S         | N   | No demande (Interne) généré   |
| demande**   | 10 |           |     | par le Service Echange        |
|             | ** |           |     | uniquement pour les retours   |
|             |    |           |     | d' actes en provenance de     |
|             |    |           |     | l'extérieur.                  |
+-------------+----+-----------+-----+-------------------------------+
| **Lettre    |    |           | O   | Codification NGAP             |
| clé**       |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **C         | *  | N         | N   | Codification NABM             |
| odification | *4 |           |     |                               |
| NABM**      | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Format de la date :           |
| l'acte**    | 14 | heure     |     |                               |
|             | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Nombre    | *  | 99        | N   | Si rien on prendra 1          |
| d'actes**   | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | 9999.99   | N   | Coefficient brut de l'acte.   |
| Coefficient | *7 |           |     | Si rien on prendra 1          |
| de l'acte** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **          |    |           | N   | A USAGE FUTUR.                |
| Coefficient |    |           |     |                               |
| majoré**    |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **M         | ** | S         | N   | (ex : ERF....) concaténation  |
| ajoration** | 26 |           |     | des codes circonstances       |
|             | ** |           |     | génériques des circonstances  |
|             |    |           |     | appliquées à cet acte dont la |
|             |    |           |     | correspondance se trouve dans |
|             |    |           |     | HVKCP.                        |
+-------------+----+-----------+-----+-------------------------------+
| **Uf        | *  | 9999      | N   |                               |
| d           | *4 |           |     |                               |
| emandeuse** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Uf        | *  | 9999      | O   |                               |
| pr          | *4 |           |     |                               |
| oductrice** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | N         | N   | No Finess du praticien du bon |
| Praticien** | *9 |           |     | (= null si pas de finess dans |
|             | ** |           |     | HRPRA).                       |
+-------------+----+-----------+-----+-------------------------------+
| **Acte      | ** | S         | N   |                               |
| nommé**     | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | =O si l'acte a été pratiqué   |
| *Libérale** | *1 |           |     | dans le cadre de l'activité   |
|             | ** |           |     | libérale.                     |
+-------------+----+-----------+-----+-------------------------------+
| **Gratuit** | *  | S         | N   | =0 Acte gratuit               |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Plateau   | ** | S         | N   | Code plateau technique        |
| technique** | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Salle     | *  | S         | N   | Code Salle d'examen           |
| d'examen**  | *6 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Appareil  | *  | S         | N   | Code Appareillage utilisé     |
| utilisé**   | *8 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

### Messages d'envoi de la codification CDAM (Actes)

On envoie un message par code *CDAM*, Donc plusieurs messages par bon de
saisie. Les messages en *CDAM* ne sont pas forcément disponibles pour
tous les actes (par exemple, *NABM*), et ils nécessite au préalable un
paramétrage des actes nommés dans le serveur d\'actes avec la
codification *CDAM*.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | MK                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | K2 (CDAM)                     |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn (où nn=no de |
|             |    |           |     | ligne pour gérer unicité)     |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | N° d'IPP                      |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **No bon**  | ** | N         | O   | No de bon de saisie dans      |
|             | 10 |           |     | hexagone                      |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **P         | ** | S         | O   | HEXAGONE                      |
| rovenance** | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Produit** | ** | S         | O   | SERVACT                       |
|             | 20 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **No de la  | ** | S         | N   | No de la demande (No Interne  |
| Demande**   | 10 |           |     | généré par le Serv.Echang /   |
|             | ** |           |     | uniquement pour les retours   |
|             |    |           |     | d'actes en provenance de      |
|             |    |           |     | l'exterieur)                  |
+-------------+----+-----------+-----+-------------------------------+
| **Code      | 4  | S         | O   | Code CDAM                     |
| CDAM**      |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | 14 | Date et   | O   | Format de la date             |
| l'acte**    |    | heure     |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Acte      | ** | S         | N   |                               |
| nommé**     | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

Attention

Lors de la mise en œuvre de la *CCAM*, un nouveau message K3 sera mis en
œuvre.

-   ## Examens

Les demandes d\'examens permettent de transmettre sous format HPRIM 1.2
ou 2.1, les demandes aux divers laboratoires, et d\'intégrer le retour
toujours sous ce même format HPRIM. Ces messages ne sont pas
transmissibles vers l\'extérieur.

### Demande d\'Examen (A1)

Evènements déclenchant l'émission de ce message:

Création d'une demande d\'examen: Lors de la validation d\'une demande
d\'examen, dans le module Unités de soins.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | DE = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création                      |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Poste**   | ** | S         | O   | Poste de travail sur lequel   |
|             | 16 |           |     | la demande a été saisie.      |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| **Individu  | ** | S         | O   | Individu au sens S3A qui a    |
| (émetteur   | 50 |           |     | généré le message.            |
| du          | ** |           |     |                               |
| message)**  |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Numéro de | ** | N         | O   | Numéro de la demande          |
| demande**   | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Loc       | ** | S         | O   | Localisation dans laquelle la |
| alisation** | 10 |           |     | demande a été saisie.         |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

# Messages Ressources Economiques et Financières

-   ## Marchés :

### Création d'un marché dans ELITE.S

Ces enregistrements sont uniquement envoyés par un logiciel de Gestion
de Marchés dans ELITE.S.

Les fournisseurs doivent obligatoirement exister dans Hexagone : si tel
n'est pas le cas, le marché sera rejeté.

#### Message 1 : Entête de Marché

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | MT : Marchés Transmis                 |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | Nom de l'émetteur ( ex : EPICURE)     |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | S    | O   | No de marché attribué par le logiciel |
| marché**   | *8 |      |     | émetteur .                            |
|            | ** |      |     |                                       |
|            |    |      |     | **ATTENTION dans** Elite.S : No sur 6 |
|            |    |      |     | en numérique avec les 2 premiers      |
|            |    |      |     | correspondants à l'exercice ( exemple |
|            |    |      |     | sur 2003, no 030001)                  |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Doit exister dans Hexagone            |
| fou        | *6 |      |     |                                       |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Raison   | ** | S    | O   | Doit exister dans Hexagone            |
| sociale**  | 35 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Doit exister dans les domiciliations  |
| banque**   | *5 |      |     | bancaires fournisseur                 |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Doit exister dans les domiciliations  |
| guichet**  | *5 |      |     | bancaires fournisseur                 |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No du    | ** | S    | O   | Doit exister dans les domiciliations  |
| compte     | 11 |      |     | bancaires fournisseur                 |
| bancaire** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Clé      | *  | N    | O   | Doit exister dans les domiciliations  |
| RIB**      | *2 |      |     | bancaires fournisseur                 |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Délai de | *  | N    | N   | Nombre de jours. Compris entre 001 et |
| Paiement** | *3 |      |     | 999                                   |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de lancement de la consultation  |
| Cons       | *8 |      |     | du marché. Format YYYYMMDD            |
| ultation** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de notification au titulaire.    |
| Noti       | *8 |      |     | Format YYYYMMDD                       |
| fication** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | Date | O   | Format YYYYMMDD                       |
| début de   | *8 |      |     |                                       |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| fin        | *8 |      |     |                                       |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Marché   | *  | S    | O   | T : pour marché alloti, F sinon       |
| alloti**   | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nbre de  | *  | N    | N   | Si marché alloti, donne le nombre de  |
| lots**     | *2 |      |     | lots associés                         |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Marché à | *  | S    | O   | Valeurs F pour Non, T pour Oui        |
| bon de     | *1 |      |     |                                       |
| commande** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Recon    | *  | S    | O   | Valeurs F pour Non, T pour Oui        |
| ductible** | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nbre de  | *  | N    | O   | Obligatoire sir code                  |
| recon      | *3 |      |     | « Reconductible » est à T. Compris    |
| ductions** | ** |      |     | entre 001 et 999.                     |
+------------+----+------+-----+---------------------------------------+
| **Gestion  | *  | S    | O   | Valeur F pour Non , T pour Oui.       |
| Interne**  | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **P        | *  | N    | N   | Décimalisé à 2.                       |
| ourcentage | *5 |      |     |                                       |
| maxi de    | ** |      |     |                                       |
| blocage**  |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | S    | O   | Permet d'identifier les contrôles     |
| marché**   | *1 |      |     | associés. Valeurs autorisées :        |
|            | ** |      |     |                                       |
|            |    |      |     | M : Mixte                             |
|            |    |      |     |                                       |
|            |    |      |     | C  : Négocié sans concurrence         |
|            |    |      |     |                                       |
|            |    |      |     | T  : Travaux                          |
|            |    |      |     |                                       |
|            |    |      |     | A : Article 30                        |
|            |    |      |     |                                       |
|            |    |      |     | U : Besoin unique                     |
|            |    |      |     |                                       |
|            |    |      |     | N : Autres                            |
+------------+----+------+-----+---------------------------------------+
| **Nature** | *  | S    | O   | Obligatoire si type = 'T' ( Travaux). |
|            | *1 |      |     | Valeurs autorisées :                  |
|            | ** |      |     |                                       |
|            |    |      |     | T : Opération de Travaux              |
|            |    |      |     |                                       |
|            |    |      |     | O : Ouvrage                           |
|            |    |      |     |                                       |
|            |    |      |     | Si type de marché différent de 'T' :  |
|            |    |      |     | valeur N                              |
+------------+----+------+-----+---------------------------------------+
| **Code CMP | ** | S    | F   | Obligatoire si type marché = 'M'.     |
| dominant** | 10 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | S    | O   | T si marché dans le cadre d'un        |
| Groupement | *1 |      |     | groupement d'achat, F si marché       |
| d'achat**  | ** |      |     | propre à l'établissement.             |
+------------+----+------+-----+---------------------------------------+
| **Taux des | *  | N    | F   | Numérique décimalisé à 2. Taux        |
| Intérêts   | *5 |      |     | spécifique pour le marché             |
| mo         | ** |      |     |                                       |
| ratoires** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

Remarque

Si le marché porte sur plusieurs fournisseurs, on aura autant
d'enregistrements que de fournisseurs différents avec le même numéro de
marché.

#### Message 2 : Lignes de Marché transmises

Si le code produit et le compte n'existe pas, la procédure de génération
de marchés dans ELITE.S permettra la saisie sur ces lignes d'un code
produit ou d'un compte (hors consommables). Le produit doit alors avoir
été créé dans Hexagone, pour pouvoir être associé à la ligne de marché.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | MT : Marchés Transmis                 |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M2                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | Nom de l'émetteur : (Ex EPICURE)      |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | S    | O   | No de marché attribué par le logiciel |
| marché**   | *8 |      |     | émetteur                              |
|            | ** |      |     |                                       |
|            |    |      |     | **ATTENTION dans** Elite.S : No sur 6 |
|            |    |      |     | en numérique avec les 2 premiers      |
|            |    |      |     | correspondants à l'exercice ( exemple |
|            |    |      |     | sur 2003, no 030001)                  |
+------------+----+------+-----+---------------------------------------+
| **No ligne | *  | N    | O   | No de ligne                           |
| de         | *3 |      |     |                                       |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Obligatoire si marché alloti          |
| lot**      | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | S    |     | N pour normal, U pour marché de type  |
| besoin**   | *1 |      |     | besoin unique. Cette valeur est       |
|            | ** |      |     | associée au lot                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Obligatoirement renseigné si ligne    |
| produit**  | *8 |      |     | sur produit                           |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | N   | Obligatoirement renseigné si ligne    |
| ord        | 10 |      |     | sur compte (marché hors consommables) |
| onnateur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | N   | Quantité minimum pour les marchés à   |
| minimum    | 14 |      |     | bon de commande Décimalisée à 3       |
| retenue**  | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | N   | Quantité moyenne. Décimalisée à 3.    |
| moyenne**  | 14 |      |     | Non utilisée dans ELITE               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | N   | Quantité maximum pour les marchés à   |
| maximum    | 14 |      |     | bon de commande Décimalisée à 3. Non  |
| retenue**  | ** |      |     | utilisée dans ELITE                   |
+------------+----+------+-----+---------------------------------------+
| **PU Hors  | ** | N    | N   | Prix unitaire Hors taxe ligne         |
| taxe**     | 13 |      |     | Décimalisé à 4                        |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | Date | N   | Date de révision éventuelle du prix   |
| révision   | *8 |      |     | format YYYYMMDD                       |
| prix**     | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Taux de  | *  | N    | O   | Le taux de TVA est obligatoire. Il    |
| TVA        | *5 |      |     | doit exister dans les tables          |
| ligne**    | ** |      |     | d'HEXAGONE Décimalisé à 2             |
+------------+----+------+-----+---------------------------------------+
| **Taux     | *  | N    | N   | Si un taux est indiqué, le taux de    |
| Taxe       | *5 |      |     | TVA+le taux de Taxe doit exister sans |
| supplé     | ** |      |     | les tables des taux Hexagone.         |
| mentaire** |    |      |     | Décimalisé à 2                        |
+------------+----+------+-----+---------------------------------------+
| **D        | ** | S    | O   | Désignation de la ligne               |
| ésignation | 70 |      |     |                                       |
| ligne**    | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | O   | Obligatoire code nomenclature du      |
| CMP**      | 10 |      |     | nouveau code des marchés publics.     |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | N   | Décimalisée à 3. Permettra            |
| minimum    | 14 |      |     | d'alimenter le lien                   |
| livrable** | ** |      |     | produit/fournisseur si information    |
|            |    |      |     | présente                              |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | N   | Décimalisée à 3.                      |
| unités     | 14 |      |     |                                       |
| g          | ** |      |     |                                       |
| ratuites** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Obligatoire si quantité unités        |
| Interne ou | *1 |      |     | gratuites renseignée. Valeur I si la  |
| Externe**  | ** |      |     | quantité gratuite est comprise dans   |
|            |    |      |     | la quantité négociée. Valeur E si la  |
|            |    |      |     | quantité gratuite non comprise dans   |
|            |    |      |     | la quantité négociée.                 |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Quantité négociée sur la ligne.       |
| négociée** | 14 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

-   ### Transmission des consommations des produits 

Ces enregistrements sont uniquement envoyés par ELITE.S pour un logiciel
extérieur.

Ces messages sont notamment destinés à alimenter les logiciels de
gestion des marchés avec les consommations des produits stockés
constatées dans Hexagone, pour un magasin donné, sur une période donnée.

#### Message 1 : Consommations par produit

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | MC : Consommations des produits       |
|            |    |      |     | stockés                               |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF       | *  | N    | O   | Code UF magasin sélectionné lors de   |
| Magasin**  | *4 |      |     | l'extraction                          |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code du produit dans HEXAGONE         |
| produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Libellé  | ** | S    | O   | Libellé du produit dans Hexagone      |
| produit**  | 40 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Unité de | *  | S    | O   | Ex : BTE, CP, UN ; CARTON . Dans      |
| gestion**  | *5 |      |     | Hexagone table de paramétrage propre  |
|            | ** |      |     | au site.                              |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Décimalisée à 3.                      |
| consommée  | 14 |      |     |                                       |
| sur la     | ** |      |     |                                       |
| période**  |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nombre   | *  | N    | O   | Nombre de mois sélectionné lors de    |
| de mois    | *2 |      |     | l'extraction                          |
| d'hi       | ** |      |     |                                       |
| storique** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Si marché en cours sur ce produit     |
| f          | *6 |      |     | lors de l'extraction, le code         |
| ournisseur | ** |      |     | fournisseur est transmis. C'est le    |
| du         |    |      |     | code Hexagone                         |
| marché**   |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Raison   | ** | S    | N   | Raison sociale du fournisseur du      |
| sociale**  | 35 |      |     | marché                                |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **PU HT du | ** | N    | N   | Prix unitaire du marché, Décimalisé   |
| produit**  | 13 |      |     | en 4.                                 |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

##  Marchés validés dans ELITE.S:

### Création d'un marché 

Les marchés peuvent être uniquement envoyés d'ELITE.S vers un autre
destinataire.

#### 

#### Message 1 : Entête de Marché

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | MA : Marchés                          |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | N    | O   | Exercice comptable de saisie          |
| Exercice** | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de marché attribué par             |
| marché**   | *6 |      |     | l'établissement                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code du  | *  | S    | O   | Code Hexagone du fournisseur          |
| t          | *6 |      |     | titulaire du marché                   |
| itulaire** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | Numéro de domiciliation bancaire du   |
| dom        | *3 |      |     | titulaire. Pour règlement.            |
| iciliation | ** |      |     |                                       |
| bancaire** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Délai de | *  | N    | F   | Nombre de jours. Compris entre 001 et |
| Paiement** | *3 |      |     | 999                                   |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de lancement de la consultation  |
| Cons       | *8 |      |     | du marché. Format YYYYMMDD            |
| ultation** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de notification au titulaire.    |
| Noti       | *8 |      |     | Format YYYYMMDD                       |
| fication** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | Date | O   | Format YYYYMMDD                       |
| début de   | *8 |      |     |                                       |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| fin        | *8 |      |     |                                       |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Marché   | *  | S    | O   | T : pour marché alloti, F sinon       |
| alloti**   | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nbre de  | *  | N    | F   | Si marché alloti, donne le nombre de  |
| lots**     | *2 |      |     | lots associés                         |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Multi    | *  | S    | O   | O : si marché multi fournisseur, N si |
| four       | *1 |      |     | mono fournisseur                      |
| nisseurs** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Montant Initial TTC marché (          |
| Initial**  | 15 |      |     | décimalisé à 2)                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Montant cumulé des avenants (         |
| avenants** | 15 |      |     | décimalisé à 2)                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **A bon de | *  | S    | O   | Valeurs F pour Non, T pour Oui        |
| cde**      | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Recon    | *  | S    | O   | Valeurs F pour Non, T pour Oui        |
| ductible** | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nbre de  | *  | N    | O   | Obligatoire sir code                  |
| recon      | *3 |      |     | « Reconductible » est à T. Compris    |
| ductions** | ** |      |     | entre 001 et 999.                     |
+------------+----+------+-----+---------------------------------------+
| **Gestion  | *  | S    | O   | Valeur F pour Non , T pour Oui.       |
| Interne**  | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **P        | *  | N    | N   | Décimalisé à 2.                       |
| ourcentage | *5 |      |     |                                       |
| maxi de    | ** |      |     |                                       |
| blocage**  |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | S    | O   | Permet d'identifier les contrôles     |
| marché**   | *1 |      |     | associés. Valeurs autorisées :        |
|            | ** |      |     |                                       |
|            |    |      |     | M : Mixte                             |
|            |    |      |     |                                       |
|            |    |      |     | C  : Négocié sans concurrence         |
|            |    |      |     |                                       |
|            |    |      |     | T  : Travaux                          |
|            |    |      |     |                                       |
|            |    |      |     | A : Article 30                        |
|            |    |      |     |                                       |
|            |    |      |     | N : Autres                            |
+------------+----+------+-----+---------------------------------------+
| **Nature** | *  | S    | O   | Obligatoire si type = 'T' ( Travaux). |
|            | *1 |      |     | Valeurs autorisées :                  |
|            | ** |      |     |                                       |
|            |    |      |     | T : Opération de Travaux              |
|            |    |      |     |                                       |
|            |    |      |     | O : Ouvrage                           |
|            |    |      |     |                                       |
|            |    |      |     | Si type de marché différent de 'T' :  |
|            |    |      |     | valeur N                              |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | F   | Obligatoire si type marché = 'M'.     |
| CMP**      | 10 |      |     | Code nomenclature cadre des marchés   |
|            | ** |      |     | publics                               |
+------------+----+------+-----+---------------------------------------+
| **         | *  | S    | O   | T si marché dans le cadre d'un        |
| Groupement | *1 |      |     | groupement d'achat, F si marché       |
| d'achat**  | ** |      |     | propre à l'établissement.             |
+------------+----+------+-----+---------------------------------------+
| **Taux des | *  | N    | F   | Numérique décimalisé à 2. Taux        |
| Intérêts   | *5 |      |     | spécifique pour le marché             |
| mo         | ** |      |     |                                       |
| ratoires** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Lignes de Marché

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | MA : Marchés                          |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M2                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de marché attribué par             |
| marché**   | *6 |      |     | l'établissement                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No ligne | *  | N    | O   | No de ligne                           |
| de         | *3 |      |     |                                       |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Obligatoire si marché alloti          |
| lot**      | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | S    |     | N pour normal, U pour marché de type  |
| besoin**   | *1 |      |     | besoin unique. Cette valeur est       |
|            | ** |      |     | associée au lot                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Obligatoirement renseigné si ligne    |
| produit**  | *8 |      |     | sur produit                           |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | N   | Obligatoirement renseigné si ligne    |
| ord        | 10 |      |     | sur compte (sans produit)             |
| onnateur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Qté      | ** | N    | N   | Quantité initiale ligne de marché     |
| initiale** | 14 |      |     | Décimalisée à 3                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **PU Hors  | ** | N    | N   | Prix unitaire Hors taxe ligne         |
| taxe**     | 13 |      |     | Décimalisé à 4                        |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | Date | N   | Date de révision éventuelle du prix   |
| révision   | *8 |      |     | format YYYYMMDD                       |
| prix**     | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code TVA | *  | N    | N   | Code TVA à appliquer sur la ligne.    |
| ligne**    | *2 |      |     | Code Hexagone, doit exister dans      |
|            | ** |      |     | HXTVA                                 |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | N   | Montant TTC ligne. Décimalisé à 2     |
| TTC        | 15 |      |     |                                       |
| ligne**    | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **D        | ** | S    | O   | Désignation de la ligne               |
| ésignation | 40 |      |     |                                       |
| ligne**    | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | O   | Obligatoire code nomenclature du      |
| CMP**      | 10 |      |     | nouveau code des marchés publics.     |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 3 : Fournisseurs par marché

Uniquement si marché multi fournisseurs et/ou marché alloti

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | MA : Marchés                          |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M3                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de marché attribué par             |
| marché**   | *6 |      |     | l'établissement                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de lot associé au fournisseur      |
| lot**      | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code fournisseur Hexagone associé     |
| fou        | *6 |      |     |                                       |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de domiciliation bancaire du       |
| dom        | *2 |      |     | fournisseur, pour gestion des         |
| iciliation | ** |      |     | règlements.                           |
| bancaire** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | Date | O   | Format YYYYMMDD                       |
| début**    | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| fin**      | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

-   ### Modification de Marché

Mêmes messages que les messages de création dès qu'une information est
modifiée avec un mode « MODIFICATION »

-   ### Suppression De Marché :

#### Message 1 : Arrêt d'un marché

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | MA : Marchés                          |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Suppression                           |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de marché attribué par             |
| marché**   | *6 |      |     | l'établissement                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | O : pour marché clôturé               |
| clôturée** | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Arrêt d'une ligne de marché

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | MA : Marchés                          |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M2                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Suppression                           |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de marché attribué par             |
| marché**   | *6 |      |     | l'établissement                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No ligne | *  | N    | O   | No de ligne clôturée.                 |
| marché**   | *3 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Obligatoirement renseigné si ligne    |
| produit**  | *8 |      |     | sur produit                           |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | N   | Obligatoirement renseigné si ligne    |
| ord        | 10 |      |     | sur compte                            |
| onnateur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | O   | Obligatoire code nomenclature du      |
| CMP**      | 10 |      |     | nouveau code des marchés publics.     |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Obligatoire si marché alloti          |
| lot**      | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | O : pour ligne de marché clôturée     |
| clôturée** | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

-   ## Demandes d'approvisionnements :

### Création d'une demande 

Les demandes sont envoyées d'un destinataire vers ELITE.S . Elles
permettent de générer des commandes après contrôles dans *GREF*. Les
commandes générées dans *GREF* pourront alors être récupérées par
l'émetteur de la demande.

#### Message 1 : Entête de demande d'approvisionnement

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | DA : Demandes d'approvisionnements    |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | DE                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | NOM EMETTEUR                          |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| demande**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | N    | O   | No de la demande propre à l'émetteur  |
| demande**  | 10 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF de    | *  | N    | O   | Code UF de gestion de la commande     |
| gestion**  | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code fournisseur Hexagone de la       |
| Fou        | *6 |      |     | commande.                             |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Point de commande sur lequel on doit  |
| point de   | *2 |      |     | générer la commande. Par défaut la    |
| commande** | ** |      |     | valeur est 01                         |
+------------+----+------+-----+---------------------------------------+
| **Objet    | ** | S    | N   | Objet de demande                      |
| demande**  | 40 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | N   | Date de livraison souhaitée. Doit     |
| l          | *8 |      |     | être supérieure ou égale à la date de |
| ivraison** | ** |      |     | demande. Format YYYYMMDD              |
+------------+----+------+-----+---------------------------------------+
| **Nature   | *  | S    | O   | P : demande sur produits, C : demande |
| commande** | *1 |      |     | sur comptes.                          |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code à   | *  | S    | O   | O si type de demande Produits ou      |
| Réce       | *1 |      |     | Compte à réceptionner dans ELITE      |
| ptionner** | ** |      |     | (donc saisie d'une livraison avant la |
|            |    |      |     | facture)                              |
|            |    |      |     |                                       |
|            |    |      |     | N : Si demande sur compte sans saisie |
|            |    |      |     | obligatoire de réception.             |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | S    | O   | Permet d'identifier les cas           |
| demande**  | *1 |      |     | particuliers pour le CMP :            |
|            | ** |      |     |                                       |
|            |    |      |     | N : demande Normale                   |
|            |    |      |     |                                       |
|            |    |      |     | T : demande de travaux                |
|            |    |      |     |                                       |
|            |    |      |     | U : demande de type Besoin unique     |
+------------+----+------+-----+---------------------------------------+
| **Exercice | *  | N    | O   | Exercice comptable d'imputation des   |
| d'im       | *4 |      |     | engagements                           |
| putation** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Lignes de demande d'approvisionnement externe

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | DA : Demandes d'approvisionnements .  |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | DL                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | NOM EMETTEUR                          |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| demande**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   |                                       |
| demande**  | 10 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de demande : 001 à 999    |
| ligne**    | *3 |      |     | maximum.                              |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Obligatoire si demande de type        |
| produit**  | *8 |      |     | Produits, Vide sinon. Code produit    |
|            | ** |      |     | d'Hexagone                            |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | O   | Obligatoire si demande de type        |
| ord        | 10 |      |     | Comptes : Format Lettre budget + No   |
| onnateur** | ** |      |     | de compte                             |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Obligatoire si l'établissement gère   |
| Marché**   | *6 |      |     | les marchés : indiquer le numéro de   |
|            | ** |      |     | marché hexagone .Sinon mettre 0       |
+------------+----+------+-----+---------------------------------------+
| **No ligne | *  | N    | N   | Obligatoire si No de marché renseigné |
| marché**   | *3 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Obligatoire si marché renseigné et    |
| lot        | *2 |      |     | marché géré avec des lots.            |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Décimalisée à 3. Quantité \> 0, si    |
| demandée** | 14 |      |     | ligne produit doit être exprimée dans |
|            | ** |      |     | l'unité de gestion associée au        |
|            |    |      |     | message 4 du produit                  |
+------------+----+------+-----+---------------------------------------+
| **PU Hors  | ** | N    | N   | **Obligatoire pour demande sur        |
| taxe**     | 13 |      |     | compte**. Décimalisé à 4.             |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | N   | **Obligatoire pour demande sur        |
| Hors       | 16 |      |     | compte**. Montant ligne en Hors taxe. |
| taxe**     | ** |      |     | Décimalisé à 2                        |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | N   | **Obligatoire pour demande sur        |
| TVA**      | *2 |      |     | compte**. Code TVA appliqué à la      |
|            | ** |      |     | ligne. Le code donne le taux associé  |
|            |    |      |     | dans HEXAGONE. Doit exister dans      |
|            |    |      |     | HXTVA                                 |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | O   | Obligatoire si produit et/ou commande |
| CMP**      | 10 |      |     | service                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | N   | Envoyer un numéro de projet géré dans |
| projet**   | *6 |      |     | Hexagone.                             |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Ligne de | *  | S    | N   | Ligne de texte associée à la demande  |
| texte 1**  | *2 |      |     | destinée au fournisseur               |
|            | 56 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Ligne de | *  | S    | N   | Suite de la ligne de texte 1          |
| texte 2**  | *2 |      |     |                                       |
|            | 56 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | T pour Oui, F pour Non.               |
| Dépense    | *1 |      |     |                                       |
| Impr       | ** |      |     | Plus utilisé à partir de la version   |
| évisible** |    |      |     | D.02                                  |
+------------+----+------+-----+---------------------------------------+

Les demandes envoyées sont considérées comme valides.

La modification ou suppression d'une demande implique la suppression ou
modification de la commande dans ELITE.S qui renvoie les modifications
ou suppression de commande.

-   ## Commandes :

### Création d'une commande 

Les commandes sont envoyées d'ELITE.S vers un autre destinataire.

#### Message 1 : Entête de commande

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | CO : Commande                         |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | CE                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | N    | O   | Exercice comptable d'imputation de la |
| Exercice** | *4 |      |     | commande                              |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de commande d'ELITE.S              |
| commande   | *8 |      |     |                                       |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de demande de l'émetteur si        |
| demande**  | 10 |      |     | commande générée à partir d'une       |
|            | ** |      |     | demande externe                       |
+------------+----+------+-----+---------------------------------------+
| **Nom      | ** | S    | N   | Renseigné si commande générée par une |
| émetteur   | 15 |      |     | demande externe.                      |
| dde**      | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF de    | *  | N    | O   | Code UF de gestion de la commande     |
| gestion**  | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code fournisseur de la commande.      |
| Fou        | *6 |      |     |                                       |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Point de commande auquel on destine   |
| point de   | *2 |      |     | la commande.                          |
| commande** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Objet    | ** | S    | N   | Objet de commande                     |
| commande** | 40 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| commande** | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | N   | Date de livraison. Format YYYYMMDD    |
| l          | *8 |      |     |                                       |
| ivraison** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Correspond au cumul TTC des lignes de |
| TTC de la  | 16 |      |     | commande associées. Décimalisé à 2.   |
| commande** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nature   | *  | S    | O   | P : commande sur produits,            |
| commande** | *1 |      |     |                                       |
|            | ** |      |     | C : commande sur comptes.             |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code lieu de livraison.               |
| lieu de    | *8 |      |     |                                       |
| l          | ** |      |     |                                       |
| ivraison** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code lieu de facturation              |
| lieu de    | *8 |      |     |                                       |
| fac        | ** |      |     |                                       |
| turation** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Obse     | *  | S    | N   | Zone d'observations destinées au      |
| rvations** | *1 |      |     | fournisseur                           |
|            | 00 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code à   | *  | S    | O   | Valeurs transmises :                  |
| Réce       | *1 |      |     |                                       |
| ptionner** | ** |      |     | O si type de commande Produits ou     |
|            |    |      |     | Compte à réceptionner (donc saisie    |
|            |    |      |     | d'une livraison avant la facture)     |
|            |    |      |     |                                       |
|            |    |      |     | N : Si commande sur compte sans       |
|            |    |      |     | saisie obligatoire de réception.      |
+------------+----+------+-----+---------------------------------------+
| **Code à   | *  | S    | O   | Commande à faxer par HEXAGONE : T     |
| Faxer**    | *1 |      |     | pour Oui, F pour Non                  |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | S    | O   | Permet d'identifier les cas           |
| Commande** | *1 |      |     | particuliers pour le CMP :            |
|            | ** |      |     |                                       |
|            |    |      |     | T : Commande de travaux               |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Générée par bordereau de livraison    |
| générée    | *1 |      |     | O(Oui) / N(Non)                       |
| O/N**      | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Raison   | ** | S    | O   | Raison sociale du fournisseur         |
| sociale    | 40 |      |     |                                       |
| Four**     | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No Fax** | ** | S    | F   | No de Fax du point de commande        |
|            | 16 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | F   | Code identifiant fournisseur pour EDI |
| robot      | *5 |      |     |                                       |
| EDI**      | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Envoi    | *  | S    | O   | Code commande transmise par EDI : T   |
| EDI**      | *1 |      |     | pour Vrai, F pour Faux                |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | S    | O   | Code déjà transférée EDI : T pour     |
| Transférée | *1 |      |     | vrai, F pour Faux                     |
| EDI**      | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | N   | Renseigné si transfert EDI déjà fait. |
| transfert  | 50 |      |     | Référence de l'utilisateur ayant      |
| EDI**      | ** |      |     | lancé le transfert EDI.               |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Lignes de commande

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | CO : Commande.                        |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | CL                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | N    | O   | Exercice comptable d'imputation de la |
| Exercice** | *4 |      |     | commande                              |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | O   | No de commande d'ELITE.S              |
| Commande   | *8 |      |     |                                       |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de commande : 001 à 999   |
| ligne      | *3 |      |     | maximum.                              |
| cde**      | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Obligatoire si Commande de type       |
| produit**  | *8 |      |     | Produits, Vide si commande de type    |
|            | ** |      |     | Comptes. Code Hexagone                |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | O   | Obligatoire si Commande de type       |
| ord        | 10 |      |     | Comptes : Format Lettre budget + No   |
| onnateur** | ** |      |     | de compte                             |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Obligatoire si l'établissement gère   |
| Marché**   | *6 |      |     | les marchés : numéro de marché        |
|            | ** |      |     | hexagone                              |
+------------+----+------+-----+---------------------------------------+
| **No ligne | *  | N    | N   | Obligatoire si No de marché renseigné |
| marché**   | *3 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Obligatoire si marché renseigné et    |
| lot        | *2 |      |     | marché géré avec des lots.            |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF       | *  | N    | O   | UF d'engagement comptable.            |
| d'en       | *4 |      |     |                                       |
| gagement** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Décimalisée à 3. Quantité \> 0, pour  |
| c          | 14 |      |     | ligne produit est exprimée dans       |
| ommandée** | ** |      |     | l'unité de conditionnement            |
|            |    |      |     | fournisseur                           |
+------------+----+------+-----+---------------------------------------+
| **PU Hors  | ** | N    | O   | Décimalisé à 4.                       |
| taxe**     | 13 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Montant ligne en Hors taxe.           |
| Hors       | 16 |      |     | Décimalisé à 2                        |
| taxe**     | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **P        | *  | N    | N   | Pourcentage de remise appliqué sur le |
| ourcentage | *5 |      |     | Hors taxe. Décimalisé à 2             |
| de         | ** |      |     |                                       |
| remise**   |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Code TVA appliqué à la ligne.         |
| TVA**      | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Montant TTC de la ligne après calcul  |
| TTC        | 16 |      |     | de la remise et de la TVA. Décimalisé |
| Ligne**    | ** |      |     | à 2                                   |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | O   | Obligatoire si produit et/ou commande |
| CMP**      | 10 |      |     | service                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | N   |                                       |
| projet**   | *6 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Ligne de | *  | S    | N   | Ligne de texte associée à la commande |
| texte 1**  | *2 |      |     | destinée au fournisseur               |
|            | 56 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Ligne de | *  | S    | N   | Suite de la ligne de texte 1          |
| texte 2**  | *2 |      |     |                                       |
|            | 56 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | T pour Oui, F pour Non.               |
| Dépense    | *1 |      |     |                                       |
| Impr       | ** |      |     |                                       |
| évisible** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Libellé  | *  | S    | N   | Renseigné si code produit présent     |
| long       | *1 |      |     |                                       |
| produit**  | 50 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type     | *  | D    | N   | Type de produit : MED = Médicament    |
| produit**  | *3 |      |     |                                       |
|            | ** |      |     | MAT = Matériel Médical                |
|            |    |      |     |                                       |
|            |    |      |     | DM = Dispositif Médical               |
|            |    |      |     |                                       |
|            |    |      |     | FIL = Film Radiologie                 |
|            |    |      |     |                                       |
|            |    |      |     | PCO = Produits de contraste           |
|            |    |      |     |                                       |
|            |    |      |     | Champ vide pour autres produits.      |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | N   | Envoyé si champ renseigné dans la     |
| UCD**      | *7 |      |     | fiche produit                         |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Décimalisée à 3. Quantité \> 0, pour  |
| en unité   | 14 |      |     | ligne produit est exprimée dans       |
| de         | ** |      |     | l'unité de gestion du produit dans    |
| gestion**  |    |      |     | l'établissement                       |
+------------+----+------+-----+---------------------------------------+

-   ### Modification de Commande

Mêmes messages que les messages de création dès qu'une information est
modifiée avec un mode « MODIFICATION »

-   ### Suppression de Commande :

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | CO : Commande                         |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | CL                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Suppression                           |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | N    | O   | Exercice comptable d'imputation de la |
| Exercice** | *4 |      |     | commande                              |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | Si émetteur = HEXAGONE : No de        |
| commande   | *8 |      |     | commande d'ELITE.S                    |
| Hexagone** | ** |      |     |                                       |
|            |    |      |     | Sinon : 0                             |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de commande : 001 à 999   |
| ligne      | *3 |      |     | maximum.                              |
| annulée**  | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Obligatoire si Commande de type       |
| produit**  | *8 |      |     | Produits, Vide si commande de type    |
|            | ** |      |     | Comptes. Code Hexagone                |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | O   | Obligatoire si Commande de type       |
| ord        | 10 |      |     | Comptes : Format Lettre budget + No   |
| onnateur** | ** |      |     | de compte                             |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Décimalisée à 3. Quantité \> 0, si    |
| commandée  | 14 |      |     | ligne produit doit être exprimée dans |
| annulée**  | ** |      |     | l'unité de gestion associée au        |
|            |    |      |     | message 4 du produit                  |
+------------+----+------+-----+---------------------------------------+

-   ## Livraisons provenant de l'extérieur :

### Création d'une livraison externe

Elles sont envoyées par un autre émetteur dans ELITE.S, le nom de
l'émetteur doit être renseigné et il sera stocké dans la réception
ELITE.S qui sera générée si tous les contrôles sont corrects.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | LI : Livraisons externes              |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | NOM EMETTEUR                          |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| l          | *8 |      |     |                                       |
| ivraison** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de réception de l'émetteur         |
| réception  | 10 |      |     |                                       |
| de         | ** |      |     |                                       |
| l'         |    |      |     |                                       |
| émetteur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de commande de l'émetteur          |
| commande   | 10 |      |     |                                       |
| de         | ** |      |     |                                       |
| l'         |    |      |     |                                       |
| émetteur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | A préciser si la commande a déjà été  |
| commande   | *8 |      |     | générée dans ELITE.s                  |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de commande : 001 à 999   |
| ligne cde  | *3 |      |     | maximum. Permet de faire le lien avec |
| Hexagone** | ** |      |     | le numéro de ligne de commande        |
|            |    |      |     | associée la ligne de livraison        |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | N   | No du BL du fournisseur               |
| Bordereau  | 10 |      |     |                                       |
| de         | ** |      |     |                                       |
| l          |    |      |     |                                       |
| ivraison** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Fournisseur Hexagone effectuant la    |
| fou        | *6 |      |     | livraison                             |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF       | *  | N    | O   | Doit exister dans Hexagone et être    |
| magasin de | *4 |      |     | associée comme UF magasin principale  |
| r          | ** |      |     | sur les produits                      |
| éception** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | **Obligatoire** si ligne sur produit  |
| produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | N   | **Obligatoire** si ligne sur compte   |
| ord        | 10 |      |     |                                       |
| onnateur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Décimalisée à 3. Quantité \> 0, doit  |
| livrée**   | 14 |      |     | être exprimée dans l'unité de gestion |
|            | ** |      |     | de stock du magasin. (CF message 4 du |
|            |    |      |     | produit )                             |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Valeurs autorisées : O pour Oui, N    |
| ligne de   | *1 |      |     | pour Non. Valeur à O permet de savoir |
| cde        | ** |      |     | si la ligne de commande est soldée en |
| soldée**   |    |      |     | livraison (cas ou la quantité livrée  |
|            |    |      |     | est strictement inférieure à la       |
|            |    |      |     | quantité commandée et pas de          |
|            |    |      |     | livraison du solde prévue).           |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | N   | Uniquement renseigné si ligne porte   |
| Marché**   | *6 |      |     | sur un marché                         |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No Lot** | *  | N    | N   | Uniquement si marché alloti           |
|            | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | O   | Obligatoire si produit et/ou commande |
| CMP**      | 10 |      |     | service                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | N   | Numéro de projet si gestion des       |
| projet**   | *6 |      |     | projets dans ELITE.S                  |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | T pour Oui, F pour Non                |
| Dépense    | *1 |      |     |                                       |
| Impr       | ** |      |     |                                       |
| évisible** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Point de | *  | N    | N   | Peut être renseigné si réception sans |
| cde        | *2 |      |     | référence à une commande Hexagone.    |
| Four.**    | ** |      |     | Sera utilisé pour générer la          |
|            |    |      |     | commande.                             |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | No de ligne du marché : Obligatoire   |
| ligne      | *8 |      |     | si no de marché transmis              |
| Marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Lignes de Livraison sur produit avec gestion de lot

Ces messages ne sont reçus que pour les lignes de produits ayant un code
Gestion des lots et date de péremption positionné à T. La gestion des
lots n'est pas implémentée dans ELITE.S pour les versions en cours. Ces
messages seront traitées dès que le fonctionnel associé sera géré.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | LI : Livraisons externes              |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M2                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | NOM EMETTEUR                          |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| l          | *8 |      |     |                                       |
| ivraison** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de réception de l'émetteur         |
| réception  | 10 |      |     |                                       |
| de         | ** |      |     |                                       |
| l'         |    |      |     |                                       |
| émetteur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de commande de l'émetteur          |
| commande   | 10 |      |     |                                       |
| de         | ** |      |     |                                       |
| l'         |    |      |     |                                       |
| émetteur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | Si la commande a déjà été générée     |
| commande   | *8 |      |     | dans ELITE.s                          |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de commande : 001 à 999   |
| ligne cde  | *3 |      |     | maximum. Permet de faire le lien avec |
| Hexagone** | ** |      |     | le numéro de ligne de commande        |
|            |    |      |     | associée la ligne de livraison        |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code produit Hexagone concerné        |
| produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No du lot                             |
| lot**      | 12 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de péremption du lot reçu        |
| pé         | *8 |      |     |                                       |
| remption** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Le total des lignes par produit doit  |
| reçue**    | 14 |      |     | être égal à la quantité totale reçue. |
|            | ** |      |     | Décimalisée à 3. Quantité \> 0        |
+------------+----+------+-----+---------------------------------------+

-   ### Modification de lignes de Livraison

Mêmes messages que les message de création dès qu'une ligne est modifiée
avec un code mode à « M » pour « MODIFICATION »

Pour des rectifications de quantités envoyer la nouvelle valeur à
prendre en compte.

Pour une remise à zéro d'une ligne mettre la quantité à zéro. Attention
au code' ligne de commande soldée'

-   Si
    code = O la ligne de commande sera considérée dans GREF comme soldée
    en livraison et donc ne pourra plus être associée a une autre
    réception.

-   Si
    code = N La ligne de commande reste en attente de livraison pour la
    différence entre la quantité commandée et le cumul des quantités
    livrées (si ce cumul est inférieur à la quantité en commande).

    -   ## Réceptions :

### Création d'une réception

Les réceptions sont envoyées d'ELITE.S vers un autre destinataire.

#### Message 1 : Lignes de Réception

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | RO : Réceptions                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     | YYYYMMDDHHMISSnn                      |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Exercice | *  | N    | O   | Exercice comptable d'imputation       |
| c          | *4 |      |     |                                       |
| omptable** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | O   | No de réception d'ELITE.S             |
| réception  | *8 |      |     |                                       |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | N   | Si réception générée par une          |
| réception  | 10 |      |     | livraison externe, alimenté avec le   |
| de         | ** |      |     | numéro transmis par l'expéditeur      |
| l'ex       |    |      |     |                                       |
| péditeur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | N   | Si réception générée par une          |
| ex         | 15 |      |     | livraison externe, alimenté avec la   |
| péditeur** | ** |      |     | référence transmise dans le message   |
|            |    |      |     | de l'expéditeur                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de réception : 001 à 999  |
| ligne      | *3 |      |     | maximum.                              |
| r          | ** |      |     |                                       |
| éception** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | S    | O   | Permet d'identifier les cas           |
| R          | *1 |      |     | particuliers pour le CMP :            |
| éception** | ** |      |     |                                       |
|            |    |      |     | N : Réception Normale                 |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de commande d'ELITE.S associé à la |
| commande   | *8 |      |     | réception                             |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de commande : 001 à 999   |
| ligne      | *3 |      |     | maximum.                              |
| cde**      | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | N   | No du BL du fournisseur               |
| Bordereau  | 10 |      |     |                                       |
| de         | ** |      |     |                                       |
| l          |    |      |     |                                       |
| ivraison** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Fournisseur Hexagone effectuant la    |
| fou        | *6 |      |     | livraison                             |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD                       |
| l          | *8 |      |     |                                       |
| ivraison** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF       | *  | N    | O   | Doit exister dans Hexagone et être    |
| magasin de | *4 |      |     | associée comme UF magasin principale  |
| r          | ** |      |     | sur les produits                      |
| éception** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | **Obligatoire** si ligne sur produit  |
| produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | N   | **Obligatoire** si ligne sur compte   |
| ord        | 10 |      |     |                                       |
| onnateur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Décimalisée à 3. Quantité \> 0, est   |
| livrée**   | 14 |      |     | exprimée dans l'unité de gestion de   |
|            | ** |      |     | stock du magasin. (CF message 4 du    |
|            |    |      |     | produit)                              |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Valeurs autorisées : O pour Oui, N    |
| ligne de   | *1 |      |     | pour Non. Valeur à O permet de savoir |
| cde        | ** |      |     | si la ligne de commande est soldée en |
| soldée**   |    |      |     | livraison (cas ou la quantité livrée  |
|            |    |      |     | est strictement inférieure à la       |
|            |    |      |     | quantité commandée et pas de          |
|            |    |      |     | livraison du solde prévue).           |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | N   | Uniquement renseigné si ligne porte   |
| Marché**   | *6 |      |     | sur un marché                         |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No Lot** | *  | N    | N   | Uniquement si marché alloti           |
|            | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | O   | Obligatoire si produit et/ou commande |
| CMP**      | 10 |      |     | service                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | N   | Numéro du projet                      |
| projet**   | *6 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | T pour Oui, F pour Non                |
| Dépense    | *1 |      |     |                                       |
| Impr       | ** |      |     |                                       |
| évisible** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 2 : Lignes de Réception sur produit avec gestion de lot

Ces messages ne sont générés que pour les lignes de produits ayant un
code Gestion des lots et date de péremption positionnée à T. La gestion
des lots n'est pas implémentée dans ELITE.S pour les versions en cours.
Ces messages seront traitées dès que le fonctionnel associé sera géré.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | RO : Réceptions                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M2                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Exercice | *  | N    | O   | Exercice comptable d'imputation       |
| c          | *4 |      |     |                                       |
| omptable** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | O   | No de réception d'ELITE.S             |
| réception  | *8 |      |     |                                       |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | N   | Si réception générée par une          |
| réception  | 10 |      |     | livraison externe, alimenté avec le   |
| de         | ** |      |     | numéro transmis par l'expéditeur      |
| l'ex       |    |      |     |                                       |
| péditeur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | N   | Si réception générée par une          |
| Ex         | 15 |      |     | livraison externe, alimenté avec la   |
| péditeur** | ** |      |     | référence transmise dans le message   |
|            |    |      |     | de l'expéditeur                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de réception : 001 à 999  |
| ligne      | *3 |      |     | maximum.                              |
| r          | ** |      |     |                                       |
| éception** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code produit Hexagone concerné        |
| produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No du lot                             |
| lot**      | 12 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Date de péremption du lot reçu        |
| pé         | *8 |      |     |                                       |
| remption** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Le total des lignes par produit doit  |
| reçue**    | 14 |      |     | être égal à la quantité totale reçue. |
|            | ** |      |     | Décimalisée à 3. Quantité \> 0        |
+------------+----+------+-----+---------------------------------------+

-   ### Modification de Réception

Mêmes messages que les messages de création dès qu'une information est
modifiée avec un mode « MODIFICATION »

-   ### Suppression de Réception :

La suppression concerne soit la totalité de la réception, soit toutes
les lignes associées à une commande.

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | RO : Réceptions                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | M1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Suppression                           |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     | YYYYMMDDHHMISSnn                      |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Exercice | *  | N    | O   | Exercice comptable d'imputation       |
| c          | *4 |      |     |                                       |
| omptable** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | O   | No de réception d'ELITE.S             |
| réception  | *8 |      |     |                                       |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de réception de l'expéditeur       |
| réception  | 10 |      |     |                                       |
| de         | ** |      |     |                                       |
| l'ex       |    |      |     |                                       |
| péditeur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Ligne    | *  | N    | O   | No de ligne de réception : 001 à 999  |
| r          | *3 |      |     | maximum.                              |
| éception** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de commande d'ELITE.S              |
| commande   | *8 |      |     |                                       |
| Hexagone** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de commande de l'expéditeur        |
| commande   | 10 |      |     |                                       |
| de         | ** |      |     |                                       |
| l'ex       |    |      |     |                                       |
| péditeur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

-   ## Factures Externes :

### Création d'une facture externe 

Les factures peuvent être envoyées par un autre émetteur dans ELITE.S.
Dans ce cas le nom de l'émetteur doit être renseigné et stocké dans la
liquidation ELITE.S qui sera générée si tous les contrôles sont
corrects.

#### Message 1 : Entête de Facture

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message : FA : Liquidations   |
|            | *2 |      |     | (factures)                            |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | FE                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | NOM EMETTEUR                          |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     | YYYYMMDDHHMISSnn                      |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de liquidation de l'émetteur       |
| l          | 10 |      |     |                                       |
| iquidation | ** |      |     |                                       |
| de         |    |      |     |                                       |
| l'ex       |    |      |     |                                       |
| péditeur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | S    | O   | Permet d'identifier les cas           |
| Liq        | *1 |      |     | particuliers pour le CMP :            |
| uidation** | ** |      |     |                                       |
|            |    |      |     | N : Réception Normale                 |
+------------+----+------+-----+---------------------------------------+
| **         | *  | N    | O   | Exercice comptable d'imputation de la |
| Exercice** | *4 |      |     | facture                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | F   | No de la facture du fournisseur       |
| facture**  | 10 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code fournisseur Hexagone émetteur de |
| Fou        | *6 |      |     | la facture.                           |
| rnisseur** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code fournisseur Hexagone auquel      |
| C          | *6 |      |     | l'établissement doit payer la         |
| réancier** | ** |      |     | facture.                              |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | Obligatoire doit exister dans         |
| domic      | *2 |      |     | Hexagone                              |
| iliation** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Délai de | *  | N    | O   | Nombre de jours                       |
| paiement** | *3 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Objet de | ** | S    | N   | Texte                                 |
| la         | 40 |      |     |                                       |
| facture**  | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | Date | O   | Date de l'émission de la facture par  |
| facture    | *8 |      |     | le fournisseur Format YYYYMMDD        |
| fou        | ** |      |     |                                       |
| rnisseur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | Date | O   | Format YYYYMMDD Doit être supérieure  |
| limite de  | *8 |      |     | à la date de réception de la facture  |
| paiement** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD . Doit être           |
| réception  | *8 |      |     | supérieure ou égale à la date de      |
| de la      | ** |      |     | facture                               |
| facture**  |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | Format YYYYMMDD . Doit être           |
| saisie de  | *8 |      |     | supérieure ou égale à la date de      |
| la         | ** |      |     | réception de la facture               |
| facture**  |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Montant TTC net à payer. Positif ,    |
| Net à      | 16 |      |     | doit être égal à la somme des lignes  |
| payer**    | ** |      |     | TTC. Décimalisé à 2                   |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | N   | Montant Hors taxe du port et          |
| port et    | 16 |      |     | emballage. Décimalisé à 2.            |
| emballage  | ** |      |     |                                       |
| HT**       |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code TVA | *  | N    | N   | Code TVA à appliquer sur le montant   |
| du Port et | *2 |      |     | Hors taxe du port et emballage        |
| e          | ** |      |     |                                       |
| mballage** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **P        | *  | N    | N   | Pourcentage de remise global appliqué |
| ourcentage | *5 |      |     | sur le montant hors taxe de chaque    |
| de remise  | ** |      |     | ligne de facture. Décimalisé à 2      |
| global**   |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | N   | Montant TTC à déduire. Doit être      |
| des avoirs | 16 |      |     | inférieur au net à payer. Doit        |
| à déduire  | ** |      |     | correspondre à la somme des montants  |
| de la      |    |      |     | des avoirs TTC à déduire des lignes   |
| liq        |    |      |     | de factures. Décimalisé à 2           |
| uidation** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

####  Message 2 : Lignes de facture

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :FA : Liquidations    |
|            | *2 |      |     | (factures)                            |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | FL                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | NOM EMETTEUR                          |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au                   |
| l'envoi**  | 16 |      |     | format :YYYYMMDDHHMISSnn              |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No de liquidation de l'émetteur       |
| l          | 10 |      |     |                                       |
| iquidation | ** |      |     |                                       |
| de         |    |      |     |                                       |
| l'ex       |    |      |     |                                       |
| péditeur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No ligne | *  | N    | O   | No ligne de liquidation de 001 à 999  |
| de         | *3 |      |     |                                       |
| liq        | ** |      |     |                                       |
| uidation** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Permet le rapprochement des factures  |
| commande   | *8 |      |     | et des commandes. Pour les lignes     |
| Hexagone** | ** |      |     | produits, il faudra avoir valider les |
|            |    |      |     | réceptions associées aux commandes    |
|            |    |      |     | pour valider la facture               |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | No de ligne de commande : 001 à 999   |
| ligne      | *3 |      |     | maximum. Permet de faire le lien avec |
| cde**      | ** |      |     | le numéro de ligne de commande        |
|            |    |      |     | associée la ligne de facture          |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Obligatoire si ligne de facture sur   |
| Produit**  | *8 |      |     | produit                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | ** | S    | N   | Obligatoire si ligne de facture       |
| bu         | 10 |      |     | directe sur compte, Format Lettre     |
| dgétaire** | ** |      |     | Budget+no de compte                   |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | N    | N   | Obligatoire si ligne de facture à     |
| Marché**   | *6 |      |     | rapprocher d'un marché. Si commande,  |
|            | ** |      |     | doit être identique sur la ligne de   |
|            |    |      |     | commande.                             |
+------------+----+------+-----+---------------------------------------+
| **No ligne | *  | N    | N   | Obligatoire si No marché renseigné    |
| de         | *3 |      |     |                                       |
| marché**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Obligatoire si marché et marché       |
| lot**      | *2 |      |     | alloti.                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | ** | S    | N   | Obligatoire si produit et/ou commande |
| CMP**      | 10 |      |     | service                               |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Code TVA à appliquer sur la ligne.    |
| TVA**      | *2 |      |     | Doit exister dans HEXAGONE : Table    |
|            | ** |      |     | HXTVA                                 |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Positive décimalisée à 3, si commande |
| Facturée** | 14 |      |     | et produit doit être \<= à la         |
|            | ** |      |     | quantité livrée non facturée et être  |
|            |    |      |     | exprimée dans l'unité de gestion      |
|            |    |      |     | associée au message 4 du produit      |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Montant hors taxe de la ligne.        |
| Hors       | 16 |      |     | Décimalisé à 2                        |
| taxe**     | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **P        | *  | N    | N   | Pourcentage de remise à appliquer à   |
| ourcentage | *5 |      |     | la ligne de facture. Décimalisé à 2   |
| remise**   | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | N   | Décimalisé à 2. Le total des lignes   |
| du port et | 16 |      |     | doit être égal au montant port et     |
| e          | ** |      |     | emballage de l'entête.                |
| mballage** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Montant TTC de la ligne : Le total    |
| TTC**      | 16 |      |     | des lignes doit être égal au montant  |
|            | ** |      |     | net à payer de l'entête. Décimalisé à |
|            |    |      |     | 2                                     |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | N   | Montant de l'avoir à déduire de la    |
| avoir à    | 16 |      |     | ligne. : Le total des lignes doit     |
| déduire**  | ** |      |     | être égal au montant des avoirs de    |
|            |    |      |     | l'entête. Décimalisé à 2              |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Valeurs autorisées :                  |
| ré         | *1 |      |     |                                       |
| cupération | ** |      |     | N : TVA non récupérable               |
| de TVA**   |    |      |     |                                       |
|            |    |      |     | P : TVA partiellement récupérable     |
|            |    |      |     |                                       |
|            |    |      |     | T : TVA totalement récupérable        |
+------------+----+------+-----+---------------------------------------+
| **Taux TVA | *  | N    | N   | Obligatoire si Code récupération est  |
| à          | *5 |      |     | à 'P' et gestion de Taux différents   |
| r          | ** |      |     | de récupération. Si taux unique, on   |
| écupérer** |    |      |     | prend celui paramétré dans Hexagone   |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | N   | Obligatoire si code récupération      |
| TVA à      | 16 |      |     | différent de N. Décimalisé à 2        |
| r          | ** |      |     |                                       |
| écupérer** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF       | *  | N    | O   | Code UF de l'affectation de la ligne  |
| d'aff      | *4 |      |     | de facture.                           |
| ectation** | ** |      |     |                                       |
|            |    |      |     | Si produit stocké non entrée/sortie   |
|            |    |      |     | doit être une UF de magasin           |
|            |    |      |     | principal.                            |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | N   | Doit exister dans ELITE.S             |
| projet**   | *6 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | T pour Oui, F pour Non                |
| Dépense    | *1 |      |     |                                       |
| impr       | ** |      |     |                                       |
| évisible** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

Attention

Toutes les factures transmises et générées dans ELITE.S ne pourront pas
être renvoyées en modification ou suppression. Ces manipulations devront
être faites dans ELITE.S directement.

-   ## Mouvements de stocks internes:

### Création d'un Mouvement de stock interne

Ces mouvements sont transmis par un autre émetteur dans ELITE.S, ou par
un système de lecture code barre, dans ce cas le nom de l'émetteur doit
être renseigné et stocké dans les pièces générées dans ELITE.S si tous
les contrôles sont corrects.

***Ces messages concernent uniquement les produits gérés en stock et non
gérés en entrées/sorties simultanées:***

> **Les
> sorties de stock classiques des magasins et / ou armoires de service
>  :**
>
> Consommations de produits par les services, et gestion des retours de
> service. Dans ce cas, 2 possibilités sont offertes :

-   Soit
    > les mouvements transmis sont déjà valorisés par le système
    > émetteur, dans ce cas la valorisation du mouvement sera
    > comptabilisée telle quelle dans ELITE.S . L'intégration de ce
    > mouvement génère un bon de régularisation de sortie de stock.\
    > *(Message de type SO, code Message S1 avec champ Valeur de la
    > sortie renseignée)*

-   Soit
    > les mouvements transmis sont uniquement quantitatifs, dans ce cas
    > la valorisation sera effectuée dans ELITE.S lors de l'arrêté de
    > balance définitive : L'intégration de ces mouvements génère des
    > bons de sorties normaux. .\
    > *(Message de type SO, code Message S1 avec champ Valeur de la
    > sortie non renseignée)*

> **Les
> inventaires de stock par magasin et / ou armoire de service:**
>
> Ces mouvements permettront de générer un état d'inventaire qui sera
> rapproché du stock géré dans ELITE.S dans les procédure de gestion des
> inventaires des stocks. Ces messages sont purement quantitatif.
>
> *(Message de type SO, code Message I1 avec champ Valeur de la sortie
> non renseignée)*
>
> **Les
> transferts entre magasins de l 'établissement**
>
> Ces mouvements permettront de gérer dans ELITE.S les mouvements entre
> magasins et / ou armoires de service à l'intérieur de l'établissement.
> Ces mouvements ne rentrent pas dans la comptabilisation des
> consommations.
>
> *(Message de type SO, code Message T1 avec champ Valeur de la sortie
> non renseignée)*

#### Message 1 : Mouvements de stock

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | SO : Mouvements de stock              |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | S1 ou I1 ou T1                        |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | NOM EMETTEUR                          |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     | YYYYMMDDHHMISSnn                      |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date     | *  | Date | O   | Date du mouvement : format YYYYMMDD   |
| M          | *8 |      |     |                                       |
| ouvement** | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code UF  | *  | N    | O   | Pour tous les types de codes Messages |
| magasin**  | *4 |      |     | :                                     |
|            | ** |      |     |                                       |
|            |    |      |     | Code de l' UF magasin effectuant la   |
|            |    |      |     | sortie de stock ou l'inventaire ou le |
|            |    |      |     | transfert                             |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Pour tous les types de codes Messages |
| armoire**  | *4 |      |     | et si gestion des armoires dans       |
|            | ** |      |     | ELITE.S : Code de l'armoire associée  |
|            |    |      |     | à l' UF magasin effectuant la sortie  |
|            |    |      |     | de stock ou l'inventaire ou le        |
|            |    |      |     | transfert                             |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | N   | No de bon attribué par le système     |
| bon**      | 10 |      |     | émetteur.                             |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code UF  | *  | N    | O   | Pour les messages S1 : UF             |
| dest       | *4 |      |     | destinatrice de la sortie ou faisant  |
| inatrice** | ** |      |     | le retour                             |
|            |    |      |     |                                       |
|            |    |      |     | Pour les messages I1 : Mettre 0000    |
|            |    |      |     |                                       |
|            |    |      |     | Pour les messages T1 : UF magasin     |
|            |    |      |     | réceptionnant le produit transféré    |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Uniquement renseigné si gestion des   |
| Armoire de | *4 |      |     | armoires dans ELITE.S.                |
| l' UF      | ** |      |     |                                       |
| dest       |    |      |     | Pour les messages S1 : Code armoire   |
| inatrice** |    |      |     | associé à UF destinatrice de la       |
|            |    |      |     | sortie ou faisant le retour           |
|            |    |      |     |                                       |
|            |    |      |     | Pour les messages I1 : Mettre 0000    |
|            |    |      |     |                                       |
|            |    |      |     | Pour les messages T1 : Code armoire   |
|            |    |      |     | de l' UF magasin réceptionnant le     |
|            |    |      |     | produit transféré                     |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Identifiant du produit dans ELITE.S : |
| produit**  | *8 |      |     | peut être soit le code produit soit   |
|            | ** |      |     | le code CIP paramétré sur la fiche    |
|            |    |      |     | produit.                              |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | O   | Décimalisée à 3. Peut être négative   |
| produit**  | 14 |      |     | dans le cas d'un message S1 (retour   |
|            | ** |      |     | ). Elle doit être exprimée dans       |
|            |    |      |     | l'unité de gestion associée au        |
|            |    |      |     | message 4 du produit                  |
+------------+----+------+-----+---------------------------------------+
| **Valeur   | ** | N    | N   | Peut être renseignée uniquement si    |
| produit**  | 16 |      |     | message S1 et peut être négative.     |
|            | ** |      |     |                                       |
|            |    |      |     | Décimalisée à 2                       |
+------------+----+------+-----+---------------------------------------+
| **Numéro   | ** | S    | N   | Obligatoire uniquement si produit     |
| du lot**   | 12 |      |     | codé avec gestion des lots et dates   |
|            | ** |      |     | de péremption                         |
+------------+----+------+-----+---------------------------------------+
| **No       | *  | S    | N   | No dossier patient HEXAGONE si connu  |
| dossier    | *9 |      |     |                                       |
| Patient**  | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

-   ### Envoi des liste pré établies

Les listes Pré établies sont envoyées d'ELITE.S vers un autre
destinataire.

Elles sont élaborées par Magasin pour chaque UF cliente et elles donnent
la liste des produits disponibles avec éventuellement les quantités de
dotations préconisées

#### Message 1 : Listes pré établies

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | SO : Sorties                          |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | L1 : liste pré établie                |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | HEXAGONE                              |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     | YYYYMMDDHHMISSnn                      |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | N    | O   |                                       |
| Exercice** | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF       | *  | N    | O   | UF magasin émetteur                   |
| Magasin**  | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code armoire ( si pas de gestion des  |
| Armoire**  | *4 |      |     | armoires 0000)                        |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **UF       | *  | N    | O   | UF cliente associée à la liste        |
| cliente**  | *4 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Code de l'armoire associée à l'UF     |
| Armoire    | *4 |      |     | cliente. Si pas de gestion des        |
| Cliente**  | ** |      |     | armoires valeur 0000                  |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Nom de la liste                       |
| liste**    | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code produit                          |
| produit**  | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | *  | N    | O   | No de ligne de la liste               |
| ligne**    | *3 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Libellé  | ** | S    | O   |                                       |
| produit**  | 40 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Quantité | ** | N    | F   | Décimalisé à 3. Quantité de dotation  |
| dotation** | 12 |      |     | calculée ou saisie                    |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Co       | ** | N    | F   | Consommation moyenne journalière      |
| nsommation | 12 |      |     | calculée si génération par le calcul  |
| Moyenne**  | ** |      |     | de dotation                           |
+------------+----+------+-----+---------------------------------------+
| **Nombre   | *  | N    | F   | Nombre de lignes de sorties prise en  |
| de lignes  | *8 |      |     | compte dans le calcul de dotation     |
| de         | ** |      |     |                                       |
| sortie**   |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

##  Recettes diverses:

### Création d'un Mouvement de recettes diverses

Ces mouvements sont transmis par un autre émetteur dans HEXAGONE. Dans
ce cas le nom de l'émetteur doit être renseigné et stocké dans les
pièces générées dans HEXAGONE si tous les contrôles sont corrects.

#### Message 1 : Entête de pièce

+------------+----+------+-----+---------------------------------------+
| **         | *  | **   | *   | **Commentaires**                      |
| Rubrique** | *L | Form | *Ob |                                       |
|            | on | at** | lig |                                       |
|            | g. |      | .** |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type**   | *  | S    | O   | Type du message :                     |
|            | *2 |      |     |                                       |
|            | ** |      |     | RD : Pièce de recettes diverses       |
+------------+----+------+-----+---------------------------------------+
| *          | *  | S    | O   | E1                                    |
| *Message** | *2 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Mode**   | *  | S    | O   | Création                              |
|            | *1 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | ** | S    | O   | NOM EMETTEUR                          |
| Emetteur** | 15 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Date de  | ** | Date | O   | Date de l'envoie au format :          |
| l'envoi**  | 16 |      |     |                                       |
|            | ** |      |     | YYYYMMDDHHMISSnn                      |
+------------+----+------+-----+---------------------------------------+
| **Individu | ** | S    | O   | Individu au sens S3A qui a généré le  |
| (émetteur  | 50 |      |     | message.                              |
| du         | ** |      |     |                                       |
| message)** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **No de    | ** | S    | O   | No d'identifiant unique de la pièce   |
| pièce de   | 10 |      |     |                                       |
| l'ex       | ** |      |     |                                       |
| péditeur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **         | *  | N    | O   | Exercice comptable d'imputation de la |
| Exercice** | *4 |      |     | pièce                                 |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code débiteur destinataire du titre à |
| débiteur** | *6 |      |     | émettre. Majuscules uniquement        |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Nom      | ** | S    | O   | Dénomination du débiteur : Majuscules |
| Débiteur** | 35 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Adresse  | ** | S    | N   | Adresse 1 du débiteur                 |
| 1**        | 40 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Adresse  | ** | S    | N   | Suite adresse                         |
| 2**        | 40 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Code postal débiteur                  |
| postal**   | *5 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Ville**  | ** | S    | N   | Ville débiteur                        |
|            | 40 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Compte   | *  | N    | O   | Compte de tiers associé au débiteur   |
| de tiers** | *7 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type     | *  | N    | O   | Valeurs autorisées :                  |
| débiteur** | *1 |      |     |                                       |
|            | ** |      |     | 1 & 2 : Sécurité sociale              |
|            |    |      |     |                                       |
|            |    |      |     | 3 & 4 : Mutuelle                      |
|            |    |      |     |                                       |
|            |    |      |     | 5 & 6 : DDASS                         |
|            |    |      |     |                                       |
|            |    |      |     | 7 : Particulier                       |
|            |    |      |     |                                       |
|            |    |      |     | 8 : Débiteur en instance              |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | N   | Obligatoire si type débiteur          |
| transfert  | *4 |      |     | différent de 7 et 8                   |
| HTITRE     | ** |      |     |                                       |
| débiteur** |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Montant  | ** | N    | O   | Obligatoirement positif. Décimalisé à |
| TTC        | 16 |      |     | 2, doit être égal au cumul des        |
| pièce**    | ** |      |     | montants TTC lignes                   |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | N    | O   | Valeurs autorisées :                  |
| soumis à   | *1 |      |     |                                       |
| r          | ** |      |     | O = Pièce soumise reversement de TVA  |
| eversement |    |      |     |                                       |
| de TVA**   |    |      |     | N = Pièce non soumise à reversement   |
|            |    |      |     | TVA                                   |
+------------+----+------+-----+---------------------------------------+
| **Objet**  | *  | S    | N   | Objet de la pièce                     |
|            | *1 |      |     |                                       |
|            | 00 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Type de  | *  | N    | O   | Valeurs autorisées :                  |
| recette**  | *1 |      |     |                                       |
|            | ** |      |     | 0 : Titre à recouvrer                 |
|            |    |      |     |                                       |
|            |    |      |     | 1 : Perçue avant émission             |
|            |    |      |     |                                       |
|            |    |      |     | 2 Opération d'Ordre                   |
+------------+----+------+-----+---------------------------------------+
| **Date de  | *  | Date | O   | YYYYMMDD                              |
| pièce**    | *8 |      |     |                                       |
|            | ** |      |     |                                       |
+------------+----+------+-----+---------------------------------------+
| **Code     | *  | S    | O   | Code édition d'un avis des sommes à   |
| Avis des   | *1 |      |     | payer en plus du titre : O pour Oui,  |
| sommes à   | ** |      |     | N pour Non                            |
| payer**    |    |      |     |                                       |
+------------+----+------+-----+---------------------------------------+

#### Message 1 : Lignes de pièce

+-------------+----+-----+----+---------------------------------------+
| *           | *  | *   | ** | **Commentaires**                      |
| *Rubrique** | *L | *Fo | Ob |                                       |
|             | on | rma | li |                                       |
|             | g. | t** | g. |                                       |
|             | ** |     | ** |                                       |
+-------------+----+-----+----+---------------------------------------+
| **Type**    | *  | S   | O  | Type du message :                     |
|             | *2 |     |    |                                       |
|             | ** |     |    | RD : Pièce de recettes diverses       |
+-------------+----+-----+----+---------------------------------------+
| **Message** | *  | S   | O  | L1                                    |
|             | *2 |     |    |                                       |
|             | ** |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+
| **Mode**    | *  | S   | O  | Création                              |
|             | *1 |     |    |                                       |
|             | ** |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+
| *           | ** | S   | O  | NOM EMETTEUR                          |
| *Emetteur** | 15 |     |    |                                       |
|             | ** |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+
| **Date de   | ** | D   | O  | Date de l'envoie au format :          |
| l'envoi**   | 16 | ate |    |                                       |
|             | ** |     |    | YYYYMMDDHHMISSnn                      |
+-------------+----+-----+----+---------------------------------------+
| **Individu  | ** | S   | O  | Individu au sens S3A qui a généré le  |
| (émetteur   | 50 |     |    | message.                              |
| du          | ** |     |    |                                       |
| message)**  |    |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+
| **No de     | ** | S   | O  | No d'identifiant unique de la pièce   |
| pièce de    | 10 |     |    |                                       |
| l'e         | ** |     |    |                                       |
| xpéditeur** |    |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+
| **No de     | *  | N   | O  | Numéro de ligne 001 à 999             |
| ligne**     | *3 |     |    |                                       |
|             | ** |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+
| **Compte    | ** | S   | O  | Format Lettre budget + No compte      |
| b           | 10 |     |    |                                       |
| udgétaire** | ** |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+
| **Code UF** | *  | N   | O  | Code UF d'affectation de la recette,  |
|             | *4 |     |    | doit appartenir au même établissement |
|             | ** |     |    | géographique que les autres lignes de |
|             |    |     |    | cette pièce                           |
+-------------+----+-----+----+---------------------------------------+
| *           | ** | N   | N  | Quantité de la ligne. Décimalisé à 3  |
| *Quantité** | 11 |     |    |                                       |
|             | ** |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+
| **PU Hors   | ** | N   | O  | Montant Hors taxe si le code          |
| taxe**      | 16 |     |    | reversement TVA de l'entête est       |
|             | ** |     |    | positionné à O et ligne soumise à     |
|             |    |     |    | reversement de TVA. Montant TTC       |
|             |    |     |    | sinon. Décimalisé à 4                 |
+-------------+----+-----+----+---------------------------------------+
| **Code      | *  | N   | N  | Obligatoire si code reversement TVA   |
| TVA**       | *2 |     |    | de l'entête est positionné et ligne   |
|             | ** |     |    | soumise à reversement de TVA. Doit    |
|             |    |     |    | exister dans HEXAGONE, Table HXTVA    |
+-------------+----+-----+----+---------------------------------------+
| **Montant   | ** | N   | O  | Le cumul des TTC lignes doit          |
| TTC ligne** | 16 |     |    | correspondre au TTC de l'entête.      |
|             | ** |     |    | Décimalisé à 2                        |
+-------------+----+-----+----+---------------------------------------+
| **Dé        | ** | S   | F  | Désignation de la ligne de pièce qui  |
| signation** | 31 |     |    | est reprise sur les titres.           |
|             | ** |     |    |                                       |
+-------------+----+-----+----+---------------------------------------+

-   ## Inventaires pour les biens immobilisés:

### Création d'un Mouvement d'inventaire

Ces mouvements sont transmis par un autre émetteur dans HEXAGONE.

Dans ce cas le nom de l'émetteur doit être renseigné et stocké dans les
pièces générées dans HEXAGONE si tous les contrôles sont corrects.

+------------+----+-----------+-----+----------------------------------+
| **         | *  | *         | *   | **Commentaires**                 |
| Rubrique** | *L | *Format** | *Ob |                                  |
|            | on |           | lig |                                  |
|            | g. |           | .** |                                  |
|            | ** |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **Type**   | *  | S         | O   | Type du message :                |
|            | *2 |           |     |                                  |
|            | ** |           |     | IM : Mouvements d'inventaire     |
+------------+----+-----------+-----+----------------------------------+
| *          | *  | S         | O   | M1                               |
| *Message** | *2 |           |     |                                  |
|            | ** |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **Mode**   | *  | S         | O   | Création                         |
|            | *1 |           |     |                                  |
|            | ** |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **         | ** | S         | O   | NOM EMETTEUR                     |
| Emetteur** | 15 |           |     |                                  |
|            | ** |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **Date de  | ** | Date      | O   | Date de l'envoi au format :      |
| l'envoi**  | 16 |           |     |                                  |
|            | ** |           |     | YYYYMMDDHHMISSnn                 |
+------------+----+-----------+-----+----------------------------------+
| **Individu | ** | S         | O   | Individu au sens S3A qui a       |
| (émetteur  | 50 |           |     | généré le message.               |
| du         | ** |           |     |                                  |
| message)** |    |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **Date     | *  | Date      | O   | Date : YYYYMMDD                  |
| in         | *8 |           |     |                                  |
| ventaire** | ** |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **Code     | *  | N         | O   | Code de l' UF pour lequel        |
| UF**       | *4 |           |     | l'inventaire est fait            |
|            | ** |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **Exercice | *  | N         | O   | Exercice de la fiche             |
| Fiche**    | *4 |           |     |                                  |
|            | ** |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **No de    | *  | N         | O   | No de fiche                      |
| fiche**    | *5 |           |     |                                  |
|            | ** |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+
| **No d'    | *  | N         | O   | No de l'inventaire ( la          |
| in         | *3 |           |     | combinaison exercice+no de       |
| ventaire** | ** |           |     | fiche+ no d'inventaire est       |
|            |    |           |     | l'identifiant code barre).       |
+------------+----+-----------+-----+----------------------------------+
| **Nombre   | *  | N         | N   | Nombre de composants associé à   |
| de         | *1 |           |     | l'identifiant du bien            |
| co         | ** |           |     | immobilisé.                      |
| mposants** |    |           |     |                                  |
+------------+----+-----------+-----+----------------------------------+

# Exemples d'évènements et messages associés :

### Arrivée aux urgences :

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M2            C             Arrivée dans l'établissement

  MV            M6            C             Entrée dans l'unité de soins
                                            des urgences
  ------------- ------------- ------------- ------------------------------

### Hospitalisation suite urgence :

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M3            C             Changement de statut du
                                            dossier qui passe de dossier
                                            d'urgence à dossier
                                            d'hospitalisation. Cette
                                            manipulation est saisie par
                                            les urgences.
  ------------- ------------- ------------- ------------------------------

### Confirmation de suite hospitalisation :

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M6            C             Entrée dans l'unité de soins
                                            effective. C'est soit l'unité
                                            de soin qui confirme
                                            l'information à la vue du
                                            patient ou quand il veut le
                                            mettre dans un lit. Soit les
                                            services administratifs qui
                                            récupèrent le dossier pour le
                                            compléter.
  ------------- ------------- ------------- ------------------------------

### Consultation externe suite urgence :

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M3            C             Changement de statut du
                                            dossier qui passe de dossier
                                            d'urgence à dossier
                                            d'hospitalisation. Cette
                                            manipulation est saisie par
                                            les urgences.
  ------------- ------------- ------------- ------------------------------

### Confirmation de suite consultation :

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M6            C             C'est soit l'unité de soin qui
                                            confirme l'information au
                                            moment de saisir les actes.
                                            Soit les services
                                            administratifs qui récupèrent
                                            le dossier pour le compléter.
  ------------- ------------- ------------- ------------------------------

### Autres suites urgence

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M8            C             Sortie de l'uf d'urgence

  MV            M9            C             Sortie de l'établissement
  ------------- ------------- ------------- ------------------------------

### 

###  Entrée directe

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M2            C             Arrivée dans l'établissement

  MV            M6            C             Entrée dans l'unité de soins
  ------------- ------------- ------------- ------------------------------

### Mutation après une entrée directe

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M8            C             Sortie unité d'origine

  MV            M6            C             Entrée dans l'unité de soins
                                            de la mutation.
  ------------- ------------- ------------- ------------------------------

### Mutation insérée entre deux mouvements 

> (Insertion d'un mouvement de mutation MV1bis entre deux mutations MV1
> et MV2)

+------------+------------+------------+------------------------------+
| **Type**   | *          | **Mode**   | **Commentaire**              |
|            | *Message** |            |                              |
+------------+------------+------------+------------------------------+
| MV         | M6         | C          | Entrée dans l'unité de soin  |
|            |            |            | de la mutation               |
|            |            |            |                              |
|            |            |            | Mouvement Mvbis.             |
+------------+------------+------------+------------------------------+
| MV         | M8         | C          | Sortie de l'uf de mutation   |
|            |            |            | (MV1bis)                     |
+------------+------------+------------+------------------------------+
| MV         | M6         | M          | Modification de l'uf origine |
|            |            |            | du mouvement MV2.            |
+------------+------------+------------+------------------------------+

### Sortie définitive

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M8            C             Sortie unité de soin

  MV            M9            C             Sortie de l'établissement
  ------------- ------------- ------------- ------------------------------

### Pré admission

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M2            C             Saisie d'une arrivée prévue à
                                            l'hôpital

  MV            M6            C             Entrée prévue dans une unité
                                            de soin.
  ------------- ------------- ------------- ------------------------------

### Confirmation d'une pré admission

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M2            M             Saisie d'une arrivée effective
                                            à l'hôpital

  MV            M6            M             Confirmation de l'entrée dans
                                            une unité de soin.
  ------------- ------------- ------------- ------------------------------

### Nouveau né hospitalisé : 

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M3            C             Changement de statut du
                                            dossier qui passe de
                                            nouveau-né à hospitalisé

  MV            M8            C             Sortie de la pouponnière.

  MV            M6            C             Entrée dans l'uf d'hospit.
  ------------- ------------- ------------- ------------------------------

### Changement de chambre :

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M7            C             Changementt de chambre
  ------------- ------------- ------------- ------------------------------

### Suppression d'un dossier :

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M2            S             Suppression du séjour par la
                                            transaction spécifique ou
                                            suppression du dernier
                                            mouvement si celui ci est une
                                            entrée directe.
  ------------- ------------- ------------- ------------------------------

### Suppression d'un patient avec n dossiers

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M2            S             Suppression dossier 1

  MV            M2            S             Suppression dossier n

  ID            M1            S             Suppression patient.
  ------------- ------------- ------------- ------------------------------

### Fusion de deux patients

  ------------- ------------- ------------- ------------------------------
  **Type**      **Message**   **Mode**      **Commentaire**

  MV            M4            C             Suppression dossier 1

  MV            M4            C             Suppression dossier n

  ID            M1            S             Suppression patient.
  ------------- ------------- ------------- ------------------------------

## Admission aux urgences

### Arrivée aux urgences sans localisation

#### Dans un premier temps le patient est enregistré

  ---------- ------------- ---------- ---------------- ---------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement    **Emplacement    **Commentaire**
                                      départ**         destination**    

  MV         M2            C                                            Arrivée dans
                                                                        l'établissement

  MV         M6            C                                            Entrée dans
                                                                        l'unité de soins
                                                                        des urgences
  ---------- ------------- ---------- ---------------- ---------------- -----------------

#### Dans un second temps le patient est mis en box ou en salle d'attente

##### Mise en box

  ---------- ------------- ---------- ---------------- ------------------------ -----------------
  **Type**   **Message**   **Mode**   **Emplacement    **Emplacement            **Commentaire**
                                      départ**         destination**            

  MU         B1            C          Néant            Zone\|Secteur\|box\|n°   Entrée dans le
                                                                                box
  ---------- ------------- ---------- ---------------- ------------------------ -----------------

##### Mise en salle d'attente

  ---------- ------------- ---------- ---------------- ------------------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement    **Emplacement             **Commentaire**
                                      départ**         destination**             

  MT         M6            C          Néant            S\|Zone\|Secteur\|salle   Entrée dans un
                                                                                 emplacement
                                                                                 temporaire
  ---------- ------------- ---------- ---------------- ------------------------- -----------------

### Arrivée aux urgences et mis en salle d'attente

  ---------- ------------- ---------- ---------------- ------------------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement    **Emplacement             **Commentaire**
                                      départ**         destination**             

  MV         M2            C                                                     Arrivée dans
                                                                                 l'établissement

  MV         M6            C                                                     Entrée dans
                                                                                 l'unité de soins
                                                                                 des urgences

  MT         M6            C          Néant            S\|Zone\|Secteur\|salle   Entrée dans un
                                                                                 emplacement
                                                                                 temporaire
  ---------- ------------- ---------- ---------------- ------------------------- -----------------

### Arrivée aux urgences et mise en box

  ---------- ------------- ---------- ---------------- ------------------------ -----------------
  **Type**   **Message**   **Mode**   **Emplacement    **Emplacement            **Commentaire**
                                      départ**         destination**            

  MV         M2            C                                                    Arrivée dans
                                                                                l'établissement

  MV         M6            C                                                    Entrée dans
                                                                                l'unité de soins
                                                                                des urgences

  MU         B1            C          Néant            Zone\|Secteur\|box\|n°   Entrée dans le
                                                                                box
  ---------- ------------- ---------- ---------------- ------------------------ -----------------

## Mouvements possibles aux urgences

### Passage d'un BOX vers la radio

  ---------- ------------- ---------- ----------------------- ------------------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement départ**  **Emplacement             **Commentaire**
                                                              destination**             

  MT         M6            C          B\|Zone\|Secteur\|box   P\|Zone\|Secteur\|salle   Entrée dans un
                                                                                        emplacement
                                                                                        temporaire
  ---------- ------------- ---------- ----------------------- ------------------------- -----------------

### Changement de box

  ---------- ------------- ---------- ------------------------ ------------------------ -----------------
  **Type**   **Message**   **Mode**   **Emplacement départ**   **Emplacement            **Commentaire**
                                                               destination**            

  MU         B1            C          Zone\|Secteur\|box\|n°   Zone\|Secteur\|box\|n°   Changement de box
  ---------- ------------- ---------- ------------------------ ------------------------ -----------------

### Retour au box suite à une radio

  ---------- ------------- ---------- ------------------------- --------------------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement départ**    **Emplacement destination** **Commentaire**

  MT         M8            C          P\|Zone\|secteur\|salle   B\|Zone\|Secteur\|box\|n°   Sortie d'un
                                      d'examen                                              emplacement
                                                                                            temporaire
  ---------- ------------- ---------- ------------------------- --------------------------- -----------------

### Passage de salle d'attente vers la radio

  ---------- ------------- ---------- ------------------------- ------------------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement départ**    **Emplacement             **Commentaire**
                                                                destination**             

  MT         M8            C          S\|Zone\|Secteur\|salle   P\|Zone\|secteur\|salle   Sortie d'un
                                                                d'examen                  emplacement
                                                                                          temporaire

  MT         M6            C          S\|Zone\|Secteur\|salle   P\|Zone\|secteur\|salle   Entrée dans un
                                                                d'examen                  emplacement
                                                                                          temporaire
  ---------- ------------- ---------- ------------------------- ------------------------- -----------------

### Passage de la radio vers le scanner

  ---------- ------------- ---------- ------------------------- ------------------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement départ**    **Emplacement             **Commentaire**
                                                                destination**             

  MT         M8            C          P\|Zone\|secteur\|salle   P\|Zone\|secteur\|salle   Sortie d'un
                                      de radio                  de scaner                 emplacement
                                                                                          temporaire

  MT         M6            C          P\|Zone\|secteur\|salle   P\|Zone\|secteur\|salle   Entrée dans un
                                      de radio                  de scaner                 emplacement
                                                                                          temporaire
  ---------- ------------- ---------- ------------------------- ------------------------- -----------------

***Sortie des urgences***

### Le patient est dans un box suite Hospitalisation ou consultation externe

  ---------- ------------- ---------- ------------------------ ---------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement départ**   **Emplacement    **Commentaire**
                                                               destination**    

  MU         B1            C          Zone\|Secteur\|box\|n°                    Sortie du box

  MV         M3            C                                                    Changement de
                                                                                statut du dossier
                                                                                qui passe de
                                                                                dossier d'urgence
                                                                                à dossier
                                                                                d'hospit.
  ---------- ------------- ---------- ------------------------ ---------------- -----------------

### Le patient est dans un box il est hospitalisé en lit porte mais reste dans le box

  ---------- ------------- ---------- ---------------- ---------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement    **Emplacement    **Commentaire**
                                      départ**         destination**    

  MV         M3            C                                            Changement de
                                                                        statut du dossier
                                                                        qui passe de
                                                                        dossier d'urgence
                                                                        à dossier
                                                                        d'hospit.
  ---------- ------------- ---------- ---------------- ---------------- -----------------

Quand le patient sera hébergé réellement dans une chambre de la
localisation lit porte

  ---------- ------------- ---------- ------------------------ ---------------- -----------------
  **Type**   **Message**   **Mode**   **Emplacement départ**   **Emplacement    **Commentaire**
                                                               destination**    

  MV         M6            C                                                    Confirmation
                                                                                entrée aux lits
                                                                                porte.

  MU         B1            C          Zone\|Secteur\|box\|n°                    Sortie du box

  MV         M2            M                                                    Modification ED
                                                                                pour mise en lit

  MV         M6            M                                                    Mise en lit
  ---------- ------------- ---------- ------------------------ ---------------- -----------------

# Cas Particuliers de Demandes Faites aux Serveurs

Il serait préférable d\'utiliser pour ce faire le module HEXAHUB.

-   ## Serveur d\'Identité

On peut faire au serveur d'identité une demande de création d'IPP
provisoire. Pour se faire il faut **envoyer un message de type M1** dont
la structure est décrite en page 5. Dans ce message, seules les
informations connues seront envoyées. Le n° IPP ne devra pas être
envoyé, s'il l'est il sera ignoré.

Ce message sera pris en charge par **le Service Echange qui activera le
composant HEXAGONE chargé de créer cet IPP et qui reverra le no IPP à
l'application demandeuse.** Par la suite le message **M1** (création
d'un IPP) sera envoyé à toutes les applications externes par la
procédure normale de création d'un patient dans le serveur. Cet IPP sera
" topé " comme provisoire jusqu'à ce qu'un utilisateur aille valider les
informations du patient.

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | DD = Identification.          |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | M1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création (seule la création   |
|             | *1 |           |     | est autorisée).               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nom**     | ** | S         | O   | Nom usuel                     |
|             | 50 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Prénom**  | ** | S         | N   | Prénom(s)                     |
|             | 50 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | *  | Date      | N   | Au format : YYYYMMDD          |
| naissance** | *8 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Nom jeune | ** | S         | N   | Nom patronymique n'est        |
| fille**     | 50 |           |     | renseigné que dans le cas de  |
|             | ** |           |     | femmes mariées.               |
+-------------+----+-----------+-----+-------------------------------+
| *           | *  | S         | N   | Abréviation recensée dans la  |
| *Civilité** | *4 |           |     | table des civilités HEXAGONE  |
|             | ** |           |     | (HRCIV).                      |
+-------------+----+-----------+-----+-------------------------------+
| **Situation | *  | S         | N   | Situation de famille abrégée  |
| fam.**      | *1 |           |     | recensée dans la table        |
|             | ** |           |     | HEXAGONE (HRSFA).             |
+-------------+----+-----------+-----+-------------------------------+
| **Nbre      | *  | N         | N   |                               |
| d'enfants** | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Na        | *  | S         | N   | Nomenclature INSEE            |
| tionalité** | *3 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Lieu de   | ** | S         | N   | Lieu de naissance             |
| naiss.**    | 64 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| Adresse :   | 40 | S         | N   | Première ligne adresse        |
|             |    |           |     |                               |
| Ligne 1     | 40 | S         | N   | Deuxième ligne adresse        |
|             |    |           |     |                               |
| Ligne 2     | 5  | N         | N   | Code postal                   |
|             |    |           |     |                               |
| Code postal | 40 | S         | N   | Ville                         |
|             |    |           |     |                               |
| Ville       | 5  | N         | N   | Code canton                   |
|             |    |           |     |                               |
| Canton      |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Zone      | *  | S         | N   | Zone libre de 100 caractères  |
| téléphone** | *1 |           |     | pour indiquer un ou plusieurs |
|             | 00 |           |     | no de téléphones.             |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Médecin   | ** | S         | N   | Médecin traitant              |
| traitant**  | 35 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Catég.    | *  | S         | N   | Catégorie socio               |
| Socio p**   | *3 |           |     | professionnelle Nomenclature  |
|             | ** |           |     | INSEE                         |
+-------------+----+-----------+-----+-------------------------------+
| **Activ.    | *  | S         | N   | Activité socio                |
| Socio. P**  | *3 |           |     | professionnelle Nomenclature  |
|             | ** |           |     | INSEE                         |
+-------------+----+-----------+-----+-------------------------------+
| **Date      | *  | Date      | N   | Date de cessation d'activité  |
| cess. Act** | *8 |           |     | au format :                   |
|             | ** |           |     |                               |
|             |    |           |     | YYYYMMDD                      |
+-------------+----+-----------+-----+-------------------------------+
| **Poids de  | *  | 9999.99   | N   | Poids à la naissance          |
| naiss.**    | *7 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Taille    | *  | 999.99    | N   | Taille à la naissance         |
| naiss.**    | *6 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Heure     | *  | N         | N   | Heure de naissance            |
| naiss.**    | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Sexe**    | *  | S         | N   | Sexe du patient               |
|             | *1 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

-   ##  Serveur d\'Actes

On peut envoyer au serveur d'acte des messages contenant des actes à
intégrer dans le serveur d'actes et qui remonteront dans le dossier du
patient.

Ils devront avoir le format suivant:

+-------------+----+-----------+-----+-------------------------------+
| *           | *  | *         | *   | **Commentaires**              |
| *Rubrique** | *L | *Format** | *Ob |                               |
|             | on |           | lig |                               |
|             | g. |           | .** |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Type**    | *  | S         | O   | Type du message :             |
|             | *2 |           |     |                               |
|             | ** |           |     | DD = Demande création actes.  |
+-------------+----+-----------+-----+-------------------------------+
| **Message** | *  | S         | O   | K1                            |
|             | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Mode**    | *  | S         | O   | Création, Modification,       |
|             | *1 |           |     | Suppression                   |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | HEXAGONE                      |
| *Emetteur** | 15 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date      | O   | Date de l'envoi au format :   |
| l'envoi**   | 16 |           |     |                               |
|             | ** |           |     | YYYYMMDDHHMISSnn              |
+-------------+----+-----------+-----+-------------------------------+
| *           | ** | S         | O   | Individu au sens S3A qui a    |
| *Individu** | 50 |           |     | généré le message.            |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **IPP**     | ** | S         | O   | N° d'IPP                      |
|             | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **No de     | *  | S         | O   | N° du séjour stable de        |
| dossier**   | *9 |           |     | l'entrée dans l'établissement |
|             | ** |           |     | jusqu'à la sortie définitive. |
+-------------+----+-----------+-----+-------------------------------+
| **N° de la  | ** | N         | O   | Correspondra au numéro de bon |
| demande**   | 10 |           |     | dans HEXAGONE                 |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Lettre    |    |           | O   | Codification NGAP             |
| clé**       |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Date de   | ** | Date et   | O   | Format de la date :           |
| l'acte**    | 14 | heure     |     |                               |
|             | ** |           |     | YYYYMMDDHHMISS                |
+-------------+----+-----------+-----+-------------------------------+
| **Nombre    | *  | 99        | N   | Si rien on prendra 1          |
| d'actes**   | *2 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | 9999.99   | N   | Si rien on prendra 1          |
| Coefficient | *7 |           |     |                               |
| de l'acte** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **          |    |           | N   | Si rien on considère qu'il    |
| Coefficient |    |           |     | n'y a pas de majoration.      |
| majoré**    |    |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **M         | *  | S         | N   | F férié                       |
| ajoration** | *1 |           |     |                               |
|             | ** |           |     | D Dimanche                    |
|             |    |           |     |                               |
|             |    |           |     | N Nuit                        |
+-------------+----+-----------+-----+-------------------------------+
| **Montant** | ** | 99        | N   | Montant valorisé              |
|             | 11 | 999999.99 |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Cir       | ** | S         | N   | Plâtre                        |
| constance** | 15 |           |     |                               |
|             | ** |           |     | Au pied du lit ...            |
+-------------+----+-----------+-----+-------------------------------+
| **Uf        | *  | 9999      | N   |                               |
| d           | *4 |           |     |                               |
| emandeuse** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **Uf        | *  | 9999      | O   |                               |
| pr          | *4 |           |     |                               |
| oductrice** | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+
| **          | *  | S         | N   | Si rien, on prendra celui par |
| Praticien** | *7 |           |     | défaut paramétré dans         |
|             | ** |           |     | hexagone pour uf et le code   |
|             |    |           |     | NGAP.                         |
+-------------+----+-----------+-----+-------------------------------+
| **Acte      | ** | S         | N   |                               |
| nommé**     | 10 |           |     |                               |
|             | ** |           |     |                               |
+-------------+----+-----------+-----+-------------------------------+

# Spécifications du Service Echange

-   ## Schéma Fonctionnel


-   ## Spécificités Fonctionnelles

Le Service Echange fait l'objet d'un module spécifique HN.

Les composants du Service Echange sont paramétrables par message et
application.

Un service, composant, prend en charge le message et renvoie un accusé
de réception.

Des compte-rendus de la communication sont générés. Cela permet une
exploitation statistique des déroulement des communications.

### Structure de l'accusé de réception

  ------------------- ---------------------------------------------------
  Accusé de Réception Booléen prenant les valeurs T (True) ou F (False)

  Code Retour         0, 1, 2, 3 ou 50

  Statut              Code d\'erreur en cas de retour d\'erreur (code
                      retour différent de 0)

  Libellé             Géré par l'application qui a reçu le message. Ce
                      code peut par exemple contenir le numéro d\'IPP
                      dans le cas d\'une demande de création d\'identité
                      ou le libellé d\'une éventuelle erreur. Il ne doit
                      pas dépasser **50 caractères**.
  ------------------- ---------------------------------------------------

### Informations à répercuter vers les autres applications

Mettre en place une **nomenclature des composants** / destinataires afin
de pouvoir éventuellement les " dispatcher " facilement sur des machines
différentes pour des raisons de performances ou les déclarer dans le
fichier d\'assignation du Service Echange.

### Structure des tables du Service Echange

La liste des tables du module service échange de Hub.s, est disponible
sur le CDROM et en téléchargement.

Elle se nomme mcd_echange.pdf, et est remise a jour a chaque livraison
de version.

-   ## Composants Externes

### Service de demande de création d\'IPP.

DLL livrée dans le répertoire outil d\'Hexagone.

**[Signature de l\'opération:]{.underline}**

long \_\_declspec(dllimport) OP_HN_CREIPP(

char\* pszCompte,

char\* pszMessage,

long\* plCodeRetour,

long\* plStatus,

char\* pszLibelle);

**[Description des paramètres:]{.underline}**

pszCompte

> Etablissement dans lequel il faut créer l\'IPP. Ce paramètre doit être
> sous la forme KALAMxx où xx correspond au numéro d\'établissement.

pszMessage

> Message ID, M1, C sous la forme décrite à la page 15.

plCodeRetour

> Code retour renvoyé par le Service Echange (0, 1 ou 2).

plStatus

> Statut d\'erreur en cas de code retour différent de 0.

pszLibelle

> Si le traitement s\'est bien passé, ce paramètre contient le numéro
> d\'IPP; sinon, il contient le libellé de l\'erreur retournée.

**Il est préférable d'utiliser les fonctions de HUB.s (hexahub), pour ce
type de fonction.**
