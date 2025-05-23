#!/bin/bash

###
### tool to check requirements
### --debug : enable debug mode
###

. _core.sh

debug "config - JAVA_VERSION_MIN : $JAVA_VERSION_MIN"
debug "config - JAVA_VERSION_MAX : $JAVA_VERSION_MAX"
debug "config - MAVEN_VERSION_MIN : $MAVEN_VERSION_MIN"
debug "config - MAVEN_VERSION_MAX : $MAVEN_VERSION_MAX"

echo -e "***** Docker 🚀"
check_installation "docker --version"

echo -e "***** Docker-compose 🚀"
check_installation "docker-compose --version"

echo -e "***** Java 🚀"
# check_installation "javap -version"
check_installation "java --version"

# class_version=`javap -verbose java.lang.String | grep "major version" | cut -d " " -f5`
# check_version_min_java "$class_version" "$JAVA_CLASS_VERSION_MIN" "$JAVA_VERSION_MIN"
# check_version_max_java "$class_version" "$JAVA_CLASS_VERSION_MAX" "$JAVA_VERSION_MAX"

java_full_version=$(java --version 2>&1 | head -n 1 | awk '{print $2}')
check_version_min_java "$java_full_version" "$JAVA_VERSION_MIN"
check_version_max_java "$java_full_version" "$JAVA_VERSION_MAX"

echo -e "***** Maven 🚀"
check_installation "mvn --version"

mvn_version=`mvn --version 2>&1 | head -1 | cut -d " " -f3`
check_version_min_maven "$mvn_version" "$MAVEN_VERSION_MIN"
check_version_max_maven "$mvn_version" "$MAVEN_VERSION_MAX"

echo -e "***** Git 🚀"
check_installation "git --version"

echo -e "***** jq 🚀"
check_installation "jq --version"

