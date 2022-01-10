#!/bin/bash

# Path to the file containing your desired packages
desired_packages_file="apps.csv"

# Fetch the list of installed packages on your system
installed_packages=$(pacman -Qq)

# Read desired packages into an array
# This assumes that the package names are in the second column of the CSV file
mapfile -t desired_packages < <(awk -F ',' 'NR > 1 {print $2}' "$desired_packages_file")

# Find packages that are installed but not in your list (extra packages)
echo "Extra Packages (Installed but not in the list):"
for pkg in $installed_packages; do
  if ! printf '%s\n' "${desired_packages[@]}" | grep -q -w "$pkg"; then
    echo "  $pkg"
  fi
done

# Find packages that are in your list but not installed (missing packages)
echo "Missing Packages (In the list but not installed):"
for pkg in "${desired_packages[@]}"; do
  if ! echo "$installed_packages" | grep -q -w "$pkg"; then
    echo "  $pkg"
  fi
done

