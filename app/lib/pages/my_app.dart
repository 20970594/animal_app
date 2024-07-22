
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}



class _MyApp extends State<MyApp> with SingleTickerProviderStateMixin { 

  Offset position = Offset(100, 100);
  late AnimationController controller;
  late Animation<double> animation;

  void initState(){
    super.initState();
    print("initState() called.");

    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    controller.addListener(() {
      setState(() {
        position = Offset(position.dx, animation.value);
      });
    });
  }

  void GravityAnimation(){
    final screenHeight = MediaQuery.of(context).size.height;
    animation = Tween<double>(
      begin: position.dy, 
      end: screenHeight - 100
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    controller.forward(from: 0.0);
  }


  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Pantalla de Drag'),),
        body: Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Draggable(
                child: Image.network('https:\/\/images.dog.ceo\/breeds\/saluki\/n02091831_961.jpg', width: 100, height: 100),
                feedback: Image.network('https:\/\/images.dog.ceo\/breeds\/saluki\/n02091831_961.jpg', width: 100, height: 100),
                childWhenDragging: Container(),
                onDraggableCanceled: (Velocity velocity, Offset offset){
                  setState(() {
                    position = offset;
                  });
                  GravityAnimation();
                },
              )
            )

          ],

          
        ),
      ),
    );
  }
}
