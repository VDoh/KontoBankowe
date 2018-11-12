#!/bin/bash

source $(dirname $0)/usefulFunctions.sh

function cAddRecipient
{
    clear
    local name
    read -p "Type in recipients name: " name
    local nameState=$(cValidateWord $name)
    if [ $nameState == 0 ]; 
    then 
        echo "Wrong name format. Has to start with upperscase letter, has to have at least 3 letters and only letters." 
        sleep 3 
        cAddRecipient 
        return 
    fi

    local surname
    read -p "Type in recipients surname: " surname
    local surnameState=$(cValidateWord $surname)
    if [ $surnameState == 0 ]; 
    then 
        echo "Wrong surname format. Has to start with upperscase letter, has to have at least 3 letters and only letters." 
        sleep 3 
        cAddRecipient 
        return 
    fi

    local pesel
    read -p "Type in recipients pesel: " pesel
    local peselState=$(cValidateNumber $pesel 11)
    if [ $peselState == 0 ]; 
    then 
        echo "Wrong pesel format. Has to have 11 digits and only digits." 
        sleep 3 
        cAddRecipient 
        return 
    fi

    local bankAccountNumber
    read -p "Type in recipients bank account number: " bankAccountNumber
    local bankAccountNumberState=$(cValidateNumber $bankAccountNumber 26)
    if [ $bankAccountNumberState == 0 ]; 
    then 
        echo "Wrong bank account number format. Has to have 26 digits and only digits." 
        sleep 3 
        cAddRecipient 
        return 
    fi

    printf "%s" "$name " >> recipients.txt
    printf "%s" "$surname " >> recipients.txt
    printf "%s" "$pesel " >> recipients.txt
    printf "%s" "$bankAccountNumber" >> recipients.txt
    echo "" >> recipients.txt
}

function cDeleteRecipient
{
    clear
    local pesel
    read -p "Type in recipients pesel: " pesel
    local peselState=$(cValidateNumber $pesel 11)

    if [ $peselState == 0 ]
    then
        echo "Incorrect pesel. Please try again..."
        sleep 3
        cDeleteRecipient
    else
        sed -i "/ $pesel /d" ./recipients.txt
    fi
}

function cGetRecipients
{
    clear
    local -a recipients=()
    local index=0

    while read -r line 
    do
        recipients[$index]="$line"
        let index++
    done < "recipients.txt"

    local -a recipientsName=()
    local -a recipientsSurname=()
    local -a recipientsPESEL=()
    local -a recipientsBankAccountNumber=()

    for (( i=0; i<$index; i++ ))
    do
        local recipient=(${recipients[$i]})

        recipientsName[$i]=${recipient[0]}
        recipientsSurname[$i]=${recipient[1]}
        recipientsPESEL[$i]=${recipient[2]}
        recipientsBankAccountNumber[$i]=${recipient[3]}
    done

    for (( i=0; i<$index; i++ ))
    do
        echo "Recipient" $(($i+1))":"
        echo "Name:" ${recipientsName[$i]}
        echo "Surname:" ${recipientsSurname[$i]}
        echo "PESEL:" ${recipientsPESEL[$i]}
        echo "Bank account number:" ${recipientsBankAccountNumber[$i]}
        echo ""
    done
}