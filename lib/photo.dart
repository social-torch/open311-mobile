import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'camera_ui.dart';
import 'submit.dart';

class PhotoPage extends Page {
  PhotoPage() : super(const Icon(Icons.map), 'Attach a photo');

  @override
  Widget build(BuildContext context) {
    return const PhotoBody();
  }
}

class PhotoBody extends StatefulWidget {
  const PhotoBody();

  @override
  State<StatefulWidget> createState() => PhotoBodyState();
}

class PhotoBodyState extends State<PhotoBody> {
  PhotoBodyState();

  void getPhoto() {
    //If we have made it to here, then it is time to go to submit page
    var page = CameraUiPage();
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

  void skip() {
    //If we have made it to here, then it is time to go to submit page
    print(ReportData());
    var page = SubmitPage();
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
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: [
          new Column(
            children: <Widget>[
              new RaisedButton(
                onPressed: getPhoto,
                child: new Text( 
                "Attach Photo", 
                ),
              ),
              new FlatButton(
                onPressed: skip,
                child: new Text( 
                "skip", 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
