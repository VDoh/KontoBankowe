#!/bin/bash
function cdeleting ()
{
 clear
 local index=0

    while read -r line 
    do
       products[$index]="$line"
        let index++
    done < "certificates.txt"
	echo "You have $index number of certificates you can choose one of them to deleted"
 
	numberFormat='^[0-9]+$'
    read -p "Write down certificate you want do delete: " numberOfLine
	if ! [[ "$numberOfLine" =~ $numberFormat ]]  || [[  "$numberOfLine" -gt $index ]]
	then
	until [[ "$numberOfLine" =~ $numberFormat ]]  && [[  "$numberOfLine" -le $index ]]
	do
	echo "There is no line $numberOfLine"
    read numberOfLine
	done
	fi
	sed -i "${numberOfLine}d" ./certificates.txt
   
}
function cadding ()
{ 
echo "WRITE ID DOWN"
 local certificates
 read certificates
 
printf "%s" "$certificates " >> certificates.txt
echo " " >> certificates.txt
}
function cgetting()
{
local -a certificates=()
    local index=0

    while read -r line 
    do
       products[$index]="$line"
        let index++
    done < "certificates.txt"

var=$(<certificates.txt)
echo "$var"
}

function cchanging()
{
echo "        YOU CAN ADD YOUR CERTIFICATES (1)   YOU CAN SEE YOUR CERTIFICATES(2)    "
echo "                   YOU DELETE YOUR CERTIFICATE(3)   BACK(4)    "

local snumber
read snumber
while [[ $snumber -gt 3 ||  ! $snumber =~ ^[1-3]+$ ]] 
do
if [[ "$number" -lt 3 && $snumber =~ ^[1-3]+$ ]] #
then
echo ""
else
echo "Could you pick again"
fi
read snumber
done
case "$snumber" in
1) 
sleep 1
cadding
 sleep 1
 clear
 cchanging
;;
2)
sleep 1
cgetting

cchanging
;;
3)
sleep 1
cdeleting
cchanging
;;
4)
sleep 1
echo "back"
;;
esac
}
