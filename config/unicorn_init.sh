#!/bin/sh
### BEGIN INIT INFO
# Provides:          Unicorn
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Init script for unicorn instace
### END INIT INFO
set -e

TIMEOUT=${TIMEOUT-60}
APP_ROOT=/app/depot
APP_CURRENT=$APP_ROOT/current
APP_USER=app
PID=$APP_ROOT/shared/unicorn.pid
#PID=$APP_CURRENT/tmp/pids/unicorn.pid
ENV=production
CMD="cd $APP_CURRENT && /home/app/.rbenv/shims/bundle exec unicorn_rails -E $ENV -D -c $APP_CURRENT/config/unicorn.rb"
action="$1"
set -u

old_pid="$PID.oldbin"

cd $APP_CURRENT || exit 1

sig () {
        test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
        test -s $old_pid && kill -$1 `cat $old_pid`
}

case $action in
start)
        sig 0 && echo >&2 "Already running" && exit 0
        pwd
        su --login $APP_USER -c "$CMD"
        ;;
stop)
        sig QUIT && exit 0
        echo >&2 "Not running"
        ;;
force-stop)
        sig TERM && exit 0

        echo >&2 "Not running"
        ;;
restart|reload)
        sig HUP && echo reloaded OK && exit 0
        echo >&2 "Couldn't reload, starting '$CMD' instead"
        su --login $APP_USER -c "$CMD"
        ;;

upgrade)
        if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
        then
                n=$TIMEOUT
                while test -s $old_pid && test $n -ge 0
                do
                        printf '.' && sleep 1 && n=$(( $n - 1 ))
                done
                echo

                if test $n -lt 0 && test -s $old_pid
                then
                        echo >&2 "$old_pid still exists after $TIMEOUT seconds"
                        exit 1
                fi
                exit 0
        fi
        echo >&2 "Couldn't upgrade, starting '$CMD' instead"
        su --login $APP_USER -c "$CMD"
        ;;
reopen-logs)
        sig USR1
        ;;
*)
        echo >&2 "Usage: $0 "
        exit 1
        ;;
esac
