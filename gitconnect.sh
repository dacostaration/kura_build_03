#!/bin/bash

# Git Connect Script


###################################################################################################################
# BEGIN Global Variables
###################################################################################################################
systemName='GitBot'			# this is just a fun name given to the system to allow users to easily distinguish b/w the system prmpts and their own responses
gitRepo="git@github.com:dacostaration/kura_build_03.git"	# remote Git Repository
repoShortName="build03"		# used in some variable names and echoes to identify the remote repository the user is interacting with
usrgroup="gitconnect"		# the group name that will be used for gitconnect users
availItemErr=""				# used to indicate if a userid or home directory or both are unavailable
userAdded=false				# record of user having been created. used in "killUser" function to know whether or not to attempt to delete user
purgeUser=false				# triggers removal of newly created user and the associated home directory when the program exits 
fileCreated=false			# tracking whether or not user's submitted file contents have been added to a file on the system
usrBranch=""				# Branch that will be created for user to push to remote repository w/o updating the "main" branch
joinitarr="y n"
usrTry=0
validUsr=0
availUsr=0
finalUsr=""
usrshell="/bin/bash"
loopTime=2
loopFin="Let's GO!"	#.....text that will be displayed at the end of the "tinyLoop" function
line=""				#.....line in file that user will be creating
removePII=TRUE		#.....boolean operator that sets whether or not lines entered by a user will be scrubbed of Personally Identifying Information [PII]


###################################################################################################################
# BEGIN Function Definitions
###################################################################################################################
# addUser 
# will attempt to:
# i. create the new user account 
# ii. the associated home directory 
addUser(){

	# check that 

	# Adding user and add them to the gitconnect group
	sudo mkdir "/home/$finalUsr"
	sleep 1
	sudo useradd $finalUsr -d "/home/$finalUsr/" -g $usrgroup -s $usrshell;
	sleep 1
	# create .ssh directory for user 
	sudo mkdir "/home/$finalUsr/.ssh";
	sleep 1

	# note user creation 
	userAdded=true
}

# addSSHKeys will:
# i. confirm the existence of the .ssh directory
# ii. set up the user's .ssh keys to be able to connect to the git repo
addSSHKeys(){
	
	# create the missing .ssh directory and set up read permissions if necessary and make it readable and writable
	sshpath="/home/$finalUsr/.ssh/"
	privkeypath="/home/$finalUsr/.ssh/id_rsa"
	pubkeypath="/home/$finalUsr/.ssh/id_rsa.pub"
	if [ ! -d "$sshpath" ]; then 
		echo "[$systemName]: Making your .ssh directory..."
		sudo mkdir "$sshpath"
		sleep 1
		sudo chmod 755 "$sshpath"
		sleep 1

		echo "[$systemName]: ssh key permissions..."		#.....used when testing
		sudo ls -alt "$sskpath"
		sleep 2
	fi

	echo "[$systemName]: Adding your public key..."
	# COPY KEYS
	# sudo cp -f "/home/gituser1/.ssh/id_rsa" "/home/$finalUsr/.ssh/id_rsa_$repoShortName"
	# sudo cp -f "/home/gituser1/.ssh/id_rsa.pub" "/home/$finalUsr/.ssh/id_rsa_$repoShortName.pub"

	# sudo cat <<EOF > "/home/$finalUsr/.ssh/id_rsa"
	# sudo cat <<EOF | xargs | sed 's/ //g' > "$privkeypath"
	sudo -u "$finalUsr" tee -a "$privkeypath" > /dev/null << EOF
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
EOF

	# sudo cat <<EOF1 > "/home/$finalUsr/.ssh/id_rsa.pub"
	# sudo cat <<EOF1 | xargs | sed 's/ //g' > "$pubkeypath"
	sudo -u "$finalUsr" tee -a "$pubkeypath" > /dev/null << EOF1
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDb0m44+mNSFV3LzoDNit6Qtt/Msr+vNPSUcnIwO1pfGTXvgwREwPxtj1CO7DtzqxzbUKrUCjl2spbzySsBAxuoFl/wwJyhxOVe65QXdxUlDx/ZjoaKBa9DpfHp80mOx0KmJZkFtXzSHxIbnuPPIYXZa7Sf/an7voT68kSoRHJFij/RpasXZGddeFBOnm2s/2K54oTH1uClrK4ZxmXOnf63zLoRP1IVybMJ7tadxyXBABwtLSZ0jVFaekIpvu4H4UUgad/AyvdGWm4r7r4ydIXMdxsln7ceqbjxDUAO/9neotzJl7W2nlnUwQ876AxnQCSwALGdxV6qSoccwd5yphUEo771uIaChPXsT32HzoOuxBGpBEs7oyrK9SEQY6S0lDfG6bALWUI4HZTqay97m66wR4zcSKFnzGvCUov6FWjMIMCnN4VU3eOZyk2PcUznFrc0FFEGHSLfQxNybITmSIX9yHeOSsebbx2EC0w3W9aXMUk8xDLhSXvykNc2Urx5CM= DESKTOP-30OQ0UI
EOF1

	# ensure keys are readable by the user
	sudo -u "$finalUsr" chmod 400 "${sshpath}id_rsa"
	sudo -u "$finalUsr" chmod 400 "${sshpath}id_rsa.pub"

}

