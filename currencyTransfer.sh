#!/bin/bash

#Assumes that "balance" is the global variable for the account balance
 
source $(dirname $0)/usefulFunctions.sh
source $(dirname $0)/transfersFunctions.sh
source $(dirname $0)/savingsAccount.sh
source $(dirname $0)/transfersHistory.sh
source $(dirname $0)/currency_exchange.sh

function cCurrencyTransfer
{
    clear
    local name=$(cGetName)
    if [ "$name" == "-1" ]; then cCurrencyTransfer; return; fi
    local surname=$(cGetSurname)
    if [ "$surname" == "-1" ]; then cCurrencyTransfer; return; fi
    local bankAccountNumber=$(cGetBankAccountNumber)
    if [ "$bankAccountNumber" == "-1" ]; then cCurrencyTransfer; return; fi
    cGetCurrency
    local currency=$?
    local amountInOtherCurrency=$(cGetAmount "Type in amount of money to transfer: ")
    if [ "$amountInOtherCurrency" == "-1" ]; then cCurrencyTransfer; return; fi
    local amount=$(Kexchangecalculation $amount $currency 10)
    
    cGenerateCode
    cAuthentication

    let balance-=$((amount+20))
    cMakeAutomaticTransfer 5

    if [ $amount -gt 49 ]
    then
        cValidateTransfer $amount $name $surname
        if [ $? == 0 ]
        then
            clear
            let balance+=amount
            echo "Transfer has been reverted."
            sleep 3
            return
        fi
    fi

    cChooseOneOfTwoOptions "Press S if you want to save transfer separately or press C if you want to continue with defualt history storage." "S" "C"
    if [ $? == 1 ] 
    then 
        cSaveTransferSeparately "Currency" $(date +'%Y-%m-%d') $bankAccountNumber $amount $name $surname
    fi

    cAddTransferToHistory "Currency" $(date +'%Y-%m-%d') $bankAccountNumber $amount $name $surname

    clear
    echo "Your account balance is now:" $balance
    sleep 3
    return
}