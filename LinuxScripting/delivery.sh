#!/bin/bash

# Initial variables
articles="jan2017articles.csv"
bed="example.bed"
R=$(tput setaf 1)
N=$(tput sgr0)

printf "\n${R}Question 1: Take a look at the last 10 lines of the file. Which command are you going to use?${N}\n"
tail $articles
printf "\n${R}- Modify the command to show just the last line of the file.${N}\n"
tail -n 1 $articles

printf "\n${R}Question 2: Extract all lines that belong to January 6th from the file and store them in a new file named \"reyes.csv\".${N}\n"
grep "06 Jan" $articles > reyes.csv
printf "Saved file \"reyes.csv\"\n"
printf "\n${R}- Check that the first line of the new file has the expected values.${N}\n"
head -n 1 reyes.csv

printf "\n${R}Question 3: Use the original csv to find which entries have 0 at the comment count only for those entries from january 25yh.${N}\n"
grep "25 Jan" $articles | awk -F ',' '{if($5="0") print $1","$2","$3","$4","$5","$6","$7","$8}'

printf "\n${R}Question 4: Now count the number of entries of Q3 and compare with the total number of entries.${N}\n"
Q3entries=$(grep "25 Jan" $articles | awk -F ',' '{if($5="0") print $1","$2","$3","$4","$5","$6","$7","$8}' | wc -l)
Totalentries=$(cat $articles | wc -l)
printf "Only $Q3entries entries of $Totalentries satisfy the criteria of Question 3\n"

printf "\n${R}Question 5: Now use example.bed file. In this file, we are interested in the exon sizes of each entry. They are located in field number 11. Now you have to get the exon sizes of the first 10 entries of the file.${N}\n"
printf "Exon sizes of the first 10 entries:\n"
entries=$(head $bed | cut -f11)
printf "$entries\n"
#entries=$(head $bed | cut -f11)
#for exons in $entries;
#do
#  echo "${exons%?}" | awk -F ',' '{print "\t",NF}'
#done
printf "\n${R}- How would you remove the last comma?${N}\n"
printf "By using this expression: \"\${var%%?}\", where var is a variable containing the list of exons with the last comma that we want to remove.\n"
printf "In this way, by instance:\n"
var=$(head -n1 $bed | cut -f11)
var1=${var%?}
printf "\t$var\n"
printf "\t$var1\n"

printf "\n${R}Question 6: How would you get the smallest size from each of the records? The result should provide a number for each line of the input.${N}\n"
printf "Minimum exon sizes of the first 10 entries:\n"
entries=$(head $bed | cut -f11)
for exons in $entries;
do
  echo "${exons%?}" | awk -F ',' 'BEGIN{OFS="\n"} {$1=$1; print $0}' | sort -n | head -n 1
done

printf "\n${R}Question 7: How would you now sort the records so that the first number shown is th smallest exon size? Again, the answer must provide a sorted list of number for each line of the input.${N}\n"
for exons in $entries;
do
  sortedexons=$(echo "${exons%?}" | awk -F ',' 'BEGIN{OFS="\n"} {$1=$1; print $0}' | sort -n | awk 'BEGIN{ORS=","} {print}')
  printf "${sortedexons%?}\n"
done

printf "\n${R}Question 8: Now get the 10 largest exons of chr1 stored in example.bed${N}\n"
grep "^chr1" $bed | cut -f11 | sed -e 's/,$//' | sed -e $'s/,/\\\n/g' | sort -nr | head -n 10
#chr1entries=$(grep "^chr1" $bed | cut -f11)
#maxexons=""
#for exons in $chr1entries;
#do
#  maxexons+="$(echo "${exons%?}" | awk -F ',' 'BEGIN{OFS="\n"} {$1=$1; print $0}' | sort -n -r | head -n 1),"
#done
#  echo "${maxexons%?}" | awk -F ',' 'BEGIN{OFS="\n"} {$1=$1; print $0}' | sort -n -r | head

printf "\n${R}Question 9: Now modify Q9 script to receive as a parameter the number of exons to search for.${N}\n"
chmod +x ./Q9.sh
./Q9.sh 5 

printf "\n${R}Question 10: Get the first 10 records of jan2017articles.csv with largest number of comments from the original csv file.${N}\n"


