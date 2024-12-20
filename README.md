# Flutter Accura Scan MICR

Accura Scan MICR SDK accurately and robustly extracts MICR data from cheques with precision and reliability.


Below steps to setup Accura Scan's SDK to your project.

## Note:-
Add `flutter_accurascan_kyc: 4.2.2-MICR` under dependencies in your pubspec.yaml file.
**Usage**
Import flutter library into file.
`import 'package:flutter_accurascan_kyc/flutter_accurascan_kyc.dart';`

## 1.Setup Android

**Add this permissions into Android’s AndroidManifest.xml file.**

```
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```

**Add it in your root build.gradle at the end of repositories.**

```
allprojects {
    repositories {
        google()
        jcenter()
        maven {
            url 'https://jitpack.io'
        }
    }
}
```

**Add it in your app/build.gradle file.**

```
packagingOptions {
   pickFirst 'lib/arm64-v8a/libcrypto.so'
   pickFirst 'lib/arm64-v8a/libssl.so'
   
   pickFirst 'lib/armeabi-v7a/libcrypto.so'
   pickFirst 'lib/armeabi-v7a/libssl.so'
   
   pickFirst 'lib/x86/libcrypto.so'
   pickFirst 'lib/x86/libssl.so'
   
   pickFirst 'lib/x86_64/libcrypto.so'
   pickFirst 'lib/x86_64/libssl.so'
   
}
```

## 2.Setup iOS

1.Install Git LFS using command install `git-lfs`

## Note:-
Minimum platform should be 15.5 in podfile `platform :ios, '15.5'`.

2.Run `pod install`

**Add this permissions into iOS Info.plist file.**

```
<key>NSCameraUsageDescription</key>
<string>App usage camera for scan documents.</string>
```

## 3.Setup Accura Scan licenses into your projects

Accura Scan has two license require for use full functionality of this library. Generate your own Accura license from here
**key-micr.license**

This license is compulsory for this library to work. it will get all setup of accura SDK.


**For Android**

```
Create "assets" folder under app/src/main and Add license file in to assets folder.
- key-micr.license // for Accura Scan OCR

```
**For iOS**
```
Place the license in your project's Runner directory, and add the licenses to the target.
```



## 4.Get license configuration from SDK. It returns all active functionalities of your license.

### Setting up License
```
  Future<void> getMetaData() async{
    try {
      await AccuraOcr.getMetaData().then((value) =>
          setupConfigData(json.decode(value)));
    }on PlatformException{}
    if (!mounted) return;
  }
```


**Error:** String

**Success:** JSON String Response = {

isMICREnable: boolean

}

### Setting up Configuration's,Error mssages and Scaning title messages

```
 Future<void> setAccuraConfig() async{
    try {

      await AccuraOcr.setLowLightTolerance(10);
      await AccuraOcr.setMinGlarePercentage(6);
      await AccuraOcr.setMaxGlarePercentage(99);
      await AccuraOcr.setBlurPercentage(60);


      await AccuraOcr.ACCURA_ERROR_CODE_MOTION("Keep Document Steady");
      await AccuraOcr.ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME("Keep document in frame");
      await AccuraOcr.ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME("Bring card near to frame");
      await AccuraOcr.ACCURA_ERROR_CODE_PROCESSING("Processing");
      await AccuraOcr.ACCURA_ERROR_CODE_BLUR_DOCUMENT("Blur detect in document");
      await AccuraOcr.ACCURA_ERROR_CODE_GLARE_DOCUMENT("Glare detect in document");
      await AccuraOcr.ACCURA_ERROR_CODE_WRONG_SIDE("Scanning wrong side of Document");
      await AccuraOcr.SCAN_TITLE_MICR("Scan MICR");
      await AccuraOcr.ACCURA_ERROR_CODE_MICR_IN_FRAME("Keep MICR in Frame");
      await AccuraOcr.ACCURA_ERROR_CODE_CLOSER("Move phone Closer");
      await AccuraOcr.ACCURA_ERROR_CODE_AWAY("Move phone Away");
      await AccuraOcr.CameraScreen_CornerBorder_Enable(true);
      await AccuraOcr.CameraScreen_Border_Width(15);
     
      await AccuraOcr.CameraScreen_CornerBorder_Enable(false);
      await AccuraOcr.CameraScreen_Border_Width(15);
      await AccuraOcr.CameraScreen_Color("#80000000");   //Pass empty string for clear color else pass the Hex code e.g, #FFFFFF.
      await AccuraOcr.CameraScreen_Back_Button(1); //For iOS disable the back button by Passing 0.
      
      await AccuraOcr.CameraScreen_Frame_Color("#D5323F"); //Pass a Hex Code to change the color of the frame.
      await AccuraOcr.CameraScreen_Text_Border_Color("#000000"); //Pass a Hex Code to change the color of the text border pass empty string to disable it.
      await AccuraOcr.CameraScreen_Text_Color("#FFFFFF"); //Pass a Hex Code to change the color of the text.

      await AccuraOcr.setAccuraConfigs();

    }on PlatformException{}
  }
  
```

### Scan MICR

```
 Future<void> startMICRCard() async {
    try {

      await AccuraOcr.startMICR().then((value) => {
        setState(() {
           dynamic result = json.decode(value);
      });
    } on PlatformException catch (e) {
      print("Error starting MICR card: $e");
    }
  }
```
Success: JSON Response {

front_data: JSONObjects?,

type: Recognition Type,

front_img: URI?

}

Error: String
