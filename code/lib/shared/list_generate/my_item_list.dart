import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/screens/forms/add_item.dart';
import 'package:rural_e_commerce/shared/item_tile.dart';


class MyItemList extends StatefulWidget {
  final bool isSeller;
  final bool forBid;
  final CurrentUserData currentUserData;
  MyItemList({this.isSeller, this.currentUserData, this.forBid});
  @override
  _MyItemListState createState() => _MyItemListState();
}

class _MyItemListState extends State<MyItemList> {
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<List<Item>>(context) ?? [];
    final myItems = [];
    for(var item in items) {
      if(widget.currentUserData.uid == item.userUID) {
        myItems.add(item);
      }
    }
    if(items.length == 0) {
      return Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Text(
              'No item to display!',
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 10.0),
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              iconSize: 50.0,
              color: Colors.green[800],
              tooltip: 'Add Item',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItem(forBid: widget.forBid, currentUserData: widget.currentUserData,),
                  )
                );
              },
            ),
          ],
        ),
      );
    }
    if(myItems.length > 0) {
      return ListView.builder(
        itemCount: myItems.length,
        itemBuilder: (context, index) {
          return ItemTile(item: myItems[index], isSeller: widget.isSeller, currentUserData: widget.currentUserData,);
        }
      );
    }
    else {
      return Container();
    }
  }
}
