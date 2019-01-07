# Patches

Afin de pouvoir corriger les erreurs constatées sans attendre la correction de l'éditeur Entr'ouvert ou personnaliser la solution Publik, un mécanisme de patch a été intégré au processus de mise à jour des serveurs.

La solution repose sur [quilt](https://wiki.debian.org/UsingQuilt), un outil pratique de [création et d'application de patchs](http://www.shakthimaan.com/downloads/glv/quilt-tutorial/quilt-doc.pdf)

Sommaire :
 - [Application d'un ou plusieurs patchs](#application-dun-patch)
 - [Nouveau patch](#nouveau-patch)

## Application d'un ou plusieurs patchs

Afin de simplifier l'application des patchs sur une installation, le script **update.sh** du projet [publik-docker-base](https://github.com/departement-loire-atlantique/publik-docker-base) a été mis au point.

Afin de simplement mettre à jour l'installation pour appliquer les dernier patches, utiliser la commande suivante :

```bash
update.sh --patches
```

Le script récupère les derniers patchs et les applique localement en tenant compte des patchs déjà appliqués et recompile automatiquement les modules python concernés.

## Nouveau patch

### Création d'un nouveau patch

Création d'un nouveau patch en respectant la convention de nommage :

```bash
cd /usr/lib/python2.7/dist-packages
quilt new nomdumodule+nomdupatch.diff
```

Exemple pour un patch relative au module authentic2_auth_oidc :

```bash
quilt new authentic2_auth_oidc+bearer.diff
```

Puis, on ajoute au patch les fichiers qui font être modifiés :

```bash
quilt add nomdumodule/../../fichiera.py
quilt add nomdumodule/../../fichierb.py
...
```

Exemple pour un patch relatif au fichier view.py du module authentic2_auth_oidc :

```bash
quilt add authentic2_auth_oidc/views.py
```

Puis, on édite les fichiers avec **quilt edit nomdumodule/../../fichier.py**

```bash
quilt edit authentic2_auth_oidc/views.py
```

Si plusieurs fichiers sont impactés dans le même module, il est possible de faire plusieurs edit pour le même patch. Attention, le script **update.sh** suppose qu'un patch ne concerne qu'un seul module. Tous les fichiers d'un patch doivent donc appartenir au même module.

Pour valider notre modification, il faut maintenant en faire la recette (recompilation du module python puis relance de la GRU) :

### Recompilation du module python

```bash
find nomdumodule -type f -name "*.pyc" -exec rm {} \;
python2.7 -m compileall nomdumodule 
```

Exemple :

```bash
find authentic2_auth_oidc -type f -name "*.pyc" -exec rm {} \;
python2.7 -m compileall authentic2_auth_oidc
```

### Relance des services

Exemple :

```bash
/opt/cg/tools/bin/cg_stop_gru.sh
/opt/cg/tools/bin/cg_start_gru.sh
```

ou

```bash
service nomduserviceutilisantlemodule restart
```

### Recette de la modification

Vérifier que les modifications apportées sont fonctionnelles et conformes aux attentes.

Si erreur, retour à l'étape ***quilt edit ...***

### Enregistrement du patch

Une fois la recette OK, le patch est généré avec la commande suivante :

```bash
quilt refresh
```

Puis, on pousse le patch vers le dépôt :

```bash
cd patches
git add nomdumodule+nomdupatch.diff
git commit -m "Explications utiles"
git push origin master
```

