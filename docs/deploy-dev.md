# Déploiement de développement

Merci de lire au préalable `docs/README.md`.

Suivre cette procédure pour déployer la version de **développement** des conteneurs
sur une machine **accessible depuis Internet**.

### Déclaration DNS

Les composants Django se connaissent entre eux via des noms de domaine, chacun
ayant la structure suivante : `<composant><ENV>.<DOMAIN>`

`ENV` est simplement un suffixe pour distinguer d'éventuelles multiples instances
de Publik (`test`, `dev`...).

Par exemple, le composant Combo aura pour adresse sur la machine
`monserveur.fr` : `combo.monserveur.fr` ou, par exemple, `combo-test.monserveur.fr`
avec `ENV=-test`.

Il faut donc faire pointer les domaines `*ENV.DOMAIN` vers la machine.

Des certificats Let's encrypt (Fournisseur de certificats HTTPS gratuits) seront automatiquement générés durant le processus d'installation. C'est pourquoi il est important que le serveur soit accessible depuis internet et que les enregistrement DNS ait été préalablement configurées avant de commencer.

Vous pouvez vérifier votre configuration DNS en réalisant un ping sur une adresse.

Exemple :

```
ping combo.monserveur.fr
```
