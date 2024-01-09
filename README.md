# qubic-hive

Intégration de Qubic dans un *Custom Miner* HiveOS

web : https://web.qubic.li/

wallet : https://wallet.qubic.li/

pool : https://app.qubic.li/public

miner : https://github.com/qubic-li/client?tab=readme-ov-file#download


## Préparation HiveOS

Pour pouvoir exécuter le miner Quibic dans HiveOS, il faut faire une mise à jour partielle de Ubuntu 18 vers Ubuntu 22.

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

`https://github.com/Akisoft41/qubic-hive/releases/download/v1.8.3/qubic-hive-1.8.3.tar.gz`

#### Hash algorithm:

Ce champ n'est pas utilisé, on peut laisser `----`

#### Wallet and worker template:

Nom du worker. Valeur de `"alias"` dans appsettings.json

#### Pool URL:

Valeur de `"baseUrl"` dans appsettings.json

`https://mine.qubic.li/` pour la pool `app.qubic.li`

#### Pass:

Pas utilisé.

#### Extra config arguments:

Chaque ligne est fusionnée dans `appsettings.json`

##### GPU
Pour les OC **GPU**, on peut mettre directement une ligne pour la commande `nvtool`

Il faut au minimum mettre une ligne `"payoutId": "_ton_payout_id"` ou `"accessToken": "_ton_access_token_"`

##### CPU
Pour le minage **CPU**, il faut ajouter une ligne `"amountOfThreads": n` (remplacer *n* par le nombre de threads)

Si vous utiliser la pool *"qubic.li GPU Mining"*, if faut ajouter `"allowHwInfoCollect": false`.


## Configuration par défaut

appsettings_global.json :

```
{
  "Settings": {
    "baseUrl": "https://mine.qubic.li/",
    "amountOfThreads": 0,
    "payoutId": null,
    "accessToken": null,
    "alias": "qubic.li Client",
    "allowHwInfoCollect": true,
    "overwrites": {"CUDA": "12"}
  }
}
```

Ce *Custom Miner* convient pour le minage par CPU ou par GPU.

Pour le minage GPU, le miner prend toutes les cartes disponibles.



## Que contient l'archive qubic-hive-1.8.2.tar.gz ?

dans cette archive, j'ai développer 3 script bash : h-config.sh, h-run.sh et h-stats.sh

Il y a aussi le programme officiel de Qubic : qli-Client


Ce projet est Open Source sous licience GPL-3.0-or-later

Copyright (C) 2023-2024 Pascal Akermann

