#!/bin/bash
#==================================================================================================================================
# Usage  : Script to parse XML file using schema.txt file, should be present in same directory. Platfom: Linux
# Version: 1.0
# Date   : 21-03-2018
# Author : Sankar Mukherjee
#==================================================================================================================================

## Command Line Argument
if [ $# -ne 2 ] ; then
        echo "ERROR: You need to pass two argument [XML SCHEMA] [XML FILE]."
        exit 1
fi
xml_schema=$1
xml_file=$2

## Environment Setup
script_home=$(cd $(dirname $0);pwd)
[ ! -f $xml_file ] && ( echo "ERROR: XML file absent!!!" ; exit 1)
[ ! -d ${script_home}/tmp ] && mkdir ${script_home}/tmp
rm -f ${script_home}/tmp/*tmp.*

raw_data=$(cat $xml_file | tr "\n" " " | sed 's/><\//>-<\//g')

## Main
for data_schm in $(echo $xml_schema | tr ";" "\n")
do
        tmp_file=${script_home}/tmp/$(echo $data_schm | tr ',' '_')_tmp.$$   
        if [ $(echo $data_schm | grep -q ","; echo $?) -eq 0 ] ; then
                echo "$data_schm" | awk -F"," '{ print $NF }' | tr [a-z] [A-Z] > $tmp_file
        else
                echo "$data_schm" | tr [a-z] [A-Z] > $tmp_file
        fi
        ${script_home}/findelement.sh "$data_schm" "$raw_data" >> $tmp_file
done
printf "\n"
maxnum=10
for filenm in $(ls ${script_home}/tmp/*tmp.*)
do
        [ $(wc -L $filenm | awk '{ print $1 }') -gt $maxnum ] && maxnum=$(wc -L $filenm | awk '{ print $1 }')
done
maxnum=$(expr $maxnum + 5)
paste ${script_home}/tmp/*tmp.* | expand -t $maxnum
printf "\n"
rm -rf ${script_home}/tmp/
