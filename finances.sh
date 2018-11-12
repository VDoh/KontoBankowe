 #!/bin/bash
function greeting()
{
sleep 1
clear
echo "                   HELLO WELCOME IN OUR SMKM-INTERNATIONALBANK"
echo "    ########################################################################"
echo "   1) FINANCES  2)LOANS  3) SERVICES  4)OFFER  5)HISTORY  6)MAKE TRANSACTIONS   "

}
function changing()
{
read snumber
while [[ $snumber -gt 6 ||  ! $snumber =~ ^[1-6]+$ ]] 
do
if [[ "$number" -lt 6 && $snumber =~ ^[1-6]+$ ]] #
then
echo ""
else
echo "Could you pick again"
fi
read snumber
done
case "$snumber" in
1) 
sleep 1
echo "building"
;;
2)
sleep 1
echo "building"
;;
3)
sleep 1
echo "building"
;;
4)
sleep 1
echo "building"
;;
5)
sleep 1
echo "building"
;;
6)
sleep 1
echo "building"
;;

esac
}
greeting
changing