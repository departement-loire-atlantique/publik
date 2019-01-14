Ce projet a pour vocation de simplifier l'installation de la solution Publik de la société Entr'ouvert.

Il repose sur des containers docker dont certains sont pré-compilés sur Docker Hub.

1 - Pré-requis
--------------------------------------

Publik ne fonctionne qu'avec Debian Jessie, le point de départ est donc de créer une machine avec cette distribution de Linux. Pour rapidement tester la solution, il est possible de l'installer sur un serveur Cloud d'OVH par exemple.

Caractéristiques minimales de la machine :
* Distribution : Debian 8
* 4Go de RAM 
* 10 Go de disque (20 Go recommandé)

2 - Déclarations DNS
------------------------------------------------------------

Configurer un sous domaine vers le serveur nouvellement créé.
Exemple : *.testgru.loire-atlantique.fr => 54.38.136.168

En fin d'installation, l'ensemble des applications publik seront accessibles depuis ce sous domaine.

Des certificats Let's encrypt (certificats HTTPS valables et signés) seront automatiquement générés durant le processus d'installation. C'est pourquoi il est important que le serveur soit accessible depuis internet et que les enregistrement DNS ait été préalablement configurées.

Vérifier votre configuration en réalisant un ping sur une adresse.

Exemple :
```
ping demarche.testgru.loire-atlantique.fr
```

3 - Installation avec le script automatique
----------------------------------------------------

```
ssh debian@54.38.136.168
sudo apt-get update
sudo apt-get install git
git clone --recurse-submodules https://github.com/departement-loire-atlantique/publik
cd publik
sudo ./sync-os.sh
cd ..
sudo mv publik /home/publik/
sudo chown publik:publik /home/publik/publik -R
```

Ce script installe les composants nécessaires, crée les certificats et un utilisateur "publik". Il peut être utilisé pour préparer le système à la première utilisation de Publik ou pour mettre à jour le système.

Il ajoute des éléments au bashrc de l'utilisateur publik afin de pouvoir bénéficier de commandes rapides (alias) de lancement de la GRU public (gru-up, gru-connect, gru-reset, ...). Voir le fichier publik.bash pour plus de détails.

> Note aux utilisateurs derrière un PROXY : Penser à installer les certificats dans le magasin de l'OS (/usr/local/share/ca-certificates) et déclarer le proxy dans la configuration docker (https://docs.docker.com/v1.13/engine/admin/systemd/#http-proxy)

4 - Démarrer publik
-------------------

> Attention : Afin que les modifications introduites par le script sync-os.sh soient bien prises en compte pour l'utilisateur publik, il est indispensable de bien se déconnecter et se reconnecter avant de continuer (mise à jour du bashrc et ajout d'un groupe à l'utilisateur publik pour avoir accès à docker).

Se connecter au serveur avec l'utilisateur "publik" et ouvrir le dossier publik créer par le script d'installation (sync-os.sh)
```
cd publik
```

Choisir le nom de votre environnement (ou laisser vide)
```
echo "ENV=test" >> .env
```

Choisir le nom du domaine ou sous domaine
```
echo "DOMAIN=testgru.loire-atlantique.fr" >> .env
```

Choisir l'email associé à cet environnement (login du compte administrateur par défaut, envoie des alertes, ...)
```
echo "EMAIL=xxx@loire-atlantique.fr" >> .env
```

Préparer l'environnement :
```
gru-build
gru-update
```

*gru-build* réalise une construction des conteneurs docker locaux.

*gru-update* téléchargement localement depuis dockerhub les conteneurs pré-construits.

Puis lancer l'environnement docker :
```
gru-up
```

Le premier démarrage dure environ 10 minutes. Le système s'arrête automatiquement en cas d'erreur sur n'importe quel service. Tant que le processus fonctionne, c'est que les opérations se déroullent bien.

Ouvrir un nouveau terminal (utilisateur "publik") pour finaliser la configureration de l'environnement Publik (Lance le mécanisme de cook, ce script bloque tant que le démarrage n'est pas prêt, donc aucun risque de le lancer trop tôt) :
```
gru-init
```

