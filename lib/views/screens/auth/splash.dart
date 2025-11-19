import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/auth_controller.dart';
import 'package:jurnee/controllers/user_controller.dart';
import 'package:jurnee/views/screens/auth/login.dart';
import 'package:jurnee/views/screens/home/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  bool isVerified = false;
  Duration animationDuration = Duration(milliseconds: 4500);

  @override
  void initState() {
    super.initState();
    verifyToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox.expand(
          child: Image.asset("assets/images/logo.gif", fit: BoxFit.cover),
        ),
      ),
    );
  }

  void verifyToken() async {
    final time = Stopwatch();
    time.start();
    isVerified = await Get.find<AuthController>().previouslyLoggedIn();
    if (isVerified) Get.find<UserController>().getUserData();

    if (time.elapsed < animationDuration) {
      await Future.delayed(animationDuration - time.elapsed);
    }

    if (isVerified) {
      Get.offAll(() => Home());
    } else {
      Get.offAll(() => Login());
    }
  }
}
