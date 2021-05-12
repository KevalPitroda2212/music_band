import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_band/Common.dart';
import 'package:music_band/screens/FirebaseHandle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Booking extends StatefulWidget {
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameCont = TextEditingController();
  TextEditingController _addressCont = TextEditingController();
  TextEditingController _costCont = TextEditingController();
  TextEditingController _dateCont = TextEditingController();
  TextEditingController _numberCont = TextEditingController();
  TextEditingController _descriptionCont = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String pickDate="";
  SharedPreferences prefs;
  String email;
  String number;

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString(Common.PREF_EMAIL_KEY);
    number = prefs.getString(Common.PREF_MOBILE_NUMBER_KEY) ?? '';
    setState(() {
      _numberCont.text = number;
    });

  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        pickDate = selectedDate.toString();
        pickDate = pickDate.split(' ').first;
      });
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
        title: Text('Booking Band'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20,),
                TextFormField(
                  controller: _nameCont,
                  decoration: Common.textFormFieldDecoration('Name'),
                  validator: (val){
                    if(val.isEmpty){
                      return 'Name should not be empty !!';
                    }else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _numberCont,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: Common.textFormFieldDecoration('Number'),
                  validator: (val){
                    if(val.isEmpty){
                      return 'Number should not be empty !!';
                    }else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _addressCont,
                  maxLines: 5,
                  decoration: Common.textFormFieldDecoration('Address'),
                  validator: (val){
                    if(val.isEmpty){
                      return 'Address should not be empty !!';
                    }else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _costCont,
                  keyboardType: TextInputType.number,
                  decoration: Common.textFormFieldDecoration('Estimated Price'),
                  validator: (val){
                    if(val.isEmpty){
                      return 'Estimated Price should not be empty !!';
                    }else{
                      return null;
                    }
                  },
                ),
                SizedBox(height: 20,),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Date : ${pickDate}'),
                      IconButton(icon: Icon(Icons.date_range), onPressed: (){
                        _selectDate(context);
                      })
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: _descriptionCont,
                  maxLines: 5,
                  decoration: Common.textFormFieldDecoration('Description'),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  child: Text('Submit'),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                    backgroundColor: MaterialStateColor.resolveWith((states) => Common.btnColor),
                  ),
                  onPressed: ()async{
                    if(_formKey.currentState.validate()){
                      Map<String, dynamic> data = {
                        'name':_nameCont.text,
                        'number' : _numberCont.text,
                        'address' : _addressCont.text,
                        'cost' : _costCont.text,
                        'date' : pickDate,
                        'description' : _descriptionCont.text,
                        'email' : email,
                      };
                      FirebaseHandle.userBooking(data, context);
                    }else{

                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
