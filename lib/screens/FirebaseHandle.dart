import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_band/Common.dart';
import 'package:music_band/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseHandle{
  FirebaseAuth auth = FirebaseAuth.instance;

  // SharedPreferences prefs;

  static void userRegister(String email, String number, String pw,BuildContext context) async {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uId = auth.currentUser.uid.toString();
    // user.add({'email' : email, 'number' : number});
    user.get().then((value){
      bool isTaken = false;
      for(int i=0 ;i<value.docs.length;i++){
        if(value.docs[i]['email'] == email || value.docs[i]['number'] == number){
          isTaken = true;
          break;
        }
        else{
          isTaken = false;
        }
      }

      if(isTaken){
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(
              content: Text(
                'You are already register.',
              ),
              duration: Duration(seconds: 10),
            )
        );
      }
      else{
        user.add({'email' : email, 'number' : number, 'password':pw}).then((value){
          print(value.id);
          if(!value.id.isEmpty){
            prefs.setString(Common.PREF_EMAIL_KEY, email);
            prefs.setString(Common.PREF_MOBILE_NUMBER_KEY, number);

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen())
            );
          }else{
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Oops!! Something went wrong')));
          }
        });
      }
    });
  }

  static void userLogin(String email, String pw,BuildContext context) async {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String uId = auth.currentUser.uid.toString();
    // user.add({'email' : email, 'number' : number});
    user.get().then((value){
      bool isTaken = false;
      String number='';
      for(int i=0 ;i<value.docs.length;i++){
        if(value.docs[i]['email'] == email && value.docs[i]['password'] == pw){
          isTaken = true;
          number = value.docs[i]['number'];
          break;
        }
        else{
          isTaken = false;
        }
      }

      if(isTaken){
        prefs.setString(Common.PREF_EMAIL_KEY, email);
        prefs.setString(Common.PREF_MOBILE_NUMBER_KEY, number);

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen())
        );
      }
      else{
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email or Password is incorrect.')));
      }
    });
  }

  static Future<bool> userBooking(Map<String,dynamic> data, BuildContext context) async {
    CollectionReference booking = FirebaseFirestore.instance.collection('bookings');
    // String uId = auth.currentUser.uid.toString();

    print(data['date']);
    booking.get().then((value){
      bool isTaken = false;
      for(int i=0 ;i<value.docs.length;i++){
        if(value.docs[i]['date'] == data['date']){
          isTaken = true;
          break;
        }
        else{
          isTaken = false;
        }
      }

      if(isTaken){
        ScaffoldMessenger.of(context)
            .showSnackBar(
            SnackBar(
              content: Text(
                'Sorry !! This date we are not available. Please select another date.',
              ),
              duration: Duration(seconds: 10),
            )
        );
      }
      else{
        booking.add(data).then((value){
          print(value.id);
          if(!value.id.isEmpty){
            ScaffoldMessenger.of(context)
                .showSnackBar(
                SnackBar(content: Text('Your booking is successfully done.'))
            );
            Navigator.of(context).pop();
          }else{
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Oops!! Something went wrong')));
          }
        });
      }
    });

  }

  static Future<Stream> getBooking(String email) async {
    Stream<QuerySnapshot> querySnapshot;
    CollectionReference user = FirebaseFirestore.instance.collection('bookings');
    user.where('email',isEqualTo: email).get().then((value){
      print(value.docs.length);
    });
    return querySnapshot;
  }

}