#!/bin/bash

# Function to execute the backup using scp
execute_backup() {
    echo "Starting backup at $(date)" | tee -a "$logfile"
    read -s -p "Enter the password for $username@$remote_server: " user_password
    echo   # Blank line for better formatting after password input

    # Confirm the backup source directory exists
    if [ ! -d "$backup_source" ]; then
        echo "Error: The source directory '$backup_source' does not exist. Please check the path and try again." | tee -a "$logfile"
        exit 1
    fi

    # Construct the full destination path
    backup_dest="$username@$remote_server:$remote_path"

    # Show a message indicating the backup has started
    echo "Backing up files from $backup_source to $backup_dest..." | tee -a "$logfile"

    # Execute scp command with password provided by the user
    sshpass -p "$user_password" scp -r "$backup_source" "$backup_dest" >> "$logfile" 2>&1
    backup_status=$?

    if [ $backup_status -eq 0 ]; then
        echo "Backup completed successfully at $(date)" | tee -a "$logfile"
    else
        echo "Backup failed with error code $backup_status at $(date)" | tee -a "$logfile"
        echo "Please check the log file ($logfile) for more details."
    fi

    # Clear the password variable for security
    unset user_password
}

# Function to check if a given path is a valid directory
validate_directory() {
    while [ ! -d "$1" ]; do
        read -p "Error: The directory '$1' does not exist. Please enter a valid source directory: " backup_source
    done
}

# Function to validate the log file path
validate_logfile() {
    touch "$1" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Error: Cannot write to log file path '$1'. Please check permissions or enter a different path."
        read -p "Enter a valid path for the log file: " logfile
        validate_logfile "$logfile"
    fi
}

# Function to display usage instructions
display_help() {
    echo "Usage: $0"
    echo
    echo "This script backs up a source directory to a remote server using SCP."
    echo "You will be prompted to provide source and destination paths, as well as the password for the remote server."
    echo
    echo "Options:"
    echo "  -h, --help   Show this help message and exit."
    exit 0
}

# Check if the user asked for help
if [[ $1 == "--help" || $1 == "-h" ]]; then
    display_help
fi

# Prompt user for inputs with validation
read -p "Enter the path to the source directory to backup: " backup_source
validate_directory "$backup_source"

read -p "Enter the username for the remote server: " username
read -p "Enter the remote server address (e.g., remote-server.com): " remote_server
read -p "Enter the destination path on the remote server (e.g., /path/to/backup/destination): " remote_path

read -p "Enter the path for the log file: " logfile
validate_logfile "$logfile"

# Main script execution
execute_backup

