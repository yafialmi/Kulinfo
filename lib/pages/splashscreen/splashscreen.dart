import 'package:culinfo/color/AppColor.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    //------------------------------Memberikan Delay tiga detik pada splash sebelum mengarah ke halaman utama----------------------------------
    Timer(Duration(seconds: 3), () {Navigator.pushReplacementNamed(context, '/home');}); 
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo1.png')
          //  SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.050,
          // ),
            // CircularProgressIndicator(
            //   color: AppColor.text,
            // ),
          ],
        ),
      ),
    );
  }
}
