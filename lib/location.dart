import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoder/geocoder.dart';
import 'page.dart';
import 'issue.dart';
import 'photo.dart';
import 'data.dart';
import 'custom_widgets.dart';
import 'custom_icons.dart';
import 'custom_colors.dart';
import 'bottom_app_bar.dart';

class LocationUiPage extends Page {
  LocationUiPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const LocationUiBody();
  }
}

class LocationUiBody extends StatefulWidget {
  const LocationUiBody();

  @override
  State<StatefulWidget> createState() => LocationUiBodyState();
}

class LocationUiBodyState extends State<LocationUiBody> {
  LocationUiBodyState();
 
  final addrController = TextEditingController();
  //Map variables
  var _defaultLoc = LatLng(42.8137, -73.9398);
  LatLng _markerLoc = null;
  var _defaultZoom = 15.0;
  MapController _mapController = MapController();

  //Location variables
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = new Location();
  bool _permission = false;
  String error;

  @override
  void initState() {
    initPlatformState();
    _locationSubscription = _location.onLocationChanged().listen((Map<String,double> result) {
      setState(() {
        _currentLocation = result;
        assert(() {
          //Using assert here for debug only prints
          print(_currentLocation["latitude"]);
          print(_currentLocation["longitude"]);
          print(_currentLocation["accuracy"]);
          print(_currentLocation["altitude"]);
          print(_currentLocation["speed"]);
          print(_currentLocation["speed_accuracy"]); // Will always be 0 on iOS
          return true;
        }());
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    //If user backs out remove address, they may choose lat/long instead
    ReportData().latlng = null;
    addrController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();
      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'Permission denied - please ask the user to enable it from the app settings';
      }
      //Default location to center on schenectady, ny
      location["latitude"] = _defaultLoc.latitude;
      location["longitude"] = _defaultLoc.longitude;
    }

    var latlng = LatLng(location["latitude"], location["longitude"]);
    setState(() {
      _currentLocation = location;
      _markerLoc = latlng;
    });
    _mapController.move(latlng, _defaultZoom);
    
  }

  void _handleTap(LatLng latlng) {
    setState(() {
      _markerLoc = latlng;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_markerLoc == null) {
      _markerLoc = _defaultLoc;
    }
   

    var markers = <Marker>[
      new Marker(
        width: 40.0,
        height: 40.0,
        point: _markerLoc,
        builder: (ctx) => new Container(
          child: new GestureDetector(
            child: new Icon(
              Icons.place,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    ];

    if (_currentLocation != null) {
      markers.add(
        new Marker(
          width: 40.0,
          height: 40.0,
          point: LatLng(_currentLocation["latitude"], _currentLocation["longitude"]),
          builder: (ctx) => new Container(
            child: new GestureDetector(
              child: new Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      );
    }

    final fm = FlutterMap(
      mapController: _mapController,
      options: new MapOptions(
        center: _defaultLoc,
        zoom: _defaultZoom,
        minZoom: 13.0,
        maxZoom: 19.0,
        swPanBoundary: LatLng(42.761463, -73.986886),
        nePanBoundary: LatLng(42.844432, -73.886104),
        onTap: _handleTap,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate:
            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']
        ),
        new MarkerLayerOptions(markers: markers)
      ],
    );

    return new Scaffold (
      appBar: AppBar(
        title: Text(APP_NAME),
        backgroundColor: CustomColors.appBarColor,
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
                      'Choose the Location',
                      textAlign: TextAlign.left,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                ProgressDots(
                  stage: 1,
                  numStages: 4,
                ),
                Container(height: 10.0),
                ColorSliverTextField(
                  controller: addrController,
                  labelText: 'Enter a location',
                  onEditingComplete: () {
                    //final query = "807 Union St, Schenectady, NY 12308";
                    //var addresses = await Geocoder.local.findAddressesFromQuery(query);
                    //var first = addresses.first;
                    //print("${first.featureName} : ${first.coordinates}");
                  },
                ),
                Flexible( 
                  child: Stack(
                    children: [
                      fm,
                      Positioned(
                        left: 4.0,
                        bottom: 5.0,
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0.0,
                        bottom: 1.0,
                        child: new IconButton(
                          icon: new Icon(Icons.my_location, color: Colors.black),
                          highlightColor: Color(0xFFFFFF),
                          onPressed: () {
                            setState(() {
                              var latlng = LatLng(_currentLocation["latitude"], _currentLocation["longitude"]);
                              _markerLoc = latlng;
                            });
                          },
                        ),
                      ),
                    ]
                  ),
                ),
                Row(
                  children: [                                                                        
                    FlatButton(                                                                        
                      color: CustomColors.appBarColor,
                      textColor: Colors.white,
                      onPressed: () {
                        var rp = new ReportData();
                        rp.latlng = _markerLoc;
                         assert(() {
                           //Using assert here for debug only prints
                           print(rp);
                           return true;
                         }());
                        Navigator.of(context).pushNamed('/issue_type');
                      },
                      child: Text( "Confirm Location"),
                    ),
                  ]
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
