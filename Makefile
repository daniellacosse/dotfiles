BREW_BUFFER = curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install

# TODO: http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/

setup:
	# xcode
	xcode-select --install

	# SSH key
	email=$(read -p "Enter your email address.")
	ssh-keygen -t rsa -b 4096 -C $(email)
	~/.ssh/config << cat >> EOF
		Host *
			AddKeysToAgent yes
			UseKeychain yes
			IdentityFile ~/.ssh/id_rsa
	EOF 
	ssh-add -K ~/.ssh/id_rsa

	echo ~/.ssh/id_rsa.pub
	read -p "Please add your public key to github."

	# brew
	/usr/bin/ruby -e "$(BREW_BUFFER)"
	brew bundle

	# node
	nvm install --lts
	yarn global add \
		typescript \
		ts-node \
		yo

	# shell scripts
	chmod -R u+x .scripts
	cp -rf .scripts ~/.scripts

	cp .profile ~/.profile
	source ~/.profile

	# dash license
	cp license.dash-license ~/Library/Application\ Support/Dash/License/license.dash-license

	# vscode
	cat .vscode/extension.list | xargs -L 1 echo code --install-extension
	cp .vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json

	# macros
	open "x-apple.systempreferences:com.apple.preference.keyboard?Keyboard"
	read -p "1) select `Use F1, F2, etc. keys as standard function keys`"

	open "x-apple.systempreferences:com.apple.preference.keyboard?Shortcuts"
	read -p "2) turn off `Display` and `Mission Control` function key shortcuts"

	open macros.kmmacros

	# boot camp
	read -p "Please insert a windows-bootable USB Drive."
	open /Applications/Utilities/Boot\ Camp\ Assistant.app
win-setup:
	# choco 
	Set-ExecutionPolicy AllSigned
	Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

	choco install Firefox Steam NordVPN 1Password RescueTime f.lux autohotkey Slack WhatsApp

	# swap command keys and invert scroll direction
	start macswaps.ahk

	Write-Host "Please import the inis from windows/wayneboard to setup the wayneboard"
	start macro-editor.exe
