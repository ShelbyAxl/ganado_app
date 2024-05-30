import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class Remoto{
  static var carpetaRemota = FirebaseStorage.instance;

  static Future subirArchivo(String path, String nombre) async{
    var file = File(path);
    return carpetaRemota.ref("imagenes/$nombre").putFile(file);
  }

  static Future<ListResult> mostrarNombresArchivosRemotos() async{
    return carpetaRemota.ref("imagenes").listAll();
  }

  static Future cargarImagen(String nombreArchivo) async{
    return carpetaRemota.ref("imagenes/$nombreArchivo").getDownloadURL();
  }
}