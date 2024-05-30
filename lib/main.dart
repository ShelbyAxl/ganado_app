import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false,));
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
        title: Text("Ganado APP", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(200, 50, 50, 1),
      ),
      body: RegistrarCorral(),
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

  Widget login(){
    final usuario = TextEditingController();
    final contrasena = TextEditingController();
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text('Iniciar sesión', style: TextStyle(fontSize: 40), textAlign: TextAlign.center,),
        SizedBox(height: 20,),
        Text("Usuario", style: TextStyle(fontSize: 25),),
        TextField(controller: usuario, decoration: InputDecoration(labelText: "Nombre de usuario"),),
        SizedBox(height: 20,),
        Text("Contraseña", style: TextStyle(fontSize: 25),),
        TextField(controller: contrasena, decoration: InputDecoration(labelText: "°°°°°°°°"), ),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: (){}, child: Text('Entrar'))
      ],
    );
  }

  Widget RegistarVaca(){
    final arete = TextEditingController();
    final raza = TextEditingController();
    final peso = TextEditingController();
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text('Registrar corral', style: TextStyle(fontSize: 30), textAlign: TextAlign.center,),
        SizedBox(height: 10,),
        Text("Número de arete", style: TextStyle(fontSize: 25),),
        TextField(controller: arete, decoration: InputDecoration(labelText: "No de arete"),),
        SizedBox(height: 10,),
        Text("Raza", style: TextStyle(fontSize: 25),),
        TextField(controller: raza, decoration: InputDecoration(labelText: "Raza de animal"),),
        SizedBox(height: 10,),
        Text("Peso", style: TextStyle(fontSize: 25),),
        TextField(controller: peso, decoration: InputDecoration(labelText: "Peso de animal"),),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: (){}, child: Text('Registrar'))
      ],
    );
  }

  Widget RegistrarCorral(){
    final arete = TextEditingController();
    final raza = TextEditingController();
    final peso = TextEditingController();
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text('Registrar corral', style: TextStyle(fontSize: 30), textAlign: TextAlign.center,),
        SizedBox(height: 10,),
        Text("ID corral", style: TextStyle(fontSize: 25),),
        TextField(controller: arete, decoration: InputDecoration(labelText: "ID corral"),),
        SizedBox(height: 10,),
        Text("ubicacion", style: TextStyle(fontSize: 25),),
        TextField(controller: raza, decoration: InputDecoration(labelText: "ubicacion"),),
        SizedBox(height: 10,),
        Text("noArete", style: TextStyle(fontSize: 25),),
        TextField(controller: peso, decoration: InputDecoration(labelText: "noArete"),),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: (){}, child: Text('Registrar'))
      ],
    );
  }
}
