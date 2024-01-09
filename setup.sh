#!/bin/sh

#                    _           _        _ _ 
#  ___  _____  __   (_)_ __  ___| |_ __ _| | |
# / _ \/ __\ \/ /   | | '_ \/ __| __/ _` | | |
#| (_) \__ \>  <    | | | | \__ \ || (_| | | |
# \___/|___/_/\_\   |_|_| |_|___/\__\__,_|_|_|

# Some configs reused from:
# https://github.com/ruyadorno/installme-osx/
# https://gist.github.com/millermedeiros/6615994
# https://gist.github.com/brandonb927/3195465/
# https://github.com/nnja/new-computer/blob/master/setup.sh

# Colorize

# Set the colours you can use
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

# Resets the style
reset=`tput sgr0`

# Color-echo. Improved. [Thanks @joaocunha]
# arg $1 = message
# arg $2 = Color
cecho() {
  echo "${2}${1}${reset}"
  return
}

echo ""
cecho "###############################################" $red
cecho "#        DO NOT RUN THIS SCRIPT BLINDLY       #" $red
cecho "#         YOU'LL PROBABLY REGRET IT...        #" $red
cecho "#                                             #" $red
cecho "#              READ IT THOROUGHLY             #" $red
cecho "#         AND EDIT TO SUIT YOUR NEEDS         #" $red
cecho "###############################################" $red
echo ""

# Set continue to false by default.
CONTINUE=false

echo ""
cecho "Have you read through the script you're about to run and " $red
cecho "understood that it will make changes to your computer? (y/n)" $red
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  cecho "Please go read the script, it only takes a few minutes" $red
  exit
fi

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##############################
# Prerequisite: Install Brew #
##############################

echo "Installing brew..."

if test ! $(which brew)
then
  ## Don't prompt for confirmation when installing homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
fi

# (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/ryota-vl/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)" 


# Latest brew, install brew cask
brew upgrade
brew update

##############################
# Install via Brew           #
##############################

echo "Starting brew app install..."

### Window Management
brew install --cask moom

### Developer Tools
brew install --cask iterm2
brew install --cask postman

### Development
brew install docker
brew install docker-compose
brew install minikube
brew install --cask orbstack
brew install --cask devpod

### Command line tools - install new ones, update others to latest version
brew install git  
brew install git-lfs # track large files in git https://github.com/git-lfs/git-lfs
brew install wget
brew install zsh # zshell
brew install tmux
brew install tree
brew link curl --force
brew install grep --with-default-names
brew install trash  # move to osx trash instead of rm
brew install less
brew install jq

### Command 
brew install awscli
brew install terraform

### Python
brew install python

### node.js
brew install node

### Dev Editors 
brew install --cask pycharm
brew install --cask webstorm
brew install --cask goland
brew install --cask clion
brew install --cask rustrover
brew install --cask intellij-idea
brew install --cask visual-studio-code

## TODO LIST
brew install --cask todoist

### Writing
brew install --cask heptabase
brew install --cask typora
brew install --cask sublime-text

## Design
brew install --cask xmind

### Productivity
brew install --cask pushplaylabs-sidekick
brew install --cask alfred
brew install --cask keycastr  # show key presses on screen (for gifs & screencasts)
brew install --cask chai      # keep computer from sleeping
brew install --cask hookmark
brew install --cask dropover
# brew install --cask vimac   # change to another name
# brew install --cask paste
# brew install --cask rize
# brew install --cask kindle-classic

### Network
brew install --cask nordvpn
brew install --cask proxyman
brew install --cask openvpn-connect

### Translate
brew install --cask grammarly-desktop
# brew install --cask openai-translator

### Keyboard & Mouse
brew install --cask keyboard-maestro

### Chat / Video Conference
brew install --cask microsoft-teams
brew install --cask discord
brew install --cask skype
brew install --cask spotify
# brew install --cask iina
# brew install --cask infuse

### Photo


### Run Brew Cleanup
brew cleanup