# usrValid will:
# i. ensure that the user's input is acceptable [alphanumeric, no spaces or special chars] for userid creation
# ii. let the user know when their input is valid
usrValid(){
	if [[ "$usrTry" > 0 ]]; then
		read -p "[$systemName]: Perhaps you can try another username: " usr
	else 
		read -p "[$systemName]: Please enter a username you wish to use: " usr
	fi

	# read usr
	usr="${usr}" | sed -e 's/^[[:space:]]*//'
	#echo "usr entered:\"${usr}\", len:${#usr}"
	#validusr=0

	if [[ ! "$usr" =~ [^a-zA-Z0-9] && ! "${#usr}" -lt 3 ]]; then
	  validUsr=1
	fi
	usr=${usr,,}

	#echo "usr trimmed: [${usr}]"

	while [[ "$validUsr" == 0 ]]; do
		echo "[$systemName]: You must enter a proper username to continue..."
		read usr;
		usr="${usr}" | sed -e 's/^[[:space:]]*//'

		validUsr=0
		#if ! [[ "$usr" =~ [^a-zA-Z0-9] ]]; then
		if [[ ! "$usr" =~ [^a-zA-Z0-9] && ! "${#usr}" -lt 1 ]]; then
		  validUsr=1
		fi
	done

	if [[ "$validUsr" == 1 ]]; then
		echo "[$systemName]: valid user..."
		echo ""
	fi
}

# usrAvail will:
# i. checks whether or not the entered userid is available
usrAvail(){
	echo "[$systemName]: Checking to see if username \"$usr\" is available..."
	echo ""
	# show a nice little countdown before takeoff
	sec=2;
	while [[ $sec -gt 0 ]]; do
	 sleep 1
	 #echo "$sec";
	 sec=$(( sec-1 ))
	done

	#  id "$usr" >/dev/null 2>&1;
	availItemErr=""
	#usrID=$("sudo getent passwd ${usr}")
	#echo $("id -u ${usr} >/dev/null 2>&1")

	# check userid availability
	#if id -u "$usr" >/dev/null 2>&1; then
	if [ `id -u $usr 2>/dev/null || echo -1` -ge 0 ]; then
	    # echo "[$systemName]: Oops! This user already exists"
		availItemErr="userid"
	fi

	# userid may be available but let's verify that there isn't a directory in /home that bares that name
	# check home directory availability
	if [ ! -d "/home/${usr}" ]; then 
		echo "[$systemName]: You're in business! This username is available"
		availUsr=1
	else 
		# echo "[$systemName]: userid \"${usr}\" is available. However, there seems to be a directory [/home/${usr}/] that already exists!"
		if [ "${#availItemErr}" -gt 0 ]; then 
			availItemErr="${availItemErr}, "
		fi 
		availItemErr="${availItemErr}home directory"	
	fi

	if [ ! -z "$availItemErr" ]; then
		availUsr=0
		echo "[$systemName]: [$availItemErr] for ${usr} not availble!"
	fi 
}

