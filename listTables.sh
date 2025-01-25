function listTables(){
    if [[ -z $(ls -p | grep -v /) ]]; then
        echo "No tables were found in this database"
        return 1
    fi
    
    echo "Here are the tables: "
    ls -p | grep -v /
}

export -f listTables
