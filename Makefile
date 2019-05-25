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

LICENSE_ZIP=$(ASSETS_FOLDER)/licenses.zip
LICENSE_FOLDER=$(ASSETS_FOLDER)/licenses
DASH_LICENSE=$(LICENSE_FOLDER)/license.dash-license
MAESTRO_LICENSE=$(LICENSE_FOLDER)/license.keyboard-maestro

MACROS=$(ASSETS_FOLDER)/macros.kmmacros

BASH_PROFILE=$(BASH_FOLDER)/profile
BASH_SCRIPTS=$(BASH_FOLDER)/scripts

BASH_PROFILE_DEST=$(HOME_FOLDER)/.bash_profile
BASH_SCRIPTS_DEST=$(HOME_FOLDER)/.bash_scripts

SSH_TEMPLATE=$(ASSETS_FOLDER)/ssh-config.template

SSH_FOLDER=$(HOME_FOLDER)/.ssh
SSH_PEM=$(SSH_FOLDER)/id_rsa
SSH_CONFIG=$(SSH_FOLDER)/config

SYSTEM_APPS_CONFIG=$(HOME_FOLDER)/Library/Application\ Support
PREFERENCE_PANES_FOLDER=/System/Library/PreferencePanes
BACKGROUND_APPLICATIONS_LIST=$(ASSETS_FOLDER)/background-applications.list

# -- commands --
.PHONY: default update

# TODO: unpack encrypted keyboard maestro license
default: $(TMP_FILES) $(SSH_PEM) $(LICENSES)
	cp $(DASH_LICENSE) $(SYSTEM_APPS_CONFIG)/Dash/License/license.dash-license ;\
 	\
	read -p "1/7) set dark mode & default browser" ;\
	open $(PREFERENCE_PANES_FOLDER)/Appearance.prefPane/ ;\
	\
	read -p "2/7) arrange windows & click-drag the little white bar over to the main display" ;\
	open $(PREFERENCE_PANES_FOLDER)/Appearance.prefPane/ ;\
	\
	read -p "3/7) select the photos album `Wallpapers` as the Desktop" ;\
	open $(PREFERENCE_PANES_FOLDER)/DesktopScreenEffectsPref.prefPane/ ;\
	\
	read -p "4/7) select `Use F1, F2, etc. keys as standard function keys`, then turn off `Display` and `Mission Control` in the Shortcuts tab." ;\
	open $(PREFERENCE_PANES_FOLDER)/Keyboard.prefPane/ ;\
	\
	read -p "5/7) open and setup all background apps" ;\
	cat $(BACKGROUND_APPLICATIONS_LIST) | xargs -L 1 open ;\
	\
	read -p "6/7) add license key && macros to keyboard maestro" ;\
	cat $(MAESTRO_LICENSE) && make $(MACROS)
	\ 
	read -p "7/7) select backup disk" ;\
	open $(PREFERENCE_PANES_FOLDER)/TimeMachine.prefPane/ ;\

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
	cp $(SSH_TEMPLATE) $(SSH_CONFIG) ;\
	ssh-add -K $(SSH_PEM) ;\
	\
	echo $(SSH_PEM).pub ;\
	read -p "Please add your public key to github." ;\
	open https://github.com/settings/keys

$(LICENSES):
	open $(LICENSE_ZIP) ;\
	read -p "Unarchive all necessary licenses..."

$(MACROS):
	open $(MACROS)

$(NODE): $(TMP_FOLDER)/last_brew
	cat package.json |\
		jq -r '.engines.node' |\
			nvm install
