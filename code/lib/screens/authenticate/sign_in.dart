import 'package:flutter/material.dart';
import 'package:rural_e_commerce/screens/authenticate/register/phoneOTP.dart';
import 'package:rural_e_commerce/screens/authenticate/register/register.dart';
import 'package:rural_e_commerce/app_localizations.dart';
import 'package:rural_e_commerce/services/auth.dart';
import 'package:rural_e_commerce/shared/constant.dart';
import 'package:rural_e_commerce/shared/loading.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // To use auth services
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  // Store email & password locally
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Sign In')),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Register(),
                )
              );
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 25.0),
              TextFormField(
                decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Email'), prefixIcon: Icon(Icons.mail)),
                validator: (value) => value.isEmpty ? AppLocalizations.of(context).translate('Enter email id') : null,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 25.0),
              TextFormField(
                decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Password'), prefixIcon: Icon(Icons.vpn_key)),
                validator: (value) => value.length < 7 ? AppLocalizations.of(context).translate('Password must be atleast 8 characters') : null,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(height: 40.0),
              ButtonTheme(
                height: 60.0,
                minWidth: 120.0,
                child: RaisedButton(
                  onPressed: () async{
                    if(_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if(result == null) {
                        setState(() {
                          error = AppLocalizations.of(context).translate('Invalid credentials');
                          loading = false;
                        });
                      }
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.green)
                  ),
                  color: Colors.green,
                  child: Text(
                    AppLocalizations.of(context).translate('Sign In'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              // Google Sign-In Option
              SizedBox(height: 20.0),
              _signInButton(),
              // SizedBox(height: 20.0),
              // _signInWithPhone(),
              SizedBox(height: 40.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Register(),
                      )
                    );
                },
                child: Text(
                  AppLocalizations.of(context).translate('Click here to Register'),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.green,  
      onPressed: () async {
        loading = true;
        dynamic result = await _auth.signInWithGoogle();
        if(result == null) {
          setState(() {
            error = AppLocalizations.of(context).translate('Invalid Credentials');
            loading = false;
          });
        }
        else {
           print(result.uid); 
          }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.green[800]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                AppLocalizations.of(context).translate('Sign In with Google'),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green[800],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInWithPhone() {
    return OutlineButton(
      splashColor: Colors.green,  
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInWithPhoneNo(),
          )
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.green[800]),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.phone, color: Colors.green,size: 36,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                AppLocalizations.of(context).translate('Sign In with Phone'),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green[800],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}