# tinyLoop 
# This function is purely for operational aesthetics. 
# It is meant to give the user a sense of activity with a visible countdown in the console while some process is running...
tinyLoop(){
	sec=$loopTime;
	while [ "$sec" -gt 0 ]; do
	 sleep 1
	 echo "T-$sec";
	 sec=$(( sec-1 ))
	done
	sleep 1
	echo $loopFin
	echo ""
}

# cleanLine will:
# i. [TEST FUNCTIONALITY] set the user's input to all lowercase .....will not be performed when the function is live
# ii. [LIVE FUNTIONALITY] purge the user's input of all PII and possible sensitive information. 
# iii. notify the user if any PII has been found/removed
cleanLine(){
	if [[ "$removePII" == false ]]; then
		line=${line,,}		#.....simply make it lowercase [1st iteration]. In "LIVE" mode, this function will remove PII
	else 
		echo "[$systemName]: Removing PII and sensitive information..."
		sleep 1
	fi
}

### 
# killuser will be called just befor the application exits gracefully [whether in error state or not]
# killUser will do the following when necessary:
# i. kill all the user's [finalUser] active processes...[future functionality]
# ii. remove the user [finalUsr] from the system 
# iii. remove the user's home directory
killUser(){
	if [[ "$purgeUser" && "$userAdded" ]]; then 
		sudo deluser --remove-home "$finalUsr"
	fi 	
}

###################################################################################################################
# BEGIN Functionality
###################################################################################################################
echo "[$systemName]: There is a great project I would like to share with you."
# echo "[$systemName]: Would you like to join the club? [y/n]" 
# read joinit;
read -p "[$systemName]: Would you like to join the club? [y/n]: " joinit
joinit=${joinit,,}

while [[ "$joinit" != @("y"|"n") ]]; do
	# echo "[$systemName]: Please enter \"y\" to join or \"n\" to remain in the dark."
	# read joinit;
	read -p "[$systemName]: Please enter \"y\" to join or \"n\" to remain in the dark: " joinit
	# echo "[$systemName]: new joinit: $joinit"
done

if [ $joinit == "n" ]; then
	echo "[$systemName]: It was worth a shot...maybe next time. Ciao!"
	# killUser
	exit 0;
fi

# else >> we continue...
# echo "moving on..."
# testUsr
echo "--------------"
echo "[$systemName]: Excellent! Let's get you set up."
# echo "[$systemName]: Please enter a username you wish to use."
# read -p "[$systemName]: Please enter a username you wish to use: " usr

while [[ "$usrValid" == 0 || "$availUsr" == 0 ]]; do
	# check if user is valid...
	usrValid

	echo "[$systemName]: Ok...let's go with [$usr]"
	sleep 1

	# check if user is available...
	usrAvail

	usrTry=$(( usrTry+1 ))

	#echo "usrValid:${usrValid}, usrAvail:${usrAvail}"		# used while testing...
done

echo "--------------"
read -p "[$systemName]: Once the program finishes running, would you like to \"keep the user and home directory\" you create? [y/n]: " removeUsr
removeUsr=${removeUsr,,}
while [[ "$removeUsr" != @("y"|"n") ]]; do
	read -p "[$systemName]: Please say whether or not you wish to keep the user info when we're done.\nShall we keep it? [y/n]: " removeUsr
	removeUsr=${removeUsr,,}
done

if [ "$removeUsr" == "y" ]; then
	echo "[$systemName]: Ok. The user you create will remain!"
	purgeUser=true
else
	echo "[$systemName]: Ok. The user you create will be destroyed!"
	purgeUser=false
fi

finalUsr=$usr

