import 'dart:io';

import 'package:culinfo/color/AppColor.dart';
import 'package:culinfo/controller/Database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

// ignore: must_be_immutable
class DetailNewsPage extends StatefulWidget {
  late int id, favorite;
  late String image;
  late String title, desc, author, date;
  final VoidCallback onDetailsPagePopped;

  DetailNewsPage(
      {super.key,
      required this.image,
      required this.id,
      required this.favorite,
      required this.title,
      required this.desc,
      required this.onDetailsPagePopped,
      required this.date,
      required this.author});

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  bool clicked = false;
  // Menampilkan Notifikasi Berhasil Menambahkan Favorite
  showToastSuccess() {
    return Fluttertoast.showToast(
        msg: "Berhasil Menambahkan Favorite!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.success,
        textColor: AppColor.text,
        fontSize: 18.0);
  }

  // Menampilkan Notifikasi Gagal Menambahkan Favorite
  showToastFailed() {
    return Fluttertoast.showToast(
        msg: "Berhasil Mengeluarkan Favorite!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColor.danger,
        textColor: AppColor.text,
        fontSize: 18.0);
  }

  // Melakukan Pengecekan Apakah Status Favorite true atau false
  Future<void> checkFavoriteStatus() async {
    final favoriteStatus = await DatabaseHelper.instance
        .getFavoriteStatus(widget.id); // Mengambil Status Dari Database

    setState(() {
      clicked = favoriteStatus == 1;
    });
  }

  // Fungsi untuk trigger fetchNews() di Dashboard Page
  void _navigateBack(BuildContext context) {
    Navigator.pop(context);
    widget.onDetailsPagePopped();
  }

  // Menampilkan Alert Dialog
  reportAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Laporkan',
            style: GoogleFonts.poppins(
                color: AppColor.danger, fontWeight: FontWeight.w600),
          ),
          content: Text('Apakah anda yakin ingin melaporkan berita ini?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColor.text),
              ),
              child: Text(
                'Kembali',
                style: GoogleFonts.poppins(color: AppColor.textBlack),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Laporkan',
                style: GoogleFonts.poppins(),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColor.danger),
                elevation: MaterialStatePropertyAll(5),
              ),
            )
          ],
          contentTextStyle: GoogleFonts.poppins(color: AppColor.textBlack),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFavoriteStatus(); // Trigger fungsi ketika load page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _navigateBack(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.textBlack,
            )),
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
              color: AppColor.textBlack, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              reportAlertDialog(context);
            },
            icon: Icon(Icons.warning_amber_rounded),
            color: AppColor.danger,
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              child: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius:
                    BorderRadius.circular(10),
                child: InstaImageViewer(
                  child: Image.file(
                    File(widget.image),
                    filterQuality: FilterQuality.high,
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title,
                                style: GoogleFonts.poppins(
                                  color: AppColor.textBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                )),
                            Text(widget.date,
                                style: GoogleFonts.poppins(
                                  color: AppColor.textBlack,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                )),
                            RichText(
                              text: TextSpan(
                                  text: 'Dibuat oleh: ',
                                  style: GoogleFonts.poppins(
                                    color: AppColor.textBlack,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: widget.author,
                                        style: GoogleFonts.poppins(
                                          color: AppColor.textBlack,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ))
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              clicked = !clicked; // Mengubah Kondisi
                              int newFavoriteValue = clicked
                                  ? 1
                                  : 0; // Nilai dari Clicked akan dibaca 1 apabila True dan 0 apabila False
                              DatabaseHelper.instance.updateFavorite(widget.id,
                                  newFavoriteValue); // Update Database Mengubah Favorite Menjadi 1 atau 0
                            });
                            clicked ? showToastSuccess() : showToastFailed();
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: clicked
                                ? AppColor.danger
                                : AppColor
                                    .placeholder, // Kondisi Apabila Ikon diklik maka akan mengubah warna
                          )),
                    ],
                  ),
                ),
                const Divider(
                  color: AppColor.placeholder,
                  thickness: 1,
                  endIndent: 10,
                  indent: 10,
                ),
                Padding(
                  // Menampilkan Text Lebih Banyak
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: ExpandableText(
                    widget.desc,
                    expandText: 'Tampilkan Lebih Banyak',
                    maxLines: 5,
                    animation: true,
                    linkColor: AppColor.primary,
                    animationDuration: Duration(seconds: 2),
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.poppins(
                      color: AppColor.textBlack,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
