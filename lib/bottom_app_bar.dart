import 'package:flutter/material.dart';
import 'new_report.dart';
import 'view_submitted.dart';
import 'all_reports.dart';
import 'settings.dart';


Widget commonBottomBar(context) {
 return BottomAppBar(                                                                             child: new Row(                                                                             mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.add_circle_outline), 
                       onPressed: () {
                          var page = NewReportPage();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              settings: RouteSettings(name: '/login/newreport'),
                              builder: (context) => Scaffold(
                                appBar: AppBar(title: Text(page.title)),
                                bottomNavigationBar: commonBottomBar(context),
                                body: page,
                              ),
                            ),
                          );
                        }),
            IconButton(icon: Icon(Icons.widgets),
                       onPressed: () {
                          var page = ViewSubmittedPage();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //settings: RouteSettings(name: '/home'),
                              builder: (context) => Scaffold(
                                appBar: AppBar(title: Text(page.title)),
                                bottomNavigationBar: commonBottomBar(context),
                                body: page,
                              ),
                            ),
                          );
                        }),
            IconButton(icon: Icon(Icons.map),
                       onPressed: () {
                          var page = AllReportsPage();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //settings: RouteSettings(name: '/home'),
                              builder: (context) => Scaffold(
                                appBar: AppBar(title: Text(page.title)),
                                bottomNavigationBar: commonBottomBar(context),
                                body: page,
                              ),
                            ),
                          );
                        }),
            IconButton(icon: Icon(Icons.settings),
                       onPressed: () {
                          var page = SettingsPage();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //settings: RouteSettings(name: '/home'),
                              builder: (context) => Scaffold(
                                appBar: AppBar(title: Text(page.title)),
                                bottomNavigationBar: commonBottomBar(context),
                                body: page,
                              ),
                            ),
                          );
                        }),
          ],
        ),
      );
}
