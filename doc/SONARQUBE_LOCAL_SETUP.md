# Local SonarQube Setup Guide

_Run SonarQube + PostgreSQL locally and scan a Java project_

This guide walks you through setting up a fully local SonarQube instance and using it to analyze your Java project for sustainability issues using the [Creedengo](https://github.com/green-code-initiative/creedengo-java) plugin. No cloud account or SonarCloud subscription is needed — everything runs on your machine via containers. By the end, you will have SonarQube running at `http://localhost:9000`, a custom quality profile loaded with Creedengo rules, and your Java project scanned and reporting issues in the dashboard.

> **Platform note:** Commands are provided for both macOS (Terminal) and Windows (PowerShell). Sections that are identical on both platforms show a single code block.

---

## Prerequisites

- [Podman](https://podman.io/) or [Docker](https://www.docker.com/products/docker-desktop/) — this guide uses Podman. If you use Docker, swap `podman` for `docker` and `podman-compose` for `docker compose` in all commands.
- [podman-compose](https://github.com/containers/podman-compose) (or Docker Compose if using Docker)
- Java project with source code to scan
- JDK installed (`java -version` and `mvn -version` / `gradle -version` should work)

---

## Step 1 — Create the SonarQube stack

**macOS:**

```sh
mkdir ~/sonarqube && cd ~/sonarqube
```

**Windows (PowerShell):**

```powershell
mkdir "$env:USERPROFILE\sonarqube"; cd "$env:USERPROFILE\sonarqube"
```

Create `docker-compose.yml` inside that folder:

```yaml
version: "3"

services:
  postgres:
    image: postgres:15
    container_name: sonarqube-postgres
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
      POSTGRES_DB: sonarqube
    volumes:
      - sonarqube_db:/var/lib/postgresql/data
    networks:
      - sonarnet
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U sonar -d sonarqube"]
      interval: 10s
      timeout: 5s
      retries: 5

  sonarqube:
    image: sonarqube:community
    container_name: sonarqube
    depends_on:
      postgres:
        condition: service_healthy
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgres:5432/sonarqube
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
    ports:
      - "9000:9000"
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions
    networks:
      - sonarnet

volumes:
  sonarqube_db:
  sonarqube_data:
  sonarqube_logs:
  sonarqube_extensions:

networks:
  sonarnet:
```

---

## Step 2 — Start SonarQube

**macOS:**

```sh
cd ~/sonarqube
podman-compose up -d
```

**Windows (PowerShell):**

```powershell
cd "$env:USERPROFILE\sonarqube"
podman-compose up -d
```

Wait for it to be ready (~1-2 min):

```sh
podman logs -f sonarqube
# Wait until you see: "SonarQube is operational"
# Then Ctrl+C
```

Open `http://localhost:9000`

- Login: `admin` / `admin`
- It will prompt you to change your password — do that

---

## Step 3 — Install the Creedengo Java plugin

Download the latest `.jar` from:
**https://github.com/green-code-initiative/creedengo-java/releases**

Copy it into the running container:

**macOS:**

```sh
podman cp ~/Downloads/creedengo-java-X.X.X.jar sonarqube:/opt/sonarqube/extensions/plugins/
```

**Windows (PowerShell):**

```powershell
podman cp "$env:USERPROFILE\Downloads\creedengo-java-X.X.X.jar" sonarqube:/opt/sonarqube/extensions/plugins/
```

Restart SonarQube to load the plugin:

```sh
podman-compose restart sonarqube
podman logs -f sonarqube
# Wait for "SonarQube is operational" again
```

Verify: **Administration → Marketplace → Installed** — Creedengo should appear.

---

## Step 4 — Create a Quality Profile with Creedengo rules

SonarQube's built-in profiles are locked, so you need to create a custom one:

1. Go to **Quality Profiles** → **Create**
2. Set:
   - **Name:** `Creedengo Java`
   - **Language:** Java
   - **Parent:** `Sonar Way`
3. Click **Create**
4. On your new profile → **Activate More**
5. Filter by **Tag → `creedengo`** on the left
6. Select all rules → **Bulk Activate**

---

## Step 5 — Create a project in SonarQube

1. **Create Project → Local project**
2. Set a **Project Key** (e.g. `my-java-app`) — remember this
3. Complete setup

Generate an auth token:

- **My Account → Security → Generate Token**
- Copy the token — you won't see it again

---

## Step 6 — Assign your Quality Profile to the project

1. Go to your project in SonarQube
2. **Project Settings → Quality Profiles**
3. Change Java profile from "Sonar Way" to "Creedengo Java"

---

## Step 7 — Add `sonar-project.properties` to your Java project

In your Java project root, create:

```properties
sonar.projectKey=my-java-app
sonar.projectName=My Java App
sonar.sources=src/main/java
sonar.java.binaries=target/classes
sonar.exclusions=**/test/**
```

---

## Step 8 — Compile your project

The scanner needs compiled classes for Java:

**macOS:**

```sh
cd /path/to/your-java-project
mvn compile        # if using Maven
# or
gradle classes     # if using Gradle
```

**Windows (PowerShell):**

```powershell
cd C:\path\to\your-java-project
mvn compile        # if using Maven
# or
gradle classes     # if using Gradle
```

---

## Step 9 — Run the scanner

Set your token as an environment variable (avoids it appearing in shell history):

**macOS:**

```sh
export SONAR_TOKEN="your-token-here"
```

**Windows (PowerShell):**

```powershell
$env:SONAR_TOKEN = "your-token-here"
```

Run the scanner from your Java project root:

**macOS:**

```sh
cd /path/to/your-java-project

podman run --rm \
  -e SONAR_HOST_URL="http://host.containers.internal:9000" \
  -e SONAR_TOKEN \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli
```

**Windows (PowerShell):**

```powershell
cd C:\path\to\your-java-project

podman run --rm `
  -e SONAR_HOST_URL="http://host.containers.internal:9000" `
  -e SONAR_TOKEN="$env:SONAR_TOKEN" `
  -v "${PWD}:/usr/src" `
  sonarsource/sonar-scanner-cli
```

> **Docker Desktop users:** replace `host.containers.internal` with `host.docker.internal` on both platforms.
>
> **If the host URL doesn't resolve:** find your machine's local IP (`ipconfig getifaddr en0` on macOS, `ipconfig` on Windows) and use that IP address instead.

Wait for:

```
INFO: ANALYSIS SUCCESSFUL
```

---

## Step 10 — View results

Open `http://localhost:9000` → your project → **Issues** → filter by tag `creedengo`

You should now see sustainability issues flagged in your Java code.

---

## Useful commands

```sh
# Stop SonarQube (keeps all data)
podman-compose down

# Start it again
podman-compose up -d

# Full reset (deletes all data)
podman-compose down -v
```
