function up() {
  cd "$(printf "%0.s../" $(seq 1 $1))";
}

function mkcd() {
  mkdir -p "$1" && cd "$1";
}

extract() {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xjf $1     ;;
          *.tar.gz)    tar xzf $1     ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       rar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xf $1      ;;
          *.tbz2)      tar xjf $1     ;;
          *.tgz)       tar xzf $1     ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "'$1' cannot be extracted via extract()" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}


docker-nuke() {
  docker stop $(docker ps -qa)
  docker rm $(docker ps -qa)
  docker rmi -f $(docker images -qa)
  docker volume rm $(docker volume ls -q)
  docker network rm $(docker network ls -q)
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

paste-from-clipboard() {
  LBUFFER+=$(xclip -o -selection clipboard)
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
  git commit --amend -a --no-edit && git push -f
}

r() {
  current_branch=$(git symbolic-ref --short HEAD)

  if [[ $current_branch == *"bug/"* ]] || [[ $current_branch == *"feature/"* ]] || [[ $current_branch == *"chore/"* ]]; then
    target_branch="develop"
  elif [[ $current_branch == *"hotfix/"* ]]; then
    target_branch="master"

  else
    echo "Error: Unsupported branch type. Branch name must include 'feature/', 'bug/', 'chore/', or 'hotfix/'"
  fi

  echo "Rebasing $current_branch to $target_branch..."
  git fetch
  git checkout $target_branch
  git pull origin $target_branch --rebase
  git checkout $current_branch
  git rebase $target_branch
  echo "Rebase complete."
}
