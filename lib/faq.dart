import 'package:flutter/material.dart';
import 'page.dart';
import 'parking_ticket.dart';
import 'assessment.dart';

//The home page give you the following options
final List<Page> _allPages = <Page>[
  ParkingTicketFaqPage(),
  AssessmentFaqPage(),
];

class FaqPage extends Page {
  FaqPage() : super(const Icon(Icons.map), 'FAQ');

  @override
  Widget build(BuildContext context) {
    return const FaqBody();
  }
}

class FaqBody extends StatefulWidget {
  const FaqBody();

  @override
  State<StatefulWidget> createState() => FaqBodyState();
}
          
class FaqBodyState extends State<FaqBody> {
  FaqBodyState();

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


