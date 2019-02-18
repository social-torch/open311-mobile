import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'page.dart';
import 'data.dart';
import 'bottom_app_bar.dart';
import 'custom_widgets.dart';
import 'custom_colors.dart';
import 'login.dart';
//import 'sign_up.dart';
import 'reg_page.dart';

// homepage

class HomePage extends StatefulWidget {
	static String tag = 'home-page';

	@override
	_HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

	@override
	Widget build(BuildContext context) {

		return new Scaffold (
			appBar: AppBar(
				title: Text(APP_NAME),
				backgroundColor: CustomColors.appBarColor,
				automaticallyImplyLeading: false,
			),
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
													'Welcome',
													textAlign: TextAlign.center,
													textScaleFactor: 2.0,
												),
											),
										),
										Container(height: 30.0),
										SizedBox(
											width: 2 * DeviceData().ButtonHeight,
											child: Image.asset('images/logo.png'),
										),
										Container(height: 30.0),
										SizedBox(
											width: double.infinity,
											child: Container(
												child: Text(
													'Create an account to log in. View and track your submitted issues.',
													textAlign: TextAlign.center,
													textScaleFactor: 1.0,
												),
											),
										),
										Container(height: 15.0),
										ColorSliverButton(
											onPressed: () {
												Navigator.push(
													context,
													MaterialPageRoute(builder: (context) => AuthPage()),
												);
											},
											child: Text( "Login"),
										),
										Container(height: 15.0),
										ColorSliverButton(
											onPressed: () {
												Navigator.push (
													context,
													MaterialPageRoute(builder: (context) => RegistrationPage()),
												);
											},
											child: Text( "Sign Up"),
										),
										Container(height: 15.0),
										ColorSliverButton(
											onPressed: () {
												Navigator.push (
													context,
													MaterialPageRoute(builder: (context) => AuthPage()),
												);
											},
											child: Text( "Sign In As Guest"),
										),
										Container(height: 15.0),
										SizedBox(
											width: double.infinity,
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
