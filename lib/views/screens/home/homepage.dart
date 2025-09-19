import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_texts.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Homepage Screen", style: AppTexts.txlm));
  }
}
