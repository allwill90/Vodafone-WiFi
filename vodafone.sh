#!/bin/bash
#your login username urlencoded
USERNAME=""
#your login password urlencoded
PASSWORD=""
#the directory where you have saved the script (can be either an absolute pathname or a relative one) e.g /my/path or my/path (no need for ending slash)
DIR=""
#the logname you wish to assign to the script when getting log messages (only for openwrt)
LOGNAME=""
#set this variable to yes if you are running this on openwrt to log messages through the openwrt logging system otherwise the logs will be printed to standard output
OPENWRT=""
#set this to no if you don't want wget to check certificates (if you use this on a system that relies on connectivity to get the date and time and you run this on boot the ssl check will fail resulting in connection errors)
SSL=""

if [ "$DIR" = "" ];then

    DIR="."
    
fi

if [ "$OPENWRT" = "yes" ];then
    
    LOG="logger -p info -t $LOGNAME"
    
else

    LOG="echo"
    
fi

if [ "$SSL" = "no" ];then

    WGETSSL="--no-check-certificate"

fi

wget $WGETSSL --server-response --append-output=$DIR'/vodafone.txt' -qO/dev/null 'http://connectivitycheck.gstatic.com/'


if test -f $DIR'/vodafone.txt';then

	REFRESH=$(cat $DIR'/vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=notyet" | cut -d= -f2 | cut -d\& -f1)

else

	$LOG "$LOGNAME" "wget failed to create file $DIR/vodafone.txt"

fi

if [ "$REFRESH" = "notyet" ];then

	UAMIP=$(cat $DIR'/vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=notyet" | cut -d\& -f2)
	UAMPORT=$(cat $DIR'/vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=notyet" | cut -d\& -f3)
	NASID=$(cat $DIR'/vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=notyet" | cut -d\& -f4)
	CHALLENGE=$(cat $DIR'/vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=notyet" | cut -d\& -f5)
	MAC=$(cat $DIR'/vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=notyet" | cut -d\& -f6)
	IP=$(cat $DIR'/vodafone.txt' | grep "Location: https://it.portal.vodafone-wifi.com/jcp/it?res=notyet" | cut -d\& -f7)
	
	if test -f $DIR'/cookies.txt';then

		 wget $WGETSSL --save-cookies $DIR'/cookies.txt' --keep-session-cookies --load-cookies=$DIR'/cookies.txt' --server-response --append-output=$DIR'/vodafone2.txt' -qO/dev/null --post-data 'userFake='$USERNAME'&UserName=VF_IT%2F'$USERNAME'&Password='$PASSWORD'&_rememberMe=on' 'https://it.portal.vodafone-wifi.com/jcp/it?res=login&'$NASID'&'$UAMIP'&'$UAMPORT'&'$MAC'&'$CHALLENGE'&'$IP
	
	else

		wget $WGETSSL --save-cookies $DIR'/cookies.txt' --keep-session-cookies --server-response --append-output=$DIR'/vodafone2.txt' -qO/dev/null --post-data 'userFake='$USERNAME'&UserName=VF_IT%2F'$USERNAME'&Password='$PASSWORD'&_rememberMe=on' 'https://it.portal.vodafone-wifi.com/jcp/it?res=login&'$NASID'&'$UAMIP'&'$UAMPORT'&'$MAC'&'$CHALLENGE'&'$IP

		if  ! -f $DIR'/cookies.txt';then

			$LOG "$LOGNAME" "wget failed to create file $DIR/cookies.txt"
		
		fi

	fi
	
	if test -f $DIR'/vodafone2.txt';then

		SUCCESS=$(cat $DIR'/vodafone2.txt' | grep "Location: https:" | cut -d\& -f1 | cut -d= -f2)

		if [ "$SUCCESS" = "success" ];then

			$LOG "$LOGNAME" "login successfull"
			
		else

			$LOG "$LOGNAME" "login failed"

		fi
	
	else
		
		$LOG "$LOGNAME" "wget failed to create file $DIR/vodafone2.txt"

	fi

else
	
    $LOG "$LOGNAME" "connection is still alive or your wireless connectivity has problems (check that you are connected to a Vodafone-Wi-Fi ap and/or your dns settings)"
        
fi

rm -rf $DIR'/vodafone.txt' $DIR'/vodafone2.txt'
