import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jurnee/controllers/auth_controller.dart';
import 'package:jurnee/utils/app_colors.dart';
import 'package:jurnee/utils/app_texts.dart';
import 'package:jurnee/utils/custom_snackbar.dart';
import 'package:jurnee/utils/custom_svg.dart';
import 'package:jurnee/utils/get_location.dart';
import 'package:jurnee/views/base/custom_button.dart';
import 'package:jurnee/views/base/custom_checkbox.dart';
import 'package:jurnee/views/base/custom_text_field.dart';
import 'package:jurnee/views/screens/auth/cant_access_app.dart';
import 'package:jurnee/views/screens/auth/forgot_password.dart';
import 'package:jurnee/views/screens/auth/register.dart';
import 'package:jurnee/views/screens/home/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailCtrl = TextEditingController(text: "alphabytes.gpt@gmail.com");
  final passCtrl = TextEditingController(text: "12345678");

  bool agreedTerms = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await isUserInCalifornia()) {
        Get.offAll(() => CantAccessApp());
      }
    });
  }

  void onSubmit() async {
    if (!agreedTerms) {
      customSnackBar(
        "You must accept the Terms and Conditions and Privacy Policy to proceed",
      );
      return;
    }
    final auth = Get.find<AuthController>();

    final message = await auth.login(emailCtrl.text, passCtrl.text);

    if (message == "success") {
      Get.offAll(() => Home(), routeName: "/app");
    } else {
      customSnackBar(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
                const SizedBox(height: 100),
                Text("You must login first!", style: AppTexts.dxsb),
                const SizedBox(height: 24),
                CustomTextField(
                  title: "Email",
                  hintText: "Enter your email",
                  controller: emailCtrl,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  title: "Password",
                  hintText: "Enter your password",
                  controller: passCtrl,
                  isPassword: true,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ForgotPassword(email: emailCtrl.text));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: AppTexts.tsms.copyWith(
                      color: AppColors.green.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CustomCheckBox(
                      value: agreedTerms,
                      size: 24,
                      activeColor: AppColors.green.shade600,
                      inactiveColor: Color(0xffe6e6e6),
                      onChanged: (val) {
                        setState(() {
                          agreedTerms = val;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "I've read and agree with the ",
                          style: AppTexts.txsr.copyWith(
                            color: Color(0xff808080),
                          ),
                          children: [
                            TextSpan(
                              text: "Terms and Conditions",
                              style: AppTexts.txsb.copyWith(
                                color: AppColors.green.shade600,
                              ),
                            ),
                            TextSpan(text: " and the "),
                            TextSpan(
                              text: "Privacy Policy",
                              style: AppTexts.txsb.copyWith(
                                color: AppColors.green.shade600,
                              ),
                            ),
                            TextSpan(text: "."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() {
                  return CustomButton(
                    onTap: onSubmit,
                    isLoading: Get.find<AuthController>().isLoading.value,
                    text: "Login",
                    isDisabled: !agreedTerms,
                  );
                }),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: AppTexts.txsr.copyWith(color: Color(0xff808080)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Register());
                      },
                      child: Text(
                        " Register now ",
                        style: AppTexts.txsb.copyWith(
                          color: AppColors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  height: 0.5,
                  width: double.infinity,
                  color: Color(0xffe6e6e6),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    "Or continue with",
                    style: AppTexts.txsr.copyWith(color: Color(0xff808080)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CustomSvg(asset: "assets/icons/google.svg"),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: CustomSvg(asset: "assets/icons/apple.svg"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
