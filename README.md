# Flutter Accura Scan MICR



## Note:-
Add `flutter_accurascan_micr` under dependencies in your pubspec.yaml file.
**Usage**
Import flutter library into file.
`import 'package:flutter_accurascan_micr/flutter_accurascan_micr.dart';`

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
           credentials { username 'jp_ssguccab6c5ge2l4jitaj92ek2' }
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

        pickFirst 'lib/arm64-v8a/libc++_shared.so'
        pickFirst 'lib/arm64-v8a/libopencv_java4.so'

        pickFirst 'lib/armeabi-v7a/libc++_shared.so'
        pickFirst 'lib/armeabi-v7a/libopencv_java4.so'

        pickFirst 'lib/x86/libc++_shared.so'
        pickFirst 'lib/x86/libopencv_java4.so'

        pickFirst 'lib/x86_64/libc++_shared.so'
        pickFirst 'lib/x86_64/libopencv_java4.so'
    }
```

## 2.Setup iOS

1.Install Git LFS using command install `git-lfs`

2.Run `pod install`

**Add this permissions into iOS Info.plist file.**

```
<key>NSCameraUsageDescription</key>
<string>App usage camera for scan documents.</string>
```

## 3.Setup Accura Scan licenses into your projects

Accura Scan has two license require for use full functionality of this library. Generate your own Accura license from here
**key.license**

This license is compulsory for this library to work. it will get all setup of accura SDK.


**For Android**

```
Create "assets" folder under app/src/main and Add license file in to assets folder.
- key.license // for Accura Scan OCR
```
**For iOS**
```
Place the key.license in your project's Runner directory, and add the licenses to the target.
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

**isValid:** boolean,

**isMICR:** boolean

}

### Setting up Configuration's,Error mssages and Scaning title messages

```
  Future<void> setAccuraConfig() async{
    try {
      await AccuraOcr.setLowLightTolerance(10);
      await AccuraOcr.setMotionThreshold(25);
      await AccuraOcr.setMinGlarePercentage(6);
      await AccuraOcr.setMaxGlarePercentage(99);
      await AccuraOcr.setBlurPercentage(60);
      await AccuraOcr.setCameraFacing(0);

      await AccuraOcr.SCAN_TITLE_MICR("Scan Cheque");=

      await AccuraOcr.ACCURA_ERROR_CODE_MOVE_AWAY("Move Phone Away");
      await AccuraOcr.ACCURA_ERROR_CODE_MOVE_CLOSER("Move Phone Closer");
      await AccuraOcr.ACCURA_ERROR_CODE_KEEP_MICR_IN_FRAME("Keep MICR in Frame");
      await AccuraOcr.ACCURA_ERROR_CODE_MOTION("Keep Document Steady");
      await AccuraOcr.ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME("Keep document in frame");
      await AccuraOcr.ACCURA_ERROR_CODE_PROCESSING("Processing");
      await AccuraOcr.ACCURA_ERROR_CODE_BLUR_DOCUMENT("Blur detect in document");
      await AccuraOcr.ACCURA_ERROR_CODE_GLARE_DOCUMENT("Glare detect in document");
      await AccuraOcr.ACCURA_ERROR_CODE_DARK_DOCUMENT("Low lighting detected");
      await AccuraOcr.isShowLogo(1);

      await AccuraOcr.CameraScreen_Color("#80000000");   //Pass empty string for clear color else pass the Hex code e.g, #FFFFFF.
      await AccuraOcr.CameraScreen_Back_Button(1); //For iOS disable the back button by Passing 0.
      await AccuraOcr.CameraScreen_Change_Button(1); //To disable flip camera button pass 0.
      await AccuraOcr.CameraScreen_Frame_Color("#D5323F"); //Pass a Hex Code to change the color of the frame.
      await AccuraOcr.CameraScreen_Text_Border_Color("#000000"); //Pass a Hex Code to change the color of the text border pass empty string to disable it.
      await AccuraOcr.CameraScreen_Text_Color("#FFFFFF"); //Pass a Hex Code to change the color of the text.

      await AccuraOcr.setAccuraConfigs();

    }on PlatformException{}
  }
  
```

## 5.Method for scan MICR documents.

   ```
Future<void> startMICR() async {
 try {
   var config = [
     micrselected,
   ];
   await AccuraOcr.startMICR(config)
       .then((value) => {
     setState((){
       dynamic result = json.decode(value);
     })
   }).onError((error, stackTrace) => {
   });
 } on PlatformException {}
}
```

**MICRType:** String

#### value: e13b or cmc7<br></br>

**Success:** JSON Response {

**front_data:** JSONObjects?,

**front_img:** URI?

}

**Error:** String


Contributing
See the contributing guide to learn how to contribute to the repository and the development workflow.

License:
MIT

