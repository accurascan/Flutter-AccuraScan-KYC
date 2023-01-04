# Flutter Kyc

Add `accura_sdk: ^0.0.1` under dependencies in your pubspec.yaml file.


Accura OCR is used for Optical character recognition.

Accura Face Match is used for Matching 2 Faces, Source face and Target face. It matches the User Image from a Selfie vs User Image in document.

Accura Authentication is used for your customer verification and authentication. Unlock the True Identity of Your Users with 3D Selfie Technology


Below steps to setup Accura's SDK to your project.



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
   
}
```

## 2.Setup iOS

1.Install Git LFS using command install `git-lfs`

2.Run `pod install`

**Add this permissions into iOS Info.plist file.**

```
<key>NSCameraUsageDescription</key>
<string>App usage camera for scan documents.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>App usage photos for get document picture.</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>App usage photos for save document picture.</string>
```

## 3.Setup AccuraScan licenses into your projects

Accura has two license require for use full functionality of this library. Generate your own Accura license from here
**key.license**

This license is compulsory for this library to work. it will get all setup of accura SDK.

**accuraface.license**

This license is use for get face match percentages between two face pictures.
And also for Passive Liveness.

**For Android**

```
Create "assets" folder under app/src/main and Add license file in to assets folder.
- key.license // for Accura OCR
- accuraface.license // for Accura Face Match
Generate your Accura license from https://accurascan.com/developer/dashboard
```
**For iOS**
```
Place both the license in your project's directory, and add the licenses to the target.
```

**Usage**

Import flutter library into file.
import 'package:accura_sdk/accura_sdk.dart';



## 4.Get license configuration from SDK. It returns all active functionalities of your license.

```
 Future<void> getMetaData() async{
    try {

      await AccuraSdk.setFaceBlurPercentage(80);
      await AccuraSdk.setHologramDetection(true);
      await AccuraSdk.setLowLightTolerance(10);
      await AccuraSdk.setMotionThreshold(25);
      await AccuraSdk.setMinGlarePercentage(6);
      await AccuraSdk.setMaxGlarePercentage(99);
      await AccuraSdk.setBlurPercentage(60);
      await AccuraSdk.setCameraFacing(0);
      await AccuraSdk.isCheckPhotoCopy(false);

      await AccuraSdk.SCAN_TITLE_OCR_FRONT("Scan Front side of ");
      await AccuraSdk.SCAN_TITLE_OCR_BACK("Scan Back side of ");
      await AccuraSdk.SCAN_TITLE_OCR("Scan ");
      await AccuraSdk.SCAN_TITLE_MRZ_PDF417_FRONT("Scan Front Side of Document");
      await AccuraSdk.SCAN_TITLE_MRZ_PDF417_BACK("Scan Back Side of Document");
      await AccuraSdk.SCAN_TITLE_DLPLATE("Scan Number plate");
      await AccuraSdk.SCAN_TITLE_BARCODE("Scan Barcode");
      await AccuraSdk.SCAN_TITLE_BANKCARD("Scan BankCard");


      await AccuraSdk.ACCURA_ERROR_CODE_MOTION("Keep Document Steady");
      await AccuraSdk.ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME("Keep document in frame");
      await AccuraSdk.ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME("Bring card near to frame");
      await AccuraSdk.ACCURA_ERROR_CODE_PROCESSING("Processing");
      await AccuraSdk.ACCURA_ERROR_CODE_BLUR_DOCUMENT("Blur detect in document");
      await AccuraSdk.ACCURA_ERROR_CODE_FACE_BLUR("Blur detected over face");
      await AccuraSdk.ACCURA_ERROR_CODE_GLARE_DOCUMENT("Glare detect in document");
      await AccuraSdk.ACCURA_ERROR_CODE_HOLOGRAM("Hologram Detected");
      await AccuraSdk.ACCURA_ERROR_CODE_DARK_DOCUMENT("Low lighting detected");
      await AccuraSdk.ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT("Can not accept Photo Copy Document");
      await AccuraSdk.ACCURA_ERROR_CODE_FACE("Face not detected");
      await AccuraSdk.ACCURA_ERROR_CODE_MRZ("MRZ not detected");
      await AccuraSdk.ACCURA_ERROR_CODE_PASSPORT_MRZ("Passport MRZ not detected");
      await AccuraSdk.ACCURA_ERROR_CODE_ID_MRZ("ID MRZ not detected");
      await AccuraSdk.ACCURA_ERROR_CODE_VISA_MRZ("Visa MRZ not detected");
      await AccuraSdk.ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE("Document is upside down. Place it properly");
      await AccuraSdk.ACCURA_ERROR_CODE_WRONG_SIDE("Scanning wrong side of Document");
      await AccuraSdk.isShowLogo(0);

      await AccuraSdk.getMetaData().then((value) =>
          dynamic result = json.decode(value);
    }on PlatformException{}
    if (!mounted) return;
  }
```


**Error:** String

**Success:** JSON String Response = {

**countries:** Array[<CountryModels>],

**barcodes:** Array[],

**isValid:** boolean,

**isOCREnable:** boolean,

**isBarcodeEnable:** boolean,

**isBankCardEnable:** boolean,

**isMRZEnable:** boolean

}

## 5.Method for scan MRZ documents.

   ```
Future<void> startMRZ() async {
 try {
   var config = [
     {"enableLogs": false},
     mrzselected,
   ];
   await AccuraSdk.startMRZ(config)
       .then((value) => {
     setState((){
       dynamic result = json.decode(value);
     })
   }).onError((error, stackTrace) => {
   });
 } on PlatformException {}
}
```

**MRZType:** String

#### value: other_mrz or passport_mrz or id_mrz or visa_mrz<br></br>
**CountryList:** String

**value:** all or IND,USA

**Success:** JSON Response {

**front_data:** JSONObjects?,

**back_data:** JSONObjects?,

**type:** Recognition Type,

**face:** URI?

**front_img:** URI?

**back_img:** URI?

}


**Error:** String

## 6.Method for scan OCR documents.
   ```
Future<void> startOCR() async {
 try {
   var config = [
     {"enableLogs": false},
     widget.countrySelect['id'],
     cardSelected['id'],
     cardSelected['name'],
     cardSelected['type'],
   ];
   await AccuraSdk.startOcrWithCard(config)
       .then((value) =>
   {
     setState(() {
       dynamic result = json.decode(value);
     })
   })
       .onError((error, stackTrace) =>
   {
   });
 } on PlatformException {}
}
```

**CountryId:** integer

**value:** Id of selected country.

**CardId:** integer

**value:** Id of selected card.

**CardName:** String

**value:** Name of selected card.

**CardType:** integer

**value:** Type of selected card.

**Success:** JSON Response {
}

**Error:** String

## 7.Method for scan barcode.
   ```
Future<void> startBarcode() async{
 var config= barcodeSelected;
 await AccuraSdk.startBarcode([config]).then((value) => {
   setState((){
     dynamic result = json.decode(value);
   })
 });
}
```

**BarcodeType:** String

**value:** Type of barcode documents.

**Success:** JSON Response {
}

**Error:** String


## 8.Method for scan bankcard.
   ```
Future<void> startBankCard() async{
   
 try{
   await AccuraSdk.startBankCard().then((value) => {
     setState((){
       dynamic result = json.decode(value);
     })
   });
 }on PlatformException{}
}
   ```

**Success:** JSON Response {
}

**Error:** String

## 8.Method for get face match percentages between two face.
   ```
Future<void> startFaceMatch() async{
 SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
 try{
   var accuraConfs = {
     "face_uri":this.faceMatchURL
   };

   await AccuraSdk.setFaceMatchFeedbackTextSize(18);
   await AccuraSdk.setFaceMatchFeedBackframeMessage("Frame Your Face");
   await AccuraSdk.setFaceMatchFeedBackAwayMessage("Move Phone Away");
   await AccuraSdk.setFaceMatchFeedBackOpenEyesMessage("Keep Your Eyes Open");
   await AccuraSdk.setFaceMatchFeedBackCloserMessage("Move Phone Closer");
   await AccuraSdk.setFaceMatchFeedBackCenterMessage("Move Phone Center");
   await AccuraSdk.setFaceMatchFeedbackMultipleFaceMessage("Multiple Face Detected");
   await AccuraSdk.setFaceMatchFeedBackFaceSteadymessage("Keep Your Head Straight");
   await AccuraSdk.setFaceMatchFeedBackLowLightMessage("Low light detected");
   await AccuraSdk.setFaceMatchFeedBackBlurFaceMessage("Blur Detected Over Face");
   await AccuraSdk.setFaceMatchFeedBackGlareFaceMessage("Glare Detected");
   await AccuraSdk.setBlurPercentage(80);
   await AccuraSdk.setFaceMatchGlarePercentage_0(-1);
   await AccuraSdk.setFaceMatchGlarePercentage_1(-1);
   await AccuraSdk.startFaceMatch([accuraConfs])
       .then((value) => {
     setState((){
       dynamic result = json.decode(value);
     })
   }).onError((error, stackTrace) => {
   });
 }on PlatformException{}
}
```

**accuraConfs:** JSON Object

**face_uri:** URI


**Success:** JSON Response {
detect: URI?
score: Float
}

**Error:** String


## 9.Method for liveness check.

   ```
Future<void> startLiveness() async{
 SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
 try{
   var accuraConfs = {
     "face_uri":this.faceMatchURL
   };

   await AccuraSdk.setLivenessFeedbackTextSize(18);
   await AccuraSdk.setLivenessFeedBackframeMessage("Frame Your Face");
   await AccuraSdk.setLivenessFeedBackAwayMessage("Move Phone Away");
   await AccuraSdk.setLivenessFeedBackOpenEyesMessage("Keep Your Eyes Open");
   await AccuraSdk.setLivenessFeedBackCloserMessage("Move Phone Closer");
   await AccuraSdk.setLivenessFeedBackCenterMessage("Move Phone Closer");
   await AccuraSdk.setLivenessFeedbackMultipleFaceMessage("Multiple Face Detected");
   await AccuraSdk.setLivenessFeedBackFaceSteadymessage("Keep Your Head Straight");
   await AccuraSdk.setLivenessFeedBackBlurFaceMessage("Blur Detected Over Face");
   await AccuraSdk.setLivenessFeedBackGlareFaceMessage("Glare Detected");
   await AccuraSdk.setLivenessBlurPercentage(80);
   await AccuraSdk.setLivenessGlarePercentage_0(-1);
   await AccuraSdk.setLivenessGlarePercentage_1(-1);
   await AccuraSdk.setLivenessFeedBackLowLightMessage("Low light detected");
   await AccuraSdk.setLivenessfeedbackLowLightTolerence(39);
   await AccuraSdk.setLivenessURL("https://accurascan.com:8443");

   await AccuraSdk.startLiveness([accuraConfs])
       .then((value) => {
     setState((){
       dynamic result = json.decode(value);
     })
   }).onError((error, stackTrace) => {
   });
 }on PlatformException{}
}
```

**accuraConfs:** JSON Object

**face_uri:** 'uri of face'


**Success:** JSON Response {

detect: URI?,

Face_score: Float,

score: Float,

}

**Error:** String


## 10.Method for Only Facematch.(The following are Optional methods, Use if you need only FaceMatch)
### To Open Gallery 1 and 2:-

_For gallery 1_

   ```
  Future<void> openGallery() async{
    try{
      var accuraConfs = {
        "face1": this.facematchURI,
        "face2": this.facematchURI2
      };

      await AccuraSdk.getGallery1([accuraConfs]).then((value) => {
        setState(() {
          dynamic result = json.decode(value);
          facematchURI =  result["Image"];
          if( result.toString().contains("score")){
            Score =  result["score"];
          }
          print("RESULT:- $ result");
        })
      }).onError((error, stackTrace)=>{});
    } on PlatformException {}
    if(!mounted) return;
  }
```

_For gallery 2_
```
  Future<void> openGallery2() async{
    try{
      var accuraConfs = {
        "face1": this.facematchURI,
        "face2": this.facematchURI2
      };
      await AccuraSdk.getGallery2([accuraConfs]).then((value) => {
        setState(() {
         dynamic result = json.decode(value);
          facematchURI2 = result["Image"];
          if(result.toString().contains("score")){
            Score = result["score"];
          }
          print("RESULT:- $result");
        })
      }).onError((error, stackTrace)=>{});
    } on PlatformException {}
    if(!mounted) return;
  }
```

### To Open Camera for Facematch 1 and 2:

_For Facematch 1:_
```
  Future<void> openCamera() async{
    try{
      var accuraConfs = {
        "face1": this.facematchURI,
        "face2": this.facematchURI2
      };
      await AccuraSdk.setFaceMatchFeedbackTextSize(18);
      await AccuraSdk.setFaceMatchFeedBackframeMessage("Frame Your Face");
      await AccuraSdk.setFaceMatchFeedBackAwayMessage("Move Phone Away");
      await AccuraSdk.setFaceMatchFeedBackOpenEyesMessage("Keep Your Eyes Open");
      await AccuraSdk.setFaceMatchFeedBackCloserMessage("Move Phone Closer");
      await AccuraSdk.setFaceMatchFeedBackCenterMessage("Move Phone Center");
      await AccuraSdk.setFaceMatchFeedbackMultipleFaceMessage("Multiple Face Detected");
      await AccuraSdk.setFaceMatchFeedBackFaceSteadymessage("Keep Your Head Straight");
      await AccuraSdk.setFaceMatchFeedBackLowLightMessage("Low light detected");
      await AccuraSdk.setFaceMatchFeedBackBlurFaceMessage("Blur Detected Over Face");
      await AccuraSdk.setFaceMatchFeedBackGlareFaceMessage("Glare Detected");
      await AccuraSdk.setBlurPercentage(80);
      await AccuraSdk.setFaceMatchGlarePercentage_0(-1);
      await AccuraSdk.setFaceMatchGlarePercentage_1(-1);

      await AccuraSdk.getCamera1([accuraConfs]).then((value) => {
        setState(() {
          dynamic result = json.decode(value);
          facematchURI = result["Image"];
          if(result.toString().contains("score")){
            Score = result["score"];
          }
          print("RESULT:- $result");
        })
      });
    } on PlatformException {}
    if(!mounted) return;
  }
```

_For Facematch 2_

```
  Future<void> openCamera2() async{
    try{
      var accuraConfs = {
        "face1": this.facematchURI,
        "face2": this.facematchURI2
      };

      await AccuraSdk.setFaceMatchFeedbackTextSize(18);
      await AccuraSdk.setFaceMatchFeedBackframeMessage("Frame Your Face");
      await AccuraSdk.setFaceMatchFeedBackAwayMessage("Move Phone Away");
      await AccuraSdk.setFaceMatchFeedBackOpenEyesMessage("Keep Your Eyes Open");
      await AccuraSdk.setFaceMatchFeedBackCloserMessage("Move Phone Closer");
      await AccuraSdk.setFaceMatchFeedBackCenterMessage("Move Phone Center");
      await AccuraSdk.setFaceMatchFeedbackMultipleFaceMessage("Multiple Face Detected");
      await AccuraSdk.setFaceMatchFeedBackFaceSteadymessage("Keep Your Head Straight");
      await AccuraSdk.setFaceMatchFeedBackLowLightMessage("Low light detected");
      await AccuraSdk.setFaceMatchFeedBackBlurFaceMessage("Blur Detected Over Face");
      await AccuraSdk.setFaceMatchFeedBackGlareFaceMessage("Glare Detected");
      await AccuraSdk.setBlurPercentage(80);
      await AccuraSdk.setFaceMatchGlarePercentage_0(-1);
      await AccuraSdk.setFaceMatchGlarePercentage_1(-1);

      await AccuraSdk.getCamera2([accuraConfs]).then((value) => {
        setState(() {
          dynamic result = json.decode(value);
          facematchURI2 = result["Image"];
          if(result.toString().contains("score")){
            Score = result["score"];
          }
          print("RESULT:- $result");
        })
      });//.onError((error, stackTrace)=>{print("Not Printing")});
    } on PlatformException {}
    if(!mounted) return;
  }
```

**accuraConfs:** JSON Object

**Face1:** 'uri of face1'

**Face2:** ’uri of face2’

**Success:** JSON Response {

**Image:** URI?,

**score:** String,
}

**Error:** String


Contributing
See the contributing guide to learn how to contribute to the repository and the development workflow.

License:
MIT

