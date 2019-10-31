import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'login.dart';
import "cities.dart";
import "utils.dart";
import "globals.dart" as globals;
import "custom_widgets.dart";
import "custom_colors.dart";
import "select_city_common.dart";
import "bottom_app_bar.dart";

class FeedbackPage extends Page {
  FeedbackPage() : super(const Icon(Icons.email), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const FeedbackBody();
  }
}

class FeedbackBody extends StatefulWidget {
  const FeedbackBody();

  @override
  State<StatefulWidget> createState() => FeedbackBodyState();
}

class FeedbackBodyState extends State<FeedbackBody> {
  FeedbackBodyState();

  @override
  void initState() {
    super.initState();
  }

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
                      'Send us your thoughts:',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 10.0),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter some feedback'
                ),
                minLines: 4,
                maxLines: 10,
                maxLength: 1024,
              ),
                Container(height: 10.0),
                ColorSliverButton(
                  onPressed: () {
                    print('Would send user response');
                  },
                    child:Text("Send"))
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


