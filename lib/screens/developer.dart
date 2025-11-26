import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utility/app_color.dart';
import '../utility/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Developer extends StatelessWidget {
  // Function to launch URLs
  void _launchURL(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack)),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
        child: Center(
          child: Container(
            height: 520,
            width: 350,
            decoration: BoxDecoration(
              color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(
                      'assets/images/okaBayu.jpg',
                    ), // Replace with your image path
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Junioka Bayu Gionanda",
                    style: AppTextStyle.paragraph(context, fontSize: 24, colorLight: AppColor.lightBlack, fontWeight: FontWeight.bold, colorDark: AppColor.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Hi, Saya Oka Bayu, pengembang aplikasi Kalkulator BMI NutriFit ini.\n\nAplikasi ini saya kembangkan agar pengguna dapat mengecek BMI dengan praktis, mengetahui status kesehatannya, serta mendapatkan dorongan untuk menerapkan pola hidup yang lebih bugar.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.paragraph(context, fontSize: 15, colorLight: AppColor.extraLightBlack, colorDark: AppColor.lightWhite),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Connect with me",
                    style: AppTextStyle.paragraph(context, fontSize: 18, fontWeight: FontWeight.w500, colorLight: AppColor.lightBlack, colorDark: AppColor.white),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(icon: Icon(FontAwesomeIcons.linkedinIn),
                        onPressed:() => _launchURL('https://www.linkedin.com/in/junioka-bayu-gionanda-unipma/'),
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.github),
                        onPressed:
                            () => _launchURL('https://github.com/JuniokaBayu'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.mail_outline),
                        onPressed: () => _launchURL('mailto:okabayu12344@gmail.com'),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    "© 2025 NutriFit",
                    style: AppTextStyle.paragraph(context, fontSize: 14, fontWeight: FontWeight.w400, colorLight: AppColor.extraLightBlack, colorDark: AppColor.lightWhite),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
