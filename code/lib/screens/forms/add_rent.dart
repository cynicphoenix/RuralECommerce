import 'package:flutter/material.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/screens/wrapper.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/shared/constant.dart';
import 'package:rural_e_commerce/shared/loading.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class AddRent extends StatefulWidget {
  final CurrentUserData currentUserData;
  AddRent({this.currentUserData});
  @override
  _AddRentState createState() => _AddRentState();
}

class _AddRentState extends State<AddRent> {
  final _formKey = GlobalKey<FormState>();
  // Store email & password locally
  String name = '';
  int quantity = 0;
  double price = 0;
  String description = '';
  bool loading = false;
  String address;

  @override
  Widget build(BuildContext context) {
    address = widget.currentUserData.address;
      return loading ? Loading() : Scaffold(
        backgroundColor: Colors.green[200],
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).translate('Add Item for Rent')),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bottom.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            // child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 25.0),
                  TextFormField(
                    decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Name of item/vehicle to be rented')),
                    validator: (value) => value.length <= 3 ? AppLocalizations.of(context).translate('Enter item/vehicle name correctly!') : null,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Time for Lease in Days')),
                    validator: (value) => !_checkValidity(value) ? AppLocalizations.of(context).translate('Incorrect Time Period!') : null,
                    onChanged: (value) {
                      setState(() {
                        quantity = int.parse(value);
                      });
                    },
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Rent/Day')),
                    validator: (value) => !_checkValidity(value) ? AppLocalizations.of(context).translate('Pricing incorrect!') : null,
                    onChanged: (value) {
                      setState(() {
                        price = double.parse(value);
                      });
                    },
                  ),
                  SizedBox(height: 25.0),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Additional Comment')),
                    validator: (value) => value.length < 0 ? AppLocalizations.of(context).translate('Invalid description!') : null,
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  SizedBox(height: 25.0),
                  ButtonTheme(
                    height: 40.0,
                    minWidth: 100.0,
                    child: RaisedButton(
                      onPressed: () async{
                        if(_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          await DatabaseServices(uid: widget.currentUserData.uid).setItemData(
                            name,
                            quantity,
                            price,
                            description,
                            address,
                            true,
                            false,
                            DateTime.now().millisecondsSinceEpoch,
                            0,
                            DateTime.now().millisecondsSinceEpoch + (50 * 24 * 60 * 60 * 1000),
                          );
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => Wrapper(),
                            ),
                            (Route<dynamic> route) => false
                          );
                        }
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: Colors.green)
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('Give On Rent'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
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
      if(double.parse(s) <= 0) {
        returnValidity = false;
      }
    }
    return returnValidity;
  }
}