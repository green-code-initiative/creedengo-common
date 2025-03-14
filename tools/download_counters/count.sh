#!/bin/bash

# List of repositories in the format owner/repo
REPOS=(
    "green-code-initiative/ecoCode-android"
    "green-code-initiative/creedengo-csharp-sonarqube"
    "green-code-initiative/creedengo-ios"
    "green-code-initiative/creedengo-java"
    "green-code-initiative/creedengo-javascript"
    "green-code-initiative/creedengo-php"
    "green-code-initiative/creedengo-python"
)

# Check if GitHub token is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <github_token>"
  exit 1
fi

GITHUB_TOKEN=$1

# Function to get download counts for a repository
get_download_counts() {
  local repo=$1
  local api_url="https://api.github.com/repos/$repo/releases"
  
  # Fetch releases data from GitHub API
  response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" $api_url)
  
  # Check if the response contains releases
  if [[ $response == *"\"id\":"* ]]; then
    # Extract download counts from the response
    download_count=$(echo $response | jq '[.[] | .assets[].download_count] | add')
    echo "Repository: $repo, Download Count: $download_count"
  else
    echo "Repository: $repo, No releases found or invalid repository."
  fi
}

# Iterate over the list of repositories and get download counts
for repo in "${REPOS[@]}"; do
  get_download_counts $repo
done
