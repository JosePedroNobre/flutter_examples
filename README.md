**Project information**

 - `BLOC` and `repository` pattern
 - Simplified models according to the best practices by google on documentation (https://flutter.dev/docs/development/data-and-backend/json)
      - Generate models in the code by running (`flutter pub run build_runner build`) (1)
      - Clean models ( `flutter packages pub run build_runner build --delete-conflicting-outputs`)

**After opening the project for the first time or if Pubspec is updated do:**

   1) `flutter pub get`
   2) `sudo gem install cocoapods`
   3) `pod install`
   4) cd ios and then `pod install`

RELEASES

**Run app dev** 
`flutter run lib/env/main_dev.dart`  

**Run app qa** 
`flutter run lib/env/main_uat.dart`  

**Run app prod** 
`flutter run lib/env/main_prod.dart`  

**Make dev buid**
 1) `flutter build ios lib/env/main_dev.dart`
 2) `flutter build apk lib/env/main_dev.dart`

 **Make qa build**
 1) `flutter build ios lib/env/main_uat.dart`
 2) `flutter build apk lib/env/main_uat.dart`

 **Make prod build**
 1) `flutter build ios lib/env/main_prod.dart`
 2) `flutter build apk lib/env/main_prod.dart`

 **Release android build to firebase**
 1) `firebase login [install firebase CLI if needed]`
 2) `cd android then ... fastlane deploy`
 
 **Release ios build to Test Flight**
 1) `cd ios`
 2) `fastlane deploy and follow steps`

 **Notes Android Fastlane**

  To use increment_version_code on android fastlane we needed this plugin :  `https://github.com/Jems22/fastlane-plugin-increment_version_code`   
  
  To use firebase_app_distribution on android fastlane we needed this plugin :  `https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane`

 **Notes iOS Fastlane**

  All methods already come built in with the fastlane library, it's necessary to have the developer certificate in our personal computer. A key was added here [https://appleid.apple.com/] in order to use third party libraries to deploy to test flight. 
