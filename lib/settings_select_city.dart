import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
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
      Response response = await dio.get(globals.endpoint311base + "/cities");
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
      getBodyText().then((wdgt) {
        retval = wdgt;
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
                Container(height: 30.0),
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


