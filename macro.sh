#!/bin/bash

# Global variable to store MongoDB Atlas connection string
atlas_connection=""

# Function to initialize MongoDB Atlas connection
initialize_mongodb_connection() {
  if [ -z "$atlas_connection" ]; then
    read -p "Enter MongoDB Atlas connection string (without quotes): " atlas_connection
  else
    echo "MongoDB Atlas connection already initialized."
  fi
}

# Function to list databases from MongoDB Atlas
list_mongodb_databases() {
  initialize_mongodb_connection
  echo "Fetching list of databases..."
  mongo "$atlas_connection" --eval "db.adminCommand('listDatabases')"
}

# Function for MongoDB Operations (with MongoDB Atlas)
mongodb_operations() {
  initialize_mongodb_connection
  echo "Fetching list of databases..."
  db_list=$(mongo "$atlas_connection" --eval "db.adminCommand('listDatabases')" --quiet | grep 'name' | awk -F ': ' '{print $2}' | tr -d '",')

  echo "Available databases:"
  echo "$db_list"
  read -p "Enter the database name from the list above: " db_name

  echo "MongoDB Atlas Operations:"
  echo "1. Insert Data"
  echo "2. Find Data"
  echo "3. Update Data"
  echo "4. Delete Data"
  echo "5. Drop Collection"
  echo "6. Create Collection"
  echo "7. Show Collections in Selected Database"
  read -p "Select a MongoDB operation: " mongo_choice

  case $mongo_choice in
    1) 
      read -p "Enter collection name: " collection_name
      read -p "Enter MongoDB insert query (JSON format): " insert_query
      mongo "$atlas_connection/$db_name" --eval "db.$collection_name.insert($insert_query)"
      ;;
    2) 
      read -p "Enter collection name: " collection_name
      read -p "Enter MongoDB find query (JSON format): " find_query
      mongo "$atlas_connection/$db_name" --eval "db.$collection_name.find($find_query)"
      ;;
    3) 
      read -p "Enter collection name: " collection_name
      read -p "Enter MongoDB update query (JSON format): " update_query
      mongo "$atlas_connection/$db_name" --eval "db.$collection_name.update($update_query)"
      ;;
    4) 
      read -p "Enter collection name: " collection_name
      read -p "Enter MongoDB delete query (JSON format): " delete_query
      mongo "$atlas_connection/$db_name" --eval "db.$collection_name.remove($delete_query)"
      ;;
    5) 
      read -p "Enter collection name to drop: " collection_name
      mongo "$atlas_connection/$db_name" --eval "db.$collection_name.drop()"
      ;;
    6) 
      read -p "Enter new collection name: " new_collection
      mongo "$atlas_connection/$db_name" --eval "db.createCollection('$new_collection')"
      ;;
    7)
      echo "Fetching collections for database: $db_name"
      mongo "$atlas_connection/$db_name" --eval "db.getCollectionNames()"
      ;;
    *) 
      echo "Invalid selection!"
      ;;
  esac
}

# Function for Git Operations
git_operations() {
  echo "Git Operations:"
  echo "1. Clone Repository"
  echo "2. Pull Repository"
  echo "3. Show Git Status"
  echo "4. Add Files"
  echo "5. Commit Changes"
  echo "6. Create New Branch"
  echo "7. Switch Branch"
  echo "8. Show Git Logs"
  echo "9. Checkout Git Logs"
  echo "10. Delete Branch"
  echo "11. Rename Branch"
  echo "12. Revert Commit"
  read -p "Select a Git operation: " git_choice

  case $git_choice in
    1) read -p "Enter repository URL: " repo_url
       git clone $repo_url ;;
    2) git pull ;;
    3) git status ;;
    4) read -p "Enter files to add (or '.' for all): " files
       git add $files ;;
    5) read -p "Enter commit message: " commit_message
       git commit -m "$commit_message" ;;
    6) read -p "Enter new branch name: " branch_name
       git branch $branch_name ;;
    7) read -p "Enter branch to switch to: " branch_name
       git checkout $branch_name ;;
    8) git log ;;
    9) read -p "Enter commit hash to checkout: " commit_hash
       git checkout $commit_hash ;;
    10) read -p "Enter branch name to delete: " branch_name
        git branch -d $branch_name ;;
    11) read -p "Enter old branch name: " old_name
        read -p "Enter new branch name: " new_name
        git branch -m $old_name $new_name ;;
    12) read -p "Enter commit hash to revert: " commit_hash
        git revert $commit_hash ;;
    *) echo "Invalid selection!" ;;
  esac
}

