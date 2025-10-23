import 'package:flutter/material.dart';
import 'atelier1.dart'; // ou 'atelier2.dart' pour tester l'autre atelier
import 'atelier2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Material 3',
      theme: ThemeData(useMaterial3: true),
      //home: const ProfilePageM3(), // ou ProductListPageM3()//
      home: const ProductListPageM3(),
    );
  }
}
