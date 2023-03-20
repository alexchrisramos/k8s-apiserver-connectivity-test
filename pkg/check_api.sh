#!/bin/bash

INTERNAL_APISERVER=https://kubernetes.default.svc
#EXTERNAL_APISERVER="https://oawbpr3k0udd1fsn11b0wtku3g12-k8s-821377833.us-west-2.elb.amazonaws.com:6443"
SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount
NAMESPACE=$(cat ${SERVICEACCOUNT}/namespace)
TOKEN=$(cat ${SERVICEACCOUNT}/token)
CACERT=${SERVICEACCOUNT}/ca.crt

while [ true ]
do
  date
  echo "Check ${INTERNAL_APISERVER}"
  curl -w "@curl_format.txt" -o /dev/null --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -s ${INTERNAL_APISERVER}/api
  echo "Check ${EXTERNAL_APISERVER}"
  curl -w "@curl_format.txt" -o /dev/null --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -s ${EXTERNAL_APISERVER}/api
  sleep 600
done
