import 'package:flutter/material.dart';
import 'page.dart';

class ParkingTicketFaqPage extends Page {
  ParkingTicketFaqPage() : super(const Icon(Icons.map), 'Parking Ticket Questions');

  @override
  Widget build(BuildContext context) {
    return const ParkingTicketFaqBody();
  }
}

class ParkingTicketFaqBody extends StatefulWidget {
  const ParkingTicketFaqBody();

  @override
  State<StatefulWidget> createState() => ParkingTicketFaqBodyState();
}

class ParkingTicketFaqBodyState extends State<ParkingTicketFaqBody> {
  ParkingTicketFaqBodyState();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        children: [
          new Column(
            children: <Widget>[
              new Text(
                'TODO: where do we redirect parking ticket questions?',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
