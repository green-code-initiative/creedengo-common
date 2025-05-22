- [Global Requirements](#global-requirements)
- [DEVELOPMENT](#development)
  - [Installing Local environment (local SonarQube)](#installing-local-environment-local-sonarqube)
    - [HOWTO build the SonarQube creedengo plugins](#howto-build-the-sonarqube-creedengo-plugins)
      - [Requirements](#requirements)
      - [Build the code](#build-the-code)
    - [HOWTO install SonarQube dev environment](#howto-install-sonarqube-dev-environment)
      - [Requirements](#requirements-1)
      - [Start SonarQube (if first time)](#start-sonarqube-if-first-time)
      - [Configuration SonarQube](#configuration-sonarqube)
        - [Change password](#change-password)
        - [Check plugins installation](#check-plugins-installation)
        - [Generate access token](#generate-access-token)
        - [Initialize default profiles for `creedengo` plugins](#initialize-default-profiles-for-creedengo-plugins)
    - [HOWTO reinstall SonarQube (if needed)](#howto-reinstall-sonarqube-if-needed)
    - [HOWTO start or stop service (already installed)](#howto-start-or-stop-service-already-installed)
    - [HOWTO install new plugin version](#howto-install-new-plugin-version)
  - [Contribution / concrete development](#contribution--concrete-development)
    - [HOWTO develop in open-source mode](#howto-develop-in-open-source-mode)
      - [Maintainer, write permission](#maintainer-write-permission)
      - [Contributor, NO write permissions](#contributor-no-write-permissions)
    - [HOWTO create and implement a new rule](#howto-create-and-implement-a-new-rule)
    - [HOWTO debug a rule (with logs)](#howto-debug-a-rule-with-logs)
    - [HOWTO Deprecate an existing rule](#howto-deprecate-an-existing-rule)
      - [STEP 1 : deprecate rule](#step-1--deprecate-rule)
      - [STEP 2 : remove rule](#step-2--remove-rule)
    - [HOWTO manage license inside code](#howto-manage-license-inside-code)
- [RELEASING](#releasing)
  - [HOWTO create a release (core-contributor rights needed)](#howto-create-a-release-core-contributor-rights-needed)
    - [Create a release on DYNAMIC versionning system module](#create-a-release-on-dynamic-versionning-system-module)
    - [Create a release on STATIC versionning system module](#create-a-release-on-static-versionning-system-module)
    - [New release from scratch](#new-release-from-scratch)
    - [New release of existing plugin](#new-release-of-existing-plugin)
  - [HOWTO publish a new version of creedengo-rules-specifications on Maven Central](#howto-publish-a-new-version-of-creedengo-rules-specifications-on-maven-central)
    - [Requirements](#requirements-2)
    - [Maven Central publish process](#maven-central-publish-process)
- [CONFIGURATION](#configuration)
  - [HOWTO configure publish system on Maven Central](#howto-configure-publish-system-on-maven-central)
    - [Update GPG Maven Central keys](#update-gpg-maven-central-keys)
      - [What is GPG Maven Central keys ?](#what-is-gpg-maven-central-keys-)
      - [How to install and use GPG ? METHOD 1 : with "GPG KeyChain" software (MAC OS)](#how-to-install-and-use-gpg--method-1--with-gpg-keychain-software-mac-os)
      - [How to install and use GPG ? METHOD 2 : command line tool](#how-to-install-and-use-gpg--method-2--command-line-tool)
        - [Why change these variables ?](#why-change-these-variables-)
        - [How to generate new values](#how-to-generate-new-values)
      - [Update Github Secrets](#update-github-secrets)
    - [Update OSSRH token](#update-ossrh-token)
      - [What is OSSRH token ?](#what-is-ossrh-token-)
      - [Why change these variables ?](#why-change-these-variables--1)
      - [How to generate new values and update Github Secrets ?](#how-to-generate-new-values-and-update-github-secrets-)
- [CONTACT](#contact)
  - [HOWTO contact the team](#howto-contact-the-team)
  - [Feedbacks](#feedbacks)
    - [User Group](#user-group)
    - [Contributor Group](#contributor-group)

# Global Requirements

- Docker
- Docker-compose

# DEVELOPMENT 

## Installing Local environment (local SonarQube)

### HOWTO build the SonarQube creedengo plugins

#### Requirements

check requirements : https://github.com/green-code-initiative/creedengo-common/blob/main/doc/starter-pack.md#requirements

#### Build the code

You can build the project code by running the following command in the root directory.
Maven will download the required dependencies.

```sh
./tool_build.sh
```

Each plugin is generated in its own `<plugin>/target` directory, but they are also copied to the `lib` directory.

Next, check the tests (unit tests and integration tests) are ok :
```sh
mvn verify
```

### HOWTO install SonarQube dev environment

#### Requirements

You must have built the plugins (see the steps above).

#### Start SonarQube (if first time)

Run the SonarQube + PostgreSQL stack:

```sh
./tool_docker-init.sh
```

Check if the containers are up:

```sh
docker ps
```

You should see two lines (one for sonarqube and one for postgres).
Please note the assigned port to your local SonarQube (9000 port used for SonarQube server inside Docker container / the other port is the one you can use to access from your web browser)

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

#### Configuration SonarQube

*Purposes* : Configure SonarQube to have all creedengo plugins rules enabled by default.

##### Change password

- go to your SonarQube homepage `http://localhost:XXXXX/` (`XXXX` : external docker port used. You can get it when you list available Docker containers)
- use default credentials : `admin`/ `admin`
- the first time after first connection, you are suggested to change `admin` password

##### Check plugins installation

- go to "Adminitration" tab
- go to "Marketplace" sub-tab
- go bottom, and click on "Installed" sub-tab
- check here, if you have creedengo plugins displayed with a SNAPSHOT version

##### Generate access token

When you are connected,
- generate a new token on `My Account -> Security -> Generate Tokens` with "User token" type
- copy it for following steps

![Administrator menu](resources/adm-menu.png)
![Security tab](resources/security-tab.png)

Instead of login+password authentication, this token can now be used as value for `sonar.login` variable when needed (examples : call sonar scanner to send metrics to SonarQube, on use internal tools, ...)

##### Initialize default profiles for `creedengo` plugins

- use tool `install_profile.sh` in `creedengo-common` repository (inside directory `tools/rules_config`)
  - if you want, you can check default configuration of this tool in `_config.sh` file
- launch followed command : `./install_profile.sh <MY_SONAR_PORT> <MY_SONAR_TOKEN>`

After this step, all code source for your language will be analyzed with your new Profile (and its activated plugins rules).

### HOWTO reinstall SonarQube (if needed)

```sh
# first clean all containers and resources used
./tool_docker-clean.sh

# then, build plugins (if not already done)
./tool_build.sh

# then, install from scratch de SonarQube containers and resources
./tool_docker-init.sh
```

### HOWTO start or stop service (already installed)

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

### HOWTO install new plugin version

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

## Contribution / concrete development

### HOWTO develop in open-source mode

There are two ways to develop in an open-source project :
- you are an official `maintainer`
- you are a `contributor`

#### Maintainer, write permission

If you are an official `maintainer` identified in the project, you are in a special team with write permissions.
Thus you can :
- create branches and commit directly inside
- push code directly on project (by the PR way)
- review and accept Pull Requests

#### Contributor, NO write permissions

If you are a new (or regular) contributor, and you don't have specific write permissions but only read permissions.
If you want to contribute to the project, you must use the FORK / Pull Request (PR) system.
But don't worry, if you are a regular contributor, project core-team members evaluates, on a regular basis, some contributors to be maintainers !!!

To contribute with FORK / PR system, you have to :
- create a fork of the original project (by clicking on `Create a new fork` button, inside top-right `fork` menu)
  - check that the new project fork is really present in your personal github projects
- clone your personal forked project
  - you can see on github, you have
    - two new buttons to interact with original project : "Contribute" and "Sync fork"
    - a status information about synchronization between your forked project and original project (on the left of previous new buttons)
  - if your fork is recently created, you can see in the status information that your forked project is synchronized
  - if not "synchronized", you can click on "Sync fork" to update your forked project from the original project
- create a new local branch to begin development
- once development done, you can commit and push your work to your github forked project
- once all is ok, you can create a new Pull Request to original Project by clicking on the new appeared message with "Compare & pull request" button
  - a new PR form is displayed and you can fill it
- *TIPS* : when you have already created the PR to the original project, and you improve the branch of your forked project (with new commits), the PR in original project is automatically updated. Please mark this PR as "Draft", meaning you are still working on it (top-right link "convert to draft" in PR inside original project)

### HOWTO create and implement a new rule

You will need to clone 3 repos :

* [creedengo-rules-specifications](https://github.com/green-code-initiative/creedengo-rules-specifications.git)
  * For a rule that already exists (existing ID) but is not described for the target language:
    * create a subfolder with the language name inside the rule folder 
    * create an ASCIIDOC file in it with the rule description for the chosen language, along with an example of KO code and an example of OK code.
    * For an example, you can refer to the rule EC31 for java: : green-code-initiative/creedengo-rules-specifications/src/main/rules/GCI31/java/GCI31.asciidoc
  * For a rule that doesn't exist yet, determine an ID (random number between 1000 and 1500) that doesn't yet exist
    * add a JSON metadata file to describe the rule, its remediation cost, its tags, etc. (follow the example of other rules)
    * add the sub-tree structure as described for an already existing rule.
  * run 'mvn install' on this project to have the dependency in your local maven cache. This command will also generate the html file that's required when your build your sonar plugin.
* creedengo-{lang} : to implement the rule for a target language
  * change the version number in pom.xml of your sonar project : exemple for creedengo-java/pom.xml : <creedengo-rules-specifications.version>main-SNAPSHOT</creedengo-rules-specifications.version> to target your local build
  * in the implementation, don't forget to add the @rule(key = “GCIxx”) annotation for Java, PHP, Python
  * use the command "mvn package" to produce the version of the plugin embedding the implementation and specifications of the rule concerned
    * It's ready to be tested in your local instance of SonarQube !
* creedengo-{lang}-test-project : to add a real-life example of an outcome that a sonar analysis should detect. (For Java ,Javascript and Python the test project is included in the subfolder of the lang git project). 

### HOWTO debug a rule (with logs)

1. Add logs like in [OptimizeReadFileExceptions](https://github.com/green-code-initiative/creedengo-java/blob/main/src/main/java/fr/greencodeinitiative/java/checks/OptimizeReadFileExceptions.java) class file
2. Build plugin JARs with `tool_build.sh`
3. Launch local Sonar with `tool_docker_init.sh`
4. Launch a sonar scanner on an exemple project with `mvn verify` command (only the first time), followed
   by :
   - if token created : `mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.1.2184:sonar -Dsonar.login=MY_TOKEN -X`
   - if login and password : `mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.1.2184:sonar -Dsonar.login=MY_LOGIN -Dsonar.password=MY_PASSWORD -X`
5. logs will appear in console (debug logs will appear if `-X` option is given like above)

### HOWTO Deprecate an existing rule

If you want to deprecate an existing rule, you have to follow 2 steps as described below.

#### STEP 1 : deprecate rule

This step is done on next release of plugin (example : version N).

1. Upgrade the rule implementation to add deprecation information : in plugin repository containing the rule implementation, add a new `@DeprecatedRule` annotation on the rule class
2. Upgrade rules documentation
   1. in plugin repository containing the rule implementation, in `RULES.md` file, move rule line from standard rules array to deprecated rules array
   2. in `creedengo-rules-specification` repository, add deprecation to current rule

Thus in next release of plugin, the rule will be still present but displayed as deprecated in SonarQube UI.

#### STEP 2 : remove rule

This step is done on release N+2.

1. Clean implementation code of the rule :
   1. in plugin repository containing the rule implementation
      1. delete rule class, clean all references to the rule
      2. delete unit test classes
   2. in plugin real test project repository, clean rule test classes
2. Upgrade rules documentation : in plugin repository containing the rule implementation, in `RULES.md` file, mark the rule as deleted

### HOWTO manage license inside code

documentation of maven plugin "license" : https://oss.carbou.me/license-maven-plugin/#goals

1. check license in code
```
mvn license:check
```

2. update license in code where license isn't exist
```
mvn license:format
```

# RELEASING

## HOWTO create a release (core-contributor rights needed)

### Create a release on DYNAMIC versionning system module

For now, this is ONLY the use case for `creedengo-rules-specifications` repository.
Why dynamic ? because the versionning is dynamic in this repository.
No need to execute the 2 shell scripts (and commits / pushes) in "static" way to manage the versionning.

1. **upgrade `CHANGELOG.md`** : add release notes for next release
    1. **Replace `Unreleased` title** with the new version like `Release X.Y.Z` and the date
        1. ... where `X.Y.Z` is the new release
        2. ... follow others examples
        3. ... clean content of current release changelog (delete empty sub-sections)
        4. respect [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
    2. **add above an empty `Unreleased`** section with sub-sections (`Added`, `Changed` and `Deleted`)
    3. **add a new section in the list at the bottom** of file with new version
    4. **commit** these modifications
2. **upgrade `README.md`** : upgrade if needed and if version compatibility matrix is described
3. create locally a tag with the previous used version
   1. execute `git tag <X.Y.Z>`
4. push new tag created previously :
   1. locally, **go to and update `main`** branch
   2. **execute `git push --tags`** to push new previously created tag

### Create a release on STATIC versionning system module

This is the use case for all plugin repositories except `creedengo-rules-specifications` repository.

1. IF **new release wanted** is a **major** or **minor** version (`X` or `Y` in `X.Y.Z`)
   1. **THEN** **modify the old version** to the new version in **all XML/YML files**
   2. **ELSE** **no modification** needed : the new corrective version (`Z` in `X.Y.Z`) will be automatic
2. **upgrade `CHANGELOG.md`** : add release notes for next release
    1. **Replace `Unreleased` title** with the new version like `Release X.Y.Z` and the date
        1. ... where `X.Y.Z` is the new release
        2. ... follow others examples
        3. ... clean content of current release changelog (delete empty sub-sections)
        4. respect [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
    2. **add above an empty `Unreleased`** section with sub-sections (`Added`, `Changed` and `Deleted`)
    3. **add a new section in the list at the bottom** of file with new version
    4. **commit** these modifications
3. **upgrade `README.md`** : upgrade if needed and if version compatibility matrix is described
4. prepare locally next release and next snapshot :
   1. **execute `tool_release_1_prepare.sh`** script to prepare locally the next release and next SNAPSHOT (creation of 2 new commits and a tag)
   2. DON'T PUSH, just **check locally** these 2 commits and tag
5. create and push new local branch :
   1. **execute `tool_release_2_branch.sh`** to create and push a new branch with that release and SNAPSHOT
   2. **check on github** that this new branch is created and pushed
6. create new github PR :
   1. on github, **create a new PR** based on this new branch to `main` branch
   2. **check Action** launch and result for this new PR
7. merge PR
   1. **merge PR** on `main` branch with `Create a merge commit` option
   2. **check Action** launch and result on `main` branch
8. push new tag created previously :
   1. locally, **go to and update `main`** branch
   2. **execute `git push --tags`** to push new previously created tag
   3. **check Action** launch and result on new tag

`## HOWTO publish new release on SonarQube Marketplace

### New release from scratch

1. Create a fork of [SonarSource/sonar-update-center-properties](https://github.com/SonarSource/sonar-update-center-properties.git) and clone it locally
2. Create a new branch
3. Change corresponding plugin metadata file (for `creedengo-java`: [creedengojava.properties](https://github.com/SonarSource/sonar-update-center-properties/blob/master/creedengojava.properties), for `creedengo-php`: [creedengophp.properties](https://github.com/SonarSource/sonar-update-center-properties/blob/master/creedengophp.properties), for `creedengo-python`: [creedengopython.properties](https://github.com/SonarSource/sonar-update-center-properties/blob/master/creedengopython.properties)): 
   - Append new version to `publicVersions` value (comma separated value)
   - Add following properties (where `X.X.X` is new release to publish):
     - `X.X.X.description`: a summary of main changes for user for this version
     - `X.X.X.sqVersions`: supported range version of SonarQube
     - `X.X.X.date`: Release date of plugin (on GitHub Release page)
     - `X.X.X.downloadUrl`: link to doanwload this specific release
     - `X.X.X.changelogUrl`: link to detailed change log of this release
4. Commit and push modifications on your fork
5. Create a Pull-Request for those modifications on [SonarSource/sonar-update-center-properties](https://github.com/SonarSource/sonar-update-center-properties/pulls) to annonce new release of the corresponding plugin, with:
   - a summary of main changes for user
   - the download link
   - the link to detailed release note
   - the link to SonarCloud corresponding project

Additional information:

- [check description of previous merged Pull-Requests](https://github.com/SonarSource/sonar-update-center-properties/pulls?q=is%3Apr+is%3Amerged)
- [github.com - SonarSource/sonar-update-center-properties](https://github.com/SonarSource/sonar-update-center-properties)
- [sonar community - Deploying to the Marketplace](https://community.sonarsource.com/t/deploying-to-the-marketplace/35236)
- documentation : [README.md](https://github.com/SonarSource/sonar-update-center-properties/blob/master/README.md)

Examples :

- [PR example 1](https://github.com/SonarSource/sonar-update-center-properties/pull/389)
- [PR example 2](https://github.com/SonarSource/sonar-update-center-properties/pull/409)

### New release of existing plugin

... quite like "New release from scratch" section above but ...

- process : [SonarSource documentation - new release](https://community.sonarsource.com/t/deploying-to-the-marketplace/35236#announcing-new-releases-2)
- documentation : [README.md](https://github.com/SonarSource/sonar-update-center-properties/blob/master/README.md)
- example : [PR example](https://github.com/SonarSource/sonar-update-center-properties/pull/468)

## HOWTO publish a new version of creedengo-rules-specifications on Maven Central

### Requirements

You need write rights to use Maven Central publish process (mainteners or core-team members).

**Create a new release of `creedengo-rules-specifications` repository** : please see above [HOWTO create a release](#howto-create-a-release-core-contributor-rights-needed).

Why create a new release before ?
Because publish process of `creedengo-rules-specifications` on Maven Central needs a tag on `creedengo-rules-specifications` repository.

### Maven Central publish process

- go to "Action" tab of `creedengo` reposiroty
- click on "Publish to Maven Central" workflow
- click on "Run workflow" list button
- choose a tag version (and not a branch because SNAPSHOT version won't be published on Maven Central)
- click on "Run workflow" button
- check launched workflow on Actions tab
- 20 minutes later (because of Maven central internal process), check on maven central if new version is published
  - check here : https://central.sonatype.com/artifact/org.green-code-initiative/creedengo-rules-specifications/versions

# CONFIGURATION

## HOWTO configure publish system on Maven Central

requirements : core-contributor rights needed
exaplanation : 

### Update GPG Maven Central keys

#### What is GPG Maven Central keys ?

GPG system is used to sign JAR files before publishing them to Maven Central.
We have to generate public and private keys, and store them in Github Secrets with `MAVEN_GPG_PRIVATE_KEY` and `MAVEN_GPG_PASSPHRASE` variables.

These GPG keys are stored in Github Secrets available `Settings` tab of the repository, in `Secrets and variables` sub-tab, in `Actions` sub-section.

#### How to install and use GPG ? METHOD 1 : with "GPG KeyChain" software (MAC OS)

Download and install GPG KeyChain software from [GPG Suite](https://gpgtools.org/)
Launch GPG KeyChain software and follow these steps :
- create a new key pair by clicking on `New` button and feed the form
  - `Name` : your name
  - `Email` : your email
  - `Passphrase` / `password` : a passphrase to protect your private key
  - `expiration date` : never
  - other options : default values
- get public key (and private key if needed), by clicking on `Export` button
  - you can export public key to a local file (with `.asc` extension)
  - you can also export private key if option checked in export form
- publish your public key to a key server by clicking on `Send` button
  - (if you open settings option menu, you can see that key server is `hkps://keys.openpgp.org`)
  - if error when publishing, try another server :
    - https://keyserver.ubuntu.com/
    - insert manually the public key
    - then check the key existence with defined email

#### How to install and use GPG ? METHOD 2 : command line tool

Values are generated on local machine with "gpg" command line tool.

on MAC OS (for the moment) :

- `brew install gpg` to install tool
- `gpg --version` to check version of GPG tool
- `gpg --gen-key` to generate private and public keys : WARNING, you need to remember passphrase used to generate keys
- `gpg --list-keys` to list keys (and display expiration date)
- `gpg --keyserver keyserver.ubuntu.com --send-keys <MY_PUBLIC_KEY>` to send public key to one fo web key servers : MANDATORY to publish on Maven Central
- `gpg --keyserver keyserver.ubuntu.com --recv-keys <MY_PUBLIC_KEY>` to get public key from keyserver : TO check if our public key is ok and known by keyserver
- `gpg --output private.pgp --armor --export-secret-key "<MY_PUBLIC_KEY>"` to export private key to a local file

For information, version of GPG command line tool :
```sh
$$ gpg --version

gpg (GnuPG) 2.4.3
libgcrypt 1.10.2
Copyright (C) 2023 g10 Code GmbH
License GNU GPL-3.0-or-later <https://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Home: <MY_HOME>/.gnupg
Algorithmes pris en charge :
Clef publique : RSA, ELG, DSA, ECDH, ECDSA, EDDSA
Chiffrement : IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256,
              TWOFISH, CAMELLIA128, CAMELLIA192, CAMELLIA256
Hachage : SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
Compression : Non compressé, ZIP, ZLIB, BZIP2
```

##### Why change these variables ?

We can check expiration date with `gpg --list-keys` command.
Current keys are valid until **2026-08-07**.
If we want to upgrade these keys, we need to generate new ones and reconfigure Github Secrets.

##### How to generate new values

1. Generate new keys with `gpg --gen-key` command : we need to give a passphrase (you can give old one)
2. Send public key to keyserver with `gpg --keyserver keyserver.ubuntu.com --send-keys <MY_PUBLIC_KEY>` command
3. Check and get public key from keyserver with `gpg --keyserver keyserver.ubuntu.com --recv-keys <MY_PUBLIC_KEY>` command
4. Export private key to a local `private.pgp` file with `gpg --output private.pgp --armor --export-secret-key "<MY_PUBLIC_KEY>"`

#### Update Github Secrets

1. Open exported local file and copy content (only content between `-----BEGIN PGP PRIVATE KEY BLOCK-----` and `-----END PGP PRIVATE KEY BLOCK-----` included)
2. Paste this content in `MAVEN_GPG_PRIVATE_KEY` variable in Github Secrets on the current repository (Secrets and variables / Actions / Repository secrets)
3. Paste the passphrase used in previous step, in `MAVEN_GPG_PASSPHRASE` variable in Github Secrets on the current repository (Secrets and variables / Actions / Repository secrets)
4. Check below OSSHR token process and then Check publish process with a new release version (see above [HOWTO configure publish process on Maven Central](#howto-publish-a-new-version-of-creedengo-rules-specifications-on-maven-central))

### Update OSSRH token

#### What is OSSRH token ?

`OSSRH_TOKEN` and `OSSRH_USERNAME` are used for communication between Github and Sonatype Nexus system for publish process to Maven Central.
Nexus URL : https://s01.oss.sonatype.org/

These variables are stored in Github Secrets available `Settings` tab of `creedengo-rules-specifications` repository (Secrets and variables / Actions / Repository secrets)

#### Why change these variables ?

Values are get from a specific Sonatype Nexus account.

Actually, `creedengo-rules-specifications` Sonatype Nexus account was used to generate values corresponding to `OSSRH_TOKEN` and `OSSRH_USERNAME` variables.

If we want use another account, we need to change these values by generating new ones on this new account.

#### How to generate new values and update Github Secrets ?

1. Go to [Sonatype Nexus](https://s01.oss.sonatype.org/)
2. Login with account (ex : `gci`)
3. Go to `Profile` tab
4. Go to `User Token` sub-tab present in top list (`Summary` value is selected by default)
5. Click on `Access User Token` button
6. New values will be generated and displayed
7. Copy these values and paste them in Github Secrets in `creedengo-rules-specifications` repository, respectively in `OSSRH_TOKEN` variable (the password) and `OSSRH_USERNAME` variable (the username)
8. Check publish process with a new release version (see above [HOWTO configure publish process on Maven Central](#howto-publish-a-new-version-of-creedengo-rules-specifications-on-maven-central))

# CONTACT

## HOWTO contact the team

Several ways existing :
- go to our website https://green-code-initiative.org/ and choose one of different ways :
  - on of our 3 social media (top-right menu)
  - go to "entreprise" page and you can fill a contact form : https://green-code-initiative.org/#/entreprise
- technically : got to our github and create an issue or a discussion
  - https://github.com/green-code-initiative

## Feedbacks

### User Group

A user group has been created to exchange around our plugins.
There is a slack channel `#club-utilisateur` on our Slack
Here are some feedbacks :
- https://lite.framacalc.org/zxw48y210s-a6z2
- [2024-10-10 user group feedback](https://github.com/green-code-initiative/creedengo-common/blob/main/doc/resources/Club%20utilisateurs%20ecoCode%20-%20Membres%20(version%20Rencontre%205).xlsx)

### Contributor Group
A contributor group has been created to exchange technically around our plugins.
You can participate to the monthly meeting going to "friday-meet" channel on slack
