Ce projet a pour vocation de simplifier l'installation de la solution Publik de la société Entr'ouvert.

Il repose sur des conteneurs docker pré-compilés sur [Docker Hub](https://hub.docker.com/u/julienbayle).

1 - Pré-requis
--------------------------------------

Publik ne fonctionne qu'avec [Debian Stretch](https://deb.entrouvert.org/), le point de départ est donc de créer une machine avec cette distribution de Linux. Pour rapidement tester la solution, il est possible de l'installer sur un serveur Cloud d'OVH par exemple.

Caractéristiques minimales de la machine :
* Distribution : Debian 9
* 4Go de RAM 
* 10 Go de disque (20 Go recommandé)

2 - Déclarations DNS
------------------------------------------------------------

Configurer un sous domaine de type wildcard vers le serveur nouvellement créé.
Exemple : 
 * Type : A
 * Nom : *ENV.DOMAIN 
 * Serveur : IP_MACHINE

A la fin de l'installation, l'ensemble des modules de Publik seront accessibles depuis ces domaines.

Des certificats Let's encrypt (Fournisseur de certificats HTTPS gratuits) seront automatiquement générés durant le processus d'installation. C'est pourquoi il est important que le serveur soit accessible depuis internet et que les enregistrement DNS ait été préalablement configurées avant de commencer.

Vous pouvez vérifier votre configuration DNS en réalisant un ping sur une adresse.

Exemple :
```
ping demarche.testgru.loire-atlantique.fr
```

3 - Installation des pré-requis
-------------------------------

Afin de procéder simplement à l'installation, un script pratique pour linux a été réalisé.

Ce script installe les composants nécessaires, crée les certificats et un utilisateur "publik". 
Il peut être utilisé pour préparer le système à la première utilisation de Publik ou pour mettre à jour le système.

Il ajoute également des éléments au bashrc de l'utilisateur publik afin de pouvoir bénéficier de commandes rapides 
(alias) de lancement de la GRU public (gru-up, gru-connect, gru-reset, ...). 
Voir le fichier publik.bash pour plus de détails.

```
ssh USER_ROOT@IP_MACHINE
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/departement-loire-atlantique/publik
cd publik
sudo ./sync-os.sh
cd ..
sudo mv publik /home/publik/
sudo chown publik:publik /home/publik/publik -R
```

> Note aux utilisateurs derrière un PROXY : Penser à installer les certificats dans le magasin de l'OS 
(/usr/local/share/ca-certificates) et déclarer le proxy dans la configuration docker
(https://docs.docker.com/v1.13/engine/admin/systemd/#http-proxy).
Il est également possible d'utiliser "--insecure" pour sync-os afin de faire des appels curls sans 
vérification des certificats soit la commande complète "sudo ./sync-os.sh --insecure"

4 - Installation de Publik sur un serveur accessible depuis Internet (IP publique)
----------------------------------------------------------------------------------

> Attention : Afin que les modifications introduites par le script sync-os.sh soient bien prises en compte pour 
l'utilisateur publik, il est indispensable de bien se déconnecter et se reconnecter avant de continuer (mise à jour
 du bashrc et ajout d'un groupe à l'utilisateur publik pour avoir accès à docker).

Se connecter au serveur avec l'utilisateur "publik" et ouvrir le dossier publik créer par le script d'installation (sync-os.sh)
```
ssh publik@IP_MACHINE
cd publik
```

Procéder à la configuration des propriétés de votre instance :
 * DOMAIN : domaine DNS de l'environnement
 * ENV : suffixe appliqué aux noms des modules publik pour votre environnement (optionnel, peut être laissé vide). 
 En pratique, ces suffixes permettent d'installer plusieurs versions de la GRU sous le même domaine.
 Exemple d'URL pour le portail des démarches : https://demarcheENV.DOMAIN  
 * EMAIL : courriel compte administrateur principal

Les propriétés sont initialisées dans un fichier d'environnement nommé ".env" 
(Pour information : Le fichier .env est utilisé par docker-compose pour charger les variables d'environnement)
```
echo "DOMAIN=testgru.mondomaine.fr" >> .env
echo "ENV=test" >> .env
echo "EMAIL=xxx@loire-atlantique.fr" >> .env
```

Une fois les propriétés définies, il faut maintenant récupérer les conteneurs docker localement :
```
gru-build
gru-pull
```

*gru-build* réalise une construction des conteneurs docker pour postgresql et le proxy (nginx) à partir des 
définitions présentes dans le dossier "postgresql" et "proxy"

*gru-pull* télécharge localement depuis dockerhub les conteneurs pré-construits.

Puis lancer l'environnement docker :
```
gru-up
```

Le premier démarrage dure environ 10 minutes. Le système s'arrête automatiquement en cas d'erreur sur n'importe 
quel service. Tant que le processus fonctionne, c'est que les opérations se déroulent bien.

Ouvrir un nouveau terminal (utilisateur "publik") pour initialiser la configuration de l'environnement Publik
(mécanisme de cook). Ce script bloque tant que les modules ne sont pas prêt. Il n'y donc aucun risque de le lancer trop tôt :
```
gru-init
```
Le script *gru-init* configure les URLs des instances, le SSO avec authentic, crée le compte administrateur par défaut. Une fois terminé, la GRU doit être prête. Ce script est à exécuter uniquement au premier lancement de la GRU ou alors après un *gru-reset* qui remet l'environnement à zéro. Son exécution peut durer également jusqu'à 5 à 10 minutes.

Une fois que la commande précédente est terminée, vérifier l'état des modules Publik (Normalement, tout doit être OK) :
```
gru-state
```

Exemple de retour :
```
OK      Hobo agent OK for all services
OK      combo (https://demarches.test.com) has status 200
OK      combo_agent (https://admin-demarches.test.com) has status 200
OK      passerelle (https://passerelle.test.com) has status 200
OK      demarches-wcs (https://demarche.test.com) has status 200
OK      authentic (https://compte.test.com) has status 200
OK      fargo (https://documents.test.com) has status 200
OK      hobo (https://hobo.test.com) has status 200
OK      pgadmin (http://pgadmin.test.com/browser/) has status 200
OK      rabbitmanager (http://rabbitmq.test.com) has status 200
OK      rabbitmanager (http://webmail.test.com) has status 200
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

Les certificats étant longs à générer, il sont stockés dans le dossier data qui n'est pas supprimé lors d'un appel à *gru-reset*. Au delà, le service let's encrypt limite ne nombre de génération de certificat par semaine (https://letsencrypt.org/docs/rate-limits/) ce qui pousse également à les conserver.

Si besoin, un alias permet de se connecter directement en bash sur une instance Docker en cours d'exécution. 
Pour celà utiliser la commande suivante (exemple pour hobo) :
```
gru-connect hobo
```

> Attention, il existe deux manières d'arrêter la GRU. La commande *gru-stop* arrête la GRU tout en préservant l'état 
des conteneurs. Elle peut alors être redémarrée avec la commande *gru-start*. La commande *gru-down* supprime les 
conteneurs (Donc au redémarrage, il repartent de l'image et toutes les données sont préservées).

5 - Installation de Publik sur un poste local sans IP publique
--------------------------------------------------------------

### Installation des pré-requis

Si vous êtes sous linux réalisez les étapes du paragraphe "3 - Installation des pré-requis".

Si vous êtes sous Windows, installez GIT avec Git bash et Docker for Windows puis faite, sous Git bash :
```
git config --global core.autocrlf input
git clone https://github.com/departement-loire-atlantique/publik
cd publik
echo "source `pwd`/publik.bash" > ~/.profile
source ~/.profile
```

### Récupération de certificats valides

Sur le poste local, il est impossible de générer un cerficat Let's Encrypt valide. 
Pour générer des certificats SSL valides, il est nécessaire de disposer d'une machine accessible depuis Internet 
et associée à un DNS.

#### Solution 1 - Récupération des certificats depuis une installation serveur

Si la GRU a déjà été installée sur un serveur, il est possible de récupérer les certificats pour les utiliser en local. Bien entendu, on préfera prendre les certificats d'un serveur de recette plutôt que de celui de production.

Se connecter en root sur le serveur, puis :

```
sudo chown publik:publik /home/publik/publik/data -R
```

Copier depuis ce serveur le dossier publik/data et le fichier .env en local au même emplacement sur votre machine.

```
rsync -rLv publik@IP_MACHINE:/home/publik/publik/data .
rsync -v publik@IP_MACHINE:/home/publik/publik/.env .
```

#### Solution 2 - Lancement d'un serveur temporaire pour générer les certificats

Pour réaliser cette solution, il vous faut juste une machine accessible depuis internet et l'accès à la configuration DNS d'un domaine.

Exemple : 
 * Créer un serveur chez OVH (VPS ou CLOUD), puis associer son IP à un domaine. 
 * Lancer l'installation (cf. dessus, étape 3 et 4 jusqu'à étape *gru-build* incluse).
 * Lancer uniquement le proxy (Ce qui va entrainer la génération des certificats SSL) :
```
docker-compose -f docker-compose-local-certificates.yml up
```
 * Une fois les certificats générés, arrêter le conteneur avec CRTL-C
 * Copier depuis ce serveur le dossier publik/data et le fichier .env en local au même emplacement sur votre machine.

### Finaliser l'installation en local

Nous faisons dans ce chapitre l'hypothèse que vous avez récupéré les certificats (dossier data) 
depuis une instance configurée sur *ENV.DOMAIN et que l'IP de votre poste est IP_MACHINE.

> Attention, si vous utiliser une VM, il faut alors mettre l'IP de la VM et non celle du poste

Ajouter les entrées suivantes au fichier /etc/hosts de votre poste local (C:\windows\System32\drivers\etc\hosts sur Windows):
```
IP_MACHINE       admin-demarchesENV.DOMAIN
IP_MACHINE       demarchesENV.DOMAIN
IP_MACHINE       compteENV.DOMAIN
IP_MACHINE       hoboENV.DOMAIN
IP_MACHINE       passerelleENV.DOMAIN
IP_MACHINE       demarcheENV.DOMAIN
IP_MACHINE       documentsENV.DOMAIN
IP_MACHINE       pgadminENV.DOMAIN
IP_MACHINE       rabbitmqENV.DOMAIN
IP_MACHINE       webmailENV.DOMAIN
```

Puis copier le fichier */etc/hosts* dans le dossier *data*.

> Il est important de mettre l'IP de son poste et non 127.0.0.1 car en pratique les conteneurs pour parler à l'hôte via la couche TCP/IP doivent connaitre l'IP de la machine hôte (Depuis un conteneur, 127.0.0.1 revient à se parler à lui-même et non à l'hôte)

Puis terminer la procédure d'installation avec les étapes décrites au "4 - Démarrer publik" (cf. ci-dessus) 
avec Git bash sous Windows et bash sous linux. Ce qui revient, en simplifiant (*gru-up* réalise automatiquement 
un *gru-build* et un *gru-pull* ), à faire la commande suivante :
```
gru-up
```

Puis ouvrir un nouveau bash :

```
gru-init
```

Attendre quelques minutes que l'installation se termine. Une fois que la commande *gru-init* terminée, 
vérifier l'état des modules Publik (Normalement, tout doit être OK) :
```
gru-state
```

C'est prêt, il n'y a plus qu'à configurer l'instance à votre guise.

6 - Mise à jour et installation de compléments
----------------------------------------------

## 6.1 - Mise à jour ou installataion de complément dans un conteneur d'un module Publik

Un script update.sh (présent dans le dossier 'base' du dépôt Git) est disponible dans chaque image (dossier */root/*) et simplifie l'installation de complément ou à la mise à jour d'un conteneur Publik.

Pour lancer ce script, la GRU doit être up.

Ce script possède 4 fonctionnalités :
 - Mise à jour des paquets éditeur (Exemple : ```docker-compose exec authentic /root/update.sh --update-packages```). Peut être utile pour mettre à jour un conteneur d'un module Publik sans avoir à le reconstruire à partir d'une image mise à jour (Exemple : Le conteneur contient un module installé manuellement et en cours de test).
 - Application des patchs personnalisés du Département de Loire Atlantique (Exemple : ```docker-compose exec authentic /root/update.sh --patch```)
 - Déploiement du thème personnalisé du Département de Loire Atlantique (Exemple : ```docker-compose exec authentic /root/update.sh --update-theme```)
 - Déploiement des applications Django (extensions Publik) du Département de Loire-Atlantique (Exemple : ```docker-compose exec authentic /root/update.sh --update-apps```)

Pour lancer ces 4 opérations d'un seul coup, utiliser :  update.sh --all

Exemple pour le module *combo* : ```docker-compose exec combo /root/update.sh --all```

Pour lancer une opération sur tous les modules, utiliser gru-update --operation. Exemple :
```
gru-update --all
```

## 6.2 - Mise à jour des certificats

Le renouvellement des certificats se fait en se connectant sur l'instance proxy et en lançant certbot (A faire régulièrement) :

```
gru-connect proxy
certbot renew
```

> Attention, cette commande ne peut être utilisée que sur un serveur disposant d'une IP publique.

## 6.3 - Mise à jour des images 

Afin de mettre à jour les images de référence avec la dernière version de l'éditeur, procéder comme suit :

```
docker-compose build --no-cache
```

> Pour information, cette commande s'exécute en 10 à 15 minutes.

ou pour mettre à jour un seul module :
```
docker-compose build --no-cache fargo
```

Puis, pour mettre à jour les images dans docker hub, procéder comme suit :

```
docker push julienbayle/publik:latest-authentic
docker push julienbayle/publik:latest-base
docker push julienbayle/publik:latest-combo
docker push julienbayle/publik:latest-fargo
docker push julienbayle/publik:latest-hobo
docker push julienbayle/publik:latest-passerelle
docker push julienbayle/publik:latest-pgsql
docker push julienbayle/publik:latest-proxy
docker push julienbayle/publik:latest-wcs
```

ou 

```
gru-push-all latest
```


Ensuite pour mettre à jour l'instance Publik locale, procéder comme suit :

```
gru-down
gru-up
```

Si l'on souhaite pouvoir conserver une version particulière des images, avant de les mettre à jour (exemple : dernière version en production), il est possible de tagguer une version pour la conserver :

```
gru-tag-all latest prod
gru-push-all prod
```

7 - Installation sans docker
----------------------------

Sans que ce soit ni recommandé, ni une fonction importante de ce dépôt, un script permet de convertir les paquets docker en un script unique d'installation "sans docker". En pratique, ce script en python convertit les *Dockerfile* en script *bash*.

Utilisation : ``` docker2shell.py ```

Le résultat de l'éxécution est un dossier nommé "shellinstall" contenant tous les fichiers de configuration + 1 script *install.sh* permettant d'installer tous les modules Publik en mode barebone. Le détail de l'installation sur un serveur local à partir de ces fichiers est disponible sur demande auprès de l'équipe du Département de Loire-Atlantique.

8 - Commentaires
----------------

Ce dépôt représente un travail "en cours" et orienté vers des instances de recette ou de développement.

Pour une utilisation en production, voici ce qu'il resterait à faire :
- Désactivation du mode DEBUG via une variable d'environnement (Tous les modules sont actuellement en mode DEBUG)
- Ajout d'un logger centralisé (SENTRY par exemple)
- Possibilité de générer lors de l'installation tous les mots de passes et secrets
- Configuration de l'envoi d'emails via une variable d'environnement (Actuellement capturés par le mailcatcher)
- Ajout de pages de maintenance personnalisées en cas de service indisponible (40x, 50x)
- Respect des précaunisations de DJANGO (https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/) en matière d'installation de production propre

ROADMAP :
- Possibilité de lancer les serveurs python en mode développement
- Possibilité de lancer un debugger python

9 - Bibliographie
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

9 - FAQs
----------------

[Foire Aux Questions](FAQ.md)
