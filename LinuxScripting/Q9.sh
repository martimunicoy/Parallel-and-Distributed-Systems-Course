#!/bin/bash

exons_number=$1
bed="example.bed"

grep "^chr1" $bed | cut -f11 | sed -e 's/,$//' | sed -e $'s/,/\\\n/g' | sort -nr | head -n $exons_number
