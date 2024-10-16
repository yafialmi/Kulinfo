import 'package:culinfo/color/AppColor.dart';
import 'dart:io';
import 'package:culinfo/controller/Database.dart';
import 'package:culinfo/pages/news/news_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favoriteNewsList = [];
  bool load = false;
  // Menampilkan Alert Dialog
  reportAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Tentang Aplikasi',
            style: GoogleFonts.poppins(
                color: AppColor.primary, fontWeight: FontWeight.w600),
          ),
          content: RichText(
              text: TextSpan(
                  text: 'Aplikasi ini dibuat oleh Kelompok', style: GoogleFonts.poppins( color: AppColor.textBlack),
                  children: [
                TextSpan(
                    text: ' 11 ',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColor.textBlack)),
                const TextSpan(text: 'yang beranggotakan '),
                TextSpan(
                    text: 'Yafi',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColor.textBlack)),
                TextSpan(text: ' ' + '& ', style: GoogleFonts.poppins(color: AppColor.textBlack)),
                TextSpan(
                    text: 'Clara',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColor.textBlack)),
              ])),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColor.primary),
              ),
              child: Text(
                'Kembali',
                style: GoogleFonts.poppins(color: AppColor.text),
              ),
            ),
            
          ],
          contentTextStyle: GoogleFonts.poppins(color: AppColor.textBlack),
        );
      },
    );
  }

  // Memasukkan Data dari Database ke dalam list
  Future<void> fetchFavoriteNews() async {
    final favoriteNews = await DatabaseHelper.instance.getFavoriteNews();
    setState(() {
      favoriteNewsList = favoriteNews;
    });
  }

  @override
  void initState() {
    fetchFavoriteNews(); // Trigger fungsi fetch data ketika load page
    // TODO: implement initState
    super.initState();
  }

  //----------------------------Build------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Favorit',
            style: GoogleFonts.poppins(
                color: AppColor.textBlack,
                fontWeight: FontWeight.w600,
                fontSize: 24),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(onPressed: 
              ()=>reportAlertDialog(context), icon: const Icon(Icons.info_outline, color: AppColor.textBlack,))
            )
          ],
        ),
        body: favoriteNewsList.isEmpty ? // Kondisi apabila data kosong
          Center(
            child: Text('No Data', style: GoogleFonts.poppins(fontSize: 34),),
          )
          :
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          
              for (var news in favoriteNewsList) // fungsi foreach untuk memanggil setiap data yang ada
                  FoodTiles(
                    id: news['id'],
                    image: news['gambar_berita'],
                    title: news['judul_berita'],
                    subtitle:
                        '${news['tanggal_pembuatan_berita']} | ${news['author_berita']}',
                    onLongPress: () =>
                        false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailNewsPage(
                            id: news['id'],
                            image: news['gambar_berita'],
                            favorite: news['favorite'],
                            title: news['judul_berita'],
                            desc: news[
                                'deskripsi_berita'], // Add the description
                            date: news['tanggal_pembuatan_berita'],
                            author: news['author_berita'],
                            onDetailsPagePopped: () {
                              fetchFavoriteNews();
                            },
                          ),
                        ),
                        
                      );
                   setState(() {
                     
                   });
                    },
                  )
          ],
        ));
  }
}

//--------------------------Custom List Tile--------------------------------------
class FoodTiles extends StatelessWidget {
  const FoodTiles({
    super.key,
    required this.id,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onLongPress, // Add onLongPress parameter
    required this.onTap, // Add onLongPress parameter
  });
  final int id;
  final String image, title, subtitle;
  final VoidCallback onLongPress; // Define the type of onLongPress
  final VoidCallback onTap; // Define the type of onLongPress

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: false,
      leading: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        child: Image.file(
          File(image),
          fit: BoxFit.contain,
        ),
      ),
      title: Text(title,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: AppColor.textBlack,
            fontWeight: FontWeight.w600,
          )),
      subtitle: Text(subtitle,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColor.textBlack,
          )),
      onLongPress: onLongPress,
      onTap: onTap, // Set the onLongPress function
    );
  }
}
