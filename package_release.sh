#!/bin/sh

ADDON_NAME="Clique_Tooltips"
VERSION=$(grep "## Version" ${ADDON_NAME}/${ADDON_NAME}.toc | awk '{split($0, a, ":"); print a[2]}' | sed 's/^[ ]*//')

if [ -z ${VERSION+x} ]; then
  echo "Missing version. Cannot create release."
  exit -1
fi

echo "Detected version: " ${VERSION}

zip -r ${ADDON_NAME}-${VERSION}.zip ${ADDON_NAME}
