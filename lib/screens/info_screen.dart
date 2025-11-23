import 'package:flutter/material.dart';
import '../utility/app_color.dart';
import '../utility/text_style.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Aplikasi FitScale',
                style: AppTextStyle.appName(context, fontSize: 30),
              ),
              const SizedBox(height: 20),
              Text(
                'FitScale adalah Kalkulator BMI (Body Mass Index) yang sederhana dan mudah digunakan. Aplikasi ini dikembangkan untuk membantu Anda melacak status kesehatan berdasarkan Tinggi dan Berat Badan.',
                textAlign: TextAlign.center,
                style: AppTextStyle.paragraph(context, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Text(
                'Versi: 1.0.0 (Flutter)',
                style: AppTextStyle.paragraph(context, colorLight: AppColor.black54),
              ),
              // Tambahkan info lain di sini jika perlu
            ],
          ),
        ),
      ),
    );
  }
}