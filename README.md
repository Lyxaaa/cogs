# Team Theta DECO3500 Project
### Wiki Outline
[General Overview (Home)](../../wiki)  
[Design Process Overview](../../wiki/Design-Process-Overview)  

## Deployment Instructions
### Web Access
You can access the latest build at either [Host A](https://distraction-destruction.web.app/#/) or [Host B](https://distraction-destruction.firebaseapp.com/)

### Login Credentials
You can sign up using your own account.
If you do not want to sign up, below are 2 profiles you can use:

The following credentials will log you into Tom's account
Usename: test@a.com
Password: password

The following credentials will log you into Hannah's account
Username: test@b.com
Password: password

### testing main functionality
1. navigate to the friend's page
2. click on the desired friend to start a session
3. set time and amount of breaks
4. wait for invitation to be accepted

If on Tom's account you may wish to start a session with Hannah's account, then accept the request to start a session on Hannah's account

### Installing Flutter
https://flutter.dev/docs/get-started/install  
From this link, make sure to download flutter v2.5.x

Follow the instructions until...  
> `flutter doctor`  
 
At this point, consider which IDE you’ll work in: Android Studio, or Visual Studio Code.

Android Studio is more established.
Visual Studio Code is newly supported.
___
### Obtaining the Android SDK

_**a.**_ With Android Studio:  
_https://developer.android.com/studio/intro/update#sdk-manager_

_**b.**_ If not running Android Studio, you will need to download the Android SDK manually.  
_https://developer.android.com/studio#command-tools_

1. Move the download to a preferred <location>  
(E.g., a directory for development tools.)  
1. Create a directory structure like so: <location>\android-sdk\cmdline-tools\  
1. Enter the directory.  
1. Unpack the download, renaming the folder from cmdline-tools to latest  
The directory structure should now look like: <location>\android-sdk\cmdline-tools\latest  
1. Add the environment variables:
   ```bash
   ANDROID_SDK_ROOT  <location>\android-sdk  
   ANDROID_HOME      <location>\android-sdk
   ```
1. In a terminal, **cd** into `latest/bin` folder. Run the following command.  
 
   ```bash
   sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"
   ```
1. Return to the original instructions, continuing at flutter doctor
 
### Android Installation
[Official Documentation on Device Installation](https://flutter.dev/docs/deployment/android)  
 `cd project-directory-root`  
 `flutter build apk --split-per-abi`  
 Ensure your android device is plugged in  
 `flutter install`  

### Tutorials
https://flutter.dev/docs/get-started/codelab
 
