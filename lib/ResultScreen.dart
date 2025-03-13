import 'dart:io';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static dynamic result = {'isValid':false};
  static String Orientation = "";


  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var scrollController = ScrollController();
  String faceMatchURL = '';
  double fontsize = 16;

  @override
  void initState() {
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
                          getDataWidgets(),
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

  //Code for display document image for front & back.
  Widget getImagesWidgets() {
    return Column(
        children: ["front_img", "back_img"]
            .map(
              (e) => (ResultScreen.result[e] != null && ResultScreen.result[e].length != 0
              ? Column(
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
                width: MediaQuery.of(context).size.width,
                padding:
                EdgeInsets.only(top: 15, bottom: 15, left: 10),
                child: Text(
                  e == 'front_img' ? 'FRONT SIDE' : 'BACK SIDE',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Image.file(
                File(ResultScreen.result[e]
                    .toString()
                    .replaceAll('file:///', '')),
              ),
            ],
          )
              : Container()),
        ).toList());
  }


  Widget getDataWidgets() {
    List<Widget> list = [];

    if (ResultScreen.result['front_data'] != null) {
      ResultScreen.result['front_data'].forEach((k, v) => {
        if (!k.toString().contains('_img'))
          {
            list.add(Table(
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
                          File(v
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
    return Column(children: list);
  }
}