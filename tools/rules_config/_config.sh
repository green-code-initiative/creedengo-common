############################################
#    C O N F I G U R A T I O N   F I L E
############################################


#####
# common configuration ("install_tag.sh" / "check_tag.sh" / "clean_tag.sh" / "install_profile.sh")
#####

# if tool display DEBUG logs or not
# DEBUG=0
DEBUG=1

# if tool simulate the add tag process if new tag has to be added
SIMULATION=0
#SIMULATION=1

SONAR_PORT=$1

# your sonar token (previously created in SONAR to secure communication with it)
# first input param of your script shell
SONAR_TOKEN=$2

# WARNING : let "http" instead of "https" (because you could have a TLS problem)
SONAR_URL=http://localhost:$SONAR_PORT

# new tag to add to rules (tagging tools) or to use for rules added to new profiles created (install_profile tool)
TAG_ECODESIGN=creedengo

#####
# additional configuration for "install_profile.sh" tool
#####

# list of rule keys that will be updated with new tag
RULES_KEYS=java:S1696

# filepath to markdown doc containing rule keys that will be updated with new tag
FILEPATH_SONAR_RULES_REUSED='./SONAR_RULES_REUSED.md'

# name quality profile to create with "install_profile.sh" tool
PROFILE_ECODESIGN="creedengoProfile"

# programming languages list to create with "install_profile.sh" tool
PROFILES_LANGUAGE_KEYS=php,py,java,cs

# if we want to set created profiles as default profile for each language
IS_PROFILE_ECODESIGN_DEFAULT=1
#IS_PROFILE_ECODESIGN_DEFAULT=0
