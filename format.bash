#!/bin/bash

echo -n "Input filename: "
read FILE

StartOfLine=$(grep -n "Fast-forward" $FILE | cut -d: -f1 | wc -l)
CTR=1
START=0
VAR=$StartOfLine
while [ $VAR -ne 0 ] ; do
	eval "START"$CTR=$(grep -n "Fast-forward" $FILE | cut -d: -f1 | sed -n $CTR"p")
	(("START"$CTR++))
	((CTR++))
	((VAR--))
done

EndOfLine=$(grep "changed" $FILE | wc -l)
CTR=1
END=0
RAV=$EndOfLine
while [ $RAV -ne 0 ] ; do
	eval "END"$CTR=$(nl $FILE |  grep "changed" | tr -d " " | tr "\t" " " | cut -d" " -f1 | sed -n $CTR"p")
	((CTR++))
	((RAV--))
done

touch $(pwd)/output.txt
echo " " > $(pwd)/output.txt
CTR=1
while [ $StartOfLine -ne 0 ] ; do
		if [ $CTR -eq 1 ] ; then
			echo "----WEB-APP----" >> $(pwd)/output.txt
		elif [ $CTR -eq 2 ] ; then
			echo "----API----" >> $(pwd)/output.txt
		fi
	while [ $((START$CTR)) -ne $((END$CTR)) ] ; do
		NUM=$((START$CTR))
		sed -n $NUM"p" $FILE >> $(pwd)/output.txt
	#	echo $(sed -n $NUM"p" $FILE) >> $(pwd)/output.txt
		((START$CTR++))
	done
	((StartOfLine--))
	((CTR++))
done


exit 0
