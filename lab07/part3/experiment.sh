#!/bin/bash

clear
x=256
for i in 1 2 3 4 5 6 7 8
do
    ./matrix_math 1 $x
    printf "\n"
    let x=x+256
done
x=256
for i in 1 2 3 4 5 6 7 8
do
    ./matrix_math 2 $x
    printf "\n"
    let x=x+256
done

