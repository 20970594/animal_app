import 'package:cached_network_image/cached_network_image.dart';
import 'package:fgc_app/utils/pictureDatabase.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fgc_app/data/picture.dart';

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

  _Show(){print('constructor, mounted: $mounted');}

  @override
  void initState(){
    print("initState() called.");
    super.initState();
    _picturesFuture = PictureDatabase.instance.getPictures();
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
        title: Text('Galeria'),
      ),
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
    );
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
