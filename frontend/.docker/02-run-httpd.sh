#!/bin/sh

busybox httpd -f -v -h /home/static -c /home/static/httpd.conf -p 80
