import 'package:firebase_app/screens/home_page.dart';
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
    await autentificacao.cadastrarUsuario(
      email: email,
      senha: senha,
    );
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
      backgroundColor: Color.fromARGB(255, 30, 30, 30),
      textColor: Colors.white,
      titleColor: Colors.white,
      confirmBtnColor: Color(0xFF15bf5f),
    ).then((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    });
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
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 6),
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
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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

          // Campo senha
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
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
              onPressed: () {
                botaoCriarlogin();
              },
              child: Text(
                "Salvar",
                style: TextStyle(fontSize: 18, color: Colors.black),
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
