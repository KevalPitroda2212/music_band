import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_band/Common.dart';
import 'package:music_band/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InItScreen extends StatefulWidget {
  @override
  _InItScreenState createState() => _InItScreenState();
}

class _InItScreenState extends State<InItScreen> {

  SharedPreferences prefs;
  String email='';
  String number;
  createFirebaseApp()async{
    await Firebase.initializeApp().then((value){
      print('value => $value');
    });
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString(Common.PREF_EMAIL_KEY) ?? '';
    number = prefs.getString(Common.PREF_MOBILE_NUMBER_KEY);

    if(email.isNotEmpty && email !=null){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen())
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPrefs();
    super.initState();
    createFirebaseApp();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               Text(
                'Music Band',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Common.elevateButton('Sign In',context),
                    SizedBox(height: 20,),
                    Common.elevateButton('Sign Up',context),
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
