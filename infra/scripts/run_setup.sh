#!/bin/bash

##################
### Apps Setup ###
##################

### Set variables

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
filebeat["namespaceToWatch"]="test"

# Random Logger
declare -A randomlogger
randomlogger["name"]="randomlogger"
randomlogger["namespace"]="test"

####################
### Build & Push ###
####################

# Random Logger
echo -e "\n--- Random Logger ---\n"
docker build \
  --tag "${DOCKERHUB_NAME}/${randomlogger[name]}" \
  "../../apps/randomlogger/."
docker push "${DOCKERHUB_NAME}/${randomlogger[name]}"
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
  --set httpPort=${logstash[httpPort]} \
  --set beatsPort=${logstash[beatsPort]} \
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

# Random Logger
echo "Deploying Random Logger ..."

helm upgrade ${randomlogger[name]} \
  --install \
  --wait \
  --debug \
  --create-namespace \
  --namespace ${randomlogger[namespace]} \
  --set dockerhubName=$DOCKERHUB_NAME \
  --set name=${randomlogger[name]} \
  --set namespace=${randomlogger[namespace]} \
  ../charts/randomlogger
