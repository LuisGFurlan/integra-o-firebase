import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Autentificacao {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> cadastrarUsuario({
    required String email,
    required String senha,
  }) async {
    // Cria o usuário no Firebase Auth
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final db = FirebaseFirestore.instance;   
    final user = <String, String>{
      "email" : email,
      "imagem" : 'null'
    };
    db  
      .collection("users")
      .doc(uid)
      .set(user);
    
  }
}
