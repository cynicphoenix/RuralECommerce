import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/screens/forms/add_item.dart';
import 'package:rural_e_commerce/screens/forms/add_rent.dart';
import 'package:rural_e_commerce/screens/home/common/edit_info.dart';
import 'package:rural_e_commerce/shared/constant.dart';
import 'package:rural_e_commerce/screens/wrapper.dart';
import 'package:rural_e_commerce/services/auth.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/chat/chatHome.dart';
import 'package:rural_e_commerce/shared/list_generate/my_item_list.dart';
import 'package:rural_e_commerce/shared/list_generate/query_item_list.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class HomeBuyer extends StatefulWidget {
  final CurrentUserData currentUserData;
  HomeBuyer({this.currentUserData});
  @override
  _HomeBuyerState createState() => _HomeBuyerState();
}

class _HomeBuyerState extends State<HomeBuyer> {
  String query = '';
  String queryType = '';
  String sortBy = 'Name';
  String sortOrder = 'Asc';
  bool isDashboard = true;
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null) {
      return Wrapper();
    }
    return StreamProvider<List<Item>>.value(
      value: DatabaseServices().currentUserItems,
      child : Container(
        decoration: BoxDecoration(
          color: Colors.green[200],
          image: DecorationImage(
            image: AssetImage('assets/bottom.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          drawer: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(    
                    child: Center(
                      child: Text(
                        '${AppLocalizations.of(context).translate('Hey')} ${widget.currentUserData.name.split(' ')[0]}!',
                          style: TextStyle(
                          fontSize: 22.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          ),
                        )
                      ),
                    decoration: BoxDecoration(
                      color: Colors.green[200],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_basket),
                    title: Text(AppLocalizations.of(context).translate('My Demands')),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        isDashboard = true;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_to_home_screen),
                    title: Text(AppLocalizations.of(context).translate('Farmer\'s Supply')),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        isDashboard = false;
                      });
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_circle_outline),
                    title: Text(AppLocalizations.of(context).translate('Add/Rent Item')),
                    onTap: () {
                      Navigator.of(context).pop();
                      _addItemPanel();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.message),
                    title: Text(AppLocalizations.of(context).translate('Messages')),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatHome(currentUserData: widget.currentUserData,),
                        )
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text(AppLocalizations.of(context).translate('Edit Information')),
                    onTap: () {
                      Navigator.of(context).pop();
                      _editInfoPanel();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(AppLocalizations.of(context).translate('Sign Out')),
                    onTap: () async{
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: 
            Text(isDashboard ? AppLocalizations.of(context).translate('Tap to View Requests') :
                                 AppLocalizations.of(context).translate('Tap to Place Bid')),
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
                if(isDashboard)
                  Expanded(
                    child: MyItemList(isSeller: false, currentUserData: widget.currentUserData, forBid: false,),
                  ),
                if(!isDashboard)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: TextFormField(
                      decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Search'), 
                        prefixIcon: Icon(Icons.search),),
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                    ),
                  ),
                if(!isDashboard)
                  SizedBox(height: 15.0),
                if(!isDashboard)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                              color: Colors.white, style: BorderStyle.solid, width: 0.0),
                        ),
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>( 
                              dropdownColor: Colors.green,          
                              hint: Text(
                                "${AppLocalizations.of(context).translate("Sort By")} : $sortBy "
                              ),
                              items: <String>[AppLocalizations.of(context).translate('Name'),
                              AppLocalizations.of(context).translate('Distance'), 
                              AppLocalizations.of(context).translate('Quantity'),
                              AppLocalizations.of(context).translate('Price')].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  sortBy = value;
                                });
                              },
                            ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                              color: Colors.white, style: BorderStyle.solid, width: 0.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>( 
                            dropdownColor: Colors.green,
                            focusColor: Colors.white,          
                            hint: Text(
                              "${AppLocalizations.of(context).translate("Sort Order")} : $sortOrder"
                            ),
                            items: <String>[AppLocalizations.of(context).translate('Asc'), 
                                            AppLocalizations.of(context).translate('Desc'),].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) async{
                              setState(() {
                                sortOrder = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                if(!isDashboard)
                  SizedBox(height: 10.0),
                if(!isDashboard)
                  Expanded(
                    child: QueryItemList(query: query, sortBy: sortBy, sortOrder: sortOrder,
                                currentUserData: widget.currentUserData, isSeller: false),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editInfoPanel() {
    showModalBottomSheet(isScrollControlled: true, backgroundColor: Colors.green[200], shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),),context: context, builder: (context) {
      return Container(
        height: 10000,
        padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 30.0),
        child: EditInfoForm(currentUserData: widget.currentUserData),
      );
    });
  }

  void _addItemPanel() {
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
                          'Add Item',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            ),
                          ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddItem(forBid: false, currentUserData: widget.currentUserData,),
                            )
                          );   
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
                          'Give On Rent',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            ),
                          ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddRent(currentUserData: widget.currentUserData,),
                            )
                          );
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