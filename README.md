# HouseKeeper iOS App
An open house walk-through app for iOS

# THE FOLLOWING CONTAINS INFORMATION FOR HOUSEKEEPER, HOUSEKEEPER-SERVER, AND HOUSEKEEPERADMINPORTAL

############################################################################################################################################

Release Notes version HouseKeeper 1.0
-	NEW FEATURES
		- Added live App-to-Server comunication
		- Added user-controlled Dream House template
		- Added user-controlled House List containing user houses
		- Added adaptive data visualizations representing the similarity between houses in the House List and the Dream House
		- Added login/logout features with the server (contained under SETTINGS > PROFILE)
		- Added Administrator Portal for policing User Database
-	BUG FIXES
		- Fixed house being added multiple times
		- Fixed all users being emptied from server on selection of single "Delete" button in Administrator Portal
		- Fixed Dream House automatically generating from the first user in the database
-	KNOWN BUGS
		- Logging in as a new user may load houses from a test user account
		- Criteria are sometimes added to a house multiple times, resulting in separately considered but similarly labeled comparative critieria

############################################################################################################################################

Install Gude for HouseKeeper 1.0
- PRE-REQUISITES
	- You must have a MAC system with xCode installed. See https://developer.apple.com/xcode/downloads/
	- You must have an Ubuntu/Apache based server configured for JavaScript, MySQL, and PHP
- DEPENDENCIES
	- For xCode: You must install and configure Alamofire. See https://github.com/Alamofire/Alamofire
- DOWNLOAD
	- FOR THE APP: github.com/ProfectusDev/housekeeper
	- FOR THE SERVER FILE: github.com/ProfectusDev/housekeeper-server
	- FOR THE WEBSITE FOLDER: github.com/ProfectusDev/HouseKeeperAdminPortal
- BUILD
	- No build necessary for this app. Can be run from xCode
- INSTALLATION
	- SERVER - FILE
		- Drag the index.js file into the root directory of your server
	- WEBSITE
		- Drag the folder into the /www directory of your server. In 'config.php', the user, password and database parameters need to be changed to reflect your server login and target database
	- iOS APP
		- Add Cocoapods to 'HouseKeeper.xcodeproj'. See https://guides.cocoapods.org/using/using-cocoapods.html
		- Open resulting 'HouseKeeper.xcworkspace' file in xCode
- RUNNING APPLICATION
	- Click the Play Button in the upper-left corner of the xCode interface