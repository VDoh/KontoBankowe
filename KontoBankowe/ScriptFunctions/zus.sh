#!/bin/bash

source $(dirname $0)/ordinaryTransfer.sh
source $(dirname $0)/standingOrders.sh

function kCalculateZus
{
    local pusPercentage="0.3409"
    local puzPercentage="0.09"
    local pus=$(awk -v a="$1" -v b="$pusPercentage" 'BEGIN {print a*b}')
    local puz=$(awk -v a="$2" -v b="$puzPercentage" 'BEGIN {print a*b}')
    local zusValue=$(awk -v a="$pus" -v b="$puz" 'BEGIN {print a+b}')
    
    printf "%.0f" $zusValue
}

#It will read PUS and PUZ from file
function cAddZusToStandingOrders
{
    clear
    local zusInfo=$(grep ZUS "$(dirname $0)/standingOrders.txt")

    if ! [ "$zusInfo" ]
    then
        local pus=2665
        local puz=3554
        local amount=$(kCalculateZus $pus $puz)

        cAddStandingOrder "Firm" "99999999999999999999999999" $amount "15" "ZUS" "0000000000"

        echo "Added ZUS to standing orders."
        sleep 3
    fi
}

function cTransferToZus
{
    clear
    cCreateStandingOrdersFile

    local zusInfoLine=$(grep ZUS "$(dirname $0)/standingOrders.txt")

    if ! [ "$zusInfoLine" ] 
    then 
        echo "You haven't setup your ZUS standing order yet."
        echo "You need to do this before attempting an automatic transfer to ZUS."
        sleep 3
        return
    fi
    
    local zusInfo=($zusInfoLine)
    local amount=$(kCalculateZus 2665 3554)

    cOrdinaryTransfer ${zusInfo[0]} ${zusInfo[1]} ${zusInfo[2]} ${zusInfo[3]} ${zusInfo[4]}
}