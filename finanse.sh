declare  balance=0
declare entire_balance=0
declare savings=0

source $(dirname $0)/finanse_credits.sh
source $(dirname $0)/Credit_cards.sh
source $(dirname $0)/cFunctionalities.sh

function fgreeting()
{
local savings=0
local entire_balance=0
sleep 1
clear
echo "                                  FINANCES"
echo "    ########################################################################"
echo "  1) CHECK ALL ACCOUNTS  2) SUBACCOUNT  3)SAV-ACCOUNT  4)DEBIT-CARDS  5)LOANS   "
echo "                                    6)BACK            "

}
function fchanging()
{
  local snumber
  read snumber
  
  while [[ $snumber -gt 6 ||  ! $snumber =~ ^[1-6]+$ ]] 
  do
  	
    if [[ "$number" -lt 6 && $snumber =~ ^[1-6]+$ ]] #
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
    echo "building"
    ;;
  2)
    sleep 1
    cSavingsAccountFunctionality
    ;;
  3)
    sleep 1
    cSavingsAccountFunctionality
    ;;
  4)
    sleep 1
    menu4
    ;;
  5)
  	sleep 1
   finanse_c
    ;;
	 6)
  greeting
changing
    ;;
  esac
  
  menu1
}
function menu1()
{
 fgreeting
 fchanging
}

