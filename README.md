# Kindred - Family App

This project has dependencies that can be installed from Cocoapods. If you don't have the package manager installed, follow the guide here https://cocoapods.org/

```
git clone https://github.com/brpowell/familyapp
cd familyapp
pod install
```

## Building the Project
Open Xcode and open the newly generated `FamilyApp.xcworkspace`, DO NOT OPEN `FamilyApp.xcodeproj`.

Click on the blue 'FamilyApp' file on the left. Go to build settings and search for 'Legacy'.
Set 'Use Legacy Swift Language Version' to no.

Click on the blue 'Pods' file on the left. Go to build settings and search for 'Legacy'.
Set 'Use Legacy Swift Language Version' to no.

Please use iPhone 6 to build.


## Signing In
Registration will break if a password of less than 6 characters is used. It will also break if a profile image is not chosen in the following registration screen.
Alternatively, you can login with the following login information. <br><br>

Username - professor@yahoo.com<br>
Password - 123456<br>
