import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/shared/item_tile.dart';
import 'package:rural_e_commerce/app_localizations.dart';


class QueryItemList extends StatefulWidget {
  final String query;
  final String sortBy;
  final String sortOrder;
  final bool isSeller;
  final CurrentUserData currentUserData;
  QueryItemList({this.query, this.sortBy, this.sortOrder, this.currentUserData, this.isSeller});
  @override
  _QueryItemListState createState() {
    return _QueryItemListState();
  }
}

class _QueryItemListState extends State<QueryItemList> {
  
  double toRadians(double degree) {
    double tempDegree = (pi) / 180; 
    return (tempDegree * degree); 
  }

  double distance(double lat1, double long1, double lat2, double long2) {
    lat1 = toRadians(lat1); 
    long1 = toRadians(long1); 
    lat2 = toRadians(lat2); 
    long2 = toRadians(long2); 
      
    // Haversine Formula 
    double dlong = long2 - long1; 
    double dlat = lat2 - lat1;  
    double ans = pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) *  pow(sin(dlong / 2), 2); 
    ans = 2 * asin(sqrt(ans)); 
    double R = 6371; 
    ans = ans * R; 
    return ans; 
  } 

  @override
  Widget build(BuildContext context) {
    String sortBy = widget.sortBy;
    String sortOrder = widget.sortOrder;
    CurrentUserData currentUserData = widget.currentUserData;
    final List<String> currentUserAddress = currentUserData.address.split('#');
    final items = Provider.of<List<Item>>(context) ?? [];
    final queryItems = [];
    for(var item in items) {
      if(item.name.toLowerCase().contains(widget.query.toLowerCase()) && currentUserData.uid != item.userUID) {
        item.distanceFromCurrentUser = num.parse(distance(
                                          double.parse(currentUserAddress[0]),
                                          double.parse(currentUserAddress[1]),
                                          double.parse(item.address.split('#')[0]),
                                          double.parse(item.address.split('#')[1])).toStringAsFixed(2));
        if(widget.isSeller) {
          if(!item.forBid) {
            queryItems.add(item);
          }
        }
        else {
          if(item.forBid) {
            queryItems.add(item);
          }
        }
      }
    }
    if (sortBy == 'Name' || sortBy == 'नाम' || sortBy == 'ਨਾਮ') {
      if(sortOrder == 'Asc' || sortOrder == 'आरोही' || sortOrder == 'ਚੜ੍ਹਨਾ') {
        queryItems.sort((a, b) => a.name.compareTo(b.name));
      }
      else {
        queryItems.sort((a, b) => b.name.compareTo(a.name));
      }
    }
    else if (sortBy == 'Distance' || sortBy == 'दूरी' || sortBy == 'ਦੂਰੀ') { 
      if(sortOrder == 'Asc' || sortOrder == 'आरोही' || sortOrder == 'ਚੜ੍ਹਨਾ') {
        queryItems.sort((a, b) => a.distanceFromCurrentUser.compareTo(b.distanceFromCurrentUser));
      }
      else {
        queryItems.sort((b, a) => a.distanceFromCurrentUser.compareTo(b.distanceFromCurrentUser));
      }
    }
    else if (sortBy == 'Quantity' || sortBy == 'मात्रा' || sortBy == 'ਮਾਤਰਾ') {
      if(sortOrder == 'Asc' || sortOrder == 'आरोही' || sortOrder == 'ਚੜ੍ਹਨਾ') {
        queryItems.sort((a, b) => a.quantity.compareTo(b.quantity));
      }
      else {
        queryItems.sort((a, b) => b.quantity.compareTo(a.quantity));
      }
    }
    else {
      if(sortOrder == 'Asc' || sortOrder == 'आरोही' || sortOrder == 'ਚੜ੍ਹਨਾ') {
        queryItems.sort((a, b) => a.price.compareTo(b.price));
      }
      else {
        queryItems.sort((a, b) => b.price.compareTo(a.price));
      }
    }
    if(queryItems.length == 0) {
      return Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0),
            Text(
              AppLocalizations.of(context).translate('No item found!'),
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: queryItems.length,
      itemBuilder: (context, index) {
        return ItemTile(item: queryItems[index], isSeller: true, currentUserData: currentUserData);
      }
    );
  }
}
