import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/collection_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive storage
  await Hive.openBox('collections'); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CollectionPage()
    );
  }
}