import 'package:flutter/material.dart';
import 'package:rural_e_commerce/screens/authenticate/register/register4.dart';
import 'package:rural_e_commerce/shared/constant.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class Register3 extends StatefulWidget {
  final String preferredLanguage;
  Register3({Key key, @required this.preferredLanguage}) : super(key: key);
  @override
  _Register3State createState() => _Register3State();
}

class _Register3State extends State<Register3> {
  final _formKey = GlobalKey<FormState>();
  
  String uid = '';
  String name = '';
  String contactNo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Rural E Commerce')),
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
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
        child: Form(
          key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 25.0),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('      Full Name'), prefixIcon: Icon(Icons.person)),
                  validator: (value) => value.length < 1 ? AppLocalizations.of(context).translate('Name-field cannot be empty!') : null,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                SizedBox(height: 25.0),
                SizedBox(height: 10.0),
                TextFormField(
                  decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Contact-No'), prefixIcon: Icon(Icons.phone), prefixText: '+91'),
                  validator: (value) => !isNumeric(value) ? AppLocalizations.of(context).translate('Invalid contact information') : null,
                  onChanged: (value) {
                    setState(() {
                      contactNo = value;
                    });
                  },
                ),
                SizedBox(height: 50.0),
                ButtonTheme(
                  height: 60.0,
                  minWidth: 120.0,
                  child: RaisedButton(
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register4(name: name, contactNo: contactNo, preferredLanguage: widget.preferredLanguage),
                          )
                        );
                      }
                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.green)
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate('Next Page'),
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    if(s.length != 10) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}