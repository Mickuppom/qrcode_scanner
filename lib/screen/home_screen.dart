import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController input = new TextEditingController();
  bool isCameraPermissionEnabled = false;

  void scan() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      input.text = cameraScanResult;
    });
  }

  void share() {}

  void copy() {}

  void checkPermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        isCameraPermissionEnabled = true;
      });
    }
    if (await Permission.camera.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code Scaner"),
      ),
      body: !isCameraPermissionEnabled
          ? Center(
              child: ElevatedButton(
                onPressed: () => openAppSettings(),
                child: Text("Setting"),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Text("Press Scan Button"),
                  Stack(
                    children: [
                      TextFormField(
                        controller: input,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 12,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: copy,
                              icon: Icon(Icons.copy),
                              label: Text("Copy"),
                            ),
                            ElevatedButton.icon(
                              onPressed: share,
                              icon: Icon(Icons.share),
                              label: Text("Share"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: ElevatedButton.icon(
                      onPressed: scan,
                      icon: Icon(Icons.camera),
                      label: Text("Scan"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
