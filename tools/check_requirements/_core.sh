#!/bin/bash

###########################################################################################
#    C O R E     ( /!\ /!\ /!\ NOT to modify)
###########################################################################################
MAGENTA='\033[38;5;201m'
PINK='\033[38;5;219m'
BLUE='\033[38;5;39m'
GREY='\033[38;5;240m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Import configurations from config.txt
while IFS="=" read -r key value || [ -n "$key" ]; do
    # Remove inline comments and trim whitespace
    key=$(echo "$key" | sed 's/\s*#.*//')
    value=$(echo "$value" | sed 's/\s*#.*//')

    # Skip empty lines
    if [[ -z $key ]]; then
        continue
    fi

    declare "$key=$value"
done < config.txt

# Gestion du mode debug via option --debug
for arg in "$@"; do
  if [[ "$arg" == "--debug" ]]; then
    export DEBUG=1
  fi
done

### display debug logs if DEBUG enabled
### $1 : message to log
debug() {
  if [[ $DEBUG == 1 ]]; then
    echo -e "${GREY}--- DEBUG --- $1${NC}"
  fi
}

### launch requirements checks
### $1 : the command to check
function check_installation() {

  debug "METHODE check_installation / param 1 : $1"

  declare -a command="$1"
  declare -a full_command="$command 2>/dev/null 1>/dev/null; echo $?"

  eval "$full_command" 2>/dev/null 1>/dev/null
  declare -a res=$?
  if [[ $res == 0 ]]; then
    echo -e "   ✅ installation"
  else
    echo -e "   ❌ installation : please ${PINK}check or install tool${NC}"
  fi

  debug "command for check = \"$full_command\""

}

# Fonction pour comparer deux versions pas forcément de type entier mais avec des "." (retourne 0 si v1 >= v2, 1 sinon)
version_ge() {
  [ "$1" = "$2" ] && return 0
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

# Fonction pour comparer deux versions pas forcément de type entier mais avec des "." (retourne 0 si v1 <= v2, 1 sinon)
version_le() {
  [ "$1" = "$2" ] && return 0
  [ "$(printf '%s\n' "$1" "$2" | sort -V | tail -n1)" = "$2" ]
}

# Fonction générique pour vérifier les versions min et max
# $1 : version courante
# $2 : borne de version (min ou max)
# $3 : type de comparaison ("min" ou "max")
# $4 : label pour affichage (optionnel)
# $5 : version associée pour affichage (optionnel)
function check_version_generic() {
  local current_version="$1"
  local bound_version="$2"
  local compare_type="$3"

  debug "METHODE check_version_generic"
  debug " - param 1 (current_version) : $current_version"
  debug " - param 2 (bound_version) : $bound_version"
  debug " - param 3 (compare_type) : $compare_type"

  local result=1

  if [[ "$compare_type" == "min" ]]; then
    if version_ge "$current_version" "$bound_version"; then
      result=0
    fi
  elif [[ "$compare_type" == "max" ]]; then
    if version_le "$current_version" "$bound_version"; then
      result=0
    fi
  fi

  if [[ $result -eq 0 ]]; then
    echo -e "   ✅ $compare_type version"
  else
    echo -e "   ❌ $compare_type version : please ${PINK}check or install good version ${NC}"
  fi

  echo -e "        (current version : $current_version / $compare_type version : '$bound_version')"
}

# Refactorisation des fonctions spécifiques pour utiliser la fonction générique

function check_version_min_java() {
  debug "METHODE check_version_min_java"
  debug " - param 1 : $1"
  debug " - param 2 : $2"
  # check_version_generic "$1" "$2" "min" "class version" "JAVA_CLASS_VERSION_MIN"
  check_version_generic "$1" "$2" "min"
}

function check_version_max_java() {
  debug "METHODE check_version_max_java"
  debug " - param 1 : $1"
  debug " - param 2 : $2"
  # check_version_generic "$1" "$2" "max" "class version" "JAVA_CLASS_VERSION_MAX"
  check_version_generic "$1" "$2" "max"
}

function check_version_min_maven() {
  debug "METHODE check_version_min_maven"
  debug " - param 1 : $1"
  debug " - param 2 : $2"
  check_version_generic "$1" "$2" "min"
}

function check_version_max_maven() {
  debug "METHODE check_version_max_maven"
  debug " - param 1 : $1"
  debug " - param 2 : $2"
  check_version_generic "$1" "$2" "max"
}
