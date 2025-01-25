source connectDB.sh

# Function to check if a value is an integer
function is_integer() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

# Function to insert data into a table
function insert_data() {
    dbName
    local table_name
    local metadata_file
    local data_file
    local primary_key_index=-1
    local primary_key_value
    local column_names=()
    local column_types=()
    local column_values=()

    
    echo "Available tables:"
    while true; do
        ls "$HOME/.Database/$db_name" | grep "_metadata.txt" | sed 's/_metadata.txt//'
        read -r -p "Enter the table name: " table_name

        # Define file paths
        metadata_file="$HOME/.Database/$db_name/${table_name}_metadata.txt"
        data_file="$HOME/.Database/$db_name/${table_name}_data.txt"

        # Check if the table exists
        if [[ -f "$metadata_file" && -f "$data_file" ]]; then
            echo "Table '$table_name' selected."
            break
        else
            echo "Table '$table_name' does not exist. Please enter a valid table name."
        fi
    done

    # Read metadata
    while IFS=, read -r column_name column_type is_primary_key; do
        column_names+=("$column_name")
        column_types+=("$column_type")
        if [[ "$is_primary_key" == "yes" ]]; then
            primary_key_index=${#column_names[@]}-1
        fi
    done < <(tail -n +2 "$metadata_file")  # Skip the header line

    # Write column names as the first line in the data file if it's empty
    if [[ ! -s "$data_file" ]]; then
        echo "${column_names[*]}" | tr ' ' ',' > "$data_file"
    fi

    # Input data for each column
    for i in "${!column_names[@]}"; do
        local value
        

        # Check data type
        while true; do
            read -r -p "Enter value for ${column_names[i]} (Type: ${column_types[i]}): " value
            
            # Check if the column type is Integer
            if [[ "${column_types[i]}" == "Integer" ]]; then
                if is_integer "$value"; then
                    values[i]="$value"  # Store the valid value
                    break
                else
                    echo "Error: ${column_names[i]} must be an integer."
                fi
            else
                # If not Integer, take any input as valid
                values[i]="$value"
                break
            fi
        done

        # Check primary key uniqueness using grep
        if [[ $i -eq $primary_key_index ]]; then
            primary_key_value="$value"
            if grep -q "^$primary_key_value," "$data_file"; then
                echo "Error: Primary key '$primary_key_value' already exists."
                return 1
            fi
        fi

        column_values+=("$value")
    done

    # Insert data
    echo "${column_values[*]}" | tr ' ' ',' >> "$data_file"
    echo "Data inserted successfully into '$table_name'."
}

export -f insert_data