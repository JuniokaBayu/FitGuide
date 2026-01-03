// lib/screens/home_screen.dart

import 'package:fit_scale/screens/developer.dart';
import 'package:fit_scale/screens/result_screen.dart';
import 'package:fit_scale/utility/text_style.dart';
import 'package:fit_scale/utility/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ruler_picker/flutter_ruler_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../utility/app_color.dart';

class HomeScreen extends StatefulWidget {
  String userName; 
  HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  void _showChangeNameModal() {
    final TextEditingController nameController = TextEditingController(text: widget.userName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.extraLightBlack),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Ubah Nama", style: AppTextStyle.appBar(context, fontSize: 20)),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Masukkan nama baru",
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColor.red)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColor.red, width: 2)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              String newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('Name', newName);
                
                setState(() {
                  widget.userName = newName;
                });
                
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nama berhasil diperbarui")),
                );
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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
        _showChangeNameModal();
        break;
      case 'theme':
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        break;
      case 'developer':
        Navigator.push(context, MaterialPageRoute(builder: (_) => Developer()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      // --- PERBAIKAN RESPONSIVE MENGGUNAKAN SINGLECHILDSCROLLVIEW ---
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20), 
              _buildGenderAgeSection(),
              const SizedBox(height: 15),
              _buildMeasurementCard('Tinggi', 'cm', currentHeight, _heightController, _onHeightChanged, 'assets/images/tinggiBadan.png'),
              const SizedBox(height: 15),
              _buildMeasurementCard('Berat', 'kg', currentWeight, _weightController, _onWeightChanged, 'assets/images/beratBadan.png', isDecimal: true),
              const SizedBox(height: 25),
              _buildCalculateButton(),
              const SizedBox(height: 20), // Tambahan padding bawah agar tidak mepet navigation bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hi $firstName! 👋", style: AppTextStyle.appBar(context, fontSize: 24).copyWith(fontWeight: FontWeight.bold)),
          Text(getGreeting(), style: AppTextStyle.appBar(context, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildGenderAgeSection() {
    return SizedBox(
      height: 160, // Kunci tinggi agar tidak overflow ke dalam
      child: Row(
        children: [
          Expanded(child: _buildGenderSelector()),
          const SizedBox(width: 15),
          Expanded(child: _buildAgeSelector()),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Gender", style: AppTextStyle.paragraph(context, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15), 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGenderOption('Male', maleSelected, 'assets/images/male.png', 'assets/images/maleBlack.png', () {
                setState(() { maleSelected = true; femaleSelected = false; });
              }),
              _buildGenderOption('Female', femaleSelected, 'assets/images/female.png', 'assets/images/femaleBlack.png', () {
                setState(() { femaleSelected = true; maleSelected = false; });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String label, bool isSelected, String selectedImg, String unselectedImg, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(isSelected ? selectedImg : unselectedImg, height: 40), 
          const SizedBox(height: 4),
          Text(label, style: AppTextStyle.paragraph(context, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAgeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Umur", style: AppTextStyle.paragraph(context, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text('${currentAge.toInt()}', style: AppTextStyle.paragraph(context, fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 50, 
            child: _buildRulerPicker(_ageController, _onAgeChanged)
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementCard(String title, String unit, double value, RulerPickerController controller, Function(double) onChange, String imagePath, {bool isDecimal = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                Image.asset(imagePath, height: 50), 
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
                    style: AppTextStyle.paragraph(context, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                SizedBox(height: 50, child: _buildRulerPicker(controller, onChange, isDecimal: isDecimal, isHeight: title == 'Tinggi')),
              ],
            ),
          ),
        ],
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
        const ScaleLineStyle(color: Colors.grey, width: 2, height: 15, scale: 0), 
        ScaleLineStyle(color: Colors.grey.withOpacity(0.8), width: 1, height: 10, scale: -1),
      ],
      onValueChanged: (value) => onChange(value.toDouble()),
      width: 150,
      height: 50,
      marker: Container(
        width: 3,
        height: 25,
        decoration: BoxDecoration(color: AppColor.red, borderRadius: BorderRadius.circular(5))
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
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
    );
  }

  void _onAgeChanged(double value) => setState(() => currentAge = value);
  void _onHeightChanged(double value) => setState(() => currentHeight = value);
  void _onWeightChanged(double value) => setState(() => currentWeight = value);
}