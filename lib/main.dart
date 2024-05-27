import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ganado APP"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: dinamico(),
    );
  }

  Widget dinamico(){
    return crudCorral();
  }

  Widget crudVacas(){
    return ListView();
  }


  Widget crudCorral(){
    return ListView();
  }
}
