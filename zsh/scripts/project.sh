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
