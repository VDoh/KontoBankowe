#!/bin/bash

function loginscreen()
{
local passwordFormat='^[0-9]+$'
local loginFormat='^[a-zA-Z]+$'
local loginInput
local passwordInput

clear
echo "Type your login:"
read loginInput
echo "Type your password:"
read passwordInput

if ! [[ "$loginInput" =~ $loginFormat ]] || ! [[ "$passwordInput" =~ $passwordFormat ]]
then
    until [[ "$loginInput" =~ $loginFormat ]] && [[ "$passwordInput" =~ $passwordFormat ]]
    do
            clear
            echo "Incorrect input. Try again: "
            echo "Type your login:"
            read loginInput
            echo -e "\n"
            echo "Type your password:"
            read passwordInput
    done
fi

a=100
b=2137
let c=b/a
echo $c
}