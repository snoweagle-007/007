import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseUser loggedInUser;

// ignore: must_be_immutable
class Done extends StatefulWidget {
  static String id = '/Done';

  @override
  _DoneState createState()
  => _DoneState();
}

class _DoneState extends State<Done> {
  final _auth = FirebaseAuth.instance;
  int _currentIndex=0;
  final tabs = [
    Center(child: Text("Welcome To Home Page"),),
    GridView.count(crossAxisCount:2, children: List.generate(11, (index) =>

        Container(

          child: Text("Video$index",style: TextStyle(fontSize: 45),),


        ),


    ),
    ),

    Center(child: Text("This is chat box"),),
    ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person,size: 63.0,color: Colors.orange,),
          title: Text("Rahul Poorna",style: TextStyle(fontSize: 33.5),),
        ),
        ListTile(
          title: Text("      "),

        ),
        ListTile(
          leading: Icon(Icons.score,size: 45.6,color: Colors.yellow,),
          title: Text("Score:",style: TextStyle(fontSize: 23.5),),
          subtitle: Text("8/10",style: TextStyle(fontSize: 22.9,color: Colors.grey),),
        ),
        ListTile(
          title: Text("      "),

        ),
        ListTile(
          leading: Icon(Icons.record_voice_over,size: 45.6,color:Colors.lightBlueAccent),
          title: Text("Your Popularity:",style: TextStyle(fontSize: 23.9),),
          subtitle: Text("6.9",style:TextStyle(fontSize: 23.9,color: Colors.grey),),
        ),
        ListTile(
          title: Text("      "),

        ),
        ListTile(
          leading: Icon(Icons.attach_money,size:45.6, color: Colors.green),
          title: Text('Amount Received in ₹:',style: TextStyle(fontSize: 23.9),),
          subtitle: Text("₹10,000",style: TextStyle(fontSize: 23.9,color: Colors.blue),),
        ),
        ListTile(
          title: Text("      "),

        ),

        ListTile(
          leading: Icon(Icons.file_upload,size: 45.0,color: Colors.black,),
          title: Text('Total Number of bills uploaded',style: TextStyle(fontSize: 23.9),),
          subtitle: Text("2(last updated on 12/08/2020)",style: TextStyle(fontSize: 21.0,color: Colors.grey),),
        ),
        ListTile(
          title: Text("      "),

        ),
        ListTile(
          leading: Icon(Icons.exit_to_app,size: 45.0,color: Colors.blueGrey,),
          title: Text('Sign OUT',style: TextStyle(fontSize: 23.9,color: Colors.grey),),

        ),
      ],
    ),

  ];

  void getCurrentUser() async {
    try {
      //TODO 10 : New user variable to check if a newUser is signed in
      final user = await _auth.currentUser();
      //Equal to null if no user is signed in, else equal to new user details
      //TODO 11 : Use if else block to get the loggedInUser details
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('XYZ Foundation'),
      ),
      body: tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        iconSize: 30,
        selectedFontSize: 19,

        items: [
          BottomNavigationBarItem(


            icon:  new Icon(Icons.home),
            title: new Text("HOME"),
            backgroundColor: Colors.redAccent,


          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.video_call),
            title: new Text("Video"),
            backgroundColor: Colors.blue,

          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.chat),
            title: new Text("Chat"),
            backgroundColor: Colors.pinkAccent,


          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text("Profile"),
            backgroundColor: Colors.yellowAccent,


          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex= index;

          });
        },
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }
}