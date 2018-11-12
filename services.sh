#!/bin/bash

#############################################################

function cValidateWord
{
    local word=$1

    local wordFormat='^[A-Z][a-z][a-z]+$'

    if [[ "$word" =~ $wordFormat ]]
    then
        echo 1
    else
        echo 0
    fi
}

function cValidateNumber
{
    local number=$1
    local numberLength=$2
    local numberFormat="^[0-9]{$numberLength}$"

    if [[ "$number" =~ $numberFormat ]]
    then
        echo 1
    else
        echo 0
    fi
}

function cAddRecipient
{
    clear
    local name
    read -p "Type in recipients name: " name
    local nameState=$(cValidateWord $name)

    local surname
    read -p "Type in recipients surname: " surname
    local surnameState=$(cValidateWord $surname)

    local pesel
    read -p "Type in recipients pesel: " pesel
    local peselState=$(cValidateNumber $pesel 11)

    local bankAccountNumber
    read -p "Type in recipients bank account number: " bankAccountNumber
    local bankAccountNumberState=$(cValidateNumber $bankAccountNumber 26)


    if [ "$nameState" == 0 ] || [ "$surnameState" == 0 ] || [ "$peselState" == 0 ] || [ "$bankAccountNumberState" == 0 ]
    then
        echo "Wrong data format. Please try again..."
        sleep 3
        cAddRecipient
    else
        printf "%s" "$name " >> recipients.txt
        printf "%s" "$surname " >> recipients.txt
        printf "%s" "$pesel " >> recipients.txt
        printf "%s" "$bankAccountNumber" >> recipients.txt
        echo "" >> recipients.txt
    fi
}

function cDeleteRecipient
{
    clear
    local pesel
    read -p "Type in recipients pesel: " pesel
    local peselState=$(cValidateNumber $pesel 11)

    if [ "$peselState" == 0 ]
    then
        echo "Incorrect pesel. Please try again..."
        sleep 3
        cDeleteRecipient
    else
        sed -i "/$pesel/d" ./recipients.txt
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

    local nameFormat='^[a-zA-Z]+.*$'
    local surnameFormat='^.*[a-zA-Z]+.*$'
    local peselFormat='^.*[0-9]{11}.*$'
    local bankAccountNumberFormat='.*[0-9]{26}$'

    for (( i=0; i<$index; i++ ))
    do
        recipient=(${recipients[$i]})

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

##########################################################################