import 'package:firebase_app/screens/criar_login.dart';
import 'package:firebase_app/screens/image_page.dart';
import 'package:firebase_app/services/autentificacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  Autentificacao autentificacao = Autentificacao();

  void pagCriarLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => CriarLogin()),
      (Route<dynamic> route) => false,
    );
  }

void botaoEntrar(String email, String senha) async {
  final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

  if (!emailRegex.hasMatch(email)) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Erro',
      titleColor: Colors.white,
      text: 'Formato de email inválido.',
      textColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      confirmBtnText: 'OK',
      confirmBtnColor: const Color(0xFFdd90452),
    );
    return;
  }

  if (senha.length < 6) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Erro',
      titleColor: Colors.white,
      text: 'A senha deve conter ao menos 6 dígitos.',
      textColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      confirmBtnText: 'OK',
      confirmBtnColor: const Color(0xFFdd90452),
    );
    return;
  }

  try {
    final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ImagePage()),
      (Route<dynamic> route) => false,
    );
  } on FirebaseAuthException catch (_) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Erro',
      titleColor: Colors.white,
      text: 'Email ou senha incorretos.',
      textColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      confirmBtnText: 'OK',
      confirmBtnColor: const Color(0xFFdd90452),
    );
  } catch (e) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Erro',
      titleColor: Colors.white,
      text: 'Ocorreu um erro inesperado. Tente novamente.',
      textColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      confirmBtnText: 'OK',
      confirmBtnColor: const Color(0xFFdd90452),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(Icons.account_circle, size: 30, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Email",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 6),
                child: TextField(
                  controller: emailController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Senha",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 6),
                child: TextField(
                  controller: senhaController,
                  obscureText: true,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Container(
            height: 50,
            width: 150,
            child: ElevatedButton(
              onPressed: (){botaoEntrar(emailController.text, senhaController.text);},
              child: Text(
                "Entrar",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.redAccent),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,
            width: 150,
            child: ElevatedButton(
              onPressed: pagCriarLogin,
              child: Text(
                "Criar Conta",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
