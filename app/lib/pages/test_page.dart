import 'package:fgc_app/pages/show_page.dart';
import 'package:fgc_app/utils/pictureDatabase.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

import 'package:fgc_app/data/picture.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState(){
    print('createState()');
    return _Test();
  }
}

class _Test extends State<Test>{

  late Future<List<Picture>>? _picturesFuture;
  List<Picture> _pictures = [];

  _Test(){print('constructor, mounted: $mounted');}

  @override
  void initState(){
    print("initState() called.");
    super.initState();
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
    if(type==1){
      for(int i=0;i<5;i++){
        final response = await http.get(Uri.parse('https://random-d.uk/api/random?type=jpg'));
        if (response.statusCode == 200) {
        imagesList.add(jsonDecode(response.body) as dynamic);
        } else {
          throw Exception('Hubo un fallo al encontrar imagenes');
        }
      }
    }
    else if(type==2){
      String jsonString = "";
      for(int i=0;i<5;i++){
        final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
        if (response.statusCode == 200) {
        jsonString = response.body;
        jsonString=jsonString.replaceAll('message', 'url');
        imagesList.add(jsonDecode(jsonString) as dynamic);
        } else {
          throw Exception('Hubo un fallo al encontrar imagenes');
        }
      }
    }
    else if(type==3){
      String jsonString = "";
      for(int i=0;i<5;i++){
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
    }
    
    return imagesList.map((dynamic image) => Picture.fromJson(image as Map<String, dynamic>)).toList();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Test'),
      ),
      drawer: Drawer(
        backgroundColor: Colors.green[700],
        child:ListView(
          children: [
            ListTile(
              title: Text("Galeria",style: TextStyle(color: Colors.white, fontSize: 30)),
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>const Show()));},
            ),
          ],
        )
      ),
      body: Center(
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
                  print(pictures[0].url);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(pictures[0].url),
                      ElevatedButton(
                        onPressed: () {
                          _insertNewPicture(pictures[0].url);
                        },
                        child: Text('Guardar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          PictureDatabase.instance.deleteAndReorderPictures(1);
                        },
                        child: Text('reordenar'),
                      )
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
            ElevatedButton(
              onPressed: () {
                PictureDatabase.instance.updateJson();
              },
              child: Text('Guardar en archivo'),
            )
          ],
        )
      ),
    );
  }

  Future<void> _insertNewPicture(String urlFromImage) async {
    
    final picture = Picture(
      url: urlFromImage//donde deberia ir la info sacada de la API
    );
    await PictureDatabase.instance.insertPicture(picture);
    _picturesFuture = PictureDatabase.instance.getPictures(); // Refresh data
    setState(() {}); // Rebuild the UI with the updated list
  }

  List<Picture> _buildPictureList() {
    // Handle potential loading state (replace with actual error handling)
    if (_picturesFuture == null) {
      return []; // Or show an empty list message
    }
    _picturesFuture!.then((result) {
      for (var item in result) {
        _pictures.add(item);
      }
    });
    return _pictures;
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
