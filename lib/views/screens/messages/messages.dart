import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_texts.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Messages Screen", style: AppTexts.txlm));
  }
}
