import 'dart:convert';

import 'package:flutter/services.dart';

class Routine{
  final int? id;
  final String difficulty;
  final String objective1;
  final String instructions1;
  final String objective2;
  final String instructions2;
  final String objective3;
  final String instructions3;
  //final String urlLogo;

const Routine({
    this.id,
    required this.difficulty,
    required this.objective1,
    required this.instructions1,
    required this.objective2,
    required this.instructions2,
    required this.objective3,
    required this.instructions3,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'difficulty': difficulty,
      'objective1': objective1,
      'instructions1': instructions1,
      'objective2': objective2,
      'instructions2': instructions2,
      'objective3': objective3,
      'instructions3': instructions3,
    };
  }

  static Routine fromMap(Map<String, dynamic> map) {
    return Routine(
      id: map['id'] as int, // Cast to int for type safety
      difficulty: map['difficulty'] as String, // Cast to String for type safety
      objective1: map['objective1'] as String, 
      instructions1: map['instructions1'] as String, 
      objective2: map['objective2'] as String,
      instructions2: map['instructions2'] as String,
      objective3: map['objective3'] as String,
      instructions3: map['instructions3'] as String,
    );
  }

  @override
  String toString() {
    return 'Routine{id: $id, difficulty: $difficulty, objective1: $objective1, instructions1: $instructions1, objective2: $objective2, instructions2: $instructions2, objective3: $objective3, instructions3: $instructions3}';
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as int, // Cast to int for type safety
      difficulty: json['difficulty'] as String, // Cast to String for type safety
      objective1: json['objective1'] as String, 
      instructions1: json['instructions1'] as String, 
      objective2: json['objective2'] as String,
      instructions2: json['instructions2'] as String,
      objective3: json['objective3'] as String,
      instructions3: json['instructions3'] as String,
    );
  }

  static Future<List<Routine>> loadRoutines() async {
    final jsonString = await rootBundle.loadString('assets/json/routines.json');
    final List<dynamic> jsonDecoded = jsonDecode(jsonString) as List<dynamic>;
    print("test----:"+jsonDecoded.toString());
    return jsonDecoded.map((dynamic item) => Routine.fromJson(item as Map<String, dynamic>)).toList();
  }
}