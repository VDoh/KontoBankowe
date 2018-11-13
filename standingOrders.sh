#!/bin/bash

source $(dirname $0)/usefulFunctions.sh

#This is the function that you probably want to use if you want to add or delete a standing order
#It takes "Add" or "Delete" as an argument
function cDisplayStandingOrderMenu
{
    clear
    local option
    echo "Standing order types:"
    echo "1. Personal"
    echo "2. Firm"
    echo -n "Press desired option number in order to continue. "
    read -rsn1 option

    local optionFormat='^(1|2)$'
    if ! [[ "$option" =~ $optionFormat ]]
    then
        cDisplayStandingOrderMenu
    else
        if [ $1 == "Delete" ]
        then
            cDeleteStandingOrder $option
        elif [ $1 == "Add" ]
        then
             cAddStandingOrder $option
        else
            echo "ERROR: Either Add or Delete as an argument for cDisplayStandingOrderMenu function."
            sleep 2
            exit 1
        fi
    fi
}

#Do not use that function unless you know what you are doing.
#You probably want to use cDisplayStandingOrderMenu function instead.
function cDeleteStandingOrder
{
    clear

    if [ $1 == "1" ]
    then
        local pesel=$(cGetPesel)
        if [ "$pesel" == "-1" ]; then cDeleteStandingOrder 1; return; fi

        sed -i "/ $pesel /d" $(dirname $0)/standingOrders.txt
    else
        local nip=$(cGetNip)
        if [ "$nip" == "-1" ]; then cDeleteStandingOrder 2; return; fi

        sed -i "/ $nip /d" $(dirname $0)/standingOrders.txt
    fi
}

#Do not use that function unless you know what you are doing.
#You probably want to use cDisplayStandingOrderMenu function instead.
function cAddStandingOrder
{
    clear
    local orderType

    if [ $1 == "1" ] 
    then
        orderType="Person"

        local name=$(cGetName)
        if [ "$name" == "-1" ]; then cAddStandingOrder 1; return; fi
        local surname=$(cGetSurname)
        if [ "$surname" == "-1" ]; then cAddStandingOrder 1; return; fi
        local pesel=$(cGetPesel)
        if [ "$pesel" == "-1" ]; then cAddStandingOrder 1; return; fi
    elif [ $1 == "2" ]
    then
        orderType="Firm"

        local firmName=$(cGetFirmsName)
        if [ "$firmName" == "-1" ]; then cAddStandingOrder 2; return; fi
        local nip=$(cGetNip)
        if [ "$nip" == "-1" ]; then cAddStandingOrder 2; return; fi
    else
        echo "ERROR. Wrong argument for function cAddStandingOrder (either 1 or 2 are admissible)"
        sleep 3
        exit 1
    fi

    local bankAccountNumber=$(cGetBankAccountNumber)
    if [ "$bankAccountNumber" == "-1" ]; then cAddStandingOrder $1; return; fi
    local amount=$(cGetAmount "Type in the amount of money you will be sending: ")
    if [ "$amount" == "-1" ]; then cAddStandingOrder $1; return; fi
    local day=$(cGetDayOfTheMonth "Type in the day of the month you will be sending the money: ")
    if [ "$amount" == "-1" ]; then cAddStandingOrder $1; return; fi

    printf "%s" "$orderType " >> $(dirname $0)/standingOrders.txt

    if [ $orderType == "Person" ]
    then
        printf "%s" "$name " >> $(dirname $0)/standingOrders.txt
        printf "%s" "$surname " >> $(dirname $0)/standingOrders.txt
        printf "%s" "$pesel " >> $(dirname $0)/standingOrders.txt
    else
        printf "%s" "$firmName " >> $(dirname $0)/standingOrders.txt
        printf "%s" "$nip " >> $(dirname $0)/standingOrders.txt
    fi

    printf "%s" "$bankAccountNumber " >> $(dirname $0)/standingOrders.txt
    printf "%s" "$amount " >> $(dirname $0)/standingOrders.txt
    printf "%s" "$day " >> $(dirname $0)/standingOrders.txt
    echo "" >> $(dirname $0)/standingOrders.txt
}

function cGetStandingOrders
{
    clear
    local -a standingOrders=()
    local index=0

    while read -r line 
    do
        standingOrders[$index]="$line"
        let index++
    done < "$(dirname $0)/standingOrders.txt"

    for (( i=0; i<$index; i++ ))
    do
        local standingOrder=(${standingOrders[$i]})

        if [ "${standingOrder[0]}" == "Firm" ]
        then
            standingFirmOrders+=("${standingOrders[$i]}")
        else
            standingPersonOrders+=("${standingOrders[$i]}")
        fi
    done

    if [ ${#standingFirmOrders[@]} -gt 0 ]
    then
        echo "Firm standing orders:"
        echo ""

        for (( i=0; i<${#standingFirmOrders[@]}; i++ ))
        do
            local standingOrder=(${standingFirmOrders[$i]})

            echo "Order" $(($i+1))":"
            echo "Firms name:" ${standingOrder[1]}
            echo "NIP:" ${standingOrder[2]}
            echo "Bank account number:" ${standingOrder[3]}
            echo "Amount:" ${standingOrder[4]}
            echo "Day of the month for the payment:" ${standingOrder[5]}
            echo ""
        done
    fi

    if [ ${#standingPersonOrders[@]} -gt 0 ]
    then
        echo "Personal standing orders:"
        echo ""

        for (( i=0; i<${#standingPersonOrders[@]}; i++ ))
        do
            local standingOrder=(${standingPersonOrders[$i]})

            echo "Order" $(($i+1))":"
            echo "Persons name:" ${standingOrder[1]}
            echo "Surname:" ${standingOrder[2]}
            echo "PESEL:" ${standingOrder[3]}
            echo "Bank account number:" ${standingOrder[4]}
            echo "Amount:" ${standingOrder[5]}
            echo "Day of the month for the payment:" ${standingOrder[6]}
            echo ""
        done
    fi
}