# echo "out of the user loop..."
# Ok. We have a valid and available username. Let us proceed...
# 1. create the user
# 2. add user to a "gitconnect" group
#	note: repo's public key must be added to user prfile!!!
# 3. notify user of the following actions
#	i. connection to the great git repo "git@github.com:dacostaration/kura_build_03.git"
#	ii. the setting up of .git in their user directory
#	iii. the cloning of the git repo
# 4. prompt the user to submit 5 lines of data that will:
#	i. be added to a file named "usrname"_build03_timestamp.txt
#	ii. scanned for and cleard of all PII [email addresses, phone numbers, SSNs]
# 5. prompt user to trigger the following actions:
#	i. git add [of their newly created file]
#	ii. git commit -m "commit @timestamp"
#	iii. git push

read -p "[$systemName]: Create a password: " usr_pass;
len=${#usr_pass};
while [[ -z "$usr_pass" || $len -lt 5 ]]; do
 read -p "[$systemName]: Please Enter a Password With 5 or More Characters: " usr_pass
 len=${#usr_pass};
done

echo ">> password will be set to [${usr_pass}]"

echo ""
echo "[$systemName]: OK! Setting up your user account now..."
echo "---------------------------------------"

#echo $(grep -q "$usrgroup" /etc/group)
#grpexists=$("getent group ${usrgroup}")
#groupentry=$("echo sudo grep ${usrgroup} /etc/group")
#if [ ! -z groupentry ]; then
if grep "$usrgroup" /etc/group; then
	echo "[$systemName]: The [$usrgroup] group already exists. No need to re-create it here..."
else
	echo "[$systemName]: Creating the [$usrgroup] group"
	sudo addgroup $usrgroup
fi

usrshell="/bin/bash"

# attempt to add user now
addUser

# using previously generated key pair

# getting into GIT here..................................................................
echo ""
echo "[$systemName]: Now that you're all set, let us \"Git\" it on!!!"
sleep 1
read -p "[$systemName]: Would you like to continue? [y/n]: " contin
contin=${contin,,}
contc=0

while [[ "$contin" != @("y"|"n") ]]; do
	case $contin in
		0) echo "[$systemName]: Please say whether or not you would like to try this \"git\" stuff [y/n]" ;;
		1) echo "[$systemName]: Really...we cannot move forward until you say so [y/n]" ;;
		3) echo "[$systemName]: Last change to proceed. [y/n]" ;;
		4) echo "[$systemName]: Sayonara!!"
			contin="n"
		;;
	esac
done

if [ "$contin" == "n" ]; then
	echo "[$systemName]: It looks like you've opted to leave."
	echo "[$systemName]: No hard feelings...see ya!"
	killUser	#....call function to kill user if necessary
	exit 0
fi

echo "-----------------------------"
echo "[$systemName]: Ok! Let's get this show on the road..."
sleep 1
echo "[$systemName]: Setting up your local directory permissions and git repo..."
sleep 1
echo ""

################################################################################
# May need to configure git to know that directories are safe.....
# fatal: detected dubious ownership in repository at '/home/rd12/build03'
# To add an exception for this directory, call:
#         git config --global --add safe.directory /home/rd12/build03
# fatal: detected dubious ownership in repository at '/home/rd12/build03/.git'
# To add an exception for this directory, call:
#         git config --global --add safe.directory /home/rd12/build03/.git
# set up git for the user
################################################################################
usrPath="/home/$finalUsr/"
project="/home/$finalUsr/$repoShortName/"
echo ">> sudo mkdir $project"
sudo mkdir "$project"		#...................................................make project directory /home/user/build03/
sleep 1
echo ">> sudo chown -R $finalUsr:$usrgroup $project"
sudo chown -R "$finalUsr":"$usrgroup" "$usrPath"		#.......................set user directory ownership
sleep 1
### permissions
perm=755
echo ">> sudo chmod $perm $project"
sudo chmod "$perm" "$project"				#.......................................set permissions
sleep 1
echo "[$systemName]: Let's check that your project directory has been created and has the right permissions..."
sudo ls -alt "$usrPath"		#<--- for testing [just to verify that the user prject has write permissions]
sleep 1
# exit 0	#<--- used when testing

