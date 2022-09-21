// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
//
// import '../config.dart';
//
// class QRScanner extends StatefulWidget {
//   const QRScanner({Key? key}) : super(key: key);
//
//   @override
//   State<QRScanner> createState() => _QRScannerState();
// }
//
// class _QRScannerState extends State<QRScanner> {
//   final qrKey = GlobalKey(debugLabel: 'QR');
//
//   QRViewController? controller;
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   void reassemble() async {
//     super.reassemble();
//
//     if (Platform.isAndroid) {
//       await controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           buidQrView(context),
//           Positioned(
//             child: buildResult(context),
//             bottom: 10,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildResult(BuildContext context) => Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//             color: Colors.white24, borderRadius: BorderRadius.circular(8)),
//         child: Text(
//           barcode != null ? 'Result : ${barcode?.code}' : 'Scan a code!',
//           maxLines: 3,
//           style: TextStyle(
//             color: Colors.white,
//           ),
//         ),
//       );
//
//   Widget buidQrView(BuildContext context) => QRView(
//         key: qrKey,
//         onQRViewCreated: onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//           borderRadius: 10,
//           borderColor: Colors.green,
//           borderLength: 20,
//           borderWidth: 10,
//           cutOutSize: MediaQuery.of(context).size.width * 0.8,
//         ),
//       );
//
//   void onQRViewCreated(QRViewController controller) async {
//     setState(() => this.controller = controller);
//     await controller.scannedDataStream.listen((value) => setState(() {
//           barcode = value;
//         }));
//     if (barcode != null) {
//       Navigator.pop(context, 'done');
//     }
//   }
// }
