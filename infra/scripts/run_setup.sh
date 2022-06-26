#!/bin/bash

##################
### Apps Setup ###
##################

### Set variables

# New Relic Logs API
newRelicLogsApi="https://log-api.eu.newrelic.com/log/v1"

# Logstash
declare -A logstash
logstash["name"]="logstash"
logstash["namespace"]="elk"
logstash["httpPort"]=9600
logstash["beatsPort"]=5044

# Filebeat
declare -A filebeat
filebeat["name"]="filebeat"
filebeat["namespace"]="elk"
filebeat["logstashName"]=${logstash[name]}
filebeat["logstashPort"]=5044
filebeat["namespaceToWatch"]="apps"

# Bash Logger
declare -A bashlogger
bashlogger["name"]="bashlogger"
bashlogger["namespace"]=${filebeat[namespaceToWatch]}

# Java Logger
declare -A javalogger
javalogger["name"]="javalogger"
javalogger["namespace"]=${filebeat[namespaceToWatch]}
javalogger["port"]=8080

####################
### Build & Push ###
####################

# Logstash
echo -e "\n--- Logstash ---\n"
docker build \
  --tag "${DOCKERHUB_NAME}/${logstash[name]}" \
  "../../apps/logstash/."
docker push "${DOCKERHUB_NAME}/${logstash[name]}"
echo -e "\n------\n"

# Bash Logger
echo -e "\n--- Bash Logger ---\n"
docker build \
  --tag "${DOCKERHUB_NAME}/${bashlogger[name]}" \
  "../../apps/bash/."
docker push "${DOCKERHUB_NAME}/${bashlogger[name]}"
echo -e "\n------\n"

# Java Logger
echo -e "\n--- Java Logger ---\n"
docker build \
  --tag "${DOCKERHUB_NAME}/${javalogger[name]}" \
  "../../apps/java/."
docker push "${DOCKERHUB_NAME}/${javalogger[name]}"
echo -e "\n------\n"

###########
### ELK ###
###########

# Logstash
echo "Deploying Logstash ..."

helm upgrade ${logstash[name]} \
  --install \
  --wait \
  --debug \
  --create-namespace \
  --namespace ${logstash[namespace]} \
  --set name=${logstash[name]} \
  --set namespace=${logstash[namespace]} \
  --set dockerhubName=$DOCKERHUB_NAME \
  --set httpPort=${logstash[httpPort]} \
  --set beatsPort=${logstash[beatsPort]} \
  --set newRelicLicenseKey=$NEWRELIC_LICENSE_KEY \
  --set newRelicLogsApi=$newRelicLogsApi \
  ../charts/logstash

# Filebeat
echo "Deploying Filebeat ..."

helm upgrade ${filebeat[name]} \
  --install \
  --wait \
  --debug \
  --create-namespace \
  --namespace ${filebeat[namespace]} \
  --set name=${filebeat[name]} \
  --set namespace=${filebeat[namespace]} \
  --set logstashName=${filebeat[logstashName]} \
  --set logstashPort=${filebeat[logstashPort]} \
  --set namespaceToWatch=${filebeat[namespaceToWatch]} \
  ../charts/filebeat

############
### Apps ###
############

# Bash Logger
echo "Deploying Bash Logger ..."

helm upgrade ${bashlogger[name]} \
  --install \
  --wait \
  --debug \
  --create-namespace \
  --namespace ${bashlogger[namespace]} \
  --set dockerhubName=$DOCKERHUB_NAME \
  --set name=${bashlogger[name]} \
  --set namespace=${bashlogger[namespace]} \
  ../charts/bash

# Java Logger
echo "Deploying Java Logger ..."

helm upgrade ${javalogger[name]} \
  --install \
  --wait \
  --debug \
  --create-namespace \
  --namespace ${javalogger[namespace]} \
  --set dockerhubName=$DOCKERHUB_NAME \
  --set name=${javalogger[name]} \
  --set namespace=${javalogger[namespace]} \
  ../charts/java