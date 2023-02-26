
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key, required this.title});



  final String title;

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
 

  @override
  Widget build(BuildContext context) {
   
    return Container(color: Colors.pink,);
  }
}
