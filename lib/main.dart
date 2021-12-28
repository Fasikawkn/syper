import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sportswipe/NotifficationManager.dart';

import 'Categories.dart';
import 'global.dart' as globals;

import 'package:flutter_svg/svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sports Swipe',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  NotificationManager notificationManager = NotificationManager();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: InkWell(
        onTap: () {
          setState(() {
            globals.initial = true;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => MainMenu()));
        },
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: size.height,
                    width: size.width,
                    child: SvgPicture.asset('assets/texttop.svg'),
                    color: HexColor("#30A836"),
                  ),
                ),
                Container(
                  height: size.height * 0.06,
                  width: size.width,
                  color: HexColor("#FFFFFF"),
                ),
                Container(
                  height: size.height * 0.31,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: size.width,
                          child: SvgPicture.asset(
                            'assets/transparenttext.svg',
                            fit: BoxFit.fill,
                          )),
                    ],
                  ),
                  color: HexColor("#004B1F"),
                ),
              ],
            ),
            Positioned(
              right: 30.0,
              bottom: size.height * 0.25,
              child: SvgPicture.asset('assets/football.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
