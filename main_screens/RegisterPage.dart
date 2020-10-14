import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hindi_app/results_screen/Done.dart';
import 'package:hindi_app/results_screen/GoogleDone.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:validators/validators.dart' as validator;

import 'LoginPage.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  static String id = '/RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name;
  String email;
  String password;
  String  aadharNum;

  bool _showSpinner = false;

  bool _wrongEmail = false;
  bool _wrongPassword = false;

  String _emailText = 'Please use a valid email';
  String _passwordText = 'Please use a strong password';

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    // hold the instance of the authenticated user
    FirebaseUser user;
    // flag to check whether we're signed in already
    bool isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      // if so, return the current user
      user = await _auth.currentUser();
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      // get the credentials to (access / id token)
      // to sign in via Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      user = (await _auth.signInWithCredential(credential)).user;
    }

    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    FirebaseUser user = await _handleSignIn();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GoogleDone(user, _googleSignIn)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        color: Colors.deepOrangeAccent,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,

              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 60.0, bottom: 20.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'स्वागत है। ',
                      style: TextStyle(fontSize: 50.0),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'कृपया अपनी जानकारी प्रदान करें।',
                          style: TextStyle(fontSize: 20.0),
                        ),

                        Text(
                          'ध्यान दें: यह फॉर्म  केवल  भारतीय  नागरिकों को लिए है ',
                          style: TextStyle(fontSize: 19.0,color: Colors.red),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('             '),
                        TextField(

                          onChanged: (value) {
                            name = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.orangeAccent,
                            hintText: 'पूरा नाम ',
                            labelText: 'पूरा नाम ',
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'इ-मेल ',
                            errorText: _wrongEmail ? _emailText : null,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (value) {
                            password = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.green,
                            labelText: 'पासवर्ड ',
                            errorText: _wrongPassword ? _passwordText : null,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        TextField(

                          onChanged: (value) {
                            aadharNum = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.blueAccent,

                            labelText: 'आधार संख्या ',
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Text('                '),
                      ],
                    ),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      color: Colors.purple,
                      onPressed: () async {
                        setState(() {
                          _wrongEmail = false;
                          _wrongPassword = false;
                        });
                        try {
                          if (validator.isEmail(email) &
                          validator.isLength(password, 6)) {
                            setState(() {
                              _showSpinner = true;
                            });
                            final newUser =
                            await _auth.createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            if (newUser != null) {
                              print('user authenticated by registration');
                              Navigator.pushNamed(context, Done.id);
                            }
                          }

                          setState(() {
                            if (!validator.isEmail(email)) {
                              _wrongEmail = true;
                            } else if (!validator.isLength(password, 6)) {
                              _wrongPassword = true;
                            } else {
                              _wrongEmail = true;
                              _wrongPassword = true;
                            }
                          });
                        } catch (e) {
                          setState(() {
                            _wrongEmail = true;
                            if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
                              _emailText =
                              'The email address is already in use by another account';
                            }
                          });
                        }
                      },
                      child: Text(
                        'रजिस्टर करें',
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: 1.0,
                            width: 60.0,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'या ',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            height: 1.0,
                            width: 60.0,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            color: Colors.redAccent,
                            shape: ContinuousRectangleBorder(
                              side:
                              BorderSide(width: 0.5, color: Colors.black12),
                            ),
                            onPressed: () {
                              onGoogleSignIn(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  'गूगल ',
                                  style: TextStyle(
                                      fontSize: 25.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            color: Colors.indigo,
                            shape: ContinuousRectangleBorder(
                              side:
                              BorderSide(width: 0.5, color: Colors.indigo[400]),
                            ),
                            onPressed: () {
                              //TODO: Implement facebook functionality
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'फेसबुक ',
                                  style: TextStyle(
                                      fontSize: 25.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'पहले से ही एक उपयोगकर्ता ?',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LoginPage.id);
                          },
                          child: Text(
                            ' लाग '
                                ' इन ',
                            style: TextStyle(fontSize: 25.0, color: Colors.blue),
                          ),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}