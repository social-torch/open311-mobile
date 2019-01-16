import 'package:flutter/material.dart';
import 'page.dart';
import "description.dart";
import 'data.dart';

class IssuePage extends Page {
  IssuePage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const IssueBody();
  }
}

class IssueBody extends StatefulWidget {
  const IssueBody();

  @override
  State<StatefulWidget> createState() => IssueBodyState();
}

class IssueBodyState extends State<IssueBody> {
  IssueBodyState();

  final descController = TextEditingController();
  ReportData repd = new ReportData();

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
                'Street Light Out',
                'Speeding in neighborhood',
                'Sewer Issue',
                'Water Leak'
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
      repd.description = descController.text;
      repd.type = _dSelect;
    });

    //If we have made it to here, then it is time to select a location/address
    var page = DescriptionPage();
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
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      body: new Column (
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
