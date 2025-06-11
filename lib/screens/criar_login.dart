import 'package:firebase_app/screens/home_page.dart';
import 'package:firebase_app/screens/image_page.dart';
import 'package:firebase_app/services/autentificacao.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  bool _obscurePassword = true; // ← controle do campo de senha

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
        titleColor: Colors.white,
        text: 'O nome não pode estar vazio.',
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
        text: 'A senha deve conter ao menos 6 caracteres.',
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
        titleColor: Colors.white,
        text: 'Erro ao criar conta. Tente novamente.',
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFdd90452),
      );
    }
  }

  void pagHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 17, 17),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Título
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "Criar Conta",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.person_add, size: 25, color: Colors.white),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 29, 28, 28),
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 83, 78, 78),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        spreadRadius: 10,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      pagHome();
                    },
                    icon: Icon(Icons.arrow_back, size: 35, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 40),

          // Campo Nome
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 29, 28, 28),
                border: Border.all(
                  width: 1,
                  color: const Color.fromARGB(255, 83, 78, 78),
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(100),
                    spreadRadius: 12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 40, 40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: nomeController,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            hintText: "Nome",
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
                  SizedBox(height: 15),

                  // Campo Email
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 40, 40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
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

                  SizedBox(height: 15),

                  // Campo Senha com ícone de visualização
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 40, 40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
                        child: TextField(
                          controller: senhaController,
                          obscureText: _obscurePassword,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Senha",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 60),

                  // Botão Salvar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: botaoCriarlogin,
                        child: Text(
                          "Salvar",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            const Color.fromARGB(255, 41, 40, 40),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
