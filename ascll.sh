#!/bin/bash
b=( 0 1 2 3 4 5 6 7 8 9 a b c d f )
c=( 0 1 2 3 4 5 6 7 8 9 a b c d f )

for ((i=0 ; i<16 ; i++  ))

do  
for ((j=0 ; j<16 ; j++))

do
echo -E "\x${b[i]}${c[j]}"  
echo -e "\x${b[i]}${c[j]}"
 
done 
done 
