import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'page.dart';
import 'data.dart';
import "globals.dart" as globals;
import "custom_widgets.dart";
import "custom_colors.dart";

class UserDataRightsPage extends Page {
  UserDataRightsPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const UserDataRightsBody();
  }
}

class UserDataRightsBody extends StatefulWidget {
  const UserDataRightsBody();

  @override
  State<StatefulWidget> createState() => UserDataRightsBodyState();
}

class UserDataRightsBodyState extends State<UserDataRightsBody> {
  UserDataRightsBodyState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
        automaticallyImplyLeading: false,
      ),
      body: Row (
        children: [
          Container(
            width: 36.0,
          ),
          Expanded(
            child: Column(
              children: [
                Container(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: Text( 
                      'User Data Rights:',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                SizedBox (
                        width: 2 * DeviceData().ButtonHeight,
                        child: Image.asset('images/logo.png'),
                      ),
                Container(height: 10.0),
                Text("User data provided to Social Torch such as images, descriptions, locations and email addresses will only be used to provide localities with information related to issue reporting."),
                Container(height: 30.0),
                ColorSliverButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/select_city');
                  },
                  child: Text("Understood"),
                ),

              ]
            ),
          ),
          Container(
            width: 36.0,
          ),
        ]
      ),
    );
  }
}


