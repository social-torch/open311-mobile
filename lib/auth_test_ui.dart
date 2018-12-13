import 'package:flutter/material.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'page.dart';

final userPool = new CognitoUserPool(
  'ap-southeast-1_xxxxxxxxx', 'xxxxxxxxxxxxxxxxxxxxxxxxxx');

final userAttributes = [
  new AttributeArg(name: 'first_name', value: 'Jimmy'),
  new AttributeArg(name: 'last_name', value: 'Wong'),
];

class AuthTestUiPage extends Page {
  AuthTestUiPage() : super(const Icon(Icons.map), 'Auth Test');

  @override
  Widget build(BuildContext context) {
    return const AuthTestUiBody();
  }
}

class AuthTestUiBody extends StatefulWidget {
  const AuthTestUiBody();

  @override
  State<StatefulWidget> createState() => AuthTestUiBodyState();
}

class AuthTestUiBodyState extends State<AuthTestUiBody> {
  AuthTestUiBodyState();

  int _counter = 0;

  void register() async {
    var data;
    try {
      data = await userPool.signUp('email@example.com', 'Password001',
          userAttributes: userAttributes);
      setState(() {
        _counter++;
      });
      print(data);
    } catch (e) {
      print(e);
      setState(() {
        _counter--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: register,
        tooltip: 'Register',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
