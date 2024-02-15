#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SITEFILE="${SITEFILE:-${SCRIPT_DIR}/jenkins.yml}"
GIT_EXIT_IF_CHANGES="${GIT_EXIT_IF_CHANGES:-yes}"
if [[ -n ${ANSIBLE_INVENTORY_MORE} ]]; then
  additional_inventory="${ANSIBLE_INVENTORY_MORE}"
fi

opts=(
  ansible-playbook          # must be first
  -i "${SCRIPT_DIR}/inventory/"
  -i "${additional_inventory}"
  --become
  --diff
  #--vault-password-file ./.ansible_vault.txt
  "${SITEFILE}"  # must be last
)

export ANSIBLE_CALLBACKS_ENABLED='timer,profile_tasks'
export ANSIBLE_STDOUT_CALLBACK='yaml'

exit_if_git_changes() {
  # exit if there are uncommited changes
  if [[ $GIT_EXIT_IF_CHANGES == "yes" ]]; then
    local git_changes=$(git diff-index HEAD --)
    if [[ $git_changes == "" ]]; then
      : # no changes
    else
      #set +u
      #local $OVERRIDE_GIT_COMMIT_REQ="${OVERRIDE_GIT_COMMIT_REQ:-false}"
      #if [[ $OVERRIDE_GIT_COMMIT_REQ != "TRUE" ]]; then
        echo "UNCOMMITED CHANGES IN GIT!"
        echo "Commit first then run again"
        exit 1
      #fi
    fi
  fi
}
  

date
exit_if_git_changes
set -x
time ${opts[@]} ${@}
set +x
date
