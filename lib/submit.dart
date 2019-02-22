import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'page.dart';
import 'data.dart';
import 'requests.dart';
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import "globals.dart" as globals;

class SubmitPage extends Page {
  SubmitPage() : super(const Icon(Icons.map), 'Submit Report');

  @override
  Widget build(BuildContext context) {
    return const SubmitBody();
  }
}

class SubmitBody extends StatefulWidget {
  const SubmitBody();

  @override
  State<StatefulWidget> createState() => SubmitBodyState();
}

class SubmitBodyState extends State<SubmitBody> {
  SubmitBodyState();

  void _apiGateway() async
  {
    try {

      //Populate our request with user data
      Requests req = new Requests(
        "",
        "",
        "",
        ReportData().type,
        ReportData().type_code,
        ReportData().description,
        "",
        "",
        "",
        "",
        "",
        "",
        ReportData().addr,
        0,
        ReportData().latlng.latitude, 
        ReportData().latlng.longitude, 
        "");

      //Send post of user request to backend
      var endpoint = globals.endpoint311 + "/request";
      Response response;
      Dio dio = new Dio();
      response = await dio.post(
        endpoint,
        data: req.toJson(),
      );
      assert(() {
        //Using assert here for debug only prints
        print(response.data);
        print(response.headers);
        print(response.request);
        return true;
      }());
    } catch (e) {
      print(e);
    }
  }
  
  @override
  Widget build(BuildContext context) {

    _apiGateway();
    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: commonBottomBar(context),
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
                      'Your service request has been submitted',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                SizedBox(
                  width: 2 * DeviceData().ButtonHeight,
                  child: Image.asset('images/confirmation.png'),
                ),
                Container(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: Text(
                      'Create an account of log in to view and track your submitted issues.',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.0,
                    ),
                  ),
                ),
                Container(height: 15.0),
                ColorSliverButton(
                  onPressed: () { },
                  child: Text( "Login"),
                ),
                Container(height: 15.0),
                ColorSliverButton(
                  onPressed: () { },
                  child: Text( "Sign Up"),
                ),
                Container(height: 15.0),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: new TextSpan (
                        text: "Forgot Password",
                        style: new TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: new TapGestureRecognizer()
                        ..onTap = () { Navigator.of(context).pushNamedAndRemoveUntil('/reset_password', ModalRoute.withName('/login')); },
                      )
                    ),
                  ),
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
