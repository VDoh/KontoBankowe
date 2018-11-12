#!/bin/bash
function adding ()
{ 
 local sdate 
 echo "date of execute dd-mm-yyyy:"
 read sdate
date_format='^(([0-2][0-9]|(3)[0-1])-(((0)[0-9])|((1)[0-2]))-[0-9]{4})$'
# file payements is needed 
 if  ! [[ "$sdate" =~ $date_format ]]
then  
	until [[  "$sdate" =~ $date_format  ]]
	do
		echo "date of execute dd-mm-yyyy:"
		read sdate
	done
fi
  local name_of _payement
  echo "name of payement"
  read name_of _payement
    printf "%s" "$sdate" >> payements.txt
	printf "%s" "$sname_of _payement " >> payements.txt
	echo "" >>  payements.txt
}

function getting()
{

local -a payements=()
    local index=0

    while read -r line 
    do
       payements[$index]="$line"
        let index++
		echo "$index"
    done < "payements.txt"

    local -a payementDate=()
    local -a payementName=()
   

    for (( i=0; i<$index; i++ ))
    do
        payement=(${payements[$i]})

       payementDate[$i]=${payement[0]}
        payementName[$i]=${payement[1]}
        
    done

    for (( i=0;  i<$index;  i++ ))
    do
	   echo "Your Planned Payements" $(($i+1))":"
        echo "Date:" ${payementDate[$i]}
        echo "Name:" ${payementName[$i]}
        echo ""
    done
}


function which ()
{
echo "  YOU CAN ADD ANOTHER PAYEMENT (1) SHOW EVERY PAYEMENT(2) DELETE PAYEMENT(3) "
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
adding
;;
2)
sleep 1
getting
;;
3)
sleep 1
echo "building"
;;
esac
}
which