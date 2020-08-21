import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/chat/conversationScreen.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rural_e_commerce/shared/map.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/app_localizations.dart';


class BidScreen extends StatefulWidget {
  final Item item;
  final DocumentSnapshot sellerSnapshot;
  final CurrentUserData currentUserData;
  BidScreen({this.item, this.sellerSnapshot, this.currentUserData});
  @override
  _BidScreenState createState() => _BidScreenState();
}

class _BidScreenState extends State<BidScreen> {
  final _formKey = GlobalKey<FormState>();

  bool bidPlaced = false; // If current user has placed bid or not
  bool bidChoosen = false; // If farmer ha accepted the bid
  bool bidGrantedToCurrentUser = false; // If the farmer has accepted the bid of current user

  double bidPrice = -1; // Already placed bid of retailer
  double enteredBidPrice; // To keep track of entered price in text-field

  @override
  Widget build(BuildContext context) {
    final Item item  = widget.item;
    final DocumentSnapshot sellerSnapshot = widget.sellerSnapshot;
    final CurrentUserData currentUserData = widget.currentUserData;
    final List<String> sellerAddress = sellerSnapshot.data['address'].split('#');

    if(item.bidAcceptIndex != -1) {
      bidChoosen = true;
      if(item.bidders[item.bidAcceptIndex] == currentUserData.uid) {
        bidGrantedToCurrentUser = true;
      }
    }

    final int index = item.bidders.length > 0 ? item.bidders.indexOf(currentUserData.uid) : -1;
    if(index != -1) {
      bidPlaced = true;
      bidPrice = item.bidPrice[index];
    }
    
    String message = 'Hey, I am interested in fulfilling your demand of ${item.name} ' + 
      'for the request that you placed on Rural E Commerce application.';

    bool loading = false;
    
    return loading ? Loading() : Container(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '${AppLocalizations.of(context).translate("Approx Quantity")} : ${item.quantity} KG',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 15),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                            '${AppLocalizations.of(context).translate("Start Bid")} : Rs. ${item.price}',
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            if(bidPlaced)
                            SizedBox(width: 20),
                            if(bidPlaced)
                            Text(
                              '${AppLocalizations.of(context).translate("My Bid")} : Rs. $bidPrice',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        if(item.bidEndTimeStamp > DateTime.now().millisecondsSinceEpoch)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${AppLocalizations.of(context).translate("Bid will end in")} ${((item.bidEndTimeStamp - DateTime.now().millisecondsSinceEpoch)/24/60/60/1000).ceil()} ${AppLocalizations.of(context).translate("day(s)")}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
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
                        if(bidGrantedToCurrentUser)
                          Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of(context).translate('Seller Name : '),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,    
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${sellerSnapshot.data['name']}',
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
                                        '+91 ${sellerSnapshot.data['contactNo']}',
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
                                        '${sellerAddress[2]}',
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
                                      launch("tel://+91${sellerSnapshot.data['contactNo']}");
                                    },
                                  ),
                                  SizedBox(width: 20.0,),
                                  IconButton(
                                    icon: Icon(Icons.sms),
                                    iconSize: 40.0,
                                    color: Colors.green,
                                    tooltip: 'Message',
                                    onPressed: () {
                                      launch("sms://${sellerSnapshot.data['contactNo']}?body=$message");
                                    },
                                  ),
                                  SizedBox(width: 20.0,),
                                  IconButton(
                                    icon: FaIcon(FontAwesomeIcons.whatsapp),
                                    iconSize: 40.0,
                                    color: Colors.green,
                                    tooltip: 'Whatsapp',
                                    onPressed: () {
                                      launch("https://wa.me/+91${sellerSnapshot.data['contactNo']}?text=$message");
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
                                          builder: (context) => MapWidget(retailerSnapshot: sellerSnapshot,
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
                                      String user2 = sellerSnapshot.documentID;
                                      String chatRoomID;
                                      if(user1.compareTo(user2) == 1) {
                                        chatRoomID = user1 + '-' + user2;
                                      }
                                      else {
                                        chatRoomID = user2 + '-' + user1;
                                      }

                                      List<String> users = [currentUserData.uid, sellerSnapshot.documentID];
                                      String itemUID = item.documentID + '#' + item.name;
                                      String usernames = currentUserData.name + '-' + sellerSnapshot.data['name'];
                                      bool result = await DatabaseServices().addChatRoom(chatRoomID, users, itemUID, usernames);
                                      if(result == true) {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => ConversationScreen(currentUserData: currentUserData, chatRoomID: chatRoomID, receiverSnapshot: sellerSnapshot),
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
                          
                        if(!bidGrantedToCurrentUser && item.bidEndTimeStamp < DateTime.now().millisecondsSinceEpoch)
                          Text(
                            bidChoosen ? AppLocalizations.of(context).translate('Sorry! Your bid was not choosen!') :
                                             AppLocalizations.of(context).translate('Seller will choose a bid soon. Be Patient...'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18
                            ),
                          ),

                        if(!bidGrantedToCurrentUser && item.bidEndTimeStamp >= DateTime.now().millisecondsSinceEpoch)
                          Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 280,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                filled: true,
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green[200], width: 2.0),
                                                  borderRadius: const BorderRadius.all(
                                                    const Radius.circular(30.0),
                                                  ),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                                                  borderRadius: const BorderRadius.all(
                                                    const Radius.circular(30.0),
                                                  ),
                                                ),
                                              ).copyWith(hintText: !bidPlaced ? 'Bid Amount in Rupees' : 'New Bid Amount in Rupees', 
                                                prefixIcon: Icon(Icons.attach_money),),

                                  validator: (value) => !_checkValidity(value) ? 'Bid should be more than minimum bid price' : null,
                                  onChanged: (value) {
                                    setState(() {
                                      enteredBidPrice = double.parse(value);
                                    });
                                  },
                                ),
                              ),

                              SizedBox(height: 20),

                              Container(
                                width: 150,
                                child: ButtonTheme(
                                  height: 60.0,
                                  minWidth: 100.0,
                                  child: RaisedButton(
                                    onPressed: () async{
                                      setState(() {
                                        loading = true;
                                      });
                                      if(_formKey.currentState.validate()) {
                                        List<dynamic> bidders = item.bidders ?? [];
                                        List<dynamic> bids = item.bidPrice ?? [];
                                        if(!bidPlaced) {
                                          bidders.add(currentUserData.uid);
                                          bids.add(enteredBidPrice);
                                        }
                                        else {
                                          bids[index] = enteredBidPrice;
                                        }
                                        await DatabaseServices().updateBids(
                                          item.documentID, 
                                          bidders,
                                          bids,
                                        ); 
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
                                        SizedBox(width: 10.0,),
                                        Text(
                                          !bidPlaced ? 'Place Bid' : 'Change Bid',
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

  bool _checkValidity(String s) {
    bool returnValidity = false;
    if (s == null) {
      return false;
    }
    returnValidity = (double.tryParse(s) != null);
    if(returnValidity == true) {
      if(double.parse(s) <= 0 || double.parse(s) <= widget.item.price) {
        returnValidity = false;
      }
      if(bidPlaced) {
        if(double.parse(s) <= bidPrice) {
          returnValidity = false;
        }
      } 
    }
    return returnValidity;
  }
}
