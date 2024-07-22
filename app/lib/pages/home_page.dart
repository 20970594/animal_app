//import 'dart:ffi';

//import 'package:fgc_app/pages/my_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//ignacio
import 'package:flutter/physics.dart';
//

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    print('create state');
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  
  _HomePageState() {
    print('constructor, mounted: $mounted');
  }

// ignacio
  late AnimationController _controller;
  late SpringSimulation _simulation;
//

  @override
  void initState(){
    super.initState();
    print("initState() called.");


//ignacio
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: double.infinity,
    );
    _simulation = SpringSimulation(
      SpringDescription(mass: 0.5, stiffness: 100, damping: 10),
      0,
      300,
      0
    );
    _controller.animateWith(_simulation);

//

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
        backgroundColor: Colors.grey[850],
        body: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child){
            return Transform.translate
            (
              offset: Offset(150, _controller.value),
              child: Container
              (
                width: 100,
                height: 100,
                decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              ),
            );
          }
        )


    );
  }
}