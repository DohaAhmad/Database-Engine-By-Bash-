function drop_table() {
    read -r -p "Enter the table name to delete: " TableName
    if [[ -f $HOME/.Database/$dbName/$TableName.txt ]]; then
        read -r -p "Are you sure you want to delete the table '$TableName'? (y/n): " confirmation
        if [[ $confirmation == "y" || $confirmation == "Y" ]]; then
            rm "$HOME/.Database/$dbName/$TableName.txt"
            rm "$HOME/.Database/$dbName/${TableName}_metadata.txt"
            echo "Table '$TableName.txt' deleted successfully"
        else
            echo "Operation canceled. Table '$TableName.txt' was not deleted."
        fi
    else
        echo "Error: Table '$TableName.txt' does not exist"
    fi
}

export -f drop_table