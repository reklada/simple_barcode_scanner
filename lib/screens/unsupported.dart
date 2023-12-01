import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/enum.dart';

class BarcodeScanner extends StatelessWidget {
  final String cancelButtonText;
  final ScanType scanType;
  final Function(String) onScanned;
  final String? appBarTitle;
  final bool? centerTitle;
  const BarcodeScanner(
      {Key? key,
      this.cancelButtonText = "Cancel",
      this.scanType = ScanType.barcode,
      required this.onScanned,
      this.appBarTitle,
      this.centerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    throw 'Platform not supported';
  }
}
