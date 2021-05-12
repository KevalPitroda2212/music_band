import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_band/Common.dart';
import 'package:music_band/screens/Booking.dart';
import 'package:music_band/screens/InItScreen.dart';
import 'package:music_band/screens/FirebaseHandle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  SharedPreferences prefs;
  String email;
  String number;
  Stream<QuerySnapshot> qSnapshot;

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString(Common.PREF_EMAIL_KEY);
    number = prefs.getString(Common.PREF_MOBILE_NUMBER_KEY);
    print('email=>${email}');

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Band'),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed:(){
            Common.logout();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => InItScreen())
            );
          }),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').where('email',isEqualTo: email).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          return ListView.builder(
            itemCount: snapshot.data ==null ? 0 :snapshot.data.docs.length,
            itemBuilder: (context, index){
              return snapshot.data.docs[index]['email'] == email
                  ? Container(
                margin: EdgeInsets.symmetric(horizontal: 15 ,vertical: 7),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey,
                    ),
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name : ${snapshot.data.docs[index]['name']}",
                      style: TextStyle(color: Colors.teal,fontSize: 25)),
                    SizedBox(height: 5,),
                    Text("Number : ${snapshot.data.docs[index]['number']}"),
                    SizedBox(height: 5,),
                    Text("Address : ${snapshot.data.docs[index]['address']}"),
                    SizedBox(height: 5,),
                    Text("Estimated Price : ${snapshot.data.docs[index]['cost']}",
                      style: TextStyle(color: Colors.green),),
                    SizedBox(height: 5,),
                    Text("Date : ${snapshot.data.docs[index]['date']}",
                    style: TextStyle(color: Colors.blue),),
                    SizedBox(height: 5,),
                    Text("Description : ${snapshot.data.docs[index]['description']}"),
                  ],
                ),
              ) : Container();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:(){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Booking())
          );
        },
        label: Text('Booking'),
      ),
    );
  }
}
