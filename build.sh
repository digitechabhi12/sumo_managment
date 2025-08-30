#!/bin/bash

echo -e "This script will delete the existing build and create a new one\n"

# Delete old build archive if it exists
if [ -d "mta_archives" ]; then
    rm -rf mta_archives
    echo -e "Deleted mta_archives\n"
fi

# Create new MTA build
mbt build
echo -e "Created new mta_archive\n"

# Get the first file from the mta_archives directory
new_file=$(ls mta_archives | head -n 1)

echo -e "Now Deploying ..........."

if [ -n "$new_file" ]; then
    # Automatically confirm aborting any ongoing deployment
    echo "y" | cf deploy "mta_archives/$new_file"
    
    # Optional: check if deployment was successful
    if [ $? -eq 0 ]; then
        echo -e "✅ Deployed mta_archives/$new_file\n..........................!!!!"
    else
        echo -e "❌ Deployment failed.\n"
        exit 1
    fi
else
    echo -e "No files found in mta_archives to deploy.\n"
fi
