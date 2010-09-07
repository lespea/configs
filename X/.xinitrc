#!/bin/sh

if [ -e /usr/bin/VBoxClient-all ];then
    /usr/bin/VBoxClient-all &
fi

xcompmgr &

exec awesome
