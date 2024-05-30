import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ganado_app/inscribir.dart';
import 'controlador/DB.dart';
import 'firebase_options.dart';
import 'controlador/ServiciosRemoto.dart';
import 'modelo/vaca.dart';
import 'modelo/corral.dart';

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
  int indice = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ganado APP", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(200, 50, 50, 1),
      ),
      body: dinamico(indice),
    );
  }


  Widget dinamico(int indice){
    return indice == 0 ? login() : RegistarVaca();
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
        ElevatedButton(onPressed: (){

          Autenticacion.autenticarUsuario(usuario.text, contrasena.text)
              .then((value) {

            if(value!=null){
              setState(() {
                indice = 1;
              });
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
            }
          });
        }, child: Text('Entrar')),
        SizedBox(
          height: 40,
        ),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (content) {
                return Inscribir();
              }));
            },
            child: Text("Inscribir usuario")),
        SizedBox(
          height: 50,
        )
      ],
    );
  }

  Widget RegistarVaca(){
    final areteController = TextEditingController();
    final razaController = TextEditingController();
    final pesoController = TextEditingController();
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text(
          'Registrar vaca',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Número de arete",
          style: TextStyle(fontSize: 25),
        ),
        TextField(
          controller: areteController,
          decoration: InputDecoration(labelText: "No de arete"),
        ),
        SizedBox(height: 10),
        Text(
          "Raza",
          style: TextStyle(fontSize: 25),
        ),
        TextField(
          controller: razaController,
          decoration: InputDecoration(labelText: "Raza de animal"),
        ),
        SizedBox(height: 10),
        Text(
          "Peso",
          style: TextStyle(fontSize: 25),
        ),
        TextField(
          controller: pesoController,
          decoration: InputDecoration(labelText: "Peso de animal"),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            String arete = areteController.text;
            String raza = razaController.text;
            double peso = double.tryParse(pesoController.text) ?? 0.0;

            Vaca nuevaVaca = Vaca(
              noArete: arete,
              raza: raza,
              peso: peso,
            );

            await DB.insertarVaca(nuevaVaca);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Vaca registrada exitosamente'),
            ));

            // Clear the text fields
            areteController.clear();
            razaController.clear();
            pesoController.clear();
          },
          child: Text('Registrar'),
        ),
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
