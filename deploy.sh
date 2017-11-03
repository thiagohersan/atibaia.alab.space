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

## update submodules
git add FATA2016-Site FATA2017-Site
git commit -m "update submodules to their latest commit"
git push origin master
git checkout -- .

## create new branch and push
git checkout --orphan gh-pages
mv FATA2016-Site/public/2016 .
mv FATA2017-Site/_site/2017 .

git rm --cached -r .
git add CNAME index.html
git add 2016
git add 2017
git commit -m "updates sites"
git push origin :gh-pages
git push -u origin gh-pages

## clean up local
git checkout -f master
git branch -D gh-pages
