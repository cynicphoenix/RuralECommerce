import 'package:flutter/material.dart';
import 'package:rural_e_commerce/screens/authenticate/register/register3.dart';


class Register2 extends StatefulWidget {
  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {
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
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 100.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 120.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                  side: BorderSide(color: Colors.green, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      title: Center(
                        child: Text(
                          'Preferred Language',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                      subtitle: Center(child: Text('Tap on the language to choose it!')),
                    ),
                  ],
                ), 
              ),
            ),
            SizedBox(height: 30.0,),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.green, width: 1),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Center(child: Text('English')),
                    onTap: () {
                      print('Tapped!');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register3(preferredLanguage: "English"),
                        )
                      );
                    },
                  ),
                ],
              ), 
            ),
            SizedBox(height: 10.0,),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.green, width: 1),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Center(child: Text('Hindi')),
                    onTap: () {
                      print('Tapped!');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register3(preferredLanguage: "Hindi"),
                        )
                      );
                    },
                  ),
                ],
              ), 
            ),
            SizedBox(height: 10.0,),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.green, width: 1),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Center(child: Text('Punjabi')),
                    onTap: () {
                      print('Tapped!');
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register3(preferredLanguage: "Punjabi"),
                        )
                      );
                    },
                  ),
                ],
              ), 
            ),
          ],
        ),
      ),
    );
  }
}