Le script *gru-init* configure les URLs des instances, le SSO avec authentic, crée le compte administrateur par défaut. Une fois terminé, la GRU doit être prête. Ce script est à exécuter uniquement au premier lancement de la GRU ou alors après un *gru-reset* qui remet l'environnement à zéro. Son exécution peut durer également jusqu'à 5 à 10 minutes.

Vérifier l'état de la GRU (A ce stade, tout doit être OK) :
```
gru-state
```

Les démarrages ultérieurs sont plus rapides, de l'ordre de 1 à 2 minutes. Il suffit alors d'invoquer uniquement la commande *gru-up* en étant dans le dossier publik.

Une fois l'installation terminée, les services de Publik sont disponibles aux URLs suivantes (Mot de passe administration par défaut 'pleasechange') :

| Service                       | URL                               |
| ----------------------------- | --------------------------------- |
| Combo (usagers)               | https://demarchesENV.DOMAIN       |
| Combo (agents).               | https://admin-demarchesENV.DOMAIN |
| Fargo (documents)             | https://documentsENV.DOMAIN       |      
| Authentic (identité et RBAC)  | https://compteENV.DOMAIN          |
| WCS (formulaires et WF)       | https://demarcheENV.DOMAIN        |
| Passerelle (middleware)       | https://passerelleENV.DOMAIN      |
| Hobo (deploiement).           | https://hoboENV.DOMAIN            |
| PgAdmin 4 (db web interface)  | http://pgadminENV.DOMAIN          |
| RabbitMQ (web interface)      | http://rabbitmqENV.DOMAIN         |
| Mail catcher (smtp trapper)   | http://webmailENV.DOMAIN          |

Les certificats étant long à générer, il sont stockés dans le dossier data qui n'est pas supprimé lors d'un appel à *gru-reset*. Au delà, le service let's encrypt limite ne nombre de génération de certificat par semaine (https://letsencrypt.org/docs/rate-limits/) ce qui pousse également à les conserver.

Si besoin, un alias permet de se connecter directement en bash sur une instance Docker en cours d'exécution. 
Pour celà utiliser la commande suivante (exemple pour hobo) :
```
gru-connect hobo
```

5 - Installation en local
----------------

> Attention : l'installation en local n'est possible que si votre machine est sous Debian Jessie. Ou alors sur une VM Debian Jessie fonctionnant sur votre machine. Au Département de Loire Atlantique, nous utilisons soit des VM ou alors des postes en dual boot avec Debian Jessie.

### Démarrer l'installation

L'installation est la même que pour un serveur (cf. au dessus).

On commence par faire les étapes "3 - Installation avec le script automatique".

### Récupération de certificats valides

Sur le poste local, impossible de générer un cerficat Let's Encrypt valide. Pour générer des certificats SSL valides, il est nécessaire de disposer d'une machine accessible depuis Internet et associée à un DNS.

#### Solution 1 - Récupération des certificats depuis une installation serveur

Si la GRU a déjà été installée sur un serveur, il est possible de récupérer les certificats pour les utiliser en local. Bien entendu, on préfera prendre les certificats d'un serveur de recette plutôt que de celui de production.

Copier depuis ce serveur le dossier publik/data en local au même emplacement sur votre machine.

#### Solution 2 - Lancement d'un serveur temporaire pour générer les certificats

Pour réaliser cette solution, il vous faut juste une machine accessible depuis internet et l'accès à la configuration DNS d'un domaine.

Créer un serveur chez OVH (VPS ou CLOUD), puis associer son IP à un domaine. 

Lancer l'installation (cf. dessus), jusqu'à étape *gru-build* incluse.

Lancer uniquement le proxy (Ce qui va entrainer la génération des certificats SSL) :
```
docker-compose -f docker-compose-local-certificates.yml up
```

Une fois les certificats générés, arrêter le container avec CRTL-C

Copier depuis ce serveur le dossier publik/data en local au même emplacement sur votre machine.

```
rsync -av user@server:/home/publik/publik/data .
```

### Finaliser l'installation en local

