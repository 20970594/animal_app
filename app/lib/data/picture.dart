import 'dart:convert';
import 'package:flutter/services.dart';

class Picture{
  final int? id;
  final String url;

  const Picture({
    this.id,
    required this.url
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'url': url,
    };
  }

  static Map<String, Object?> fromUrltoMap(String url) {
    return {
      'id': null,
      'url': url,
    };
  }

  static Picture fromMap(Map<String,dynamic> map){
    return Picture(
      id: map['id'] as int?,
      url: map['url'] as String,
    );
  }

  @override
  String toString(){
    return 'Picture{id: $id, url: $url';
  }



  factory Picture.fromJson(Map<String, dynamic> json){
    return Picture(
      id: json['id'] as int?,
      url: json['url'] as String,
    );
  }

  static Future<List<Picture>> loadPictures() async{
    final jsonString = await rootBundle.loadString('assets/json/pictures.json');
    final List<dynamic> jsonDecoded = jsonDecode(jsonString) as List<dynamic>;
    print("test----:$jsonDecoded");
    return jsonDecoded.map((dynamic item) => Picture.fromJson(item as Map<String, dynamic>)).toList();
  }
}
