import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_accurascan_kyc/flutter_accurascan_kyc.dart';
import 'package:flutterkyc/ResultScreen.dart';
import 'package:flutterkyc/barcodeList.dart';
import 'package:flutterkyc/cardList.dart';


void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  static String path = "";
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic _result = {"isValid",false};
  String mfile = "";
  List<File> images = [];
  Map<String,dynamic> countrySelected = {};
  String mrzCountryList = 'all';
  bool isMRZEnable = false;
  bool isBarcodeEnable = false;
  bool isBankCardEnable = false;
  List barcodeList = [];
  var count = 0;
  String orientation = 'portrait';
  List<Map<String, dynamic>> mrzList = [
    {"label": "Passport", "value": "passport_mrz"},
    {"label": "Mrz ID", "value": "id_mrz"},
    {"label": "Visa Card", "value": "visa_mrz"},
    {"label": "Other", "value": "other_mrz"}
  ];

  List<String> listOfCountryandMrz = [''];
  String mrzselected = '';
  dynamic sdkConfig;


  @override
  void initState() {
    super.initState();
    getMetaData();
  }

  Future<void> getMetaData() async{
    try {
      await AccuraOcr.getMetaData().then((value) =>
          setupConfigData(json.decode(value)));
    }on PlatformException{}
    if (!mounted) return;
  }

  Future<void> setAccuraConfig() async{
    try {
      await AccuraOcr.setFaceBlurPercentage(80);
      await AccuraOcr.setHologramDetection(true);
      await AccuraOcr.setLowLightTolerance(10);
      await AccuraOcr.setMotionThreshold(25);
      await AccuraOcr.setMinGlarePercentage(6);
      await AccuraOcr.setMaxGlarePercentage(99);
      await AccuraOcr.setBlurPercentage(60);
      await AccuraOcr.setCameraFacing(0);
      await AccuraOcr.isCheckPhotoCopy(false);
      await AccuraOcr.Disable_Card_Name(false);

      await AccuraOcr.setIsDocEnable(true); //set false to disable Document Liveness
      await AccuraOcr.setDocUrl("Your URL"); //Add you Document Liveness URL
      await AccuraOcr.setProgressMessage("DocLiveness Calling..."); //Add Loading Text
      await AccuraOcr.setApiTimer(10); // Set the API calling timer
      await AccuraOcr.setHideProgressDialogue(false); //true to disable Progress Dialogue

      await AccuraOcr.SCAN_TITLE_OCR_FRONT("Scan Front side of ");
      await AccuraOcr.SCAN_TITLE_OCR_BACK("Scan Back side of ");
      await AccuraOcr.SCAN_TITLE_OCR("Scan ");
      await AccuraOcr.SCAN_TITLE_MRZ_PDF417_FRONT("Scan Front Side of Document");
      await AccuraOcr.SCAN_TITLE_MRZ_PDF417_BACK("Scan Back Side of Document");
      await AccuraOcr.SCAN_TITLE_DLPLATE("Scan Number plate");
      await AccuraOcr.SCAN_TITLE_BARCODE("Scan Barcode");
      await AccuraOcr.SCAN_TITLE_BANKCARD("Scan BankCard");

      await AccuraOcr.ACCURA_ERROR_CODE_MOTION("Keep Document Steady");
      await AccuraOcr.ACCURA_ERROR_CODE_DOCUMENT_IN_FRAME("Keep document in frame");
      await AccuraOcr.ACCURA_ERROR_CODE_BRING_DOCUMENT_IN_FRAME("Bring card near to frame");
      await AccuraOcr.ACCURA_ERROR_CODE_PROCESSING("Processing");
      await AccuraOcr.ACCURA_ERROR_CODE_BLUR_DOCUMENT("Blur detect in document");
      await AccuraOcr.ACCURA_ERROR_CODE_FACE_BLUR("Blur detected over face");
      await AccuraOcr.ACCURA_ERROR_CODE_GLARE_DOCUMENT("Glare detect in document");
      await AccuraOcr.ACCURA_ERROR_CODE_HOLOGRAM("Hologram Detected");
      await AccuraOcr.ACCURA_ERROR_CODE_DARK_DOCUMENT("Low lighting detected");
      await AccuraOcr.ACCURA_ERROR_CODE_PHOTO_COPY_DOCUMENT("Can not accept Photo Copy Document");
      await AccuraOcr.ACCURA_ERROR_CODE_FACE("Face not detected");
      await AccuraOcr.ACCURA_ERROR_CODE_MRZ("MRZ not detected");
      await AccuraOcr.ACCURA_ERROR_CODE_PASSPORT_MRZ("Passport MRZ not detected");
      await AccuraOcr.ACCURA_ERROR_CODE_ID_MRZ("ID MRZ not detected");
      await AccuraOcr.ACCURA_ERROR_CODE_VISA_MRZ("Visa MRZ not detected");
      await AccuraOcr.ACCURA_ERROR_CODE_UPSIDE_DOWN_SIDE("Document is upside down. Place it properly");
      await AccuraOcr.ACCURA_ERROR_CODE_WRONG_SIDE("Scanning wrong side of Document");
      await AccuraOcr.isShowLogo(0);
      await AccuraOcr.isFlipImg(1);
      await AccuraOcr.CameraScreen_Color("#80000000");   //Pass empty string for clear color else pass the Hex code e.g, #FFFFFF.
      await AccuraOcr.CameraScreen_Back_Button(1); //For iOS disable the back button by Passing 0.
      await AccuraOcr.CameraScreen_Change_Button(1); //To disable flip camera button pass 0.
      await AccuraOcr.CameraScreen_Frame_Color("#D5323F"); //Pass a Hex Code to change the color of the frame.
      await AccuraOcr.CameraScreen_Text_Border_Color(""); //Pass a Hex Code to change the color of the text border pass empty string to disable it.
      await AccuraOcr.CameraScreen_Text_Color("#FFFFFF"); //Pass a Hex Code to change the color of the text.
      await AccuraOcr.CameraScreen_CornerBorder_Enable(true);
      await AccuraOcr.CameraScreen_Border_Width(15);
      await AccuraOcr.setFlipImage(MyApp.path);

      await AccuraOcr.setAccuraConfigs().then((value) => {
        setState((){
          print(json.decode(value));
        })
      });

    }on PlatformException{}
    }

  Future<void> startBankCard() async{
    try{
      await AccuraOcr.startBankCard().then((value) => {
        setState((){
          _result = json.decode(value);
          ResultScreen.result = _result;
        })
      });
    }on PlatformException{}
  }


  void setupConfigData(obj){
    setState((){
      sdkConfig = obj;
    });
    if(sdkConfig["isValid"] == true){
      setAccuraConfig();
      List<String> tempList3=[];
      List barcodeData = [];

      List countryData = obj['countryList'];
      if(sdkConfig['isMRZEnable']) {
        for (var item in mrzList) {
          tempList3.add(item['label']);
        }
      }
      if(sdkConfig['isBankCardEnable']){
        tempList3.add('Bank Card');
      }
      if(sdkConfig['isBarcodeEnable']) {
        tempList3.add("Barcode");
        barcodeData = obj["barcodes"];
      }

      for (var item in countryData) {
        tempList3.add(item['name']);
      }

      setState((){
        barcodeList = barcodeData;
        listOfCountryandMrz = tempList3;
      });
    }
  }

  Future<void> startMRZ() async {
    try {
      var config = [
        mrzselected,
      ];
      print('startMRZ:- $config');
      await AccuraOcr.startMRZ(config)
          .then((value) => {
        setState((){
          _result = json.decode(value);
          ResultScreen.Orientation = orientation;
          ResultScreen.result = _result;
          print("RESULT:- $_result");
        })
      }).onError((error, stackTrace) => {
        setState(() {
        })
      });
    } on PlatformException {}
  }


  @override
  Widget build(BuildContext context) {
    {
      print(MediaQuery.of(context).orientation.toString());
    }
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text("Accura KYC"),
              actions: [TextButton(onPressed: (){
                count = count + 1;
                if(count%2 != 0){
                  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                  orientation = "landscape";
                }
                else{
                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                  orientation = "portrait";
                }
              }, child: count%2 == 0?Text("Landscape",style: TextStyle(color: Colors.white),)
                  :Text("Portrait",style: TextStyle(color: Colors.white),))],
              backgroundColor: Colors.red[800],
            ),
            resizeToAvoidBottomInset: true,
            body: SafeArea(child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover
                ),
              ),
              child:
              SingleChildScrollView(
                  child: Center(
                    child: Container(
                      child:
                      sdkConfig == null
                          ? Container(
                              height:MediaQuery.of(context).size.height,
                              child: Center(child: CircularProgressIndicator()),
                      )
                          : !sdkConfig["isValid"]
                          ?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/license.png',height: 150,width: 150,),
                          Text("License is not Valid",textAlign: TextAlign.center,)
                        ],
                      ) :
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: listOfCountryandMrz.length,
                          itemBuilder: (context,index){
                            return
                              SingleChildScrollView(
                                  child:
                                  Card(
                                      color: (listOfCountryandMrz[index] == 'Passport' || listOfCountryandMrz[index] == 'Visa Card'
                                          || listOfCountryandMrz[index] == 'Mrz ID' || listOfCountryandMrz[index] == 'Other'
                                          || listOfCountryandMrz[index] == 'Bank Card' || listOfCountryandMrz[index] == 'Barcode'
                                      )?Colors.grey:Colors.red[800],
                                      child:
                                      ListTile(
                                        title: Text(listOfCountryandMrz[index]
                                          ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                                        ),
                                        onTap: () async{
                                          if(listOfCountryandMrz[index] == 'Passport' || listOfCountryandMrz[index] == 'Visa Card'
                                              || listOfCountryandMrz[index] == 'Mrz ID' || listOfCountryandMrz[index] == 'Other'
                                              || listOfCountryandMrz[index] == 'Bank Card' || listOfCountryandMrz[index] == 'Barcode'
                                          ){
                                            if(listOfCountryandMrz[index] == 'Passport'){
                                              mrzselected = 'passport_mrz';
                                              print('passport');
                                              await startMRZ();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ResultScreen()));
                                            }
                                            else if(listOfCountryandMrz[index] == 'Visa Card'){
                                              mrzselected = 'visa_card';
                                              print('visa_card');
                                              await startMRZ();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ResultScreen()));
                                            }
                                            else if(listOfCountryandMrz[index] == 'Mrz ID'){
                                              mrzselected = 'id_mrz';
                                              print('ID');
                                              await startMRZ();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ResultScreen()));
                                            }else if(listOfCountryandMrz[index] == 'Bank Card'){
                                              await startBankCard();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ResultScreen()));
                                            }else if(listOfCountryandMrz[index] == 'Barcode'){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => BarcodeList(barcode: barcodeList)));
                                            }
                                            else {
                                              mrzselected = 'other_mrz';
                                              print('other_mrz');
                                              await startMRZ();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ResultScreen()));
                                            }
                                          }
                                          else{
                                            var selected = sdkConfig!['countryList'].where((i)=>i['name'] == listOfCountryandMrz[index]).first;
                                            List<String> tempList = [];
                                            for(var item in selected['cards']){
                                              tempList.add(item['name']);
                                            }
                                            CardList.aOrientation = orientation;
                                            countrySelected = selected;
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CardList(card: tempList, countrySelect: countrySelected)));
                                          }
                                        },
                                      )
                                  )
                              );
                          }),
                    ),
                  )
              ),
            ),
            )
        )
    );
  }
}