# change to the new user directory [as finalUsr]
echo "[$systemName]: Let us run commands as your newly created user before running with git..."
echo "-----------------------------------------"
echo ">> cd $project"		
# # su "$finalUsr" -c		#<--- this will change user. we don't want this as I believe it starts a new shell and we will not be able to continue the current process flow
# sleep 1
# cd "$project"
# su "$finalUsr" -c cd "$project";
# sudo su -c "Your command right here" -s /bin/sh otheruser
# sudo -H -u "$finalUsr" bash -c cd "$project" 	#<--- this gets permission denied unless you ARE the user or you are root! If someone runs this program, we need to be aware of this fact
cd "$project"

sleep 1

echo ">> pwd [checking current working directory]"
pwd
sleep 1

echo ">> git init"
# sudo git init
sudo -u "$finalUsr" git init
# sudo -H -u "$finalUsr" bash -c git init
sleep 1

echo ">> git config"
sudo -u "$finalUsr" git config user.email "finalUsr@gitconnectscript.com"
sleep 1
sudo -u "$finalUsr" git config user.name "$finalUsr"
sleep 1

# Add SSH Keys
echo "-----------------------------------------"
addSSHKeys

# Run a tinyLoop ---------------------------------------------------
loopTime=3	#...........set the tinyLoop timer to 3 secs
loopFin="[$systemName as $finalUsr]: Let's pull the repo and have some fun!"
tinyLoop	#...........show a little countdown
# ------------------------------------------------------------------

# clone repo: git@github.com:dacostaration/kura_build_03.git"
# sudo -H -u "$finalUsr" bash -c git clone git@github.com:dacostaration/kura_build_03.git
# set up remote origin for git repo
echo "-----------------------------------------"
echo "[$systemName as $finalUsr]: Let us set the remote origin for github: $gitRepo"
# sleep 1
# echo "[$systemName]: 2. git remote remove origin"
# sudo git remote remove origin
# sleep 2
# echo "[$systemName]: 3. git remote add origin ${gitRepo}"
# sudo git remote add origin "$gitRepo"
# sudo -H -u "$finalUsr" bash -c git remote add origin "$gitRepo"
sudo -u "$finalUsr" git remote add origin "$gitRepo"		#..........add remote repo
# sleep 2
# echo "[$systemName]: 4. git pull"
# sudo git pull 
# sudo -H -u "$finalUsr" bash -c git pull
sudo -u "$finalUsr" git pull "$gitRepo" master		#..................................pull repo contents
sleep 2

# since this will be this user's first interaction with the remote repo, no prior commit history exists. 
# as such, they will not be permitted to create a branch off of the master/main branch
# we need to: git branch --set-upstream-to=origin/<branch> master
# sudo -u "$finalUser" git branch --set-upstream-to=origin/"$usrBranch" master

# create a separate branch for this user
usrBranch="${finalUsr}Branch"
echo "[$systemName as $finalUsr]: Creating a new branch off of the main repo named \"$usrBranch\""
sudo -u "$finalUsr" git branch "$usrBranch"
sleep 1

# switch to the newly created branch
echo "[$systemName as $finalUsr]: Switch to newly created branch [$usrBranch]"
sudo -u "$finalUsr" git switch "$usrBranch"
sleep 1

echo "-----------------------------------------"

echo ""
echo "[$systemName as $finalUsr]: Now let us check if we were able to pull down the files..."
echo "[$systemName as $finalUsr]: You should see the remote repository's contents here [between BEGIN and END]:"
# echo "-----------------------------------------"
# echo ":BEGIN:"
echo "-----------------------------------------"
ls $project
echo "-----------------------------------------"
# echo ":END:"
# echo "-----------------------------------------"
read -p "[$systemName as $finalUsr]: Do you see the folder or files? [y/n]: " resp
resp=${resp,,}
if [[ "$rep" == "y" ]]; then
	echo "-------------------------"
	# echo ">> changing ownwership of all files..."
	# sudo -u chown -R "${finalUsr}:${usrgroup} ${project}/*"
