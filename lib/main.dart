import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_accurascan_micr/flutter_accurascan_micr.dart';
import '/ResultScreen.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  dynamic _result = {"isValid",false};
  String mfile = "";

  var count = 0;
  String orientation = 'portrait';


  List<String> listMicr = [''];
  String micrselected = 'e13b';
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
      await AccuraOcr.setLowLightTolerance(10);
      await AccuraOcr.setMotionThreshold(25);
      await AccuraOcr.setMinGlarePercentage(-1);
      await AccuraOcr.setMaxGlarePercentage(-1);
      await AccuraOcr.setBlurPercentage(99);
      await AccuraOcr.setCameraFacing(0);

      await AccuraOcr.SCAN_TITLE_MICR("Scan Cheque");

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

  void _showPopupOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.looks_one),
                title: Text('E13b'),
                onTap: () async {
                  // Add functionality for the E13b option here.
                  micrselected = "e13b";
                  await startMICR();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.looks_two),
                title: Text('CMC7'),
                onTap: () async {
                  // Add functionality for the CMC7 option here.
                  micrselected = "cmc7";
                  await startMICR();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultScreen()));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void setupConfigData(obj){
    setState((){
      sdkConfig = obj;
    });
    if(sdkConfig["isValid"] == true){
      setAccuraConfig();
      List<String> tempList3=[];

      if(sdkConfig['isMICR']) {
        tempList3.add('MICR');
      }

      setState((){
        listMicr = tempList3;
      });
    }
  }

  Future<void> startMICR() async {
    try {
      var config = [
        micrselected
      ];
      print('startMRZ:- $config');
      await AccuraOcr.startMICR(config)
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
              title: Text("Accura MICR"),
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
              decoration: const BoxDecoration(
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
                          ? Center(child: CircularProgressIndicator())
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
                          itemCount: listMicr.length,
                          itemBuilder: (context,index){
                            return
                              SingleChildScrollView(
                                  child:
                                  Card(
                                      color: Colors.grey,
                                      child:
                                      ListTile(
                                        title: Text(listMicr[index]
                                          ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                                        ),
                                        onTap:
                                           _showPopupOptions
                                        ,
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