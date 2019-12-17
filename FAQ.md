Foire Aux Questions
===================

Comment résoudre l'erreur ```standard_init_linux.go:211: exec user process caused "no such file or directory"```
----------------------------------------------------------------------------------------------------------------

Cette erreur survient sur Docker Windows lorsque la configuration Git **core.autocrlf** est de type *Checkout Windows-style, commit Unix-style*. Pour pouvoir utiliser Git Bash et les images Docker de Publik, il faut configurer Git en mode *Checkout as-is, commit Unix-style* : ```git config --global core.autocrlf input```

En effet, en mode CRLF, les fichiers bash ne sont pas reconnus sous linux.

Comment résoudre un échec de compilation d'une image ?
------------------------------------------------------

Exemple d'erreur :

```
Les paquets suivants contiennent des dépendances non satisfaites :
 fargo : Dépend: python3-fargo (= 0.33-1~eob90+1) mais ne sera pas installé
```

On repère l'étape du Dockerfile qui pose souci, exemple :

```
Step 3/12 : RUN apt-get update && apt-get -t stretch-backports install -y python3-django python3-django-mellon && apt-get install -y --no-install-recommends postgresql-fargo && rm -rf /var/lib/apt/lists/*
 ---> Running in 73546f969521
```

Puis on exécute une console dans l'image correspondant à cette étape :
```
docker run -it 73546f969521 /bin/bash
```

On relance la ligne de commande qui a échouée :
```
apt-get update && apt-get -t stretch-backports install -y python3-django python3-django-mellon
```

Dans ce  précis il manque la dépendance `python3-django-filters` de *stretch-backports*, on l'installe pour vérifier que ça fonctionne :
```
apt-get -t stretch-backports install -y python3-django-filters
```

Puis on corrige la ligne dans le Dockerfile en ajoutant le packet manquant :
```
apt-get -t stretch-backports install -y python3-django python3-django-mellon python3-django-filters \
```