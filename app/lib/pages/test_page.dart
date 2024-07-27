import 'package:fgc_app/pages/show_page.dart';
import 'package:fgc_app/utils/pictureDatabase.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

import 'package:fgc_app/data/picture.dart';
import 'package:list_wheel_scroll_view_nls/list_wheel_scroll_view_nls.dart';

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io';

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

  //_Test(){print('constructor, mounted: $mounted');}


  void initState(){
    print("initState() called.");
    super.initState();
    //LoadLocalJson();
    //_picturesFuture = Picture.loadPictures();
    _picturesFuture = fetchImages(3);
    _pictures = _buildPictureList();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies()');
    super.didChangeDependencies();
  }

  Future<List<Picture>> fetchImages(int type) async {// 1:patos / 2:perros / 3:gatos
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
        title: Text('Test'),
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
              Text('hola'),
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
                          width: 300,
                          height:300,
                          child: ListWheelScrollViewX(
                            scrollDirection: Axis.horizontal,
                            physics: FixedExtentScrollPhysics(),
                            itemExtent: 250,//pictures.length.toDouble(),
                            children: values.map((value)=>buildCustomWidget(value)).toList()/*[
                              Container(
                                width: 250,
                                height: 250,
                                alignment: Alignment.center,
                                child: Image.network(pictures[0].url,fit: BoxFit.contain),
                              ),
                              Container(
                                width: 250,
                                height: 250,
                                alignment: Alignment.center,
                                /*decoration: const BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.rectangle
                                ),*/
                                child: Image.network(pictures[1].url,fit: BoxFit.contain),
                              )
                            ],*/
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _insertNewPicture(pictures[0].url);
                            //_storageInLocal(pictures[0]);
                          },
                          child: Text('Guardar'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            PictureDatabase.instance.deleteAndReorderPictures(1);
                          },
                          child: Text('reordenar'),
                        ),
                        /*ElevatedButton(
                          onPressed: () {
                            SaveOnLocalJson(pictures);
                          },
                          child: Text('Guardar en archivo'),
                        )*/
                      ],
                    );
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => Show()));
                },
                child: Text('Mostrar'),
              ),
              
            ],
          )
        ),
      ),
    );
  }

  /*Future<void> _storageInLocal(Picture image) async{
    var _var = await http.get(Uri.parse(image.url));
    Directory directory = await getApplicationDocumentsDirectory();
    File file = new File(path.join(directory.path, path.basename(image.url)));
    await file.writeAsBytes(_var.bodyBytes);
  }*/

  Future<void> _insertNewPicture(String urlFromImage) async {
    
    final picture = Picture(
      url: urlFromImage
    );
    await PictureDatabase.instance.insertPicture(picture);
    _picturesFuture = PictureDatabase.instance.getPictures();
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

  /*Future<void> LoadLocalJson()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime')??true;
    if(isFirstTime){
      String jsonString = await rootBundle.loadString('assets/json/pictures.json');
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String thisPath = path.join(documentsDirectory.path, 'pictures.json');

      File file = File(thisPath);
      await file.writeAsString(jsonString);
      await prefs.setBool('isFirstTime', false);
    }
  }*/

  /*Future<void> SaveOnLocalJson(List<Picture> pictureList)async{
    String? _localPicturePath;
    final connectivityResult = await Connectivity().checkConnectivity();
    final directory = await getApplicationDocumentsDirectory();
    if(connectivityResult!=ConnectivityResult.none){
      for(Picture picture in pictureList){
        final filePath = join(directory.path, 'image');
        if(!File(filePath).existsSync())
        {
          try {
            final response = await Dio().download(picture.url, filePath);

            if (response.statusCode == 200) {
              setState(() {
                _localPicturePath = filePath;
              });
            }
          } catch (e) {
              print('Error downloading image: $e');
          }
        }
      }
    }

    /*Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String thisPath = path.join(documentsDirectory.path, 'pictures.json');

    File file = File(thisPath);
    PictureDatabase.instance.updateJson(file);*/
  }*/

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

