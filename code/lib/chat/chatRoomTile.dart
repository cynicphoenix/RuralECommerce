import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/chat/conversationScreen.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/services/database.dart';

class ChatRoomsTile extends StatelessWidget {
  final CurrentUserData currentUserData;
  final String userName;
  final String chatRoomID;

  ChatRoomsTile({this.userName, @required this.chatRoomID, this.currentUserData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Container(
        width: 280,
        child: ButtonTheme(
          height: 70.0,
          minWidth: 100.0,
          child: RaisedButton(
            onPressed: () async{
              final DocumentSnapshot receiverSnaphot = await DatabaseServices()
              .getAnyUserInfo(chatRoomID.replaceAll('-', '').replaceAll(currentUserData.uid, ''));
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => ConversationScreen(
                  chatRoomID: chatRoomID,
                  currentUserData: currentUserData,
                  receiverSnapshot: receiverSnaphot,
                )
              ));
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
              side: BorderSide(color: Colors.green)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.person, color: Colors.green,),
                SizedBox(width: 10.0,),
                Text(
                  userName,
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
    );
  }
}

