import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rural_e_commerce/chat/conversationScreen.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/shared/map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class AcceptorDetail extends StatefulWidget {
  final Item item;
  final DocumentSnapshot bidderSnapshot;
  final CurrentUserData currentUserData;
  AcceptorDetail({this.item, this.bidderSnapshot, this.currentUserData});
  @override
  _AcceptorDetailState createState() => _AcceptorDetailState();
}

class _AcceptorDetailState extends State<AcceptorDetail> {

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

    
    String message = 'Hey, I have accepted your bid ' + 
      'for the ${item.name} that you placed on Rural E Commerce application.';

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

          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.white,
              onPressed: () async {
                await DatabaseServices().acceptBid(item.documentID, -1);
                Navigator.pop(context);
              },
            )
          ],
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
                                  '${item.bidPrice[item.bidAcceptIndex]}',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.phone),
                              iconSize: 40.0,
                              color: Colors.green,
                              tooltip: 'Call',
                              onPressed: () {
                                launch("tel://+91${bidderSnapshot.data['contactNo']}");
                              },
                            ),
                            SizedBox(width: 20.0,),
                            IconButton(
                              icon: Icon(Icons.sms),
                              iconSize: 40.0,
                              color: Colors.green,
                              tooltip: 'Message',
                              onPressed: () {
                                launch("sms://${bidderSnapshot.data['contactNo']}?body=$message");
                              },
                            ),
                            SizedBox(width: 20.0,),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.whatsapp),
                              iconSize: 40.0,
                              color: Colors.green,
                              tooltip: 'Whatsapp',
                              onPressed: () {
                                launch("https://wa.me/+91${bidderSnapshot.data['contactNo']}?text=$message");
                              },
                            ),
                            SizedBox(width: 20.0,),
                            IconButton(
                              icon: Icon(Icons.location_on),
                              iconSize: 40.0,
                              color: Colors.green,
                              tooltip: 'Location',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapWidget(retailerSnapshot: bidderSnapshot,
                                                                      currentUserData: widget.currentUserData,
                                                                      item: item),
                                  ),
                                );
                              },
                            ),
                          ],
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
                        Container(
                          width: 280,
                          child: ButtonTheme(
                            height: 60.0,
                            minWidth: 100.0,
                            child: RaisedButton(
                              onPressed: () async{
                                
                                String user1 = widget.currentUserData.uid;
                                String user2 = bidderSnapshot.documentID;
                                String chatRoomID;
                                if(user1.compareTo(user2) == 1) {
                                  chatRoomID = user1 + '-' + user2;
                                }
                                else {
                                  chatRoomID = user2 + '-' + user1;
                                }

                                List<String> users = [widget.currentUserData.uid, bidderSnapshot.documentID];
                                String itemUID = item.documentID + '#' + item.name;
                                String usernames = widget.currentUserData.name + '-' + bidderSnapshot.data['name'];
                                bool result = await DatabaseServices().addChatRoom(chatRoomID, users, itemUID, usernames);
                                if(result == true) {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => ConversationScreen(currentUserData: widget.currentUserData, chatRoomID: chatRoomID, receiverSnapshot: bidderSnapshot),
                                  ));
                                }
                              },
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.green)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.message, color: Colors.green,),
                                  SizedBox(width: 10.0,),
                                  Text(
                                    AppLocalizations.of(context).translate('Instant Message'),
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
}