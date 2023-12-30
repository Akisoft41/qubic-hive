# qubic-hive

Intégration de Qubic dans un Custom Miner HiveOS

## Préparation HiveOS

Pour pouvoir exécuter le miner Quibic dans HiveOS, il faut faire une mise à jour partielle de Ubuntu 18 vers la version 22.

Procédure que j'utilise:

```
Flight sheet Unset

hive-replace --list
1

selfupgrade

apt update
apt upgrade

echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
apt update

apt install libc6

reboot
```

Si vous n'utilisez plus le miner Quibic, il est conseillé de remettre une version officielle de HiveOS (de refaire un hive-replace).


## Flight Sheet

Voici ma Flight Sheet:

![Flight Sheet](/img/FlightSheet1.png)

Le script de démarrage prend les valeurs de la flight sheet pour compléter la config par défaut (appsettings_global.json).

#### Miner name

Ne pas modifier ce champ, il est rempli automatiquement avec l'installation URL.

#### Installation URL

`https://github.com/Akisoft41/qubic-hive/releases/download/v1.8.0/qubic-hive-1.8.0.tar.gz`

#### Hash algorithm:

Ce champ n'est pas utilisé, on peut laisser `----`

#### Wallet and worker template:

Nom du worker. Valeur de `"alias"` dans appsettings.json

#### Pool URL:

Valeur de `"baseUrl"` dans appsettings.json

#### Pass:

Pas utilisé

#### Extra config arguments:

Chaque ligne est fusionnée dans `appsettings.json`

Pour les oc, on peut mettre directement une ligne pour la commande `nvtool`

Il faut au minimum mettre une ligne `"payoutId": "_ton_payout_id"` ou `"accessToken": "_ton_access_token_"`



## Que contient l'archive qubic-hive-1.8.0.tar.gz ?

dans cette archive, j'ai développer 3 script bash : h-config.sh, h-run.sh et h-stats.sh

Il y a aussi le programme officiel de Qubic : qli-Client version 1.8.0

Ce projet est Open Source