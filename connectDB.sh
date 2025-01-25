#! /usr/bin/bash
shopt -s extglob

source listTables.sh
source dropTable.sh
source selectFromTable.sh
source deleteFromTable.sh
source listDatabases.sh
source createTable.sh
source updateTable.sh

function connectDB(){
    listDatabases
    read -r -p "Enter DataBase Name : " dbName 

    if [[ -d $HOME/.Database/$dbName ]]; then
        cd $HOME/.Database/$dbName
        echo "successfully connected to database" $dbName
        displayMenu
    elif [[ -e $HOME/.Database/$dbName ]]; then
        echo "Error:" $dbName "exists but is not a Database!"
        return 1
    else
        echo "Error: No Database found with the name" $dbName 
        return 1
    fi 
}

function displayMenu(){
    echo "Choose an option from the following options:"
    echo "1- Create a table"
    echo "2- Drop table"
    echo "3- Insert into table"
    echo "4- Select from table"
    echo "5- Delete from table"
    echo "6- Update table"
    echo "7- List tables of DB"
    echo "8- exit"
    
    read -r -p "Enter your choice:" choice
    
    case $choice in
        1) createTable ;;
        2) drop_table ;;
        3) insert_data ;;
        4) select_from_table ;;
        5) delete_from_table ;;
        6) updateTable ;;
        7) listTables ;;
        8) exit ;;
        *) echo "Invalid choice, please try again"; displayMenu ;;
    esac
}


# Function to check if a value is an integer
function is_integer() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}


function insert_data() {
    local table_name
    local metadata_file
    local data_file
    local primary_key_index=-1
    local primary_key_value
    local column_names=()
    local column_types=()
    local column_values=()

    
    echo "Available tables in '$dbName':"
    while true; do
        ls "$HOME/.Database/$dbName" | grep "_metadata.txt" | sed 's/_metadata.txt//'
        read -r -p "Enter the table name: " table_name

        metadata_file="$HOME/.Database/$dbName/${table_name}_metadata.txt"
        data_file="$HOME/.Database/$dbName/${table_name}.txt"

        if [[ -f "$metadata_file" && -f "$data_file" ]]; then
            echo "Table '$table_name' selected."
            break
        else
            echo "Table '$table_name' does not exist. Please enter a valid table name."
        fi
    done


    while IFS=, read -r column_name column_type is_primary_key; do
        column_names+=("$column_name")
        column_types+=("$column_type")
        if [[ "$is_primary_key" == "yes" ]]; then
            primary_key_index=${#column_names[@]}-1
        fi
    done < <(tail -n +2 "$metadata_file")  

    if [[ ! -s "$data_file" ]]; then
        echo "${column_names[*]}" | tr ' ' ',' > "$data_file"
    fi

    
    for i in "${!column_names[@]}"; do
        local value
        

        
        while true; do
            read -r -p "Enter value for ${column_names[i]} (Type: ${column_types[i]}): " value
            
            
            if [[ "${column_types[i]}" == "Integer" ]]; then
                if is_integer "$value"; then
                    values[i]="$value"  
                    break
                else
                    echo "Error: ${column_names[i]} must be an integer."
                fi
            else
                
                values[i]="$value"
                break
            fi
        done

        
        if [[ $i -eq $primary_key_index ]]; then
            primary_key_value="$value"
            if grep -q "^$primary_key_value," "$data_file"; then
                echo "Error: Primary key '$primary_key_value' already exists."
                return 1
            fi
        fi

        column_values+=("$value")
    done

    
    echo "${column_values[*]}" | tr ' ' ',' >> "$data_file"
    echo "Data inserted successfully into '$table_name'."
}


export -f connectDB