import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/views/screens/home/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  bool isVerified = false;
  Duration time = Duration(milliseconds: 4500);

  @override
  void initState() {
    super.initState();
    // verifyToken();
    Future.delayed(time, () {
      Get.to(() => Home());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(backgroundColor: Colors.transparent),
      body: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox.expand(
          child: Image.asset("assets/images/logo.gif", fit: BoxFit.cover),
        ),
      ),
    );
  }

  // void verifyToken() async {
  //   final time = Stopwatch();
  //   time.start();
  //   isVerified = await Get.find<AuthController>().previouslyLoggedIn();

  //   if (time.elapsed < Duration(seconds: 2)) {
  //     await Future.delayed(Duration(seconds: 2) - time.elapsed);
  //   }

  //   if (isVerified) {
  //     Get.offAll(() => App());
  //   } else {
  //     Get.offAll(() => Onboard());
  //   }
  // }
}