En supposant que vous ayez récupérer les certificats (dossier data) depuis une instance configuré sur *.testgru.loire-atlantique.fr et que l'IP de votre poste est 54.38.136.168.

> Attention, si vous utiliser une VM, il faut alors mettre l'IP de la VM.

Ajouter les entrées suivantes au fichier /etc/host de votre poste local
(Remplacer par l'IP de votre poste local ou de votre VM et le domaine 
dont est extrait le certificat) :
```
54.38.136.168       admin-demarches.testgru.loire-atlantique.fr
54.38.136.168       demarches.testgru.loire-atlantique.fr
54.38.136.168       compte.testgru.loire-atlantique.fr
54.38.136.168       hobo.testgru.loire-atlantique.fr
54.38.136.168       passerelle.testgru.loire-atlantique.fr
54.38.136.168       demarche.testgru.loire-atlantique.fr
54.38.136.168       documents.testgru.loire-atlantique.fr
54.38.136.168       pgadmin.testgru.loire-atlantique.fr
54.38.136.168       rabbitmq.testgru.loire-atlantique.fr
54.38.136.168       webmail.testgru.loire-atlantique.fr
```
> Il est important de mettre l'IP de son poste et non 127.0.0.1 car en pratique, la configuration /etc/hosts est répliquée vers chaque container. Celà permet quand un container fait un appel à xxx.testgru.loire-atlantique.fr que celui ci passe via le container proxy qui gère le HTTPS pour tous les services.

Puis terminer la procédure d'installation avec les étapes décrites au "4 - Démarrer publik" (cf. ci-dessus).

6 - Mise à jour
---------------

Un script update.sh est disponible et permet de mettre à jour une installation Publik.

Ce script possède 3 fonctionnalités :
 - Mise à jour des paquets (update.sh --update-packages)
 - Application des patchs personnalisés du Département de Loire Atlantique (update.sh --patch)
 - Déploiement du thème personnalisé du Département de Loire Atlantique (update.sh --update-theme)

7 - Commentaires
----------------

Ce dépôt représente un travail "en cours" et orienté vers des instances de recette ou de développements.

Pour une utilisation en production, voici ce qu'il resterait à faire :
- Possibilité de désactivé le mode DEBUG via une variable d'environnement (Tous les modules sont actuellement en mode DEBUG)
- Ajout d'un logger centralisé (SENTRY par exemple)
- Possibilité de générer lors de l'installation tous les mots de passes et secrets
- Configuration de l'envoi d'emails via une variable d'environnement (Actuellement capturés par le mailcatcher)
- Ajout de pages de maintenance personnalisées en cas de service indisponible (40x, 50x)
- Respect des précaunisations de DJANGO (https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/) en matière d'installation de production propre

ROADMAP :
- Possibilité de lancer les serveurs python en mode développement
- Possibilité de lancer un debugger python
- Ajout d'un mécanisme permettant de générer des patchs ou d'appliquer des paths

8 - Bibliographie
-----------------

En novembre 2017, les documentations accessibles en ligne étaient incomplètes, parfois incohérentes avec le code ou contradictoires entre elles. Par conséquent, l’installation des modules a été laborieuse. Ce dépôt docker résume une approche qui a fonctionné mais n'engage pas la société Entr'ouvert.

Documentations intéressantes à connaître :
- Guide pour les développeurs Publik : https://dev.entrouvert.org/projects/prod-eo/wiki
- Intégration continue des modules Publik : https://jenkins.entrouvert.org
- Documentation d’installation :
  - http://doc.entrouvert.org/publik-infra//installation.html
  - https://dev.entrouvert.org/projects/publik/wiki/InstallationJessie
  - http://doc.entrouvert.org/wcs/dev/
  - http://doc.entrouvert.org/auquotidien/dev/
  - https://dev.entrouvert.org/projects/prod-eo/wiki/Gestion_des_acc%C3%A8s
  - https://doc-publik.entrouvert.com/guide-de-l-administrateur-systeme/installation/haute-disponibilite/#pre-requis (Ajouté en février 2018)
- GitHub d’un syndicat mixte qui publie sous GitHub ses développements : https://github.com/IMIO/docker-teleservices

