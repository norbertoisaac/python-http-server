#! /bin/sh
# Script para iniciar y parar el servicio HTTP
logDir=/var/log/httpd.py.d
stdErr=${logDir}/error.log
stdOut=${logDir}/httpd.log
startFlag=${logDir}/run.flag

function start(){
  mkdir -p $logDir
  chmod 710 $logDir
  chown nobody:nogroup $logDir
  touch $startFlag
  while [[ -f $startFlag ]]; do
    /usr/sbin/runuser -u nobody -g nogroup -- /usr/bin/python3 httpd.py >${stdOut} 2>${stdErr}
    /usr/bin/sleep 1
  done
}

function stop(){
  rm -f $startFlag
}

if [[ $1 == 'start' ]]; then
  start
elif [[ $ == 'stop' ]]; then
  stop
fi
