# Rules Tagging system and Creating Quality Profile

## Purpose

### Rules Tagging system

Add one new tag to a list of rules from `SONAR_RULES_REUSED.md` (using SonarQube API).
Why ? because maybe some original SonarQube rules are already ready for being part of this plugin

### Creedengo Quality Profile

Add one new Profile by language inherited from SonarWay (using SonarQube API).
Why ?
- we must create a custom Profile to use new eco-design rules from creedengo plugins
- the new profile is inherited from SonarWay to keep natives SonarWay rules also
The script attach the new rules with the new quality profile.
The new profile becomes the default profile for the language.

## Requirements

- Sonar installed
  - add new token in personal account settings to communicate with Sonar API ("user token" type)
  - Got **'Admininister: Quality Profiles'** global permission on your account.
- Check `_config.sh` file :
  - debug mode (`DEBUG` variable) : 0 to disable, 1 to enable
  - simulation mode (`SIMULATION` variable) : 0 to do real calls, 1 to simulate 
  - Sonar token (`SONAR_TOKEN` variable) : put here the new added token previously
  - Sonar URL (`SONAR_URL` variable) : put here your custom Sonar URL ("http://localhost:9000" by default)
  - name of tag to add (`TAG_ECODESIGN` variable) : the name of the new tag to add to a list of rules
  - file path to `SONAR_RULES_REUSED.md` (`FILEPATH_SONAR_RULES_REUSED` variable) : filepath in the local folder. Contains all rules.
  - name of profile to add (`PROFILE_ECODESIGN` variable) : the name of the new profile to add for each language
  - language keys list (string format separated with one comma) (`PROFILES_LANGUAGE_KEYS` variable) : specify here the list of all keys language that you want to add the new creedengo quality profile
  - profiles set as default (`IS_PROFILE_ECODESIGN_DEFAULT` variable) : 1 if we want to set created profiles as default profile for each language, 0 if we don't want

## Local develop Environment & prerequisites

Differents environment have been used:

- bash 3.2 on MacOS with extra jq package (`brew install jq`)
- Ubuntu 20.04.4 LTS (bash 5.0.17(1)-release) with extra jq package (`sudo apt install jq`)

## Concepts

### Call Sonar API rest to

#### Tags

- ... get rule data (included systags array and tags array)
- ... update rule data i.e tags array

#### Quality Profile

- ... create custom quality profile
- ... change parent profile
- ... get profile key
- ... activate existing rules associated with mentionned tag

### Tags modifications

SonarQube `systags`` are not editable from api call (it seems to be nativally fullfilled with SonarQube installation)
Tags array seems to be the editable part. It's editable from :

- Sonar UI usage
- Sonar API calls

## Algorithm

### Tagging scripts

- get rules data (rules list from parsing `SONAR_RULES_REUSED.md`)
- check if new tag to add (from config file) already exists on systags array or tags array
- add new tag to all existing tags if necessary

Files :

- `check_tags.sh` : read tags for all listed rules
- `clean_tag.sh` : delete specified tag from all listed rules
- `install_tag.sh` : add specified tag to all listed rules

### Profile script

- create a custom profile for each language
- change parent profiles with "Sonar Way"
- activate existing rules tag by `TAG_ECODESIGN` variable to the custom profile

Files :

- `install_profile.sh` : create new custom profile

## How to

- change configuration in `_config.sh` file : check requirements above
- launch `check_tags.sh` to control your rules and tags
- launch `install_tags.sh` to add custom tag to your rules
- launch `check_tags.sh` again to control your rules and tags
- launch `install_profile.sh` to create profiles with the new rules from plugins

## Contributing

**You want to add new pre-existing rule from Sonar ?**

- You have to find the sonar key from **"RULES"** view on Sonarqube
- adding a new line to `SONAR_RULES_REUSED.md` with this key
- add references to justify this value
- Create a Pull Request following #CONTRIBUTING.md
