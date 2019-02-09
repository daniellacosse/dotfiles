
#!/bin/bash

source ~/.scripts/*
PATH=$PATH:~/.scripts/*

alias profile="code ~/.profile"
alias scripts="code ~/.scripts"

new() {
  touch ~/.scripts/$1
  chmod -R u+x ~/.scripts

  code ~/.scripts/$1
}