#!/bin/bash
source $(dirname $0)/cFunctionalities.sh # 1,3,4
source $(dirname $0)/installments.sh # 5
source $(dirname $0)/planned_payment.sh #2
source $(dirname $0)/documents.sh # 6
source $(dirname $0)/certificates.sh # 7
source $(dirname $0)/top_up.sh # 8
source $(dirname $0)/currency_exchange.sh # 9

function greetingServices()
{	
    clear
    sleep 1
    echo "                                              Services"
    echo "    ###########################################################################################"
    echo "       1) Recipients 2) Scheduled payments 3) Standing orders 4) Saving goals 5) Installments "
    echo "                 6) Documents 7) Certificates 8) Top-up 9) Currency exchange r) Return"
}

function menuServices()
{
    greetingServices
    local choiceFormat='^([1-9]|r)$'    
    local choice
    read -rsn1 choice

    if ! [[ "$choice" =~ $choiceFormat ]]
    then
        until [[ "$choice" =~ $choiceFormat ]]
        do
            echo "Wrong input data. Try again."
            greetingU
            read -rsn1 choice
        done
    fi

    case "$choice" in
    "1") cRecipientsFunctionality ;;
    "2") which ;;
    "3") cStandingOrdersFunctionality ;;
    "4") cSavingsAccountFunctionality ;;
    "5") ichanging ;;
    "6") dchanging ;;
    "7") cchanging ;;
    "8") tchoose ;;
    "9") Kexchange ;;
    "r") echo "";;
    esac
}

menuServices