else 
	contc=0
	maxloop=10
	loop=0
	while [[ "$resp" != @("y"|"q") ]]; do
		if [ "$loop" -ge "$maxloop" ]; then 
			echo ">> Too many attempts!"
			resp="q"
			break
		fi

		if [ "$contc" -gt 0 ]; then
			read -p "[$systemName as $finalUsr]: Please confirm whether or not the repo was pulled successfully [y/n]: " resp
			# sudo -H -u "$finalUsr" bash -c ls $project
			sudo -u "$finalUsr" ls "$project"
			echo "-----------------------------------------"
			# read resp
		fi

		# resplen=${#resp}
		# if [ "$resplen" > 0 ]; then 
			if [ $resp == "n" ]; then
				read -p "[$systemName as $finalUsr]: No repo huh? Would you like to try again? [y/n]: " resp
				resp=${resp,,}
				if [ $resp == "n" ]; then
					resp="q"
				else
					# sudo git clone git@github.com:dacostaration/kura_build_03.git
					# sudo git remote remove origin "$gitRepo"
					# git remote add origin "$gitRepo"
					resp="c"	# set response to a value that will allow loop continuation
				fi
			fi
		# else
		# 	resp="c"
		# fi
		$(( loop+1 ))
	done
fi

if [ "$resp" == "q" ]; then
	echo "-----------------------------------------"
	echo "[$systemName]: It looks like you've opted to leave."
	echo "[$systemName]: Maybe we can do this again some other time."
	killUser
	exit 0
fi

echo "-----------------------------------------"
echo "[$systemName as $finalUsr]: Excellent! Now that we're up to date...let us create a file to upload..."

flines=""
l=0
lcont="y"
echo "[$systemName as $finalUsr]: Type something for the first line: "
read line
cleanLine
while [ "$lcont" == "y" ]; do

	l=$(( l+1 ))

	if [ "$l" -gt 1 ]; then
		# echo ">> current lines: "
		flines="${flines}"$'\n'		#.....note: bash will interpret "dollar sign + single quote + \n" [$'\n'] as a newline. Otherwise "\n" will be interpreted as part of the string
		echo "[$systemName as $finalUsr]: Enter new line text: "
		read line
		cleanLine
	fi
	flines="${flines}${line}"	#....add new "clean" line

	read -p "[$systemName as $finalUsr]: Would you like to add another line? [y/n]: " lcont
	lcont=${lcont,,}
	while [[ $lcont != @("y"|"n") ]]; do
		read -p "[$systemName as $finalUsr]: Shall we continue? [y/n]: " lcont
	done
done

ts=""		# timestamp used when creating file from user input
giveUp=false
reTry="y"
while [[ "$fileCreated" == false && "$giveUp" == false ]]; do 

	if [ $lcont == "n" ]; then
		echo "[$systemName as $finalUsr]: ${l} lines will be written to your file...\n"
		echo "-----------------------------------------"
		echo "$flines"
		echo "-----------------------------------------"

		# create and write to file...
		ts="$(date +'%Y-%m-%d_%H-%M-%S')"
		myfilepath="/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt"
#	 	sudo tee -a "/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt" > /dev/null << EOF
# "$flines"
# EOF
		# echo "$flines" "/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt" > /dev/null
		# sudo -H -u "$finalUsr" bash -c echo "$flines" "/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt" > /dev/null
		# sudo -u "$finalUsr" echo "$flines" "/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt" > /dev/null
		# sudo -u "$finalUsr" touch "/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt"
		sudo -u "$finalUsr" touch "$myfilepath"
		sleep 1
		sudo chmod 755 "$myfilepath"
		sleep 1
		# sudo -u "$finalUsr" echo "$flines" > "/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt"
		# sudo -u "$finalUsr" tee a_file.txt >/dev/null
		sudo -u "$finalUsr" tee -a "$myfilepath" > /dev/null << EOF0
