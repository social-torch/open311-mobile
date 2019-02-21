import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'page.dart';
import 'data.dart';
import 'login.dart';
import "services.dart";
import "requests.dart";
import "globals.dart" as globals;
import "custom_widgets.dart";
import "custom_colors.dart";


class SelectCityPage extends Page {
  SelectCityPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const SelectCityBody();
  }
}

class SelectCityBody extends StatefulWidget {
  const SelectCityBody();

  @override
  State<StatefulWidget> createState() => SelectCityBodyState();
}

void _getServices(endpoint) async {
  final Dio dio = Dio();
  try {
    Response response = await dio.get(endpoint);
    CityData().serv_resp = ServicesResponse.fromJson(response.data);
  } catch (error, stacktrace) {
    print("Exception occured: $error stackTrace: $stacktrace");
  }
}

void _getRequests(endpoint) async {
  final Dio dio = Dio();
  try {
    Response response = await dio.get(endpoint);
    CityData().req_resp = RequestsResponse.fromJson(response.data);
  } catch (error, stacktrace) {
    print("Exception occured: $error stackTrace: $stacktrace");
  }
}

Widget _setMyCity(BuildContext context) {
  while (CityData().cities_resp == null) {
    sleep(const Duration(seconds: 1));
  }
  return Expanded( child: new ListView.builder (
    itemCount: CityData().cities_resp.cities.length,
    itemBuilder: (BuildContext context, int Index) {
      return  new ColorSliverButton(
        child: Text(CityData().cities_resp.cities[Index].city_name),
        onPressed: () {
          globals.endpoint311 = CityData().cities_resp.cities[Index].endpoint;
          _getServices(globals.endpoint311 + "/services");
          _getRequests(globals.endpoint311 + "/requests");
          Navigator.of(context).pushReplacementNamed('/my_homepage');
        },
      );
    },
  ),
  );
}
          
class SelectCityBodyState extends State<SelectCityBody> {
  SelectCityBodyState();

  //This function will only run if user has already chosen a default city
  initNav(context) {
    if (globals.endpoint311 != 'nada') {
      Navigator.of(context).pushReplacementNamed('/my_homepage');
    }
  }

  //Get city to use to determine endpoint calls, unless a default already exists
  Widget _getBody(BuildContext context) {
    Widget retval = Text(" ");
    if (globals.endpoint311 == 'nada') {
      retval = _setMyCity(context);
    }
    return retval;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initNav(context));
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


