export DEBIAN_FRONTEND=noninteractive
dpkg --configure -a
apt-get install tasksel -y
tasksel install ubuntu-desktop
service gdm3 start
