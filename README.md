Ce projet a pour vocation de configurer rapidement un environnement pour tester la solution
Publik de la société entrouvert.

La solution repose sur des containers docker.

Publik ne fonctionne qu'avec Debian Jessie, le point de départ est donc de créer une machine avec cette distribution de Linux. A titre d'exemple, la procédure est illustrée avec l'offre Cloud de l'hébergeur OVH.

1 - Creation du serveur
--------------------------------------

Se connecter au manager OVH (Créer un compte si nouveau client)

Aller dans la rubrique "Cloud"

Créer un projet cloud (Etape à réaliser uniquement la première fois)
* Bouton Commander => Projet Cloud

Ajouter un serveur à un projet cloud
* Ouvrir le projet (via le menu Gauche) puis le sous menu "Infrastructure"
* Menu Actions => Ajouter un serveur
** Localisation : France
** Distribution : Debian 8
** Instance : Choisir tout type d'instance avec un minimum de 4Go 
   de RAM et 20Go de disque (l'instance S1-4 est suffisante). 
   Le démarrage de tous les services de public consomme jusqu'à 
   4Go de RAM lors de l'installation.
* Ajouter la clé du poste pouvant se connecter au serveur
* Une fois le serveur prêt, l'accès à la machine est proposé. 
  Exemple : ssh debian@54.38.136.168

2 - Déclarer des enregistrements DNS pour cette installation
------------------------------------------------------------

Configurer un sous domaine vers le serveur nouvellement créé.
Exemple : *.testgru.loire-atlantique.fr => 54.38.136.168

3 - Installation du noeud avec le script automatique
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

Ce script installe les composants nécessaires et crée un utilisateur "publik". Il peut être utilisé pour préparer le système à la première utilisation de Publik ou pour mettre à jour le système.

Il ajoute des éléments au bashrc de l'utilisateur publik afin de pouvoir bénéficier de commandes rapides (alias) de lancement de la GRU public (gru-up, gru-connect, gru-reset, ...). Voir le fichier publik.bash pour plus de détails.

4 - Démarrer publik
-------------------

Se connecter au serveur avec l'utilisateur "publik" et ouvrir le dossier publik créer par le script d'installation (sync-os.sh)
```
cd publik
```

Choisir le nom de votre environnement (ou laisser vide)
```
export ENV=test
```

Choisir le nom du domaine ou sous domaine
```
export DOMAIN=testgru.loire-atlantique.fr
```

Puis lancer l'environnement docker :
```
gru-up
```

Publik et ses services associés sont alors disponibles aux URLs suivantes :

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

Afin de simplifier les lancements ultérieur, la configuration de la variable d'environnement ENV et DOMAIN peuvent être ajouté manuellement au .bashrc de l'utilisateur publik

5 - Commentaires
----------------

Ce dépôt représente un travail "en cours", les points suivants ne sont pas implémentés :
- Possibilité de désactivé le mode DEBUG (Tous les modules sont actuellement en mode DEBUG)
- Ajout d'un logger centralisé (SENTRY par exemple)
- Possibilité de générer lors de l'installation tous les mots de passes et secrets
- Configuration de l'envoi d'emails
- Pages de maintenance personnalisées en cas de service indisponible (40x, 50x)
- Respect des précaunisations de DJANGO (https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/) en matière d'installation de production propre
- Installation depuis le code source et non les dépôts DEBIAN
- Lancement des serveurs python en mode développement
