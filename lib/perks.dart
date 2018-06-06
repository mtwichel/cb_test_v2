import 'package:flutter/material.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class PerksPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _PerksPageState();

}

class _PerksPageState extends State <PerksPage> {

  int storeNum = 1;
  String _currentUser;

  var locations = {
    1: [-108.558485, 45.783883],
    3: [-108.577248, 45.755775],
    5: [-108.614153, 45.754857],
    7: [-108.515731, 45.794672],
    9: [-108.770728, 45.665017],
    11: [-108.472538, 45.811303],
    18: [-108.597714, 45.783772],
    100: [-111.1374192, 45.66934],
  };

  @override
  void initState() {
    super.initState();
    _currentUser = null;
  }

  checkIn(var location) async {
    if(location != null){
      print(location["longitude"].toString() + " | " + location["latitude"].toString());
      var snackbar = await searchForCBs(location["longitude"], location["latitude"]);
      Scaffold.of(context).showSnackBar(snackbar);

    }
  }

  searchForCBs(var longitude, var latitude) async {
    SnackBar snackbar;
    await Future.forEach(locations.keys, (key) {
      if((locations[key][0] - longitude).abs() < .01  && (locations[key][1] - latitude).abs() < .01){
        final storeDocRef = Firestore.instance.document('check-ins/$key');
        try{
          storeDocRef.updateData({
            "marcustwichel" : true
          });
          snackbar = new SnackBar(
            content: new Text('Checked into CB$key'),
            action: new SnackBarAction(
              label: 'Undo',
              onPressed: () {
                storeDocRef.updateData({
                  "marcustwichel" : false
                });
              },
            ),
          );
        }catch (error){
          snackbar = new SnackBar(content: new Text('An Error Occured'));
        }
      }
    });
    if(snackbar != null){
      return snackbar;
    }else{
      return new SnackBar(content: new Text('Not Near Any City Brew'));
    }
  }

  @override
  Widget build(BuildContext context) {
    var cardNumber = '40280 0000 00563';
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Title(
          child: new Text("Logged In As"),
          color: Colors.black,
        ),
        new Container(
          margin: EdgeInsets.all(8.0),
          child: new FlatButton(
            child: new Text("CHECK IN NOW"),
            color: new Color(0xFF137f45),
            textColor: Colors.white,
            onPressed: () {
              checkGps();
            },

          ),
        ),

        new Card(
            margin: new EdgeInsets.all(16.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(16.0),
            ),
            child: new Container(
              padding: EdgeInsets.only(
                left: 70.0,
                right: 70.0,
                top: 10.0,
                bottom: 10.0,
              ),
              child: new Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  new Center(child: new CircularProgressIndicator()),
                  new Center(child: new FadeInImage.memoryNetwork(
                    image: ('https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=' + cardNumber),
                    placeholder: kTransparentImage,
                  )),
                ],

              ),
            )

        ),
        new Divider(),
      ],
    );
  }

  void checkGps() async {
    var currentLocation = <String, double>{};
    var location = new Location();
    try {
      currentLocation = await location.getLocation;
      checkIn(currentLocation);
    }  catch (e) {
      print(e);

    }

  }

  Widget _getPerkCard(String cardNumber) {
    return new Card(
        color: Colors.grey[700],
        margin: new EdgeInsets.all(16.0),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0),
        ),
        child:
        new ListTile(
          leading: new Icon(Icons.album),
          title: new Text('City Brew Coffee', style: new TextStyle(
              color: Colors.white
          ),),
          subtitle: new Text(cardNumber),
        )
    );
  }
}