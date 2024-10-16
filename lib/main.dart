import 'package:culinfo/controller/Database.dart';
import 'package:culinfo/pages/home/home.dart';
import 'package:culinfo/pages/splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDatabase();
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kulinfo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splashscreen',
      routes: {
        '/splashscreen': (context) => const SplashScreenPage(),
        '/home':(context) => const HomePage(),
      },
    );
  }
}
