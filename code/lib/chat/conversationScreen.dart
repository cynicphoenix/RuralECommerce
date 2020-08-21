import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/chat/messageTile.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/shared/constant.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class ConversationScreen extends StatefulWidget {
  final CurrentUserData currentUserData;
  final String chatRoomID;
  final DocumentSnapshot receiverSnapshot;
  ConversationScreen({this.currentUserData, this.chatRoomID, this.receiverSnapshot});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageEditingController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  Stream<QuerySnapshot> chats;
  
  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageTile(
              message: snapshot.data.documents[index].data["message"],
              sendByMe: widget.currentUserData.uid == snapshot.data.documents[index].data["sendBy"],
            );
          }
        ) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": widget.currentUserData.uid,
        "message": messageEditingController.text,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch,
      };
      DatabaseServices().addMessage(widget.chatRoomID, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        // message = "reach the bottom";
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        // message = "reach the top";
      });
    }
  }
  
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    DatabaseServices().getChats(widget.chatRoomID).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
          color: Colors.green[200],
        ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
          appBar: AppBar(
              title: Text(widget.receiverSnapshot.data['name']),
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
                  icon: Icon(Icons.person),
                  color: Colors.white,
                  onPressed: () {
                    receiverInfo();
                  },
                )
              ],
            ), 
            body: Material(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[200],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: messageEditingController,
                              decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Type your message...')),
                            )
                          ),
                          SizedBox(width: 10,),
                          GestureDetector(
                          onTap: () {
                            addMessage();
                            setState(() {
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            });   
                          },
                          child: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              
                            color: Colors.black,
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF4CAF50),
                                  const Color(0xFF4CAF50)
                                ],
                                begin: FractionalOffset.topLeft,
                                end: FractionalOffset.bottomRight
                              ),
                            borderRadius: BorderRadius.circular(50),

                            ),
                            padding: EdgeInsets.all(2),
                            child: Icon(Icons.send, color: Colors.white, size: 30,),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      height: MediaQuery
                            .of(context)
                            .size
                            .height - MediaQuery
                                      .of(context)
                                      .size
                                      .height/5,
                      child: chatMessages(),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> receiverInfo() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(100.0)),),
      context: context,
      builder: (builder) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 50),
          height: 180.0,
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
              children: <Widget>[
                SizedBox(height: 20.0,),
                Icon(
                  Icons.person,
                  size: 40.0,
                  color: Colors.red,
                ),
                SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '${widget.receiverSnapshot.data['name']}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,    
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0,),
                Text(
                  '${AppLocalizations.of(context).translate("Contact Info : ")}+91${widget.receiverSnapshot.data['contactNo']}',
                  style: TextStyle(
                    fontSize: 15.0, 
                  ),
                ),
                SizedBox(height: 5.0,),
                Text(
                  '${AppLocalizations.of(context).translate("Location")} : ${widget.receiverSnapshot.data['address'].toString().split('#')[2]}',
                  style: TextStyle(
                    fontSize: 15.0, 
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}