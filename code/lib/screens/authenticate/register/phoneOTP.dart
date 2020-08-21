import 'package:flutter/material.dart';
import 'package:rural_e_commerce/screens/authenticate/register/register.dart';
import 'package:rural_e_commerce/screens/authenticate/sign_in.dart';
// import 'package:rural_e_commerce/services/auth.dart';
import 'package:rural_e_commerce/shared/constant.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:rural_e_commerce/shared/loading.dart';

class SignInWithPhoneNo extends StatefulWidget {
  final Function toggleView;
  SignInWithPhoneNo({this.toggleView});

  @override
  _SignInWithPhoneNoState createState() => _SignInWithPhoneNoState();
}

class _SignInWithPhoneNoState extends State<SignInWithPhoneNo> {

  // To use auth services
  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
   String phoneNo;
  String smsCode;
  String verificationId;
  String error = '';
  bool loading = false;

  // Future<void> verifyPhone() async {
  //   final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
  //     this.verificationId = verId;
  //   };

  //   final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
  //     this.verificationId = verId;
  //     smsCodeDialog(context).then((value) {
  //       print('Signed in');
  //     });
  //   };

  //   final PhoneVerificationCompleted verifiedSuccess = (FirebaseUser user) {
  //     print('verified');
  //   };

  //   final PhoneVerificationFailed veriFailed = (AuthException exception) {
  //     print('${exception.message}');
  //   };

  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: this.phoneNo,
  //     codeAutoRetrievalTimeout: autoRetrieve,
  //     codeSent: smsCodeSent,
  //     timeout: const Duration(seconds: 5),
  //     verificationCompleted: verifiedSuccess,
  //     verificationFailed: veriFailed
  //   );
  // }
 
  // Future<bool> smsCodeDialog(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return new AlertDialog(
  //         title: Text('Enter sms Code'),
  //         content: TextField(
  //           onChanged: (value) {
  //             this.smsCode = value;
  //           },
  //         ),
  //         contentPadding: EdgeInsets.all(10.0),
  //         actions: <Widget>[
  //           new FlatButton(
  //             child: Text('Done'),
  //             onPressed: () {
  //               FirebaseAuth.instance.currentUser().then((user) {
  //                 if (user != null) {
  //                   Navigator.of(context).pop();
  //                   Navigator.of(context).pushReplacementNamed('/homepage');
  //                 } else {
  //                   Navigator.of(context).pop();
  //                   signIn();
  //                 }
  //               });
  //             },
  //           )
  //         ],
  //       );
  //     }
  //   );
  // }
 
  // signIn() {
  //   FirebaseAuth.instance
  //       .signInWithPhoneNumber(verificationId: verificationId, smsCode: smsCode)
  //       .then((user) {
  //     Navigator.of(context).pushReplacementNamed('/homepage');
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }
 
  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     appBar: new AppBar(
  //       title: new Text('PhoneAuth'),
  //     ),
  //     body: new Center(
  //       child: Container(
  //           padding: EdgeInsets.all(25.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               TextField(
  //                 decoration: InputDecoration(hintText: 'Enter Phone number'),
  //                 onChanged: (value) {
  //                   this.phoneNo = value;
  //                 },
  //               ),
  //               SizedBox(height: 10.0),
  //               RaisedButton(
  //                   onPressed: verifyPhone,
  //                   child: Text('Verify'),
  //                   textColor: Colors.white,
  //                   elevation: 7.0,
  //                   color: Colors.blue)
  //             ],
  //           )),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text('Sign In with Phone'),
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
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/bottom.png'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 25.0),
              TextFormField(
                decoration: TextInputDecoration.copyWith(hintText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                validator: (value) => value.length != 10 && isNumeric(value) ? 'Enter valid phone number' : null,
                // controller: phoneNumController,
                onChanged: (value) {
                  setState(() {
                    phoneNo = value;
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
                      // _verifyPhoneNumber(context);
                      
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: Colors.green)
                  ),
                  color: Colors.green,
                  child: Text(
                    'Sign-In',
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
              
              // Sign In with Email
              SizedBox(height: 20.0),
              _signInWithMail(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInWithMail() {
    return OutlineButton(
      splashColor: Colors.green,  
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignIn(),
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
            Icon(Icons.mail, color: Colors.green[800],size: 38,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign In with Email',
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


  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

}