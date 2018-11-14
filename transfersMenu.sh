#!/bin/bash

source $(dirname $0)/ordinaryTransfer.sh
source $(dirname $0)/expressTransfer.sh
source $(dirname $0)/currencyTransfer.sh

function cTransfersGeneralMenu
{
    clear
    echo "Menu | Transfers"
    echo "1. Ordinary transfer."
    echo "2. Express transfer."
    echo "3. Currency transfer."
    
    local option
    echo -n "Press desired option number in order to continue or press R in order to return to the previous page. "
    read -rsn1 option

    if [ "$option" == 1 ]
    then
        cTransfersSpecificMenu "Ordinary"
    elif [ "$option" == 2 ]
    then
        cTransfersSpecificMenu "Express"
    elif [ "$option" == 3 ]
    then
        cTransfersSpecificMenu "Currency"
    elif [ "$option" == "r" ] || [ "$option" == "R" ]
    then
        return
    else
        cTransfersGeneralMenu
    fi
}

function cTransfersSpecificMenu
{
    clear
    echo "Menu | $1 transfers"
    echo "1. Personal transfer."
    echo "2. Firm transfer."

    local option
    echo -n "Press desired option number in order to continue or press R in order to return to the previous page. "
    read -rsn1 option

    if [ "$option" == 1 ]
    then
        c$1ManualTransfer "Person"
    elif [ "$option" == 2 ]
    then
        c$1ManualTransfer "Firm"
    elif [ "$option" == "r" ] || [ "$option" == "R" ]
    then
        cTransfersGeneralMenu
        return
    fi
    
    cTransfersSpecificMenu $1
}