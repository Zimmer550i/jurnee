import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/search_widget.dart';

class Homepage extends StatefulWidget {
  final bool showMap;
  const Homepage({super.key, this.showMap = false});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int tab = 0;
  bool searchEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.scaffoldBG,
                surfaceTintColor: Colors.transparent,
                titleSpacing: 0,
                title: Row(
                  children: [
                    const SizedBox(width: 24),
                    CustomSvg(asset: "assets/icons/logo.svg"),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          searchEnabled = true;
                        });
                      },
                      child: CustomSvg(asset: "assets/icons/search.svg"),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tabs("All", null, 0),
                    tabs("Events", "assets/icons/calendar.svg", 1),
                    tabs("Deals", "assets/icons/price_tag.svg", 2),
                    tabs("Services", "assets/icons/info.svg", 3),
                    tabs("Alerts", "assets/icons/wrench.svg", 4),
                  ],
                ),
              ),

              Container(
                width: double.infinity,
                height: 1,
                color: AppColors.gray.shade200,
              ),
              widget.showMap
                  ? Expanded(
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(37.42796133580664, -122.085749655962),
                          zoom: 14.4746,
                        ),
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    for (int i = 0; i < 10; i++)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 20,
                                        ),
                                        child: PostCard(),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          if (searchEnabled)
            Column(
              children: [
                if (searchEnabled) SearchWidget(),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchEnabled = false;
                      });
                    },
                    child: Container(
                      color: AppColors.black.withValues(alpha: 0.37),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget tabs(String title, String? icon, int index) {
    bool isSelected = index == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          tab = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(
          vertical: 6,
          horizontal: isSelected ? 16 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green.shade600 : Colors.white,
          border: isSelected
              ? null
              : Border.all(color: AppColors.gray.shade300),
          borderRadius: BorderRadius.circular(27),
        ),
        child: Row(
          spacing: 4,
          children: [
            if (icon != null) CustomSvg(asset: icon),
            Text(
              title,
              style: AppTexts.txsm.copyWith(color: AppColors.gray.shade500),
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.white),
        child: Column(
          children: [
            SizedBox(
              height: 184,
              width: double.infinity,
              child: Image.asset(
                "assets/images/sample_image.jpg",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 124,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cozy Coffee Spot",
                      style: AppTexts.dxss.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),

                    Row(
                      spacing: 4,
                      children: [
                        CustomSvg(asset: "assets/icons/location.svg"),
                        Text(
                          "2.3 miles",
                          style: AppTexts.tsmm.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                        Container(),
                        CustomSvg(asset: "assets/icons/star.svg"),
                        Text(
                          "4.9",
                          style: AppTexts.tsmm.copyWith(
                            color: AppColors.gray.shade600,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      "Shop our summer collection of dresses, now 50% off. Free delivery within 10 miles and 24/7 customer service...",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTexts.tsmr.copyWith(
                        color: AppColors.gray.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
