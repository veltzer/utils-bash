#!/bin/bash -e
# ls -d py* | wc -l
pycmdtools mcmp --print "MANIFEST.in" py*/MANIFEST.in
pycmdtools mcmp --print "setup.cfg" py*/setup.cfg
pycmdtools mcmp --print ".myenv" py*/.myenv
pycmdtools mcmp --print "Makefile" py*/Makefile
pycmdtools mcmp --print ".pylintrc" py*/.pylintrc
pycmdtools mcmp --print ".myenv" py*/.myenv
pycmdtools mcmp --print ".flake8" py*/.flake8
pycmdtools mcmp --print ".gitignore" py*/.gitignore
pycmdtools mcmp --print "packages.txt" py*/packages.txt
# templates
pycmdtools mcmp --print "templates/LICENSE.mako" py*/templates/LICENSE.mako
pycmdtools mcmp --print "templates/requirements.txt.mako" py*/templates/requirements.txt.mako
pycmdtools mcmp --print "templates/setup.py.mako" py*/templates/setup.py.mako
pycmdtools mcmp --print "templates/README.rst.mako" py*/templates/README.rst.mako
pycmdtools mcmp --print "templates/README.md.mako" py*/templates/README.md.mako
pycmdtools mcmp --print "templates/[pkg]/static.py.mako" py*/templates/*/static.py.mako
pycmdtools mcmp --print "templates/.github/workflows/build.yml.mako" py*/templates/.github/workflows/build.yml.mako
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
pycmdtools mcmp --print ".github/workflows/build.yml" py*/.github/workflows/build.yml
