#!/bin/bash

LABEL=WR00L2L2


for i in `seq 1 45`; do printf "="; done; echo
echo "           HPL in TFLOPS"
for i in `seq 1 45`; do printf "-"; done; echo
printf "%-10s %10s %10s %12s\n" "NodeID" "Best" "Worst" "Variation"
for i in `seq 1 45`; do printf "-"; done; echo

best_flop_bestest=0
best_flop_worst=999999
all_flop_bestest=0
all_flop_worst=999999

for file in hpl*.out; do
    nodeid=`echo $file|cut -d'-' -f2,3|cut -d'.' -f1`

    best_flop=`grep $LABEL $file|sort -k7 -nr|head -1|awk '{printf "%10.3f\n", $NF/1000}'`
    worst_flop=`grep $LABEL $file|sort -k7 -n|head -1|awk '{printf "%10.3f\n", $NF/1000}'`
    variation=$(echo $best_flop  $worst_flop |awk '{printf "%5.2f%\n", ($1-$2)/$1*100}')

    if (( $(echo "$best_flop > $best_flop_bestest" | bc -l) )); then
        best_flop_bestest=$best_flop
    fi

    if (( $(echo "$best_flop < $best_flop_worst" | bc -l) )); then
        best_flop_worst=$best_flop
    fi

    if (( $(echo "$best_flop > $all_flop_bestest" | bc -l) )); then
        all_flop_bestest=$best_flop
    fi

    if (( $(echo "$worst_flop < $all_flop_worst" | bc -l) )); then
        all_flop_worst=$worst_flop
    fi


    printf "%-10s %10s %10s %10s\n" $nodeid $best_flop $worst_flop $variation

    
done


for i in `seq 1 45`; do printf "="; done; echo

printf "%10s %10s %12s\n"  "Best" "Worst" "Variation"
for i in `seq 1 45`; do printf "-"; done; echo

echo " Variation across best TFLOPS:"
best_variation=$(echo $best_flop_bestest  $best_flop_worst |awk '{printf "%5.2f%\n", ($1-$2)/$1*100}')
printf "%10s %10s %10s\n" $best_flop_bestest $best_flop_worst $best_variation

for i in `seq 1 45`; do printf "-"; done; echo

echo " Variation across all TFLOPS:"
all_variation=$(echo $all_flop_bestest  $all_flop_worst |awk '{printf "%5.2f%\n", ($1-$2)/$1*100}')
printf "%10s %10s %10s\n" $all_flop_bestest $all_flop_worst $all_variation

for i in `seq 1 45`; do printf "="; done; echo
