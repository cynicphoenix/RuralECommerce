import 'package:rural_e_commerce/models/user.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/shared/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class EditInfoForm extends StatefulWidget {
  final CurrentUserData currentUserData;
  EditInfoForm({this.currentUserData});
  @override
  _EditInfoFormState createState() => _EditInfoFormState();
}

class _EditInfoFormState extends State<EditInfoForm> {
  final _formKey = GlobalKey<FormState>();
  Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = '';
  String _currentFullAddress;
  String _currentName;
  String _currentContactNo;
  String _currentPreferredLanguage;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    String address = widget.currentUserData.address.split('#')[2];
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate('Update your Personal Information!'),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
              padding:EdgeInsets.symmetric(horizontal:10.0),
              child:Container(
                height:1.5,
                color:Colors.green,
              ),
            ),
          SizedBox(
            height: 50.0,
          ),
          TextFormField(
            initialValue: widget.currentUserData.name,
            decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Name'), 
                        prefixIcon: Icon(Icons.person),),
            validator: (value) => value.isEmpty ? AppLocalizations.of(context).translate('Name-field cannot be empty!') : null,
            onChanged: (value) {
              setState(() {
                _currentName = value;
              });
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          TextFormField(
            initialValue: widget.currentUserData.contactNo,
            decoration: TextInputDecoration.copyWith(hintText: AppLocalizations.of(context).translate('Contact-No'), 
                        prefixIcon: Icon(Icons.phone),),
            validator: (value) => !isNumeric(value) ? AppLocalizations.of(context).translate('Invalid contact information') : null,
            onChanged: (value) {
              setState(() {
                _currentContactNo = value;
              });
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          // Container(
          //   height: 60.0,
          //   padding: EdgeInsets.symmetric(horizontal: 10.0),
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(30.0),
          //                 border: Border.all(
          //                     color: Colors.white, style: BorderStyle.solid, width: 0.0),
          //               ),
          //   child: DropdownButtonHideUnderline(
          //     child: DropdownButton<String>( 
          //       isExpanded: true,
          //       dropdownColor: Colors.green,          
          //       hint: Center(
          //         child: Text(
          //           "Preferred Language : ${_currentPreferredLanguage ?? widget.currentUserData.preferredLanguage} "
          //         ),
          //       ),
          //       items: <String>['English', 'Hindi', 'Punjabi'].map((String value) {
          //         return new DropdownMenuItem<String>(
          //           value: value,
          //           child: new Text(value),
          //         );
          //       }).toList(),
          //       onChanged: (value) {
          //         setState(() {
          //           _currentPreferredLanguage = value;
          //         });
          //       },
          //     ),
          //   ),
          // ),
          
          SizedBox(
            height: 30.0,
          ),

        
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_currentAddress == '')
                IconButton(
                  icon: Icon(Icons.my_location),
                  iconSize: 50.0,
                  color: Colors.green,
                  tooltip: AppLocalizations.of(context).translate('Get Location'),
                  onPressed: () {
                    setState(() {
                    });
                    _getCurrentLocation();
                  },
                ),
              if (_currentAddress != '')
                IconButton(
                  icon: Icon(Icons.location_on),
                  iconSize: 50.0,
                  color: Colors.green,
                  tooltip: AppLocalizations.of(context).translate('My Location'),
                  onPressed: () {
                  },
                ),
              SizedBox(width: 10.0,),
              if (_currentAddress == '')
                Text(
                  '$address',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              if (_currentAddress != '')
                Text(
                  "$_currentAddress",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
            ],
          ),
          
          SizedBox(
            height: 30.0,
          ),
          ButtonTheme(
            height: 60.0,
            minWidth: 180.0,
            child: RaisedButton(
              onPressed: () async {
                if(_formKey.currentState.validate()) {
                  await DatabaseServices(uid: widget.currentUserData.uid).updateUserData(
                    _currentName ?? widget.currentUserData.name,
                    _currentContactNo ?? widget.currentUserData.contactNo,
                    widget.currentUserData.isRetailer,
                    _currentPreferredLanguage ?? widget.currentUserData.preferredLanguage,
                    _currentFullAddress ?? widget.currentUserData.address,
                    widget.currentUserData.isRegistrationComplete,
                  );
                  Navigator.pop(context);
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.green[800])),
              color: Colors.green,
              child: Text(
                AppLocalizations.of(context).translate('Update Info'),
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
          ),
        ],
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
        _currentFullAddress = _currentPosition.latitude.toString() + '#' + _currentPosition.longitude.toString()
                        + '#' + _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }
}