"${flines}"
EOF0

	fi

	# Run a tinyLoop ---------------------------------------------------
	loopTime=2	#...........set the tinyLoop timer to 3 secs
	loopFin="[$systemName as $finalUsr]: Attempted to create your file...Here's what it looks like:"
	tinyLoop	#...........show a little countdown
	# ------------------------------------------------------------------

	echo "-----------------------------------------"
	if [ ! -f "/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt" ]; then 
		echo "[$systemName]: Hmm...It doesn't appear as though your file was created!"
		read -p "[$systemName]: Would you like to retry? [y/n]: " reTry
		reTry=${reTry,,}
		while [[ "$reTry" != @("y","n") ]]; do
			read -p "[$systemName as $finalUsr]: Please state whether or not you wish to retry file creation [y/n]: " reTry 
			reTry=${reTry,,}
		done
		if [ "$reTry" == "y"]; then 
			giveUp=false
		else 
			giveUp=true
		fi 
	else
		fileCreated=true
		sudo -u "$finalUsr" cat "/home/$finalUsr/$repoShortName/${finalUsr}_${repoShortName}_${ts}.txt"
	fi
	echo "-----------------------------------------"
	echo ""
done

if "$giveUp"; then 
	killUser
	exit 0
fi 

sleep 1
echo "[$systemName as $finalUsr]: Here comes the magic...."
sleep 1
echo "[$systemName as $finalUsr]: \"Git\" ready to Auto-Commit..."
sleep 1
echo "[$systemName as $finalUsr]: Adding your file with [git add .]..."
#sudo git add . 
sudo -u "$finalUsr" git add .

# Run a tinyLoop ---------------------------------------------------
loopTime=2	#...........set the tinyLoop timer to 3 secs
loopFin="[$systemName as $finalUsr]: Done!"
tinyLoop	#...........show a little countdown
# ------------------------------------------------------------------

read -p "[$systemName as $finalUsr]: Type a comment to send with your commit: " comment
comment=${comment//[^[:alnum:]]/}

echo "[$systemName as $finalUsr]: Committing your file with [git commit -m \"${comment}\"]..."
#sudo git commit -m "$comment"
sudo -u "$finalUsr" git commit -m "$comment"

# Run a tinyLoop ---------------------------------------------------
loopTime=2	#...........set the tinyLoop timer to 3 secs
loopFin="[$systemName as $finalUsr]: Done!"
tinyLoop	#...........show a little countdown
# ------------------------------------------------------------------

echo "[$systemName as $finalUsr]: Drum roll please...."
sleep 2
echo "[$systemName as $finalUsr]: Pushing your file with [git push]..."
# Note: pushing a new branch w/o an upstream branch will have a fatal error as follows:
# ------
# [GitBot as rd03]: Pushing your file with [git push]...
# fatal: The current branch rd03Branch has no upstream branch.
# To push the current branch and set the remote as upstream, use
#
#   git push --set-upstream origin rd03Branch
sudo -u "$finalUsr" git push --set-upstream origin "$usrBranch"

# sudo -u "$finalUsr" git push origin "$usrBranch"
sudo -u "$finalUsr" git push

# Run a tinyLoop ---------------------------------------------------
loopTime=2	#...........set the tinyLoop timer to 3 secs
loopFin="[$systemName as $finalUsr]: Done!"
tinyLoop	#...........show a little countdown
# ------------------------------------------------------------------

echo "-----------------------------------------"
echo "[$systemName as $finalUsr]: Ta Da!"
echo "[$systemName as $finalUsr]: That was fun! Here's the state of affairs....[git status]"
echo "-----------------------------------------"
#sudo git status
sudo -u "$finalUsr" git status
sleep 1
echo "[$systemName as $finalUsr]: Let's see your activity....[git log]"
echo "-----------------------------------------"
sudo -u "$finalUsr" git log --oneline --graph --all --decorate

echo "-----------------------------------------"
echo "[$systemName as $finalUsr]: Let's exit this user account now!"
# exit		#..............................exit user account
sleep 1
echo "[$systemName]: See you next time..."
echo "-----------------------------------------"


killUser		#..........................call the killUser function to remove this user [if this option to remove the user was selected]
exit 0;
