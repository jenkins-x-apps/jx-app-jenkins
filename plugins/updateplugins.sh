#!/bin/sh

echo "updating the plugins to the latest verions"
#updatebot pull -k plugins

echo "adding plugins to ../jx-app-jenkins/values.schema.json"

filename="plugins.txt"

while read p; do
   pluginstxt=$pluginstxt\"$p\",
done < $filename

# trim the trailing ,
pluginstxt=`echo $pluginstxt | sed 's/.$//'`

sed "s/\"PLUGINS_INJECTED_HERE\"/${pluginstxt}/" ../jx-app-jenkins/values.schema.tmpl.json > \
  ../jx-app-jenkins/values.schema.json