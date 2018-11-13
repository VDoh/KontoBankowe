#!/bin/bash

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

function cCheckIfSavingsDirExists
{
    if [ -d "$(dirname $0)/$1" ]
    then
        echo 1
    else
        echo 0
    fi
}

function cCheckIfSavingsAccountExists
{
    if [ -f "$(dirname $0)/$1" ]
    then
        echo 1
    else
        echo 0
    fi
}