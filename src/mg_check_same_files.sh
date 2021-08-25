#!/bin/bash -e
# ls -d py* | wc -l
pycmdtools mcmp py*/MANIFEST.in
pycmdtools mcmp py*/setup.cfg
pycmdtools mcmp py*/.myenv
pycmdtools mcmp py*/Makefile
pycmdtools mcmp py*/.pylintrc
pycmdtools mcmp py*/.myenv
pycmdtools mcmp py*/.flake8
pycmdtools mcmp py*/templates/LICENSE
pycmdtools mcmp py*/templates/requirements.txt.mako
pycmdtools mcmp py*/templates/setup.py.mako
pycmdtools mcmp py*/templates/README.rst.mako
pycmdtools mcmp py*/templates/README.md.mako
pycmdtools mcmp py*/templates/*/static.py.mako
pycmdtools mcmp py*/templates/.github/workflows/build.yml.mako
pycmdtools mcmp py*/config/apt.py
pycmdtools mcmp py*/config/composites.py
pycmdtools mcmp py*/config/deb.py
pycmdtools mcmp py*/config/general.py
pycmdtools mcmp py*/config/git.py
pycmdtools mcmp py*/config/__init__.py
pycmdtools mcmp py*/config/messages.py
# still doesnt work
# pycmdtools mcmp py*/.idea/.gitignore
# pycmdtools mcmp py*/.github/workflows/build.yml
