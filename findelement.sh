#!/bin/bash
#==================================================================================================================================
# Usage  : Script to with xmlparse.sh. Platfom: Linux
# Version: 1.0
# Date   : 21-03-2018
# Author : Sankar Mukherjee
#==================================================================================================================================
xml_schm=$1
xml_data=$2
script_home=$(cd $(dirname $0);pwd)

dstatus=$(echo $xml_schm | grep -q ","; echo $?)
if [ $dstatus -ne 0 ]
then
        echo $xml_data | grep -Po '(?<=<'$xml_schm'>).*(?=</'$xml_schm'>)'
else
        delim=$(echo $xml_schm | cut -d',' -f1)
        for i in $(echo $xml_data | sed 's/<'$delim'>/\n/g' | sed 's/<\/'$delim'>/ /g')
        do
                $script_home/findelement.sh "$(echo $xml_schm | cut -d',' -f2-)" "$i"
        done
fi