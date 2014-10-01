#!/bin/bash

TEXBUCKET_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for DIR in $TEXBUCKET_DIR/repo/*; do
  if [ -d "$DIR" ]; then
    texbucket_remove `basename $DIR`
  fi
done

cd $TEXBUCKET_DIR
rm -rf repo
rm -rf www

cd /usr/bin
rm -f texbucket_*

cd /var/www
rm -rf texbucket
rm -f /repo
