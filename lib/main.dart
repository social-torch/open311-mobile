import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'map_ui.dart';
import 'page.dart';
import 'report.dart';
import "place_marker.dart";
import "camera_ui.dart";
import "reg_page.dart";
import "confirm_page.dart";
import "resend_confirm_page.dart";
import "auth_page.dart";
import "globals.dart" as globals;

final List<Page> _allPages = <Page>[
  MapUiPage(),
  PlaceMarkerPage(),
  CameraUiPage(),
  RegistrationPage(),
  ConfirmPage(),
  ResendConfirmPage(),
  AuthPage(),
  ReportPage(),
];


Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    globals.cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.descrption');
  }
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  void _pushPage(BuildContext context, Page page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) =>
            Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open311 Schenectady, NY')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) =>
            ListTile(
              leading: _allPages[index].leading,
              title: Text(_allPages[index].title),
              onTap: () => _pushPage(context, _allPages[index]),
            ),
      ),
    );
  }
}

