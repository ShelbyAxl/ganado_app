import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../modelo/vaca.dart';
import '../modelo/corral.dart';

class DB {
  static Future<Database> _abrirDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "ganado.db"),
      onCreate: (db, version) {
        return db.transaction((txn) async {
          // Crear la tabla VACA
          await txn.execute(
            "CREATE TABLE VACA("
                "NOARETE TEXT PRIMARY KEY, "
                "RAZA TEXT, "
                "PESO REAL)",
          );

          //Tabla Corral con el fk
          await txn.execute(
            "CREATE TABLE CORRAL("
                "IDCORRAL INTEGER PRIMARY KEY AUTOINCREMENT, "
                "UBICACION TEXT, "
                "NOARETE TEXT, "
                "FOREIGN KEY (NOARETE) REFERENCES VACA(NOARETE))",
          );
        });
      },
      version: 1,
    );
  }

  // CRUD para la tabla Vaca
  static Future<int> insertarVaca(Vaca vaca) async {
    Database db = await _abrirDB();
    return db.insert("VACA", vaca.toJSON(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Vaca>> mostrarTodasVacas() async {
    Database db = await _abrirDB();
    List<Map<String, dynamic>> resultado = await db.query("VACA");
    return List.generate(resultado.length, (index) {
      return Vaca(
        noArete: resultado[index]['NOARETE'],
        raza: resultado[index]['RAZA'],
        peso: resultado[index]['PESO'],
      );
    });
  }

  static Future<int> actualizarVaca(Vaca vaca) async {
    Database db = await _abrirDB();
    return db.update("VACA", vaca.toJSON(), where: "NOARETE=?", whereArgs: [vaca.noArete]);
  }

  static Future<int> eliminarVaca(String noArete) async {
    Database db = await _abrirDB();
    return db.delete("VACA", where: "NOARETE=?", whereArgs: [noArete]);
  }

  // CRUD para la tabla CORRAL
  static Future<int> insertarCorral(Corral corral) async {
    Database db = await _abrirDB();
    return db.insert("CORRAL", corral.toJSON());
  }

  static Future<List<Corral>> mostrarTodosCorrales() async {
    Database db = await _abrirDB();
    List<Map<String, dynamic>> resultado = await db.query("CORRAL");
    return List.generate(resultado.length, (index) {
      return Corral(
        idCorral: resultado[index]['IDCORRAL'],
        ubicacion: resultado[index]['UBICACION'],
        noArete: resultado[index]['NOARETE'],
      );
    });
  }

  static Future<int> actualizarCorral(Corral corral) async {
    Database db = await _abrirDB();
    return db.update("CORRAL", corral.toJSON(), where: "IDCORRAL=?", whereArgs: [corral.idCorral]);
  }

  static Future<int> eliminarCorral(int idCorral) async {
    Database db = await _abrirDB();
    return db.delete("CORRAL", where: "IDCORRAL=?", whereArgs: [idCorral]);
  }
}