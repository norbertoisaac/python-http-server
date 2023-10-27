#! /bin/sh
# Script para iniciar y parar el servicio HTTP
logDir=/var/log/httpd.py.d
stdErr=${logDir}/error.log
stdOut=${logDir}/httpd.log
startFlag=${logDir}/run.flag
httpdPidF=${logDir}/httpd.py.pid

start() {
  mkdir -p $logDir
  chmod 710 $logDir
  chown nobody:nogroup $logDir
  touch $startFlag
  touch $httpdPidF
  chown nobody:nogroup $httpdPidF
  chown nobody:nogroup $stdOut
  chown nobody:nogroup $stdErr
  while [ -f $startFlag ]; do
    /usr/sbin/runuser -u nobody -g nogroup -P -- /usr/bin/python3 httpd.py --pid $httpdPidF >>${stdOut} 2>>${stdErr}
    /usr/bin/date >>${stdErr} 
    /usr/bin/sleep 1
  done
}

stop() {
  rm -f $startFlag
  /usr/bin/kill -15 $(cat $httpdPidF)
}

if [ $1 = 'start' ]; then
  start
elif [ $1 = 'stop' ]; then
  stop
fi

