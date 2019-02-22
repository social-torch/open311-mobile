import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import "custom_widgets.dart";
import "custom_colors.dart";
import "select_city_common.dart";


class SettingsSelectCityPage extends Page {
  SettingsSelectCityPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const SettingsSelectCityBody();
  }
}

class SettingsSelectCityBody extends StatefulWidget {
  const SettingsSelectCityBody();

  @override
  State<StatefulWidget> createState() => SettingsSelectCityBodyState();
}

class SettingsSelectCityBodyState extends State<SettingsSelectCityBody> {
  SettingsSelectCityBodyState();

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
                      'Choose your city:',
                      textAlign: TextAlign.center,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                setMyCity(context, "/settings"),
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


