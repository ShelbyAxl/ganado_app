import 'controlador/ServiciosRemoto.dart';
import 'package:flutter/material.dart';

class Inscribir extends StatefulWidget {
  const Inscribir({super.key});

  @override
  State<Inscribir> createState() => _InscribirState();
}

class _InscribirState extends State<Inscribir> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("CREAR USUARIO"),
        centerTitle: true,
        backgroundColor: Colors.black38,
      ),
      body: ListView(
        padding: EdgeInsets.all(40),
        children: [
          TextField(
            controller: email,
            decoration: InputDecoration(labelText: "Correo: "),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: password,
            decoration: InputDecoration(labelText: "Contraseña"),
            obscureText: true,
          ),
          SizedBox(
            height: 40,
          ),
          OutlinedButton(onPressed: () {
            Autenticacion.crearUsuario(email.text, password.text).then((value) {
              if (value!=null){
                Autenticacion.cerrarSesion();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ÉXITO")));
              }
            });
          }, child: Text("Crear")),
        ],
      ),
    );
  }
}
