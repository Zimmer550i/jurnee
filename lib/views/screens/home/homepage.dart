import 'package:flutter/material.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/views/base/post_card.dart';
import 'package:jurnee/views/base/search_widget.dart';
import 'package:jurnee/views/screens/home/location_map.dart';

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
                  ? LocationMap()
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
