# Base du docker avec alpine et une version de python 3.10
FROM python:3.10.11-alpine3.17

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# Mise à disposition des ports utiles pour l'utilisation de battlebots
EXPOSE 8000 61613 1883

# Mise à jours d'apk
RUN apk update


#---------------------------------------------------------------------------------#
                           ### Installation de Java ###

# Recherche du répertoire source de java
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home

# Déclaration des variables d'environnement JAVA home
ENV JAVA_HOME $(docker-java-home)
ENV PATH $PATH:$JAVA_HOME/jre/bin:$JAVA_HOME/bin

# Installation de la version de JAVA nécéssaire.
RUN set -x && apk add --no-cache openjdk8-jre


#---------------------------------------------------------------------------------#
                    ### Installation des librairies python ###

# Installation de curl et de jq
RUN apk add curl jq

# Définition des variables pour récupération des sources git
ENV GIT_TOKEN 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

# Définition des variables d'environnements battlebots
ENV BATTLEBOTS_DEBUG false
ENV BATTLEBOTS_DIR /opt/battlebots-server

# Récupération du script de récupération d'assets git
COPY ./ressources/get_github_assets.sh /opt

# Récupération de l'assets battlebot, dezippage du répertoire serveur et suppression des fichier inutile
RUN ./opt/get_github_assets.sh $GIT_TOKEN TalLC/battlebot battlebots-server-package.zip latest && rm /opt/get_github_assets.sh 
RUN unzip battlebots-server-package.zip -d $BATTLEBOTS_DIR && \
	rm -rf $BATTLEBOTS_DIR/*.bat \
			$BATTLEBOTS_DIR/third-party/jre* \
			$BATTLEBOTS_DIR/third-party/python* \
			battlebots-server-package.zip

# Intallation de librairies nécessaire pour battlebots
RUN apk add build-base geos-dev && pip install -U pip && pip install -r $BATTLEBOTS_DIR/requirements.txt && rm $BATTLEBOTS_DIR/requirements.txt


#---------------------------------------------------------------------------------#
                      ### Lancement du serveur battlebots ###
COPY ./ressources/start-server.sh $BATTLEBOTS_DIR

ENTRYPOINT ["sh", "-c", "$BATTLEBOTS_DIR/start-server.sh"]

