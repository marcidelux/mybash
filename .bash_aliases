alias c='clear'
alias sb='source ~/.bashrc'
alias la='ls -a'
alias pbcopy="xclip -sel clip"

# Docker aliases
alias d="docker"                                    # Docker
alias dc="docker-compose"                           # Docker compose
alias dpc="docker ps -a"                            # Print out containers
alias dppc="docker ps --format 'table ID:\t{{.ID}}\nName:\t{{.Names}}\nCommand:\t{{.Command}}\nPorts:\t{{.Ports}}\nCreatedAt:\t{{.CreatedAt}}\nStatus:\t{{.Status}}\nSize:\t{{.Size}}\nImage:\t{{.Image}}\n'" #prety print containers
alias drc="docker rm -vf"                           # Remove container
alias dpi="docker images -a"                        # Print out images
alias dri="docker rmi -f"                           # Remove image
alias drai='docker rmi -f $(docker images -a -q)'   # Remoe all images
alias drac='docker rm -vf $(docker ps -aq)'         # Remove all containers
alias dpv="docker volume ls"                        # Print out volumes
alias drv="docker volume rm"                        # Remove volume
alias drav="docker volume prune -f"                  # Remove all volumes
alias dpn="docker network ls"                       # Print out Network
alias drn="docker network rm"                       # Remove network
alias dran="docker network prune -f"                # Remove all networks
alias dp="dpc; echo; dpi; echo;  dpv; echo; dpn"    # Print out all information
alias dra="drai; drac; drav; dran"                  # Remove everything