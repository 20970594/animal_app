import 'dart:ffi';

import 'package:fgc_app/pages/my_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    print('create state');
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  
  _HomePageState() {
    print('constructor, mounted: $mounted');
  }

  @override
  void initState(){
    super.initState();
    print("initState() called.");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies() called.");
  }

  @override
  Widget build(BuildContext context) {
    print("build() called.");

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        toolbarHeight: 80,
        title: Text(''),
        automaticallyImplyLeading: false,
      ),
      body:Center(
          child: Column(
            
          ),
        ), 
    );
  }
}