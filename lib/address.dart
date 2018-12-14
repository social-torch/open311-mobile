import 'package:flutter/material.dart';
import 'page.dart';
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
      _city = streetCntl.text;
      _state = streetCntl.text;
      _zip = streetCntl.text;
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
  void dispose() {
    streetCntl.dispose();
    cityCntl.dispose();
    stateCntl.dispose();
    zipCntl.dispose();
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
