import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_band/Common.dart';
import 'package:music_band/screens/HomeScreen.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:music_band/screens/FirebaseHandle.dart' as db;
import 'package:music_band/screens/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatelessWidget {
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
  TextEditingController _numberCont = TextEditingController();
  TextEditingController _pwCont = TextEditingController();
  SharedPreferences prefs;

  sendMail(String email, String number, String pw) async{
    prefs = await SharedPreferences.getInstance();
    db.FirebaseHandle.userRegister(email,number, pw,context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    alignment: Alignment.center,
                    child: Text(
                      'Music Band',
                      style: TextStyle(
                          color: Colors.teal,
                          fontSize: 35,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Sign Up',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(height: 25,),
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
                          controller: _numberCont,
                          decoration: Common.textFormFieldDecoration('Mobile number'),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          validator: (val){
                            if(val.isEmpty){
                              return 'number should not be empty !!';
                            }else{
                              if(val.length == 10){
                                return null;
                              }
                              return 'Mobile number should be 10 digit';
                            }
                          },
                        ),
                        SizedBox(height: 10,),
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

                              sendMail(_emailCont.text, _numberCont.text,_pwCont.text);
                            }else{

                            }
                          },
                        ),
                        SizedBox(height: 20,),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.bottomRight,
                          child: GestureDetector(
                            child: Text('Login'),
                            onTap: (){
                              print('tap');
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignIn())
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
      ),
    );
  }
}

