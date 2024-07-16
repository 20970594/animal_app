
import 'package:fgc_app/globals.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome()
    );
  }
}

class MyHome extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[850],
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: 50,
                height: 200,
              ),
              const SizedBox(
                width: 250,
                height: 80,
                child: Image(width: 500,height: 250,image: AssetImage(AppIcon)),
              ),
              const SizedBox(
                height: 20,
                ),
              SizedBox(
                width: 380,
                height: 100,
                child: Text('¿Es tu primera vez usando FGC?\nPor favor escoge un juego y una dificultad',
                  style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,)
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  InkWell(
                    splashColor: Colors.grey,
                    onTap: () {},
                    child: Ink.image(
                      height: 100,width: 100,
                      image: AssetImage(GameIcon_01_2),
                      fit: BoxFit.cover
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    splashColor: Colors.grey,
                    onTap: () {},
                    child: Ink.image(
                      height: 60,width: 100,
                      image: AssetImage(GameIcon_02),
                      fit: BoxFit.cover
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    splashColor: Colors.grey,
                    onTap: () {},
                    child: Ink.image(
                      height: 70,width: 100,
                      image: AssetImage(GameIcon_03),
                      fit: BoxFit.cover
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    splashColor: Colors.grey,
                    onTap: () {},
                    child: Ink.image(
                      height: 100,width: 100,
                      image: AssetImage(GameIcon_04),
                      fit: BoxFit.cover
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Rutina facil',style: TextStyle(fontSize: 20),),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 230,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Rutina Intermedia',style: TextStyle(fontSize: 20),),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Rutina Dificil',style: TextStyle(fontSize: 20),),
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              SizedBox(
                width: 170,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));},
                  child: const Text('Continuar',style: TextStyle(fontSize: 20),),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('Puedes cambiar estas opciones cuando gustes',
                  style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,)     
            ],
          ),
        ),
        
      ),
    );
  }
}
