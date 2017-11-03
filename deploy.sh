#!/bin/bash

git submodule init
git submodule update

## 2016
pushd FATA2016-Site
git pull origin master

if [ ! -d themes ]; then
  mkdir themes
  pushd themes
  git clone https://github.com/digitalcraftsman/hugo-creative-theme.git
  popd
fi

hugo -d public/2016
popd

## 2017
pushd FATA2017-Site
git pull origin master

jekyll build --destination _site/2017
popd

## create new branch and push
git add FATA2016-Site FATA2017-Site
git commit -m "move submodule to latest commit in master"
git push origin master
git checkout -- .

git checkout --orphan gh-pages
mv FATA2016-Site/public/2016 .
mv FATA2017-Site/_site/2017 .

git rm --cached -r .
git add 2016/ 2017/ CNAME index.html
git commit -m "update sites"
git push origin :gh-pages
git push -u origin gh-pages

git checkout -f master
git branch -D gh-pages
