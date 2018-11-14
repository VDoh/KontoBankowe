#!/bin/bash

source $(dirname $0)/finanse.sh

function greeting()
{
local savings=0
local entire_balance=0
sleep 1
clear
echo "                   HELLO WELCOME IN OUR SMKM-INTERNATIONALBANK"
echo "    ########################################################################"
echo "      1) FINANCES  2) SERVICES  3)OFFER  4)HISTORY  5)MAKE TRANSACTIONS   "
echo " BALANCE: $balance $"
echo " SAVINGS: $savings $"
echo " ENTIRE BALANCE: $entire_balance $"

}
function changing()
{
local snumber
read snumber
while [[ $snumber -gt 5 ||  ! $snumber =~ ^[1-5]+$ ]] 
do
if [[ "$number" -lt 5 && $snumber =~ ^[1-5]+$ ]] #
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
menu1
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