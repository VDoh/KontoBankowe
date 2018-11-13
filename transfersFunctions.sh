#!/bin/bash

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

function cAddTransferToHistory
{
    echo ""
}

function cSaveTransferSeparately
{
    echo ""
}