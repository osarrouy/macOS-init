#!/bin/sh

# Restore preferences
echo "Restoring preferences"
echo -e "[storage]\nengine = icloud" >> ~/.mackup.cfg
mackup restore -n

# Install oh-my-zsh
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
source ~/.zshrc

# End
echo "Post-sync installs over"
