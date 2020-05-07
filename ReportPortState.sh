#!/bin/sh
#
#  Script %name:        ReportPortState.sh%
#  %version:            1 %
#  Description:
# =========================================================================================================
#  %created_by:         Diego Villegas (FDM) %
#  %date_created:       Friday, August 28, 2015  3:11:29 PM SAT %
# =========================================================================================================
# change log
# =========================================================================================================
# Mod.ID         Who                            When                                    Description
# =================================================================================================== ======

#Definicion de variables.
HOME="/var/tmp"
HOSTNAME=`uname -n`
OSTYPE=`uname -s`
CONFFILE="$HOME/report.conf"
REPORT="$HOME/report.csv"
LOGFILE="$LOGDIR/SystemOut.log"
TIME_ELAP=10

>$REPORT
#Inicio de funciones de script
#Funcion para determinar si un host se encuentra a la escucha de un puerto determinado
eval_telnet_TCP () {
	echo "IP_ADDRESS:PORT:TYPE:CONNECTION">>$REPORT
	TARGET=`cat $CONFFILE| awk -F: '{print $1}'`
	for e in `echo $TARGET`;
	do
		TARGET_IP=`cat $CONFFILE| grep "$e"|awk -F: '{print $2}'`
		TARGET_PORT=`cat $CONFFILE| grep "$e"|awk -F: '{print $3}'`
		TARGET_TYPE=`cat $CONFFILE| grep "$e"|awk -F: '{print $4}'`
			if [ $TARGET_TYPE = "tcp" ]
			then
				perl -MIO::Socket::INET -e exit\(!defined\(IO::Socket::INET-\>new\(\"$TARGET_IP:$TARGET_PORT\"\)\)\)
				if [  $? -eq  0 ]
				then
					echo "$TARGET_IP:$TARGET_PORT:$TARGET_TYPE:OPEN">>$REPORT
				elif [ $? -eq  1 ]
				then
					echo "$TARGET_IP:$TARGET_PORT:$TARGET_TYPE:CLOSE">>$REPORT
				fi
			fi
        done
}
eval_telnet_TCP
