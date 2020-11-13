#!/bin/bash

#This is a quick script to update Moodle LMS.
#Still needs alot of work to make it interactive and also include tests to ensure it does not fail.
#####!!!!!WARNING!!!!!#####
#This script has some disastrous commands that may leave you crying; kindly go through it and make sure it will be doing what you expect.
#I am not liable for any damages or losses of data incured
#Edit the line containing theme and mods(plugins) to the ones you installed on your system
##you can find the list of your additional plugins from Site Administration > Plugins > Plugins Overview > Additional Plugins
#Change version numbers to your preference

#Update Moodle 
php /var/www/html/moodle/admin/cli/maintenance.php --enable
cd /var/www/html
mv moodle moodle.bak
cd /opt/moodle
git pull
cp -R /opt/moodle /var/www/html
chmod -R 0755 /var/www/html/moodle
cd /var/www/html
cp moodle.bak/config.php moodle/config.php
#themes and mods
cp -pr moodle.bak/theme/moove moodle/theme/moove
cp -pr moodle.bak/mod/attendance moodle/mod/attendance
cp -pr moodle.bak/mod/bigbluebuttonbn moodle/mod/bigbluebuttonbn
cp -pr moodle.bak/report/extendedlog moodle/report/extendedlog
cp -pr moodle.bak/blocks/dedication moodle/blocks/dedication
cp -pr moodle.bak/question/type/essaywiris moodle/question/type/essaywiris
cp -pr moodle.bak/question/type/matchwiris moodle/question/type/matchwiris
cp -pr moodle.bak/question/type/multianswerwiris moodle/question/type/multianswerwiris
cp -pr moodle.bak/question/type/multichoicewiris moodle/question/type/multichoicewiris
cp -pr moodle.bak/question/type/shortanswerwiris moodle/question/type/shortanswerwiris
cp -pr moodle.bak/question/type/truefalsewiris moodle/question/type/truefalsewiris
cp -pr moodle.bak/question/type/wq moodle/question/type/wq
cp -pr moodle.bak/filter/wiris moodle/filter/wiris
cp -pr moodle.bak/lib/editor/atto/plugins/wiris moodle/lib/editor/atto/plugins/wiris
cp -pr moodle.bak/lib/editor/tinymce/plugins/tiny_mce_wiris moodle/lib/editor/tinymce/plugins/tiny_mce_wiris
cp -pr moodle.bak/local/wirisquizzes moodle/local/wirisquizzes
cp -pr moodle.bak/admin/tool/opcache moodle/admin/tool/opcache
cp -pr moodle.bak/mod/hotpot/ moodle/mod/hotpot/
cp -pr moodle.bak/mod/autoattendmod/ moodle/mod/autoattendmod/
cp -pr moodle.bak/blocks/autoattend/ moodle/blocks/autoattend/
##
chown -R root:root moodle
chmod -R 0755 moodle
cd moodle
php admin/cli/upgrade.php 
php admin/cli/maintenance.php --disable
