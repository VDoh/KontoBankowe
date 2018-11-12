function loginscreen()
{
passwordFormat='^[0-9]+$'
loginFormat='^[a-zA-Z]+$'

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
}

loginscreen