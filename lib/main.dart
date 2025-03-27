import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gas/controller/data_controller.dart';
import 'package:gas/controller/date_controller.dart';
import 'package:gas/firebase_options.dart';
import 'package:gas/view/home/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataController()),
        ChangeNotifierProvider(create: (context) => DateController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: const Color.fromARGB(255, 242, 205, 96)),
      home: HomeScreen(),
    );
  }
}
