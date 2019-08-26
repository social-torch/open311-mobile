#!/bin/bash

set -e

HERE="$( cd "$( dirname "${BASE_SOURCE[0]}" )" && pwd)"

if [ -f "${HERE}/prebuild.sh" ]; then
  ${HERE}/prebuild.sh
fi

flutter $@
