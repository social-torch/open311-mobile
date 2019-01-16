import 'package:flutter/material.dart';
import 'page.dart';
import 'report.dart';
import 'faq.dart';

class NavPage {
  NavPage(this.pathname, this.page);

  final String pathname;
  final Page page;
}

//The home page give you the following options
final List<NavPage> _allPages = <NavPage>[
  NavPage("/report", ReportPage()),
  NavPage("/faq", FaqPage()),
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

  @override
  void initState() {
    super.initState();
  }

  void _pushPage(BuildContext context, NavPage npage) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        settings: RouteSettings(name: npage.pathname),
        builder: (_) =>
            Scaffold(
              appBar: AppBar(title: Text(npage.page.title)),
              body: npage.page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) =>
        ListTile(
          leading: _allPages[index].page.leading,
          title: Text(_allPages[index].page.title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}


