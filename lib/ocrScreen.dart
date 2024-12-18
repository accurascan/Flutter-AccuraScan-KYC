import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_accurascan_kyc/flutter_accurascan_kyc.dart';

import 'ResultScreen.dart';


void main() {
  runApp(const MaterialApp(
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
  dynamic _result = {"isValid", false};
  String mfile = "";
  List<File> images = [];
  Map<String, dynamic> countrySelected = {};
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


  Future<void> getMetaData() async {
    try {
      await AccuraOcr.getMetaData().then((value) =>
          setupConfigData(json.decode(value)));
    } on PlatformException {}
    if (!mounted) return;
  }

  Future<void> setAccuraConfig() async {
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

      await AccuraOcr.CameraScreen_Text_Size(20);
      await AccuraOcr.CameraScreen_Color("#80000000");
      await AccuraOcr.CameraScreen_Back_Button(1);
      await AccuraOcr.CameraScreen_Change_Button(1);
      await AccuraOcr.CameraScreen_Frame_Color("#D5323F");
      await AccuraOcr.CameraScreen_Text_Border_Color("#000000");
      await AccuraOcr.CameraScreen_Text_Color("#FFFFFF");

      await AccuraOcr.setAccuraConfigs().then((value) => {
        setState(() {
          print(json.decode(value));
        })
      });
    } on PlatformException {}
  }

  Future<void> startMICRCard() async {
    try {

      await AccuraOcr.startMICR().then((value) => {
        setState(() {
          _result = json.decode(value);
          // ResultScreen.result = _result;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultScreen(result: _result,)));
        })
      });
    } on PlatformException catch (e) {
      print("Error starting MICR card: $e");
    }
  }

  void setupConfigData(obj) {
    setState(() {
      sdkConfig = obj;
    });
    if (sdkConfig["isValid"] == true) {
      setAccuraConfig();
      List<String> tempList3 = [];
      List barcodeData = [];

      if (sdkConfig['isMICREnable']) {
        tempList3.add('MICR Card');
      }

      setState(() {
        listOfCountryandMrz = tempList3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accura MICR"),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                startMICRCard();  // Trigger MICR Card scan
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.red[800], // Set the text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Make the corners rounded
                ),
              ),
              child: Text('Start Scanning'),
            ),
            // Add additional UI components as needed
          ],
        ),
      ),
    );
  }
}