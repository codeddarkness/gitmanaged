#!/bin/bash

# Function to manage untracked files
manage_untracked() {
    local stay_in_menu=true
    
    while $stay_in_menu; do
        echo -e "\n${GREEN}Manage Untracked Files:${NC}"
        echo "1. List untracked files"
        echo "2. Add all untracked files"
        echo "3. Create/edit .gitignore"
        echo "4. Clean untracked files (BE CAREFUL)"
        echo "5. Return to main menu"
        
        read -r untracked_choice
        
        case $untracked_choice in
            1)
                echo -e "\n${YELLOW}Untracked files:${NC}"
                git ls-files --others --exclude-standard
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                git add $(git ls-files --others --exclude-standard)
                echo -e "${GREEN}All untracked files added.${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                if [[ -f .gitignore ]]; then
                    echo -e "${YELLOW}Editing existing .gitignore file${NC}"
                else
                    echo -e "${YELLOW}Creating new .gitignore file${NC}"
                    # Add some common patterns
                    echo "# Automatically generated .gitignore file" > .gitignore
                    echo "**/node_modules/" >> .gitignore
                    echo "**/__pycache__/" >> .gitignore
                    echo "*.log" >> .gitignore
                    echo ".DS_Store" >> .gitignore
                    echo ".env" >> .gitignore
                    echo "*.pyc" >> .gitignore
                fi
                
                echo -e "${YELLOW}Enter your preferred editor (default: nano):${NC}"
                read -r editor
                
                if [[ -z $editor ]]; then
                    editor="nano"
                fi
                
                $editor .gitignore
                echo -e "${GREEN}.gitignore file updated.${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo -e "${RED}WARNING: This will delete all untracked files. This action cannot be undone.${NC}"
                echo -e "${RED}Are you absolutely sure? (type 'YES' to confirm)${NC}"
                read -r confirm_clean
                
                if [[ $confirm_clean == "YES" ]]; then
                    git clean -fd
                    echo -e "${GREEN}Untracked files cleaned.${NC}"
                else
                    echo -e "${YELLOW}Clean operation canceled.${NC}"
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            5)
                stay_in_menu=false
                ;;
            *)
                echo -e "${RED}Invalid option.${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}
