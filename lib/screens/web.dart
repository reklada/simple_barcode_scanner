/*
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/constant.dart';
import 'package:simple_barcode_scanner/enum.dart';

/// Barcode scanner for web using iframe
class BarcodeScanner extends StatelessWidget {
  final String lineColor;
  final String cancelButtonText;
  final bool isShowFlashIcon;
  final ScanType scanType;
  final Function(String) onScanned;
  final String? appBarTitle;
  final bool? centerTitle;

  const BarcodeScanner({
    Key? key,
    required this.lineColor,
    required this.cancelButtonText,
    required this.isShowFlashIcon,
    required this.scanType,
    required this.onScanned,
    this.appBarTitle,
    this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String createdViewId = DateTime.now().microsecondsSinceEpoch.toString();
    String? barcodeNumber;

    final html.IFrameElement iframe = html.IFrameElement()
      ..src = PackageConstant.barcodeFileWebPath
      ..style.border = 'none'
      ..onLoad.listen((event) async {
        /// Barcode listener on success barcode scanned
        html.window.onMessage.listen((event) {
          /// If barcode is null then assign scanned barcode
          /// and close the screen otherwise keep scanning
          if (barcodeNumber == null) {
            barcodeNumber = event.data;
            onScanned(barcodeNumber!);
          }
        });
      });
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry
        .registerViewFactory(createdViewId, (int viewId) => iframe);

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle ?? kScanPageTitle),
        centerTitle: centerTitle,
      ),
      body: HtmlElementView(
        viewType: createdViewId,
      ),
    );
  }
}*/

// Import necessary packages
import 'dart:convert';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/constant.dart';
import 'package:simple_barcode_scanner/enum.dart';

class BarcodeScanner extends StatefulWidget {
  final String lineColor;
  final String cancelButtonText;
  final bool isShowFlashIcon;
  final ScanType scanType;
  final Function(String) onScanned;
  final String? appBarTitle;
  final bool? centerTitle;

  const BarcodeScanner({
    Key? key,
    required this.lineColor,
    required this.cancelButtonText,
    required this.isShowFlashIcon,
    required this.scanType,
    required this.onScanned,
    this.appBarTitle,
    this.centerTitle,
  }) : super(key: key);

  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String selectedCameraId = "";
  List<dynamic> cameras = [];

  @override
  void initState() {
    super.initState();
    _getCameraList();
  }

  void _getCameraList() {
    final html.IFrameElement iframe = html.IFrameElement()
      ..src = PackageConstant.barcodeFileWebPath
      ..style.border = 'none';

    // Register the iframe
    String viewId = "barcode-scanner";
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) => iframe);

    // Listen for camera list
    iframe.onLoad.listen((event) {
      html.window.onMessage.listen((event) {
        setState(() {
          cameras = jsonDecode(event.data);
          if (cameras.isNotEmpty) {
            selectedCameraId = cameras[0]['id'];
          }
        });
      });
    });
  }

  void _startScanning() {
    // Send the selected camera ID to the HTML
    html.window.postMessage(selectedCameraId, '*');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode/Qrcode'),
      ),
      body: Column(
        children: [
          if (cameras.isNotEmpty) ...[
            DropdownButton<String>(
              value: selectedCameraId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCameraId = newValue!;
                });
              },
              items: cameras.map<DropdownMenuItem<String>>((camera) {
                return DropdownMenuItem<String>(
                  value: camera['id'],
                  child: Text(camera['label']),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _startScanning,
              child: const Text('Start Scanning'),
            ),
          ],
          Expanded(
            child: HtmlElementView(viewType: 'barcode-scanner'),
          ),
        ],
      ),
    );
  }
}
