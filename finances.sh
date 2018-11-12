 #!/bin/bash
function greeting()
{
sleep 1
clear
echo "               HELLO WELCOME IN OUR SMKM-INTERNATIONALBANK"
echo "    ########################################################################"
echo " 1) CHECKING ALL ACCOUNTS   2) SUBACCOUNTS  3) SAVINGS ACCOUNT  4)CREDIT CARDS  "
echo "        5)LOANS  6) SERVICES  7)OFFER  8)HISTORY   9)MAKE TRANSACTIONS                                                                              "
}
function changing()
{
read number
while [[ $number -gt 9 ||  ! $number =~ ^[1-9]+$ ]] 
do
if [[ "$number" -lt 9 && $number =~ ^[1-9]+$ ]] #
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
6)
sleep 1
echo "building"
;;
7)
sleep 1
echo "building"
;;
8)
sleep 1
echo "building"
;;
9)
sleep 1
echo "building"
;;

esac
}
greeting
changing