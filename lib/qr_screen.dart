import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatelessWidget {
  var QRData;

  QRScreen({Key? key, required this.QRData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contactopus'),
      ),
      body: Center(
        child: QrImageView(
          data: QRData,
          version: QrVersions.auto,
          size: screenWidth / 1.285714285714286,
          gapless: false,
        ),
      ),
    );
  }
}
