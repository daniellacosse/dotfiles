SHELL:=/bin/bash
NODE:=$(if $(shell which node),$(shell which node),nonode)

HOME_FOLDER=~

TMP_FOLDER = $(HOME_FOLDER)/.tmp
TMP_FILES = $(TMP_FOLDER)/last_bash \
	$(TMP_FOLDER)/last_brew \
	$(TMP_FOLDER)/last_yarn \
	$(TMP_FOLDER)/last_code

BASH_FOLDER=bash
ASSETS_FOLDER=assets
VSCODE_FOLDER=.vscode
VSCODE_FILES=$(shell find $(VSCODE_FOLDER) -type d) \
	$(shell find $(VSCODE_FOLDER) -type f -name '*')

DASH_LICENSE_FILE=license.dash-license
DASH_LICENSE=$(ASSETS_FOLDER)/$(DASH_LICENSE_FILE)
DASH_LICENSE_ZIP=$(DASH_LICENSE).zip

MACROS=$(ASSETS_FOLDER)/macros.kmmacros

BASH_PROFILE=$(BASH_FOLDER)/profile
BASH_SCRIPTS=$(BASH_FOLDER)/scripts

BASH_PROFILE_DEST=$(HOME_FOLDER)/.bash_profile
BASH_SCRIPTS_DEST=$(HOME_FOLDER)/.bash_scripts

SSH_FOLDER=$(HOME_FOLDER)/.ssh
SSH_PEM=$(SSH_FOLDER)/id_rsa
SSH_CONFIG=$(SSH_FOLDER)/config

SYSTEM_APPS_CONFIG=/Library/Application\ Support
CARBONITE_INSTALL_PAGE=https://account.carbonite.com/Computer/List

# -- commands --
.PHONY: default update

# TODO: open installed bckground apps
# TODO: unpack encrypted/zipped keyboard maestro license
default: $(TMP_FILES) $(SSH_PEM) $(DASH_LICENSE) $(MACROS)
	open $(CARBONITE_INSTALL_PAGE)
	\
	cp $(DASH_LICENSE) $(SYSTEM_APPS_CONFIG)/Dash/License/license.dash-license ;\
 	\
	open "x-apple.systempreferences:com.apple.preference.keyboard?Keyboard" ;\
	read -p "1) select `Use F1, F2, etc. keys as standard function keys`" ;\
	\
	open "x-apple.systempreferences:com.apple.preference.keyboard?Shortcuts" ;\
	read -p "2) turn off `Display` and `Mission Control` function key shortcuts" ;\

update: $(TMP_FILES) $(MACROS)

# -- cache --
$(TMP_FOLDER):
	mkdir -p $(TMP_FOLDER)

$(TMP_FOLDER)/last_bash: $(TMP_FOLDER) $(BASH_PROFILE) $(BASH_SCRIPTS)
	chmod -R u+x $(BASH_SCRIPTS) 								> $(TMP_FOLDER)/last_bash 2>&1 ;\
	cp -rf $(BASH_SCRIPTS) $(BASH_SCRIPTS_DEST) > $(TMP_FOLDER)/last_bash 2>&1  ;\
	\
	cp $(BASH_PROFILE) $(BASH_PROFILE_DEST)			> $(TMP_FOLDER)/last_bash 2>&1  ;\
	source $(BASH_PROFILE_DEST)									> $(TMP_FOLDER)/last_bash 2>&1

$(TMP_FOLDER)/last_brew: $(TMP_FOLDER) Brewfile
	brew bundle \
		> $(TMP_FOLDER)/last_brew 2>&1

$(TMP_FOLDER)/last_yarn: $(TMP_FOLDER) $(NODE) package.json
	cat package.json |\
		jq -r '.dependencies | keys' |\
		xargs -L 1 yarn global add \
			> $(TMP_FOLDER)/last_yarn 2>&1

$(TMP_FOLDER)/last_code: $(TMP_FOLDER) $(TMP_FOLDER)/last_brew $(VSCODE_FILES)
	cp .vscode $(SYSTEM_APPS_CONFIG)/Code/User ;\
	cat .vscode/extensions.json |\
		jq -r '.recommendations | .[]' |\
		xargs -L 1 code --install-extension \
			> $(DEP_FOLDER)/last_code 2>&1

$(SSH_PEM):
	email=$(read -p "Enter your email address.") ;\
	\
	ssh-keygen -t rsa -b 4096 -C $$email ;\
	cp $(ASSETS_FOLDER)/ssh-config.example $(SSH_CONFIG) ;\
	ssh-add -K $(SSH_PEM) ;\
	\
	echo $(SSH_PEM).pub ;\
	read -p "Please add your public key to github."

$(DASH_LICENSE):
	open $(DASH_LICENSE_ZIP) ;\
	read -p "unarchive the dash license..."

$(MACROS):
	open $(MACROS)

$(NODE): $(TMP_FOLDER)/last_brew
	cat package.json |\
		jq -r '.engines.node' |\
			nvm install
