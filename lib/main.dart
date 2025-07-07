import 'package:flutter/material.dart';
import 'AuctionListPage.dart';

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
