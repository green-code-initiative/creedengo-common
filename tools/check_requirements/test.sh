#!/bin/bash

# On exporte les variables nécessaires pour les tests
export JAVA_CLASS_VERSION_MIN=52
export JAVA_CLASS_VERSION_MAX=61
export JAVA_VERSION_MIN=8
export JAVA_VERSION_MAX=17
export MAVEN_VERSION_MIN="3.6.0"
export MAVEN_VERSION_MAX="3.9.9"
export DEBUG=0

# On vérifie que config.txt existe, mais on ne le modifie pas
if [ ! -f config.txt ]; then
  echo "Erreur : config.txt est requis pour les tests mais ne sera pas modifié."
  exit 1
fi

# On source normalement _core.sh (il lira config.txt mais ne le modifie jamais)
source ./_core.sh

test_output="test_output.txt"

echo ""
echo "===== TESTS check_version_min_java ====="
check_version_min_java 52 52 8 > $test_output
grep -q "✅ min version" $test_output && echo "check_version_min_java OK (equal)" || echo "check_version_min_java FAIL (equal)"

check_version_min_java 53 52 8 > $test_output
grep -q "✅ min version" $test_output && echo "check_version_min_java OK (greater)" || echo "check_version_min_java FAIL (greater)"

check_version_min_java 51 52 8 > $test_output
grep -q "❌ min version" $test_output && echo "check_version_min_java OK (lower)" || echo "check_version_min_java FAIL (lower)"

echo ""
echo "===== TESTS check_version_max_java ====="
check_version_max_java 61 61 17 > $test_output
grep -q "✅ max version" $test_output && echo "check_version_max_java OK (equal)" || echo "check_version_max_java FAIL (equal)"

check_version_max_java 60 61 17 > $test_output
grep -q "✅ max version" $test_output && echo "check_version_max_java OK (lower)" || echo "check_version_max_java FAIL (lower)"

check_version_max_java 62 61 17 > $test_output
grep -q "❌ max version" $test_output && echo "check_version_max_java OK (greater)" || echo "check_version_max_java FAIL (greater)"

echo ""
echo "===== TESTS check_version_min_maven ====="
check_version_min_maven "3.8.1" "3.8.1" > $test_output
grep -q "✅ min version" $test_output && echo "check_version_min_maven OK (equal)" || echo "check_version_min_maven FAIL (equal)"

check_version_min_maven "3.8.2" "3.8.1" > $test_output
grep -q "✅ min version" $test_output && echo "check_version_min_maven OK (greater)" || echo "check_version_min_maven FAIL (greater)"

check_version_min_maven "3.7.9" "3.8.1" > $test_output
grep -q "❌ min version" $test_output && echo "check_version_min_maven OK (lower)" || echo "check_version_min_maven FAIL (lower)"

echo ""
echo "===== TESTS check_version_max_maven ====="
check_version_max_maven "3.8.1" "3.8.1" > $test_output
grep -q "✅ max version" $test_output && echo "check_version_max_maven OK (equal)" || echo "check_version_max_maven FAIL (equal)"

check_version_max_maven "3.7.9" "3.8.1" > $test_output
grep -q "✅ max version" $test_output && echo "check_version_max_maven OK (lower)" || echo "check_version_max_maven FAIL (lower)"

check_version_max_maven "3.8.2" "3.8.1" > $test_output
grep -q "❌ max version" $test_output && echo "check_version_max_maven OK (greater)" || echo "check_version_max_maven FAIL (greater)"

rm -f $test_output

echo ""
echo "===== TESTS check_requirements.sh (présence des commandes et extraction version) ====="

# Vérifie la présence des commandes principales dans check_requirements.sh
grep -q "docker --version" check_requirements.sh && echo "docker --version OK" || echo "docker --version FAIL"
grep -q "docker-compose --version" check_requirements.sh && echo "docker-compose --version OK" || echo "docker-compose --version FAIL"
grep -q "javap -version" check_requirements.sh && echo "javap -version OK" || echo "javap -version FAIL"
grep -q "mvn --version" check_requirements.sh && echo "mvn --version OK" || echo "mvn --version FAIL"
grep -q "git --version" check_requirements.sh && echo "git --version OK" || echo "git --version FAIL"
grep -q "jq --version" check_requirements.sh && echo "jq --version OK" || echo "jq --version FAIL"

# Vérifie l'extraction de la version majeure Java
grep -q "java_full_version=" check_requirements.sh && echo "java_full_version extraction OK" || echo "java_full_version extraction FAIL"

echo ""
echo "===== FIN DES TESTS ====="