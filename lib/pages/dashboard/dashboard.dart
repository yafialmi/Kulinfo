import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:banner_carousel/banner_carousel.dart';
import 'package:culinfo/color/AppColor.dart';
import 'package:culinfo/controller/Database.dart';
import 'package:culinfo/pages/news/news_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> newsList = [];
  bool load = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchNews();
  }
  // Memasukkan Data dari Database ke dalam List
  Future<void> fetchNews() async {
    final news = await DatabaseHelper.instance.getAllNews();
    setState(() {
      newsList = news;
    });
  }
  // Refresh Page untuk Mengambil Data Terbaru
  Future<void> _handleRefresh() async {
    await fetchNews();
    setState(() {
      load = true;
    });
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        load = false;
      });
    });
  }
  // Menampilkan Alert Dialog untuk Menghapus Data
  deleteAlertDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Perhatian',
            style: GoogleFonts.poppins(
                color: AppColor.danger, fontWeight: FontWeight.w600),
          ),
          content: RichText(
              text: TextSpan(
            text: 'Apakah anda yakin untuk menghapus berita ini?',
            style: GoogleFonts.poppins(color: AppColor.textBlack),
          )),
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
            ElevatedButton(
              onPressed: () async {
                DatabaseHelper.instance
                    .deleteNews(id)
                    .then((value) => fetchNews())
                    .whenComplete(() => Navigator.pop(context));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColor.danger),
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(color: AppColor.text),
              ),
            ),
          ],
          contentTextStyle: GoogleFonts.poppins(color: AppColor.textBlack),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchNews();
  }

  //-----------------------------Build-----------------------------------
  @override
  Widget build(BuildContext context) {
    List<Widget> listBanners = [ // Menampilkan Banner dari Data yang ada di Database
      for (var news in newsList.take(3)) // take(3) berfungsi untuk hanya mengambil tiga data dari banyak data yang ada dalam list
        Image.file( 
          File(news['gambar_berita']),
          fit: BoxFit.cover,
        ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Kulinfo',
          style: GoogleFonts.poppins(
              color: AppColor.textBlack,
              fontWeight: FontWeight.w600,
              fontSize: 24),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                _handleRefresh();
              },
              child: Icon(Icons.refresh),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(AppColor.primary),
              ),
            ),
          )
        ],
      ),
      body: load
          ? Center(
              child: CircularProgressIndicator(
                color: AppColor.primary,
              ),
            )
          : listBanners.isEmpty
              ? Center(
                  child: Text(
                    'No Data',
                    style: GoogleFonts.poppins(fontSize: 34),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      BannerCarousel(
                        initialPage: Random().nextInt(3),
                        animation: true,
                        spaceBetween: 10,
                        activeColor: AppColor.primary,
                        viewportFraction: 1,
                        customizedBanners: listBanners,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.030,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Berita Terbaru',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            color: AppColor.textBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.0010,
                      ),
                      for (var news in newsList)
                        FoodTiles(
                          id: news['id'],
                          image: news['gambar_berita'],
                          title: news['judul_berita'],
                          subtitle:
                              '${news['tanggal_pembuatan_berita']} | ${news['author_berita']}',
                          onLongPress: () =>
                              deleteAlertDialog(context, news['id']), // untuk trigger delete dialog
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
                                    fetchNews();
                                  },
                                ),
                              ),
                            );
                            setState(() {});
                          },
                        )
                    ],
                  ),
                ),
    );
  }
}

//-------------------------Custom List Tile---------------------------------------
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
        borderRadius: const BorderRadius.all(Radius.circular(4)),
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
