#!/bin/bash

## 0. Check sudo
if [ $(id -u) -ne 0 ]
  then echo "Warning: linking web portals to system dir requires root privilege"
  ISROOT=0
  else ISROOT=1
fi

## 1. Create dirs
TEXBUCKET_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $TEXBUCKET_DIR
mkdir -p -m 755 repo

## 2. Check httpd and svn
if [ -f /etc/httpd/conf/httpd.conf ]; then 
  HTTPD_CONF='/etc/httpd/conf/httpd.conf'
  echo "Found /etc/httpd/conf/httpd.conf"
  DOCUMENT_ROOT=`grep -o '^DocumentRoot ".*"' $HTTPD_CONF | c
ut -d' ' -f2 | sed -e 's/^"//' -e 's/"$//'`
else
  echo "Warning: httpd.conf not found. Httpd is required for TexBucket."
  read -p "Full path to web root directory? " DOCUMENT_ROOT
  while [ ! -d $DOCUMENT_ROOT ]; do
    echo "invalid path"
    read -p "Full path to web root directory?" DOCUMENT_ROOT
  done
fi

svnserve --version >/dev/null
if [ $? -ne 0 ]; then
  echo "Error: svnserve not found. Subversion is required for TexBucket."
  exit 1
fi

if [ "$ISROOT" -ne 0 ]; then
  killall svnserve
  svnserve -d
  echo "svnserve restarted"
fi

## 3. Make links for dirs
if [ "$ISROOT" -ne 0 ] && [ ! -d $DOCUMENT_ROOT/texbucket ]; then
  mkdir -p -m 755 $DOCUMENT_ROOT/texbucket
  ln -s $DOCUMENT_ROOT/texbucket $TEXBUCKET_DIR/www 
  echo "TexBucket web portal linked to $DOCUMENT_ROOT/texbucket" 
fi

## 4. Make links for bins.
if [ "$ISROOT" -ne 0 ]; then
  ln -s $TEXBUCKET_DIR/repo /repo
  ln -s $TEXBUCKET_DIR/bin/texbucket_new /usr/bin/texbucket_new
  ln -s $TEXBUCKET_DIR/bin/texbucket_remove /usr/bin/texbucket_remove
  ln -s $TEXBUCKET_DIR/bin/texbucket_useradd /usr/bin/texbucket_useradd
  ln -s $TEXBUCKET_DIR/bin/texbucket_userdel /usr/bin/texbucket_userdel
  echo "TexBucket commands linked to /usr/bin/"
fi
