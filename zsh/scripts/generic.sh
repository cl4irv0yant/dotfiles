docker-nuke() {
  docker stop $(docker ps -qa)
  docker rm $(docker ps -qa)
  docker rmi -f $(docker images -qa)
  docker volume rm $(docker volume ls -q)
  docker network rm $(docker network ls -q)
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
