#!/bin/bash

# Path to the Python script
PYTHON_SCRIPT="/home/user/coding-projects/scripts/automation/generate_commit_message.py"

# Check for unstaged changes
if [[ -z $(git status --porcelain) ]]; then
    echo "No changes detected. Nothing to commit."
    exit 0
fi

# Capture the git diff
GIT_DIFF=$(git diff)

# Generate commit message using Python script
COMMIT_MESSAGE=$(echo "$GIT_DIFF" | python3 "$PYTHON_SCRIPT")

# Check if commit message was generated
if [[ -z "$COMMIT_MESSAGE" ]]; then
    echo "Failed to generate commit message."
    exit 1
fi

echo "Generated Commit Message:"
echo "-------------------------"
echo "$COMMIT_MESSAGE"
echo "-------------------------"

# Prompt user to approve or reject the commit message
read -p "Do you approve this commit message? (y/n): " APPROVE_MSG
if [[ "$APPROVE_MSG" != "y" && "$APPROVE_MSG" != "Y" ]]; then
    echo "Commit aborted by user."
    exit 0
fi

# List modified and tracked files
MODIFIED_FILES=$(git diff --name-only)
echo "Modified Files:"
echo "$MODIFIED_FILES"

# Prompt user to approve or reject files to stage
read -p "Do you want to stage all modified files? (y/n): " APPROVE_FILES
if [[ "$APPROVE_FILES" == "y" || "$APPROVE_FILES" == "Y" ]]; then
    git add .
else
    echo "Staging aborted by user."
    exit 0
fi

# Final confirmation before committing
read -p "Proceed with commit? (y/n): " FINAL_CONFIRM
if [[ "$FINAL_CONFIRM" != "y" && "$FINAL_CONFIRM" != "Y" ]]; then
    echo "Commit aborted by user."
    exit 0
fi

# Allow user to add additional information to the commit message
read -p "Would you like to add additional information to the commit message? (y/n): " ADD_INFO
if [[ "$ADD_INFO" == "y" || "$ADD_INFO" == "Y" ]]; then
    read -p "Enter additional commit message: " EXTRA_MESSAGE
    COMMIT_MESSAGE="$COMMIT_MESSAGE - $EXTRA_MESSAGE"
fi

# Perform the commit
git commit -m "$COMMIT_MESSAGE"

# Confirm commit
if [[ $? -eq 0 ]]; then
    echo "Commit successful!"
else
    echo "Commit failed."
    exit 1
fi
