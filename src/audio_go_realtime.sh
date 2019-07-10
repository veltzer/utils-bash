#!/bin/bash

<<'COMMENT'

script to turn off all unneccessary things for you.
this script kills anything that may get in the way of a good recording session:
browsers, skype and more

TODO:
- record which services out of the ones we are shutting down were up and have a feature
to reload them once we are done with recording.

COMMENT

sudo /etc/init.d/apache2 stop
sudo /etc/init.d/postfix stop
#sudo /etc/init.d/atop stop
sudo /etc/init.d/timidity stop
sudo /etc/init.d/avahi-daemon stop
sudo /etc/init.d/ssh stop
#sudo /etc/init.d/mysql stop
#sudo /etc/init.d/couchdb stop
#sudo /etc/init.d/winbind stop
#sudo /etc/init.d/ntp stop
# sv processes
#sudo sv stop git-daemon
# upstart jobs
sudo stop mysql
# desktop stuff
dropbox stop
killall chromium-browser evolution pidgin chrome
# replace compiz window manager with fast window manager
#metacity --replace &
