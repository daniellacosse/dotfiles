SHELL:=/bin/bash
NODE:=$(if $(shell which node),$(shell which node),nonode)

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

default: $(TMP_FILES) $(SYSTEM_SSH_PEM) $(LICENSE_FOLDER)
	read -p "1/11) set default browser" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Appearance.prefPane/ ;\
	\
	read -p "2/11) set date and time preferences" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/DateAndTime.prefPane/ ;\
	\
	read -p "3/11) arrange windows & click-drag the little white bar over to the main display" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Displays.prefPane/ ;\
	\
	read -p "4/11) select the photos album -Wallpapers- as the Desktop" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/DesktopScreenEffectsPref.prefPane/ ;\
	\
	read -p "5/11 setup touchbar, then turn off function key shortcuts in the Shortcuts tab." ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Keyboard.prefPane/ ;\
	\
	read -p "6/11) connect bluetooth keyboard and trackpad" ;\
	open $(SYSTEM_PREFERENCE_PANES_FOLDER)/Bluetooth.prefPane/ ;\
	\
	read -p "7/11) open and setup all background apps" ;\
	cat $(BACKGROUND_APPLICATIONS_LIST) | xargs -L 1 open ;\
	\
	read -p "8/11) add ssh key to github" ;\
	make $(SYSTEM_SSH_PEM)
	\
	read -p "9/11) add license key && macros" ;\
	make $(LICENSE_FOLDER) ;\
	cp $(DASH_LICENSE) $(SYSTEM_APPS_CONFIG)/Dash/License/license.dash-license ;\
	cat $(MAESTRO_LICENSE) && make $(MACROS) ;\
	\
	read -p "10/11) setup nvidia eGPU" ;\
	bash <(curl -s https://raw.githubusercontent.com/learex/macOS-eGPU/master/macOS-eGPU.sh) --beta --nvidiaDriver 387.10.10.10.40.113 --iopcieTunneledPatch ;\
	\
	read -p "11/11) data transfer from previous mac - use spotlight to open 'migration assistant'"
	# \ 
	# read -p "7/7) select backup disk" ;\
	# open $(SYSTEM_PREFERENCE_PANES_FOLDER)/TimeMachine.prefPane/ ;\

update: $(TMP_FILES) $(MACROS)

# -- cache --
$(TMP_FOLDER):
	mkdir -p $(TMP_FOLDER)

$(TMP_FOLDER)/last_brew: $(TMP_FOLDER) Brewfile
	brew bundle \
		> $(TMP_FOLDER)/last_brew 2>&1

$(TMP_FOLDER)/last_bash: $(TMP_FOLDER) $(NODE)
	chmod -R u+x $(BASH_SCRIPTS) 								         > $(TMP_FOLDER)/last_bash 2>&1 ;\
	cp -R $(BASH_SCRIPTS)/. $(HOME_FOLDER)/.bash_scripts >> $(TMP_FOLDER)/last_bash 2>&1  ;\
	\
	cp $(BASH_AUTOCOMPLETION) $(HOME_FOLDER)/.$(BASH_AUTOCOMPLETION) >> $(TMP_FOLDER)/last_bash 2>&1 ;\
	\
	cp $(BASH_PROFILE) $(HOME_FOLDER)/.bash_profile			>> $(TMP_FOLDER)/last_bash 2>&1  ;\
	source $(HOME_FOLDER)/.bash_profile									>> $(TMP_FOLDER)/last_bash 2>&1

$(TMP_FOLDER)/last_yarn: $(TMP_FOLDER) package.json
	cat package.json |\
		jq -r '.dependencies | keys | .[]' |\
		xargs -L 1 yarn global add \
			> $(TMP_FOLDER)/last_yarn 2>&1

$(TMP_FOLDER)/last_code: $(TMP_FOLDER) $(TMP_FOLDER)/last_brew $(VSCODE_FILES)
	sudo cp -fa .vscode/. $(SYSTEM_APPS_CONFIG)/Code/User ;\
	cat .vscode/extensions.json |\
		jq -r '.recommendations | .[]' |\
		xargs -L 1 code --install-extension \
			> $(TMP_FOLDER)/last_code 2>&1

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

$(SYSTEM_SSH_FOLDER):
	mkdir -p $(SYSTEM_SSH_FOLDER)

$(LICENSE_FOLDER):
	open $(LICENSE_ZIP) ;\
	read -p "Unarchive all necessary licenses..."

$(MACROS):
	open $(MACROS)

$(NODE):
	export NVM_DIR=~/.nvm ;\
	source $(brew --prefix nvm)/nvm.sh ;\
	nvm install $(cat package.json | jq -r '.engines.node')
