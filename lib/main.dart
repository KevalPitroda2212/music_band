import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_band/Common.dart';
import 'package:music_band/screens/InItScreen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Band',
      theme: ThemeData(
        primarySwatch: Common.themeColor,
      ),
      debugShowCheckedModeBanner: false,
      home: InItScreen(),
    );
  }
}
