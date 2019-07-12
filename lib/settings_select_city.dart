import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'utils.dart';
import 'cities.dart';
import "custom_widgets.dart";
import "custom_colors.dart";
import "select_city_common.dart";
import "globals.dart" as globals;


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

  Widget _bodyWidget;

  @override
  void initState() {
    super.initState();
    getBodyText().then((newBodyWidget) {
      setState(() {
        _bodyWidget = newBodyWidget;
      });
    });
  }

  Future<Widget> getBodyText() async {
    Widget retval;
    final Dio dio = Dio();
    try {
      Response response = await dio.get(
        globals.endpoint311base + "/cities",
        options: Options(
          headers: {
            HttpHeaders.authorizationHeader: globals.userIdToken
          },
        ),
      );
      CityData().cities_resp = CitiesResponse.fromJson(response.data);
      assert(() {
        //Using assert here for debug only prints
        print(response.data);
        return true;
      }());
      retval = setMyCity(context, "/settings");
    } catch (error, stacktrace) {
      assert(() {
        //Using assert here for debug only prints
        print("Exception occured: $error stackTrace: $stacktrace");
        return true;
      }());
      //This is a poor mans threadish way to doing processing on the side without deadlocking async
      compute(sleepThread, 1).then((num) {
        getBodyText().then((wdgt) {
          retval = wdgt;
        });
      });
    }
    return retval;
  }

  Widget _getBody(BuildContext context) {
    Widget retval = Text("Loading available cities...");
    if (_bodyWidget != null) {
      retval = _bodyWidget;
    }
    return retval;
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
                Container(height: 10.0),
                RichText(
                  text: new TextSpan (
                    children: [
                      new TextSpan(
                        text: "Don't see your city?",
                        style: new TextStyle(color: Colors.blue),
                        recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushNamed('/request_new_city');
                        },
                      ),
                    ],
                  )
                ),
                Container(height: 10.0),
                _getBody(context),
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


