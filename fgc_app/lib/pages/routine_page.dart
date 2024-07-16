import 'dart:ffi';

import 'package:fgc_app/data/routines.dart';
import 'package:fgc_app/globals.dart';
import 'package:fgc_app/pages/game_page.dart';
import 'package:fgc_app/pages/home_page.dart';
import 'package:fgc_app/pages/my_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoutinePage extends StatefulWidget{
  const RoutinePage({Key? key}) : super(key: key);

  @override
  State<RoutinePage> createState() => _RoutinePage();
}

class _RoutinePage extends State<RoutinePage> {
  
  String dropdownValue='one';
  String? dropdownCharValue;
  String? dropdownActionValue;
  String? dropdownAgainstValue;
  String? dropdownAttackValue;
  int menu = 1;

  Future<List<Routine>>? _routinesFuture;
  List<Routine> _routines = [];
  
  List<Routine> _buildRoutinesList() {

    // Handle potential loading state (replace with actual error handling)
    if (_routinesFuture == null) {
      print("it was empty");
      return []; // Or show an empty list message
    }
    _routinesFuture!.then((result) {
      for (var item in result) {
        _routines.add(item);
      }
    });
    return _routines;
  }
  
  _HomePageState() {
    print('constructor, mounted: $mounted');
  }

  @override
  void initState(){
    super.initState();
    print("initState() called.");
    _routinesFuture = Routine.loadRoutines();
    _routines = _buildRoutinesList();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies() called.");
  }

  void _incrementMenu() {
    setState(() {
      menu++;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("build() called.");

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            DrawerButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.white))),
            SizedBox(width: 10,),
            Text('Inicio',
              style: TextStyle(fontFamily: 'GuiltyGear',color: Colors.white, fontSize: 30), textAlign: TextAlign.center,),
            SizedBox(width: 20,),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[850],
        child:ListView(
          children: [
            GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const GamePage()));},
              child: DrawerHeader(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(GameIcon_01_2),fit: BoxFit.cover)),
                child: Text("Juegos",style: TextStyle(fontFamily: 'GuiltyGear',color: Colors.black, fontSize: 30), textAlign: TextAlign.start,),
              ),
            ),
            ListTile(
              title: Text("Inicio",style: TextStyle(fontFamily: 'GuiltyGear',color: Colors.white, fontSize: 30)),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));},
            ),
            ListTile(
              title: Text("Rutinas",style: TextStyle(fontFamily: 'GuiltyGear',color: Colors.white, fontSize: 30)),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const RoutinePage()));},
            ),
          ],
        )
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(GG_Background_02),
            fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
              Card(margin: EdgeInsets.all(10), color: Colors.grey[850],
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        SizedBox(height: 30, width: 150,
                          child: Text('Rutina facil',
                            style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,) 
                        ),
                        SizedBox(height: 26, width: 150,
                          child: Text('Tareas pendientes',
                            style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,) 
                        ),
                        SizedBox(width: 50,),
                        PopupMenuButton(
                          iconColor: Colors.white,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: Text("Detalles"),
                              onTap: (){
                                showDialog(
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                      contentPadding: EdgeInsets.all(20),
                                      backgroundColor: Colors.grey[850],
                                      children: <Widget>[
                                        Column(mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text('',
                                                style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,) 
                                            ],
                                          ),
                                        ],
                                        ),
                                      ],
                                    ),
                                  );
                              },
                            ),
                            PopupMenuItem(
                              child: Text("Historial"),
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (context) => SimpleDialog(
                                    contentPadding: EdgeInsets.all(20),
                                    backgroundColor: Colors.grey[850],
                                    children: <Widget>[
                                      Column(mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text('Historial',
                                              style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,) 
                                          ],
                                        ),
                                      ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                  ]
                )
              ),
            
            SizedBox(height: 10,),
            GestureDetector(onTap: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  contentPadding: EdgeInsets.all(20),
                  backgroundColor: Colors.grey[850],
                  children: <Widget>[
                    Column(mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Tareas',
                            style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,) 
                        ],
                      )
                    ],
                    )
                  ]
                ),
              );
            },
              child:Card(margin: EdgeInsets.all(10), color: Colors.grey[850],
                child: const Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        SizedBox(height: 30, width: 200,
                          child: Text('Rutina Intermedia',
                            style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,) 
                        ),
                        SizedBox(height: 26, width: 150,
                          child: Text('Tareas pendientes',
                            style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,) 
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                  ]
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}