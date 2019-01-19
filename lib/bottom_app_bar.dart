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
                         Navigator.of(context).pushNamedAndRemoveUntil('/new_report', ModalRoute.withName('/login'));
                        }),
            IconButton(icon: Icon(Icons.widgets),
                       onPressed: () {
                         Navigator.of(context).pushNamedAndRemoveUntil('/view_submitted', ModalRoute.withName('/login'));
                        }),
            IconButton(icon: Icon(Icons.map),
                       onPressed: () {
                         Navigator.of(context).pushNamedAndRemoveUntil('/all_reports', ModalRoute.withName('/login'));
                        }),
            IconButton(icon: Icon(Icons.settings),
                       onPressed: () {
                         Navigator.of(context).pushNamedAndRemoveUntil('/settings', ModalRoute.withName('/login'));
                        }),
          ],
        ),
      );
}
