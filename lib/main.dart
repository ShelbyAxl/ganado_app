import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ganado_app/controlador/DB.dart';
import 'package:ganado_app/inscribir.dart';
import 'package:ganado_app/modelo/vaca.dart';
import 'firebase_options.dart';
import 'controlador/ServiciosRemoto.dart';
import 'modelo/corral.dart';
import 'Imagenes.dart';
import 'package:file_picker/file_picker.dart';

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
  void initState() {
    super.initState();
    _cargarVacas();
    _cargarCorrales();
  }

  Future<void> _cargarVacas() async {
    List<Vaca> vacasCargadas = await DB.mostrarTodasVacas();
    setState(() {
      vacas = vacasCargadas;
    });
  }

  Future<void> _cargarCorrales() async {
    List<Corral> corralesCargados = await DB.mostrarTodosCorrales();
    setState(() {
      corrales = corralesCargados;
    });
  }


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
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          String titulo = "Storage";
          final seleccionarArchivo = await FilePicker.platform.pickFiles(
              allowedExtensions: ['png','jpg','jpeg'],
              allowMultiple: false,
              type: FileType.custom
          );

          if(seleccionarArchivo == null) {
            setState(() {
              titulo = "ARCHIVO NO SELECCIONADO";
            });
            return;
          }

          var path = seleccionarArchivo.files.single.path!!;
          var nombre = seleccionarArchivo.files.single.name;
          setState(() {
            titulo = "CARGANDO IMAGEN";
          });
          Remoto.subirArchivo(path, nombre).then((value) {
            setState(() {
              titulo = "ARCHIVO CARGADO CORRECTAMENTE";
            });
          });
        }, child: Icon(Icons.add),
      ),
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

  String dirURL = "https://firebasestorage.googleapis.com/v0/b/conociendo-firebase-b616f.appspot.com/o/imagenes%2Fkamen_rider_geats_wallpaper_by_jxloud_dfmze4s-375w-2x.jpg?alt=media&token=21cb6105-de79-43d2-a0b5-480b7424006c";
  Widget contenido() {
    return Center(
      child: Column(
        children: [
          Container(
            color: Colors.black,
            height: 200,
            child: FutureBuilder(
                future: Remoto.mostrarNombresArchivosRemotos(),
                builder: (context, listaNombres){
                  if (listaNombres.hasData){
                    return ListView.builder(
                        itemCount: listaNombres.data!.items.length,
                        itemBuilder: (content, indice){
                          return Padding(padding: EdgeInsets.only(
                              top: 10, left: 30, right: 30
                          ), child: OutlinedButton(
                            onPressed: () async{
                              Remoto.cargarImagen(listaNombres.data!.items[indice].name).then((value){
                                setState(() {
                                  dirURL = value;
                                });
                              });
                            }, child: Text(listaNombres.data!.items[indice].name),
                          ),
                          );
                        }
                    );

                  }
                  return CircularProgressIndicator();

                }
            ),
          ),
          Image.network(dirURL)
        ],
      ),
    );
  }

  Widget navegacion() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'GALERIA',
            backgroundColor: Color.fromRGBO(0, 11, 23, 1)),
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
        case 2: return RegistrarCorral();
        default: return contenido();
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

  final idCorralController = TextEditingController();
  final ubicacionController = TextEditingController();
  final noAreteController = TextEditingController();

  List<Corral> corrales = [];
  Widget RegistrarCorral() {

    Future<void> _cargarCorrales() async {
      List<Corral> corralesCargados = await DB.mostrarTodosCorrales();
      setState(() {
        corrales = corralesCargados;
      });
    }

    Future<void> _registrarCorral() async {
      int idCorral = int.tryParse(idCorralController.text) ?? 0;
      String ubicacion = ubicacionController.text;
      String noArete = noAreteController.text;

      Corral nuevoCorral = Corral(
        idCorral: idCorral,
        ubicacion: ubicacion,
        noArete: noArete,
      );

      await DB.insertarCorral(nuevoCorral);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Corral registrado exitosamente'),
      ));
      FirebaseFirestore baseRemota = FirebaseFirestore.instance;

      baseRemota.collection("ganadoApp").add({
        'idCorral' : idCorralController.text,
        'ubicacion' : ubicacionController.text,
        'noArete' : noAreteController.text
      }).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Se insertó en la nube"))));
      idCorralController.clear();
      ubicacionController.clear();
      noAreteController.clear();
      _cargarCorrales();
    }

    Future<void> _actualizarCorral(int idCorral) async {
      String ubicacion = ubicacionController.text;
      String noArete = noAreteController.text;

      Corral corralActualizado = Corral(
        idCorral: idCorral,
        ubicacion: ubicacion,
        noArete: noArete,
      );

      await DB.actualizarCorral(corralActualizado);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Corral actualizado exitosamente'),
      ));
      idCorralController.clear();
      ubicacionController.clear();
      noAreteController.clear();
      _cargarCorrales();
    }


    Future<void> _eliminarCorral(int idCorral) async {
      await DB.eliminarCorral(idCorral);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Corral eliminado exitosamente'),
      ));
      _cargarCorrales();
    }



    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        Text(
          'Registrar Corral',
          style: TextStyle(fontSize: 30),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "ID del Corral",
          style: TextStyle(fontSize: 25),
        ),
        TextField(
          controller: idCorralController,
          decoration: InputDecoration(labelText: "ID del Corral"),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        Text(
          "Ubicación",
          style: TextStyle(fontSize: 25),
        ),
        TextField(
          controller: ubicacionController,
          decoration: InputDecoration(labelText: "Ubicación"),
        ),
        SizedBox(height: 10),
        Text(
          "Número de Arete",
          style: TextStyle(fontSize: 25),
        ),
        TextField(
          controller: noAreteController,
          decoration: InputDecoration(labelText: "Número de Arete"),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _registrarCorral,
          child: Text('Registrar'),
        ),
        SizedBox(height: 20),
        Text(
          'Lista de Corrales',
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: corrales.length,
          itemBuilder: (context, index) {
            Corral corral = corrales[index];
            return ListTile(
              title: Text('ID: ${corral.idCorral}'),
              subtitle: Text('Ubicación: ${corral.ubicacion}, No de Arete: ${corral.noArete}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      idCorralController.text = corral.idCorral.toString();
                      ubicacionController.text = corral.ubicacion;
                      noAreteController.text = corral.noArete;
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _eliminarCorral(corral.idCorral);
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
            if (idCorralController.text.isNotEmpty) {
              _actualizarCorral(int.parse(idCorralController.text));
            }
          },
          child: Text('Actualizar'),
        ),
      ],
    );
  }



}