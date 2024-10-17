import 'dart:io';

import 'package:culinfo/color/AppColor.dart';
import 'package:culinfo/controller/Database.dart';
import 'package:culinfo/pages/dashboard/dashboard.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import  'package:intl/intl.dart';

import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreateNewsPage extends StatefulWidget {
  final VoidCallback? onDetailsPagePopped;

  const CreateNewsPage({required this.onDetailsPagePopped, super.key});

  @override
  State<CreateNewsPage> createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  File? _image;
  String? _imgpath;
  final _formKey = GlobalKey<FormState>();
  final C_desc = new TextEditingController();
  final C_author = new TextEditingController();
  final C_title = new TextEditingController();

  void _navigateBack(BuildContext context) {
    // Pop the details page and trigger fetchNews on the dashboard page
    Navigator.pop(context);
    // Assuming that DashboardPage has a StatefulWidget with _DashboardPageState
    final dashboardState =
        context.findAncestorStateOfType<DashboardPageState>();
    dashboardState?.fetchNews();
  }

//--------------------------Mendapatkan Gambar Melalui Galeri--------------------------------------//
  Future getImageGalery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imagePermanent = await saveFilePermanently(image.path);
      print(imagePermanent);

      // final imageTemporary = File(image.path);
      // print(imageTemporary);

      setState(() {
        _image = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //-------------------------Menyimpan Path File---------------------------------------//
  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    setState(() {
      _imgpath = image.path;
    });

    return File(imagePath).copy(image.path);
  }

//------------Memberikan Notifikasi apabila data berhasil dibuat-------------//
  showToastSuccess() {
    return Fluttertoast.showToast(
        msg: "Berhasil Buat Berita!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.success,
        textColor: AppColor.text,
        fontSize: 18.0);
  }

//------------Memberikan Notifikasi apabila data gagal dibuat-------------//
  showToastFailed() {
    return Fluttertoast.showToast(
        msg: "Mohon periksa kembali!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.danger,
        textColor: AppColor.text,
        fontSize: 18.0);
  }

//--------------------------Fungsi untuk menghapus text apabila meninggalkan halaman--------------------------------------
  @override
  void dispose() {
    C_desc.dispose();
    C_author.dispose();
    C_title.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  //------------------------------Build----------------------------------
  @override
  Widget build(BuildContext context) {
    final Date = DateTime.now();
    String finalDate = DateFormat().format(Date);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus(); // disclose fokus keyboard
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColor.textBlack,
              )),
          title: Text(
            'Buat berita baru',
            style: GoogleFonts.poppins(
                color: AppColor.textBlack, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      _image != null
                          ? InkWell(
                              onTap: () => getImageGalery(),
                              child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _image!,
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.placeholder,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextButton(
                                    onPressed: () {
                                      getImageGalery();
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.camera_alt,
                                            size: 42,
                                            color: AppColor.textBlack,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Pilih Cover Berita Anda",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.textBlack),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.030,
                      ),
                      TextFormField(
                        controller: C_title,
                        enabled: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul Berita tidak boleh kosong!';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Judul Berita',
                          alignLabelWithHint: true,
                          floatingLabelStyle:
                              GoogleFonts.archivo(color: AppColor.primary),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: AppColor.primary, width: 1.0),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: GoogleFonts.archivo(),
                          hintText: 'Isi Judul Berita ini',
                          hintStyle:
                              GoogleFonts.archivo(color: AppColor.placeholder),
                          contentPadding: EdgeInsets.all(20),
                          fillColor: Colors.white,
                          focusColor: AppColor.primary,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIconColor: Colors.black,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.030,
                      ),
                      TextFormField(
                        controller: C_author,
                        enabled: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Author tidak boleh kosong!';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Author',
                          alignLabelWithHint: true,
                          floatingLabelStyle:
                              GoogleFonts.archivo(color: AppColor.primary),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: GoogleFonts.archivo(),
                          hintText: 'Isi Author berita ini',
                          hintStyle:
                              GoogleFonts.archivo(color: AppColor.placeholder),
                          contentPadding: EdgeInsets.all(20),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: AppColor.primary, width: 1.0),
                          ),
                          focusColor: AppColor.primary,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIconColor: Colors.black,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.030,
                      ),
                      TextFormField(
                        controller: C_desc,
                        autofocus: false,
                        enabled: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi tidak boleh kosong!';
                          }
                          return null;
                        },
                        maxLines: 3,
                        showCursor: true,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Deskripsi',
                          alignLabelWithHint: true,
                          floatingLabelStyle:
                              GoogleFonts.archivo(color: AppColor.primary),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.all(20),
                          labelStyle: GoogleFonts.archivo(),
                          focusColor: AppColor.primary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: AppColor.primary, width: 1.0),
                          ),
                          hintText: 'Isi Deskripsi Anda',
                          hintStyle:
                              GoogleFonts.archivo(color: AppColor.placeholder),
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          prefixIconColor: Colors.black,
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Align(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.060,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () async {
                              //-------------------Kondisi Validasi-----------------------------
                              if (_formKey.currentState!.validate()) {
                                try {
                                  await DatabaseHelper.instance.Create(
                                    C_title.text,
                                    C_author.text,
                                    _imgpath!,
                                    C_desc.text,
                                    finalDate,
                                  );
                                  // Data successfully inserted
                                  print('Record successfully created');
                                  // Optionally, show a success message to the user
                                } catch (e) {
                                  // Failed to insert data
                                  print('Failed to create record: $e');
                                }
                                Navigator.pop(context);
                                showToastSuccess();
                              } else {
                                showToastFailed();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(AppColor.primary),
                              elevation: MaterialStatePropertyAll(5),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              'Simpan',
                              style: GoogleFonts.archivo(
                                  color: AppColor.text, fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
