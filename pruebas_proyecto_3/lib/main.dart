/*import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pruebas_proyecto_3/models/Gif.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<List<Gif>> _listadoGifs;

  Future<List<Gif>> _getGifs() async{
    final response = await http.get("https://api.giphy.com/v1/gifs/trending?api_key=V5yKGZczSur3M4gDzwdaKmnGccnRPXmg&limit=10&offset=0&rating=g&bundle=messaging_non_clips" as Uri);
  
    if(response.statusCode==200){
      print(response.body);
    } else{
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}*/


/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pruebas_proyecto_3/models/Gif.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Gif>> _listadoGifs;

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=V5yKGZczSur3M4gDzwdaKmnGccnRPXmg&limit=10&offset=0&rating=g&bundle=messaging_non_clips"));
  
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Gif> gifs = [];
      for (var item in jsonData['data']) {
        gifs.add(Gif(item['title'], item['images']['original']['url']));
      }
      return gifs;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: FutureBuilder<List<Gif>>(
          future: _listadoGifs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.map((gif) {
                  return ListTile(
                    title: Text(gif.name),
                    leading: Image.network(gif.url),
                  );
                }).toList(),
              );
            } else {
              return const Center(child: Text('No data'));
            }
          },
        ),
      ),
    );
  }
}*/

/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:pruebas_proyecto_3/models/Gif.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(ImageGridPage());

class ImageGridPage extends StatefulWidget {
  @override
  _ImageGridPageState createState() => _ImageGridPageState();
}

class _ImageGridPageState extends State<ImageGridPage> {
  late Future<List<ImageModel>> futureImages;

  Future<List<ImageModel>> fetchImages() async {
  final response = await http.get(Uri.parse('https://dog.ceo/api/breed/hound/afghan/images/random'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((image) => ImageModel.fromJson(image)).toList();
  } else {
    throw Exception('Failed to load images');
  }
}

  @override
  void initState() {
    super.initState();
    futureImages = fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Grid'),
      ),
      body: FutureBuilder<List<ImageModel>>(
        future: futureImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load images'));
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
    );
  }
}*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pruebas_proyecto_3/models/Gif.dart';

class ImageGridPage extends StatefulWidget {
  @override
  _ImageGridPageState createState() => _ImageGridPageState();
}

class _ImageGridPageState extends State<ImageGridPage> {
  late Future<List<ImageModel>> futureImages;

  @override
  void initState() {
    super.initState();
    futureImages = fetchImages();
  }

  Future<List<ImageModel>> fetchImages() async {
    final response = await http.get(Uri.parse('https://dog.ceo/api/breed/hound/images'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> imagesList = jsonResponse['message'];
      return imagesList.map((image) => ImageModel.fromJson(image as String)).toList();
    } else {
      throw Exception('Hubo un fallo al encontrar imagenes');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Grid'),
      ),
      body: FutureBuilder<List<ImageModel>>(
        future: futureImages,
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ImageGridPage(),
  ));
}