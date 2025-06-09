import 'dart:io';
import 'package:firebase_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_app/photo.dart';
import 'package:firebase_app/db_helper.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  File? image;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
  }

  Future<void> _loadUserPhoto() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List<Photo> photos = await DBHelper().getPhotosByUid(uid);
    if (photos.isNotEmpty) {
      setState(() {
        image = File(photos.first.photoName!);
      });
    }
  }

  Future<void> pickImage(context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      previewImage(context, imageFile);
    }
  }

  Future<void> pickImageCamera(context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      previewImage(context, imageFile);
    }
  }

  void previewImage(BuildContext context, File imageFile) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext modalContext) {
        return SizedBox(
          height: 500,
          width: 445,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    child: ClipOval(
                      child: Image.file(
                        imageFile,
                        width: 280,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveImage(imageFile);
                    Navigator.pop(modalContext);
                  },
                  child: const Text(
                    "Salvar",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.redAccent,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ImagePage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveImage(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');

    Photo newPhoto = Photo(
      uid: FirebaseAuth.instance.currentUser!.uid,
      photoName: savedImage.path,
    );

    await DBHelper().save(newPhoto);

    setState(() {
      image = savedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Perfil"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.black, size: 30),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 90),
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
                child:
                    image == null
                        ? const Icon(
                          Icons.no_photography,
                          color: Colors.grey,
                          size: 210,
                        )
                        : ClipOval(
                          child: Image.file(
                            image!,
                            width: 280,
                            height: 280,
                            fit: BoxFit.cover,
                          ),
                        ),
              ),
            ),
          ),
          const SizedBox(height: 30),
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
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
          ),
          const SizedBox(height: 70),
          Container(
            height: 50,
            width: 210,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  showDragHandle: true,
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext modalContext) {
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
                                Navigator.pop(modalContext);
                                pickImageCamera(context);
                              },
                              splashColor: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 70,
                                width: 130,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                          const SizedBox(width: 20),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 226, 223, 223),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(modalContext);
                                pickImage(context);
                              },
                              splashColor: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 70,
                                width: 130,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
              child: const Text(
                "Editar Foto de Perfil",
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
