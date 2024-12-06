import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/ocrScreen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';


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
        title: const Text("Accura MICR"),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
      body: SizedBox.expand(
        // Ensures the container takes the full height and width of the screen
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_home.png"),
              fit: BoxFit.cover, // Ensures the background image covers the full screen
            ),
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 100,
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "Accura MICR",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
