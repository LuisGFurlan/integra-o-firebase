import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Autentificacao {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> cadastrarUsuario({required String email, required String senha}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final db = FirebaseFirestore.instance;

    final user = <String, dynamic>{
      "email": email,
      "imagem": "null",
      // Outros campos vazios pra depois serem acrescentados
      "rua": "",
      "numero": "",
      "complemento": "",
      "bairro": "",
      "cidade": "",
      "estado": "",
      "cep": ""
    };
    db.collection("users").doc(uid).set(user);
  }

  Future<void> salvarEnderecoUsuario({required String uid, 
    required String rua, 
    required String numero, 
    required String complemento, 
    required String bairro, 
    required String cidade, 
    required String estado, 
    required String cep}) async {

      final db = FirebaseFirestore.instance;

      await db.collection("users").doc(uid).update({ 
        "rua": rua,
        "numero": numero,
        "complemento": complemento,
        "bairro": bairro,
        "cidade": cidade,
        "estado": estado,
        "cep": cep,
      });
  }
}


