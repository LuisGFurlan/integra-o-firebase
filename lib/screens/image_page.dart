import 'package:firebase_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Perfil"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false,
              );
            },
            icon: Icon(Icons.logout, color: Colors.black,size: 30,),
          ),
         //ícone no canto 
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 90),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 280,
                width: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.redAccent, width: 3),
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.no_photography,
                    color: Colors.grey,
                    size: 210,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              height: 60,
              width: 500,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent, width: 3),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: Text(
                  "${FirebaseAuth.instance.currentUser?.email ?? 'Sem usuário'}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
          SizedBox(height: 70,),
          Container(
            height: 50,
            width: 210,
            child: ElevatedButton(
              onPressed: (){},
              child: Text(
                "Editar Foto de Perfil",
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
