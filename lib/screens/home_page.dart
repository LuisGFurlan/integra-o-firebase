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
      backgroundColor: const Color.fromARGB(255, 17, 17, 17),
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.only( right: 15, left: 15),
            child: Container(
              child: Text(
                "Seja Bem Vindo!",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: Text(
              "Por favor, faça loguin em sua conta",
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 102, 102, 102),
              ),
            ),
          ),
          SizedBox(height: 125),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 41, 40, 40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 41, 40, 40),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: senhaController,
                    obscureText: true,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: "Senha",
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              height: 50,
              width: 500,
              child: ElevatedButton(
                onPressed: () {
                  botaoEntrar(emailController.text, senhaController.text);
                },
                child: Text(
                  "Entrar",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Color.fromARGB(255, 41, 40, 40),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.white, // cor da borda
                        width: 1, // espessura da borda
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 27),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Não tem uma conta?",
                  style: TextStyle(color: Colors.white),
                ),
                TextButton(
                  onPressed: () {
                    pagCriarLogin();
                  },
                  child: Text(
                    "Criar conta",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer()
        ],
      ),
    );
  }
}
