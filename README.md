# KuraLabs [kura_build_03]
# Version 1.0
-------------------------------------------------------------------------------------------------------------
# Application Name:
	GitConnect
-------------------------------------------------------------------------------------------------------------
# Author:
	R. Da Costa 
-------------------------------------------------------------------------------------------------------------
# Objective: 
	The "gitconnect.sh" script will, based on user input, securely create a git user and push changes 
	to an auto-generated branch [i.e. NOT the main branch] named specifically for the new user
-------------------------------------------------------------------------------------------------------------
# Requirements:
	No specific requirements
-------------------------------------------------------------------------------------------------------------
# Potentional Breaks:
	Note: The user has the option to either keep or destroy the newly created user and all related files
	i. If the application is terminated prematurely during execution and the user opted to destroy the 
	   newly created userid, the userid will likely not be destroyed. All files will remain.
		- Additionally related to this, if the application is re-run, one could not reuse the improperly destroyed userid
	ii. If another user already created and committed a branch with the same userid, any user attempting to do so will fail.
		- The failure will not occur locally as the userid may not exist on the current Linux filesystem. 
		- I will occur when "gitconnect.sh" attempts to add and commit the new user-related branch as it will already exist
-------------------------------------------------------------------------------------------------------------
# Application Components:
	General Files:
		README.md
	Main Script:
		gitconnect.sh
-------------------------------------------------------------------------------------------------------------
# Application Process Flow:
	1. Collect User Information 
	2. Setup linux user account [in "gitconnect" group] 
	3. Initialize git
	4. Establish git connection + clone project
	5. Create userid-based branch 
	6. Prompt user for file contents line by line
	7. Add, Commit + Push to Remote Repository
-------------------------------------------------------------------------------------------------------------
# *** Potential Enhancement(s) ***
	1. Allow existing users to update, merge and commit to their existing repository branches
