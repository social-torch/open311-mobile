import 'package:flutter/material.dart';
import 'new_report.dart';
import 'view_submitted.dart';
import 'all_reports.dart';
import 'settings.dart';
import 'custom_colors.dart';

String navPage = "nada";

Color _currentPage(currentPage) {
  if (navPage == currentPage) {
    return CustomColors.salmon;
  }
  return Colors.black;
}

Widget commonBottomBar(context) {
  return BottomAppBar(
    child: new Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Image.asset("images/add new.png"),
              color: _currentPage("/new_report"),
              highlightColor: CustomColors.salmon,
              tooltip: 'Submit a new report',
              onPressed: () {
                navPage = "/new_report";
                Navigator.of(context).pushNamedAndRemoveUntil('/new_report', ModalRoute.withName('/login'));
              }
            ),
            Text(
              "Create",
              style: TextStyle(color: _currentPage("/new_report")),
            ),
          ]
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Image.asset("images/add view requests.png"),
              color: _currentPage("/view_submitted"),
              highlightColor: CustomColors.salmon,
              tooltip: 'View your past submissions',
              onPressed: () {
                navPage = "/view_submitted";
                Navigator.of(context).pushNamedAndRemoveUntil('/view_submitted', ModalRoute.withName('/login'));
              }
            ),
            Text(
              "Requests",
              style: TextStyle(color: _currentPage("/view_submitted")),
            ),
          ]
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Image.asset("images/map.png"),
              color: _currentPage("/all_reports"),
              highlightColor: CustomColors.salmon,
              tooltip: 'Map of all reports',
              onPressed: () {
                navPage = "/all_reports";
                Navigator.of(context).pushNamedAndRemoveUntil('/all_reports', ModalRoute.withName('/login'));
              }
            ),
            Text(
              "Map",
              style: TextStyle(color: _currentPage("/all_reports")),
            ),
          ]
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Image.asset("images/settings.png"),
              color: _currentPage("/settings"),
              highlightColor: CustomColors.salmon,
              tooltip: 'View your current settings',
              onPressed: () {
                navPage = "/settings";
                Navigator.of(context).pushNamedAndRemoveUntil('/settings', ModalRoute.withName('/login'));
              }
            ),
            Text(
              "Settings",
              style: TextStyle(color: _currentPage("/settings")),
            ),
          ]
        ),
      ],
    ),
  );
}
