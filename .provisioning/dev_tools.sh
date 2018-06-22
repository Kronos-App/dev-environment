#!/usr/bin/env bash

# disable gnome-initial-setup welcome screens
VCONF=$VHOME/.config
mkdir -p $VCONF && chown vagrant:vagrant $VCONF
echo "yes" > $VCONF/gnome-initial-setup-done

# set en_US locale (defaults to en_UK) and US keymaps
localectl set-locale LANG=en_US.UTF-8
localectl set-keymap us

# configure project ssh key
PRIVKEY=$VHOME/.ssh/id_rsa
chmod 600 $PRIVKEY
chown vagrant:vagrant $PRIVKEY

# configure git
cat << EOM > $VHOME/.gitconfig
[user]
name = "$GIT_NAME"
email = "$GIT_EMAIL"
EOM

# ensure installation is up to date
apt-get update
apt-get upgrade
apt-get dist-upgrade

# install essentials
apt-get install -y vim curl build-essential gnome-terminal gnome-tweak-tool
apt-get remove -y --auto-remove byobu

# install nautilus
apt-get install -y python3 python3-pip ninja-build
pip3 install --user meson
cd $VHOME
echo PATH=$VHOME/.local/bin:$PATH >> .bashrc
source .bashrc
apt-get install -y libgtk-3-dev libgail-3-dev libgexiv2-dev libgnome-autoar-0-dev libgnome-desktop-3-dev libtracker-sparql-2.0-dev libxml++2.6-dev libgirepository1.0-dev libseccomp-dev appstream-util
cd $VHOME/Downloads
git clone https://gitlab.gnome.org/GNOME/nautilus.git
cd nautilus/
$VHOME/.local/bin/meson build
cd build
ninja
ninja install

# install chromium
apt-get install -y chromium-browser

# install chrome
sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
apt-get update
apt-get install -y google-chrome-stable

# install node, yarn
apt-get install -y nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update
apt-get install -y yarn

# install vscode
apt-get install -y libgtk2.0-0
curl -o code.deb -L http://go.microsoft.com/fwlink/?LinkID=760868
dpkg -i code.deb
apt-get -f install -y
VSC_EXT_DIR=~/.vscode/extensions
mkdir -p $VSC_EXT_DIR
code --user-data-dir=$VSC_CONF_DIR \
    --extensions-dir=$VSC_EXT_DIR \
    --install-extension=dbaeumer.vscode-eslint \
    --install-extension=esbenp.prettier-vscode \
    --install-extension=jakob101.relativepath
rm code.deb

# cleanup
apt-get autoclean
apt-get clean
apt-get autoremove
