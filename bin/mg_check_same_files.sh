#!/bin/bash -e
# ls -d py* | wc -l
pycmdtools mcmp --print "MANIFEST.in" py*/MANIFEST.in
pycmdtools mcmp --print "setup.cfg" py*/setup.cfg
pycmdtools mcmp --print "Makefile" py*/Makefile
pycmdtools mcmp --print ".pylintrc" ./*/.pylintrc
pycmdtools mcmp --print ".flake8" ./*/.flake8
pycmdtools mcmp --print ".gitignore" ./*/.gitignore
# templates
pycmdtools mcmp --print "templates/LICENSE.mako" py*/templates/LICENSE.mako
pycmdtools mcmp --print "templates/setup.py.mako" py*/templates/setup.py.mako
pycmdtools mcmp --print "templates/README.rst.mako" py*/templates/README.rst.mako
pycmdtools mcmp --print "templates/README.md.mako" py*/templates/README.md.mako
pycmdtools mcmp --print "templates/README.md.mako" [^py]*/templates/README.md.mako
pycmdtools mcmp --print "templates/[pkg]/static.py.mako" py*/templates/*/static.py.mako
pycmdtools mcmp --print "templates/.github/workflows/build.yml.mako" ./*/templates/.github/workflows/build.yml.mako
pycmdtools mcmp --print "templates/requirements.txt.mako" ./*/templates/requirements.txt.mako
# configs
pycmdtools mcmp --print "config/apt.py" py*/config/apt.py
pycmdtools mcmp --print "config/composites.py" py*/config/composites.py
pycmdtools mcmp --print "config/deb.py" py*/config/deb.py
pycmdtools mcmp --print "config/general.py" py*/config/general.py
pycmdtools mcmp --print "config/git.py" py*/config/git.py
pycmdtools mcmp --print "config/__init__.py" py*/config/__init__.py
pycmdtools mcmp --print "config/messages.py" py*/config/messages.py
pycmdtools mcmp --print "config/deps.py" py*/config/deps.py
# .idea stuff
pycmdtools mcmp --print ".idea/.gitignore" py*/.idea/.gitignore
# results of templates
pycmdtools mcmp --print ".github/workflows/build.yml" ./*/.github/workflows/build.yml
