#!/bin/bash

# MongoDB Atlas connection string
ATLAS_URL="mongodb+srv://whitejacker0:dde4aSX2j7hdBk7j@cluster0.8yo94fu.mongodb.net/Hack%40GenAI?retryWrites=true&w=majority&appName=Cluster0"

# Function to list databases
list_databases() {
    mongosh "$ATLAS_URL" --eval "db.adminCommand('listDatabases').databases.forEach(db => print(db.name))" --quiet
}

# Function to list collections in a database
list_collections() {
    local db_name=$1
    mongosh "$ATLAS_URL/$db_name" --eval "db.getCollectionNames().forEach(print)" --quiet
}

# Function to insert a document
insert_document() {
    local db_name=$1
    local coll_name=$2
    echo "Enter document fields in JSON format (e.g., {\"name\": \"John\", \"age\": 30}):"
    read -r doc
    mongosh "$ATLAS_URL/$db_name" --eval "db.$coll_name.insertOne($doc)" --quiet
}

# Function to find documents
find_documents() {
    local db_name=$1
    local coll_name=$2
    echo "Enter query in JSON format (e.g., {\"name\": \"John\"}):"
    read -r query
    mongosh "$ATLAS_URL/$db_name" --eval "db.$coll_name.find($query).forEach(printjson)" --quiet
}

# Function to update a document
update_document() {
    local db_name=$1
    local coll_name=$2
    echo "Enter query to find document in JSON format:"
    read -r query
    echo "Enter update operation in JSON format (e.g., {\"\$set\": {\"age\": 31}}):"
    read -r update
    mongosh "$ATLAS_URL/$db_name" --eval "db.$coll_name.updateOne($query, $update)" --quiet
}

# Function to delete a document
delete_document() {
    local db_name=$1
    local coll_name=$2
    echo "Enter query to find document to delete in JSON format:"
    read -r query
    mongosh "$ATLAS_URL/$db_name" --eval "db.$coll_name.deleteOne($query)" --quiet
}

# Function to aggregate documents
aggregate_documents() {
    local db_name=$1
    local coll_name=$2
    echo "Enter aggregation pipeline in JSON format (e.g., [{\"$group\": {\"_id\": null, \"total\": {\"$sum\": \"$amount\"}}}]):"
    read -r pipeline
    mongosh "$ATLAS_URL/$db_name" --eval "db.$coll_name.aggregate($pipeline).forEach(printjson)" --quiet
}

# Main menu function
main_menu() {
    while true; do
        echo -e "\n--- MongoDB Atlas Operations Menu ---"
        echo "1. List databases"
        echo "2. List collections in a database"
        echo "3. Perform operations on a collection"
        echo "4. Exit"
        read -p "Enter your choice (1-4): " choice

        case $choice in
            1) list_databases ;;
            2) 
                read -p "Enter database name: " db_name
                list_collections "$db_name"
                ;;
            3)
                read -p "Enter database name: " db_name
                read -p "Enter collection name: " coll_name
                collection_operations "$db_name" "$coll_name"
                ;;
            4) echo "Exiting."; exit 0 ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    done
}

# Collection operations menu function
collection_operations() {
    local db_name=$1
    local coll_name=$2
    while true; do
        echo -e "\n--- Collection Operations ---"
        echo "1. Insert document"
        echo "2. Find documents"
        echo "3. Update document"
        echo "4. Delete document"
        echo "5. Aggregate documents"
        echo "6. Return to main menu"
        read -p "Enter your choice (1-6): " op_choice

        case $op_choice in
            1) insert_document "$db_name" "$coll_name" ;;
            2) find_documents "$db_name" "$coll_name" ;;
            3) update_document "$db_name" "$coll_name" ;;
            4) delete_document "$db_name" "$coll_name" ;;
            5) aggregate_documents "$db_name" "$coll_name" ;;
            6) return ;;
            *) echo "Invalid choice. Please try again." ;;
        esac
    done
}

# Start the main menu
main_menu