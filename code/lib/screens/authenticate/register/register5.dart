import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/screens/wrapper.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/shared/loading.dart';
import 'package:rural_e_commerce/app_localizations.dart';


class Register5 extends StatefulWidget {
  final String preferredLanguage;
  final String name;
  final String contactNo;
  final bool isRetailer;
  Register5({Key key, @required this.name, @required this.contactNo, @required this.preferredLanguage, @required this.isRetailer}) : super(key: key);
  @override
  _Register5State createState() => _Register5State();
}

class _Register5State extends State<Register5> {
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = '';
  bool loading = false;
  @override
  Widget build(BuildContext context) {   
    final user = Provider.of<User>(context);
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
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
        child: Center(
          child: Column(
            children: <Widget>[
              if (_currentAddress == '' && loading == false)
                IconButton(
                  icon: Icon(Icons.my_location),
                  iconSize: 100.0,
                  color: Colors.green,
                  tooltip: AppLocalizations.of(context).translate('Get Location'),
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    _getCurrentLocation();
                  },
                ),
              if (_currentAddress == '' && loading == true)
                SizedBox(height: 20.0),
              if (_currentAddress == '' && loading == true)
                LoadingFadingCircle(),
              if (_currentAddress != '')
                IconButton(
                  icon: Icon(Icons.location_on),
                  iconSize: 100.0,
                  color: Colors.green,
                  tooltip: AppLocalizations.of(context).translate('Get Location'),
                  onPressed: () {
                  },
                ),
              SizedBox(height: 20.0),
              if (_currentAddress == '' && loading == false)
                Text(
                  AppLocalizations.of(context).translate('Allow & Turn on GPS,'),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                ),
              SizedBox(height: 10.0),
              if (_currentAddress == '' && loading == false)
                Text(
                  AppLocalizations.of(context).translate('Tap on Location Icon to get Location!'),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                ),            
              if (_currentAddress != '')
                Text(
                  "$_currentAddress",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              SizedBox(height: 60.0),
              if (_currentAddress != '')
              ButtonTheme(
                height: 60.0,
                minWidth: 200.0,
                child: RaisedButton(
                  onPressed: () async {
                    await DatabaseServices(uid: user.uid).updateUserData(
                      widget.name,
                      widget.contactNo,
                      widget.isRetailer,
                      widget.preferredLanguage,
                      _currentPosition.latitude.toString() + '#' + _currentPosition.longitude.toString()
                        + '#' + _currentAddress,
                      true,
                    );
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => Wrapper(),
                      ),
                      (Route<dynamic> route) => false
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.green[800])),
                  color: Colors.green,
                  child: Text(
                    AppLocalizations.of(context).translate('Create Account'),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  // This function gets location
  _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}

