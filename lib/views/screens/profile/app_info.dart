import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:jurnee/views/base/custom_app_bar.dart';

class AppInfo extends StatelessWidget {
  final String title;
  const AppInfo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          // const SizedBox(height: 24,),
          Html(data: 
          """<div style="font-family: Arial, sans-serif; padding: 16px; line-height: 1.6; color: #333;">
  
  <h2 style="color: #2563eb; display: flex; align-items: center;">
    &#128221; Privacy Policy
  </h2>
  <p style="color: #555; margin: 0 0 12px;">
    This section is a <strong>placeholder</strong>. In production, the Admin will upload the official 
    <strong>Privacy Policy</strong> from the Admin Dashboard. Once updated, this text will be replaced automatically.
  </p>

  <h2 style="color: #2563eb; display: flex; align-items: center;">
    &#128196; Terms of Service
  </h2>
  <p style="color: #555; margin: 0 0 12px;">
    These Terms of Service are <strong>sample content</strong>. In production, the Admin will provide the 
    official Terms of Service via the Admin Dashboard. All updates will appear here.
  </p>

  <h2 style="color: #2563eb; display: flex; align-items: center;">
    &#128100; About Us
  </h2>
  <p style="color: #555; margin: 0 0 12px;">
    The <strong>About Us</strong> page currently contains demo information. In production, the Admin will update this 
    section with real company or app details, and the content will be reflected here.
  </p>

  <h2 style="color: #2563eb; display: flex; align-items: center;">
    &#128272; Community Guidelines
  </h2>
  <p style="color: #555; margin: 0;">
    The Community Guidelines shown here are <strong>temporary placeholders</strong>. Once the Admin uploads the 
    official guidelines in the Admin Dashboard, they will replace this text.
  </p>

  <p style="margin-top: 20px; font-size: 14px; color: #777;">
    &#9888; <em>Note:</em> All above sections are placeholder data. The Admin will upload and maintain 
    the official versions through the Admin Dashboard.
  </p>
</div>
""")
        ]),
      ),
    );
  }
}
