#!/bin/bash

# Function to manage remotes
manage_remotes() {
    local stay_in_menu=true
    
    while $stay_in_menu; do
        echo -e "\n${GREEN}Remote Management:${NC}"
        echo "1. List remotes"
        echo "2. Add remote"
        echo "3. Remove remote"
        echo "4. Change remote URL"
        echo "5. Return to main menu"
        
        read -r remote_choice
        
        case $remote_choice in
            1)
                echo -e "\n${YELLOW}Current remotes:${NC}"
                git remote -v
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo -e "\n${YELLOW}Enter remote name:${NC}"
                read -r remote_name
                echo -e "${YELLOW}Enter remote URL:${NC}"
                read -r remote_url
                git remote add $remote_name $remote_url
                echo -e "${GREEN}Remote added: $remote_name -> $remote_url${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                echo -e "\n${YELLOW}Current remotes:${NC}"
                git remote -v
                echo -e "\n${YELLOW}Enter remote name to remove:${NC}"
                read -r remote_remove
                git remote remove $remote_remove
                echo -e "${GREEN}Remote removed: $remote_remove${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo -e "\n${YELLOW}Current remotes:${NC}"
                git remote -v
                echo -e "\n${YELLOW}Enter remote name to change:${NC}"
                read -r remote_change
                echo -e "${YELLOW}Enter new URL:${NC}"
                read -r new_url
                git remote set-url $remote_change $new_url
                echo -e "${GREEN}Remote URL changed for $remote_change -> $new_url${NC}"
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
