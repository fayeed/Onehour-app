<div align="center">
  <div style="display: flex; align-items: center; width: 300px; justify-content: space-around;">
    <img src="https://i.imgur.com/RSILLox.png" width="80" height="80" />
    <h1 align="center" style="font-size: 48px;">Onehour</h1>
  </div>
  <h2 align="center">A time tracking app build using Flutter</h2>
</div>

## Screens

| First Header                              | Second Header                             |
| ----------------------------------------- | ----------------------------------------- |
| ![Imgur](https://i.imgur.com/up6aTDt.png) | ![Imgur](https://i.imgur.com/Xyz125b.png) |
| ![Imgur](https://i.imgur.com/ajovytu.png) | ![Imgur](https://i.imgur.com/Fc43Bdj.png) |
| ![Imgur](https://i.imgur.com/l9rMYHO.png) | ![Imgur](https://i.imgur.com/SaBkfNo.png) |
| ![Imgur](https://i.imgur.com/7zWX4QW.png) | ![Imgur](https://i.imgur.com/WoFmumm.png) |

## Tech Stack
- Flutter
- Flutter Bloc with Hydrated Bloc
- Firebase
- Admob

## Features
- Track time for all your task.
- Offline Support.
- Social Logins (Google, Facebook)
- Light & Dark theme support.
- Ads configured using remote config.

## Getting Started
1. [Fork repository](https://github.com/fayeed/Onehour-app/fork) and clone your fork locally
1. Install [Flutter 1.7.8](https://flutter.dev/docs/get-started/install)
1. Install [Android Studio / IntelliJ / VSCode](https://flutter.dev/docs/development/tools/android-studio)
1. [Preparing Release for Android](https://flutter.dev/docs/deployment/android)
1. [Preparing Release for iOS](https://flutter.dev/docs/deployment/ios)

## Building the project



## Android

### Missing Key.Properties file

If you try to build the project straight away, you'll get an error complaining that a `key.properties` file is missing and Exit code 1 from: /Onehour-appp/android/gradlew app:properties:. To resolve that,

1. Follow this guide to [Generate Keystor](https://flutter.dev/docs/deployment/android#create-a-keystore) and then move it to [Onehour-appp/android/app](https://github.com/fayeed/Onehour-app/blob/master/android/app)

2. Open [Onehour-appp/android](https://github.com/fayeed/Onehour-app/blob/master/android/) and create a new file `key.properties` and your key info:

```
storePassword=STORE_PASSWORD
keyPassword=KEY_PASSWORD
keyAlias=key
storeFile=key.jks
```

3. Integrate Firebase for [Android](https://firebase.google.com/docs/flutter/setup?platform=android)

4. Open [AndroidManifest.xml](https://github.com/fayeed/onehour/blob/master/android/app/src/main/AndroidManifest.xml) and replace `ADMOB_ID` with your id.
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ADMOB_ID"/>
```

5. Open [strings.xml](https://github.com/fayeed/onehour/blob/master/android/app/src/main/res/values/strings.xml) and replace `0000000000` with your id.

```xml
    <!-- Replace "000000000000" with your Facebook App ID here. -->
    <string name="facebook_app_id">000000000000</string>

    <!--
      Replace "000000000000" with your Facebook App ID here.
      **NOTE**: The scheme needs to start with `fb` and then your ID.
    -->
    <string name="fb_login_protocol_scheme">fb000000000000</string>
```


## IOS

1. Integrate Firebase for [IOS](https://firebase.google.com/docs/flutter/setup)

2. Open [Info.plist](https://github.com/fayeed/onehour/blob/master/ios/Runner/Info.plist) replace `REVERSED_CLIENT_ID`,

```xml
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
			    <!--
                              Replace "000000000000" with your Facebook App ID here.
                              **NOTE**: The scheme needs to start with `fb` and then your ID.
                            -->
				<string>fb000000000000</string>
				<!--Replace REVERSED_CLIENT_ID with your googleservice.plist REVERSED_CLIENT_ID-->
				<string>REVERSED_CLIENT_ID</string>
			</array>
		</dict>
	</array>

	<!--Replace 000000000000 with your facebook app id-->
	<key>FacebookAppID</key>
	<string>000000000000</string>

	<!--Replace FACEBOOK_DISPLAY_NAME with your facebook display name -->
	<key>FacebookDisplayName</key>
	<string>FACEBOOK_DISPLAY_NAME</string>

	<!--Replace 00000ADMOB_ID0000000 with your admob id-->
	<key>GADApplicationIdentifier</key>
	<string>ADMOB_ID</string>
```

## Contributing

Awesome! Contributions of all kinds are greatly appreciated. To help smoothen the process we have a few non-exhaustive guidelines to follow which should get you going in no time.

### Using GitHub Issues

- Feel free to use GitHub issues for questions, bug reports, and feature requests
- Use the search feature to check for an existing issue
- Include as much information as possible and provide any relevant resources (Eg. screenshots)

## License

Project is published under the [MIT license](/LICENSE.md).
Feel free to clone and modify repo as you want, but don't forget to add reference to authors :)
