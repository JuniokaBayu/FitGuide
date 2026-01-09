import 'package:flutter/material.dart';

import '../utility/app_color.dart';
import '../utility/text_style.dart';

class NameScreen extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const NameScreen({super.key, required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(color: AppColor.borderColor(context)),
    );

    return Scaffold(
      backgroundColor: AppColor.background(context, light: AppColor.creamLight),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                Image.asset(
                  'assets/images/HiGIF.gif',
                  height: screenHeight * 0.33,
                ),

                const SizedBox(height: 20),

                Text(
                  'Hello!',
                  style: AppTextStyle.appName(context, fontSize: 28),
                ),

                const SizedBox(height: 10),

                Text(
                  'Kami harus memanggil kamu apa?',
                  style: AppTextStyle.paragraph(context, fontSize: 18),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 35),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  decoration: BoxDecoration(
                    color: AppColor.background(
                      context,
                      light: Colors.white.withOpacity(0.6),
                      dark: AppColor.darkBlack,
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: AppColor.borderColor(context),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Nama',
                            hintStyle: AppTextStyle.paragraph(
                                context, colorDark: AppColor.extraLightBlack),
                            labelText: 'Masukkan Nama Anda',
                            labelStyle: AppTextStyle.paragraph(
                                context, colorDark: AppColor.white),
                            enabledBorder: border,
                            focusedBorder: border,
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.buttonColor(context, light: AppColor.cream),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: IconButton(
                          onPressed: onSubmit,
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 28,
                            color: AppColor.buttonColor(
                              context,
                              light: AppColor.border,
                              dark: AppColor.darkBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
