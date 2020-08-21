import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class BidderDetail extends StatefulWidget {
  final Item item;
  final DocumentSnapshot bidderSnapshot;
  final CurrentUserData currentUserData;
  BidderDetail({this.item, this.bidderSnapshot, this.currentUserData});
  @override
  _BidderDetailState createState() => _BidderDetailState();
}

class _BidderDetailState extends State<BidderDetail> {

  Item item;
  DocumentSnapshot bidderSnapshot;

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

    item  = widget.item;
    bidderSnapshot = widget.bidderSnapshot;
    final List<String> retailerAddress = bidderSnapshot.data['address'].split('#');

    item.distanceFromCurrentUser = num.parse(distance(
                                            double.parse(retailerAddress[0]),
                                            double.parse(retailerAddress[1]),
                                            double.parse(item.address.split('#')[0]),
                                            double.parse(item.address.split('#')[1])).toStringAsFixed(2));

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
          title: Text(AppLocalizations.of(context).translate('Rural E Commerce')),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
        ), 
        body: Container(
          decoration: BoxDecoration(
            color: Colors.green[200],
            image: DecorationImage(
              image: AssetImage('assets/bottom.png'),
              fit: BoxFit.cover,
            )
          ),
          child: SingleChildScrollView(
                      child: Column(
              children: <Widget>[
                SizedBox(height: 10.0,),
                Card(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.shopping_basket),
                          title: Container(
                            margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.green[300],
                                    ),
                                    SizedBox(width: 2.0),
                                    Text(
                                      '${item.distanceFromCurrentUser.toString()} KMs ',
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text(item.description),
                        ),                                 
                        SizedBox(height: 10.0,),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal:10.0),
                          child:Container(
                            height:1.0,
                            color:Colors.green,
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        Container(
                          margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).translate('Bidder Name : '),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,    
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${bidderSnapshot.data['name']}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,    
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${AppLocalizations.of(context).translate("Location")} : ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,    
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${retailerAddress[2]}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,    
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),  
                        Container(
                          margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).translate('Bid Amount : '),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,    
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${item.bidPrice[item.bidders.indexOf(bidderSnapshot.documentID)]}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,    
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ), 
                        SizedBox(height: 30.0,),
                        Padding(
                          padding:EdgeInsets.symmetric(horizontal:10.0),
                          child:Container(
                            height:1.0,
                            color:Colors.green,
                          ),
                        ),
                        SizedBox(height: 30.0,),
                        if(item.bidAcceptIndex == -1 && item.bidEndTimeStamp > DateTime.now().millisecondsSinceEpoch)
                          Text(
                          '${AppLocalizations.of(context).translate("Accepting Bid will be available in")} ${((item.bidEndTimeStamp - DateTime.now().millisecondsSinceEpoch)/24/60/60/1000).ceil()} ${AppLocalizations.of(context).translate("day(s)")}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                          ),
                        ),
                        if(item.bidAcceptIndex == -1 && item.bidEndTimeStamp < DateTime.now().millisecondsSinceEpoch)
                          Container(
                            width: 160,
                            child: ButtonTheme(
                              height: 60.0,
                              minWidth: 160.0,
                              child: RaisedButton(
                                onPressed: () async{
                                  _acceptBidPanel();
                                },
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.green)
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: 10.0,),
                                    Text(
                                      AppLocalizations.of(context).translate('Accept Bid'),
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 18
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
      ),
    );
  }

  void _acceptBidPanel() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(100.0)),),
      context: context,
      builder: (builder) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 50),
          height: 120.0,
          color: Colors.transparent,
          child: Container(
            height: 125,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10, color: Colors.green[200], spreadRadius: 5
                )
              ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 45.0,
                      width: 160,
                      child: FlatButton(
                        child: Text(
                          AppLocalizations.of(context).translate('Yes'),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            ),
                          ),
                        onPressed: () async{
                          final int index = item.bidders.indexOf(bidderSnapshot.documentID);
                          await DatabaseServices().acceptBid(
                                          item.documentID, 
                                          index,
                                        ); 
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(side: BorderSide(
                          color: Colors.green,
                          width: 1.5,
                          style: BorderStyle.solid
                        ), borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Container(
                      height: 45.0,
                      width: 160,
                      child: FlatButton(
                        child: Text(
                          AppLocalizations.of(context).translate('No'),
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            ),
                          ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(side: BorderSide(
                          color: Colors.green,
                          width: 1.5,
                          style: BorderStyle.solid
                        ), borderRadius: BorderRadius.circular(50)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

 