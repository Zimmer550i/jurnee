import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/maps_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/views/base/custom_text_field.dart';

class LocationPicker extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const LocationPicker({
    super.key,
    this.title = "Location",
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Inject the controller
    // If you have two pickers (pickup & dropoff), consider using tag: 'pickup'
    final MapsController mapCtrl = Get.put(MapsController());

    return Column(
      spacing: 8,
      children: [
        CustomTextField(
          controller: controller,
          onChanged: (val) {
            // Update the reactive variable in the controller
            mapCtrl.onSearchChanged(val);
          },
          title: title,
          hintText: "Select location",
          trailing: "assets/icons/location.svg",
        ),

        // Reactive UI update
        Obx(() {
          if (mapCtrl.predictions.isEmpty) return const SizedBox.shrink();

          return Column(
            children: mapCtrl.predictions.map((prediction) {
              return GestureDetector(
                onTap: () {
                  mapCtrl.selectPrediction(prediction, controller);
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8), // specific spacing
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray.shade100),
                  ),
                  child: Text(
                    prediction.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}