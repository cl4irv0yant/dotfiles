#!/bin/zsh


fetch_fixtures() {
  cp -r $HOME/src/fixtures .
}


docker-nuke() {
	docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q)

}

rebase() {
    #!/bin/bash

  # Get the current branch name
  current_branch=$(git symbolic-ref --short HEAD)

  # Check if the current branch name contains "feature/"
  if [[ $current_branch == *"feature/"* ]]; then
    target_branch="develop"
  # Check if the current branch name contains "bug/" or "hotfix/"
  elif [[ $current_branch == *"bug/"* ]] || [[ $current_branch == *"hotfix/"* ]]; then
    target_branch="master"
  # If the current branch name doesn't match any of the above conditions, display an error message and exit
  else
    echo "Error: Unsupported branch type. Branch name must include 'feature/', 'bug/', or 'hotfix/'"
    exit 1
  fi

  # Perform the rebase
  echo "Rebasing $current_branch to $target_branch..."
  git fetch
  git checkout $target_branch
  git pull origin $target_branch --rebase
  git checkout $current_branch
  git rebase $target_branch

  echo "Rebase complete."

}

code-nuke() {
  sudo -rm -rf docker/mysql/data
  rm -rf var
  rm -rf vendor
  docker-nuke
  make build
  make up
  docker-ip-populate-hosts
  fetch_fixtures
  make composer
  make refresh-db

}


docker-ip() {
    for ID in $(docker ps -q | awk '{print $1}'); do
        IP=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$ID")
        NAME=$(docker ps | grep "$ID" | awk '{print $NF}')
        printf "%s %s\n" "$IP" "$NAME"
    done
}

docker-ip-populate-hosts() {
    # Loop through all running containers
    for ID in $(docker ps -q); do
        IP=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$ID")
        NAME=$(docker ps | grep "$ID" | awk '{print $NF}')
        
        # Check if the hostname already exists in /etc/hosts
        if grep -q "$NAME" /etc/hosts; then
            # Replace the existing IP address with the new one
            sudo sed -i "/$NAME/ s/.*/$IP\t$NAME/" /etc/hosts
        else
            # Append the new IP address and hostname to /etc/hosts
            echo -e "$IP\t$NAME" | sudo tee -a /etc/hosts > /dev/null
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
