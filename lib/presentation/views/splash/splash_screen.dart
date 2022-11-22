import 'dart:async';

import 'package:autobaires/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = ROUTE_SPLASH_SCREEN;

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isShowingSplash = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isShowingSplash = true;
      });
    });
    Timer(
      const Duration(milliseconds: 3000),
      () => Navigator.pushNamed(context, ROUTE_LOGIN_SCREEN),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: AnimatedOpacity(
            opacity: isShowingSplash ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(IMAGE_SPLASH, fit: BoxFit.cover),
                ),
                AnimatedOpacity(
                    opacity: isShowingSplash ? 0.8 : 0,
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(
                            color: COLOR_VIOLET,
                            spreadRadius: SHADOW_SPREAD_RADIUS,
                            blurRadius: SHADOW_BLUR_RADIUS,
                            offset: Offset(SHADOW_OFFSET_X, SHADOW_OFFSET_Y),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(IMAGE_LOGO, fit: BoxFit.cover),
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
