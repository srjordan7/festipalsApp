# festipals

## Description
festipals is an iOS app that allows you to plan out your concert/festival day easily by keeping all information in one place.

## Features
* Create a new event and input basic information
* Upload photos of setlists and view them sorted in order by day
* Upload photo of venue map and add a meeting location for end of day
* Add who you're attending with and their contact information to easily keep up

## Dependencies
### Backend/Database - Google Firebase
  * Firebase Auth for user accounts
  * Firestore Database for database
  * Firebase Storage for image storage and retreival
### Frontend/UI - SwiftUI

## Installation
### Xcode
Xcode is the software used to create applications for Apple operating systems. It is available for free through the Mac App Store or through the [Apple website](https://developer.apple.com/download/all/?q=Xcode).

* Download Xcode to your computer
* Fork the festipals repo to your Github account
* Copy the URL of your fork
* Click on 'Clone and existing project' when opening Xcode and paste the URL of the repo
* Press 'Clone' and save to your local device

### Firebase
Firebase is a backend-as-a-service provided by Google. festipals comes already registered to Firebase.

* Confirm the GoogleService-Info.plist file is present in the festipals root folder.

### Running festipals - Xcode simulator
To run festipals through the simulator provided by Xcode, simply press the play button in the upper left menu bar.

### Running festipals - iOS device
* On your iOS device, ensure you are running development mode
  * In the 'Settings' app, navigate to 'Privacy & Security'
  * Scroll to the bottom and select 'Developer Mode' under 'Security'
  * Switch 'Developer Mode' on
  
* Within Xcode, navigate to the festipals root folder
* Choose the festipals target under the 'Targets' column
* Navigate to the 'Signing & Capabilities' menu
* Click the 'Team' selector and select your account if shown, otherwise select 'Add an Account..."
  * Sign in or create an Apple ID
  
* When you are ready to deploy, plug in your iPhone to your computer
  * Unlock your iOS device and wait for your device to load
  * In Xcode, under the device selector at the top, select your iOS device
  * Press the play button and wait for festipals to download to you iOS device
  * Once downloaded, you may unplug your iOS device
    * Redo deployment process when wanting to test changes to app
