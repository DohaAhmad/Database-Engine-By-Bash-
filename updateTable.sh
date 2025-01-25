function updateTable() {
    local table_name
    local metadata_file
    local data_file
    local column_name
    local column_index
    local condition_column
    local condition_index
    local condition_value
    local column_value
    local column_type
    local temp_file="./temp_data.txt"

    while true; do
        read -r -p "Enter Table Name to Update: " table_name
        metadata_file="./${table_name}_metadata.txt"
        data_file="./${table_name}.txt"

        if [[ ! -f "$metadata_file" || ! -f "$data_file" ]]; then
            echo "Error: Table '$table_name.txt' does not exist in the current Database."
        else
            break
        fi
    done

    echo "Available Columns:"
    awk -F',' 'NR > 1 { print $1 }' "$metadata_file"

    while true; do
        read -r -p "Enter the Column Name to Update: " column_name
        column_index=$(awk -F',' -v col="$column_name" 'NR > 1 { if ($1 == col) print NR }' "$metadata_file")
        column_type=$(awk -F',' -v col="$column_name" 'NR > 1 { if ($1 == col) print $2 }' "$metadata_file")

        if [[ -z "$column_index" ]]; then
            echo "Error: Column '$column_name' does not exist in the table."
        else
            break
        fi
    done

    while true; do
        read -r -p "Enter the Column Name for the Condition: " condition_column
        condition_index=$(awk -F',' -v col="$condition_column" 'NR > 1 { if ($1 == col) print NR }' "$metadata_file")

        if [[ -z "$condition_index" ]]; then
            echo "Error: Condition column '$condition_column' does not exist in the table."
        else
            break
        fi
    done

    read -r -p "Enter the Value for the Condition: " condition_value

    
    awk -F',' -v col_index="$column_index" -v cond_index="$condition_index" \
        -v cond_value="$condition_value" -v new_value="$column_value" \
        'BEGIN { OFS = "," } 
        NR == 1 { print $0 } 
        NR > 1 { 
            if ($cond_index == cond_value) $col_index = new_value; 
            print $0 
        }' "$data_file" > "$temp_file"

    mv "$temp_file" "$data_file"
    echo "Table '$table_name.txt' updated successfully."
}

export -f updateTable