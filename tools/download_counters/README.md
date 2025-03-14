# Download Counters Script

This script retrieves the download counts of a list of repositories from the GitHub API.

## Prerequisites

- Bash
- `curl`
- `jq` (for parsing JSON responses)

## Setup

1. Install `jq` if you don't have it already:

   ```bash
   sudo apt-get install jq
   ```

2. Obtain a GitHub personal access token with the `repo` or `public_repo` permission:

   1. Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens).
   2. Click on **Generate new token**.
   3. Give your token a descriptive name.
   4. Select the `repo / public_repo` scope to grant the necessary permissions.
   5. Click **Generate token**.
   6. Copy the generated token and save it securely.

## Usage

1. Clone the repository or download the script.

2. Open a terminal and navigate to the directory containing the script.

3. Run the script:

   ```bash
   bash count.sh <github_token>
   ```

## Example

```bash
bash count.sh ghp_yourGitHubTokenHere
```
