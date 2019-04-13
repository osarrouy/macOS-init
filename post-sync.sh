#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\

echo "Restauration des préférences"
# Sélection du service de cloud (à décommenter si vous n'utilisez pas Dropbox, c'est le service par défaut) : https://github.com/lra/mackup/blob/master/doc/README.md
echo -e "[storage]\nengine = icloud" >> ~/.mackup.cfg

# Récupération de la sauvegarde sans demander à chaque fois l'autorisation
mackup restore -n

echo "Installation de oh-my-zsh"
# Installation de oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo ""
echo "ET VOILÀ !"
echo "Il est maintenant possible d'activer d'autres dossiers dans la synchronisation Dropbox."
