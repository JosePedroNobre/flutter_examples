**Project information**

 - `BLOC` and `repository` pattern
 - Simplified models according to the best practices by google on documentation (https://flutter.dev/docs/development/data-and-backend/json)
      - Generate models in the code by running (`flutter pub run build_runner build`) (1)
      - Clean models ( `flutter packages pub run build_runner build --delete-conflicting-outputs`)

**After opening the project for the first time or if Pubspec is updated do:**

   1) `flutter pub get`

RELEASES

**Run app in dev** 
`flutter run lib/env/main_dev.dart`  

**Run app in qa** 
`flutter run lib/env/main_uat.dart`  

**Run app in prod** 
`flutter run lib/env/main_prod.dart`  

**Run app in storeTest** 
`flutter run lib/env/main_store_test.dart`  

**Make dev buid**
`flutter build apk lib/env/main_dev.dart`

**Make storeTest buid**
`flutter build apk lib/env/main_store_test.dart`

 **Make qa build**
`flutter build apk lib/env/main_uat.dart`

 **Make prod build**
`flutter build apk lib/env/main_prod.dart`

 **Release android build to firebase**
 1) `firebase login [install firebase CLI if needed]`
 2) `cd android then ... fastlane deploy`

 **Notes Android Fastlane**

To use increment_version_code on android fastlane we needed this plugin :  `https://github.com/Jems22/fastlane-plugin-increment_version_code`

To use firebase_app_distribution on android fastlane we needed this plugin :  `https://firebase.google.com/docs/app-distribution/ios/distribute-fastlane`
