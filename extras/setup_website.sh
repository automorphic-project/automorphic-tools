#! /bin/bash

# url of Stacks project website
LOCALHOST="http://localhost:8080"
# location automorphic-website directory relative to root webserver
# should start with a / if not empty
DIRECTORY=""
# absolute path to base directory to put website, tools, automorphic-history
CURRENT=$(pwd)
# website will be placed in CURRENT/STACKSWEB
STACKSWEB="automorphic-website"
# tools will be placed in CURRENT/STACKSTOOL
STACKSTOOL="automorphic-tools"
# history will be placed in CURRENT/STACKSHISTORY
STACKSHISTORY="automorphic-history"
# Location of automorphic project relative to STACKSWEB
# default choice is 'tex'
PROJECTDIR="tex"
# Location containing database relative to STACKSWEB
# default choice is 'database'
DATABASEDIR="database"
# name database
DATABASENAME="automorphic.sqlite"
# Location containing graph data relative to STACKSWEB
# default choice is 'data'
DATADIR="data"
# server from which to clone the automorphic repositories
GITREPO="https://github.com/automorphic-project/"


function check_variables {
echo "This script tries to setup the Stacks project website locally."
echo "It takes a very long time to run..."
echo
echo "Please check the values of the following variables: "
echo "LOCALHOST="$LOCALHOST
echo "DIRECTORY="$DIRECTORY
echo "CURRENT="$CURRENT
echo "STACKSWEB="$STACKSWEB
echo "STACKSTOOL="$STACKSTOOL
echo "STACKSHISTORY="$STACKSHISTORY
echo "PROJECTDIR="$PROJECTDIR
echo "DATABASEDIR="$DATABASEDIR
echo "DATABASENAME="$DATABASENAME
echo "DATADIR="$DATADIR
echo "GITREPO="$GITREPOA
echo
echo "Continue (y/n)"
read ANTWOORD
if [ ! $ANTWOORD = 'y' ]; then exit 0; fi
}

function setup_automorphic_website {
cd $CURRENT
git clone ${GITREPO}automorphic-website $STACKSWEB
cd $CURRENT/$STACKSWEB
cat <<'EOF' > robots.txt
User-agent: *
Disallow: /
EOF
git submodule init
git submodule update
chmod 0777 ./php/cache
sed -i -e "s@database.*=.*@database = \"$DATABASEDIR/$DATABASENAME\"@" config.ini
sed -i -e "s@directory.*=.*@directory = \"$DIRECTORY\"@" config.ini
sed -i -e "s@project.*=.*@project = \"./$PROJECTDIR\"@" config.ini
ln -s ../../../../../css/automorphic-editor.css js/EpicEditor/epiceditor/themes/editor/automorphic-editor.css
ln -s ../../../../../css/automorphic-preview.css js/EpicEditor/epiceditor/themes/preview/automorphic-preview.css
sed -i -e "s@MathJax.Ajax.loadComplete(\"\[MathJax\]/extensions/TeX/xypic.js\");@MathJax.Ajax.loadComplete(\"/js/XyJax/extensions/TeX/xypic.js\");@" js/XyJax/extensions/TeX/xypic.js
sed -i -e "s@SimplePie cache\" =>.*@SimplePie cache\" => \"./php/cache\",@" php/config.php
cd $CURRENT
}

function setup_automorphic_project {
cd $CURRENT/$STACKSWEB
git clone ${GITREPO}automorphic-project $PROJECTDIR
cd $PROJECTDIR
sed -i -e "s@http://automorphic.math.columbia.edu/tag/@$LOCALHOST/tag/@" scripts/tag_up.py
make -j3 tags
cd $CURRENT
}

function setup_automorphic_tools {
cd $CURRENT
git clone ${GITREPO}automorphic-tools $STACKSTOOL
cd $STACKSTOOL
sed -i -e "s@website =.*@website = \"../$STACKSWEB\"@" config.py
sed -i -e "s@database =.*@database = \"../$STACKSWEB/$DATABASEDIR/$DATABASENAME\"@" config.py
sed -i -e "s@websiteProject =.*@websiteProject = \"../$STACKSWEB/$PROJECTDIR\"@" config.py
cd $CURRENT
}

function setup_database {
cd $CURRENT/$STACKSTOOL
python create.py
mkdir $CURRENT/$STACKSWEB/$DATABASEDIR
chmod 0777 $CURRENT/$STACKSWEB/$DATABASEDIR
mv $CURRENT/$STACKSTOOL/automorphic.sqlite $CURRENT/$STACKSWEB/$DATABASEDIR/$DATABASENAME
chmod 0777 $CURRENT/$STACKSWEB/$DATABASEDIR/$DATABASENAME
cd $CURRENT
}

function populate_database {
cd $CURRENT/$STACKSTOOL
python update.py
python macros.py
cd $CURRENT/$STACKSWEB
mkdir $DATADIR
cd $CURRENT/$STACKSTOOL
python graphs.py
cd $CURRENT
}

function setup_automorphic_history {
cd $CURRENT
git clone ${GITREPO}automorphic-history $STACKSHISTORY
cd $STACKSHISTORY
sed -i -e "s@#do_it_all()@do_it_all()@" history.py
sed -i -e "s@#exit(0)@exit(0)@" history.py
sed -i -e "s@websiteProject =.*@websiteProject = \"../$STACKSWEB/$PROJECTDIR\"@" history.py
cd $CURRENT
}

function populate_automorphic_history {
cd $CURRENT/$STACKSHISTORY
python history.py
cd $CURRENT
}

function add_history_database {
# If there is more than one then this line does not work
COMMIT=`ls $CURRENT/$STACKSHISTORY/histories`
cd $CURRENT/$STACKSTOOL
echo $COMMIT | python history.py
cd $CURRENT
}

# START EXECUTION

check_variables
set -e
mkdir -p $CURRENT
cd $CURRENT
setup_automorphic_website
setup_automorphic_project
setup_automorphic_tools
setup_database
populate_database
setup_automorphic_history
populate_automorphic_history
add_history_database
