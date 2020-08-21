import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/screens/wrapper.dart';
import 'package:rural_e_commerce/services/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
        Locale('en', ''),
        Locale('hi', ''),
        Locale('pa', '')
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales){            
        for(var supportedLocale in supportedLocales){          
          if(supportedLocale.languageCode == locale.languageCode){
            return supportedLocale;          
          }                              
        }
        return supportedLocales.first;
      },
        home: Wrapper(),
      ),
    );
  }
}
