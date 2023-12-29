# qubic-hive

Intégration de Qubic dans un Custom Miner HiveOS

### Préparation HiveOS

Pour pouvoir exécuter le miner Quibic dans HiveOS, il faut faire une mise à jour partielle de Ubuntu.

Procédure que j'utilise:

> Flight sheet Unset
> 
> hive-replace --list
> 1
> 
> selfupgrade
> 
> apt update
> apt upgrade
> 
> echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
> apt update
> 
> apt install libc6
> 
> reboot

### Flight Sheet

Voici ma Flight Sheet:

![Flight Sheet](/img/FlightSheet1.png)

> Installation URL
>
> https://github.com/Akisoft41/qubic-hive/releases/download/v1.8.0/qubic-hive-1.8.0.tar.gz

Pour les oc, on peut mettre directement la commande "nvtool" dans l'Extra config arguments.
