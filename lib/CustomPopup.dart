import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_accurascan_kyc/flutter_accurascan_kyc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart'; // For date formatting

class CustomPopup extends StatefulWidget {
  final bool isVisible;
  final Function onClose;
  final String passportNo;
  final String dob;
  final String doe;
  final Function onNFCResult;

  CustomPopup({
    required this.isVisible,
    required this.onClose,
    required this.passportNo,
    required this.dob,
    required this.doe,
    required this.onNFCResult,
  });

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  String? _selectedDob;
  String? _selectedDoe;

  @override
  void initState() {
    super.initState();
    _selectedDob = widget.dob;
    _selectedDoe = widget.doe;
  }

  String formatDate(DateTime date) {
    return DateFormat('dd-MM-yy').format(date);
  }

  String formatDateForFunction(DateTime date) {
    return DateFormat('ddMMyy').format(date);
  }

  void handleNFC() async {

    try {
      final dobToPass = formatDateForFunction(DateFormat('dd-MM-yy').parse(_selectedDob ?? widget.dob));
      final doeToPass = formatDateForFunction(DateFormat('dd-MM-yy').parse(_selectedDoe ?? widget.doe));
      print('start nfc: ${widget.passportNo} ${dobToPass} ${doeToPass}',);

      var passArgs = [
        widget.passportNo,
        dobToPass,
        doeToPass,
      ];

      // Hide the popup before starting NFC
      widget.onClose();

      // Start NFC process using the method channel
      await AccuraOcr.startNFC(passArgs).then((response) {
        widget.onNFCResult({'response': response});
      }).catchError((error) {
        print("NFC error: $error");
        widget.onNFCResult({'NFC error': error.toString()});
      });
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white, // Change background color here
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('User Id: ${widget.passportNo}', style: TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => widget.onClose(),
                      child: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date of Birth:', style: TextStyle(fontSize: 16)),
                    GestureDetector(
                      onTap: () => _selectDob(context),
                      child: Text(_selectedDob ?? widget.dob, style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date of Expiry:', style: TextStyle(fontSize: 16)),
                    GestureDetector(
                      onTap: () => _selectDoe(context),
                      child: Text(_selectedDoe ?? widget.doe, style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: handleNFC,
                  child: Text('Start NFC'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDob(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select DOB'),
          content: SfDateRangePicker(
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                _selectedDob = formatDate(args.value);
              });
              Navigator.of(context).pop();
            },
            selectionMode: DateRangePickerSelectionMode.single,
            initialSelectedDate: DateFormat('dd-MM-yy').parse(_selectedDob ?? widget.dob),
          ),
        );
      },
    );
  }

  void _selectDoe(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select DOE'),
          content: SfDateRangePicker(
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                _selectedDoe = formatDate(args.value);
              });
              Navigator.of(context).pop();
            },
            selectionMode: DateRangePickerSelectionMode.single,
            initialSelectedDate: DateFormat('dd-MM-yy').parse(_selectedDoe ?? widget.doe),
          ),
        );
      },
    );
  }
}



