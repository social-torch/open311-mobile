import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';
import 'package:geocoder/geocoder.dart';
import 'page.dart';
import 'data.dart';
import 'utils.dart';
import 'requests.dart';
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
 
  String filterItem = "Loading";

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
  var _markers = List<Marker>();
  List<Requests> req_list;
  List<int> users_to_req_idx = List();
  List<DropdownMenuItem<String>> req_type_filter_dd = [
    DropdownMenuItem(
      value: 'Loading',
      child: Text('Loading...')
    ),
  ];

  //This is a poor mans threadish way to doing processing on the side without deadlocking async
  void delayedProcessing() {
    compute(sleepThread, 1).then((num) {
      if ((CityData().req_resp != null) && (CityData().limited_req_resp != null) && (CityData().serv_resp != null) ) {
        try {
          setState(() {
            req_type_filter_dd = CityData().serv_resp.services.map((srv) {
              return DropdownMenuItem<String>(
                value: srv.service_name,
                child: Row(
                  children: [
                    //Icon(Icons.filter, color: Colors.white),
                    SizedBox(width: DeviceData().DeviceWidth/2.5, child: Text(" " + srv.service_name)),
                  ]
                ),
              );
            }).toList();
            if (filterItem == "Loading") {
              filterItem = "All";
              req_type_filter_dd.insert(0,
                DropdownMenuItem<String>(
                  value: filterItem,
                  child: Row(
                    children: [
                      //Icon(Icons.filter, color: Colors.white),
                      SizedBox(width: DeviceData().DeviceWidth/2.5, child:  Text(" " + filterItem)),
                    ]
                  ),
                )
              );
            }
            _getMarkers();
          });
        } catch (e) {
          assert(() {
            //Using assert here for debug only prints
            print("User switched menu's before markers loaded, ignoring");
            return true;
          }());
        }
      }
      else
      {
        delayedProcessing();
      }
    });
  } 

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

    delayedProcessing();
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
    try {
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
    } catch (error, stacktrace) {
      assert(() {
        //Using assert here for debug only prints
        print("_addressToLatLng Exception occured: $error stackTrace: $stacktrace");
        return true;
      }());
    }
  }

  //Given a service code find its index in the list of total service codes and
  //  and derive a color from it.  Try and handle as many colors as possible
  //  to enable future service codes.
  
  Color _getColorOfService(String serviceName)
  {
    Color retval = Colors.orange;
    int i = 0;
    for (i=0; i<CityData().serv_resp.services.length; i++)
    {
      if (CityData().serv_resp.services[i].service_name == serviceName)
      {
        break;
      }
    }

    //We only have so many primaries, use shades for indices that go over
    if (i >= Colors.primaries.length) {
      int shadeIdx = ( i / Colors.primaries.length ).toInt();
      if (shadeIdx == 5) {
        shadeIdx++; //500 is a primary switch to 600
      } else if (shadeIdx > 9) {
        shadeIdx = 9; //We have run out of colors eek!
        print("Need to udate color selection code we have run out of colors");
      }
      int primaryIdx = i % Colors.primaries.length;
      retval = Colors.primaries[primaryIdx][shadeIdx];
    } else {
      retval = Colors.primaries[i];
    }
    return retval;
  }

  void _getMarkers() {
    _markers = List<Marker>();
    if (globals.userName == globals.guestName) {
      users_to_req_idx = List();
      req_list = List();
      //Get index of limited to list to total list so when user selects items they get the item they selected
      for (int j=0; j<CityData().limited_req_resp.requests.length; j++) {
        for (int i=0; i<CityData().req_resp.requests.length; i++) {
          if (CityData().req_resp.requests[i].service_request_id == CityData().limited_req_resp.requests[j].service_request_id) {
            req_list.add(new Requests.fromJson(CityData().limited_req_resp.requests[j].toJson()));
            users_to_req_idx.add(i);
            break;
          }
        }
      }
      for (var i=0; i<req_list.length; i++) {
        if ( (filterItem == "All") || (filterItem == req_list[i].service_name) ) { 
          _markers.add(
            new Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(req_list[i].lat, req_list[i].lon),
              builder: (ctx) => new Container(
                child: new GestureDetector(
                  child: new IconButton(
                    icon: new Icon(Icons.place, color: _getColorOfService(req_list[i].service_name)),
                    highlightColor: CustomColors.salmon,
                    onPressed: () {
                      CityData().prevReqIdx = users_to_req_idx[i];
                      Navigator.of(context).pushNamed('/view_submitted_item');
                    }
                  ),
                ),
              ),
            ),
          );
        }
        if ( (CityData().itemSelected != null) && CityData().itemSelected && (CityData().prevReqIdx == users_to_req_idx[i]) ) {
          _mapController.move(LatLng(CityData().req_resp.requests[CityData().prevReqIdx].lat, 
                                     CityData().req_resp.requests[CityData().prevReqIdx].lon),
                              _mapController.zoom);
          CityData().itemSelected = false;
        }
      }
    } else {
      req_list = List();
      CityData().req_resp.requests.forEach((r) => req_list.add(new Requests.fromJson(r.toJson())));
      for (var i=0; i<req_list.length; i++) {
        if ( (filterItem == "All") || (filterItem == req_list[i].service_name) ) { 
          _markers.add(
            new Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(req_list[i].lat, req_list[i].lon),
              builder: (ctx) => new Container(
                child: new GestureDetector(
                  child: new IconButton(
                    icon: new Icon(Icons.place, color: _getColorOfService(req_list[i].service_name),),
                    highlightColor: CustomColors.salmon,
                    onPressed: () {
                      CityData().prevReqIdx = i;
                      Navigator.of(context).pushNamed('/view_submitted_item');
                    }
                  ),
                ),
              ),
            ),
          );
        }
        if ( (CityData().itemSelected != null) && CityData().itemSelected && (CityData().prevReqIdx == i) ) {
          _mapController.move(LatLng(CityData().req_resp.requests[CityData().prevReqIdx].lat, 
                                     CityData().req_resp.requests[CityData().prevReqIdx].lon),
                              _mapController.zoom);
          CityData().itemSelected = false;
        }
      }
    }
    if (_currentLocation != null) {
      _markers.add(
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
  }

  @override
  Widget build(BuildContext context) {

    if (_markerLoc == null) {
      _markerLoc = _defaultLoc;
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
        new MarkerLayerOptions(markers: _markers)
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
                  right: 5.0,
                  top: 5.0,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: CustomColors.appBarColor,
                      borderRadius: new BorderRadius.circular(9.0),
                    ),
                    child: new Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: CustomColors.appBarColor,
                      ), 
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: filterItem,
                            style: new TextStyle(
                              color: CustomColors.salmon,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                filterItem = newValue;
                                _getMarkers();
                              });
                            },
                            items: req_type_filter_dd,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5.0,
                  left: 5.0,
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
                        if (addrController.text != "" ) {
                          _addressToLatLng(addrController.text);
                        }
                        FocusScope.of(context).unfocus();
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
