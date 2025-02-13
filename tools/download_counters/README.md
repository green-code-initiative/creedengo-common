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

2. Obtain a GitHub personal access token. You can create one [here](https://github.com/settings/tokens).

## Usage

1. Clone the repository or download the script.

2. Open a terminal and navigate to the directory containing the script.

3. Set the `GITHUB_TOKEN` environment variable with your GitHub personal access token:

   ```bash
   export GITHUB_TOKEN=your_github_token
   ```

4. Run the script:

   ```bash
   bash count.sh
   ```

## Example

```bash
export GITHUB_TOKEN=ghp_yourGitHubTokenHere
bash count.sh
```
