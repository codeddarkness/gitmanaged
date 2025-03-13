#!/bin/bash

# Function to merge branches
merge_branches() {
    local stay_in_menu=true
    
    while $stay_in_menu; do
        echo -e "\n${GREEN}Merge Branches:${NC}"
        echo "1. Merge a branch into current branch"
        echo "2. View available branches"
        echo "3. Return to main menu"
        
        read -r merge_menu_choice
        
        case $merge_menu_choice in
            1)
                # Show available branches
                echo -e "\n${YELLOW}Available branches:${NC}"
                git branch
                
                # Get current branch
                current_branch=$(git branch --show-current)
                echo -e "\n${YELLOW}Current branch: $current_branch${NC}"
                
                # Get source branch
                echo -e "\n${YELLOW}Enter the branch you want to merge FROM:${NC}"
                read -r source_branch
                
                # Verify source branch exists
                if ! git show-ref --verify --quiet refs/heads/$source_branch; then
                    echo -e "${RED}Error: Branch '$source_branch' does not exist.${NC}"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi
                
                # Confirm merge
                echo -e "${YELLOW}You are about to merge $source_branch INTO $current_branch.${NC}"
                echo -e "${YELLOW}Continue with merge? (y/n)${NC}"
                read -r confirm_merge
                
                if [[ $confirm_merge != "y" && $confirm_merge != "Y" ]]; then
                    echo -e "${YELLOW}Merge canceled.${NC}"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi
                
                # Ask for merge strategy
                echo -e "\n${YELLOW}Select merge strategy:${NC}"
                echo "1. Regular merge (creates merge commit)"
                echo "2. Fast-forward merge (if possible)"
                echo "3. Squash merge (combines all commits into one)"
                echo "4. Rebase (replays commits on top of target branch)"
                read -r merge_strategy
                
                # Perform merge based on selected strategy
                case $merge_strategy in
                    1)
                        echo -e "${YELLOW}Performing regular merge...${NC}"
                        git merge $source_branch
                        ;;
                    2)
                        echo -e "${YELLOW}Attempting fast-forward merge...${NC}"
                        git merge --ff-only $source_branch
                        if [ $? -ne 0 ]; then
                            echo -e "${RED}Fast-forward merge not possible.${NC}"
                            echo -e "${YELLOW}Would you like to do a regular merge instead? (y/n)${NC}"
                            read -r do_regular
                            if [[ $do_regular == "y" || $do_regular == "Y" ]]; then
                                git merge $source_branch
                            else
                                echo -e "${YELLOW}Merge canceled.${NC}"
                            fi
                        fi
                        ;;
                    3)
                        echo -e "${YELLOW}Performing squash merge...${NC}"
                        git merge --squash $source_branch
                        echo -e "${YELLOW}Changes have been staged. You need to commit them.${NC}"
                        echo -e "${YELLOW}Do you want to commit now? (y/n)${NC}"
                        read -r commit_now
                        if [[ $commit_now == "y" || $commit_now == "Y" ]]; then
                            echo -e "${YELLOW}Enter commit message for the squash merge:${NC}"
                            read -r squash_message
                            git commit -m "$squash_message"
                            echo -e "${GREEN}Squash merge completed and committed.${NC}"
                        else
                            echo -e "${YELLOW}Squash merge changes staged but not committed.${NC}"
                        fi
                        ;;
                    4)
                        echo -e "${YELLOW}Performing rebase...${NC}"
                        git rebase $source_branch
                        ;;
                    *)
                        echo -e "${RED}Invalid option. Merge canceled.${NC}"
                        ;;
                esac
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo -e "\n${YELLOW}Local branches:${NC}"
                git branch
                echo -e "\n${YELLOW}Remote branches:${NC}"
                git branch -r
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
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
