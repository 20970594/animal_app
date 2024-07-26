
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/*
class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}*/

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Pantalla de drag',
      theme: 
        ThemeData
        (
          primarySwatch: Colors.amber,
        ),
        home: Drag(),
    );
  }
}

class Drag extends StatefulWidget{
  Drag({super.key});

  @override

  State<Drag> createState() => _Drag();
}

class _Drag extends State<Drag> with SingleTickerProviderStateMixin { 

  Offset position = Offset(100, 100);
  late AnimationController controller;
  late Animation<double> animation;

  bool imageAttached = false;

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
      end: screenHeight - 200
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
              child: Draggable<Offset>(
                data: position,
                child: Image.network('https:\/\/images.dog.ceo\/breeds\/saluki\/n02091831_961.jpg', width: 200, height: 200),
                feedback: Image.network('https:\/\/images.dog.ceo\/breeds\/saluki\/n02091831_961.jpg', width: 200, height: 200),
                childWhenDragging: Container(),
                onDraggableCanceled: (Velocity velocity, Offset offset){
                  setState(() {
                    position = offset;
                  });
                  GravityAnimation();
                },
              ),  
            ),
            Positioned
            ( 
              bottom: 50,
              left: MediaQuery.of(context).size.width /1.2,
              child: DragTarget<Offset>(
                onWillAccept: (data){

                  ///Aqui iria el respectivo codigo cuando recibe la  imagen
                  print('Aqui se inserto la imagen');

                  return true;
                },
                onAccept:(offset){
                  setState(() {
                    imageAttached = true;
                    position = Offset(
                      MediaQuery.of(context).size.width / 2-50,
                      MediaQuery.of(context).size.height - 150);
                  });
                  activeDrop(context);
                },
                builder: (BuildContext context, List<dynamic> accepted,
                List<dynamic> rejected){
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration
                    (color: imageAttached 
                      ? Colors.green.withOpacity(0.5) 
                      : Colors.grey.withOpacity(0.5),
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text(imageAttached ? 'Attached' : 'Drop Here',
                    style: TextStyle(color: Colors.white)),),
                  ); 
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  void activeDrop(BuildContext context){
    showDialog(
      context: context, 
      builder: (BuildContext context){
          return AlertDialog(
            title: Text('Ocurrio'),
            content: Text('Imaagen adjuntada'),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                }, 
                child: Text('Cerrar'),
              ),
            ],
          );
      },
    );
  }
}


