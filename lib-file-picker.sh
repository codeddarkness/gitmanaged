#!/bin/bash

# Function to pick files from branches
pick_files_from_branch() {
    local stay_in_menu=true
    
    while $stay_in_menu; do
        echo -e "\n${GREEN}Pick Files From Branch:${NC}"
        echo "1. List available branches"
        echo "2. Select branch and browse files"
        echo "3. Cherry-pick file from another branch"
        echo "4. Compare file across branches"
        echo "5. Return to main menu"
        
        read -r file_pick_choice
        
        case $file_pick_choice in
            1)
                echo -e "\n${YELLOW}Available branches:${NC}"
                git branch
                echo -e "\n${YELLOW}Remote branches:${NC}"
                git branch -r
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo -e "\n${YELLOW}Available branches:${NC}"
                git branch
                
                echo -e "\n${YELLOW}Enter branch name to browse:${NC}"
                read -r browse_branch
                
                # Verify branch exists
                if ! git show-ref --verify --quiet refs/heads/$browse_branch; then
                    echo -e "${RED}Error: Branch '$browse_branch' does not exist.${NC}"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi
                
                echo -e "\n${YELLOW}Files in $browse_branch:${NC}"
                git ls-tree -r --name-only $browse_branch
                
                echo -e "\n${YELLOW}Would you like to view a specific file? (y/n)${NC}"
                read -r view_file
                
                if [[ $view_file == "y" || $view_file == "Y" ]]; then
                    echo -e "\n${YELLOW}Enter file path:${NC}"
                    read -r file_path
                    
                    if git cat-file -e $browse_branch:$file_path 2>/dev/null; then
                        echo -e "\n${YELLOW}File content:${NC}"
                        git show $browse_branch:$file_path
                    else
                        echo -e "${RED}Error: File does not exist in branch $browse_branch.${NC}"
                    fi
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                echo -e "\n${YELLOW}Available branches:${NC}"
                git branch
                
                echo -e "\n${YELLOW}Enter source branch (to copy from):${NC}"
                read -r source_branch
                
                # Verify source branch exists
                if ! git show-ref --verify --quiet refs/heads/$source_branch; then
                    echo -e "${RED}Error: Branch '$source_branch' does not exist.${NC}"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi
                
                echo -e "\n${YELLOW}Files in $source_branch:${NC}"
                git ls-tree -r --name-only $source_branch
                
                echo -e "\n${YELLOW}Enter file path to cherry-pick:${NC}"
                read -r file_path
                
                if git cat-file -e $source_branch:$file_path 2>/dev/null; then
                    # Create directory if it doesn't exist
                    directory=$(dirname "$file_path")
                    if [ "$directory" != "." ] && [ ! -d "$directory" ]; then
                        mkdir -p "$directory"
                    fi
                    
                    git show $source_branch:$file_path > "$file_path"
                    echo -e "${GREEN}File copied from $source_branch to current working directory.${NC}"
                    
                    echo -e "\n${YELLOW}Would you like to stage this file for commit? (y/n)${NC}"
                    read -r stage_file
                    
                    if [[ $stage_file == "y" || $stage_file == "Y" ]]; then
                        git add "$file_path"
                        echo -e "${GREEN}File staged for commit.${NC}"
                    fi
                else
                    echo -e "${RED}Error: File does not exist in branch $source_branch.${NC}"
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo -e "\n${YELLOW}Available branches:${NC}"
                git branch
                
                echo -e "\n${YELLOW}Enter first branch for comparison:${NC}"
                read -r branch1
                
                echo -e "\n${YELLOW}Enter second branch for comparison:${NC}"
                read -r branch2
                
                # Verify branches exist
                if ! git show-ref --verify --quiet refs/heads/$branch1; then
                    echo -e "${RED}Error: Branch '$branch1' does not exist.${NC}"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi
                
                if ! git show-ref --verify --quiet refs/heads/$branch2; then
                    echo -e "${RED}Error: Branch '$branch2' does not exist.${NC}"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi
                
                echo -e "\n${YELLOW}Enter file path to compare:${NC}"
                read -r file_path
                
                if git cat-file -e $branch1:$file_path 2>/dev/null && git cat-file -e $branch2:$file_path 2>/dev/null; then
                    echo -e "\n${YELLOW}Differences in $file_path between $branch1 and $branch2:${NC}"
                    git diff $branch1:$file_path $branch2:$file_path
                else
                    echo -e "${RED}Error: File does not exist in one or both branches.${NC}"
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
