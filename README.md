# team-theta
repo for Team Theta DECO3500 Project, Semester 2 2021

## Installation
### Installing Flutter
https://flutter.dev/docs/get-started/install
From this link, make sure to download flutter v2.5.x

Follow the instructions until... 
 flutter doctor  
At this point, consider which IDE you’ll work in: Android Studio, or Visual Studio Code.

Android Studio is more established.
Visual Studio Code is newly supported.

### Obtaining the Android SDK
With Android Studio: https://developer.android.com/studio/intro/update#sdk-manager

If not running Android Studio, you will need to download the Android SDK manually. https://developer.android.com/studio#command-tools

Move the download to a preferred <location>
(E.g., a directory for development tools.)
Create a directory structure like so: <location>\android-sdk\cmdline-tools\
Enter the directory.
Unpack the download, renaming the folder from cmdline-tools to latest
The directory structure should now look like: <location>\android-sdk\cmdline-tools\latest
Add the environment variables:
ANDROID_SDK_ROOT  <location>\android-sdk
ANDROID_HOME <location>\android-sdk
In a terminal, cd into latest/bin folder.
Run the following command.
sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"

Return to the original instructions, continuing at flutter doctor

## Tutorials
https://flutter.dev/docs/get-started/codelab
