SHELL:=/bin/bash

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
BASH_AUTOCOMPLETION=$(BASH_FOLDER)/git-autocompletion.bash
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
	read -p "1/14) set colors & default browser" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Appearance.prefPane/ ;\
	\
	read -p "2/14) set accessibility preferences" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/UniversalAccessPref.prefPane/ ;\
	\
	read -p "3/14) set date and time preferences" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/DateAndTime.prefPane/ ;\
	\
	read -p "4/14) set login options - turn off guest account" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Account.prefPane/ ;\
	\
	read -p "5/14) set login options - security settings" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Security.prefPane/ ;\
	\
	read -p "6/14) arrange windows & click-drag the little white bar over to the main display" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Displays.prefPane/ ;\
	\
	read -p "7/14) wire photos to iCloud" ;\
	open /Applications/Photos.app/ ;\
	\
	read -p "8/14) select the photos album -Wallpapers- as the Desktop" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/DesktopScreenEffectsPref.prefPane/ ;\
	\
	read -p "9/14 setup touchbar, then turn off function key shortcuts in the Shortcuts tab." ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Keyboard.prefPane/ ;\
	\
	read -p "10/14) connect bluetooth keyboard and trackpad" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Bluetooth.prefPane/ ;\
	\
	read -p "11/14) open and setup all background apps" ;\
	cat $(BACKGROUND_APPLICATIONS_LIST) | xargs -L 1 open ;\
	\
	read -p "12/14) create and add ssh key to github" ;\
	make $(SYSTEM_SSH_PEM)
	\
	read -p "13/14) add license key && macros" ;\
	cat $(MAESTRO_LICENSE) ;\
	open /Application/Dash.app/ ;\
	open $(MACROS) ;\
	\
	read -p "14/14) setup nvidia eGPU. make sure it's not plugged in now - hot-plug it in after startup but before login" ;\
	bash <(curl -s https://raw.githubusercontent.com/learex/macOS-eGPU/master/macOS-eGPU.sh)

update: $(TMP_FOLDER)
	make $(TMP_FOLDER)/update

$(TMP_FOLDER)/update: $(TMP_FILES)

# -- cache --

$(TMP_FOLDER)/last_brew: Brewfile
	brew bundle --force \
		> $(TMP_FOLDER)/last_brew

Brewfile: # track

$(TMP_FOLDER)/last_bash: $(BASH_PROFILE) $(BASH_SCRIPTS)
	chmod -R u+x $(BASH_SCRIPTS)													> $(TMP_FOLDER)/last_bash 2>&1 ;\
	cp -R $(BASH_SCRIPTS)/. $(HOME_FOLDER)/.bash_scripts 	>> $(TMP_FOLDER)/last_bash ;\
	\
	cp $(BASH_AUTOCOMPLETION) $(HOME_FOLDER)/.$(BASH_AUTOCOMPLETION) >> $(TMP_FOLDER)/last_bash ;\
	\
	cp $(BASH_PROFILE) $(HOME_FOLDER)/.bash_profile					>> $(TMP_FOLDER)/last_bash ;\
	source $(HOME_FOLDER)/.bash_profile											>> $(TMP_FOLDER)/last_bash 2>&1 ;\
	nvm install $(cat package.json | jq -r '.engines.node') >> $(TMP_FOLDER)/last_bash

$(BASH_PROFILE):
$(BASH_SCRIPTS): # track

$(TMP_FOLDER)/last_yarn: package.json
	cat package.json |\
		jq -r '.dependencies | keys | .[]' |\
		xargs -L 1 yarn global add \
			> $(TMP_FOLDER)/last_yarn

package.json: # track

$(TMP_FOLDER)/last_code: $(TMP_FOLDER)/last_brew .vscode/extensions.json
	sudo cp -fa .vscode/. $(SYSTEM_APPS_CONFIG)/Code/User ;\
	cat .vscode/extensions.json |\
		jq -r '.recommendations | .[]' |\
		xargs -L 1 code --install-extension \
			> $(TMP_FOLDER)/last_code

.vscode/extensions.json: # track

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
