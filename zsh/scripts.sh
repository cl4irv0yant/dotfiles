#!/bin/zsh

docker-nuke() {
	docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q)

}

code-nuke() {
  sudo -rm -rf docker/mysql/data
  rm -rf var
  rm -rf vendor
  docker-nuke
  make build
  make up
  make composer
  make refresh-db
  docker-ip-2
}


docker-populate-hosts() {
    docker-ip | sudo tee -a /etc/hosts
}


docker-ip() {
    for ID in $(docker ps -q | awk '{print $1}'); do
        IP=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$ID")
        NAME=$(docker ps | grep "$ID" | awk '{print $NF}')
        printf "%s %s\n" "$IP" "$NAME"
    done
}

docker-ip-2() {
    # Loop through all running containers
    for ID in $(docker ps -q); do
        IP=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$ID")
        NAME=$(docker ps --format "{{.Names}}" | grep "$ID" | awk '{print $NF}')
        
        # Check if the hostname already exists in /etc/hosts
        if grep -q "$NAME" /etc/hosts; then
            # Replace the existing IP address with the new one
            sudo sed -i "s/^[[:space:]]*$IP[[:space:]]*$NAME$/\t$IP\t$NAME/" /etc/hosts
        else
            # Append the new IP address and hostname to /etc/hosts
            echo -e "\t$IP\t$NAME" | sudo tee -a /etc/hosts > /dev/null
        fi
    done
}

compress() {
    tar cvzf $1.tar.gz $1
}

ftmuxp() {
    if [[ -n $TMUX ]]; then
        return
    fi
    
    # get the IDs
    ID="$(ls $XDG_CONFIG_HOME/tmuxp | sed -e 's/\.yml$//')"
    if [[ -z "$ID" ]]; then
        tmux new-session
    fi

    create_new_session="Create New Session"

    ID="${create_new_session}\n$ID"
    ID="$(echo $ID | fzf | cut -d: -f1)"

    if [[ "$ID" = "${create_new_session}" ]]; then
        tmux new-session
    elif [[ -n "$ID" ]]; then
        # Rename the current urxvt tab to session name
        printf '\033]777;tabbedx;set_tab_name;%s\007' "$ID"
        tmuxp load "$XDG_CONFIG_HOME/tmuxp/$ID"
    fi
}

vman() {
  nvim -c "SuperMan $*"

  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
}
