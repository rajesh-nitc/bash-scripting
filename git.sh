#!/bin/bash

set -x

REPO="test"
DEVELOP="develop"
RELEASE="release/1.0.0"
FILE="hello.txt"
git clone git@github.com:rajesh-nitc/$REPO.git
cd $REPO

develop_exists=$(git branch -a | grep $DEVELOP)
if [ $? = 0 ]
then
    git checkout $DEVELOP
    git branch -u origin/$DEVELOP
    echo "foo $DEVELOP" >> $FILE
    git add .
    git commit -m "msg"
    git push
else
    git checkout -b $DEVELOP master
    echo "hello $DEVELOP" >> $FILE
    git add .
    git commit -m "msg"
    git push origin $DEVELOP
    git branch -u origin/$DEVELOP
fi

release_exists=$(git branch -a | grep $RELEASE)
if [ $? = 0 ]
then
    git checkout $RELEASE
    git branch -u origin/$RELEASE
    echo "foo $RELEASE" >> $FILE
    git add .
    git commit -m "msg"
    git push
else
    git checkout -b $RELEASE $DEVELOP
    echo "fix in $RELEASE" >> $FILE
    git add .
    git commit -m "msg"
    git push origin $RELEASE
    git branch -u origin/$RELEASE
fi

cat $FILE
git checkout $DEVELOP
git merge $RELEASE
git push
git checkout master
git merge $RELEASE
git push
git push origin --delete $RELEASE