import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:accura_sdk/accura_sdk.dart';
import 'package:flutterkyc/ResultScreen.dart';

class CardList extends StatefulWidget {
  const CardList({Key? key, required this.card, required this.countrySelect}) : super(key: key);
  final List card;
  final Map<String,dynamic> countrySelect;
  static String aOrientation = "";

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  dynamic _result = {"isValid",false};
  List<String> ocrCountryDropdownOptions = [''];
  Map<String,dynamic> cardSelected = {};


  Future<void> startOCR() async {
    try {
      var config = [
        {"enableLogs": false},
        widget.countrySelect['id'],
        cardSelected['id'],
        cardSelected['name'],
        cardSelected['type'],
      ];
      print("startOcr: $config");
      await AccuraSdk.startOcrWithCard(config)
          .then((value) =>
      {
        setState(() {
          ResultScreen.Orientation = CardList.aOrientation;
          _result = json.decode(value);
          ResultScreen.result = _result;
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => ResultScreen()));
        })
      })
          .onError((error, stackTrace) =>
      {
      });
    } on PlatformException {}
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
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.card.length,
                  itemBuilder: (context, index){
                    return
                      Card(
                          color: Colors.red[800],
                          child:
                          ListTile(
                              title: Text(widget.card[index].toString(),
                                style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.white),
                              ),
                              onTap: (){
                                cardSelected = widget.countrySelect['cards'].where((i)=>i['name'] == widget.card[index]).first;
                                startOCR();
                              }
                          )
                      );

                  })
          ),
        ),
      ),
    );
  }
}
