#!/bin/sh

[ -x "$(which ttyd)" ] || {
  echo "Installing ttyd..."
  sudo curl -skL -o "/usr/sbin/ttyd" https://github.com/tsl0922/ttyd/releases/download/1.7.4/ttyd.x86_64
  sudo chmod +x /usr/sbin/ttyd
}

[ -x "$(which ngrok)" ] || {
  echo "Installing ngrok..."
  sudo curl -skL -o /tmp/ngrok.tgz https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
  sudo tar -xf /tmp/ngrok.tgz -C /usr/sbin
  sudo chmod +x /usr/sbin/ngrok
}

[ -x "$(which ttyd)" -a -x "$(which ngrok)" ] || exit 1

[ -z "${NGROK_AUTHTOKEN}" ] && {
  echo "Please set secrets.NGROK_AUTHTOKEN in repo settings"
  exit 1
}

[ -z "${1}" ] && {
  echo "Please provide a command to run"
  exit 1
}

ttyd -W -p 7681 sh -c "${1}; killall ngrok" &
(sleep ${2:-3600} && killall ngrok) &
ngrok http 7681 --authtoken $NGROK_AUTHTOKEN --log=stdout 2>&1 || exit 0 && exit 0

exit 0
