#!/bin/bash

set -xe

REPO="test"
DEVELOP="develop"
RELEASE="release/1.0.0"
FILE="hello.txt"
git clone git@github.com:rajesh-nitc/$REPO.git
cd $REPO
git checkout -b $DEVELOP master
echo "hello $DEVELOP" >> $FILE
git add .
git commit -m "msg"
git push origin $DEVELOP
git branch -u origin/$DEVELOP
git checkout -b $RELEASE $DEVELOP
echo "fix in $RELEASE" >> $FILE
git add .
git commit -m "msg"
git push origin $RELEASE
git branch -u origin/$RELEASE
cat $FILE
git checkout $DEVELOP
git merge $RELEASE
git push origin $DEVELOP
git checkout master
git merge $RELEASE
git push origin master
git push origin --delete $RELEASE