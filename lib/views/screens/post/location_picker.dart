import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class LocationPicker extends StatefulWidget {
  final String title;
  const LocationPicker({super.key, this.title = "Location"});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final ctrl = TextEditingController();
  bool showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        CustomTextField(
          controller: ctrl,
          onChanged: (val) {
            setState(() {
              if (val == "") {
                showSuggestions = false;
              } else {
                showSuggestions = true;
              }
            });
          },
          title: widget.title,
          hintText: "Select location",
          trailing: "assets/icons/location.svg",
        ),

        if (showSuggestions)
          for (int i = 0; i < 5; i++)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray.shade100),
              ),
              child: Text("Location Suggestion ${i + 1}"),
            ),
      ],
    );
  }
}
