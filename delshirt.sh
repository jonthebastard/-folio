#!/bin/bash

set -euo pipefail

git_current_branch () {
  local REF
  REF=$(git symbolic-ref --quiet HEAD 2>/dev/null)
  local RET=$?
  if [[ $RET != 0 ]]
  then
    [[ $RET == 128 ]] && return
    REF=$(git rev-parse --short HEAD 2>/dev/null)  || return
  fi
  echo ${REF#refs/heads/}
}

for NUMBER in "$@" ; do
  IMAGE=$(find img -name "*${NUMBER}*")
  POST=$(find _posts -name "*${NUMBER}*")
  BAND_NAME=$(grep 'title' "${POST}" | awk -F'"' '{print $2}')
  COMMIT_INFO=$(echo ${IMAGE} | sed -E 's/img\/([0-9a-z-]+)\.jpg/\1/')

  rm ${IMAGE}
  rm ${POST}
  git commit -a -m "removing ${COMMIT_INFO} image+post"

  FILE_BAND_NAME=$(echo $COMMIT_INFO | cut -c 6-)
  echo ${FILE_BAND_NAME}
  if ! [[ $(ls img | grep ${FILE_BAND_NAME}) ]] ; then
    sed -i '' -E "/\- \"${BAND_NAME}\"/d" _config.yml
    git commit -a -m "removing ${BAND_NAME} from _config.yml"
  fi
done

git push origin $(git_current_branch)
