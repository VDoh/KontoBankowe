#!/bin/bash

source $(dirname $0)/leasing.sh
source $(dirname $0)/loans_and_credits.sh


echo "Active LOANS"

echo "LOANS"
ShowInfoCreditAndLoans

echo "LEASING"
mShowFromLeasing