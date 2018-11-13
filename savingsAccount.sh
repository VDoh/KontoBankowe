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
    
    local savingsAccountState=$(cCheckIfSavingsAccountExists)

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

    sed -i "s/Monthly: \(.*\)/Monthly: $monthlySavings/" $(dirname $0)/SavingsAccount/savingsAccount.txt
}

function cSetGoal
{
    clear
    local goal
    read -p "Set your saving goal: " goal
    local goalFormat='^[1-9][0-9]*$'

    if ! [[ "$goal" =~ $goalFormat ]]
    then
        echo "Wrong goal format. Has to be greater than 0 and can contain only digits."
        sleep 2
        cSetGoal
        return
    fi

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
    local transferAmount
    read -p "Type in how much would like to transfer to your savings account: " transferAmount
    local transferAmountFormat='^[1-9][0-9]*$'

    if ! [[ "$transferAmount" =~ $transferAmountFormat ]]
    then
        echo "Wrong transfer amount format. Transfer has to be greater than 0 (only digits are allowed)."
        sleep 2
        cMakeManualTransfer
        return
    fi

    local savingsAccountBalance=$(awk '/Balance: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    savingsAccountBalance=$(echo $(($savingsAccountBalance+$transferAmount)))
    sed -i "s/Balance: \(.*\)/Balance: $savingsAccountBalance/" $(dirname $0)/SavingsAccount/savingsAccount.txt
}

function cDisplaySavingsAccountInformation
{
    clear
    while read -r line 
    do
        echo $line
    done < "$(dirname $0)/SavingsAccount/savingsAccount.txt"

    local monthly=$(awk '/Monthly: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    local goal=$(awk '/Goal: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    local gatheredMoney=$(awk '/Balance: /{print $2}' $(dirname $0)/SavingsAccount/savingsAccount.txt)
    local timeToGoal
    let leftToGoal=goal-gatheredMoney

    if [ "$monthly" == 0 ]
    then
        echo "You haven't setup your monthly payment yet."
        sleep 3
        cSavingsAccount
    elif [ "$goal" == 0 ]
    then
        echo "You haven't setup your goal yet."
        sleep 3
        cSavingsAccount
    else
        let timeToGoal=leftToGoal/monthly
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