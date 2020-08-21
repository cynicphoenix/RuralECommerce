import 'package:flutter/material.dart';
import 'package:rural_e_commerce/screens/authenticate/register/register5.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class Register4 extends StatefulWidget {
  final String preferredLanguage;
  final String name;
  final String contactNo;
  Register4({Key key, @required this.name, @required this.contactNo, @required this.preferredLanguage}) : super(key: key);
  @override
  _Register4State createState() => _Register4State();
}

class _Register4State extends State<Register4> {
  bool isRetailer = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        title: Text('Rural E Commerce'),
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
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 100.0),
        child: Center(
          child: SingleChildScrollView(
                      child: Column(
              children: <Widget>[
                Container(
                  child: InkWell( 
                    onTap: () {
                      isRetailer = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register5(name: widget.name, contactNo: widget.contactNo, 
                            preferredLanguage: widget.preferredLanguage, isRetailer: isRetailer),
                        )
                      );
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.green[800],
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/farmer.png'),
                        radius: 99,
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  AppLocalizations.of(context).translate('SELLER'),
                  style: TextStyle(
                    fontSize: 20.0,
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                SizedBox(height: 50.0),
                Container(
                  child: InkWell( 
                    onTap: () {
                      isRetailer = true;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register5(name: widget.name, contactNo: widget.contactNo, 
                            preferredLanguage: widget.preferredLanguage, isRetailer: isRetailer),
                        )
                      );
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.green[800],
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/retailer.png'),
                        radius: 99,
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  AppLocalizations.of(context).translate('BUYER'),
                  style: TextStyle(
                    fontSize: 20.0,
                    letterSpacing: 3.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
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