import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/bids/bidderDetail.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class Bids {
  String bidderUID;
  dynamic bidPrice;

  Bids({this.bidderUID, this.bidPrice});
}


class PlacedBids extends StatefulWidget {
  final Item item;
  final CurrentUserData currentUserData;
  PlacedBids({this.item, this.currentUserData});
  @override
  _PlacedBidsState createState() => _PlacedBidsState();
}

class _PlacedBidsState extends State<PlacedBids> {

  @override
  Widget build(BuildContext context) {
    
    List<Bids> bidsList = [];
    for(int i = 0; i < widget.item.bidders.length; i++) {
      bidsList.add(Bids(
                    bidderUID: widget.item.bidders[i],
                    bidPrice: widget.item.bidPrice[i],
      ));
    }

    bidsList.sort((a, b) => b.bidPrice.compareTo(a.bidPrice));

    if(bidsList.length == 0) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.green[200],
            image: DecorationImage(
              image: AssetImage('assets/bottom.png'),
              fit: BoxFit.cover,
            ),
          ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Placed Bids'),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50.0),
                Text(
                  'No bid requests!',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }   

    return Container(
      decoration: BoxDecoration(
          color: Colors.green[200],
          image: DecorationImage(
            image: AssetImage('assets/bottom.png'),
            fit: BoxFit.cover,
          ),
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('Tap to view Bid Details')),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
        ),
        
        body: ListView.builder(
          itemCount: bidsList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: InkWell(
                onTap: () async {
                  final DocumentSnapshot bidderSnapshot = await DatabaseServices()
                                              .getAnyUserInfo(bidsList[index].bidderUID.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BidderDetail(item: widget.item, bidderSnapshot: bidderSnapshot, 
                          currentUserData: widget.currentUserData),
                    )
                  );
                },
                child: Card(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Container(
                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Rs. ${bidsList[index].bidPrice.toString()}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}