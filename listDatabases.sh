function listDatabases(){
    echo "Here is the available Databases"
    ls -F $HOME/.Database/ | grep / | tr '/' ' '

    if [[ $? -ne 0 || -z "$(ls -F ~/.Database/ | grep / | tr '/' ' ')" ]]; then
        echo "Error: No Databases found"
    fi
}

export -f listDatabases