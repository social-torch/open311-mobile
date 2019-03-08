import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'page.dart';
import 'data.dart';
import 'bottom_app_bar.dart';
import 'submit.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';


class DescriptionPage extends Page {
  DescriptionPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const DescriptionBody();
  }
}

class DescriptionBody extends StatefulWidget {
  const DescriptionBody();

  @override
  State<StatefulWidget> createState() => DescriptionBodyState();
}
          
class DescriptionBodyState extends State<DescriptionBody> {
  DescriptionBodyState();

  final descController = TextEditingController();

  void submitPage() {
    setState(() {
      ReportData().description = descController.text;
    });
 
    Navigator.of(context).pushNamedAndRemoveUntil('/submit', ModalRoute.withName('/login'));
  }

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      resizeToAvoidBottomPadding: false,
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
            child: ListView(
              children: [
                Container(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: Text(
                      'Write a Brief Description',
                      textAlign: TextAlign.left,
                      textScaleFactor: 2.0,
                    ),
                  ),
                ),
                Container(height: 30.0),
                ProgressDots(
                  stage: 3,
                  numStages: 4,
                ),
                Container(height: 30.0),
                ColorSliverTextField(
                  maxLines: 6,
                  controller: descController,
                  labelText: 'Write an optional brief description here'
                ),
                Container(height: 15.0),
                Row(
                  children: [
                    FlatButton(
                      color: CustomColors.appBarColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0)),
                      textColor: Colors.white,
                      onPressed: submitPage,
                      child: Text( "Submit the Issue"),
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


