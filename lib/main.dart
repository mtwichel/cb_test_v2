import 'dart:async';

import 'package:flutter/material.dart';
import 'perks.dart';
import 'home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: new Color(0xFF137f45),
        accentColor: new Color(0xFF000000),
        primaryColorLight: new Color(0xFF4faf71),
        primaryColorDark: new Color(0xFF00511c),
      ),
      home: new MyHomePage(title: 'City Brew Coffee'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _state = 0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new PopupMenuButton(
            onSelected: (int choice) {
              switch (choice){
                case 1: //sign in
                  _handleSignIn();
                  break;
                case 2: //sign out

                  break;
              }
            },
              itemBuilder: (BuildContext buildcontext) {
                return [
                  new PopupMenuItem<int>(
                    child: new Text("Sign-In"),
                    value: 1,
                  ),
                  new PopupMenuItem<int>(
                    child: new Text("Sign-Out"),
                    value: 2,
                  )
                ];
              }
          ),
        ],
      ),
      body: (_state==0 ? new HomePage() : new PerksPage()),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: _state,
        onTap: (int index){
          setState(() {
            _state = index;
          });
        },
        items: [
          new BottomNavigationBarItem(
            title: new Text("Home"),
            icon: new Icon(Icons.home),
            backgroundColor: Colors.red,
          ),
          new BottomNavigationBarItem(
            title: new Text("Perks"),
            icon: new Icon(Icons.card_membership),
            backgroundColor: Colors.black,
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton.extended(
        onPressed: null,
        tooltip: 'Increment',
        icon: new Icon(Icons.store),
        label: new Text("Order Now"),
      ),
    );
  }

  void stateChanged(int state) {
    _state = state;
  }

  Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("signed in " + user.displayName);
    return user;
  }
}
