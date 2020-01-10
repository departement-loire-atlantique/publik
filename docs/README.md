# Documentation

Ce projet facilite l'installation du logiciel Publik de la société Entr'ouvert
en mettant ses composants sous forme de conteneurs Docker déployés avec Docker Compose.

## Architecture de Publik

Nous résumons ici l'architecture de Publik mais conseillons évidemment de lire
la [documentation officielle](https://doc-publik.entrouvert.com/guide-de-l-administrateur-systeme/).

Publik est composé de briques de plusieurs types :

* Django. Les composants fournissant les fonctionnalités à proprement parler sont chacun des projets Django classiques. Ces applications sont lancées via des services système.
* PostgreSQL. Chaque composant Django a sa propre base de données. Toutes sont stockées sur une même instance PostgreSQL.
* RabbitMQ. Les composants Django communiquent via un serveur RabbitMQ.
* Nginx. Un serveur web fait office de proxy, c'est-à-dire de point d'entrée HTTP redirigeant les requêtes vers chaque composant Django.

Publik ne fonctionne que sous Debian 9. PostgreSQL, RabbitMQ et Nginx sont installés
via les paquets officiels tandis que des paquets Debian sont créés pour chaque composant
Django.

Les composants Django sont démarrés via des services système.

## Mise en conteneurs

Naturellement, nous attribuons à chaque composant une image Docker, puis gérons
la connectivité avec Docker Compose.

Tous les composants Django nécessitent Debian 9 et partagent des dépendances,
des configurations et des utilitaires communs. Ainsi, une image de base a été créée.

Toutes les images de composant Django ont une architecture similaire :

* Un `Dockerfile` héritant de l'image de base, installant des dépendances spécifiques au composant et copiant les divers scripts et fichiers de configuration dans les bons dossiers.
* Un fichier `*.py` comportant une extension du fichier `settings.py` de Django.
* Un `nginx.template` comportant les règles du proxy spécifiques au composant.
* Un `start.sh` appelé au démarrage du conteneur
* Un `stop.sh` TODO

Le `start.sh` fait dans les grandes lignes trois types de tâches :

* Attendre que les composants dont on dépend aient démarré
* Substituer les variables d'environnement par leurs valeurs dans les scripts et les fichiers de configuration
* Démarrer le service système

La substitution des variables d'environnement se fait par exemple dans le fichier
`nginx.template`. Comme on ne peut lire directement la valeur de la variable
d'environnement (par exemple de `$DOMAIN`), son nom est écrit à la place de la valeur
(ex : `server_name compte${ENV}.${DOMAIN};`) puis sera substitué par la commande
`envsubst`. Les fichiers comportant des noms de variables à substituer ont pour
extension `.template`. Comme la valeur des variables d'environnement peut changer
d'une exécution à l'autre, il est important de conserver le modèle d'origine et
de ne pas faire une substitution en place.

TODO : env vars unavailable in services

## Déploiement

### Pré-requis

Un script d'installation des dépendances est fourni mais suppose que la machine
est de type Debian ou dérivée. Dans le cas contraire, vous pouvez consulter le
script `sync-os.sh` et reproduire les commandes en les adaptant pour votre système.

Caractéristiques minimales de la machine :

* 4Go de RAM
* 10 Go de disque (20 Go recommandé)

### Installation

```bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/Vayel/publik.git
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

Pour la suite, se référer à :

* `docs/deploy-local.md` pour une installation sur une machine **non accessible** depuis Internet
* `docs/deploy-dev.md` pour une installation de développement sur une machine **accessible** depuis Internet
* `docs/deploy-prod.md` pour une installation de production sur une machine **accessible** depuis Internet
