#!/bin/bash

# fifteen replicas
nrep=15 

# "effective" temperature range
tmin=298 
tmax=370 

# build geometric progression
list=$(
awk -v n=${nrep} \
    -v tmin=${tmin} \
    -v tmax=${tmax} \
    'BEGIN{for(i=0;i<n;i++){
     t=tmin*exp(i*log(tmax/tmin)/(n-1));
     printf(t); if(i<n-1)printf(",");
    }
    }'
)

for((i=0;i<nrep;i++))
do
    # choose lambda as T[0]/T[i]
    lambda=$(echo ${list[@]} | awk 'BEGIN{FS=",";}{print $1/$'$((i+1))';}')

    # process topology
    echo ${lambda}
    plumed partial_tempering ${lambda} < topol_processed.top > R${i}/topol.top
done
