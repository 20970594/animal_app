import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fgc_app/data/picture.dart';


class PictureDatabase{
  PictureDatabase._privateConstructor();

  static final PictureDatabase instance = PictureDatabase._privateConstructor();

  static const _databaseName = 'picture_database.db';
  static const _databaseVersion = 3;

  Future<Database> get database async{
    final databasePath = await getDatabasesPath();
    print('The versions in _databaseVersion is $_databaseVersion');

    return await openDatabase(
      '$databasePath/$_databaseVersion',
      onCreate: (db, version) {
        print('The versions in version is $version');
        db.execute('''
          CREATE TABLE picture(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            url TEXT)
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion)async {
        print('The versions in $oldVersion and newVersion is $newVersion');

        for(int version = oldVersion+1;version<=newVersion;version++){
          
          switch(version){
            case 3:
              print('The version is $version and Create a new table with the desired AUTOINCREMENT column');
              await db.execute('''
                CREATE TABLE picture_new(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  url TEXT)
              ''');

              final oldData = await db.query('picture');
              for (final row in oldData) {
                await db.insert('picture_new', row);
              }

              await db.execute('DROP TABLE picture');

              await db.execute('ALTER TABLE picture_new RENAME TO picture');
              break;
              default:
                throw Exception('Unsupported upgrade version: $version');
          }
        }
      },
      version: 3,
    );
  }

  Future<void> insertPicture(Picture Picture) async{
    final database = await PictureDatabase.instance.database;
    await database.insert(
      'picture',
      Picture.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateJson()async{
    final database = await PictureDatabase.instance.database;
    final List<Map<String, dynamic>> picturesFromDatabase = await database.query(
      'picture',
      orderBy: 'id',
    );
    String jsonString =  jsonEncode(picturesFromDatabase);
    File file = File('assets/json/pictures.json');
    await file.writeAsString(jsonString);
  }

  Future<void> deleteAndReorderPictures(int id) async{
    final database = await PictureDatabase.instance.database;
    await database.delete('picture', where: 'id = ?',whereArgs: [id]);

    // Obtener todos los registros restantes ordenados por ID
    final List<Map<String, dynamic>> remainingPictures = await database.query(
      'picture',
      orderBy: 'id',
    );

    // Eliminar todos los registros restantes
    await database.delete('picture');

    // Reinserta los registros con nuevos IDs secuenciales
    int newId = 1;
    for (var picture in remainingPictures) {
      await database.insert(
        'picture',
        {'id': newId, 'url': picture['url']},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      newId++;
    }
  }
  
  Future<List<Picture>> getPictures() async{
    final database = await PictureDatabase.instance.database;
    final List<Map<String, dynamic>> maps = await database.query('picture');
    return List.generate(maps.length, (i) => Picture.fromMap(maps[i]));
  }


}

