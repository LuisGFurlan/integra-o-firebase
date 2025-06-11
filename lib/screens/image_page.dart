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
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      builder: (modalContext) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipOval(
                  child: Image.file(
                    imageFile,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 45,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _saveImage(imageFile);
                      Navigator.pop(modalContext);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 41, 40, 40),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 45,
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(modalContext),
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 41, 40, 40),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
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

   void pagHome(context) {
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
          Spacer(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "Conta",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.account_circle, size: 25, color: Colors.white),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Container(
                  alignment: Alignment.centerRight,
                  //height: 300,
                  //width: 500,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 29, 28, 28),
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 83, 78, 78),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        spreadRadius: 10,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      pagHome(context);
                    },
                    icon: Icon(Icons.logout, size: 35, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 40),
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
                    color: Colors.black.withValues(alpha: 0.4),
                    spreadRadius: 12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 30, 30, 30),
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            spreadRadius: 8,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child:
                            image == null
                                ? const Icon(
                                  Icons.no_photography,
                                  color: Colors.white38,
                                  size: 140,
                                )
                                : Image.file(image!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 41, 40, 40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          FirebaseAuth.instance.currentUser?.email ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (BuildContext modalContext) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildImageSourceButton(
                              icon: Icons.camera_alt,
                              label: 'Câmera',
                              onTap: () {
                                Navigator.pop(modalContext);
                                pickImageCamera(context);
                              },
                            ),
                            _buildImageSourceButton(
                              icon: Icons.image,
                              label: 'Galeria',
                              onTap: () {
                                Navigator.pop(modalContext);
                                pickImage(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 41, 40, 40),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                child: const Text(
                  "Selecionar Imagem",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color.fromARGB(255, 41, 40, 40),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 100,
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
