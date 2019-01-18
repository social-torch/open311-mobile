import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'location.dart';
import 'bottom_app_bar.dart';


class ViewSubmittedPage extends Page {
  ViewSubmittedPage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const ViewSubmittedBody();
  }
}

class ViewSubmittedBody extends StatefulWidget {
  const ViewSubmittedBody();

  @override
  State<StatefulWidget> createState() => ViewSubmittedBodyState();
}
          
class ViewSubmittedBodyState extends State<ViewSubmittedBody> {
  ViewSubmittedBodyState();

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
      body: new RaisedButton(
        onPressed: nextPage,
        child: new Text(
        "ViewSubmitted",
        ),
      ),
    );
  }
}


