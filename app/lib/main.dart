import 'package:fgc_app/data/picture.dart';
import 'package:fgc_app/pages/test_page.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'AngelineVintage',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Test(),
      routes: {
      '/detail': (context) => const Test(),
      //'/list': (context) => ListDetail(),
    },
    );
  }
}