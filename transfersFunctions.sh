#!/bin/bash

source $(dirname $0)/usefulFunctions.sh

function cGetName
{
    local personsName
    read -p "Type in recipients name: " personsName
    local nameState=$(cValidateWord $personsName)
    if [ $nameState == 0 ]; 
    then 
        echo -1
        echo "Wrong name format. Has to start with upperscase letter, has to have at least 3 letters and only letters" >&2
        sleep 3
    else
        echo $personsName
    fi
}

function cGetSurname
{
    local surname
    read -p "Type in recipients surname: " surname
    local surnameState=$(cValidateWord $surname)
    if [ $surnameState == 0 ]; 
    then 
        echo -1
        echo "Wrong surname format. Has to start with upperscase letter, has to have at least 3 letters and only letters" >&2
        sleep 3
    else
        echo $surname
    fi
}

function cGetBankAccountNumber
{
    local bankAccountNumber
    read -p "Type in recipients bank account number: " bankAccountNumber
    local bankAccountNumberState=$(cValidateNumber $bankAccountNumber 26)
    if [ $bankAccountNumberState == 0 ]; 
    then 
        echo -1
        echo "Wrong bank account number format. Has to have 26 digits and only digits." >&2
        sleep 3 
    else
        echo $bankAccountNumber
    fi
}

function cGetAmount
{
    local amount
    read -p "Type in amount of money you would like to transfer: " amount
    local amountFormat='^([1-9][0-9]*)$'
    if ! [[ "$amount" =~ $amountFormat ]]; 
    then 
        echo -1
        echo "Wrong amount format. Has to be greater than 0 and can contain digits only." >&2
        sleep 3
    else
        echo $amount
    fi
}

function cGenerateCode
{
    local code=$(shuf -i100000-999999 -n1)  
    touch $(dirname $0)/authenticationCode.txt
    echo $code > $(dirname $0)/authenticationCode.txt
}

function cAuthentication
{
    clear
    local code=$(cat "$(dirname $0)/authenticationCode.txt")
    
    local userInput
    read -p "Enter authentication code here (you can find it in a file called authenticationCode.txt in the same directory as the script): " userInput
    if [ $userInput != $code ]
    then
        echo "Please try again."
        sleep 3
        cAuthentication
    fi
}

function cValidateTransfer
{
    clear

    echo "You sent" $1 "to" $2 $3"." >&2
    echo "Press U if you want to undo it or press C if you want to continue. " >&2
    
    local option
    read -rsn1 option

    if [ "$option" == "u" ] || [ "$option" == "U" ]
    then
        return 0
    elif [ "$option" == "c" ] || [ "$option" == "C" ]
    then
        return 1
    else
        cValidateTransfer
    fi
}