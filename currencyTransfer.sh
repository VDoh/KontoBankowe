#!/bin/bash

#Assumes that "balance" is the global variable for the account balance
 
source $(dirname $0)/usefulFunctions.sh
source $(dirname $0)/transfersFunctions.sh
source $(dirname $0)/savingsAccount.sh
source $(dirname $0)/transfersHistory.sh
source $(dirname $0)/currency_exchange.sh

function cCurrencyManualTransfer
{
    clear

    if [ "$1" == "Person" ]
    then
        local name=$(cGetName)
        if [ "$name" == "-1" ]; then cCurrencyManualTransfer "Person"; return; fi
    
        local surnameOrNip=$(cGetSurname)
        if [ "$surnameOrNip" == "-1" ]; then cCurrencyManualTransfer "Person"; return; fi
    elif [ "$1" == "Firm" ]
    then
        local name=$(cGetName)
        if [ "$name" == "-1" ]; then cCurrencyManualTransfer "Firm"; return; fi
    
        local surnameOrNip=$(cGetNip)
        if [ "$surnameOrNip" == "-1" ]; then cCurrencyManualTransfer "Firm"; return; fi
    else
        echo "ERROR. Wrong argument for function cCurrencyManualTransfer (either Person or Firm)."
        sleep 3
        exit 1
    fi
    
    local bankAccountNumber=$(cGetBankAccountNumber)
    if [ "$bankAccountNumber" == "-1" ]; then cCurrencyManualTransfer; return; fi
    
    cGetCurrency
    local currency=$?

    local amountInOtherCurrency=$(cGetAmount "Type in amount of money to transfer: ")
    if [ "$amountInOtherCurrency" == "-1" ]; then cCurrencyManualTransfer; return; fi

    cCurrencyTransfer $1 $name $surnameOrNip $bankAccountNumber $currency $amountInOtherCurrency
}

function cCurrencyTransfer
{
    clear
    local type=$1
    local name=$2
    local surnameOrNip=$3
    local bankAccountNumber=$4  
    local currency=$5
    local amountInOtherCurrency=$6 
    local amount=$(KexchangeCalculation $amount $currency 10)
    
    cGenerateCode
    cAuthentication

    let balance-=$((amount+20))
    cMakeAutomaticTransfer 10

    if [ $amount -gt 49 ]
    then
        cValidateTransfer $amount ${type,,} $name $surnameOrNip
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
        cSaveTransferSeparately $type "Currency" $(date +'%Y-%m-%d') $bankAccountNumber $amount $name $surnameOrNip
    fi

    cAddTransferToHistory $type "Currency" $(date +'%Y-%m-%d') $bankAccountNumber $amount $name $surnameOrNip

    clear
    echo "Your account balance is now:" $balance
    sleep 3
    return
}