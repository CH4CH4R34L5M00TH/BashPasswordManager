#!/bin/bash

# Define the password file
password_file="passwords.txt"

# Check if the password file exists
if [ ! -f $password_file ]; then
    touch $password_file
fi

# Define a function to generate a secure password
generate_password() {
    local password=$(openssl rand -base64 12)
    echo $password
}

# Define a function to add a new account and password to the password file
add_password() {
    local account=$1
    local password=$2
    echo "$account: $password" >> $password_file
}

# Define a function to retrieve a password for a given account
get_password() {
    local account=$1
    local password=$(grep "^$account:" $password_file | awk -F': ' '{print $2}')
    echo $password
}

# Define a function to list all the accounts and their passwords
list_passwords() {
    cat $password_file
}

# Start the password manager loop
while true; do
    # Prompt the user for input
    read -p "Enter a command (add, get, list, quit): " command

    # Handle the different commands
    case $command in
        "add")
            read -p "Enter the account name: " account
            password=$(generate_password)
            add_password $account $password
            echo "Added password for $account: $password"
            ;;
        "get")
            read -p "Enter the account name: " account
            password=$(get_password $account)
            if [ -z $password ]; then
                echo "Password not found for $account"
            else
                echo "Password for $account: $password"
            fi
            ;;
        "list")
            list_passwords
            ;;
        "quit")
            exit 0
            ;;
        *)
            echo "Invalid command"
            ;;
    esac
done
