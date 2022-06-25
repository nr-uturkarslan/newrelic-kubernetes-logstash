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
