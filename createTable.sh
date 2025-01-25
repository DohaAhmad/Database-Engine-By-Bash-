shopt -s extglob

function check_namee() {
    local name=$1
    local processed_name

    processed_name=$(echo "$name" | tr ' ' '_')

    if [[ $processed_name = [0-9]* ]]; then
        echo "Error: Name can't start with numbers."
        return 1
    elif [[ ! $processed_name =~ ^[a-zA-Z_0-9]+$ ]]; then
        echo "Error: Name can't contain special characters."
        return 1
    else
        echo "$processed_name"  # Return the valid name
        return 0
    fi
}

function createTable() {
    local db_name=$1
    local table_name
    local column_name
    local column_type
    local primary_key
    local metadata_file
    local data_file

    # Get a valid table name using the check_namee function
    while true; do
        read -r -p "Enter Table Name: " table_name
        if check_namee "$table_name"; then
            table_name=$(check_namee "$table_name")
            break
        fi
    done

    # Define file paths in the current directory
    metadata_file="./${table_name}_metadata.txt"
    data_file="./${table_name}.txt"

    # Check if the table already exists in the current directory
    if [[ -f "$metadata_file" ]]; then
        echo "Error: Table '$table_name' already exists in the current directory."
        return 1
    fi

    # Create metadata file
    echo "Creating table '$table_name' in database"
    echo "Column Name,Column Type,Primary Key" > "$metadata_file"

    # Inserting Metadata
    while true; do
        read -r -p "Enter Column Name (or 'done' to finish): " column_name
        if [[ "$column_name" == "done" ]]; then
            break
        fi

        # Validate column name
        if ! check_namee "$column_name"; then
            continue
        fi
        column_name=$(check_namee "$column_name")

        # Validate column type input
        while true; do
            read -r -p "Enter Column Type (String/Integer): " column_type
            if [[ "$column_type" == "String" || "$column_type" == "Integer" ]]; then
                break
            else
                echo "Invalid column type. Please enter 'String' or 'Integer'."
            fi
        done

        # Validate primary key input
        while true; do
            read -r -p "Is this column a primary key? (yes/no): " primary_key
            if [[ "$primary_key" == "yes" || "$primary_key" == "no" ]]; then
                break
            else
                echo "Invalid input for primary key. Please enter 'yes' or 'no'."
            fi
        done

        # Append metadata
        echo "$column_name,$column_type,$primary_key" >> "$metadata_file"
    done

    # Create an empty data file
    touch "$data_file"
    echo "Table '$table_name' created'."
}

export -f createTable