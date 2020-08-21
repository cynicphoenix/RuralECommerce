import 'package:rural_e_commerce/models/item.dart';
import 'package:flutter/material.dart';
import 'package:rural_e_commerce/services/database.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class DeleteForm extends StatefulWidget {
  final Item item;
  DeleteForm({this.item});
  @override
  _DeleteFormState createState() => _DeleteFormState();
}

class _DeleteFormState extends State<DeleteForm> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 50),
      height: 200.0,
      color: Colors.transparent,
      child: Container(
        height: 125,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10, color: Colors.green[200], spreadRadius: 5
            )
          ]
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0,),
            Icon(
              Icons.delete,
              size: 40.0,
              color: Colors.red,
            ),
            SizedBox(height: 15.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Text(
                    '${AppLocalizations.of(context).translate("Delete")} ${widget.item.name}?',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,    
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 45.0,
                  child: FlatButton(

                    child: Text(
                      AppLocalizations.of(context).translate('Yes'),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        ),
                      ),
                    onPressed: () async {
                      dynamic result = await DatabaseServices().deleteItem(widget.item.userUID+'#'+widget.item.name);
                      if(result == 'Success') {
                        print('Delete Success');
                      }
                      else {
                        print('Cannot Delete');
                      }
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(side: BorderSide(
                      color: Colors.green,
                      width: 1.5,
                      style: BorderStyle.solid
                    ), borderRadius: BorderRadius.circular(50)),
                  ),
                ),
                SizedBox(width: 20.0,),
                Container(
                  height: 45.0,
                  child: FlatButton(
                    child: Text(
                      AppLocalizations.of(context).translate('No'),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        ),
                      ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(side: BorderSide(
                      color: Colors.green,
                      width: 1.5,
                      style: BorderStyle.solid
                    ), borderRadius: BorderRadius.circular(50)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}