#!/bin/bash

# Git Manager Installation Script

# Set color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${GREEN}"
echo "====================================================="
echo "          Git Repository Manager Installer           "
echo "====================================================="
echo -e "${NC}"

# Create directories
echo -e "${YELLOW}Creating installation directories...${NC}"

# Define installation directory
DEFAULT_INSTALL_DIR="$HOME/.git-manager"
echo -e "Where would you like to install Git Manager? (default: $DEFAULT_INSTALL_DIR)"
read -r INSTALL_DIR

if [[ -z $INSTALL_DIR ]]; then
    INSTALL_DIR=$DEFAULT_INSTALL_DIR
fi

# Create directory structure
mkdir -p "$INSTALL_DIR/lib"

# Create the base script files
echo -e "${YELLOW}Creating scripts...${NC}"

# Main script
cat > "$INSTALL_DIR/git-manager.sh" << 'EOF'
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
EOF

# Create library files
echo -e "${YELLOW}Creating library files...${NC}"

# Colors library
cat > "$INSTALL_DIR/lib/colors.sh" << 'EOF'
#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
EOF

# Common library
cat > "$INSTALL_DIR/lib/common.sh" << 'EOF'
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
EOF

# Create symbolic link to make the command available system-wide
if [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
    echo -e "${YELLOW}Creating symbolic link in /usr/local/bin...${NC}"
    chmod +x "$INSTALL_DIR/git-manager.sh"
    ln -sf "$INSTALL_DIR/git-manager.sh" /usr/local/bin/git-manager
    echo -e "${GREEN}Symbolic link created. You can now run 'git-manager' from anywhere.${NC}"
else
    echo -e "${YELLOW}Could not create symbolic link in /usr/local/bin (permission denied).${NC}"
    echo -e "${YELLOW}To use the script, run: ${NC}"
    echo -e "  ${GREEN}bash $INSTALL_DIR/git-manager.sh${NC}"
    echo -e "${YELLOW}Or add an alias to your shell config:${NC}"
    echo -e "  ${GREEN}alias git-manager='bash $INSTALL_DIR/git-manager.sh'${NC}"
fi

# Copy all other library files
echo -e "${YELLOW}Enter the path where you downloaded all the library files:${NC}"
read -r LIB_SOURCE

if [ -d "$LIB_SOURCE" ]; then
    cp -f "$LIB_SOURCE/lib-branch.sh" "$INSTALL_DIR/lib/branch.sh" 2>/dev/null
    cp -f "$LIB_SOURCE/lib-commit.sh" "$INSTALL_DIR/lib/commit.sh" 2>/dev/null
    cp -f "$LIB_SOURCE/lib-merge.sh" "$INSTALL_DIR/lib/merge.sh" 2>/dev/null
    cp -f "$LIB_SOURCE/lib-tags.sh" "$INSTALL_DIR/lib/tags.sh" 2>/dev/null
    cp -f "$LIB_SOURCE/lib-remotes.sh" "$INSTALL_DIR/lib/remotes.sh" 2>/dev/null
    cp -f "$LIB_SOURCE/lib-logs.sh" "$INSTALL_DIR/lib/logs.sh" 2>/dev/null
    cp -f "$LIB_SOURCE/lib-untracked.sh" "$INSTALL_DIR/lib/untracked.sh" 2>/dev/null
    cp -f "$LIB_SOURCE/lib-file-picker.sh" "$INSTALL_DIR/lib/file_picker.sh" 2>/dev/null
    
    echo -e "${GREEN}Library files copied successfully.${NC}"
else
    echo -e "${RED}Library source directory not found.${NC}"
    echo -e "${YELLOW}You'll need to manually copy the library files to $INSTALL_DIR/lib/${NC}"
fi

echo -e "${GREEN}"
echo "====================================================="
echo "          Git Repository Manager Installed           "
echo "====================================================="
echo -e "Installation Directory: $INSTALL_DIR"
echo -e "${NC}"
echo -e "${YELLOW}You can run the script by typing:${NC} git-manager"
echo ""

