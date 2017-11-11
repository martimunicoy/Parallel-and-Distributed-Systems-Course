#!/bin/bash

# Assignment done by Jorge Pardillos and Martí Municoy.

# Initial variables
articles="jan2017articles.csv"
bed="example.bed"
R=$(tput setaf 1)
N=$(tput sgr0)

printf "\n${R}Question 1: Take a look at the last 10 lines of the file. Which command are you going to use?${N}\n"
printf "We are using the \'tail\' command. The results are below:\n"
tail $articles
printf "\n${R}- Modify the command to show just the last line of the file.${N}\n"
tail -n 1 $articles

printf "\n${R}Question 2: Extract all lines that belong to January 6th from the file and store them in a new file named \"reyes.csv\".${N}\n"
grep "06 Jan" $articles > reyes.csv
printf "Saved file \"reyes.csv\"\n"
printf "\n${R}- Check that the first line of the new file has the expected values.${N}\n"
head -n 1 reyes.csv

printf "\n${R}Question 3: Use the original csv to find which entries have 0 at the comment count only for those entries from january 25th.${N}\n"
grep "25 Jan" $articles | awk -F ',' -v OFS=',' '{if($5=="0") print $0} '

printf "\n${R}Question 4: Now count the number of entries of Q3 and compare with the total number of entries.${N}\n"
Q3entries=$(grep "25 Jan" $articles | awk -F ',' '{if($5=="0") print $1","$2","$3","$4","$5","$6","$7","$8}' | wc -l)
Totalentries=$(cat $articles | wc -l)
printf "Only $Q3entries entries of $Totalentries satisfy the criteria of Question 3\n"

printf "\n${R}Question 5: Now use example.bed file. In this file, we are interested in the exon sizes of each entry. They are located in field number 11. Now you have to get the exon sizes of the first 10 entries of the file.${N}\n"
printf "Exon sizes of the first 10 entries:\n"
entries=$(head $bed | cut -f11)
printf "$entries\n"

printf "\n${R}- How would you remove the last comma?${N}\n"
printf "By using \"sed\" with the following argument: \"-e \'s/,\$//g\'\".\n"
printf "In this way, by instance:\n"
var=$(head -n1 $bed | cut -f11)
var1=$(echo $var | sed -e 's/,$//g')
printf "\t$var\n"
printf "\t$var1\n"

printf "\n${R}Question 6: How would you get the smallest size from each of the records? The result should provide a number for each line of the input.${N}\n"
printf "Minimum exon sizes of the first 10 entries:\n"
entries=$(head $bed | cut -f11)
for exons in $entries;
do
  echo "${exons%?}" | awk -F ',' 'BEGIN{OFS="\n"} {$1=$1; print $0}' | sort -n | head -n 1
done

printf "\n${R}Question 7: How would you now sort the records so that the first number shown is the smallest exon size? Again, the answer must provide a sorted list of number for each line of the input.${N}\n"
for exons in $entries;
do
  sortedexons=$(echo "${exons%?}" | awk -F ',' 'BEGIN{OFS="\n"} {$1=$1; print $0}' | sort -n | awk 'BEGIN{ORS=","} {print}')
  printf "${sortedexons%?}\n"
done

printf "\n${R}Question 8: Now get the 10 largest exons of chr1 stored in example.bed${N}\n"
grep "^chr1" $bed | cut -f11 | sed -e 's/,$//' | sed -e $'s/,/\\\n/g' | sort -nr | head -n 10

printf "\n${R}Question 9: Now modify Q8 script to receive as a parameter the number of exons to search for.${N}\n"
chmod +x ./Q9.sh
printf "By typing \"./Q9.sh 5\", where \"5\" is the parameter that specifies the number of exons to search for, we get the results from below.\n"
./Q9.sh 5

printf "\n${R}Question 10: Get the first 10 records of jan2017articles.csv with largest number of comments from the original csv file.${N}\n"
awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "", $i) } {print $0}' $articles | sort -nrt, -k5 | head -10

printf "\n${R}Question 11: Modify your previous script to receive a number as a parameter N and then show the top N entries with more comments.${N}\n"
chmod +x ./Q11.sh
printf "By typing \"./Q11.sh 5\", where \"5\" is the parameter that specifies the number of entries to search for, we get the results from below.\n"
./Q11.sh 5

printf "\n${R}Question 12: Now we are going to create a new articles.csv where we get a different output data layout using awk tool.${N}\n"
awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "_COMMA_", $i) } {print $0}' $articles | cut -f4,5,8,1 -d ',' | sed -e 's/_COMMA_/,/g' > articles.csv
printf "Saved file \"articles.csv\"\n"

printf "\n${R}Question 13: Now create a new article2.csv format where we cut the Title text to 10 characters and we get only the last level of the Path.${N}\n"
paste <(awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "", $i) } {print $0}' $articles | cut -f4 -d ',' | cut -c -10) <(awk -F'"' -v OFS='' '{ for (i=2; i<=NF; i+=2) gsub(",", "", $i) } {print $0}' $articles  | cut -f6 -d ',' | awk -F'/' '{print $NF}') | awk -F '\t' '{print $1","$2}' > articles2.csv
printf "Saved file \"articles2.csv\"\n"
printf "\n"
