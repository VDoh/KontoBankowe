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
        local pesel
        read -p "Type in persons PESEL in order to delete them from standing orders: " pesel
        local peselState=$(cValidateNumber $pesel 11)

        if [ $peselState == "0" ]
        then
            echo "Wrong pesel format. Has to have 11 digits and only digits." 
            sleep 3 
            cDeleteStandingOrder 1
            return
        fi

        sed -i "/ $pesel /d" ./standingOrders.txt
    else
        local nip
        read -p "Type in firms NIP in order to delete it from standing orders: " nip
        local nipState=$(cValidateNumber $nip 10)

        if [ $nipState == "0" ]
        then
            echo "Wrong NIP format. Has to have 10 digits and only digits." 
            sleep 3 
            cDeleteStandingOrder 2
            return
        fi

        sed -i "/ $nip /d" ./standingOrders.txt
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

        local personsName
        read -p "Type in recipients name: " personsName
        local nameState=$(cValidateWord $personsName)
        if [ $nameState == 0 ]; 
        then 
            echo "Wrong name format. Has to start with upperscase letter, has to have at least 3 letters and only letters" 
            sleep 3 
            cAddStandingOrder  1
            return 
        fi

        local surname
        read -p "Type in recipients surname: " surname
        local surnameState=$(cValidateWord $surname)
        if [ $surnameState == 0 ]; 
        then 
            echo "Wrong surname format. Has to start with upperscase letter, has to have at least 3 letters and only letters" 
            sleep 3 
            cAddStandingOrder 1
            return 
        fi

        local pesel
        read -p "Type in recipients pesel: " pesel
        local peselState=$(cValidateNumber $pesel 11)
        if [ $peselState == 0 ]; 
        then 
            echo "Wrong pesel format. Has to have 11 digits and only digits." 
            sleep 3 
            cAddStandingOrder 1
            return 
        fi
    elif [ $1 == "2" ]
    then
        orderType="Firm"

        local firmName
        read -p "Type in firms name: " firmName
        local firmNameFormat='^[a-zA-Z0-9-]+$'
        if ! [[ "$firmName" =~ $firmNameFormat ]] 
        then 
            echo "Wrong firm name format. Can contain only letters, digits and hyphens." 
            sleep 3 
            cAddStandingOrder 2
            return 
        fi

        local nip
        read -p "Type in firms NIP: " nip
        local nipState=$(cValidateNumber $nip 10)
        if [ $nipState == 0 ]
        then
            echo "Wrong NIP format. Has to have 10 digits and only digits."
            sleep 3 
            cAddStandingOrder 2
            return 
        fi
    fi

    local bankAccountNumber
    read -p "Type in recipients bank account number: " bankAccountNumber
    local bankAccountNumberState=$(cValidateNumber $bankAccountNumber 26)
    if [ $bankAccountNumberState == 0 ]; 
    then 
        echo "Wrong bank account number format. Has to have 26 digits and only digits." 
        sleep 3 
        cAddStandingOrder $1
        return 
    fi

    local amount
    read -p "Type in the amount of money you will be sending: " amount
    local amountFormat='^[1-9][0-9]*$'
    if ! [[ "$amount" =~ $amountFormat ]]
    then
        echo "Wrong amount format. Has to be greater than 0 and can contain only digits."
        sleep 3
        cAddStandingOrder $1
        return
    fi

    local day
    read -p "Type in the day of the mount you will be sending the money: " day
    local dayFormat='^([1-9]|([1-2][0-9])|30)$'
    if ! [[ "$day" =~ $dayFormat ]]
    then
        echo "Wrong day format. Has to be a number between 1 and 30 and cannot start with 0."
        sleep 3
        cAddStandingOrder $1
        return
    fi

    printf "%s" "$orderType " >> standingOrders.txt

    if [ $orderType == "Person" ]
    then
        printf "%s" "$personsName " >> standingOrders.txt
        printf "%s" "$surname " >> standingOrders.txt
        printf "%s" "$pesel " >> standingOrders.txt
    else
        printf "%s" "$firmName " >> standingOrders.txt
        printf "%s" "$nip " >> standingOrders.txt
    fi

    printf "%s" "$bankAccountNumber " >> standingOrders.txt
    printf "%s" "$amount " >> standingOrders.txt
    printf "%s" "$day " >> standingOrders.txt
    echo "" >> standingOrders.txt
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
    done < "standingOrders.txt"

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

cGetStandingOrders