import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'location.dart';
import 'bottom_app_bar.dart';


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
          
class AllReportsBodyState extends State<AllReportsBody> {
  AllReportsBodyState();

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
        "AllReports",
        ),
      ),
    );
  }
}


