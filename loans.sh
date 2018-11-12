#!/bin/bash 

##balance

declare balanceAfterCredit=0


###Uwaga moze byc problem z balance czyli aktualnym stanem konta mozliwa bedzie zmiana zmiennej balance na taka odczytana z pliku
function Loans()
{
    echo "Here you can take a credit "
    echo "Do you want take a credit? "
    echo "1) YES"
    echo "2) NO"

    local pick 
    read pick

    until  [[ $pick -gt 0 ]] && [[ $pick =~ $re ]] && [[ $pick -gt 3 ]]
    do 
        echo "Smth went wrong Expected 1 or 2 "
        echo "Enter again"
        read pick 
    done 

    case $pick in 
        "1") 
            echo "For how much months do you wanna take credit? "
            local creditTime
            read creditTime

            until  [[ $creditTime -gt 0 ]] && [[ $creditTime =~ $re ]] 
            do 
                    echo "Smth went wrong expected unsigned number "
                    echo "Enter again"
                    read creditTime
                    clear 
            done 

            echo "Money pls: "

            local moneyLoan 
            read moneyLoan

            until  [[ $moneyLoan -gt 0 ]] && [[ $moneyLoan =~ $re ]] 
            do 
                    echo "Smth went wrong expected unsigned number "
                    echo "Enter again"
                    read moneyLoan 
                    clear
            done 
            
            echo "Credit Granted"

            let balanceAfterCredit=balance+moneyLoan

            ;;

        "2")
            echo "Going Back "
            
            ;;
    esac

}