#!/bin/bash

for subscript in $(az account list | jq -r '.[] | {name} | join(",")')
do
   for webapp_info in $(az webapp list --subscription ${subscript} | jq -r '.[] | {name,resourceGroup} | join(",")')
   do  
      webapp=$(echo $webapp_info | cut -d\, -f1)
      rg=$(echo $webapp_info | cut -d\, -f2)
      for webjob in $(az webapp webjob continuous list --name ${webapp} --resource-group ${rg} --subscription ${subscript} | jq -r '.[] | {name} | join(",")' | cut -d\/ -f2)
      do
          echo "$subscript,$rg,$webapp,$webjob"
          # az webapp webjob continous stop --name ${webapp} --resource-group ${rg} --webjob-name ${webjob} --subscription ${subscript}
          # az webapp webjob continous start --name ${webapp} --resource-group ${rg} --webjob-name ${webjob} --subscription ${subscript}
      done
    done
done