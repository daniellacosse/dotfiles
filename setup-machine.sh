# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle

# global node deps
npm run install

sudo easy_install pip

# vim
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

# vscode extensions
code --install-extension tnaseem.theme-seti
code --install-extension qinjia.seti-icons
code --install-extension sirtori.indenticator

code --install-extension yzhang.markdown-all-in-one

code --install-extension felipecaputo.git-project-manager
code --install-extension ziyasal.vscode-open-in-github

code --install-extension deerawan.vscode-dash
code --install-extension peterjausovec.vscode-docker

code --install-extension daltonjorge.scala
code --install-extension ms-vscode.go

code --install-extension richie5um2.vscode-sort-json
code --install-extension zengxingxin.sort-js-object-keys

code --install-extension eg2.tslint
code --install-extension joelday.docthis

code --install-extension formulahendry.auto-complete-tag
code --install-extension wayou.vscode-todo-highlight
code --install-extension wix.vscode-import-cost
code --install-extension knisterpeter.vscode-commitizen
