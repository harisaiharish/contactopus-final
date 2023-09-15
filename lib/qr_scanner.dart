import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/saving_contact.dart';

MobileScannerController cameraController = MobileScannerController();

class QRScanner2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 147, 223, 130),
      appBar: AppBar(
        title: const Text('Contactopus'),
        centerTitle: true,
      ),
      body: MobileScanner(
        fit: BoxFit.contain,
        onDetect: (Barcode barcode, MobileScannerArguments? args) {
          var data = barcode.rawValue;
          var n = 'new'.allMatches(data!).length;
          if (barcode.rawValue != null) {
            showPopup(context, data, n);
          }
        },
      ),
    );
  }
}
