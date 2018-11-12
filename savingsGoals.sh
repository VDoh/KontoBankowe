#!/bin/bash

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

    if [ $savingsAccountDirState == 1 ]
    then
        cd $(dirname $0)/SavingsAccount
        local savingsAccountState=$(cCheckIfSavingsAccountExists)

        if [ $savingsAccountState == 1]
        then
            echo "You already have savings account."
            sleep 2
            return
        else
            touch savingsAccount.txt
        fi
    else
        mkdir $(dirname $0)/SavingsAccount
        touch savingsAccount.txt
    fi
}