import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_texts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profile Screen", style: AppTexts.txlm));
  }
}
