import 'package:fit_scale/utility/app_color.dart';
import 'package:flutter/material.dart';
import '../utility/text_style.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: AppColor.background(context, light: AppColor.creamLight),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // LOGO dengan shadow elegan
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Image.asset('assets/images/logo.png', height: 200),
          ),

          const SizedBox(height: 30),

          Text(
            'NutriFit',
            style: AppTextStyle.appName(context, fontSize: 32),
          ),

          const SizedBox(height: 25),

          Text(
            'Kesehatan Anda itu berharga. NutriFit hadir untuk membantu Anda mengenal kondisi tubuh dengan cara yang sederhana. Cukup beberapa ketukan, Anda bisa mengecek BMI, memantau kebugaran, dan mulai mengarahkan diri menuju gaya hidup yang lebih sehat.',
            textAlign: TextAlign.center,
            style: AppTextStyle.paragraph(context, fontSize: 16),
          ),

          const SizedBox(height: 35),

          // Highlight
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.background(
                context,
                light: Colors.white.withOpacity(0.6),
                dark: AppColor.darkBlack,
              ),
            ),
            child: Text(
              "Mari kita mulai 💪",
              style: AppTextStyle.paragraph(
                context,
                colorLight: AppColor.lightBlack,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
