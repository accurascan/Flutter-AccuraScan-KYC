
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_accurascan_kyc/flutter_accurascan_kyc.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static dynamic result = {'isValid':false};
  static String Orientation = "";


  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var scrollController = ScrollController();
  dynamic _result;
  String faceMatchURL = '';
  double fontsize = 16;
  String matchFileURL = '';
  String livenessScore = '0.0';
  String faceMatchScore = '0.0';
  @override
  void initState() {
    setState((){
      faceMatchURL = ResultScreen.result['face'].toString();
    });
    print('Data from other Screen');
    print(ResultScreen.result);
  }

  Future<void> startFaceMatch() async{
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    try{
      var accuraConfs = {
        "face_uri":this.faceMatchURL
      };

      await AccuraFacematch.setFaceMatchFeedbackTextSize(18);
      await AccuraFacematch.setFaceMatchFeedBackframeMessage("Frame Your Face");
      await AccuraFacematch.setFaceMatchFeedBackAwayMessage("Move Phone Away");
      await AccuraFacematch.setFaceMatchFeedBackOpenEyesMessage("Keep Your Eyes Open");
      await AccuraFacematch.setFaceMatchFeedBackCloserMessage("Move Phone Closer");
      await AccuraFacematch.setFaceMatchFeedBackCenterMessage("Move Phone Center");
      await AccuraFacematch.setFaceMatchFeedbackMultipleFaceMessage("Multiple Face Detected");
      await AccuraFacematch.setFaceMatchFeedBackFaceSteadymessage("Keep Your Head Straight");
      await AccuraFacematch.setFaceMatchFeedBackLowLightMessage("Low light detected");
      await AccuraFacematch.setFaceMatchFeedBackBlurFaceMessage("Blur Detected Over Face");
      await AccuraFacematch.setFaceMatchFeedBackGlareFaceMessage("Glare Detected");
      await AccuraFacematch.setFaceMatchBlurPercentage(80);
      await AccuraFacematch.setFaceMatchGlarePercentage_0(-1);
      await AccuraFacematch.setFaceMatchGlarePercentage_1(-1);
      await AccuraFacematch.startFaceMatch([accuraConfs])
          .then((value) => {
        setState((){
          if(ResultScreen.Orientation == "landscape"){

            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
          }
          _result = json.decode(value);
          print("Result: $_result");
          matchFileURL = _result['detect'].toString();
          livenessScore = '0.0';
          faceMatchScore = _result['score'].toString();
        })
      }).onError((error, stackTrace) => {
      if(ResultScreen.Orientation  == "landscape"){
          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
    }
      });
    }on PlatformException{}
  }
  Future<void> startLiveness() async{
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    try{
      var accuraConfs = {
        "face_uri":this.faceMatchURL
      };

      await AccuraLiveness.setLivenessFeedbackTextSize(18);
      await AccuraLiveness.setLivenessFeedBackframeMessage("Frame Your Face");
      await AccuraLiveness.setLivenessFeedBackAwayMessage("Move Phone Away");
      await AccuraLiveness.setLivenessFeedBackOpenEyesMessage("Keep Your Eyes Open");
      await AccuraLiveness.setLivenessFeedBackCloserMessage("Move Phone Closer");
      await AccuraLiveness.setLivenessFeedBackCenterMessage("Move Phone Closer");
      await AccuraLiveness.setLivenessFeedbackMultipleFaceMessage("Multiple Face Detected");
      await AccuraLiveness.setLivenessFeedBackFaceSteadymessage("Keep Your Head Straight");
      await AccuraLiveness.setLivenessFeedBackBlurFaceMessage("Blur Detected Over Face");
      await AccuraLiveness.setLivenessFeedBackGlareFaceMessage("Glare Detected");
      await AccuraLiveness.setLivenessBlurPercentage(80);
      await AccuraLiveness.setLivenessGlarePercentage_0(-1);
      await AccuraLiveness.setLivenessGlarePercentage_1(-1);
      await AccuraLiveness.setLivenessFeedBackLowLightMessage("Low light detected");
      await AccuraLiveness.setLivenessfeedbackLowLightTolerence(39);
      await AccuraLiveness.setLivenessURL("your liveness url");



      await AccuraLiveness.startLiveness([accuraConfs])
          .then((value) => {
        setState((){
          if(ResultScreen.Orientation  == "landscape"){
            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
          }
          _result = json.decode(value);
          print("result: $_result");
          matchFileURL= _result['detect'].toString();
          livenessScore = _result['score'].toString();
          faceMatchScore = _result['face_score'].toString();
        })
      }).onError((error, stackTrace) => {
      if(ResultScreen.Orientation  == "landscape"){
          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
    }
      });
    }on PlatformException{}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Accura Result"),
        backgroundColor: Colors.red[800],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 12,
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        child: Column(children: [
                          getImageOnDocument(),
                          getDataWidgets(),
                          getMRZDataWidgets(),
                          getImagesWidgets(),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Code for display face images.
  Widget getImageOnDocument() {
    return new Column(
      children: [
        ResultScreen.result['face'] != null
            ? Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 100,
                  child: Image.file(
                    new File(ResultScreen.result['face']
                        .toString()
                        .replaceAll('file:///', '')),
                    fit: BoxFit.cover
                  ),
                ),
                matchFileURL != ''
                    ? Container(
                  margin: EdgeInsets.only(left: 50),
                  height: 150,
                  width: 100,
                  child: Image.file(
                    new File(
                        matchFileURL.replaceAll('file:///', '')),
                    fit: BoxFit.cover,
                  ),
                )
                    : Container()
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          primary: Colors.red[800]),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/ic_liveness.png",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "LIVENESS",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        startLiveness();
                      },
                    ),
                    Visibility(
                      visible: true,
                      child: livenessScore != ''
                          ? Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            double.parse(livenessScore)
                                .toStringAsFixed(2)
                                .toString() +
                                "%",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      )
                          : Container(),
                    )
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, right: 20, left: 20),
                          primary: Colors.red[800]),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/ic_facematch.png",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "FACEMATCH",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        startFaceMatch();
                      },
                    ),
                    Visibility(
                      visible: faceMatchScore != "" ? true : false,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            double.parse(faceMatchScore)
                                .toStringAsFixed(2)
                                .toString() +
                                "%",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        )
            : Container(),
      ],
    );
  }

  //Code for display document image for front & back.
  Widget getImagesWidgets() {
    return new Column(
        children: ["front_img", "back_img"]
            .map(
              (e) => (ResultScreen.result[e] != null && ResultScreen.result[e].length != 0
              ? Column(
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: Text(
                  e == 'front_img' ? 'FRONT SIDE' : 'BACK SIDE',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                width: MediaQuery.of(context).size.width,
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 10),
              ),
              Image.file(
                new File(ResultScreen.result[e]
                    .toString()
                    .replaceAll('file:///', '')),
              ),
            ],
          )
              : Container()),
        )
            .toList());
  }

  //Code for display MRZ, OCR, Barcode, BankCard data
  Widget getDataWidgets() {
    return new Column(
        children: ["front_data", "back_data"]
            .map(
              (e) => (ResultScreen.result[e] != null && ResultScreen.result[e].length != 0
              ? Column(
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: Text(
                  e == 'front_data'
                      ? getResultType(ResultScreen.result['type'])
                      : 'OCR Back',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                width: MediaQuery.of(context).size.width,
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 10),
              ),
              getSubDataWidgets(e)
            ],
          )
              : Container()),
        )
            .toList());
  }

  Widget getSubDataWidgets(key) {
    List<Widget> list = [];

    if (ResultScreen.result[key] != null) {
      ResultScreen.result[key].forEach((k, v) => {
        if (!k.toString().contains('_img'))
          {
            list.add(new Table(
              border: TableBorder.symmetric(
                  inside: BorderSide(color: Colors.red, width: 1),
                  outside: BorderSide(color: Colors.red, width: 0.5)),
              children: [
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(k.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize)),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: k != "signature"
                            ? Text(v.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize))
                            : Image.file(
                          new File(v
                              .toString()
                              .replaceAll('file:///', '')),
                        ),
                      ),
                    ),
                  )
                ]),
              ],
            ))
          }
      });
    }
    return new Column(children: list);
  }

  Widget getMRZDataWidgets() {
    List<Widget> list = [];

    if (ResultScreen.result['mrz_data'] != null) {
      ResultScreen.result['mrz_data'].forEach((k, v) => {
        if (!k.toString().contains('_img'))
          {
            list.add(new Table(
              border: TableBorder.all(color: Color(0xFFD32D39)),
              children: [
                TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(k.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize)),
                      ),
                    ),
                  ),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.middle,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: k != "signature"
                            ? Text(v.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: fontsize))
                            : Image.file(
                          new File(v
                              .toString()
                              .replaceAll('file:///', '')),
                        ),
                      ),
                    ),
                  )
                ]),
              ],
            ))
          }
      });
    }
    return new Column(children: list);
  }

  String getResultType(type) {
    switch (type) {
      case "BANKCARD":
        return "Bank Card Data";
      case "DL_PLATE":
        return "Vehicle Plate";
      case "BARCODE":
        return "Barcode Data";
      case "PDF417":
        return "PDF417 Barcode";
      case "OCR":
        return "OCR Front";
      case "MRZ":
        return "MRZ";
      case "BARCODEPDF417":
        return "USA DL Result";
      default:
        return "Front Side";
    }
  }
}