# Function for NPM Package Installation
install_npm_packages() {
  read -p "Enter package names to install (space-separated): " packages
  npm install $packages
}

# Function for SQL Database Operations
sql_operations() {
  echo "SQL Operations:"
  echo "1. Create Table"
  echo "2. Insert Data"
  echo "3. Select Data"
  echo "4. Update Data"
  echo "5. Delete Data"
  echo "6. Drop Table"
  echo "7. Alter Table"
  echo "8. Truncate Table"
  echo "9. Rename Table"
  read -p "Select an SQL operation: " sql_choice

  case $sql_choice in
    1) 
      read -p "Enter SQL query to create table: " create_query
      mysql -u <user> -p -e "$create_query"
      ;;
    2) 
      read -p "Enter SQL insert query: " insert_query
      mysql -u <user> -p -e "$insert_query"
      ;;
    3) 
      read -p "Enter SQL select query: " select_query
      mysql -u <user> -p -e "$select_query"
      ;;
    4) 
      read -p "Enter SQL update query: " update_query
      mysql -u <user> -p -e "$update_query"
      ;;
    5) 
      read -p "Enter SQL delete query: " delete_query
      mysql -u <user> -p -e "$delete_query"
      ;;
    6) 
      read -p "Enter SQL query to drop table: " drop_query
      mysql -u <user> -p -e "$drop_query"
      ;;
    7) 
      read -p "Enter SQL alter query: " alter_query
      mysql -u <user> -p -e "$alter_query"
      ;;
    8) 
      read -p "Enter SQL truncate query: " truncate_query
      mysql -u <user> -p -e "$truncate_query"
      ;;
    9) 
      read -p "Enter SQL query to rename table: " rename_query
      mysql -u <user> -p -e "$rename_query"
      ;;
    *) 
      echo "Invalid selection!"
      ;;
  esac
}


# Function to Dockerize MERN Stack Website
dockerize_mern_stack() {
  echo "Dockerizing your MERN stack website..."
  
  # Dockerfile template for MERN stack website
  cat <<EOF > Dockerfile
# Backend
FROM node:14 AS backend
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm install
COPY backend/ .
EXPOSE 5000
CMD ["npm", "start"]

# Frontend
FROM node:14 AS frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ .
RUN npm run build

# Final stage
FROM nginx:alpine
COPY --from=frontend /app/frontend/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

  echo "Dockerfile created for MERN stack website."
  echo "To build and run the Docker container:"
  echo "1. Build the Docker image: docker build -t mern-app ."
  echo "2. Run the Docker container: docker run -p 80:80 mern-app"
  echo "Prerequisites: Ensure Docker is installed and running."
}

# Main Menu
while true; do
  echo "Main Menu:"
  echo "1. Git Operations"
  echo "2. Install NPM Packages"
  echo "3. SQL Database Operations"
  echo "4. MongoDB Operations"
  echo "5. Dockerize Your MERN Stack Website"
  echo "6. Exit"
  read -p "Select an option: " choice

  case $choice in
    1) git_operations ;;
    2) install_npm_packages ;;
    3) sql_operations ;;
    4) mongodb_operations ;;
    5) dockerize_mern_stack ;;
    6) exit 0 ;;
    *) echo "Invalid choice, please try again." ;;
  esac
done
