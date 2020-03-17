#!/bin/bash

CHANGE=$1
OUTPUT=$2

sleep 120
# while [! -f ${OUTPUT}/output.xml]; do
#   sleep 5
# done

sed -i "${CHANGE}" ${OUTPUT}/output.xml
rebot --ProcessEmptySuite --noncritical ntrdy --noncritical jtst --log ${OUTPUT}/log.html --report NONE ${OUTPUT}/output.xml
rebot --ProcessEmptySuite --noncritical ntrdy --noncritical jtst --log NONE --report ${OUTPUT}/report.html ${OUTPUT}/output.xml
sed -i "s/\*Tests/\*HealthMatters/" ${OUTPUT}/log.html
sed -i "s/\*Tests/\*HealthMatters/" ${OUTPUT}/report.html

# sleep 5
# echo ${CHANGE}
# echo ${OUTPUT}
# while [! -f ${OUTPUT}/test2.txt]; do
#   sleep 5
# done
# ~/Documents/qa/RobotFrameworkServer/testdb
# "$(bash -c 'sleep 10')" &
# wait ttt
# bash -c 'sleep 10' &
# wait $!
#
# bash -c "sleep 1 &&
#   sleep 1 &&
#   sleep 1" &
#
# bash -c "sleep 2 &&
#   'while \[\! -f ~/Documents/qa/RobotFrameworkServer/testdb/test.txt\]\; do sleep 5 & done' &&
#   sleep 2" &
