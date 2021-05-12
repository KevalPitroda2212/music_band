import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_band/screens/SignIn.dart';
import 'package:music_band/screens/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Common{

  static final Color themeColor = Colors.teal;
  static final Color btnColor = Colors.teal[300];
  static final Color fontColor = Colors.white;
  static final String PREF_EMAIL_KEY = 'email';
  static final String PREF_MOBILE_NUMBER_KEY = 'number';

  static Widget elevateButton(String name, BuildContext context){
    return ElevatedButton(
      child: Text(name),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
        backgroundColor: MaterialStateColor.resolveWith((states) => Common.btnColor),
      ),
      onPressed: (){
        if(name == 'Sign In'){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignIn())
          );
        }else if(name == 'Sign Up'){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUp())
          );
        }else{

        }
      },
    );
  }
  static InputDecoration textFormFieldDecoration(String label){
    return InputDecoration(
      labelText: label,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Common.themeColor),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Common.themeColor),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Common.themeColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Common.themeColor),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red),
      ),
    );
  }

  static void logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}