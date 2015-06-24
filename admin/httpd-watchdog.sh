#!/bin/bash
SUBJECT="Server restarted"
EMAIL="youremailaddress@gmail.com"
MESSAGE="/path/to/message.txt"
SITE="http://YOUR_SITE.com/index.html"
response=$(curl --write-out %{http_code} --connect-timeout 5  --silent --output /dev/null $SITE)
if [[ ! $response -eq 200 ]]
then
  (kill $(ps aux | grep '[h]ttpd' | awk '{print $2}'))
  (/etc/init.d/httpd restart)
  /bin/mail -s "$SUBJECT" "$EMAIL" < $MESSAGE # may not work
fi
# code adopted from: http://goo.gl/paGCoI
