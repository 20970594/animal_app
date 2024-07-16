import 'package:fgc_app/globals.dart';
import 'package:fgc_app/pages/routine_page.dart';
import 'package:fgc_app/pages/my_app.dart';
import 'package:fgc_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget{
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  
  String dropdownValue = 'one';
  int Menu = 1;

  void _incrementMenu() {
    setState(() {
      Menu++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          color: Colors.grey[850],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 20,),
                GestureDetector(
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        contentPadding: EdgeInsets.all(10),
                        backgroundColor: Colors.grey[850],
                        children: <Widget>[
                          Column(mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('Año de salida: 2020\nJuego de lucha en 2D, Anime, Arcade, Multijugador\nDescripción: «GUILTY GEAR -STRIVE-» es el último título de la aclamada franquicia de juegos de lucha de Guilty Gear. Creado por Daisuke Ishiwatari y desarrollado por Arc System Works, «GUILTY GEAR -STRIVE-» mantiene la reputación de la serie gracias a sus revolucionarios gráficos híbridos 2D/3D con sombreado de celdas y su intensa y atractiva jugabilidad.\nPágina web: https://es.bandainamcoent.eu/guilty-gear/guilty-gear-strive\nPuntuación: 85',
                              style: TextStyle(color: Colors.white, fontSize: 18),textAlign: TextAlign.start),
                            ElevatedButton(onPressed: (){}, child: Text("Activar",style: TextStyle(color: Colors.black, fontSize: 20),textAlign: TextAlign.start))
                          ],
                          )
                        ]
                      ),
                    );
                  },
                  child:Image(image: AssetImage(GameIcon_01_2),width: 180, height: 180,)
                ),
                SizedBox(width: 20,),
                GestureDetector(
                  onTap: (){},
                  child:SizedBox(width: 180, height: 180,
                    child: Image(image: AssetImage(GameIcon_02),width: 180, height: 180,)),
                )
              ]
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 20,),
                GestureDetector(
                  onTap: (){},
                  child:SizedBox(width: 180, height: 180,
                    child: Image(image: AssetImage(GameIcon_03),width: 180, height: 180,)),
                ),
                SizedBox(width: 40,),
                GestureDetector(
                  onTap: (){},
                  child:SizedBox(width: 150, height: 150,
                    child: Image(image: AssetImage(GameIcon_04),width: 150, height: 150,)),
                )
              ]
            ),
          ],
        )
      ),
    );
  }
}