import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';

class CustomLoading extends StatelessWidget {
  final Color? color;
  const CustomLoading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(color: color ?? AppColors.green, strokeCap: StrokeCap.butt,),
      ),
    );
  }
}
