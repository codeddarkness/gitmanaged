#!/bin/bash

# Function to manage tags
manage_tags() {
    local stay_in_menu=true
    
    while $stay_in_menu; do
        echo -e "\n${GREEN}Manage Tags:${NC}"
        echo "1. List all tags"
        echo "2. Create a new tag"
        echo "3. Delete a tag"
        echo "4. Push tags to remote"
        echo "5. Return to main menu"
        
        read -r tag_choice
        
        case $tag_choice in
            1)
                echo -e "\n${YELLOW}Current tags:${NC}"
                git tag -n  # Shows tags with annotations
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo -e "\n${YELLOW}Enter tag version (e.g., v1.0.0):${NC}"
                read -r tag_version
                
                echo -e "${YELLOW}Tag a specific commit? (y/n)${NC}"
                read -r specific_commit
                
                if [[ $specific_commit == "y" || $specific_commit == "Y" ]]; then
                    echo -e "${YELLOW}Recent commits:${NC}"
                    git log --oneline -n 10
                    
                    echo -e "\n${YELLOW}Enter commit hash to tag:${NC}"
                    read -r commit_hash
                    
                    echo -e "${YELLOW}Enter tag message (optional):${NC}"
                    read -r tag_message
                    
                    if [[ -z $tag_message ]]; then
                        git tag $tag_version $commit_hash
                    else
                        git tag -a $tag_version -m "$tag_message" $commit_hash
                    fi
                else
                    echo -e "${YELLOW}Enter tag message (optional):${NC}"
                    read -r tag_message
                    
                    if [[ -z $tag_message ]]; then
                        git tag $tag_version
                    else
                        git tag -a $tag_version -m "$tag_message"
                    fi
                fi
                
                echo -e "${GREEN}Tag created: $tag_version${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                echo -e "\n${YELLOW}Current tags:${NC}"
                git tag
                
                echo -e "\n${YELLOW}Enter tag to delete:${NC}"
                read -r del_tag
                
                echo -e "${RED}Are you sure you want to delete tag $del_tag? (y/n)${NC}"
                read -r confirm_delete
                
                if [[ $confirm_delete == "y" || $confirm_delete == "Y" ]]; then
                    git tag -d $del_tag
                    echo -e "${GREEN}Local tag deleted: $del_tag${NC}"
                    
                    echo -e "${YELLOW}Delete this tag from remote as well? (y/n)${NC}"
                    read -r delete_remote
                    
                    if [[ $delete_remote == "y" || $delete_remote == "Y" ]]; then
                        echo -e "${YELLOW}Enter remote name (default: origin):${NC}"
                        read -r remote_name
                        
                        if [[ -z $remote_name ]]; then
                            remote_name="origin"
                        fi
                        
                        git push $remote_name --delete refs/tags/$del_tag
                        echo -e "${GREEN}Remote tag deleted from $remote_name: $del_tag${NC}"
                    fi
                else
                    echo -e "${YELLOW}Tag deletion canceled.${NC}"
                fi
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo -e "\n${YELLOW}Enter remote name (default: origin):${NC}"
                read -r remote_name
                
                if [[ -z $remote_name ]]; then
                    remote_name="origin"
                fi
                
                echo -e "${YELLOW}Push all tags or a specific tag?${NC}"
                echo "1. Push all tags"
                echo "2. Push a specific tag"
                read -r push_choice
                
                if [[ $push_choice == "1" ]]; then
                    git push $remote_name --tags
                    echo -e "${GREEN}All tags pushed to $remote_name.${NC}"
                elif [[ $push_choice == "2" ]]; then
                    echo -e "\n${YELLOW}Current tags:${NC}"
                    git tag
                    
                    echo -e "\n${YELLOW}Enter tag to push:${NC}"
                    read -r push_tag
                    
                    git push $remote_name refs/tags/$push_tag
                    echo -e "${GREEN}Tag $push_tag pushed to $remote_name.${NC}"
                else
                    echo -e "${RED}Invalid option. Push canceled.${NC}"
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
