import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR extends StatefulWidget {
  const ScanQR({super.key});

  @override
  State<StatefulWidget> createState() => ScanQRState();
}

class ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isFlashOn = false;
  bool isFrontCamera = false;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Scanner un qr code ami', style: theme.textTheme.displaySmall),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(alignment: Alignment.center, children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          cameraFacing: isFrontCamera ? CameraFacing.front : CameraFacing.back,
        ),
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  isFlashOn ? Icons.flashlight_off : Icons.flashlight_on,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (controller != null) {
                    controller!.toggleFlash();
                    setState(() {
                      isFlashOn = !isFlashOn;
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.flip_camera_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (controller != null) {
                    controller!.flipCamera();
                    setState(() {
                      isFrontCamera = !isFrontCamera;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      Navigator.of(context).pop(scanData.code);
    });
  }
}
