#!/bin/bash

echo -n "Input filename: "
read FILE

NoOfStart=$(grep -n "Fast-forward" $FILE | cut -d: -f1 | wc -l)
CTR=1
START=0
VAR=$NoOfStart
while [ $VAR -ne 0 ] ; do
	eval "START"$CTR=$(grep -n "Fast-forward" $FILE | cut -d: -f1 | sed -n $CTR"p")
	(("START"$CTR++))
	((CTR++))
	((VAR--))
done

EndOfLine=$(grep " changed" $FILE | wc -l)
CTR=1
END=0
RAV=$EndOfLine
while [ $RAV -ne 0 ] ; do
	eval "END"$CTR=$(nl $FILE |  grep " changed" | tr -d " " | tr "\t" " " | cut -d" " -f1 | sed -n $CTR"p")
	((CTR++))
	((RAV--))
done

CTR=1
WEBAPP=( )
API=( )
while [ $NoOfStart -ne 0 ] ; do
	while [ $((START$CTR)) -ne $((END$CTR)) ] ; do
	NUM=$((START$CTR))
	nl $FILE | tr -d " " | tr "\t" " " | grep "^$NUM " | grep "api/application" > /dev/null

	if [ $? -eq 1 ] ; then
		WEBAPP=(${WEBAPP[*]} $NUM)
	else
		API=(${API[*]} $NUM)
	fi
	((START$CTR++))
	done
((CTR++))
((NoOfStart--))	
done

touch $(pwd)/output.txt
echo " " > $(pwd)/output.txt
echo "---WEB-APP---" >> $(pwd)/output.txt
for VAR in ${WEBAPP[*]}
do
	sed -n $VAR"p" $FILE >> $(pwd)/output.txt
done 
echo -e "\n---API---" >> $(pwd)/output.txt
for VAR in ${API[*]}
do
	sed -n $VAR"p" $FILE >> $(pwd)/output.txt
done
exit 0
