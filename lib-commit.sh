#!/bin/bash

# Function to handle commits
commit_changes() {
    echo -e "\n${YELLOW}Files to be committed:${NC}"
    git status --short
    echo ""
    
    echo -e "${GREEN}What would you like to do?${NC}"
    echo "1. Stage all changes"
    echo "2. Stage specific files"
    echo "3. Return to main menu"
    
    read -r commit_choice
    
    case $commit_choice in
        1)
            git add .
            echo -e "${GREEN}All changes staged.${NC}"
            ;;
        2)
            echo -e "${YELLOW}Enter file(s) to stage (space-separated):${NC}"
            read -r files_to_stage
            git add $files_to_stage
            echo -e "${GREEN}Specified files staged.${NC}"
            ;;
        3)
            return
            ;;
        *)
            echo -e "${RED}Invalid option.${NC}"
            read -p "Press Enter to continue..."
            return
            ;;
    esac
    
    echo -e "${YELLOW}Enter commit message:${NC}"
    read -r commit_message
    
    echo -e "${YELLOW}Would you like to create a version tag for this commit? (y/n)${NC}"
    read -r create_tag
    
    if [[ $create_tag == "y" || $create_tag == "Y" ]]; then
        echo -e "${YELLOW}Current tags:${NC}"
        git tag
        
        echo -e "\n${YELLOW}Enter tag version (e.g., v1.0.0):${NC}"
        read -r tag_version
        
        echo -e "${YELLOW}Enter tag message (optional):${NC}"
        read -r tag_message
        
        git commit -m "$commit_message"
        
        if [[ -z $tag_message ]]; then
            git tag $tag_version
        else
            git tag -a $tag_version -m "$tag_message"
        fi
        
        echo -e "${GREEN}Changes committed with tag: $tag_version${NC}"
    else
        git commit -m "$commit_message"
        echo -e "${GREEN}Changes committed.${NC}"
    fi
    
    read -p "Press Enter to continue..."
}
