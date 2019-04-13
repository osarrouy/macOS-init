#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\

# Sources :
# https://github.com/nicolinuxfr/macOS-post-installation
# https://www.macg.co/logiciels/2017/02/comment-synchroniser-les-preferences-des-apps-avec-mackup-97442
# https://github.com/OzzyCzech/dotfiles/blob/master/.osx

# Demande du mot de passe administrateur dès le départ
sudo -v

# Keep-alive: met à jour le timestamp de `sudo`
# tant que `post-install.sh` n'est pas terminé
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## LA BASE : Homebrew et les lignes de commande
if test ! $(which brew)
then
  echo "Installation de Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Ajout des binaires Homebrew au PATH
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.zshrc

# Mettre à jour la liste des applications disponibles
brew update

# Installer les nouvelles applications du bundle Brewfile
# et mettre à jour celles déjà présentes
brew bundle

# Installer SF-Mono
echo 'Installation de SF-Mono'
cd /Applications/Utilities/Terminal.app/Contents/Resources/Fonts/ && cp *.otf ~/Library/Fonts/ && cd

echo "Installation des outils de développement Ruby"
# Mise à jour de RubyGems
sudo gem update --system --silent
# Installation de Bundler
sudo gem install bundler -n /usr/local/bin

echo "Installation des outils de développement Node"
# Installation de composants Node
npm install -g npm-check-updates

echo "Installation d'applications Node"

## ************************* CONFIGURATION ********************************
echo "Configuration de quelques paramètres par défaut"

# Fermer les fenêtres "Préférences Système"
osascript -e 'tell application "System Preferences" to quit'

## FINDER

# Affichage de la bibliothèque
# chflags nohidden ~/Library

# Affichage de la barre latérale
defaults write com.apple.finder ShowStatusBar -bool true

# Afficher par défaut en mode colonne
# Flwv ▸ Cover Flow View
# Nlsv ▸ List View
# clmv ▸ Column View
# icnv ▸ Icon View
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Afficher le chemin d'accès
defaults write com.apple.finder ShowPathbar -bool true

# Afficher toutes les extensions
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Afficher le dossier maison par défaut
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Supprimer les doublons dans le menu "ouvrir avec…"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Rechercher dans le dossier en cours par défaut
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Fenêtre de sauvegarde complète par défaut
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Fenêtre d'impression complète par défaut
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Sauvegarde sur disque (et non sur iCloud) par défaut
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Coup d'œil : sélection de texte
defaults write com.apple.finder QLEnableTextSelection -bool true

# Ne pas alerter en cas de modification de l'extension d'un fichier
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Pas de création de fichiers .DS_STORE sur les disques réseau et externes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Supprimer l'alerte de quarantaine des applications
defaults write com.apple.LaunchServices LSQuarantine -bool false

## DOCK

# Taille minimum
defaults write com.apple.dock tilesize -int 64

# Agrandissement actif
defaults write com.apple.dock magnification -bool true

# Taille maximale pour l'agrandissement
defaults write com.apple.dock largesize -float 96

## MISSION CONTROL

# Pas d'organisation des bureaux en fonction des apps ouvertes
defaults write com.apple.dock mru-spaces -bool false

# Mot de passe demandé immédiatement quand l'économiseur d'écran s'active
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

## CLAVIER ET TRACKPAD

## Activer Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

## echo " Trackpad: map bottom right corner to right-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Accès au clavier complet (tabulation dans les boîtes de dialogue)
sudo defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Arrêt pop-up clavier façon iOS
sudo defaults write -g ApplePressAndHoldEnabled -bool false

# Répétition touches plus rapide
sudo defaults write NSGlobalDomain KeyRepeat -int 1
# Délai avant répétition des touches
sudo defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Trackpad : toucher pour cliquer
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Souris : glisser une fenêtre de n'importe où avec ^ + Cmd
defaults write -g NSWindowShouldDragOnGesture -bool true

## APPS

# Vérifier la disponibilité de mise à jour quotidiennement
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Vérifier les mises à jour automatiquement
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Photos : pas d'affichage pour les iPhone
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# TextEdit : .txt par défaut
defaults write com.apple.TextEdit RichText -int 0

# TextEdit : ouvre et enregistre les fichiers en UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


## SONS

# Démarrer en silence
sudo nvram SystemAudioVolume="%00"

# Alertes sonores quand on modifie le volume
sudo defaults write com.apple.systemsound com.apple.sound.beep.volume -float 1

## IMAGES

# Enregistrer les screenshots en PNG (autres options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Mettre une ombre sur les screenshots
defaults write com.apple.screencapture disable-shadow -bool false

## ************ Fin de l'installation *********
echo "Finder et Dock relancés… redémarrage nécessaire pour terminer."
killall Dock
killall Finder

echo "Derniers nettoyages…"
brew cleanup
rm -f -r /Library/Caches/Homebrew/*

echo ""
echo "ET VOILÀ !"
echo "Après synchronisation des données Dropbox (seuls les dossiers « Mackup » et « Settings » sont nécessaires dans un premier temps), lancer le script post-cloud.sh"
