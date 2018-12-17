import 'package:flutter/material.dart';
import 'page.dart';
import 'report.dart';
import 'faq.dart';
import "globals.dart" as globals;

//The home page give you the following options
final List<Page> _allPages = <Page>[
  ReportPage(),
  FaqPage(),
];

class HomePage extends Page {
  HomePage() : super(const Icon(Icons.map), 'Open311 Schenectady, NY');

  @override
  Widget build(BuildContext context) {
    return const HomeBody();
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody();

  @override
  State<StatefulWidget> createState() => HomeBodyState();
}
          
class HomeBodyState extends State<HomeBody> {
  HomeBodyState();

  void _pushPage(BuildContext context, Page page) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) =>
            Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) =>
        ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}


