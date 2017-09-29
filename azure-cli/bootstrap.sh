cd /tmp
wget http://www.ivarch.com/programs/sources/pv-1.6.6.tar.gz
tar xfvz pv-1.6.6.tar.gz
cd pv-1.6.6
sh ./configure
make
make install
apk update
apk add ncurses util-linux git
cd /root
git clone https://github.com/derdanu/architects-forum.git
echo "echo \"Please authenticate first with az login\""  > /root/.bashrc
