import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'page.dart';
import 'data.dart';
import 'camera_ui.dart';
import 'location.dart';
import 'issue_type.dart';
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';


class NewReportPage extends Page {
  NewReportPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const NewReportBody();
  }
}

class NewReportBody extends StatefulWidget {
  const NewReportBody();

  @override
  State<StatefulWidget> createState() => NewReportBodyState();
}
          
class NewReportBodyState extends State<NewReportBody> {
  NewReportBodyState();
  Future<File> _image;

  void getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void locPage() {
    //If we have made it to here, then it is time to select a location/address
    var page = LocationUiPage();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(page.title)),
          bottomNavigationBar: commonBottomBar(context),
          body: page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: AppBar(title: Text(APP_NAME)),
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
                      'Select an Image',
                      textAlign: TextAlign.left,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                ProgressDots(
                  stage: 0,
                  numStages: 4,
                ),
                Container(height: 30.0),
                ColorSliverButton(
                  onPressed: () { getImage(ImageSource.camera); },
                  child: Text( "Camera"),
                ),
                Container(height: 15.0),
                ColorSliverButton(
                  onPressed: () { getImage(ImageSource.gallery); },
                  child: Text( "Photo Library"),
                ),
                Container(height: 15.0),
                ColorSliverButton(
                  onPressed: locPage,
                  child: Text( "Most Recent"),
                ),
                Container(height: 15.0),
                ColorSliverButton(
                  onPressed: locPage,
                  child: Text( "No Photo"),
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


