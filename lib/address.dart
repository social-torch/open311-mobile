import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'photo.dart';

class AddressPage extends Page {
  AddressPage() : super(const Icon(Icons.map), 'Report Address');

  @override
  Widget build(BuildContext context) {
    return const AddressBody();
  }
}

class AddressBody extends StatefulWidget {
  const AddressBody();

  @override
  State<StatefulWidget> createState() => AddressBodyState();
}

class AddressBodyState extends State<AddressBody> {
  AddressBodyState();
  var _street = null;
  var _city = null;
  var _state = null;
  var _zip = null;
  final streetCntl = TextEditingController();
  final cityCntl = TextEditingController();
  final stateCntl = TextEditingController();
  final zipCntl = TextEditingController();

  void whoops() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text('Please fill in all fields'),
        );
      },
    );
  }

  void nextPage() {
    setState(() {
      _street = streetCntl.text;
      _city = cityCntl.text;
      _state = stateCntl.text;
      _zip = zipCntl.text;
    });

    if (_street == '') {
      whoops();
      return;
    }
    if (_city == '') {
      whoops();
      return;
    }
    if (_state == '') {
      whoops();
      return;
    }
    if (_zip == '') {
      whoops();
      return;
    }


    var addrd = new AddressData();
    addrd.street = _street;
    addrd.city = _city;
    addrd.state = _state;
    addrd.zip = _zip;
    var rp = new ReportData();
    rp.address = addrd;
    assert(() {
      //Using assert here for debug only prints
      print(rp);
      return true;
    }());

    //If we have made it to here, then it is time to go to submit page
    var page = PhotoPage();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(page.title)),
          body: page,
        ),
      ),
    );
  }

  @override
  void initState() {
    //Remove lat/long if user is inputting address
    ReportData().latlng = null;
    super.initState();
  }

  @override
  void dispose() {
    streetCntl.dispose();
    cityCntl.dispose();
    stateCntl.dispose();
    zipCntl.dispose();

    //If user backs out remove address, they may choose lat/long instead
    ReportData().address = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: [
          new Column(
            children: <Widget>[
              new TextField(
                controller: streetCntl,
                decoration: InputDecoration(
                  hintText: 'Street',
                ),
              ),
              new TextField(
                controller: cityCntl,
                decoration: InputDecoration(
                  hintText: 'city',
                ),
              ),
              new TextField(
                controller: stateCntl,
                decoration: InputDecoration(
                  hintText: 'state',
                ),
              ),
              new TextField(
                controller: zipCntl,
                decoration: InputDecoration(
                  hintText: 'zip',
                ),
              ),
              new RaisedButton(
                onPressed: nextPage,
                child: new Text( 
                "Next", 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
