import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:jurnee/firebase_options.dart';
import 'package:jurnee/themes/light_theme.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_constants.dart';
import 'package:jurnee/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jurnee/views/screens/auth/splash.dart';
import 'controllers/localization_controller.dart';
import 'controllers/theme_controller.dart';
import 'helpers/di.dart' as di;
import 'helpers/route.dart';

bool _mobileAdsInitialized = false;

Future<void> _ensureMobileAdsInitialized() async {
  if (_mobileAdsInitialized) return;
  await MobileAds.instance.initialize();
  _mobileAdsInitialized = true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await _ensureMobileAdsInitialized();
  // await MobileAds.instance.updateRequestConfiguration(
  //   RequestConfiguration(testDeviceIds: ['5d5be013ce0959eae5547111446cf6f6']),
  // );
  await dotenv.load(fileName: ".env");
  Map<String, Map<String, String>> languages = await di.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.green[600],
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});
  final Map<String, Map<String, String>> languages;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: AppConstants.APP_NAME,
              debugShowCheckedModeBanner: false,
              // theme: themeController.darkTheme ? dark() : light(),
              theme: light(),
              defaultTransition: Transition.cupertino,
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode,
                AppConstants.languages[0].countryCode,
              ),
              transitionDuration: const Duration(milliseconds: 500),
              getPages: AppRoutes.pages,
              // initialRoute: AppRoutes.splash,
              home: Splash(),
            );
          },
        );
      },
    );
  }
}
