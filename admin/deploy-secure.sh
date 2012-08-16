#! /bin/bash

#############################################################
#	Ubuntu Server Deploy Script (version 1.0)				#
#															#
#	deploy-secure.sh										#
#		Performs some basic security improvements			#
#															#
#															#
#		by William Hart (www.williamhart.info)				#
#		https://github.com/mecharius/ubuntu-deploy-script	#
#															#
#############################################################

# install shpass for logging in via ssh
# http://www.cyberciti.biz/faq/noninteractive-shell-script-ssh-password-provider/
apt-get install sshpass -y

# disable root ssh access
sed -i "s/PermitRootLogin[^ ]/PermitRootLogin no/" /etc/ssh/sshd_config

# disable password login
#sed -i "s/PasswordAuthentication [^ ]/PasswordAuthentication no/" /etc/ssh/sshd_config
# (COMMENTED OUT AS NEED TO GENERATE ON LOCAL MACHINE FIRST)

# get the new user name and password
dialog --title "Create new user" --backtitle "Ubuntu Server Deploy\
 Script 1.0" --msgbox "A new user will now be created to operate replace \
 the root user.  In the following screens you will be prompted for a \
 user name and password. . ." 9 50

dialog --title "Set Username" --backtitle "Ubuntu Server Deploy\
 Script 1.0" --input "Specify a username to use instead of the root user:" 9 50
$userName = $?

$pass1 = 1
$pass2 = 2
while [ $pass1 -ne $pass2 ] 
(
	dialog --title "Set Password" --backtitle "Ubuntu Server Deploy\
	 Script 1.0" --input "Specify a password to use for "\ $userName \ ":" 9 50
	$pass1 = $?
	
	dialog --title "Confirm Password" --backtitle "Ubuntu Server Deploy\
	 Script 1.0" --input "Confirm the password:" 9 50
	$pass2 = $?
	
	if [ $pass1 -ne $pass2 ]
		dialog --title "Continue with installation!" --backtitle "Ubuntu Server Deploy\
		 Script 1.0" --yesno "The passwords you have entered do not match.  Do you want \
		 try again? (Select No to exit installation, or Yes to try again)" 9 50
		if [ $? -gt 0 ]
			exit 1; # exit with error
		fi
	fi
)
 
# create a new user for login
useradd -m -s /bin/bash $userName
passwd $userName $pass1

# login as that user
sshpass -p $pass1 ssh $userName@localhost
sudo su
