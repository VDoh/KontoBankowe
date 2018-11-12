#!/bin/bash

function cValidateWord
{
    word=$1

    wordFormat='^[A-Z][a-z][a-z]+$'

    if [[ "$word" =~ $wordFormat ]]
    then
        echo 1
    else
        echo 0
    fi
}

function cValidateNumber
{
    number=$1
    numberLength=$2
    numberFormat="^[0-9]{$numberLength}$"

    if [[ "$number" =~ $numberFormat ]]
    then
        echo 1
    else
        echo 0
    fi
}

function cAddRecipient
{
    local name
    read -p "Type in recipients name: " name
    nameState=$(cValidateWord $name)

    if [ $nameState == 0 ]
    then
        echo "Wrong name format (has to start with uppercase letter, has to have length of at least 3 letters and can contain only letters."
        sleep 3
        clear
        cAddRecipient
    fi

    local surname
    read -p "Type in recipients surname: " surname
    surnameState=$(cValidateWord $surname)

    if [ $surnameState == 0 ]
    then
        echo "Wrong name format (has to start with uppercase letter, has to have length of at least 3 letters and can contain only letters."
        sleep 3
        clear
        cAddRecipient
    fi
    
    local pesel
    read -p "Type in recipients pesel: " pesel
    peselState=$(cValidateNumber $pesel 11)

    if [ $peselState == 0 ]
    then
        echo "Wrong name format (has to start with uppercase letter, has to have length of at least 3 letters and can contain only letters."
        sleep 3
        clear
        cAddRecipient
    fi
    
    local bankAccountNumber
    read -p "Type in recipients bank account number: " bankAccountNumber
    bankAccountNumberState=$(cValidateNumber $bankAccountNumber 26)

    if [ $bankAccountNumber == 0 ]
    then
        echo "Wrong name format (has to start with uppercase letter, has to have length of at least 3 letters and can contain only letters."
        sleep 3
        clear
        cAddRecipient
    fi

    printf "%s" "$name " >> recipients.txt
    printf "%s" "$surname " >> recipients.txt
    printf "%s" "$pesel " >> recipients.txt
    printf "%s" "$bankAccountNumber" >> recipients.txt
    echo "" >> recipients.txt
}

function cGetRecipients
{
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