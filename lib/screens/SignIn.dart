import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_band/Common.dart';
import 'package:music_band/screens/HomeScreen.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:music_band/screens/FirebaseHandle.dart' as db;
import 'package:music_band/screens/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FormElement();
  }
}

class FormElement extends StatefulWidget {
  @override
  _FormElementState createState() => _FormElementState();
}

class _FormElementState extends State<FormElement> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailCont = TextEditingController();
  TextEditingController _pwCont = TextEditingController();
  SharedPreferences prefs;

  sendMail(String email, String pw) async{
    prefs = await SharedPreferences.getInstance();
    db.FirebaseHandle.userLogin(email,pw,context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
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
                      Text('Sign In',
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _emailCont,
                        decoration: Common.textFormFieldDecoration('Email'),
                        validator: (val){
                          var validate = RegExp(r'''^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''').hasMatch(val);
                          print(validate);
                          if(val.isEmpty){
                            return 'Email should not be empty !!';
                          }
                          else if(!validate){
                            return 'Please enter valid email !!';
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _pwCont,
                        decoration: Common.textFormFieldDecoration('Password'),
                        keyboardType: TextInputType.text,
                        maxLength: 15,
                        obscureText: true,
                        validator: (val){
                          if(val.isEmpty){
                            return 'number should not be empty !!';
                          }else{
                            if(val.length >= 6){
                              return null;
                            }
                            return 'Password should be greater than 6 character';
                          }
                        },
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        child: Text('Submit'),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                          backgroundColor: MaterialStateColor.resolveWith((states) => Common.btnColor),
                        ),
                        onPressed: (){
                          if(_formKey.currentState.validate()){

                            sendMail(_emailCont.text, _pwCont.text);
                          }else{

                          }
                        },
                      ),
                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          child: Text('Register'),
                          onTap: (){
                            print('tap');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignUp())
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

