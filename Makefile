BREW_URL = https://raw.githubusercontent.com/Homebrew/install/master/install

TMP_FOLDER = ~/.tmp
TMP_FILES = $(TMP_FOLDER)/last_bash \
	$(TMP_FOLDER)/last_brew \
	$(TMP_FOLDER)/last_yarn \
	$(TMP_FOLDER)/last_code

BASH_FOLDER=bash
ASSETS_FOLDER=assets

DASH_LICENSE=$(ASSETS_FOLDER)/license.dash-license

BASH_SCRIPTS=$(BASH_FOLDER)/scripts
BASH_PROFILE=$(BASH_FOLDER)/profile

.PHONY: default update

default: ~/.ssd/id_rsa $(TMP_FILES)
	cp $(DASH_LICENSE) ~/Library/Application\ Support/Dash/License/license.dash-license ;\
 	\
	open "x-apple.systempreferences:com.apple.preference.keyboard?Keyboard" ;\
	read -p "1) select `Use F1, F2, etc. keys as standard function keys`" ;\
	open "x-apple.systempreferences:com.apple.preference.keyboard?Shortcuts" ;\
	read -p "2) turn off `Display` and `Mission Control` function key shortcuts" ;\
 	\
	open macros.kmmacros ;\

update: $(TMP_FILES)
	# TODO

~/.ssh/id_rsa:
	email=$(read -p "Enter your email address.") ;\
	ssh-keygen -t rsa -b 4096 -C $(email) ;\
	~/.ssh/config << cat >> EOF \
		Host * \
			AddKeysToAgent yes \
			UseKeychain yes \
			IdentityFile ~/.ssh/id_rsa \
	EOF ;\
	ssh-add -K ~/.ssh/id_rsa ;\
	\
	echo ~/.ssh/id_rsa.pub ;\
	read -p "Please add your public key to github."

$(TMP_FOLDER)/last_bash:
	chmod -R u+x $(BASH_SCRIPTS) ;\
	cp -rf $(BASH_SCRIPTS) ~/.bash_scripts ;\
	\
	cp $(BASH_PROFILE) ~/.bash_profile ;\
	source ~/.bash_profile

$(TMP_FOLDER)/last_brew:
	/usr/bin/ruby -e "curl -fsSL $(BREW_URL)" ;\
	brew bundle

# TODO: install node from package.json/engines
# then globally install dependencies
$(TMP_FOLDER)/last_yarn:
	nvm install --lts ;\
	yarn global add \
		concurrently \
		typescript \
		ts-node \
		yo

$(TMP_FOLDER)/last_code:
	cat .vscode/extension.list | xargs -L 1 echo code --install-extension ;\
	cp .vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
