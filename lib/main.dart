import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterkyc/FaceMatch.dart';
import 'package:flutterkyc/ocrScreen.dart';
import 'package:path_provider/path_provider.dart';



import 'FaceMatch.dart';
void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _shareFlipImage();
  }

  _shareFlipImage() async {
    try {
      final ByteData bytes = await rootBundle.load('assets/images/flip.png');
      final Uint8List list = bytes.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/flip.png').create();
      file.writeAsBytesSync(list);
      String file1 = file.toString();
      String ggg = file1.replaceAll("File: '", "");
      String fff = ggg.replaceAll("'", "");
      String filePath = "file://$fff";
      setState(() {
        MyApp.path = filePath;
      });
    } catch (e) {
      print('Share error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accura KYC"),
        backgroundColor: Colors.red[800],
      ),
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg_home.png"),
                  fit: BoxFit.cover
              )
          ),
          child:SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
                      },
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width-50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/OCR.jpg"),
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width-50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Facematch.jpg"),
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FaceMatch()));
                      },
                    )
                  ],
                ),
              )
          )
      ),
    );
  }
}
