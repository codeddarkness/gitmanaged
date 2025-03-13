#!/bin/bash

# Function to display the header
display_header() {
    clear
    echo -e "${BLUE}====================================${NC}"
    echo -e "${GREEN}       GIT REPOSITORY MANAGER      ${NC}"
    echo -e "${BLUE}====================================${NC}"
    echo ""
    
    # Display current git status
    echo -e "${YELLOW}Current Git Status:${NC}"
    echo "Repository: $(basename -s .git $(git config --get remote.origin.url 2>/dev/null || echo 'Not configured'))"
    echo "Current Branch: $(git branch --show-current 2>/dev/null || echo 'Not in a git repository')"
    echo "Remote: $(git config --get remote.origin.url 2>/dev/null || echo 'Not configured')"
    
    # Display latest tag if any
    latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)
    if [[ -n $latest_tag ]]; then
        echo "Latest Tag: $latest_tag"
    else
        echo "Latest Tag: None"
    fi
    
    echo -e "${BLUE}====================================${NC}"
    echo ""
}

# Function to check if directory is a git repository
check_git_repo() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "${RED}Error: Not inside a git repository.${NC}"
        echo "Would you like to initialize a git repository here? (y/n)"
        read -r init_choice
        if [[ $init_choice == "y" || $init_choice == "Y" ]]; then
            git init
            echo -e "${GREEN}Git repository initialized.${NC}"
        else
            return 1
        fi
    fi
    return 0
}
