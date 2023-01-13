import 'dart:convert';

import 'package:flutter_accurascan_kyc/flutter_accurascan_kyc.dart';
import 'package:flutterkyc/ResultScreen.dart';
import 'package:flutter/material.dart';

class BarcodeList extends StatefulWidget {
  const BarcodeList({Key? key, required this.barcode}) : super(key: key);
final barcode;
  @override
  State<BarcodeList> createState() => _BarcodeListState();
}

class _BarcodeListState extends State<BarcodeList> {

  var barcodeSelected = "";
 dynamic _result;


  Future<void> startBarcode() async{
    var config= barcodeSelected;
    await AccuraOcr.startBarcode([config]).then((value) => {
      setState((){
        _result = json.decode(value);
      })
    });
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
          title: Text("Accura KYC"),
          backgroundColor: Colors.red[800],
        ),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover
                ),
              ),
              child:
              Container(child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.barcode.length,
                  itemBuilder: (context, index){
                    return
                      Card(
                          color: Colors.red[800],
                          child:
                          ListTile(
                              title: Text(widget.barcode[index].toString(),
                                style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.white),
                              ),
                              onTap: () async{
                                barcodeSelected = widget.barcode[index];
                               await startBarcode();
                                ResultScreen.result = _result;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResultScreen()));
                              }
                          )
                      );

                  })
              )
          ),
        ),
      ),
    );
  }
}
