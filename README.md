# battlebot-docker-image

## Build de l'image Docker
Pour construire l'image Docker à partir du Dockerfile, utilisez la commande `docker build` :

```sh
docker build -t battlebots:0.5.1 .
```

## Sauvegarde de l'image sous forme de fichier
Pour exporter l'image Docker en tant que fichier tar, utilisez la commande `docker save` :

```sh
docker save -o battlebots.tar battlebots:0.5.1
```


## Chargement du fichier image
Pour importer une image Docker à partir d'un fichier tar, utilisez la commande `docker load` :

```sh
docker load -i battlebots.tar
```

## Démarrage d'un conteneur en ligne de commande
Pour démarrer un conteneur à partir de l'image Docker, utilisez la commande `docker run` :

```sh
docker run -d --rm -p 8000:8000 -p 61613:61613 -p 1883:1883 battlebots:0.5.1
```

Explication des options utilisées :
- -d : Détache le conteneur et le fait s'exécuter en arrière-plan.
- -p 8000:8000 : (serveur web + REST) Mappe le port local 8000 sur le port 8000 du conteneur.
- -p 61613:61613 : (serveur STOMP) Mappe le port local 61613 sur le port 61613 du conteneur.
- -p 1883:1883 : (serveur MQTT) Mappe le port local 1883 sur le port 1883 du conteneur.
- battlebots:0.5.1 : Spécifie le nom et le tag de l'image à utiliser pour démarrer le conteneur.


## Démarrage d'un conteneur avec docker compose
Pour démarrer un conteneur en utilisant docker compose :

- Créez un fichier nommé `docker-compose.yml` dans un répertoire de votre choix :

```yml
version: '3'
services:
  battlebots:
    image: battlebots:0.5.1
    ports:
      - 8000:8000
      - 61613:61613
      - 1883:1883
    environment:
      - BATTLEBOTS_DEBUG=false
```

- Placez-vous dans le répertoire où se trouve le fichier `docker-compose.yml`
- Exécutez la commande suivante pour démarrer le conteneur en utilisant Docker Compose :

```sh
docker-compose up -d
```

Explication des options utilisées :
- -d : Détache le conteneur et le fait s'exécuter en arrière-plan.



## Debug

Pour activer le mode débug, passer la variable d'environnement `BATTLEBOTS_DEBUG` à `true`.

En ligne de commande :

```sh
docker run -d --rm -p 8000:8000 -p 61613:61613 -p 1883:1883 -e BATTLEBOTS_DEBUG=true battlebots:0.5.1
```

Dans le fichier `docker-compose.yml`
```yml
    ...
    environment:
      - BATTLEBOTS_DEBUG=true
```