#############################################
### Fonts
#############################################

echo "Installing fonts..."

brew tap homebrew/cask-fonts

### programming fonts
brew install font-monaspace
brew install font-fira-mono-for-powerline
brew install font-fira-code

### SourceCodePro + Powerline + Awesome Regular (for powerlevel 9k terminal icons)
cd ~/Library/Fonts && { curl -O 'https://github.com/Falkor/dotfiles/blob/master/fonts/SourceCodePro+Powerline+Awesome+Regular.ttf?raw=true' ; cd -; }

#############################################
### Installs from Mac App Store
#############################################

echo "Installing apps from the App Store..."

### find app ids with: mas search "app name"
brew install mas

### Mas login is currently broken on mojave. See:
### Login manually for now.

cecho "Need to log in to App Store manually to install apps with mas...." $red
echo "Opening App Store. Please login."
open "/Applications/App Store.app"
echo "Is app store login complete.(y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ]
then
	mas install 539883307  # LINE
 	mas install 803453959  # SLACK
        mas install 1352778147 # Bitwarden
        mas install 823766827  # Microsoft OneDrive
        mas install 462062816  # Microsoft PowerPoint
        mas install 462058435  # Microsoft Excel
        mas install 462054704  # Microsoft Word
	mas install 1355679052 # Dropover - Easier Drag & Drop
else
	cecho "App Store login not complete. Skipping installing App Store Apps" $red
fi

#############################################
### Install few global python packages
#############################################

echo "Installing global Python packages..."

pip3 install --upgrade pip
pip3 install --user pylint
pip3 install --user flake8

#############################################
### Set OSX Preferences - Borrowed from https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#############################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

##################
### Finder, Dock, & Menu Items
##################

# Pycharm Plugins: Vim
defaults write -g ApplePressAndHoldEnabled 0

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Only Show Open Applications In The Dock  
defaults write com.apple.dock static-only -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Don’t show recent applications in Dock
#    defaults write com.apple.dock show-recents -bool false

# Menu bar: hide the Time Machine, User icons, but show the volume Icon.
for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
	defaults write "${domain}" dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Volume.menu" \
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
	"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
	"/System/Library/CoreServices/Menu Extras/Battery.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"

##################
### Text Editing / Keyboards
##################

# Disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Use function F1, F, etc keys as standard function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true


###############################################################################
# Screenshots / Screen                                                        #
###############################################################################

# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Address Book, Dashboard, iCal, TextEdit, and Disk Utility                   #
###############################################################################

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

###############################################################################
# Spotlight                                                                   #
###############################################################################

# Hide Spotlight tray-icon (and subsequent helper)
#sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
# Load new settings before rebuilding the index
killall mds

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Disable “natural” (Lion-style) scrolling
# Uncomment if you don't use scroll reverser
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable force click and haptic feedback
defaults write ~/Library/Preferences/com.apple.AppleMultitouchTrackpad.plist ForceSuppressed -bool true

# Mouse settings
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseOneFingerDoubleTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseTwoFingerDoubleTapGesture -int 3
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse.plist MouseTwoFingerHorizSwipeGesture -int 2
defaults write ~/Library/Preferences/.GlobalPreferences.plist com.apple.mouse.scaling -float 3
defaults write ~/Library/Preferences/.GlobalPreferences.plist com.apple.swipescrolldirection -boolean YES

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

#############################################
### Generate ssh keys & add to ssh-agent
### See: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
#############################################


#############################################
# Check Updates, Install 
#############################################
echo ""
cecho "Done!" $cyan
echo ""
echo ""
cecho "################################################################################" $white
echo ""
echo ""
cecho "Note that some of these changes require a logout/restart to take effect." $red
echo ""
echo ""
echo -n "Check for and install available OSX updates, install, and automatically restart? (y/n)? "
read response
if [ "$response" != "${response#[Yy]}" ] ;then
    sudo softwareupdate -i -a --restart
fi
