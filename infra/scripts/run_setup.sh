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

# filebeat
declare -A filebeat
filebeat["name"]="filebeat"
filebeat["namespace"]="elk"
filebeat["logstashName"]=${logstash[name]}
filebeat["logstashPort"]=5044

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

# filebeat
echo "Deploying filebeat ..."

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
  ../charts/filebeat
