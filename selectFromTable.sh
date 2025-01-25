function select_from_table() {
    echo $dbName
    read -r -p "Enter the table name: " TableName

    if [[ -f $HOME/.Database/$dbName/$TableName.txt ]]; then
        echo "Select Options:"
        select option in "Select All Data" "Select Data by Column" "Select Data by Row (Primary Key)" "Back to Previous Menu"
        do
            case $REPLY in
            1)
                echo "Table Contents:"
                column -t -s ',' "$HOME/.Database/$dbName/$TableName.txt"
                ;;
            2)
                # Extract column names from the header row
                IFS=',' read -ra Columns <<< "$(head -n 1 "$HOME/.Database/$dbName/$TableName.txt")"
                echo "Columns Available: ${Columns[*]}"
                read -r -p "Enter the column name to select: " ColumnName
                
                # Find the column index
                ColumnIndex=-1
                for i in "${!Columns[@]}"; do
                    if [[ ${Columns[i]} == "$ColumnName" ]]; then
                        ColumnIndex=$i
                        break
                    fi
                done

                if [[ $ColumnIndex -eq -1 ]]; then
                    echo "Error: Column '$ColumnName' does not exist"
                else
                    echo "Data from Column '$ColumnName':"
                    # Display the selected column, including the header
                    awk -F',' -v col=$((ColumnIndex + 1)) '{print $col}' "$HOME/.Database/$dbName/$TableName.txt"
                fi
                ;;
            3)
                read -r -p "Enter the Primary Key to search for: " PrimaryKey
                if grep -q "^$PrimaryKey," "$HOME/.Database/$dbName/$TableName.txt"; then
                    echo "Row with Primary Key '$PrimaryKey':"
                    grep "^$PrimaryKey," "$HOME/.Database/$dbName/$TableName.txt"
                else
                    echo "Error: No row found with Primary Key '$PrimaryKey'"
                fi
                ;;
            4)
                echo "Returning to the previous menu..."
                break
                ;;
            *)
                echo "Please enter a valid option"
                ;;
            esac
        done
    else
        echo "Error: Table '$TableName.txt' does not exist"
    fi
}