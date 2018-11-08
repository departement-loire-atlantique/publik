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

Puis lancer l'environnement docker :
```
cd publik
gru-up
```

Le premier démarrage dure environ 10 minutes. Le système s'arrête automatiquement en cas d'erreur. Tant que le processus fonctionne, c'est que les opérations se déroullent bien.

Ouvrir un nouveau terminal (utilisateur "publik") pour finaliser la configureration de l'environnement Publik (Lance le mécanisme de cook) :
```
gru-init
```

Le script *gru-init* configure les URLs des instances, le SSO avec authentic, crée le compte administrateur par défaut. Une fois terminé, la GRU doit être prête. Ce script est à exécuter uniquement au premier lancement de la GRU ou alors après un *gru-reset* qui remet l'environnement à zéro.

Vérifier l'état de la GRU:
```
gru-state
```

Les démarrages ultérieur sont plus rapide, de l'ordre de 1 à 2 minutes.

Une fois l'installation terminée, les services de Publik sont disponibles aux URLs suivantes (Mot de passe administration par défaut 'pleasechange') :

| Service                       | URL                       |
| ----------------------------- | ------------------------- |
| Combo (citizen)               | demarchesENV.DOMAIN       |
| Combo (employees              | admin-demarchesENV.DOMAIN |
| Fargo (documents)             | documentsENV.DOMAIN       |      
| Authentic (Identity provider) | compteENV.DOMAIN          |
| WCS (forms and workflows)     | demarcheENV.DOMAIN        |
| Passerelle (middleware)       | passerelleENV.DOMAIN      |
| Hobo (deployment admin)       | hoboENV.DOMAIN            |
| PgAdmin 4 (db web interface)  | pgadminENV.DOMAIN         |
| RabbitMQ (web interface)      | rabbitmqENV.DOMAIN        |
| Mail catcher (smtp trapper)   | webmailENV.DOMAIN         |


Les certificats étant long à générer, il sont stockés dans le dossier data qui n'est pas supprimé lors d'un appel à *gru-reset*. Au delà, letsencrypt limite ne nombre de génération de certificat par semaine (https://letsencrypt.org/docs/rate-limits/) ce qui pousse également à les conserver.

5 - Installation en local
----------------

Pour une installation en local, il est possible d'ajouter les 
entrées suivantes au fichier /etc/host plutôt que dans le DNS.
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
Avant le démarrage de la GRU en local avec *gru-up*, il récupérer le 
contenu du dossier data/ du projet d'une instance opérationnelle.
(Le dossier data contient les certificats signés)

6 - Commentaires
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
- Installation depuis le code source et non les dépôts DEBIAN
- Possibilité de lancer les serveurs python en mode développement
- Possibilité de lancer un debugger python

7 - Bibliographie
-----------------

En novembre 2017, les documentations accessibles en ligne étaient incomplètes, parfois incohérentes avec le code ou contradictoires entre elles. Par conséquent, l’installation des modules a été laborieuse. Ce dépôt docker résume une approche qui a fonctionné mais n'engage pas la société Entrouvert.

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

