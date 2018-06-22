export DEBIAN_FRONTEND=noninteractive
dpkg --configure -a
apt-get update
apt-get install -y gnome-session gdm3
service gdm3 start
