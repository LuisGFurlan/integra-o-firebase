import 'dart:io';
import 'package:firebase_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File? _image;
  final _picker = ImagePicker();

  pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

  pickImageCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      setState(() {});
    }
  }

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
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(Icons.logout, color: Colors.black, size: 30),
            ),
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
                child: _image == null
                    ? Icon(
                        Icons.no_photography,
                        color: Colors.grey,
                        size: 210,
                      )
                    : ClipOval(
                        child: Image.file(
                          _image!,
                          width: 280,
                          height: 280,
                          fit: BoxFit.cover,
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
                  "${FirebaseAuth.instance.currentUser?.email}",
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
          SizedBox(height: 70),
          Container(
            height: 50,
            width: 210,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) {
                    return SizedBox(
                      height: 140,
                      width: 445,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 226, 223, 223),
                            child: InkWell(
                              onTap: () {
                                pickImageCamera();
                              },
                              splashColor: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 70,
                                width: 130,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.black,
                                          size: 40,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Câmera",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 226, 223, 223),
                            child: InkWell(
                              onTap: () {
                                pickImage();
                              },
                              splashColor: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 70,
                                width: 130,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image,
                                          color: Colors.black,
                                          size: 40,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Galeria",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
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
