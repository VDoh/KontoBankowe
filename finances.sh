 #!/bin/bash
function greeting()
{
sleep 1
clear
echo "               HELLO WELCOME IN OUR SMKM-INTERNATIONALBANK"
echo "    ########################################################################"
echo " 1) CHECKING ALL ACCOUNTS   2) SUBACCOUNTS  3) SAVINGS ACCOUNT  4)CREDIT CARDS  "
echo "                              5)LOANS                                                                                    "
}
function changing()
{
read number
while [[ $number -gt 5 ||  ! $number =~ ^[1-5]+$ ]] 
do
if [[ "$number" -lt 5 && $number =~ ^[1-5]+$ ]] #
then
echo ""
else
echo "Could you pick again"
fi
read number
done
case "$number" in
1) 
sleep 1
echo "building"
;;
2)
sleep 1
echo "building"
;;
3)
sleep 1
echo "building"
;;
4)
sleep 1
echo "building"
;;
5)
sleep 1
echo "building"
;;

esac
}
greeting
changing