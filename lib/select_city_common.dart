import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'data.dart';
import 'services.dart';
import 'requests.dart';
import "globals.dart" as globals;
import "custom_widgets.dart";
import "custom_colors.dart";
import 'utils.dart';

Future<int> getServices(endpoint) async {
  final Dio dio = Dio();
  int retval = 0;
  try {
    retval++;
    Response response = await dio.get(
      endpoint,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: globals.userIdToken
        },
      ),
    );
    CityData().serv_resp = ServicesResponse.fromJson(response.data);
  } catch (error, stacktrace) {
    assert(() {
      //Using assert here for debug only prints
      print("Exception occured: $error stackTrace: $stacktrace");
      return true;
    }());
    getServices(endpoint).then((cnt) { retval += cnt; });
  }
  return retval;
}

Future<int> getRequests(endpoint) async {
  final Dio dio = Dio();
  int retval = 0;
  try {
    retval++;
    Response response = await dio.get(
      endpoint,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: globals.userIdToken
        },
      ),
    );
    CityData().req_resp = RequestsResponse.fromJson(response.data);

    //For guest user we only show latest 25 items, lets filter them out now.
    RequestsResponse req_resp = CityData().req_resp;
    while(req_resp.requests.length > 25)
    {
      var oldestIdx = 0;
      for (var i=1; i<req_resp.requests.length; i++)
      {
        if (getLatestDateString(req_resp.requests[oldestIdx].requested_datetime, req_resp.requests[i].requested_datetime) == req_resp.requests[oldestIdx].requested_datetime)
        {
          oldestIdx = i;
        }
      }
      req_resp.requests.removeAt(oldestIdx);
    }
    CityData().limited_req_resp = req_resp;
  } catch (error, stacktrace) {
    assert(() {
      //Using assert here for debug only prints
      print("Exception occured: $error stackTrace: $stacktrace");
      return true;
    }());
    getRequests(endpoint).then((cnt) { retval += cnt; });
  }
}

Widget setMyCity(BuildContext context, String nextPage) {
  //TODO: verify the sleep below is no longer needed
  while (CityData().cities_resp == null) {
    sleep(const Duration(seconds: 1));
  }
  return Expanded( 
    child: new ListView.builder (
      itemCount: CityData().cities_resp.cities.length,
      itemBuilder: (BuildContext context, int Index) {
        return new Column(
          children: [
            new ColorSliverButton(
              child: Text(CityData().cities_resp.cities[Index].city_name),
              onPressed: () {
                globals.endpoint311 = CityData().cities_resp.cities[Index].endpoint;
                globals.cityIdx = Index;
                getServices(globals.endpoint311 + "/services");
                getRequests(globals.endpoint311 + "/requests");
                Navigator.of(context).pushReplacementNamed(nextPage);
              },
            ),
            Container(height: 15.0),
          ]
        );
      },
    ),
  );
}
