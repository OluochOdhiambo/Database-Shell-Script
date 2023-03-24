#!/bin/sh

# Define usage function to show correct usage of the script
usage() {
  echo "Usage: $0 {create|add|lookup|update|delete} [table] [args...]"
  exit 1
}

# Check if the correct number of arguments are supplied
if [ $# -lt 2 ]; then
  usage
fi

# Define variables for the script
command="$1"
table="$2"
if [ -n "$DBFILE_DATABASE" ]; then
  dbdir="$DBFILE_DATABASE"
else
  dbdir="./db"
  mkdir -p "$dbdir"
fi
dbfile="${dbdir}/${table}.csv"

# Check if the table exists
if [ "$command" != "create" ] && [ ! -f "$dbfile" ]; then
  echo "Error: Table '$table' does not exist"
  exit 1
fi

# Define functions for the script

# Create a new table
create_table() {
  # Check if the table already exists
  if [ -f "$dbfile" ]; then
    echo "Error: Table '$table' already exists"
    exit 1
  fi
  
  # Create the table file
  touch "$dbfile"
  
  # Add the field names to the first line of the file
  echo "$2" > "$dbfile"
  
  echo "Table '$table' created"
}

add_record() {
  # Check if the correct number of arguments are supplied
  if [ $# -ne 2 ]; then
    echo "Error: Incorrect number of arguments provided"
    exit 1
  fi

  # Extract field names and values from the command argument
  fields=$(echo "$2" | tr ',' '\n')
  record=""
  for field in $fields
  do
    field_name=$(echo "$field" | cut -d '=' -f 1)
    field_value=$(echo "$field" | cut -d '=' -f 2)
    if [ -z "$record" ]; then
      record="$field_value"
    else
      record="$record,$field_value"
    fi
  done

  # Add the record to the file
  echo "$record" >> "$dbfile"

  echo "Record added to '$table'"
}


# Lookup records in the table
lookup_records() {
  # Get the field names from the first line of the file
  fields=$(head -1 "$dbfile")
  
  # Loop through each record in the file and check if it matches the query
  while read -r record; do
    # Combine the field names and values into a single string
    combined=$(echo "$fields" | tr ',' '\n' | paste -d '=' - <(echo "$record" | tr ',' '\n') | tr '\n' '&')
    
    # Check if the record matches the query
    if echo "$combined" | grep -q "$2"; then
      echo "$record"
    fi
  done < <(tail -n +2 "$dbfile")
}

update_record() {
  
  # Check if the correct number of arguments are supplied
  if [ $# -ne 3 ]; then
    echo "Error: Incorrect number of fields provided"
    exit 1
  fi

  # Extract the query field and value from the argument
  queryField=$(echo "$2" | awk -F= '{print $1}')
  queryValue=$(echo "$2" | awk -F= '{print $2}')


  # Get the field names from the first line of the file
  fields=$(head -1 "$dbfile")

  # Make temp file
  tmpfile=$(mktemp)

  # Get the field names from the first line of the file
  fields=$(head -1 "$dbfile")

  tmpfile=$(mktemp)

  # Loop through each record in the file and update if it matches the query
  while read -r record; do
    # Convert the record into an associative array
    declare -A record_fields
    
    i=0
    for field in $(echo "$fields" | tr ',' ' '); do
      ((i++))
      record_fields[$field]="$(echo "$record" | tr ',' ' ' | awk -v i="$i" '{print $i}')"
    done

    # Check if the record matches the query
    if [ "${record_fields[$queryField]}" = "$queryValue" ]; then

        # Extract the field to update from args
        updateFields=$(echo "$3")
        # i=0
        for updateField in $(echo "$3" | tr ',' ' '); do
            # update_fields[$field]="$(echo "$3" | tr ',' ' ' | awk -v i="$i" '{print $i}')"
            # ((i++))

            updateF=$(echo "${updateField}" | awk -F= '{print $1}')
            updateV=$(echo "${updateField}" | awk -F= '{print $2}')

            # Update the record with the new values
            new_record=""
            for recordField in $(echo "$fields" | tr ',' ' '); do
              
              if [ "$recordField" = "$updateF" ]; then

                # Replace the field value with the new value
                record_fields[$recordField]="$updateV"
              fi
              new_record+="${record_fields[$recordField]},"
            done
            
          done
        echo "${new_record%,}" >> "$tmpfile"
      
    else
      # If the record does not match the query, write it to the temporary file as is
      echo "$record" >> "$tmpfile"
    fi
  done < "$dbfile"

  # Replace the original file with the temporary file
  mv "$tmpfile" "$dbfile"
}


# Delete records from the table
delete_records() {
  # Get the field names from the first line of the file
  fields=$(head -1 "$dbfile")

  # Create a temporary file to hold the updated records
  tmpfile=$(mktemp)
  echo "$fields" >> "$tmpfile"
  # Loop through each record in the file and delete if it matches the query
  while read -r record; do
    # Combine the field names and values into a single string
    combined=$(echo "$fields" | tr ',' '\n' | paste -d '=' - <(echo "$record" | tr ',' '\n') | tr '\n' '&')

    
    # Check if the record matches the query
    if ! echo "$combined" | grep -q "$2"; then
      echo "$record" >> "$tmpfile"
    fi
  done < <(tail -n +2 "$dbfile")

  # Replace the original file with the temporary file
  mv "$tmpfile" "$dbfile"

  echo "Records deleted from '$table'"
}


# Execute the specified command
case "$command" in
  create)
    create_table "$table" "$3"
    ;;
  add)
    add_record "$table" "$3"
    ;;
  lookup)
    lookup_records "$table" "$3"
    ;;
  update)
    update_record "$table" "$3" "$4"
    ;;
  delete)
    delete_records "$table" "$3"
    ;;
  *)
    usage
    ;;
esac