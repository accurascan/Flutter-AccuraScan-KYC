
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_accurascan_kyc/flutter_accurascan_kyc.dart';

class ResultScreen extends StatefulWidget {
  final dynamic result; // Added to pass result explicitly to the screen.
  const ResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  var scrollController = ScrollController();
  late dynamic _result;
  String faceMatchURL = '';
  double fontsize = 16;
  String matchFileURL = '';
  String livenessScore = '0.0';
  String faceMatchScore = '0.0';

  @override
  void initState() {
    super.initState();
    // Initialize the result passed from the previous screen
    _result = widget.result;
    setState(() {
      faceMatchURL = _result['face']?.toString() ?? '';
    });
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
        foregroundColor: Colors.white,
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
                      getImageOnDocument(),
                      getDataWidgets(),
                      getMRZDataWidgets(),
                      getImagesWidgets(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Display face image
  Widget getImageOnDocument() {
    return Column(
      children: [
        _result['face'] != null
            ? Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 100,
                  child: Image.file(
                    File(_result['face'].toString().replaceAll('file:///', '')),
                    fit: BoxFit.cover,
                  ),
                ),
                matchFileURL != ''
                    ? Container(
                  margin: EdgeInsets.only(left: 50),
                  height: 150,
                  width: 100,
                  child: Image.file(
                    File(matchFileURL.replaceAll('file:///', '')),
                    fit: BoxFit.cover,
                  ),
                )
                    : Container()
              ],
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: Colors.red[800],
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          right: 20,
                          left: 20,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/ic_liveness.png",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "LIVENESS",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        // startLiveness();
                      },
                    ),
                    Visibility(
                      visible: true,
                      child: livenessScore != ''
                          ? Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            double.parse(livenessScore)
                                .toStringAsFixed(2)
                                .toString() +
                                "%",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      )
                          : Container(),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        backgroundColor: Colors.red[800],
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          right: 20,
                          left: 20,
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/ic_facematch.png",
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "FACEMATCH",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        // startFaceMatch();
                      },
                    ),
                    Visibility(
                      visible: faceMatchScore != "" ? true : false,
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            double.parse(faceMatchScore)
                                .toStringAsFixed(2)
                                .toString() +
                                "%",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        )
            : Container(),
      ],
    );
  }

  // Display document images (front & back)
  Widget getImagesWidgets() {
    return Column(
      children: ["front_img", "back_img"].map(
            (e) => (_result[e] != null && _result[e].length != 0
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
                  color: Colors.black,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
            ),
            Image.file(
              File(_result[e].toString().replaceAll('file:///', '')),
            ),
          ],
        )
            : Container()),
      ).toList(),
    );
  }

  // Display MRZ, OCR, Barcode, BankCard data
  Widget getDataWidgets() {
    return Column(
      children: ["front_data", "back_data"].map(
            (e) => (_result[e] != null && _result[e].length != 0
            ? Column(
          children: [
            Container(
              color: Colors.grey.withOpacity(0.5),
              child: Text(
                e == 'front_data'
                    ? getResultType(_result['type'])
                    : 'OCR Back',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
            ),
            getSubDataWidgets(e),
          ],
        )
            : Container()),
      ).toList(),
    );
  }

  // Sub Data widget for each section
  Widget getSubDataWidgets(key) {
    List<Widget> list = [];
    if (_result[key] != null) {
      _result[key].forEach((k, v) {
        if (!k.toString().contains('_img')) {
          list.add(Table(
            border: TableBorder.symmetric(
              inside: BorderSide(color: Colors.red, width: 1),
              outside: BorderSide(color: Colors.red, width: 0.5),
            ),
            children: [
              TableRow(children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(k.toString()),
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(v.toString()),
                    ),
                  ),
                ),
              ]),
            ],
          ));
        }
      });
    }
    return Column(children: list);
  }

  // Method to get result type for front data
  String getResultType(String type) {
    switch (type) {
      case 'passport':
        return 'Passport Data';
      case 'idcard':
        return 'ID Card Data';
      case 'driving_license':
        return 'Driving License Data';
      default:
        return 'Document Data';
    }
  }

  // Placeholder for MRZ data (if needed)
  Widget getMRZDataWidgets() {
    return Container(); // Implement as needed based on your data structure
  }
}