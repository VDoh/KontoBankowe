#!/bin/bash

function ShowInfoCreditAndLoans()
{
    local txtName="creditInfo.txt"     

    if [ -s $txtName ]
    then 
        if [ `whoami`=$USER ]
        then
            cat creditInfo.txt
        else 
            echo "You must be root to do that"
        fi
    else
        echo "cannot read There might be no credits added or file doesn't exists"
    fi
}

#zalezne od funkcji loans
#nazwa pliku przechowujaca kredyty 