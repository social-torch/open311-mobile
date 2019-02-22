import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import "cities.dart";
import "data.dart";
import "select_city.dart";
import "login.dart";
import "my_homepage.dart";
import "new_report.dart";
import "view_submitted.dart";
import "view_submitted_item.dart";
import "all_reports.dart";
import "settings.dart";
import "settings_select_city.dart";
import "location.dart";
import "issue_type.dart";
import "description.dart";
import "submit.dart";
import "globals.dart" as globals;
import "reset_pwd_page.dart";

import 'dart:io';

Future<void> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    globals.cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.descrption');
  }
  runApp(MaterialApp(
    home: MyApp(),
    routes: {
    '/my_homepage': (context) => HomePage(),
    '/login': (context) => AuthPage(),
    '/reset_password': (context) => ResetPasswordPage(),
    '/new_report': (context) => NewReportPage(),
    '/view_submitted': (context) => ViewSubmittedPage(),
    '/view_submitted_item': (context) => ViewSubmittedItemPage(),
    '/all_reports': (context) => AllReportsPage(),
    '/settings': (context) => SettingsPage(),
    '/settings_select_city': (context) => SettingsSelectCityPage(),
    '/location': (context) => LocationUiPage(),
    '/issue_type': (context) => IssueTypePage(),
    '/description': (context) => DescriptionPage(),
    '/submit': (context) => SubmitPage(),
  },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

void _getCities(endpoint) async {
  final Dio dio = Dio();
  try {
    Response response = await dio.get(endpoint);
    CityData().cities_resp = CitiesResponse.fromJson(response.data);
    assert(() {
      //Using assert here for debug only prints
      print(response.data);
      return true;
    }());
  } catch (error, stacktrace) {
    print("Exception occured: $error stackTrace: $stacktrace");
  }
}

class _MyAppState extends State<MyApp> {   
  @override
  Widget build(BuildContext context) {

  //Initialize App Device data
  DeviceData().ButtonHeight = MediaQuery.of(context).size.height * 0.08;
  DeviceData().DeviceWidth= MediaQuery.of(context).size.width;

  _getCities(globals.endpoint311base + "/cities");

  return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: SelectCityPage(),
      title: new Text('Open311 Schenectady, NY',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Colors.white,
      ),),
      image: new Image.network( 
        'https://scontent-ort2-1.xx.fbcdn.net/v/t1.0-9/45111551_10155479038251853_7726811169557577728_n.jpg?_nc_cat=109&_nc_ht=scontent-ort2-1.xx&oh=44dd60d3f21d2c403b09a859253ab05c&oe=5CA90733', 
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
      backgroundColor: Colors.black,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 200.0,
      onClick: ()=>print(""),
      loaderColor: Colors.red
    );
  }
}
