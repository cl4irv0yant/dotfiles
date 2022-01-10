docker-nuke() {
	docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q)

}


update() {
  base_dir=$HOME/src
  folders=("front-end-mono" "sweetspot-api" "sweetspot-api-platform")

  for folder in "${folders[@]}"; do
      cd "$base_dir/$folder" || continue
      echo "Updating '$folder'"

      current_branch=$(git symbolic-ref --short HEAD)

      saved_branch="$current_branch"

      git checkout master
      git pull --rebase

      git checkout develop
      git pull --rebase

      git checkout "$saved_branch"

      echo "Switched back to branch '$saved_branch' in '$folder'"
  done
}

code-nuke() {
  docker-nuke
  sudo rm -rf docker/mysql/data
  sudo rm -rf var
  sudo rm -rf vendor
  make build
  make uph && make composer && make refresh-db

}

docker-ip() {
    for ID in $(docker ps -q | awk '{print $1}'); do
        IP=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$ID")
        NAME=$(docker ps | grep "$ID" | awk '{print $NF}')
        printf "%s %s\n" "$IP" "$NAME"
    done
}

docker-ip-populate-hosts() {
    for ID in $(docker ps -q); do
        IP=$(docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" "$ID")
        NAME=$(docker ps | grep "$ID" | awk '{print $NF}')
        
        if grep -q "$NAME" /etc/hosts; then
            sudo sed -i "/$NAME/ s/.*/$IP\t$NAME/" /etc/hosts
        else
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
        tmuxp load "$STATE/dotfiles/tmuxp/$ID"
    fi
}

vman() {
  nvim -c "SuperMan $*"

  if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
  fi
}

uuid() {
  uuidgen | xsel -ib
}

g() {
  git commit --amend -am "WIP" && git push -f
}


r() {
  current_branch=$(git symbolic-ref --short HEAD)

  if [[ $current_branch == *"bug/"* ]] || [[ $current_branch == *"feature/"* ]] || [[ $current_branch == *"chore/"* ]]; then
    target_branch="develop"
  elif [[ $current_branch == *"hotfix/"* ]]; then
    target_branch="master"

  else
    echo "Error: Unsupported branch type. Branch name must include 'feature/', 'bug/', 'chore/', or 'hotfix/'"
    exit 1
  fi

  echo "Rebasing $current_branch to $target_branch..."
  git fetch
  git checkout $target_branch
  git pull origin $target_branch --rebase
  git checkout $current_branch
  git rebase $target_branch

  echo "Rebase complete."
}
