import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/collections.dart';
import 'package:flutter_application_1/models/notes.dart';
import 'package:flutter_application_1/models/transfers.dart';
import 'package:flutter_application_1/utils/auth/auth_gate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'themes/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(CollectionAdapter());
  Hive.registerAdapter(TransferAdapter());
  Hive.registerAdapter(NoteAdapter());

  await Hive.openBox<Collection>('collections');
  await Hive.openBox<Transfer>('transfers');
  await Hive.openBox<Note>('notes');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthGate(),
    );
  }
}
