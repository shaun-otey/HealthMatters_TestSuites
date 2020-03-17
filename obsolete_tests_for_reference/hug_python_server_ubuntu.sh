#!/bin/bash
set -e

# sudo apt-get install python3-setuptools
# sudo easy_install3 pip
# sudo apt-get install python3-setuptools
# sudo apt-get install -y python3-dev
# sudo -H pip3 install hug -U
# sudo -H pip3 install uwsgi
# sudo -H pip3 install gunicorn
# sudo -H pip3 install psycopg2
# sudo -H pip3 install boto3
# sudo -H pip3 install awscli
# sudo -H pip3 install robotframework
# sudo -H pip3 install -U https://github.com/HelioGuilherme66/robotframework-selenium2library/archive/v1.8.2b1.tar.gz
# sudo -H pip3 install pyotp
# sudo -H pip3 install robotframework-pabot
# sudo -H pip3 install -U robotframework-requests
# sudo -H pip3 install future
# sudo chmod 777 /var/log
# mkdir -p /var/log/rf

su -lc /bin/bash $UBUNTU <<EOF
sudo apt-get install -y python3-dev
sudo -H pip3 install --upgrade pip
sudo -H pip3 install hug==2.3.2 -U
sudo -H pip3 install uwsgi
sudo -H pip3 install gunicorn
sudo -H pip3 install psycopg2
sudo -H pip3 install boto3
sudo -H pip3 install awscli
sudo -H pip3 install robotframework
sudo -H pip3 install -U https://github.com/HelioGuilherme66/robotframework-selenium2library/archive/v1.8.2b1.tar.gz
sudo -H pip3 install pyotp
sudo -H pip3 install robotframework-pabot
sudo -H pip3 install -U robotframework-requests
sudo -H pip3 install future
sudo chmod 777 /var/log
mkdir -p /var/log/rf
EOF

cd /home/ubuntu/rf_app/RobotFrameworkServer
export $(cat SERVER)
DISPLAY=:8964 gunicorn -w 5 -b :8000 server:__hug_wsgi__
# gunicorn -w 5 -b :8000 server:__hug_wsgi__ &>/dev/null &
# DISPLAY=:8964 uwsgi --http-socket :8000 --wsgi-file server.py --callable __hug_wsgi__ --master --process 4 &>/dev/null &
# DISPLAY=:8964 hug -f server.py &>/dev/null &

# exec "$@"
