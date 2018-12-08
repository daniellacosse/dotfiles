source ~/.bash_utilities/*
PATH=$PATH:~/.bash_scripts

alias profile="vi ~/.bash_profile"
alias utilities="vi ~/.bash_utilities"
alias utils=utilities

alias makescript="touch ~/.bash_scripts/$1 && vi ~/.bash_scripts/$1"
alias makeutil="touch ~/.bash_utilities/$1 && vi ~/.bash_utilities/$1"
