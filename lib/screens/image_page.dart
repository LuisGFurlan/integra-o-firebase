import 'dart:convert';
import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/screens/home_page.dart';
import 'package:firebase_app/services/autentificacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_app/photo.dart';
import 'package:firebase_app/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
    carregarEnderecoDoFirebase();
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
        return SafeArea(
          child: SizedBox(
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

  TextEditingController cepController = TextEditingController();
  TextEditingController numController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController bairroController = TextEditingController();

  String ruaApi = "";
  String cepApi = "";
  String bairroApi = "";
  String estadoApi = "";
  String complementoApi = "";
  String cidadeApi = "";
  String numApi = "";

  bool contemCaractereEspecial(String texto) {
    return !RegExp(r'^[a-zA-Z0-9À-ÿ\s]+$').hasMatch(texto);
  }

  void buscaCep(String cep, BuildContext context) async {
    if (cep.length != 8) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erro',
        titleColor: Colors.white,
        text: 'Digite o CEP completo.',
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFdd90452),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("https://viacep.com.br/ws/$cep/json/"),
      );
      final dados = json.decode(response.body);

      if (dados.containsKey('erro')) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Erro',
          titleColor: Colors.white,
          text: 'CEP não encontrado.',
          textColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          confirmBtnText: 'OK',
          confirmBtnColor: const Color(0xFFdd90452),
        );
        return;
      }

      if ((dados["logradouro"] == null || dados["logradouro"].isEmpty) ||
          (dados["bairro"] == null || dados["bairro"].isEmpty)) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Erro',
          titleColor: Colors.white,
          text: 'CEP não retornou rua ou bairro. Insira manualmente.',
          textColor: Colors.white,
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          confirmBtnText: 'OK',
          confirmBtnColor: const Color(0xFFdd90452),
        );
        return;
      }

      setState(() {
        ruaController.text = dados["logradouro"];
        bairroController.text = dados["bairro"];
        cidadeApi = dados["localidade"] ?? '';
        estadoApi = dados["uf"] ?? '';
        cepApi = dados["cep"] ?? '';
      });
    } catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erro',
        titleColor: Colors.white,
        text: 'Falha na conexão ao buscar o CEP.',
        textColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        confirmBtnText: 'OK',
        confirmBtnColor: const Color(0xFFdd90452),
      );
    }
  }

  void gravaEnderecoFirebase(BuildContext context) async {
    final auth = Autentificacao();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    try {
      await auth.salvarEnderecoUsuario(
        uid: uid,
        rua: ruaApi,
        numero: numApi,
        complemento: complementoApi,
        bairro: bairroApi,
        cidade: cidadeApi,
        estado: estadoApi,
        cep: cepApi,
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Endereço atualizado com sucesso')),
      // );
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Erro ao atualizar o endereço')),
      // );
      // print(e);
    }
  }

  void carregarEnderecoDoFirebase() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final endereco =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (endereco.exists) {
      final data = endereco.data();
      if (data != null) {
        setState(() {
          ruaApi = data['rua'] ?? '';
          cepApi = data['cep'] ?? '';
          bairroApi = data['bairro'] ?? '';
          estadoApi = data['estado'] ?? '';
          complementoApi = data['complemento'] ?? '';
          cidadeApi = data['cidade'] ?? '';
          numApi = data['numero'] ?? '';
        });
      }
    }
  }

  Widget _buildInfoLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 41, 40, 40),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        Icon(
                          Icons.account_circle,
                          size: 25,
                          color: Colors.white,
                        ),
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

            SizedBox(height: 15),
            Column(
              children: [
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
                        const SizedBox(height: 15),
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
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 41, 40, 40),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.email,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      41,
                                      40,
                                      40,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 6,
                                      top: 10,
                                    ),
                                    child: Text(
                                      FirebaseAuth
                                              .instance
                                              .currentUser
                                              ?.email ??
                                          '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                (ruaApi.isNotEmpty ||
                        numApi.isNotEmpty ||
                        complementoApi.isNotEmpty ||
                        bairroApi.isNotEmpty ||
                        cidadeApi.isNotEmpty ||
                        estadoApi.isNotEmpty ||
                        cepApi.isNotEmpty)
                    ? Column(
                      children: [
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Row(
                                children: const [
                                  Text(
                                    "Localização",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.location_on,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            height: 300,
                            width: 500,
                            constraints: const BoxConstraints(maxWidth: 500),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 29, 28, 28),
                              border: Border.all(
                                width: 1,
                                color: const Color.fromARGB(255, 83, 78, 78),
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 12,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _buildInfoLabelValue("Rua", ruaApi),
                                    _buildInfoLabelValue("Número", numApi),
                                    _buildInfoLabelValue(
                                      "Complemento",
                                      complementoApi,
                                    ),
                                    _buildInfoLabelValue("Bairro", bairroApi),
                                    _buildInfoLabelValue("Cidade", cidadeApi),
                                    _buildInfoLabelValue("Estado", estadoApi),
                                    _buildInfoLabelValue("CEP", cepApi),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Container(),
              ],
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
                        return SafeArea(
                          child: Padding(
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (BuildContext modalContext) {
                        return SafeArea(
                          child: AnimatedPadding(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(modalContext).viewInsets.bottom,
                            ),
                            child: SingleChildScrollView(
                              child: IntrinsicHeight(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 40),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 25,
                                          ),
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Cadastrar Endereço",
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.location_on,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 40),

                                    // Campo Nome
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 25,
                                      ),
                                      child: Container(
                                        width: 500,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            29,
                                            28,
                                            28,
                                          ),
                                          border: Border.all(
                                            width: 1,
                                            color: const Color.fromARGB(
                                              255,
                                              83,
                                              78,
                                              78,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(
                                                100,
                                              ),
                                              spreadRadius: 12,
                                              blurRadius: 20,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 30),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                10.0,
                                              ),
                                              child: Container(
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                    255,
                                                    41,
                                                    40,
                                                    40,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        left: 10,
                                                      ),
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      CepInputFormatter(),
                                                    ],
                                                    controller: cepController,
                                                    onChanged: (value) {
                                                      final cepLimpo = value
                                                          .replaceAll(
                                                            RegExp(r'[-.]'),
                                                            '',
                                                          );
                                                      if (cepLimpo.length ==
                                                          8) {
                                                        buscaCep(
                                                          cepLimpo,
                                                          context,
                                                        );
                                                      }
                                                    },
                                                    cursorColor: Colors.white,
                                                    decoration:
                                                        const InputDecoration(
                                                          hintText: "CEP",
                                                          hintStyle: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                          border:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                        ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            //SizedBox(height: 15),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                        255,
                                                        41,
                                                        40,
                                                        40,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 10,
                                                          ),
                                                      child: TextField(
                                                        controller:
                                                            ruaController,
                                                        cursorColor:
                                                            Colors.white,
                                                        decoration:
                                                            InputDecoration(
                                                              hintText:
                                                                  "Nome da Rua",
                                                              hintStyle: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Container(
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                        255,
                                                        41,
                                                        40,
                                                        40,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 10,
                                                          ),
                                                      child: TextField(
                                                        controller:
                                                            bairroController,
                                                        cursorColor:
                                                            Colors.white,
                                                        decoration:
                                                            InputDecoration(
                                                              hintText:
                                                                  "Bairro",
                                                              hintStyle: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              enabledBorder:
                                                                  InputBorder
                                                                      .none,
                                                              focusedBorder:
                                                                  InputBorder
                                                                      .none,
                                                            ),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10.0,
                                                        ),
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              41,
                                                              40,
                                                              40,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                            ),
                                                        child: TextField(
                                                          controller:
                                                              complementoController,
                                                          cursorColor:
                                                              Colors.white,
                                                          decoration: InputDecoration(
                                                            hintText:
                                                                "Complemento",
                                                            hintStyle: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            border:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          10.0,
                                                        ),
                                                    child: Container(
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              41,
                                                              40,
                                                              40,
                                                            ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              left: 10,
                                                            ),
                                                        child: TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              numController,
                                                          cursorColor:
                                                              Colors.white,
                                                          decoration:
                                                              InputDecoration(
                                                                hintText:
                                                                    "Número",
                                                                hintStyle:
                                                                    TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                enabledBorder:
                                                                    InputBorder
                                                                        .none,
                                                                focusedBorder:
                                                                    InputBorder
                                                                        .none,
                                                              ),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 60),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 25,
                                                  ),
                                              child: SizedBox(
                                                height: 50,
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      ruaApi =
                                                          ruaController.text
                                                              .trim();
                                                      bairroApi =
                                                          bairroController.text
                                                              .trim();
                                                      numApi =
                                                          numController.text
                                                              .trim();
                                                      complementoApi =
                                                          complementoController
                                                              .text
                                                              .trim();
                                                      cepApi =
                                                          cepController.text
                                                              .trim();
                                                    });
                                                    gravaEnderecoFirebase(
                                                      context,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Salvar",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                          const Color.fromARGB(
                                                            255,
                                                            41,
                                                            40,
                                                            40,
                                                          ),
                                                        ),
                                                    shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        side: const BorderSide(
                                                          color: Colors.white,
                                                          width: 1,
                                                        ),
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
                                    SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            ),
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
                    "Inserir Endereço",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
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
