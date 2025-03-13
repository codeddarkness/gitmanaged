#!/bin/bash

# Git Manager Setup Script
# This script creates the directory structure and moves libraries to their correct locations

# Set color variables
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}=================================================${NC}"
echo -e "${GREEN}         Git Repository Manager Setup           ${NC}"
echo -e "${BLUE}=================================================${NC}"
echo ""

# Define required libraries
declare -a REQUIRED_LIBS=(
  "lib-colors.sh"
  "lib-common.sh"
  "lib-branch.sh"
  "lib-commit.sh"
  "lib-merge.sh"
  "lib-tags.sh"
  "lib-remotes.sh"
  "lib-logs.sh"
  "lib-untracked.sh"
  "lib-file-picker.sh"
)

# Define source and destination directories
CURRENT_DIR=$(pwd)
DEFAULT_INSTALL_DIR="$HOME/.git-manager"

# Check if we're in the git-manager folder
if [[ "$(basename "$CURRENT_DIR")" != "git-manager" ]]; then
  echo -e "${YELLOW}Warning: Current directory is not named 'git-manager'.${NC}"
  echo -e "${YELLOW}Make sure you're running this script from the folder containing your library files.${NC}"
  echo ""
fi

# Ask for installation directory
echo -e "${YELLOW}Where would you like to install Git Manager? (default: $DEFAULT_INSTALL_DIR)${NC}"
read -r INSTALL_DIR

if [[ -z $INSTALL_DIR ]]; then
  INSTALL_DIR=$DEFAULT_INSTALL_DIR
fi

# Create installation directory if it doesn't exist
if [[ ! -d "$INSTALL_DIR" ]]; then
  echo -e "${YELLOW}Creating installation directory: $INSTALL_DIR${NC}"
  mkdir -p "$INSTALL_DIR"
fi

# Create lib directory if it doesn't exist
if [[ ! -d "$INSTALL_DIR/lib" ]]; then
  echo -e "${YELLOW}Creating library directory: $INSTALL_DIR/lib${NC}"
  mkdir -p "$INSTALL_DIR/lib"
fi

# Check for missing libraries
echo -e "${YELLOW}Checking for required libraries...${NC}"
MISSING_LIBS=0

for lib in "${REQUIRED_LIBS[@]}"; do
  if [[ ! -f "$CURRENT_DIR/$lib" ]]; then
    echo -e "${RED}Missing required library: $lib${NC}"
    MISSING_LIBS=$((MISSING_LIBS + 1))
  fi
done

if [[ $MISSING_LIBS -gt 0 ]]; then
  echo -e "${RED}Found $MISSING_LIBS missing libraries. Please make sure all required files are present.${NC}"
  exit 1
else
  echo -e "${GREEN}All required libraries found.${NC}"
fi

# Check if main script exists or needs to be created
if [[ ! -f "$CURRENT_DIR/git-manager.sh" ]]; then
  echo -e "${YELLOW}Main script file 'git-manager.sh' not found. It will be created.${NC}"
  
  # Create the main script
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
  
  echo -e "${GREEN}Main script file created.${NC}"
else
  # Copy the main script if it exists
  echo -e "${YELLOW}Copying main script file to installation directory...${NC}"
  cp -f "$CURRENT_DIR/git-manager.sh" "$INSTALL_DIR/git-manager.sh"
fi

# Copy library files to their correct locations with proper names
echo -e "${YELLOW}Copying library files to installation directory...${NC}"

cp -f "$CURRENT_DIR/lib-colors.sh" "$INSTALL_DIR/lib/colors.sh"
cp -f "$CURRENT_DIR/lib-common.sh" "$INSTALL_DIR/lib/common.sh"
cp -f "$CURRENT_DIR/lib-branch.sh" "$INSTALL_DIR/lib/branch.sh"
cp -f "$CURRENT_DIR/lib-commit.sh" "$INSTALL_DIR/lib/commit.sh"
cp -f "$CURRENT_DIR/lib-merge.sh" "$INSTALL_DIR/lib/merge.sh"
cp -f "$CURRENT_DIR/lib-tags.sh" "$INSTALL_DIR/lib/tags.sh"
cp -f "$CURRENT_DIR/lib-remotes.sh" "$INSTALL_DIR/lib/remotes.sh"
cp -f "$CURRENT_DIR/lib-logs.sh" "$INSTALL_DIR/lib/logs.sh"
cp -f "$CURRENT_DIR/lib-untracked.sh" "$INSTALL_DIR/lib/untracked.sh"
cp -f "$CURRENT_DIR/lib-file-picker.sh" "$INSTALL_DIR/lib/file_picker.sh"

# Copy the readme if it exists
if [[ -f "$CURRENT_DIR/readme.md" ]]; then
  cp -f "$CURRENT_DIR/readme.md" "$INSTALL_DIR/README.md"
fi

# Make scripts executable
echo -e "${YELLOW}Making scripts executable...${NC}"
chmod +x "$INSTALL_DIR/git-manager.sh"

# Create symbolic link
if [ -d "/usr/local/bin" ] && [ -w "/usr/local/bin" ]; then
  echo -e "${YELLOW}Creating symbolic link in /usr/local/bin...${NC}"
  ln -sf "$INSTALL_DIR/git-manager.sh" /usr/local/bin/git-manager
  echo -e "${GREEN}Symbolic link created. You can now run 'git-manager' from anywhere.${NC}"
else
  echo -e "${YELLOW}Could not create symbolic link in /usr/local/bin (permission denied).${NC}"
  echo -e "${YELLOW}To use the script, run: ${NC}"
  echo -e "  ${GREEN}bash $INSTALL_DIR/git-manager.sh${NC}"
  echo -e "${YELLOW}Or add an alias to your shell config:${NC}"
  echo -e "  ${GREEN}alias git-manager='bash $INSTALL_DIR/git-manager.sh'${NC}"
fi

echo -e "${BLUE}=================================================${NC}"
echo -e "${GREEN}       Git Repository Manager Setup Complete     ${NC}"
echo -e "${BLUE}=================================================${NC}"
echo -e "${YELLOW}Installation Directory: ${GREEN}$INSTALL_DIR${NC}"
echo -e "${YELLOW}Run the tool with command: ${GREEN}git-manager${NC}"
echo ""
