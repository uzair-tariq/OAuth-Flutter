import 'package:flutter/material.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Social Login Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: new Text("Facebook"),
              onPressed: () async {
                final facebookLogin = FacebookLogin();
                final result = await facebookLogin.logInWithReadPermissions(['email']);
                switch (result.status) {
                  case FacebookLoginStatus.loggedIn:
                    print(result.accessToken.token);
                    break;
                  case FacebookLoginStatus.cancelledByUser:
                    print("Login Cancelled");
                    break;
                  case FacebookLoginStatus.error:
                    print(result.errorMessage);
                    break;
                }
              },
            ),
            FlatButton(
              child: new Text("Google"),
              onPressed: () async {
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final GoogleSignIn googleSignIn = GoogleSignIn();

                final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
                final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

                final AuthCredential credential = GoogleAuthProvider.getCredential(
                  accessToken: googleSignInAuthentication.accessToken,
                  idToken: googleSignInAuthentication.idToken,
                );

                final FirebaseUser user = await _auth.signInWithCredential(credential);

                assert(!user.isAnonymous);
                assert(await user.getIdToken() != null);

                final FirebaseUser currentUser = await _auth.currentUser();
                assert(user.uid == currentUser.uid);

                print(user);
                
              },
            )
          ],
        ),
      ),
    );
  }
}
