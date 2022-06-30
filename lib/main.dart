
import 'package:flutter/material.dart';
import 'package:gpt3dsc/screens/splash.dart';


const OPENAI_KEY = String.fromEnvironment("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");


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: Colors.white,

      ),

      home: SplashScreen(),
    );
  }
}




