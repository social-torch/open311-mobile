import 'package:flutter/material.dart';
import 'page.dart';
import "location.dart";

class ReportPage extends Page {
  ReportPage() : super(const Icon(Icons.map), 'Report a problem');

  @override
  Widget build(BuildContext context) {
    return const ReportBody();
  }
}

class ReportBody extends StatefulWidget {
  const ReportBody();

  @override
  State<StatefulWidget> createState() => ReportBodyState();
}

class ReportBodyState extends State<ReportBody> {
  ReportBodyState();

  final descController = TextEditingController();
  var _description = null;
  final List<String> _list = const [ 
                'Broken Sidewalk', 
                'Pothole',
                'Snow Removal',
                'Building Code Violation',
                'Working without Permit',
                'Improper Zoning',
                'Body Shop work in street',
                'Public Nuisance',
                'Park Complaint',
                'Tree Complaint',
                'Missed Trash Pickup',
                'Steet Light Out'
              ];
  var _dSelect = null;

  void nextPage() {
    if (_dSelect == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Please select a report type'),
          );
        },
      );
      return;
    }

    setState(() {
      _description = descController.text;
    });

    //If we have made it to here, then it is time to select a location/address
    var page = LocationUiPage();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(page.title)),
          bottomNavigationBar: BottomAppBar(
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(icon: Icon(Icons.menu), onPressed: () {},),
                IconButton(icon: Icon(Icons.search), onPressed: () {},),
              ],
            ),
          ),
          body: page,
        ),
      ),
    );
  }

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: [
          new Column(
            children: <Widget>[
  	      new Text(
                'Please enter a report type',
                textAlign: TextAlign.center,
              ),
              new DropdownButton<String>(
                value: _dSelect,
                items: _list.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) { setState(() { _dSelect = value; }); },
              ),
  	      new Text(
                'Description (optional)',
                textAlign: TextAlign.center,
              ),
              new TextField(
                keyboardType: TextInputType.multiline,
                controller: descController,
                maxLines: 10,
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
