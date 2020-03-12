import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';
import 'page.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import "cities.dart";
import "data.dart";
import "select_city.dart";
import "login.dart";
import "my_homepage.dart";
import "new_report.dart";
import "update_report.dart";
import "update_report_status.dart";
import "update_report_loc.dart";
import "update_report_img.dart";
import "view_submitted.dart";
import "view_submitted_user.dart";
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
import "reg_page.dart";
import "confirm_page.dart";
import 'authenticate.dart';
import 'request_new_city.dart';
import 'submit_new_city.dart';
import 'user_data_rights.dart';
import 'feedback.dart';

import 'dart:io';

bool showRights = true;

Future<void> main() async {
  try {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  } catch (e) {
    print('Error: $e.code\nError Message: $e.descrption');
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  showRights = prefs.getBool("ShowDataRights") ?? true;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    routes: {
    '/my_homepage': (context) => HomePage(),
    '/login': (context) => AuthPage(),
    '/reset_password': (context) => ResetPasswordPage(),
    '/new_report': (context) => NewReportPage(),
    '/update_report': (context) => UpdateReportPage(),
    '/update_report_status': (context) => UpdateReportStatusPage(),
    '/update_report_loc': (context) => UpdateReportLocPage(),
    '/update_report_img': (context) => UpdateReportImgPage(),
    '/view_submitted': (context) => ViewSubmittedPage(),
    '/view_submitted_user': (context) => ViewSubmittedUserPage(),
    '/view_submitted_item': (context) => ViewSubmittedItemPage(),
    '/all_reports': (context) => AllReportsPage(),
    '/settings': (context) => SettingsPage(),
    '/settings_select_city': (context) => SettingsSelectCityPage(),
    '/location': (context) => LocationUiPage(),
    '/issue_type': (context) => IssueTypePage(),
    '/description': (context) => DescriptionPage(),
    '/submit': (context) => SubmitPage(),
    '/registration': (context) => RegistrationPage(),
    '/confirm': (context) => ConfirmPage(),
    '/select_city': (context) => SelectCityPage(),
    '/request_new_city': (context) => RequestNewCityPage(),
    '/submit_new_city': (context) => SubmitNewCityPage(),
    '/user_data_rights': (context) => UserDataRightsPage(),
      '/feedback': (context) => FeedbackPage()
  },
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {   
  @override
  Widget build(BuildContext context) {

  //Initialize App Device data
  DeviceData().ButtonHeight = MediaQuery.of(context).size.height * 0.08;
  DeviceData().DeviceWidth= MediaQuery.of(context).size.width;
  authenticate();

  // Check if user has already agreed to the User Data Rights
  // To clear this for debugging, go to the phone's settings, Apps, Storage, then clear app data.
  Page nextPage;
  if (showRights) {
    nextPage = UserDataRightsPage();
    print("Need to show user data rights");
  } else {
    nextPage = SelectCityPage();
    print("User data rights were shown, skipping");
  }

  return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: nextPage,
      title: new Text('Social Torch 311',
      style: new TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Colors.white,
      ),),
      image: Image.asset(
        "images/logo.png",
        width: DeviceData().DeviceWidth,
      ),
      backgroundColor: Colors.black,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 200.0,
      onClick: ()=>print(""),
      loaderColor: Colors.red
    );
  }
}
