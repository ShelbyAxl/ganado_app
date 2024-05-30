import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ganado_app/controlador/DB.dart';
import 'package:ganado_app/inscribir.dart';
import 'package:ganado_app/modelo/vaca.dart';
import 'firebase_options.dart';
import 'controlador/ServiciosRemoto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _indexCuerpo = 0;
  int _indexMenu = 0;
  int _indexNav = 0;
  List<Vaca> vacas = [];

  @override
  Widget build(BuildContext context) {
    return cuerpo();
  }

  Widget cuerpo() {
    switch (_indexCuerpo) {
      case 1: return inicio();
      default: return login();
    }
  }

  Widget inicio() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ganado APP'),
      ),
      body: dinamico(),
      drawer: menu(),
      bottomNavigationBar: navegacion(),
    );
  }

  Widget menu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  child: InkWell(
                      child: Image.asset('assets/vaca.png', height: 50)),
                ),
                Text(
                  'Ganado APP',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  '(C) TecNM Campus Tepic',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            decoration: BoxDecoration(color: Color.fromRGBO(0, 53, 104, 1)),
          ),
          SizedBox(height: 10,),
          itemDrawer(0, Icons.home, 'INICIO'),
          itemDrawer(1, Icons.person, 'REGISTROS'),
          itemDrawer(2, Icons.book, 'SALIR'),
        ],
      ),
    );
  }

  Widget itemDrawer(int i, IconData icono, String texto) {
    return ListTile(
      onTap: () {
        setState(() {
          i < 2 ? _indexMenu = i : _indexCuerpo = 2;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [
          Expanded(child: Icon(icono)),
          Expanded(
            child: Text(texto),
            flex: 2,
          )
        ],
      ),
    );
  }

  Widget navegacion() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'VACAS',
            backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
        BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'CORRAL',
            backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
      ],
      currentIndex: _indexNav,
      onTap: (index) {
        setState(() {
          _indexNav = index;
        });
      },
      backgroundColor: Color.fromRGBO(0, 11, 23, 1),
      selectedItemColor: Color.fromRGBO(103, 123, 155, 1),
      unselectedItemColor: Color.fromRGBO(255, 237, 220, 1),
    );
  }

  Widget dinamico() {
    switch(_indexMenu){
      case 0: switch(_indexNav){
        case 1: return RegistarVaca();
        default: return RegistrarCorral();
      }
      case 1: switch(_indexNav){
        case 1: return RegistarVaca();
        default: return RegistrarCorral();
      }
      default: return RegistarVaca();
    }
  }

  Widget login() {
    final usuario = TextEditingController();
    final contrasena = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Ganado APP'),
      ),
      body: ListView(
        padding: EdgeInsets.all(50),
        children: [
          Text(
            'Iniciar sesión',
            style: TextStyle(fontSize: 40),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Usuario",
            style: TextStyle(fontSize: 25),
          ),
          TextField(
            controller: usuario,
            decoration: InputDecoration(labelText: "Nombre de usuario"),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Contraseña",
            style: TextStyle(fontSize: 25),
          ),
          TextField(
            controller: contrasena,
            decoration: InputDecoration(labelText: "°°°°°°°°"),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () {
                Autenticacion.autenticarUsuario(usuario.text, contrasena.text)
                    .then((value) {
                  if (value != null) {
                    setState(() {
                      _indexCuerpo = 1;
                      _indexMenu = 0;
                      _indexNav = 0;
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("Error")));
                  }
                });
              },
              child: Text('Entrar')),
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
      ),
    );
  }

  Widget RegistarVaca() {
    final areteController = TextEditingController();
    final razaController = TextEditingController();
    final pesoController = TextEditingController();

    void _limpiarCampos() {
      areteController.clear();
      razaController.clear();
      pesoController.clear();
    }

    void dispose() {
      areteController.dispose();
      razaController.dispose();
      pesoController.dispose();
      super.dispose();
    }

    Future<void> _cargarVacas() async {
      List<Vaca> vacasCargadas = await DB.mostrarTodasVacas();
      setState(() {
        vacas = vacasCargadas;
      });
    }

    Future<void> _registrarVaca() async {
      String arete = areteController.text;
      String raza = razaController.text;
      double peso = double.tryParse(pesoController.text) ?? 0.0;

      Vaca nuevaVaca = Vaca(
        noArete: arete,
        raza: raza,
        peso: peso,
      );

      FirebaseFirestore baseRemota = FirebaseFirestore.instance;

      baseRemota.collection("ganadoApp").add({
        'noArete' : areteController.text,
        'raza' : razaController.text,
        'peso' : pesoController.text
      }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se insertó en la nube"))));

      await DB.insertarVaca(nuevaVaca);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Vaca registrada exitosamente'),
      ));
      _limpiarCampos();
      _cargarVacas();
    }



    Future<void> _actualizarVaca(String noArete) async {
      String raza = razaController.text;
      double peso = double.tryParse(pesoController.text) ?? 0.0;

      Vaca vacaActualizada = Vaca(
        noArete: noArete,
        raza: raza,
        peso: peso,
      );

      await DB.actualizarVaca(vacaActualizada);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Vaca actualizada exitosamente'),
      ));
      _limpiarCampos();
      _cargarVacas();
    }

    Future<void> _eliminarVaca(String noArete) async {
      await DB.eliminarVaca(noArete);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Vaca eliminada exitosamente'),
      ));
      _cargarVacas();
    }

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
          onPressed: _registrarVaca,
          child: Text('Registrar'),
        ),
        SizedBox(height: 20),
        Text(
          'Lista de Vacas',
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: vacas.length,
          itemBuilder: (context, index) {
            Vaca vaca = vacas[index];
            return ListTile(
              title: Text(vaca.noArete),
              subtitle: Text('Raza: ${vaca.raza}, Peso: ${vaca.peso}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      areteController.text = vaca.noArete;
                      razaController.text = vaca.raza;
                      pesoController.text = vaca.peso.toString();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _eliminarVaca(vaca.noArete);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (areteController.text.isNotEmpty) {
              _actualizarVaca(areteController.text);
            }
          },
          child: Text('Actualizar'),
        ),
      ],
    );
  }

  Widget RegistrarCorral() {
    final arete = TextEditingController();
    final raza = TextEditingController();
    final peso = TextEditingController();
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text(
          'Registrar corral',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "ID corral",
          style: TextStyle(fontSize: 25),
        ),
        TextField(
          controller: arete,
          decoration: InputDecoration(labelText: "ID corral"),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Ubicacion",
          style: TextStyle(fontSize: 25),
        ),
        TextField(
          controller: raza,
          decoration: InputDecoration(labelText: "Ubicacion"),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(onPressed: () {

        }, child: Text('Registrar'))
      ],
    );
  }
}