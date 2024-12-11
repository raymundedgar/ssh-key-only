#!/bin/sh

rustc --version || curl https://sh.rustup.rs -sSf | sh -s -- -y

. "$HOME/.cargo/env"

NEXUS_HOME=$HOME/.nexus
GREEN='\033[1;32m'
ORANGE='\033[1;33m'
NC='\033[0m' # No Color

git --version 2>&1 >/dev/null
GIT_IS_AVAILABLE=$?
if [ $GIT_IS_AVAILABLE != 0 ]; then
  echo Unable to find git. Please install it and try again.
  exit 1;
fi

NONINTERACTIVE = 1
PROVER_ID=$(cat $NEXUS_HOME/prover-id 2>/dev/null)
if [ -z "$NONINTERACTIVE" ] && [ "${#PROVER_ID}" -ne "28" ]; then
    echo "\nTo receive credit for proving in Nexus testnets..."
    echo "\t1. Go to ${GREEN}https://beta.nexus.xyz${NC}"
    echo "\t2. On the bottom left hand corner, copy the ${ORANGE}prover id${NC}"
    echo "\t3. Paste the ${ORANGE}prover id${NC} here. Press Enter to continue.\n"
    PROVER_ID="Uhbg6Ojk4zRMSnFzG3UbXgGaJOo2"
    while [ ! ${#PROVER_ID} -eq "0" ]; do
        if [ ${#PROVER_ID} -eq "28" ]; then
            if [ -f "$NEXUS_HOME/prover-id" ]; then
                echo Copying $NEXUS_HOME/prover-id to $NEXUS_HOME/prover-id.bak
                cp $NEXUS_HOME/prover-id $NEXUS_HOME/prover-id.bak
            fi
            echo "$PROVER_ID" > $NEXUS_HOME/prover-id
            echo Prover id saved to $NEXUS_HOME/prover-id.
            break;
        else
            echo Unable to validate $PROVER_ID. Please make sure the full prover id is copied.
        fi
        read -p "Prover Id (optional)> " PROVER_ID </dev/tty
    done
fi

REPO_PATH=$NEXUS_HOME/network-api

if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating.";
  (cd $REPO_PATH && git stash save && git fetch --tags)
else
  mkdir -p $NEXUS_HOME
  (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
fi
(cd $REPO_PATH && git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1))

(cd $REPO_PATH/clients/cli && cargo run --release --bin prover -- beta.orchestrator.nexus.xyz)
