#!/bin/bash

entries_number=$1

awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "", $i) } {print $0}' jan2017articles.csv | cut -f5 -d ',' | sort -nr | head -n $entries_number
