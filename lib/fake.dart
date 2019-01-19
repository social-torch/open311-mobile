import 'package:flutter/material.dart';
import 'page.dart';
import 'data.dart';
import 'login.dart';


class FakePage extends Page {
  FakePage() : super(const Icon(Icons.map), APP_NAME);

  @override
  Widget build(BuildContext context) {
    return const FakeBody();
  }
}

class FakeBody extends StatefulWidget {
  const FakeBody();

  @override
  State<StatefulWidget> createState() => FakeBodyState();
}
          
class FakeBodyState extends State<FakeBody> {
  FakeBodyState();

  initNav(context) {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initNav(context));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      body: new Text("NA")
    );
  }
}


