#!/bin/bash

source $(dirname $0)/usefulFunctions.sh

function cCheckIfSavingsDirExists
{
    if [ -d "$(dirname $0)/SavingsAccount" ]
    then
        echo 1
    else
        echo 0
    fi
}

function cCheckIfSavingsAccountExists
{
    if [ -f "$(dirname $0)/SavingsAccount/savingsAccount.txt" ]
    then
        echo 1
    else
        echo 0
    fi
}

function cCreateSavingsAccount
{
    local savingsAccountDirState=$(cCheckIfSavingsDirExists)

    if [ $savingsAccountDirState == 0 ]
    then
        mkdir $(dirname $0)/SavingsAccount
    fi
    
    cd $(dirname $0)/SavingsAccount
    local savingsAccountState=$(cCheckIfSavingsAccountExists)

    if [ $savingsAccountState == 0]
    then
        touch savingsAccount.txt
    fi
}

function cSetMonthlySavings
{
    clear
    local monthlySavings
    read -p "Set how much money would you like to save per month: " monthlySavings
    local monthlySavingsFormat='^[1-9][0-9]*$'

    if ! [[ "$monthlySavings" =~ $monthlySavingsFormat ]]
    then
        echo "Wrong savings format. Has to be greater than 0 and can contain only digits."
        sleep 2
        cSetMonthlySavings
        return
    fi
}

function cDisplaySavingsAccountMenu
{
    clear
    echo "Menu | Savings account"
    echo "1. Set monthly savings."
    echo "2. Make transfer manually."
    echo "3. Display information about your savings account."
    echo "Press desired option number in order to continue "
}

function cMakeTransfer
{
    clear

}

function cDisplaySavingsAccountInformation
{
    clear
}

function cSavingsAccount
{
    clear
    cCreateSavingsAccount

    local option
    cDisplaySavingsAccountMenu
    read -rsn1 option
    local optionFormat='^[1-3]$'

    if ! [[ "$option" =~ $optionFormat ]]
    then
        cSavingsAccount
        return
    fi

    case $option in
        1)
            cSetMonthlySavings
            ;;
        2)
            cMakeTransfer
            ;;
        3)
            cSavingsAccount
            ;;
    esac
}