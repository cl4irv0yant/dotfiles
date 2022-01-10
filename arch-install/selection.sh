declare -A unique_categories
declare -a apps
declare -a dialog_options

while IFS=, read -r category app description; do
  apps+=("$category-$app" "$description" "on")
  unique_categories["$category"]=1
done < apps.csv

APP_CHOICES=$(echo "${!unique_categories[@]}" | tr ' ' ' ')

echo $APP_CHOICES
