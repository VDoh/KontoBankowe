#!/bin/bash
# Funkcja ZUS przyjmuje jako pierwszy argument podstawe ubezpieczenia spolecznego, jako drugi podstawe ubezpieczenia zdrowotnego
# Funkcja zwraca echem sumę ZUS

function ZUS()
{
    local PodstawaUbezpieczeniaSpolecznego=0
    local PodstawaUbezpieczeniaZdrowotnego=0
    local ZUSvalue=0
    local PUSpercentage="0.3409"
    local PUZpercentage="0.09"

    PodstawaUbezpieczeniaSpolecznego=$(awk -v a="$1" -v b="$PUSpercentage" 'BEGIN {print a*b}')

    PodstawaUbezpieczeniaZdrowotnego=$(awk -v a="$2" -v b="$PUZpercentage" 'BEGIN {print a*b}')

    ZUSvalue=$(awk -v a="$PodstawaUbezpieczeniaSpolecznego" -v b="$PodstawaUbezpieczeniaZdrowotnego" 'BEGIN {print a+b}')
    echo $ZUSvalue
}
