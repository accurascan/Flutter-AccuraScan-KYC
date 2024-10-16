import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_accurascan_kyc/flutter_accurascan_kyc.dart';

void main() {
  runApp(const FaceMatch());
}

class FaceMatch extends StatefulWidget {
  const FaceMatch({Key? key}) : super(key: key);

  @override
  State<FaceMatch> createState() => _FaceMatchState();
}

class _FaceMatchState extends State<FaceMatch> {

  dynamic _result = {'isValid': false};
  String facematchURI = '';
  String facematchURI2 = '';
  String Score = "0.0";

  Future<void> openGallery() async{
    try{
      var accuraConfs = {
        "face1": this.facematchURI,
        "face2": this.facematchURI2
      };

      await AccuraOcr.getGallery1([accuraConfs]).then((value) => {
        setState(() {
          _result = json.decode(value);
          facematchURI = _result["Image"];
          if(_result.toString().contains("score")){
            Score = _result["score"];
          }
          print("RESULT:- $_result");
        })
      }).onError((error, stackTrace)=>{});
    } on PlatformException {}
    if(!mounted) return;
  }

  Future<void> openGallery2() async{
    try{
      var accuraConfs = {
        "face1": this.facematchURI,
        "face2": this.facematchURI2
      };
      await AccuraOcr.getGallery2([accuraConfs]).then((value) => {
        setState(() {
          _result = json.decode(value);
          facematchURI2 = _result["Image"];
          if(_result.toString().contains("score")){
            Score = _result["score"];
          }
          print("RESULT:- $_result");
        })
      }).onError((error, stackTrace)=>{});
    } on PlatformException {}
    if(!mounted) return;
  }

  Future<void> openCamera() async{
    try{
      var accuraConfs = {
        "face1": this.facematchURI,
        "face2": this.facematchURI2
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

      await AccuraFacematch.getCamera1([accuraConfs]).then((value) => {
        setState(() {
          _result = json.decode(value);
          facematchURI = _result["Image"];
          if(_result.toString().contains("score")){
            Score = _result["score"];
          }
          print("RESULT:- $_result");
        })
      });
    } on PlatformException {}
    if(!mounted) return;
  }


  Future<void> openCamera2() async{
    try{
      var accuraConfs = {
        "face1": this.facematchURI,
        "face2": this.facematchURI2
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

      await AccuraFacematch.getCamera2([accuraConfs]).then((value) => {
        setState(() {
          _result = json.decode(value);
          facematchURI2 = _result["Image"];
          if(_result.toString().contains("score")){
            Score = _result["score"];
          }
          print("RESULT:- $_result");
        })
      });
    } on PlatformException {}
    if(!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Accura KYC'),
          backgroundColor: Colors.red[800],
        ),
        body: Center(
          child: Column(
            children: [
              facematchURI != ''
                  ? Container(
                margin: EdgeInsets.only(left: 50),
                height: 150,
                width: 100,
                child: Image.file(
                  new File(
                      facematchURI.replaceAll("file:///", '')),
                ),
              )
                  : Container(),
              Center(
                child: Row(
                  mainAxisAlignment:  MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                            ), backgroundColor: Colors.red[800],
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20)),
                        onPressed: (){
                      openGallery();
                    },
                        child: Text("Open Gallery")
                    ),

                    SizedBox(width: 10,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                            ), backgroundColor: Colors.red[800],
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20)),
                        onPressed: (){
                      openCamera();
                    },
                        child: Text("Open Camera")
                    ),
                  ],
                ),
              ),


              SizedBox(height: 10,),
              facematchURI2 != ''
                  ? Container(
                margin: EdgeInsets.only(left: 50),
                height: 150,
                width: 100,
                child: Image.file(
                  new File(
                      facematchURI2.replaceAll("file:///", '')),
                ),
              )
                  : Container(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                            ), backgroundColor: Colors.red[800],
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20)),
                        onPressed: (){
                      openGallery2();
                    },
                        child: Text("Open Gallery")
                    ),

                    SizedBox(width: 10,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                            ), backgroundColor: Colors.red[800],
                            padding: EdgeInsets.only(
                                top: 10, bottom: 10, right: 20, left: 20)),
                        onPressed: (){
                      openCamera2();
                    },
                        child: Text("Open Camera")
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
                  Text("MatchScore is $Score")
            ],
          ),
        ),
      ),
    );
  }
}
