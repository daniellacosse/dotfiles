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

code --install-extension yzhang.markdown-all-in-one

code --install-extension ziyasal.vscode-open-in-github
code --install-extension deerawan.vscode-dash
code --install-extension peterjausovec.vscode-docker

code --install-extension daltonjorge.scala
code --install-extension ms-vscode.go

code --install-extension richie5um2.vscode-sort-json
code --install-extension zengxingxin.sort-js-object-keys
