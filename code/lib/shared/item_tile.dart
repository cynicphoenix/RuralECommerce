import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/chat/chatHome.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/bids/acceptorDetail.dart';
import 'package:rural_e_commerce/bids/bidScreen.dart';
import 'package:rural_e_commerce/shared/itemSpecs.dart';
import 'package:rural_e_commerce/screens/home/common/delete.dart';
import 'package:rural_e_commerce/bids/placedBids.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class ItemTile extends StatefulWidget {
  final Item item;
  final bool isSeller;
  final CurrentUserData currentUserData;
  ItemTile({this.item, this.isSeller, this.currentUserData});
  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
  Item item = widget.item;
  bool isSeller = widget.isSeller;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () async {
          if(item.forRent) {
            final DocumentSnapshot retailerSnapshot = await DatabaseServices()
              .getAnyUserInfo(item.userUID);
            if(widget.currentUserData.uid != item.userUID) {
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemSpecs(item: item, retailerSnapshot: retailerSnapshot, currentUserData: widget.currentUserData,),
              )
            );
            }
            else {
              String itemUID = item.userUID + '#' + item.name;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatHome(currentUserData: widget.currentUserData, itemUID: itemUID,),
                )
              );
            }
          }
          else if(item.forBid) {
            if(widget.currentUserData.uid != item.userUID) {  
              final DocumentSnapshot sellerSnapshot = await DatabaseServices()
                                                              .getAnyUserInfo(item.userUID); 
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BidScreen(item: item, sellerSnapshot: sellerSnapshot, currentUserData: widget.currentUserData,),
                )
              );
            }
            else {
              if(item.bidAcceptIndex != -1) {
                final DocumentSnapshot bidderSnapshot = await DatabaseServices()
                  .getAnyUserInfo(item.bidders[item.bidAcceptIndex]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AcceptorDetail(item: item, bidderSnapshot: bidderSnapshot,
                      currentUserData: widget.currentUserData),
                  )
                );
              }
              else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlacedBids(item: item, currentUserData: widget.currentUserData),
                  )
                );
              }
            }
          }
          else if(isSeller) {
             final DocumentSnapshot retailerSnapshot = await DatabaseServices()
              .getAnyUserInfo(item.userUID);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemSpecs(item: item, retailerSnapshot: retailerSnapshot, currentUserData: widget.currentUserData,),
              )
            );
          }
          else if(!isSeller) {
            String itemUID = item.userUID + '#' + item.name;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatHome(currentUserData: widget.currentUserData, itemUID: itemUID,),
              )
            );
          }
        },
        child: Card(
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.album),
                title: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          if(item.userUID != widget.currentUserData.uid)
                            Icon(
                              Icons.location_on,
                              color: Colors.green[300],
                            ),
                          if(item.userUID == widget.currentUserData.uid)
                            InkWell(
                              onTap: () {
                                _deletePanel(item);
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 28.0
                              ),
                            ),
                          SizedBox(width: 2.0),
                          if(item.userUID != widget.currentUserData.uid)
                            Text(
                              '${item.distanceFromCurrentUser.toString()} KMs ',
                              style: TextStyle(
                                fontSize: 15.0,
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
              Container(
                margin: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        '${AppLocalizations.of(context).translate("Quantity")} : ${item.quantity} KG',
                        style: TextStyle(
                          fontSize: 15.0,
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
                          fontSize: 15.0,
                          color: Colors.black,
                          ),
                        ),
                      onPressed: () {/* ... */},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deletePanel(Item item) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(100.0)),),
      context: context,
      builder: (builder) {
        return DeleteForm(item: item,);
      },
    );   
  }
}
