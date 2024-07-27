import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fgc_app/utils/pictureDatabase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'home_page.dart';
import 'package:fgc_app/data/picture.dart';
import 'package:path_provider/path_provider.dart';

class Show extends StatefulWidget {
  const Show({super.key});

  @override
  State<Show> createState(){
    print('createState()');
    return _Show();
  }
}

class _Show extends State<Show>{

  Future<List<Picture>>? _picturesFuture;
  //Future<List<String>>? _pathsFuture;

  _Show(){print('constructor, mounted: $mounted');}

  @override
  void initState(){
    print("initState() called.");
    super.initState();
    _picturesFuture = PictureDatabase.instance.getPictures();
    //_pathsFuture=_getPictures();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies()');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('Show'),
      ),
      /*body: Center(
        child: FutureBuilder<String>(
          future: _picturesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                // Mostrar la imagen desde el archivo
                return Image.file(File(snapshot.data!));
              } else {
                return Text('No image found');
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),*/
      body: FutureBuilder<List<Picture>>(
          future: _picturesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Hubo un fallo al encontrar imagenes'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print('No images found');
              return Center(child: Text('No se encontraron imagenes'));
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data![index].url,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
                },
              );
            }
          },
        ),
        /*body: FutureBuilder<List<String>>(
          future: _pathsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(child: Text('Hubo un fallo al encontrar imagenes'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              print('No images found');
              return Center(child: Text('No se encontraron imagenes'));
            } else {
              final paths = snapshot.data!;
              return Image.file(File(paths[0]));
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: snapshot.data![index].url,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  );
                },
              );
            }
          },
        ),*/
    );
  }
  /*Future<List<String>> _getPictures() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String pathJson = join(documentsDirectory.path, 'pictures.json');
  File file = File(pathJson);
  String jsonString = file.readAsStringSync();
  print(file.readAsStringSync());

  List<dynamic> list= jsonDecode(jsonString);
  List<Map<String,dynamic>> jsonList =[];
  List<String> pathList = [];
  for(Map<String,dynamic> json in list){
    jsonList.add(json as Map<String,dynamic>);
  }
  for(Map<String,dynamic> json in jsonList){
    //String a =json['url'];
    pathList.add(join(documentsDirectory.path, 'image'));
  }
  print('Lista:$pathList');
  return pathList;
}*/

/*Future<String> getImageFilePath() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, 'image.jpg');
  return path;
}*/

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
