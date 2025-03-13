#!/bin/bash

# Function to handle branch management
branch_management() {
    local stay_in_menu=true
    
    while $stay_in_menu; do
        echo -e "\n${GREEN}Branch Management:${NC}"
        echo "1. List all branches"
        echo "2. Create new branch"
        echo "3. Switch to branch"
        echo "4. Rename branch"
        echo "5. Delete branch"
        echo "6. Return to main menu"
        
        read -r branch_choice
        
        case $branch_choice in
            1)
                echo -e "\n${YELLOW}Local branches:${NC}"
                git branch
                echo -e "\n${YELLOW}Remote branches:${NC}"
                git branch -r
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo -e "\n${YELLOW}Enter new branch name:${NC}"
                read -r new_branch
                git checkout -b $new_branch
                echo -e "${GREEN}Created and switched to new branch: $new_branch${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                echo -e "\n${YELLOW}Available branches:${NC}"
                git branch
                echo -e "\n${YELLOW}Enter branch name to switch to:${NC}"
                read -r switch_branch
                git checkout $switch_branch
                echo -e "${GREEN}Switched to branch: $switch_branch${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo -e "\n${YELLOW}Available branches:${NC}"
                git branch
                echo -e "\n${YELLOW}Enter branch name to rename:${NC}"
                read -r old_branch
                echo -e "${YELLOW}Enter new branch name:${NC}"
                read -r new_branch
                git branch -m $old_branch $new_branch
                echo -e "${GREEN}Renamed branch from $old_branch to $new_branch${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            5)
                echo -e "\n${YELLOW}Available branches:${NC}"
                git branch
                echo -e "\n${YELLOW}Enter branch name to delete:${NC}"
                read -r del_branch
                echo -e "${RED}Are you sure you want to delete branch $del_branch? (y/n)${NC}"
                read -r confirm_delete
                
                if [[ $confirm_delete == "y" || $confirm_delete == "Y" ]]; then
                    git branch -d $del_branch
                    echo -e "${GREEN}Branch deleted: $del_branch${NC}"
                else
                    echo -e "${YELLOW}Branch deletion canceled.${NC}"
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            6)
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

# Function to fix branch rename issues
fix_branch_rename_issues() {
    local stay_in_menu=true
    
    while $stay_in_menu; do
        echo -e "\n${GREEN}Fix Branch Rename Issues:${NC}"
        echo "1. Fix branch rename/push issues"
        echo "2. Return to main menu"
        
        read -r fix_choice
        
        case $fix_choice in
            1)
                echo -e "${YELLOW}This will help fix issues with branch renaming, including 'refusing to delete the current branch' errors.${NC}"
                
                # Get current branch
                current_branch=$(git branch --show-current)
                echo -e "${YELLOW}Current branch: $current_branch${NC}"
                
                # List remotes
                echo -e "\n${YELLOW}Available remotes:${NC}"
                git remote -v | grep "(push)" | awk '{print $1}'
                echo -e "\n${YELLOW}Enter the remote name (default: origin):${NC}"
                read -r remote_name
                
                if [[ -z $remote_name ]]; then
                    remote_name="origin"
                fi
                
                # List branches
                echo -e "\n${YELLOW}Current local branches:${NC}"
                git branch
                echo -e "\n${YELLOW}Current remote branches:${NC}"
                git branch -r
                
                echo -e "\n${YELLOW}Enter the desired branch name for your current branch:${NC}"
                read -r desired_branch
                
                if [[ -z $desired_branch ]]; then
                    echo -e "${RED}Branch name cannot be empty.${NC}"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi
                
                # Fix branch renaming issue
                echo -e "\n${YELLOW}Fixing branch rename issues...${NC}"
                
                # Rename the local branch if needed
                if [[ $current_branch != $desired_branch ]]; then
                    git branch -m $current_branch $desired_branch
                    echo -e "${GREEN}Renamed local branch from $current_branch to $desired_branch${NC}"
                    current_branch=$desired_branch
                fi
                
                # Check if the branch already exists on remote
                if git ls-remote --heads $remote_name $desired_branch | grep -q $desired_branch; then
                    echo -e "${YELLOW}Branch $desired_branch already exists on remote.${NC}"
                    echo -e "${YELLOW}Would you like to:${NC}"
                    echo "1. Delete remote branch and push local branch"
                    echo "2. Force push local branch to remote (overwrite)"
                    echo "3. Cancel operation"
                    
                    read -r remote_choice
                    
                    case $remote_choice in
                        1)
                            echo -e "${RED}Deleting remote branch $desired_branch...${NC}"
                            git push $remote_name --delete $desired_branch
                            echo -e "${GREEN}Pushing local branch to remote...${NC}"
                            git push -u $remote_name $desired_branch
                            ;;
                        2)
                            echo -e "${RED}Force pushing to remote branch $desired_branch...${NC}"
                            git push -f -u $remote_name $desired_branch
                            ;;
                        3)
                            echo -e "${YELLOW}Operation canceled.${NC}"
                            echo ""
                            read -p "Press Enter to continue..."
                            continue
                            ;;
                        *)
                            echo -e "${RED}Invalid option. Operation canceled.${NC}"
                            echo ""
                            read -p "Press Enter to continue..."
                            continue
                            ;;
                    esac
                else
                    # Push the branch to remote
                    git push -u $remote_name $desired_branch
                fi
                
                echo -e "${GREEN}Branch rename issue fixed. Your branch $desired_branch is now correctly set up.${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
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
