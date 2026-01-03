import 'package:flutter/material.dart';
import '../utility/app_color.dart';
import '../utility/text_style.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background(
        context,
        light: AppColor.creamLight,
        dark: AppColor.darkBlack,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- ICON BULAT ---
              Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite,
                  size: 45,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 30),

              // --- JUDUL ---
              Text(
                'Aplikasi NutriFit',
                style: AppTextStyle.appName(context, fontSize: 32),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // --- GARIS PEMBATAS TIPIS ---
              Container(
                height: 3,
                width: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'NutriFit adalah kalkulator BMI (Body Mass Index) yang praktis dan mudah dipakai. '
                'Aplikasi ini saya buat untuk membantu Anda mengecek kondisi kesehatan berdasarkan '
                'tinggi serta berat badan, sehingga Anda bisa lebih memahami tubuh Anda dan memulai '
                'kebiasaan hidup yang lebih sehat.',
                style: AppTextStyle.paragraph(context, fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 35),

              Text(
                'Versi 1.0.0',
                style: AppTextStyle.paragraph(context, fontSize: 13).copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
