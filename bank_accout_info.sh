#!/bin/bash

function MShowAccounts()
{
local path='~/Desktop/bank_acc_info.txt'

if [ `whoami` = $USER ]
then  
    cat $path
else 
    echo "Log as $USER" 
fi

}

MShowAccounts