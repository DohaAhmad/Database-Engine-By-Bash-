function dropDB() {
    read -r -p "Enter the name of the database to delete: " DBName
    if [[ -d $HOME/.Database/$DBName ]]; then
        rm -r "$HOME/.Database/$DBName"
        echo "Database '$DBName' deleted successfully"
    else
        echo "Error: Database '$DBName' does not exist"
    fi
}

export -f dropDB