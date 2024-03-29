
set -x

ver=2.18.1

url=https://github.com/docker/compose/releases/download/v$ver
dc=docker-compose-$(uname -s)-$(arch)
rm -rf $dc
wget -q $url/$dc
rc=$?
if [ "$rc" == "0" ]; then
  sudo mv $dc /usr/local/bin/docker-compose
else
  echo "ERROR: unable to download $url/$dc"
  exit 1
fi

sudo chmod +x /usr/local/bin/docker-compose

if [ ! -f /usr/bin/docker-compose ]; then
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

