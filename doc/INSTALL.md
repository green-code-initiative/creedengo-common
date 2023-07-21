# Install notes - EcoCode

- [Global Requirements](#global-requirements)
- [HOWTO build the SonarQube ecoCode plugins](#howto-build-the-sonarqube-ecocode-plugins)
  - [Requirements](#requirements)
  - [Build the code](#build-the-code)
- [HOWTO install SonarQube dev environment](#howto-install-sonarqube-dev-environment)
  - [Requirements](#requirements-1)
  - [Start SonarQube (if first time)](#start-sonarqube-if-first-time)
  - [Configuration SonarQube](#configuration-sonarqube)
    - [Change password](#change-password)
    - [Check plugins installation](#check-plugins-installation)
    - [Generate access token](#generate-access-token)
    - [Initialize default profiles for `ecocode` plugins](#initialize-default-profiles-for-ecocode-plugins)
- [HOWTO reinstall SonarQube (if needed)](#howto-reinstall-sonarqube-if-needed)
- [HOWTO start or stop service (already installed)](#howto-start-or-stop-service-already-installed)
- [HOWTO install new plugin version](#howto-install-new-plugin-version)
- [HOWTO create a release (core-contributor rights needed)](#howto-create-a-release-core-contributor-rights-needed)
- [HOWTO debug a rule (with logs)](#howto-debug-a-rule-with-logs)

## Global Requirements

- Docker
- Docker-compose

## HOWTO build the SonarQube ecoCode plugins

### Requirements

- Java >= 11.0.17
- Mvn 3
- SonarQube 9.4 to 9.9

### Build the code

You can build the project code by running the following command in the root directory.
Maven will download the required dependencies.

```sh
./tool_build.sh
```

Each plugin is generated in its own `<plugin>/target` directory, but they are also copied to the `lib` directory.

## HOWTO install SonarQube dev environment

### Requirements

You must have built the plugins (see the steps above).

### Start SonarQube (if first time)

Run the SonarQube + PostgreSQL stack:

```sh
./tool_docker-init.sh
```

Check if the containers are up:

```sh
docker ps
```

You should see two lines (one for sonarqube and one for postgres).

Result example :
![Result example](resources/docker-ps-result.png)

If there is only postgres, check the logs:

```sh
./tool_docker-logs.sh
```

If you have this error on run:
`web_1 | [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]`
you can allocate more virtual memory:

```sh
sudo sysctl -w vm.max_map_count=262144
```

For Windows:

```sh
wsl -d docker-desktop
sysctl -w vm.max_map_count=262144
```

### Configuration SonarQube

*Purposes* : Configure SonarQube to have all ecocode plugins rules enabled by default.

#### Change password

- go to your SonarQube homepage `http://localhost:9000/`
- use default credentials : `admin`/ `admin`
- the first time after first connexion, you are suggested to change `admin` password

#### Check plugins installation

- go to "Adminitration" tab
- go to "Marketplace" sub-tab
- go bottom, and clic on "Installed" sub-tab
- check here, if you have ecoCode plugins displayed with a SNAPSHOT version

#### Generate access token

When you are connected, generate a new token on `My Account -> Security -> Generate Tokens`

![Administrator menu](resources/adm-menu.png)
![Security tab](resources/security-tab.png)

Instead of login+password authentication, this token can now be used as value for `sonar.login` variable when needed (examples : call sonar scanner to send metrics to SonarQube, on use internal tools, ...)

#### Initialize default profiles for `ecocode` plugins

- use tool `install_profile.sh` in `ecocode-common` repository (inside directory `tools/rules_config`)
  - if you want, you can check default configuration of this tool in `_config.sh` file
- launch followed command : `./install_profile.sh <MY_SONAR_TOKEN>`

After this step, all code source for your language will be analyzed with your new Profile (and its activated plugins rules).

## HOWTO reinstall SonarQube (if needed)

```sh
# first clean all containers and resources used
./tool_docker-clean.sh

# then, build plugins (if not already done)
./tool_build.sh

# then, install from scratch de SonarQube containers and resources
./tool_docker-init.sh
```

## HOWTO start or stop service (already installed)

Once you did the installation a first time (and then you did custom configuration like quality gates, quality
profiles, ...),
if you only want to start (or stop properly) existing services :

```sh

# start WITH previously created token (to do : change the token inside script)
./tool_start_withtoken.sh

# start without previously created token
./tool_start.sh

# stop the service
./tool_stop.sh
```

## HOWTO install new plugin version

1. Install dependencies from the root directory:

```sh
./tool_build.sh
```

Result : JAR files (one per plugin) will be copied in `lib` repository after build.

2. Restart SonarQube

```sh
# stop the service
./tool_stop.sh

# start the service
./tool_start.sh
```

## HOWTO create a release (core-contributor rights needed)

1. *new version process* : IF the new release wanted is a major or minor version (`X` or `Y` in `X.Y.Z`)
   1. THEN modify the old version to the new version in all XML/YML files (with a find/replace)
   2. ELSE the new corrective version (`Z` in `X.Y.Z`) will be automatic
2. `CHANGELOG.md` : add release notes for next release
    1. Replace `Unreleased` title with the new version like `Release X.Y.Z` and the date
        1. ... where `X.Y.Z` is the new release
        2. ... follow others examples
        3. ... clean content of current release changelog (delete empty sub-sections)
        4. respect [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
    2. add above an empty `Unreleased` section with sub-sections (`Added`, `Changed` and `Deleted`)
    3. add a new section in the list at the bottom of file with new version
    4. update `docker-compose.yml` with next SNAPSHOT corrective version
    5. commit these modifications
3. `tool_release_1_prepare.sh` : *IF ALL IS OK*, execute this script to prepare locally the next release and next SNAPSHOT (creation of 2 new commits and a tag) and check these commits and tag
4. `tool_release_2_branch.sh` : *IF ALL IS OK*, execute this script to create and push a new branch with that release and SNAPSHOT
5. *PR* : *IF ALL IS OK*, on github, create a PR based on this new branch to `main` branch
6. *check Github Action + merge PR* : wait that automatic check (Github `Actions` tab) on the new branch are OK, then check modifications and finally merge it with `Create a merge commit` option
7. *IF ALL IS OK* and if PR merge is OK, then delete the branch as mentionned when PR merged
8. *check Github Action + update local* : wait that automatic check on the `main` branch are OK, and then *IF ALL IS OK*, upgrade your local source code from remote, and go to `main` branch
9. *push tag* : push new tag with `git push --tags`
10. *check release* : an automatic workflow started on github and create the new release of plugin
11. `docker-compose.yml` : check and modify (if needed) the version in this file to the new SNAPSHOT version

## HOWTO debug a rule (with logs)

1. Add logs like in [OptimizeReadFileExceptions](https://github.com/green-code-initiative/ecoCode/blob/main/java-plugin/src/main/java/fr/greencodeinitiative/java/checks/OptimizeReadFileExceptions.java) class file
2. Build plugin JARs with `tool_build.sh`
3. Launch local Sonar with `tool_docker_init.sh`
4. Launch a sonar scanner on an exemple project with `mvn verify` command (only the first time), followed
   by :
   - if token created : `mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.1.2184:sonar -Dsonar.login=MY_TOKEN -X`
   - if login and password : `mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.1.2184:sonar -Dsonar.login=MY_LOGIN -Dsonar.password=MY_PASSWORD -X`
5. logs will appear in console (debug logs will appear if `-X` option is given like above)
