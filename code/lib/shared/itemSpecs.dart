import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/chat/conversationScreen.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rural_e_commerce/shared/map.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class ItemSpecs extends StatelessWidget {
  final Item item;
  final DocumentSnapshot retailerSnapshot;
  final CurrentUserData currentUserData;
  ItemSpecs({this.item, this.retailerSnapshot, this.currentUserData});
  @override
  Widget build(BuildContext context) {
    final List<String> retailerAddress = retailerSnapshot.data['address'].split('#');
    
    String message = 'Hey, I am interested in fulfilling your demand of ${item.name} ' + 
      'for the request that you placed on Rural E Commerce application.';

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
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              '${AppLocalizations.of(context).translate("Quantity")} : ${item.quantity} KG',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                ),
                              ),
                            onPressed: () {/* ... */},
                          ),
                          SizedBox(width: 20.0),
                          FlatButton(
                            child: Text(
                              '${AppLocalizations.of(context).translate("Price/KG")} : Rs. ${item.price}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                ),
                              ),
                            onPressed: () {/* ... */},
                          ),
                        ],
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
                              '${AppLocalizations.of(context).translate("Retailer Name")} : ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,    
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '${retailerSnapshot.data['name']}',
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
                              AppLocalizations.of(context).translate('Contact Info : '),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,    
                              ),
                            ),
                            Flexible(
                              child: Text(
                                '+91 ${retailerSnapshot.data['contactNo']}',
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
                              launch("tel://+91${retailerSnapshot.data['contactNo']}");
                            },
                          ),
                          SizedBox(width: 20.0,),
                          IconButton(
                            icon: Icon(Icons.sms),
                            iconSize: 40.0,
                            color: Colors.green,
                            tooltip: 'Message',
                            onPressed: () {
                              launch("sms://${retailerSnapshot.data['contactNo']}?body=$message");
                            },
                          ),
                          SizedBox(width: 20.0,),
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.whatsapp),
                            iconSize: 40.0,
                            color: Colors.green,
                            tooltip: 'Whatsapp',
                            onPressed: () {
                              launch("https://wa.me/+91${retailerSnapshot.data['contactNo']}?text=$message");
                            },
                          ),
                          SizedBox(width: 20.0,),
                          IconButton(
                            icon: Icon(Icons.location_on),
                            iconSize: 40.0,
                            color: Colors.green,
                            tooltip: AppLocalizations.of(context).translate('Location'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapWidget(retailerSnapshot: retailerSnapshot,
                                                                    currentUserData: currentUserData,
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
                              
                              String user1 = currentUserData.uid;
                              String user2 = retailerSnapshot.documentID;
                              String chatRoomID;
                              if(user1.compareTo(user2) == 1) {
                                chatRoomID = user1 + '-' + user2;
                              }
                              else {
                                chatRoomID = user2 + '-' + user1;
                              }

                              List<String> users = [currentUserData.uid, retailerSnapshot.documentID];
                              String itemUID = item.userUID + '#' + item.name;
                              String usernames = currentUserData.name + '-' + retailerSnapshot.data['name'];
                              bool result = await DatabaseServices().addChatRoom(chatRoomID, users, itemUID, usernames);
                              if(result == true) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ConversationScreen(currentUserData: currentUserData, chatRoomID: chatRoomID, receiverSnapshot: retailerSnapshot),
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
    );
  }
}
