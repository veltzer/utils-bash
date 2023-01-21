#!/bin/bash -e

# lets print all the options that we have for browsers...
# locate .desktop | grep -E "/mozilla-firefox.desktop|/firefox.desktop|/google-chrome.desktop|/org.kde.konqueror.desktop" -

browser_wanted="firefox.desktop"
current=$(xdg-settings get default-web-browser)
if [ "${current}" != "${browser_wanted}" ]
then
	echo "your current browser is [${current}], we will change it to ${browser_wanted}..."
	xdg-settings set default-web-browser "${browser_wanted}"
	current=$(xdg-settings get default-web-browser)
	echo "your current browser is now [${current}]..."
else
	echo "your current browser is [${current}], that's good..."
fi

current=$(xdg-mime query default text/html)
if [ "${current}" != "${browser_wanted}" ]
then
	echo "your current text/html handler is [${current}], we will change it to ${browser_wanted}..."
	xdg-mime default "${browser_wanted}" text/html
	current=$(xdg-mime query default text/html)
	echo "your current text/html handler is now [${current}]..."
else
	echo "your current text/html handler is [${current}], that's good..."
fi

current=$(grep "BrowserApplication" ~/.config/kdeglobals | cut -f 2 -d =)
if [ "${current}" != "${browser_wanted}" ]
then
	echo "your current kde browser is [${current}], we will change it to ${browser_wanted}..."
	kwriteconfig5 --file ~/.config/kdeglobals --group General --key BrowserApplication "${browser_wanted}"
	current=$(grep "BrowserApplication" ~/.config/kdeglobals | cut -f 2 -d =)
	echo "your current kde browser is now [${current}]..."
else
	echo "your current kde browser is [${current}], that's good..."
fi

