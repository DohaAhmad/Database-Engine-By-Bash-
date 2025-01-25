function delete_from_table() {
    read -r -p "Enter the table name: " TableName
    if [[ -f $HOME/.Database/$dbName/$TableName.txt ]]; then
        read -r -p "Enter the primary key of the record to delete: " PrimaryKey
        if grep -q "^$PrimaryKey," "$HOME/.Database/$dbName/$TableName.txt"; then
            sed -i "/^$PrimaryKey,/d" "$HOME/.Database/$dbName/$TableName.txt"
            echo "Record with primary key '$PrimaryKey' deleted successfully"
        else
            echo "Error: Record with primary key '$PrimaryKey' not found"
        fi
    else
        echo "Error: Table '$TableName.txt' does not exist"
    fi
}

export -f delete_from_table