import 'package:fgc_app/pages/show_page.dart';
import 'package:fgc_app/utils/pictureDatabase.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:fgc_app/data/picture.dart';
import 'package:list_wheel_scroll_view_nls/list_wheel_scroll_view_nls.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'AngelineVintage',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Test(),
      /*routes: {
      //'/detail': (context) => const Test(),
      //'/list': (context) => ListDetail(),
    },*/
    );
  }
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState(){
    print('createState()');
    return _Test();
  }
}

class _Test extends State<Test> with SingleTickerProviderStateMixin{
  
  late Future<List<Picture>>? _picturesFuture;
  List<Picture> _pictures = [];
  int _selected=0;

  //_Test(){print('constructor, mounted: $mounted');}


  void initState(){
    print("initState() called.");
    super.initState();
    //LoadLocalJson();
    //_picturesFuture = Picture.loadPictures();
    _picturesFuture = fetchImages();
    _pictures = _buildPictureList();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies()');
    super.didChangeDependencies();
  }

  Future<List<Picture>> fetchImages() async {// 1:patos / 2:perros / 3:gatos
    List<dynamic> imagesList = [];
      for(int i=0;i<10;i++){
        final response = await http.get(Uri.parse('https://random-d.uk/api/random?type=jpg'));
        if (response.statusCode == 200) {
        imagesList.add(jsonDecode(response.body) as dynamic);
        } else {
          throw Exception('Hubo un fallo al encontrar imagenes');
        }
      }
      String jsonString = "";
      for(int i=0;i<10;i++){
        final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
        if (response.statusCode == 200) {
        jsonString = response.body;
        jsonString=jsonString.replaceAll('message', 'url');
        imagesList.add(jsonDecode(jsonString) as dynamic);
        } else {
          throw Exception('Hubo un fallo al encontrar imagenes');
        }
      }
      //puede dar error aparentemente
      jsonString = "";
      for(int i=0;i<10;i++){
        final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));
        if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        jsonString = jsonResponse[0]['url'];
        jsonString='{"url":"$jsonString"}';
        imagesList.add(jsonDecode(jsonString) as dynamic);
        } else {
          throw Exception('Hubo un fallo al encontrar imagenes');
        }
      }
      imagesList.shuffle();
    return imagesList.map((dynamic image) => Picture.fromJson(image as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        title: Row(
          children: [
            Text('Animal Roulette'),
            SizedBox(width: 50,),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context)=> const AboutDialog(
                    applicationIcon: SizedBox(width: 50, height: 50,child:Image(image: AssetImage('assets/images/appLogo.png'))),
                    applicationName: 'Animal Roulette',
                    applicationVersion: 'version 1.0.0',
                    children: [
                      Text('Equipo:\nJosé Castillo\nDiego Ugarte\nIgnacio Silva \n \n Descripción: \n \n Esta aplicación te deja ver y guardar imagenes de gatos, perros y patos aleatorias. Esto gracias a que cada imagen es cargda desde distintas API.')
                    ],
                  )
                );
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: Image(image: AssetImage('assets/images/info_icon.png')),
              ),
            )
          ],
        ),
      ),
      
      drawer: Drawer(
        backgroundColor: Colors.green[400],
        child:ListView(
          children: [
            ListTile(
              title: Text("Galeria",style: TextStyle(color: Colors.black87, fontSize: 30)),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Show()));},
            ),
          ],
        )
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover
          ),
        ),
        
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<List<Picture>>(
                future: _picturesFuture,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  }
                  else{
                    final pictures = snapshot.data!;
                    final List<String> values = List<String>.filled(pictures.length,'',growable: false);
                    for(int i = 0;i<pictures.length;i++){
                      values[i]=pictures[i].url;
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        //Image.network(pictures[0].url),
                        SizedBox(
                          width: 400,
                          height:400,
                          child: ListWheelScrollViewX(
                            scrollDirection: Axis.horizontal,
                            physics: FixedExtentScrollPhysics(),
                            itemExtent: 350,
                            children: values.map((value)=>buildCustomWidget(value)).toList(),
                            onSelectedItemChanged: (value) => _selected=value,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: GestureDetector(
                                onTap: () {
                                  _insertNewPicture(pictures[_selected].url);
                                },
                                child: Image(image: AssetImage('assets/images/save_icon.png'),fit: BoxFit.contain,)
                              )
                            ),
                            SizedBox(width: 20,),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: GestureDetector(
                                onTap: () {
                                  SaveOnLocal(pictures[_selected]);
                                },
                                child: Image(image: AssetImage('assets/images/download_icon.png'),fit: BoxFit.contain,)
                              )
                            ),
                            SizedBox(width: 20,),
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: GestureDetector(
                                onTap: () {
                                  _reloadList();
                                },
                                child: Image(image: AssetImage('assets/images/reload_icon.png'),fit: BoxFit.contain,)
                              )
                            ),
                          ],
                        )
                      ],
                    );
                  }
                },
              ),
            ],
          )
        ),
      ),
    );
  }

  Future<void> _reloadList() async {
    _picturesFuture = fetchImages();
    setState(() {});
  }

  Future<void> _insertNewPicture(String urlFromImage) async {
    
    final picture = Picture(
      url: urlFromImage
    );
    await PictureDatabase.instance.insertPicture(picture);
    setState(() {});
  }

  List<Picture> _buildPictureList() {
    if (_picturesFuture == null) {
      return [];
    }
    _picturesFuture!.then((result) {
      for (var item in result) {
        _pictures.add(item);
      }
    });
    return _pictures;
  }

  Future<void> SaveOnLocal(Picture picture)async{
    await GallerySaver.saveImage(picture.url, toDcim: true);
  }

  Widget buildCustomWidget(String value) {
    return Container(
      width: 250,
      height: 250,
      alignment: Alignment.center,
      child: Image.network(value,fit: BoxFit.contain),
    );
  }

  @override
  void didUpdateWidget(covariant Test oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget , mounted: $mounted');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('deactivate, mounted: $mounted');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose, mounted: $mounted');
  }

  @override
  void reassemble() {
    super.reassemble();
    print('reassemble, mounted: $mounted');
  }
}

