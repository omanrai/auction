import 'dart:io';
import 'package:flutter/material.dart';
import 'auction_item_list.dart';

class AuctionItem {
  final String name;
  final String address;
  final DateTime addedTime;
  final double price;
  final List<String> images;

  AuctionItem({required this.name, required this.address, required this.addedTime, required this.price, required this.images});
}

class AuctionListPage extends StatefulWidget {
  @override
  _AuctionListPageState createState() => _AuctionListPageState();
}

class _AuctionListPageState extends State<AuctionListPage> {
  List<AuctionItem> items = [];

  void _navigateToAddItem() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuctionItemPage()),
    );
    if (newItem != null) {
      setState(() {
        items.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auctions (${items.length})'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _navigateToAddItem,
            tooltip: 'Add Auction Item',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              title: Text(item.name),
              subtitle: Text('Added: ${item.addedTime}\nAddress: ${item.address}\nTotal Price: \$${item.price.toStringAsFixed(2)}'),
              leading: item.images.isNotEmpty
                  ? Image.file(
                      File(item.images[0]),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
