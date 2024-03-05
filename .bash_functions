dbash() {
    docker exec -it "$1" /bin/bash
}

dsh() {
    docker exec -it "$1" /bin/sh
}

_dockerprint_complete() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local containers=$(docker ps --format "{{.Names}}")
  COMPREPLY=($(compgen -W "${containers}" -- ${cur}))
}

complete -F _dockerprint_complete dpcn
complete -F _dockerprint_complete dlog

#Prints out a given container by its name
dpcn() {
  docker ps --filter "name=$1" --format "ID: {{.ID}}\nname: {{.Names}}\nimage: {{.Image}}\ncommand: {{.Command}}\nport: {{.Ports}}\nstatus: {{.Status}}"
}

# Follow logs on given docker by name.
dlog() {
    docker logs -f "$1"
}