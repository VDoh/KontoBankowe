#!/bin/bash

#Assumes that "balance" is the global variable for the account balance

source $(dirname $0)/usefulFunctions.sh
source $(dirname $0)/transfersFunctions.sh
source $(dirname $0)/savingsAccount.sh

function cOrdinaryTransfer
{
    clear
    local name=$(cGetName)
    if [ "$name" == "-1" ]; then cOrdinaryTransfer; return; fi
    local surname=$(cGetSurname)
    if [ "$surname" == "-1" ]; then cOrdinaryTransfer; return; fi
    local bankAccountNumber=$(cGetBankAccountNumber)
    if [ "$bankAccountNumber" == "-1" ]; then cOrdinaryTransfer; return; fi
    local amount=$(cGetAmount "Type in amount of money to transfer: ")
    if [ "$amount" == "-1" ]; then cOrdinaryTransfer; return; fi
    
    cGenerateCode
    cAuthentication

    let balance-=amount
    cMakeAutomaticTransfer 3

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

    cAddTransferToHistory "Ordinary" $(date +'%Y-%m-%d') $bankAccountNumber $amount $name $surname

    clear
    echo "Your account balance is now:" $balance
    sleep 3
    return
}