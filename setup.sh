#!/bin/sh
## 0. Check sudo
if [ "$EUID" -ne 0 ]
  then echo "Warning: linking web portals to system dir requires root privilege"
  ISROOT=0
  else ISROOT=1
fi

## 1. Create dirs
mkdir -p -m 755 repo
mkdir -p -m 755 www
#mkdir -p -m 755 conf

## 2. Check httpd and svn
if [ -f /etc/httpd/conf/httpd.conf ]; then 
  HTTPD_CONF='/etc/httpd/conf/httpd.conf'
  echo "Found /etc/httpd/conf/httpd.conf"
else
  echo "Warning: httpd.conf not found. Httpd is required for TexBucket."
  read -p "Full path to httpd.conf?" HTTPD_CONF
fi

DOCUMENT_ROOT=`grep -o '^DocumentRoot ".*"' $HTTPD_CONF | c
ut -d' ' -f2 | sed -e 's/^"//' -e 's/"$//'`

svnserve --version >/dev/null
if [ $? -ne 0 ]; then
  echo "Error: svnserve not found. Subversion is required for TexBucket."
  exit 1
fi

TEXBUCKET_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

#if [ ISROOT ]; then
#  killall svnserve
#  svnserve -d -r $TEXBUCKET_DIR/repo
#  echo "svnserve root path reset to $TEXBUCKET_DIR/repo"
#fi

## 3. Make links for dirs
if [ ISROOT ]; then
  ln -s $TEXBUCKET_DIR/www $DOCUMENT_ROOT/texbucket
  echo "TexBucket web portal linked to $DOCUMENT_ROOT/texbucket" 
fi

## 4. Make links for bins
if [ ISROOT ]; then
  ln -s $TEXBUCKET_DIR/bin/texbucket_new /usr/local/bin/tb_new
  ln -s $TEXBUCKET_DIR/bin/texbucket_remove /usr/local/bin/tb_remove
  ln -s $TEXBUCKET_DIR/bin/texbucket_useradd /usr/local/bin/tb_useradd
  ln -s $TEXBUCKET_DIR/bin/texbucket_userdel /usr/local/bin/tb_userdel
  echo "TexBucket commands linked to /usr/local/bin/
fi
