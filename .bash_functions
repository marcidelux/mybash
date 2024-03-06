_select_docker_container() {
    local containers=$(docker ps --format "{{.Names}}")
    local PS3="Please select a Docker container: " # Prompt for select
    local container_names=($containers)
    local selected_name

    select selected_name in "${container_names[@]}"; do
        if [ -n "$selected_name" ]; then
            echo "You selected: $selected_name"
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done

    # Or, set a global variable to use outside this function
    SELECTED_DOCKER_CONTAINER="$selected_name"
}

_dockerprint_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local containers=$(docker ps --format "{{.Names}}")
  COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
}

complete -F _dockerprint_complete dpcn
complete -F _dockerprint_complete dlog
complete -F _dockerprint_complete dbash
complete -F _dockerprint_complete dsh

# Run /bin/bash command on target docker given by name
dbash() {
    docker exec -it "$1" /bin/bash
}
dbash_s() {
  _select_docker_container
  local container_name="${1:-$SELECTED_DOCKER_CONTAINER}"
  if [ -n "$container_name" ]; then
     docker exec -it "$container_name" /bin/bash
  else
    echo "No container selected or provided."
  fi
}

# Run /bin/sh command on target docker given by name
dsh() {
    docker exec -it "$1" /bin/sh
}
dbsh_s() {
  _select_docker_container
  local container_name="${1:-$SELECTED_DOCKER_CONTAINER}"
  if [ -n "$container_name" ]; then
     docker exec -it "$container_name" /bin/sh
  else
    echo "No container selected or provided."
  fi
}

#Prints out a given container by its name
dpcn() {
  docker ps --filter "name=$1" --format "ID: {{.ID}}\nname: {{.Names}}\nimage: {{.Image}}\ncommand: {{.Command}}\nport: {{.Ports}}\nstatus: {{.Status}}"
}
dpcn_s() {
  _select_docker_container
  local container_name="${1:-$SELECTED_DOCKER_CONTAINER}"
  if [ -n "$container_name" ]; then
     docker ps --filter "name=$container_name" --format "ID: {{.ID}}\nname: {{.Names}}\nimage: {{.Image}}\ncommand: {{.Command}}\nport: {{.Ports}}\nstatus: {{.Status}}"
  else
    echo "No container selected or provided."
  fi
}

# Follow logs on given docker by name.
dlog() {
    docker logs -f "$1"
}

# Follow logs on choosen docker by number
dlog_s() {
  _select_docker_container
  local container_name="${1:-$SELECTED_DOCKER_CONTAINER}"
  if [ -n "$container_name" ]; then
    docker logs -f "$container_name"
  else
    echo "No container selected or provided."
  fi
}