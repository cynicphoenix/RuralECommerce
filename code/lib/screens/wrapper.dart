import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/screens/authenticate/authenticate.dart';
import 'package:rural_e_commerce/screens/authenticate/register/register3.dart';
import 'package:rural_e_commerce/screens/home/buyer/homeBuyer.dart';
import 'package:rural_e_commerce/screens/home/seller/homeSeller.dart';
import 'package:rural_e_commerce/services/database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null) {
      return Authenticate();
    }
    else {
      return StreamBuilder<CurrentUserData>(
        stream: DatabaseServices(uid: user.uid).userData,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            CurrentUserData currentUserData = snapshot.data;
            if (currentUserData.isRegistrationComplete) {
              if(currentUserData.isRetailer) {
                return HomeBuyer(currentUserData: currentUserData);
              }
              else {
                return HomeSeller(currentUserData: currentUserData);
              }
            }
            else {
              return Register3(preferredLanguage: 'Default',);
            }
          }
          else {
            return Authenticate();
          }
        }
      );
    }
  }
}