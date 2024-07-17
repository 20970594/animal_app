
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHome()
    );
  }
}

class MyHome extends StatelessWidget{
  const MyHome({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[850],
        body: const Center(
          child: Column()
        ),
        
      ),
    );
  }
}
