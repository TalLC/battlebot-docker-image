# Positionnement dans le dossier source du serveur battlebots
cd $BATTLEBOTS_DIR

# Assignation du mode DEBUG
python ./third-party/set-debug.py debug=$BATTLEBOTS_DEBUG

# Lancement d'ActivMQ
nohup sh ./third-party/activemq/bin/activemq start > /var/log/activemq.log &

# Attendre 10 seconde
echo Laisser le temps à ActiveMQ de démarrer
sleep 10

# Lancement du serveur
echo Lancement du serveur
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload --timeout-keep-alive 30 2>&1 | tee /var/log/battlebots.log


