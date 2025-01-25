#! /usr/bin/bash
export LC_COLLATE=C

source connectDB.sh
source listDatabases.sh
source removeDB.sh

shopt -s extglob
export PS3="Please Choose One Choice : "
function check_name() {
    local processed_name=$(echo "$1" | tr ' ' '_')
    
    if [[ $processed_name = [0-9]* ]]; then
        echo "Error: Database can't start with numbers"
        return 1
    else
        case $processed_name in
            +([a-zA-Z_0-9]))
                    return 0
            ;;
            *)
                echo "Error: Database can't contain special characters"
                    return 1
            ;;
        esac
    fi
}

function create_Database() {
    if [[ -d $HOME/.Database ]]; then 
        echo "Welcome To DataBase!"
    else 
        mkdir $HOME/.Database
        echo "Database Created"
    fi 

    read -r -p "Enter Database Name: " DBName
    check_name "$DBName"
    
    if (( $? == 0 )); then
        if [[ -d $HOME/.Database/$DBName ]]; then
            echo "Error: This Database Already Exists"
        else 
            mkdir "$HOME/.Database/$DBName"
            echo "Database '$DBName' Created"
        fi
    fi
}


select choice in CreateDB ConnectDB ListDB RemoveDB "Exit"
do
    case $REPLY in 
    1)
        create_Database
    ;;
    2) 
        connectDB
    ;;
    3)
        listDatabases
    ;;
    4)
        dropDB
    ;;
    5)
        echo "Exit"
        break
    ;;
    *)
        echo "Please Enter vaild input"
    ;;
    esac
done
