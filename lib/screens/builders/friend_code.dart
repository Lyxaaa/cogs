import 'dart:async';

import 'package:distraction_destruction/templates/user.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

/**
 * Generates
 */
class FriendCode extends StatelessWidget {
  final AppUser? user;

  const FriendCode(this.user);

  @override
  Widget build(BuildContext context) {
    if (user?.uid == null) {
      return Container(height:400, width: 400);
    }

    return Container(
        width: 400,
        height: 400,
        constraints: new BoxConstraints(
          minHeight: 100.0,
          minWidth: 100.0,
          maxHeight: 300.0,
          maxWidth: 300.0,
        ),
        child: Center(child:QrImage(
                    data: user!.uid!,
                    version: QrVersions.auto,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                    ),
                  )
              ));
  }
}

Future<String> friendScan() async {
  String scanResult = await FlutterBarcodeScanner.scanBarcode(
  "#ff6666",
  "Cancel",
  false,
  ScanMode.QR);
  return scanResult;
}