import 'package:firebase_app/screens/home_page.dart';
import 'package:firebase_app/screens/image_page.dart';
import 'package:firebase_app/services/autentificacao.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class CriarLogin extends StatefulWidget {
  const CriarLogin({super.key});

  @override
  State<CriarLogin> createState() => _CriarLoginState();
}

class _CriarLoginState extends State<CriarLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();

  Autentificacao autentificacao = Autentificacao();

  botaoCriarlogin() async {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();
    String nome = nomeController.text.trim();

    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

    if (nome.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erro',
        text: 'O nome não pode estar vazio.',
        titleColor: Colors.white,
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFdd90452),
      );
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erro',
        text: 'Formato de email inválido.',
        titleColor: Colors.white,
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
        text: 'A senha deve conter ao menos 6 caracteres.',
        titleColor: Colors.white,
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFdd90452),
      );
      return;
    }

    try {
      await autentificacao.cadastrarUsuario(email: email, senha: senha);

      setState(() {
        emailController.clear();
        senhaController.clear();
        nomeController.clear();
      });

      QuickAlert.show(
        title: 'Sucesso',
        context: context, 
        type: QuickAlertType.success,
        text: 'Login Criado!',
        confirmBtnText: 'OK',
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        textColor: Colors.white,
        titleColor: Colors.white,
        confirmBtnColor: const Color(0xFF15bf5f),
      ).then((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ImagePage()),
          (Route<dynamic> route) => false,
        );
      });
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erro',
        text: 'Erro ao criar conta. Tente novamente.',
        titleColor: Colors.white,
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
      appBar: AppBar(
        title: Text("Criar Login", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(Icons.account_circle, size: 30, color: Colors.black),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Campo nome
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Nome",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 12),
                child: TextField(
                  controller: nomeController,
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

          // Campo email
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Email",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 12),
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

          // Campo senha
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Senha",
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 12),
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
            height: 30,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                botaoCriarlogin();
              },
              child: Text(
                "Salvar",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 30,
            width: 150,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(
                "Cancelar",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
