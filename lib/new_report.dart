import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'location.dart';
import 'bottom_app_bar.dart';


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

  @override
  void initState() {
    super.initState();
  }

  void nextPage() {
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
      body: new RaisedButton(
        onPressed: nextPage,
        child: new Text(
        "Next",
        ),
      ),
    );
  }
}


