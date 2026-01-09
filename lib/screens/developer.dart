import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utility/app_color.dart';
import '../utility/text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Developer extends StatelessWidget {
  const Developer({super.key});

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
      appBar: AppBar(
        backgroundColor:
            AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
        elevation: 0,
        title: Text(
          "Developer",
          style: AppTextStyle.paragraph(
            context,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            colorLight: AppColor.lightBlack,
            colorDark: AppColor.white,
          ),
        ),
      ),

      body: Container(
        width: double.infinity,
        color: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),

            child: Container(
              width: 360,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile image
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.borderColor(context,
                            light: AppColor.border, dark: AppColor.lightWhite),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/profil.jpg'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Name
                  Text(
                    "Junioka Bayu G",
                    style: AppTextStyle.paragraph(
                      context,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      colorLight: AppColor.lightBlack,
                      colorDark: AppColor.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Description
                  Text(
                    "Hi, Saya Oka Bayu, pengembang aplikasi Kalkulator BMI NutriFit ini.\n\n"
                    "Aplikasi ini dibuat agar pengguna dapat mengecek BMI dengan mudah, mengetahui status tubuhnya, "
                    "dan mendapatkan dorongan untuk hidup lebih sehat.",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.paragraph(
                      context,
                      fontSize: 15,
                      colorLight: AppColor.extraLightBlack,
                      colorDark: AppColor.lightWhite,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section title
                  Text(
                    "Connect with me",
                    style: AppTextStyle.paragraph(
                      context,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      colorLight: AppColor.lightBlack,
                      colorDark: AppColor.white,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Social icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _iconButton(FontAwesomeIcons.linkedinIn,
                          () => _launchURL('https://www.linkedin.com/in/junioka-bayu-gionanda-unipma/'), context),
                      SizedBox(width: 20),
                      _iconButton(FontAwesomeIcons.github,
                          () => _launchURL('https://github.com/JuniokaBayu'), context),
                      SizedBox(width: 20),
                      _iconButton(Icons.mail_outline,
                          () => _launchURL('mailto:okabayu12344@gmail.com'), context),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Copyright
                  Text(
                    "© 2025 NutriFit",
                    style: AppTextStyle.paragraph(
                      context,
                      fontSize: 14,
                      colorLight: AppColor.extraLightBlack,
                      colorDark: AppColor.lightWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2), // Padding luar untuk membungkus IconButton
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Latar belakang tombol mengikuti warna tombol aplikasi
        color: AppColor.buttonColor(context, dark: AppColor.lightBlack, light: AppColor.cream),
        border: Border.all(
          color: AppColor.borderColor(context).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: 22),
        onPressed: onTap,
        // Warna ikon otomatis menjadi Putih di Dark Mode dan Hitam/Gelap di Light Mode
        color: AppColor.paraColor(context, dark: Colors.white, light: AppColor.lightBlack),
        splashRadius: 25,
      ),
    );
  }
}
