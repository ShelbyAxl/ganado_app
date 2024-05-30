import 'package:firebase_auth/firebase_auth.dart';

class Autenticacion{
  static FirebaseAuth autenticar = FirebaseAuth.instance;

  static Future <User?> crearUsuario(String email, String pass) async{
    try{
      UserCredential res = await autenticar.createUserWithEmailAndPassword(email: email, password: pass);
      return res.user;
    }catch(e){
      return null;
    }
  }

  static Future<User?> autenticarUsuario(String email, String password) async{
    try{
      UserCredential usuario = await autenticar.signInWithEmailAndPassword(email: email, password: password);
      return usuario.user;
    }catch(e){
      return null;
    }

  }
  static bool estaLogueado(){
    return autenticar.currentUser != null ? true : false;
  }

  static Future cerrarSesion() async{
    return autenticar.signOut();
  }

}