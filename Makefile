BREW_BUFFER = curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install

setup:
	# brew
	/usr/bin/ruby -e "$(BREW_BUFFER)"
	brew bundle

	# node
	nvm install --lts
	yarn global add typescript
	yarn global add ts-node

	# shell scripts
	cp ./.profile ~/.profile
	cp -rf ./.scripts ~/.scripts
	chmod -R u+x ~/.scripts

	source ~/.profile

	# vscode extensions
	code --install-extension tnaseem.theme-seti
	code --install-extension qinjia.seti-icons
	code --install-extension sirtori.indenticator

	code --install-extension yzhang.markdown-all-in-one
	code --install-extension ban.spellright

	code --install-extension eamodio.gitlens
	code --install-extension felipecaputo.git-project-manager
	code --install-extension ziyasal.vscode-open-in-github
	code --install-extension wayou.vscode-todo-highlight

	code --install-extension deerawan.vscode-dash
	code --install-extension peterjausovec.vscode-docker
	code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

	code --install-extension richie5um2.vscode-sort-json
	code --install-extension zengxingxin.sort-js-object-keys

	code --install-extension joelday.docthis
	code --install-extension eg2.tslint

	code --install-extension formulahendry.auto-complete-tag
	code --install-extension wix.vscode-import-cost
