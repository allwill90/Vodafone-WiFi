#!/bin/bash
#your login username
USERNAME=""
#your login password
PASSWORD=""
#the directory where you have saved the script starting from the root and with an ending slash e.g /etc/scripts/
DIR=""
#the logname you wish to assign to the script when getting log messages
LOGNAME=""

wget --server-response --append-output=$DIR'vodafone.txt' -qO/dev/null 'http://www.google.it/'

if test -f $DIR'vodafone.txt';then

	REFRESH=$(cat $DIR'vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=notyet" | cut -d= -f2 | cut -d\& -f1)

else

	logger -p info -t "$DIR$LOGNAME" "wget failed to create file $DIRvodafone.txt"

fi

if [ "$REFRESH" = "notyet" ];then

	NASID=$(cat $DIR'vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=welcome" | cut -d\& -f2)
	UAMIP=$(cat $DIR'vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=welcome" | cut -d\& -f3)
	UAMPORT=$(cat $DIR'vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=welcome" | cut -d\& -f4)
	MAC=$(cat $DIR'vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=welcome" | cut -d\& -f5)
	CHALLENGE=$(cat $DIR'vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=welcome" | cut -d\& -f6)
	IP=$(cat $DIR'vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=welcome" | cut -d\& -f6)
	
	if test -f $DIR'cookies.txt';then

		 wget --save-cookies $DIR'cookies.txt' --keep-session-cookies --load-cookies=$DIR'cookies.txt' --server-response --append-output=$DIR'vodafone2.txt' -qO/dev/null --post-data 'userFake='$USERNAME'&UserName=VF_IT%2F'$USERNAME'&Password='$PASSWORD'&_rememberMe=on' 'https://it.portal.vodafone-wifi.com/jcp/it?res=login&'$NASID'&'$UAMIP'&'$UAMPORT'&'$MAC'&'$CHALLENGE'&'$IP
	
	else

		wget --save-cookies $DIR'cookies.txt' --keep-session-cookies --server-response --append-output=$DIR'vodafone2.txt' -qO/dev/null --post-data 'userFake='$USERNAME'&UserName=VF_IT%2F'$USERNAME'&Password='$PASSWORD'&_rememberMe=on' 'https://it.portal.vodafone-wifi.com/jcp/it?res=login&'$NASID'&'$UAMIP'&'$UAMPORT'&'$MAC'&'$CHALLENGE'&'$IP

		if  ! -f $DIR'cookies.txt';then

			logger -p info -t "$DIR$LOGNAME" "wget failed to create file $DIRcookies.txt"
		
		fi

	fi
	
	if test -f $DIR'vodafone2.txt';then

		SUCCESS=$(cat $DIR'vodafone2.txt' | grep "Location: https:" | cut -d\& -f1 | cut -d= -f2)

		if [ "$SUCCESS" = "success" ];then

			logger -p info -t "$DIR$LOGNAME" "login successfull"
			
		else

			logger -p info -t "$DIR$LOGNAME" "login failed"

		fi
	
	else
		
		logger -p info -t "$DIR$LOGNAME" "wget failed to create file $DIRvodafone2.txt"

	fi

else
	
	logger -p info -t "$DIR$LOGNAME" "connection still alive"

fi

rm -rf $DIR'vodafone.txt' $DIR'vodafone2.txt'
