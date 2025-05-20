
- [Basic Explanations](#basic-explanations)
  - [Sonarqube Plugin](#sonarqube-plugin)
    - [How a SonarQube plugin works](#how-a-sonarqube-plugin-works)
  - [Gitflow](#gitflow)
  - [How to develop in open-source mode](#how-to-develop-in-open-source-mode)
  - [Github Green-Code-Initiative](#github-green-code-initiative)
  - [Some rules references](#some-rules-references)
    - [115 web rules details](#115-web-rules-details)
    - [40+ android/iOS rules details](#40-androidios-rules-details)
- [Initialize local development](#initialize-local-development)
  - [Requirements](#requirements)
    - [Method 1 - Automatic check (default method)](#method-1---automatic-check-default-method)
    - [Method 2 - Manual check (if above "method 1" doesn't work)](#method-2---manual-check-if-above-method-1-doesnt-work)
  - [Get source code](#get-source-code)
  - [Start local environment](#start-local-environment)
- [Implement a new rule](#implement-a-new-rule)
  - [Requirements](#requirements-1)
  - [Choose the rule you want to implement](#choose-the-rule-you-want-to-implement)
  - [Check `Definition Of Done` for new rule implementation](#check-definition-of-done-for-new-rule-implementation)
  - [Test your rule implementation](#test-your-rule-implementation)
  - [Specific real test project for Python and Java plugin](#specific-real-test-project-for-python-and-java-plugin)
- [Publish your work](#publish-your-work)
  - [Commit your code](#commit-your-code)
  - [Open pull request](#open-pull-request)
  - [Review others development](#review-others-development)
  - [Validation of a PR](#validation-of-a-pr)
  - [Close your rule](#close-your-rule)

# Basic Explanations

In order to develop a Sonarqube Plugin in Open source for creedengo, the following basics should have been understood:

- How to develop a Sonarqube plugin
- Understand and work with the Gitflow
- How to develop in open-source mode

## Sonarqube Plugin

Here is the official documentation to understand how to develop a sonar plugin: <https://docs.sonarqube.org/latest/extend/developing-plugin/>
But ... we are going to help you more specifically for `creedengo` project in the following sections.

### How a SonarQube plugin works

Code is parsed to be transformed as an [AST (Abstract Syntax Tree)](https://en.wikipedia.org/wiki/Abstract_syntax_tree). This AST will allow you to access one or more nodes of your code.
For example, you’ll be able to access all of the `for` loops, to explore content etc.

To better understand AST structure, you can use the [AST Explorer](https://astexplorer.net/) and select the language of the code you want to explore.

The JavaScript Sonar plugin works differently because it doesn't parse the code to transform it into an AST itself, it uses the ESLint engine which does the parsing by itself ([More information here](https://github.com/green-code-initiative/creedengo-javascript/blob/main/CONTRIBUTING.md)). The good part is that it means that all creedengo JavaScript rules are made available both to Sonar and to [ESLint](https://eslint.org/) through an [creedengo ESLint plugin](https://www.npmjs.com/package/@creedengo/eslint-plugin).

## Gitflow

What is GitFlow and how it works: <https://medium.com/android-news/gitflow-with-github-c675aa4f606a>

## How to develop in open-source mode
Please check following section

## Github Green-Code-Initiative

- common part (doc / tools): <https://github.com/green-code-initiative/creedengo-common>
- rules specification: <https://github.com/green-code-initiative/creedengo-rules-specifications>
- several mobile repositories
- several standard repositories
- several test project repositories

## Some rules references

### 115 web rules details

<https://github.com/cnumr/best-practices>

### 40+ android/iOS rules details

<https://github.com/cnumr/best-practices-mobile>

# Initialize local development

This section is to help you to install and configure your first environment to develop with us !!!

We advise you to use [Sdkman.io](https://sdkman.io/) to manage tools versions of your tools, locally. This tool will install different versions as you want.

## Requirements

- `Docker`: <https://docs.docker.com/get-docker/>
- `Docker-compose`: <https://docs.docker.com/compose/install/>
- `Java` JDK 17 (free subscription is required for download): <https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html>
- `Maven` for Sonarqube plugin Development: <https://maven.apache.org/download.cgi>
- `Git`: <https://git-scm.com/book/en/v2/Getting-Started-Installing-Git>
- `JQ`: <https://jqlang.github.io/jq/>

### Method 1 - Automatic check (default method)

In the current repository, go to `tools/check_requirements` directory.
Next, execute script verification:

- for Mac or Unix OS: `./check_requirements.sh`

- for Windows OS:
  - execute script: `check_requirements.bat`
  - then check versions displayed

PS: if you have some problems with this script, please feel free to create a new issue here <https://github.com/green-code-initiative/creedengo-common/issues>

### Method 2 - Manual check (if above "method 1" doesn't work)

If you want, you can check following file to know what are min and max versions for each tool: <https://github.com/green-code-initiative/creedengo-common/blob/main/tools/check_requirements/config.txt>

Then launch check commands as follows (and check versions displayed):

```sh
docker --version
docker-compose --version
javap -version
mvn --version
git --version
jq --version
```

## Get source code

Clone the project with (standard, mobile or/and common): please see all availables repositories here <https://github.com/orgs/green-code-initiative/repositories?type=all>

Example for Java plugin (with SSH):
```sh
git clone git@github.com:green-code-initiative/creedengo-java.git
```

*WARNING*: if you are a new contributor (and not identified project `maintainer`), you have to use FORK / Pull Request System like explained here <https://github.com/green-code-initiative/creedengo-common/blob/main/doc/HOWTO.md#howto-develop-in-open-source-mode>

## Start local environment

You will find all steps to start and configure your local Sonarqube dev Environment here:

- 1st step - build your local plugin: <https://github.com/green-code-initiative/creedengo-common/blob/main/doc/HOWTO.md#howto-build-the-sonarqube-creedengo-plugins>
- 2nd step - launch local Sonarqube (with installation of previous local plugin built): <https://github.com/green-code-initiative/creedengo-common/blob/main/doc/HOWTO.md#howto-install-sonarqube-dev-environment>
- 3rd step - check that local environment is running perfectly:
  - choose one of repositories with suffix "test-project" (ex: <https://github.com/green-code-initiative/creedengo-php-test-project/tree/main>) for other languages than Java and Python
    - next, launch script tool_send_to_sonar.sh <MY_SONAR_PORT> <MY_SONAR_TOKEN> (using previous security token created on the second step) 
    - finally, open local SonarQube GUI (<http://localhost:9000>) to verify if the project alone raises creedengo errors
  - for Python and Java plugins, please check bottom ("Specific real test project for Python and Java plugins" part ), there is no test project anymore. It is inside the plugin under `src/it/test-projects` directory

# Implement a new rule

## Requirements

Please see section above `Initialize local development`

## Choose the rule you want to implement

Once your local environment is running, you can pick a rule waiting to be implemented.

Many ways to do this: 

- first way: choose a rule in following tables that is ready to implement (🚀) or has to be analyzed (❓)
   - [Web rules](https://github.com/green-code-initiative/creedengo-rules-specifications/blob/main/RULES.md)
   - [Android (Java) rules](https://github.com/green-code-initiative/ecocode-android/blob/main/android-plugin/RULES.md)
   - [iOS (Swift) rules](https://github.com/green-code-initiative/creedengo-ios/blob/main/RULES.md)
- second way: pick a plugin in the table bottom and check if a rule is waiting to be implemented.

| Plugin Language | Plugin Rules Ideas                                                                                                                                                                                                                                |
|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Java            | [💡 rule-idea](https://github.com/green-code-initiative/creedengo-java/issues?q=is%3Aissue+is%3Aopen+label%3A%F0%9F%92%A1rule-idea)                                                                                                               |
| JavaScript      | [🗃️ rule or 💡 rule-idea](https://github.com/green-code-initiative/creedengo-javascript/issues?q=is%3Aopen+is%3Aissue+label%3A%22%F0%9F%92%A1+rule-idea%22%2C%22%F0%9F%97%83%EF%B8%8F+rule%22+label%3A%22%F0%9F%8F%86+challenge+%F0%9F%8F%86%22) |
| HTML            | [🗃️ rule or 💡 rule-idea](https://github.com/green-code-initiative/creedengo-html/issues?q=is%3Aopen+is%3Aissue+label%3A%22%F0%9F%92%A1+rule-idea%22%2C%22%F0%9F%97%83%EF%B8%8F+rule%22+label%3A%22%F0%9F%8F%86+challenge+%F0%9F%8F%86%22)       |
|                 |                                                                                                                                                                                                                                                   |

- third way: pick a idea rule (not yet analyzed) and check if a rule is waiting to be implemented.

| Repository          | Plugin Rules Ideas                                                                                                                       |
|---------------------|------------------------------------------------------------------------------------------------------------------------------------------|
| creedengo-common    | [💡 rule-idea](https://github.com/green-code-initiative/creedengo-common/issues?q=is%3Aissue+is%3Aopen+label%3A%F0%9F%92%A1rule-idea)    |
| creedengo-challenge | [💡 rule-idea](https://github.com/green-code-initiative/creedengo-challenge/issues?q=is%3Aissue+is%3Aopen+label%3A%F0%9F%92%A1rule-idea) |
|                     |                                                                                                                                          |

- fourth way: check rule ideas in Kanban project board [here](https://github.com/orgs/green-code-initiative/projects/1) and select implementable (or hardly implementable) ticket, and create an issue in the right language repository
- fifth way: Go and give a hand to the [spotters team](https://github.com/green-code-initiative/creedengo-challenge/blob/main/spotters.md) who will give you some rules to implement

**IMPORTANT**: before implementing a rule, please check if the rule is not already implemented in another language and the id already exists in `RULES.md` file or in `creedengo-rules-specifications` repository. If the rule is already implemented, please use the same id.

## Check `Definition Of Done` for new rule implementation

For a new rule implementation, we strongly recommend you to follow this check-list:

- [ ] Check if rule doesn't exist in our referential rules list yet (`RULES.md` file of `creedengo-rules-specifications` repository)
- [ ] Create PR on the `creedengo-rules-specifications` repository to add the new rule definition
  - [ ] To choose the new rule id:
    - [ ] if rule is already existing in `RULES.md` file or in `creedengo-rules-specifications` repository, please use the given rule id
    - [ ] if rule doesn't already exist in `RULES.md` file or in `creedengo-rules-specifications` repository, please use a random number between 1000 and 1500 (ex: "EC1289") and use it (later, you will be asked to change it)
  - [ ] You should use SNAPSHOT version of `creedengo-rules-specifications` during your local rule implementation to go forward
- [ ] Implement rule in your local specific language repository with a reference to local SNAPSHOT of `creedengo-rules-specifications` (previously, install it locally with maven command)
  - [ ] Write Unit tests (and maximize code coverage)
  - [ ] Update `CHANGELOG.md` file (inside `Unreleased` section)
- [ ] Create PR on the real test project to add a triggering case (check [local procedure](https://github.com/green-code-initiative/creedengo-common/blob/main/doc/starter-pack.md#start-local-environment))
  - [ ] WARNING Java an Python plugin: check above (`Specific real test project for Python and Java plugin`)
- [ ] Fix potential SonarCloud issues / out-of-date warnings (report is sent after creating PR)
- [ ] In next review step, reviewer will ask you to use a specific id rule if you have chosen a random one

## Test your rule implementation

- First kind of test: Unit tests (please check `Definition of Done` above)
- Second kind of test: End-to-End tests in a real local environment (please check `Definition of Done` above and [local procedure](https://github.com/green-code-initiative/creedengo-common/blob/main/doc/starter-pack.md#start-local-environment) )

> Each rule needs to have scripts in a specific language (i.e. Python, Rust, JS, PHP and JAVA) in order to test directly inside Sonarqube that the rule has been implemented.
> To validate that the rule has been implemented, you need to execute a scan on those scripts. You will need sonar scanner: <https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/>

## Specific real test project for Python and Java plugins

These two plugins doesn't have a specific test project yet in a separated repository.
We are deploying in all plugins, a new system to make real tests based on integration tests inside each plugin.
The purpose of this system is to be independent of Docker to launch integration tests.
Now, we do not need Docker to launch integration tests.
We can use a simple maven command to launch a Sonarqube instance and play the integration tests:
```sh
mvn clean verify
```
If you want to keep your local Sonarqube instance, you can use this maven command (using a maven profile):
```sh
mvn clean verify -Pkeep-running
```

You can find this new real tests system inside `src/it` directory:
- sub-directory `java` contains:
  - system source-code
  - the only one integration test that will be used to launch the integration tests: `GCIRulesIT.java`
- sub-directory `test-projects` contains the real test projects (the old one that was in a separated repository)

# Publish your work

## Commit your code

Create a new branch following this pattern: <rule_id>-<language>
Example:

```sh
git checkout -b 47-JS
```

Commit your code:

```sh
git add .
git commit -m "your comments"
```

Push your branch:

```sh
git push origin <rule_id>-<language>
```

You may have to login with your account: <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token>

## Open pull request

Once your code is pushed and tested, open a PR between your branch and "main": <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request>

## Review others development

Ask to people to review your PR. Once two people, at least, have reviewed, you can validate your PR
If you want to be reviewed, review others... It's a win/win situation

## Validation of a PR

Validate your PR or ask to someone who have the permissions to validate your PR.
Once PR validated, a github workflow is automatically launched. Thus, the new implemented code is also scanned with our internal Sonar to check the implemented code quality.
Here is the SonarQube: <https://sonarcloud.io/organizations/green-code-initiative/projects>

## Close your rule

Once your PR is validated, your rule integrates creedengo. In <https://github.com/orgs/green-code-initiative/projects/2>, move it from the "In Progress" column to the "Done" column.
Well done.
