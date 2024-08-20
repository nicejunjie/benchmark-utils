#!/bin/bash

QUEUE="gg"
QLIMIT=40

 nodes=`cat hostlist`

 [ -e waitlist ] && rm waitlist

checkjob() {
 njobs=`squeue -u $USER -p "$QUEUE"|tail -n +2|wc -l`
 echo checkjob: njobs=$njobs
}


nl=`cat hostlist|wc -l`

iter=0

while [ $nl -gt 0 ]; do

  ((iter++))
  echo "doing iteration $iter, hostlist size $nl"
  for nodeid in `echo $nodes`; do
    while : ; do
      checkjob
      echo njobs=$njobs
      if [ "$njobs" -lt "$QLIMIT" ]; then
        status=`sinfo  -n $nodeid|grep "$QUEUE "|awk '{print $5}'` 
        if [ "$status" == "idle" ]; then
          echo $nodeid submitted
          sbatch --nodelist=$nodeid run.sh
          break
        else 
          echo $nodeid \($status\) to waiting list
          echo $nodeid >>waitlist
          break
        fi  
      else 
        echo "wait 30s to submit $nodeid, currently $njobs are running"
        sleep 30
      fi  
    done
  done

  mv waitlist hostlist
  nodes=`cat hostlist`
  nl=`cat hostlist|wc -l`

  sleep 30

done #while

