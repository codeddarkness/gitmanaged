#!/bin/bash

# Git Repository Manager Script
# This script provides a CLI menu to manage git repositories

# Load utility scripts
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/branch.sh"
source "$SCRIPT_DIR/lib/commit.sh"
source "$SCRIPT_DIR/lib/merge.sh"
source "$SCRIPT_DIR/lib/tags.sh"
source "$SCRIPT_DIR/lib/remotes.sh"
source "$SCRIPT_DIR/lib/logs.sh"
source "$SCRIPT_DIR/lib/untracked.sh"
source "$SCRIPT_DIR/lib/file_picker.sh"

# Function to display the main menu
display_menu() {
    echo -e "${GREEN}Select an option:${NC}"
    echo "1. Show git status"
    echo "2. Commit changes"
    echo "3. Push changes"
    echo "4. Pull changes"
    echo "5. Branch management"
    echo "6. Fix branch rename issues"
    echo "7. Merge branches"
    echo "8. Manage tags"
    echo "9. Manage remotes"
    echo "10. View logs"
    echo "11. Manage untracked files"
    echo "12. Pick files from branches"
    echo "0. Exit"
    echo ""
}

# Function to show git status
git_status() {
    echo -e "\n${YELLOW}Git Status:${NC}"
    git status
    echo ""
    read -p "Press Enter to continue..."
}

# Function to handle pushing changes
push_changes() {
    current_branch=$(git branch --show-current)
    
    echo -e "\n${YELLOW}Current branch: $current_branch${NC}"
    echo -e "${GREEN}Push to which remote? (default: origin)${NC}"
    read -r remote
    
    if [[ -z $remote ]]; then
        remote="origin"
    fi
    
    echo -e "${GREEN}Set upstream? (y/n) (default: y)${NC}"
    read -r set_upstream
    
    if [[ -z $set_upstream || $set_upstream == "y" || $set_upstream == "Y" ]]; then
        git push -u $remote $current_branch
    else
        git push $remote $current_branch
    fi
    
    echo ""
    read -p "Press Enter to continue..."
}

# Function to handle pulling changes
pull_changes() {
    echo -e "\n${YELLOW}Pull from which remote? (default: origin)${NC}"
    read -r remote
    
    if [[ -z $remote ]]; then
        remote="origin"
    fi
    
    echo -e "${YELLOW}Pull from which branch? (default: current branch)${NC}"
    read -r branch
    
    if [[ -z $branch ]]; then
        branch=$(git branch --show-current)
    fi
    
    git pull $remote $branch
    
    echo ""
    read -p "Press Enter to continue..."
}

# Main function
main() {
    if ! check_git_repo; then
        exit 1
    fi
    
    while true; do
        display_header
        display_menu
        
        read -r choice
        
        case $choice in
            1)
                git_status
                ;;
            2)
                commit_changes
                ;;
            3)
                push_changes
                ;;
            4)
                pull_changes
                ;;
            5)
                branch_management
                ;;
            6)
                fix_branch_rename_issues
                ;;
            7)
                merge_branches
                ;;
            8)
                manage_tags
                ;;
            9)
                manage_remotes
                ;;
            10)
                view_logs
                ;;
            11)
                manage_untracked
                ;;
            12)
                pick_files_from_branch
                ;;
            0)
                echo -e "${GREEN}Exiting Git Repository Manager. Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Run the main function
main
