// lib/screens/home_screen.dart

import 'package:fit_scale/screens/developer.dart';
import 'package:fit_scale/screens/onboarding_screen.dart';
import 'package:fit_scale/screens/result_screen.dart';
import 'package:fit_scale/utility/text_style.dart';
import 'package:fit_scale/utility/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../utility/app_color.dart';

class HomeScreen extends StatefulWidget {
  late String userName;
  HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- LOGIKA TETAP SAMA ---
  late RulerPickerController _ageController;
  late RulerPickerController _heightController;
  late RulerPickerController _weightController;

  double currentAge = 20;
  double currentHeight = 150;
  double currentWeight = 45;
  bool maleSelected = false;
  bool femaleSelected = false;
  String get firstName => widget.userName.split(" ")[0];

  @override
  void initState() {
    super.initState();
    _ageController = RulerPickerController(value: currentAge);
    _heightController = RulerPickerController(value: currentHeight);
    _weightController = RulerPickerController(value: currentWeight);
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 5) return 'Selamat Dini Hari';
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Future<void> _saveBmiRecord(double bmiValue, String category) async {
    final prefs = await SharedPreferences.getInstance();
    final String newRecord = "${DateTime.now().toIso8601String().substring(0, 10)}|"
        "${bmiValue.toStringAsFixed(1)}|"
        "$category|"
        "${currentHeight.toStringAsFixed(0)}|"
        "${currentWeight.toStringAsFixed(1)}";
    final List<String> history = prefs.getStringList('bmi_history') ?? [];
    history.add(newRecord);
    await prefs.setStringList('bmi_history', history);
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 16) return 'Severe Thinness';
    else if (bmi < 17) return 'Moderate Thinness';
    else if (bmi < 18.5) return 'Mild Thinness';
    else if (bmi < 25) return 'Normal';
    else if (bmi < 30) return 'Overweight';
    else if (bmi < 35) return 'Obese Class I';
    else if (bmi < 40) return 'Obese Class II';
    else return 'Obese Class III';
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'change_name':
        Navigator.push(context, MaterialPageRoute(builder: (_) => OnboardingScreen()));
        break;
      case 'theme':
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        break;
      case 'developer':
        Navigator.push(context, MaterialPageRoute(builder: (_) => Developer()));
        break;
    }
  }

  // --- UI REFINED (Penyempurnaan Kode Lama) ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("NutriFit", style: AppTextStyle.appBar(context).copyWith(fontWeight: FontWeight.bold)),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: _onMenuSelected,
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'change_name', child: Text('Ubah Nama')),
                const PopupMenuItem(value: 'theme', child: Text('Ubah Tema')),
                const PopupMenuItem(value: 'developer', child: Text('Pengembang')),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildGenderAgeSection(),
          const SizedBox(height: 12),
          _buildMeasurementCard('Tinggi', 'cm', currentHeight, _heightController, _onHeightChanged, 'assets/images/heighting.png'),
          const SizedBox(height: 12),
          _buildMeasurementCard('Berat', 'kg', currentWeight, _weightController, _onWeightChanged, 'assets/images/weighting.png', isDecimal: true),
          const SizedBox(height: 15),
          _buildCalculateButton(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi $firstName! 👋", style: AppTextStyle.appBar(context, fontSize: 24).copyWith(fontWeight: FontWeight.bold)),
              Text(getGreeting(), style: AppTextStyle.appBar(context, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderAgeSection() {
    return Expanded(
      flex: 7, // Ditingkatkan sedikit agar kotak umur lebih lega
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            _buildGenderSelector(),
            const SizedBox(width: 12),
            _buildAgeSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Memastikan konten di tengah
          children: [
            Text("Gender", style: AppTextStyle.paragraph(context, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGenderOption('Male', maleSelected, 'assets/images/male.png', 'assets/images/maleBlack.png', () {
                  setState(() { maleSelected = true; femaleSelected = false; });
                }),
                const VerticalDivider(color: Colors.grey, thickness: 1, indent: 10, endIndent: 10),
                _buildGenderOption('Female', femaleSelected, 'assets/images/female.png', 'assets/images/femaleBlack.png', () {
                  setState(() { femaleSelected = true; maleSelected = false; });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, bool isSelected, String selectedImg, String unselectedImg, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(isSelected ? selectedImg : unselectedImg, height: 50),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyle.paragraph(context, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildAgeSelector() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Pusatkan secara vertikal
          children: [
            Text("Umur", style: AppTextStyle.paragraph(context, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('${currentAge.toInt()}', style: AppTextStyle.paragraph(context, fontSize: 28, fontWeight: FontWeight.bold)),
            // Tinggi ruler dikunci agar tidak menyebabkan overflow
            SizedBox(
              height: 65, 
              child: _buildRulerPicker(_ageController, _onAgeChanged)
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementCard(String title, String unit, double value, RulerPickerController controller, Function(double) onChange, String imagePath, {bool isDecimal = false}) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(imagePath, height: 60),
                    const SizedBox(height: 5),
                    Text(title, style: AppTextStyle.paragraph(context, fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${value.toStringAsFixed(isDecimal ? 1 : 0)} $unit', 
                        style: AppTextStyle.paragraph(context, fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    SizedBox(height: 60, child: _buildRulerPicker(controller, onChange, isDecimal: isDecimal, isHeight: title == 'Tinggi')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRulerPicker(RulerPickerController controller, Function(double) onChange, {bool isDecimal = false, bool isHeight = false}) {
    return RulerPicker(
      controller: controller,
      rulerBackgroundColor: Colors.transparent,
      onBuildRulerScaleText: (index, value) => "",
      ranges: [RulerRange(begin: isHeight ? 100 : 1, end: isHeight ? 220 : 200, scale: isDecimal ? 0.1 : 1)],
      scaleLineStyleList: [
        const ScaleLineStyle(color: Colors.grey, width: 2, height: 25, scale: 0),
        ScaleLineStyle(color: Colors.grey.withOpacity(0.8), width: 1, height: 15, scale: -1),
      ],
      onValueChanged: (value) => onChange(value.toDouble()),
      width: 150,
      height: 60,
      marker: Container(
        width: 4,
        height: 35,
        decoration: BoxDecoration(color: AppColor.red, borderRadius: BorderRadius.circular(5))
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 2,
            ),
            onPressed: () async {
              final double heightInMeters = currentHeight / 100;
              final bmiValue = currentWeight / (heightInMeters * heightInMeters);
              final category = _getBmiCategory(bmiValue);
              await _saveBmiRecord(bmiValue, category);

              if (!mounted) return;
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScreen(
                userName: firstName, gender: maleSelected ? 'Male' : 'Female', age: currentAge.toStringAsFixed(0),
                height: currentHeight.toStringAsFixed(0), weight: currentWeight.toStringAsFixed(1),
                bmi: bmiValue.toStringAsFixed(1),
              )));
            },
            child: Text('Menghitung', style: AppTextStyle.paragraph(context, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ),
    );
  }

  void _onAgeChanged(double value) => setState(() => currentAge = value);
  void _onHeightChanged(double value) => setState(() => currentHeight = value);
  void _onWeightChanged(double value) => setState(() => currentWeight = value);
}