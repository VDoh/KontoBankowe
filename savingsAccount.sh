#!/bin/bash

source $(dirname $0)/usefulFunctions.sh

function cCreateSavingsAccount
{
    local savingsAccountDirState=$(cCheckIfDirExists SavingsAccount)

    if [ $savingsAccountDirState == 0 ]; then mkdir $(dirname $0)/SavingsAccount; fi
    
    local savingsAccountState=$(cCheckIfFileExists SavingsAccount/savingsAccount.txt)

    if [ $savingsAccountState == 0 ]
    then
        touch $(dirname $0)/SavingsAccount/savingsAccount.txt
        printf "%s\n" "Balance: 0" >> $(dirname $0)/SavingsAccount/savingsAccount.txt
        printf "%s\n" "Monthly: 0" >> $(dirname $0)/SavingsAccount/savingsAccount.txt
        printf "%s\n" "Goal: 0" >> $(dirname $0)/SavingsAccount/savingsAccount.txt
    fi
}

function cSetMonthlySavings
{
    clear
    local monthlySavings=$(cGetAmount "Set how much money would you like to save per month: ")
    if [ "$monthlySavings" == "-1" ]; then cSetMonthlySavings; return; fi

    sed -i "s/Monthly: \(.*\)/Monthly: $monthlySavings/" $(dirname $0)/SavingsAccount/savingsAccount.txt
}

function cSetGoal
{
    clear
    local goal=$(cGetAmount "Set your saving goal: ")
    if [ "$goal" == "-1" ]; then cSetGoal; return; fi

    sed -i "s/Goal: \(.*\)/Goal: $goal/" $(dirname $0)/SavingsAccount/savingsAccount.txt
}

function cDisplaySavingsAccountMenu
{
    clear
    echo "Menu | Savings account"
    echo "1. Set monthly savings."
    echo "2. Make transfer manually."
    echo "3. Set goal."
    echo "4. Display information about your savings account."
    echo "Press desired option number in order to continue "
}

#Takes amount as an argument
function cMakeAutomaticTransfer
{
    cCreateSavingsAccount
    local transferAmount=$1
    local transferFormat='^[1-9][0-9]+$'

    if [[ "$transferAmount" =~ $transferFormat ]]
    then
        echo "ERROR. cMakeAutomaticTransfer in savingsGoals.sh takes number bigger than 0 as an argument."
        sleep 3
        exit 1
    fi

    local savingsAccountBalance=$(awk '/Balance: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    savingsAccountBalance=$(echo $(($savingsAccountBalance+$transferAmount)))
    sed -i "s/Balance: \(.*\)/Balance: $savingsAccountBalance/" $(dirname $0)/SavingsAccount/savingsAccount.txt
}

function cMakeManualTransfer
{
    clear
    local transferAmount=$(cGetAmount "Type in amount of money you would like to transfer: ")
    if [ "$transferAmount" == "-1" ]; then cMakeManualTransfer; return; fi

    local savingsAccountBalance=$(awk '/Balance: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    savingsAccountBalance=$(echo $(($savingsAccountBalance+$transferAmount)))
    sed -i "s/Balance: \(.*\)/Balance: $savingsAccountBalance/" $(dirname $0)/SavingsAccount/savingsAccount.txt
}

function cDisplaySavingsAccountInformation
{
    clear
    echo "Information | Savings account"

    while read -r line 
    do
        echo $line
    done < "$(dirname $0)/SavingsAccount/savingsAccount.txt"

    local monthly=$(awk '/Monthly: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    local goal=$(awk '/Goal: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    local gatheredMoney=$(awk '/Balance: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    local timeToGoal
    local leftToGoal=$(($goal-$gatheredMoney))

    if [ "$gatheredMoney" -gt "$goal" ]
    then
        echo "You have already achieved your goal."
        sleep 3
    elif [ "$monthly" == 0 ]
    then
        echo "You haven't setup your monthly payment yet."
        sleep 3
    elif [ "$goal" == 0 ]
    then
        echo "You haven't setup your goal yet."
        sleep 3
    else
        let timeToGoal=leftToGoal/monthly      
        if [ $(( $leftToGoal % $monthly)) != 0 ]; then let timeToGoal++; fi

        echo "It will take you" $timeToGoal "more months to achieve your goal of saving" $goal"."
        sleep 3
    fi
}

function cSavingsAccount
{
    clear
    cCreateSavingsAccount

    local option
    cDisplaySavingsAccountMenu
    read -rsn1 option
    local optionFormat='^[1-4]$'
    if ! [[ "$option" =~ $optionFormat ]]; then cSavingsAccount; return; fi

    case $option in
        1)
            cSetMonthlySavings
            ;;
        2)
            cMakeManualTransfer
            ;;
        3)
            cSetGoal
            ;;
        4)
            cDisplaySavingsAccountInformation
            ;;
    esac

    cSavingsAccount
}