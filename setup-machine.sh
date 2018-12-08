# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle

sudo easy_install pip

# global node deps
npm run install

pip install -r requirements.txt

# shell
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

rm -rf ~/.vim_runtime

cp ./bash_profile ~/.bash_profile
cp -rf ./bash_utilities ~/.bash_utilities
cp -rf ./bash_scripts ~/.bash_scripts

source ~/.bash_profile

# vscode extensions
code --install-extension tnaseem.theme-seti
code --install-extension qinjia.seti-icons
code --install-extension sirtori.indenticator

code --install-extension yzhang.markdown-all-in-one

code --install-extension eamodio.gitlens
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
