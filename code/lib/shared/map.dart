import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:rural_e_commerce/models/item.dart';
import 'package:rural_e_commerce/models/user.dart';
import 'package:rural_e_commerce/app_localizations.dart';

class MapWidget extends StatefulWidget {
  final Item item;
  final DocumentSnapshot retailerSnapshot;
  final CurrentUserData currentUserData;
  MapWidget({this.item, this.retailerSnapshot, this.currentUserData});
  @override
  _MapWidgetState createState() => new _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
  final List<String> retailerAddress = widget.retailerSnapshot.data['address'].split('#');
  final List<String> currentUserAddress = widget.currentUserData.address.split('#');
  // var points = <LatLng>[
  //       new LatLng(num.parse(retailerAddress[0]), num.parse(retailerAddress[1])),
  //       new LatLng(num.parse(currentUserAddress[0]), num.parse(currentUserAddress[1])),
  // ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Tap on Marker')),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {},
          )
        ],
      ), 
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(num.parse(retailerAddress[0]), num.parse(retailerAddress[1])), minZoom: 5.0),
        layers: [
          new TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/cynicphoenix/ckcp165ui00vc1ims6hmgrehp/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY3luaWNwaG9lbml4IiwiYSI6ImNrY295MnJyZTAzaW4yc2xnMXR1MHNvMWYifQ.PMxSMzefkXNVcNZWdoRT9A",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiY3luaWNwaG9lbml4IiwiYSI6ImNrY295MnJyZTAzaW4yc2xnMXR1MHNvMWYifQ.PMxSMzefkXNVcNZWdoRT9A',
              // 'id': 'mapbox.mapbox-streets-v7'
            }
          ),
          MarkerLayerOptions(markers: [
            Marker(
              width: 45.0,
              height: 45.0,
              point: new LatLng(num.parse(retailerAddress[0]), num.parse(retailerAddress[1])),
              builder: (context) => new Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.red,
                  iconSize: 60.0,
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(100.0)),),
                      context: context,
                      builder: (builder) {
                        return Container(
                          margin: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 50),
                          height: 160.0,
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
                                  Icons.shopping_basket,
                                  size: 40.0,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 15.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        '${retailerAddress[2]}',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,    
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  '(${AppLocalizations.of(context).translate("Retailer\'s Location")})',
                                  style: TextStyle(
                                    fontSize: 15.0, 
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              ),
            ),

            Marker(
              width: 45.0,
              height: 45.0,
              point: new LatLng(num.parse(currentUserAddress[0]), num.parse(currentUserAddress[1])),
              builder: (context) => new Container(
                child: IconButton(
                  icon: Icon(Icons.location_on),
                  color: Colors.blue,
                  iconSize: 60.0,
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(100.0)),),
                      context: context,
                      builder: (builder) {
                        return Container(
                          margin: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 50),
                          height: 160.0,
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
                                  Icons.home,
                                  size: 40.0,
                                  color: Colors.blue,
                                  ),
                                
                                SizedBox(height: 15.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        '${currentUserAddress[2]}',
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,    
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  '(${AppLocalizations.of(context).translate("My Location")})',
                                  style: TextStyle(
                                    fontSize: 15.0, 
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                ),
              ),
            ),
          ],),
          // new PolylineLayerOptions(
          //   polylines: [
          //     new Polyline(
          //       points: points,
          //       strokeWidth: 2.0,
          //       color: Colors.green
          //     )
          //   ]
          // )
        ]
      )
    );
  }
}