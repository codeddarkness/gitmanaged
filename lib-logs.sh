#!/bin/bash

# Function to view logs
view_logs() {
    local stay_in_menu=true
    
    while $stay_in_menu; do
        echo -e "\n${GREEN}Log Options:${NC}"
        echo "1. Show basic log"
        echo "2. Show detailed log"
        echo "3. Show graph log"
        echo "4. Show log for specific branch"
        echo "5. Return to main menu"
        
        read -r log_choice
        
        case $log_choice in
            1)
                git log --oneline -n 10
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                git log -n 10
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                git log --graph --oneline --all -n 20
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo -e "\n${YELLOW}Enter branch name:${NC}"
                read -r log_branch
                git log --oneline $log_branch -n 10
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
