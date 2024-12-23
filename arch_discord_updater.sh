#!/bin/bash


# I have no idea if this works for other distros but it does for me (arch)

PURPLE='\033[0;35m'
NC='\033[0m' # reset

# check deps
check_jq_installed() {
  if ! command -v jq &>/dev/null; then
    echo -e "${PURPLE}Error missing 'jq' please install it!${NC}"
    exit 1
  fi
}


if [ "$(id -u)" -ne 0 ]; then
  echo -e "${PURPLE}This script needs to be run as root!${NC}"
  exit 1
fi

# Check if jq is installed
check_jq_installed

read -p "What version is Discord asking for?: " version

# store path for build_info.json so that we can update the version in the file
file="/opt/discord/resources/build_info.json"

# Check if the file exists
if [ ! -f "$file" ]; then
  echo -e "${PURPLE}File not found: $file${NC}"
  exit 1
fi

# Use jq to modify the version in the JSON file
jq --arg new_version "$version" '.version = $new_version' "$file" > tmp.$$.json && mv tmp.$$.json "$file"

# Inform the user of the update
echo -e "${PURPLE}Version has been updated to $version in $file."
echo ""
echo ""
echo ""
echo -e "${PURPLE} attempting to kill Discord..."
pkill discord
echo -e "DONE! you may now relaunch discord and it should attempt to update!"
echo -e "Made by crossjbly [https://crossjbly.pages.dev/]${NC}"
