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

# Temporary file to store results
TEMP_FILE=$(mktemp)

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
    if [ "$download_count" = "null" ] || [ -z "$download_count" ]; then
      download_count=0
    fi
    # Store in format: count|repo_name
    echo "$download_count|$repo" >> "$TEMP_FILE"
  else
    echo "0|$repo" >> "$TEMP_FILE"
  fi
}

# Iterate over the list of repositories and get download counts
for repo in "${REPOS[@]}"; do
  get_download_counts $repo
done

# Display results with emojis and formatting
echo ""
echo "📊 Download Statistics Summary"
echo "=============================="
echo ""

# Calculate total downloads first
total_downloads=0
while IFS='|' read -r count repo; do
  total_downloads=$((total_downloads + count))
done < "$TEMP_FILE"

# Sort by download count (descending)
sort -t'|' -k1 -rn "$TEMP_FILE" | while IFS='|' read -r count repo; do
  # Extract just the repo name (after the /)
  repo_name=$(echo "$repo" | cut -d'/' -f2)
  
  # Format count with thousands separator
  formatted_count=$(printf "%'d" "$count" 2>/dev/null || echo "$count")

  # Display the result
  echo "📦 $repo_name: $formatted_count downloads"
done

# Display total
formatted_total=$(printf "%'d" "$total_downloads" 2>/dev/null || echo "$total_downloads")
echo ""
echo "=============================="
echo "🎯 Total Downloads: $formatted_total"
echo ""

# Clean up temp file
rm -f "$TEMP_FILE"
