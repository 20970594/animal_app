import 'package:flutter/material.dart';
import 'pages/my_app.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}
