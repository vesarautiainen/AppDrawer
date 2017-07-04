#!/bin/sh

usage () {
  echo
  echo 'Usage: version.sh [<newversion> | minor | major]'
  echo

  echo 'If version.sh is used without any argument, the current version is' \
       'printed.\nIf a version is passed, a new version is set in the qmldir file,\na' \
       'git/bzr commit is created, and a git/bzr tag is created.'

  echo
  echo 'Examples:'
  echo
  echo '$ version.sh'
  echo '$ version.sh minor'
  echo '$ version.sh major'
  echo '$ version.sh 3.1'
  echo
  exit 0
}

# http://djm.me/ask
ask() {
  while true; do

    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi

    # Ask the question
    read -p "$1 [${prompt}] " REPLY

    # Default?
    if [ -z "${REPLY}" ]; then
      REPLY=${default}
    fi

    # Check if the reply is valid
    case "${REPLY}" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac

  done
}

if [ ! -f "qmldir" ]; then
  printf "No qmldir file found in the current directory.\n"
  exit 1
fi

CURRENT_VERSION=$(grep "[0-9]\.[0-9]" < qmldir | awk 'NR==1{print $2}')
VERSION_MAJOR=$(echo "$CURRENT_VERSION" | awk -v RS=. 'NR==1{print $1}')
VERSION_MINOR=$(echo "$CURRENT_VERSION" | awk -v RS=. 'NR==2{print $1}')

if [ -z "${CURRENT_VERSION}" ]; then
  printf "No version found in the qmldir file.\n"
  exit 1
fi

changeVersion() {
  printf "\n  Version bump: %s => %s \n\n" "${1}" "${2}"
  if ask "Update the version in the qmldir file?" Y; then
    sed -r -i'' -e "s/[0-9]+\.[0-9]+/${2}/g" qmldir
  else
    printf "\n"
    exit 0
  fi

  bzr info >/dev/null 2>/dev/null
  if [ "$?" -eq "0" ] && ask "Bazaar repository detected. Commit and tag the new version?" Y; then
    bzr commit -m "${2}" qmldir && bzr tag "v${2}"
  fi

  git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null
  if [ "$?" -eq "0" ] && ask "git repository detected. Commit and tag the new version?" Y; then
    git add qmldir && git commit -m "${2}" && git tag "v${2}"
  fi
}

if [ $# -eq 0 ]; then
  printf "\n  Version %s\n\n" "${CURRENT_VERSION}"

elif [ "$1" = 'minor' ]; then
  VERSION_NEXT_MINOR=$(echo "${VERSION_MINOR}+1" | bc)
  changeVersion "${CURRENT_VERSION}" "${VERSION_MAJOR}.${VERSION_NEXT_MINOR}"

elif [ "$1" = 'major' ]; then
  VERSION_NEXT_MAJOR=$(echo "${VERSION_MAJOR}+1" | bc)
  changeVersion "${CURRENT_VERSION}" "${VERSION_NEXT_MAJOR}.0"

elif echo "$1" | grep "[0-9]\.[0-9]" -q; then
  changeVersion "${CURRENT_VERSION}" "${1}"

else
  usage
fi
