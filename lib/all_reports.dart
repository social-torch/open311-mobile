import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoder/geocoder.dart';
import 'page.dart';
import 'data.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'custom_icons.dart';
import 'custom_colors.dart';
import 'bottom_app_bar.dart';
import 'view_submitted.dart';
import 'globals.dart' as globals;

class AllReportsPage extends Page {
  AllReportsPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const AllReportsBody();
  }
}

class AllReportsBody extends StatefulWidget {
  const AllReportsBody();

  @override
  State<StatefulWidget> createState() => AllReportsBodyState();
}

Positioned __guestRestrictionMessage() {
  String restriction = "Only 25 Events are showing. Login in or sign up to view all events.";
  if (globals.userName == globals.guestName) {
    return new Positioned(
      top: 70,
      left: 25,
      right: 25,
      child: new Container (
        padding: EdgeInsets.all(5.0),
        alignment: Alignment.topCenter,
        width: DeviceData().DeviceWidth,
        color: Colors.white,
        child: new Text(
          restriction,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w200, fontSize: 16),
          textScaleFactor: 1.0,
        ),
      )
    );
  } else {
    return new Positioned(
        top: 70,
        left: 25,
        right: 25,
      child: new Container(

      ),
    );
  }
}

class AllReportsBodyState extends State<AllReportsBody> {
  AllReportsBodyState();
 
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

  void _addressToLatLng(String address) async {
    var addresses = await Geocoder.local.findAddressesFromQuery(address);
    if (addresses.length > 0) {
      var first = addresses.first;
      assert(() {
        //Using assert here for debug only prints
        print("${first.featureName} : ${first.coordinates}");
        return true;
      } ());
      setState(() {
        _markerLoc = LatLng(first.coordinates.latitude, first.coordinates.longitude);
      });
      _mapController.move(_markerLoc, _defaultZoom);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_markerLoc == null) {
      _markerLoc = _defaultLoc;
    }
   
    var markers = List<Marker>();

    if ((CityData().req_resp != null) && (CityData().limited_req_resp != null)) {
      if (globals.userName == globals.guestName) {
        for (var i=0; i<CityData().limited_req_resp.requests.length; i++) {
          markers.add(
            new Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(CityData().limited_req_resp.requests[i].lat, CityData().limited_req_resp.requests[i].lon),
              builder: (ctx) => new Container(
                child: new GestureDetector(
                  child: new Icon(
                    Icons.place,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          );
        }
      } else {
        for (var i=0; i<CityData().req_resp.requests.length; i++) {
          markers.add(
            new Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(CityData().req_resp.requests[i].lat, CityData().req_resp.requests[i].lon),
              builder: (ctx) => new Container(
                child: new GestureDetector(
                  child: new Icon(
                    Icons.place,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

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
        //swPanBoundary: LatLng(42.761463, -73.986886),
        //nePanBoundary: LatLng(42.844432, -73.886104),
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
      body: new Column( 
        children: [
          new Flexible( 
            child: Stack(
              children: [
                fm,
                Positioned(
                  right: 9.0,
                  bottom: 15.0,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      color: CustomColors.appBarColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  right: 5.0,
                  bottom: 11.0,
                  child: new IconButton(
                    icon: new Icon(Icons.my_location, color: Colors.white),
                    highlightColor: Color(0xFFFFFF),
                    onPressed: () {
                      setState(() {
                        if (_currentLocation != null) {
                          var latlng = LatLng(_currentLocation["latitude"], _currentLocation["longitude"]);
                          _markerLoc = latlng;
                          _mapController.move(latlng, _mapController.zoom);
                        }
                      });
                    },
                  ),
                ),
                Positioned(
                   top: 5.0,
                  child: new Container (
                    width: DeviceData().DeviceWidth,
                    alignment: Alignment(0.0, 0.0),
                    child: FlatButton(
                      color: CustomColors.appBarColor,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                      onPressed:() {
                        Navigator.push (
                          context,
                          MaterialPageRoute(builder: (context) => ViewSubmittedPage()),
                        );
                      },
                      child: new Text(
                        "List View",
                        textScaleFactor: 2.0,
                      ),
                    ),
                  ),
                ),
                __guestRestrictionMessage(),
                Positioned(
                  left: 36.0,
                  bottom: 0.0,
                  child: new SizedBox(
                    width: DeviceData().DeviceWidth - 108.0,
                    child: new ColorSliverTextField(
                      controller: addrController,
                      labelText: 'Enter a location',
                      onEditingComplete: () {
                        _addressToLatLng(addrController.text);
                      },
                    ),
                  ),
                ),
              ]
            ),
          ),
        ]
      ),
    );
  }
}
