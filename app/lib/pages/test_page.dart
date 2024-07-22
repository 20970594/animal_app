import 'package:fgc_app/pages/show_page.dart';
import 'package:fgc_app/utils/pictureDatabase.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'home_page.dart';
import 'package:fgc_app/data/picture.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

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
    _picturesFuture = fetchImages();
    _pictures = _buildPictureList();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies()');
    super.didChangeDependencies();
  }

  Future<List<Picture>> fetchImages() async {
    final response = await http.get(Uri.parse('https://random-d.uk/api/random?type=jpg'));
    if (response.statusCode == 200) {
      final jsonString = response.body;
      final jsonStringMod = '[$jsonString]';
      print(jsonDecode(jsonStringMod));
      final List<dynamic> jsonResponse = jsonDecode(jsonStringMod) as List<dynamic>;
      return jsonResponse.map((dynamic image) => Picture.fromJson(image as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Hubo un fallo al encontrar imagenes');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text('Test'),
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
