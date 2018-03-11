#!/bin/sh

#  Checkout repo
git clone --bare https://github.com/greg1988/dev-env.git $HOME/.cfg
# Setup alias for this script to use
config() {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

# Prepare backup in case there is existing config
mkdir -p .config-backup

# Checkout to root
config checkout

if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;

# Run second checkout in case we had to backup
config checkout

# Don't show untracked files
config config status.showUntrackedFiles no