SHELL:=/bin/bash
HOMEBREW=$(shell which brew)

HOME_FOLDER=~
LIBRARY_FOLDER=$(HOME_FOLDER)/Library

TMP_FOLDER = $(HOME_FOLDER)/.tmp
TMP_FILES = $(TMP_FOLDER)/last_brew \
	$(TMP_FOLDER)/last_bash \
	$(TMP_FOLDER)/last_yarn \
	$(TMP_FOLDER)/last_code

BASH_FOLDER=.bash
ASSETS_FOLDER=assets
VSCODE_FOLDER=.vscode
VSCODE_FILES=$(shell find $(VSCODE_FOLDER) -type d) \
	$(shell find $(VSCODE_FOLDER) -type f -name '*')

LICENSE_ZIP=$(ASSETS_FOLDER)/licenses.zip
LICENSE_FOLDER=$(ASSETS_FOLDER)/licenses
DASH_LICENSE=$(LICENSE_FOLDER)/license.dash-license
MAESTRO_LICENSE=$(LICENSE_FOLDER)/license.keyboard-maestro

MACROS=$(ASSETS_FOLDER)/macros.kmmacros

BASH_PROFILE=$(BASH_FOLDER)/profile
BASH_AUTOCOMPLETION=git-autocompletion.bash
BASH_SCRIPTS=$(BASH_FOLDER)/scripts

SYSTEM_BASH_PROFILE=$(HOME_FOLDER)/.bash_profile
SYSTEM_BASH_AUTOCOMPLETION=$(HOME_FOLDER)/.git-autocompletion.bash
SYSTEM_BASH_SCRIPTS=$(HOME_FOLDER)/.bash_scripts

SSH_TEMPLATE=$(ASSETS_FOLDER)/ssh-config.template

SYSTEM_SSH_FOLDER=$(HOME_FOLDER)/.ssh
SYSTEM_SSH_PEM=$(SYSTEM_SSH_FOLDER)/id_rsa
SYSTEM_SSH_CONFIG=$(SYSTEM_SSH_FOLDER)/config

BACKGROUND_APPLICATIONS_LIST=$(ASSETS_FOLDER)/background-applications.list
SYSTEM_APPS_CONFIG=$(LIBRARY_FOLDER)/Application\ Support
SYSTEM_PREFERENCE_PANES_FOLDER=/System/Library/PreferencePanes

# -- commands --
.PHONY: default update

default: $(TMP_FOLDER) $(LICENSE_FOLDER)
	make $(TMP_FILES) ;\
	\
	read -p "1/8) create and add ssh key to github" ;\
	make $(SYSTEM_SSH_PEM)
	\
	read -p "2/8) set colors & default browser" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Appearance.prefPane/ ;\
	\
	read -p "3/8) set accessibility preferences" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/UniversalAccessPref.prefPane/ ;\
	\
	read -p "4/8) set date and time preferences" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/DateAndTime.prefPane/ ;\
	\
	read -p "5/8) arrange windows & click-drag the little white bar over to the main display" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Displays.prefPane/ ;\
	\
	read -p "6/8) select the photos album -Wallpapers- as the Desktop" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/DesktopScreenEffectsPref.prefPane/ ;\
	\
	read -p "7/8) open and setup all background apps" ;\
	cat $(BACKGROUND_APPLICATIONS_LIST) | xargs -L 1 open ;\
	\
	read -p "8/8) install saffire mixcontrol separately" ;\
	open https://fael-downloads-prod.focusrite.com/customer/prod/s3fs-public/downloads/Saffire%20MixControl-3.9.3168_0.dmg ;\

update: $(TMP_FOLDER)
	make $(TMP_FOLDER)/update

$(TMP_FOLDER)/update: $(TMP_FILES)

# -- cache --

$(TMP_FOLDER)/last_brew: $(HOMEBREW) Brewfile
	brew bundle --force \
		> $(TMP_FOLDER)/last_brew

$(TMP_FOLDER)/last_bash: $(BASH_PROFILE) $(BASH_SCRIPTS)
	chmod -R u+x $(BASH_SCRIPTS)													> $(TMP_FOLDER)/last_bash 2>&1 ;\
	cp -R $(BASH_SCRIPTS)/. $(HOME_FOLDER)/.bash_scripts 	>> $(TMP_FOLDER)/last_bash ;\
	\
	cp $(BASH_FOLDER)/$(BASH_AUTOCOMPLETION) $(HOME_FOLDER)/$(BASH_AUTOCOMPLETION) >> $(TMP_FOLDER)/last_bash ;\
	\
	cp $(BASH_PROFILE) $(HOME_FOLDER)/.bash_profile					>> $(TMP_FOLDER)/last_bash ;\
	source $(HOME_FOLDER)/.bash_profile											>> $(TMP_FOLDER)/last_bash 2>&1 ;\
	nvm install $(shell cat package.json | jq -r '.engines.node') >> $(TMP_FOLDER)/last_bash

$(TMP_FOLDER)/last_yarn: package.json
	cat package.json |\
		jq -r '.dependencies | keys | .[]' |\
		xargs -L 1 yarn global add \
			> $(TMP_FOLDER)/last_yarn

$(TMP_FOLDER)/last_code: $(TMP_FOLDER)/last_brew .vscode/extensions.json
	sudo cp -fa .vscode/. $(SYSTEM_APPS_CONFIG)/Code/User ;\
	cat .vscode/extensions.json |\
		jq -r '.recommendations | .[]' |\
		xargs -L 1 code --install-extension \
			> $(TMP_FOLDER)/last_code

$(SYSTEM_SSH_PEM): $(SYSTEM_SSH_FOLDER)
	read -p "Enter your email address: " email ;\
	\
	ssh-keygen -t rsa -b 4096 -C $$email ;\
	cp $(SSH_TEMPLATE) $(SYSTEM_SSH_CONFIG) ;\
	ssh-add -K $(SYSTEM_SSH_PEM) ;\
	\
	cat $(SYSTEM_SSH_PEM).pub ;\
	open https://github.com/settings/keys ;\
	read -p "Please add your public key to github."

# -- folders --

$(TMP_FOLDER):
	mkdir -p $(TMP_FOLDER)

$(SYSTEM_SSH_FOLDER):
	mkdir -p $(SYSTEM_SSH_FOLDER)

$(LICENSE_FOLDER):
	open $(LICENSE_ZIP) ;\
	read -p "Unarchive all necessary licenses..."

$(LICENSE_ZIP):
	zip -uer $(LICENSE_ZIP) $(LIBRARY_FOLDER)

$(HOMEBREW):
	$(SHELL) -c "$$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
