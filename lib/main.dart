import 'package:flutter/material.dart';
import '1st phase/auction_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auction App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuctionListPage(),
    );
  }
}
