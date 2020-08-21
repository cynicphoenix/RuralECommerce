import 'package:flutter/material.dart';
import 'package:rural_e_commerce/chat/chatRoomTile.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class ChatHome extends StatefulWidget {
  final CurrentUserData currentUserData;
  final String itemUID;
  ChatHome({this.currentUserData, this.itemUID});
  @override
  _ChatHomeState createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  Stream chatRooms;
  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
          ? ListView.builder(
            
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if(widget.itemUID == null ||  (widget.itemUID != null && snapshot.data.documents[index]
                                                  .data["items"].contains(widget.itemUID))) {
                  return ChatRoomsTile(
                
                    userName: snapshot.data.documents[index]
                                                    .data["usernames"]
                                                    .toString()
                                                    .replaceAll('-', '')
                                                    .replaceAll(widget.currentUserData.name, ''),
                    chatRoomID: snapshot.data.documents[index].data["chatRoomID"],
                    currentUserData: widget.currentUserData,
                  );
                }
                else {
                  return Container();
                }
              })
          : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    DatabaseServices().getUserChats(widget.currentUserData.uid).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.green[200],
        ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            title: Text(AppLocalizations.of(context).translate('Messages')),
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
          child: chatRoomsList(),
        ),
      ),
    );
  }

}