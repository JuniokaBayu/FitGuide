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

class HomeScreen extends StatefulWidget{
  late String userName;

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
    
    // UBAH FORMAT: Sekarang kita simpan "TGL|BMI|KATEGORI|TINGGI|BERAT"
    // Gunakan pemisah '|' untuk memudahkan pembacaan nanti
    final String newRecord = "${DateTime.now().toIso8601String().substring(0, 10)}|"
        "${bmiValue.toStringAsFixed(1)}|"
        "$category|"
        "${currentHeight.toStringAsFixed(0)}|" // Simpan Tinggi
        "${currentWeight.toStringAsFixed(1)}"; // Simpan Berat
    
    final List<String> history = prefs.getStringList('bmi_history') ?? [];
    
    history.add(newRecord);
    
    await prefs.setStringList('bmi_history', history);
  }

  // Tambahkan fungsi untuk mendapatkan kategori BMI
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
      Navigator.push(context, MaterialPageRoute(builder: (_)=>OnboardingScreen()));
        break;
      case 'theme':
        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        break;
      case 'developer':
        Navigator.push(context, MaterialPageRoute(builder: (_)=>Developer()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
       title: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text("NutriFit", style: AppTextStyle.appBar(context)),
           PopupMenuButton<String>(
             icon: const Icon(Icons.more_vert),
             onSelected: _onMenuSelected,
             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
               const PopupMenuItem<String>(value: 'change_name', child: Text('Ubah Nama')),
               const PopupMenuItem<String>(value: 'theme', child: Text('Ubah Tema')),
               const PopupMenuItem<String>(value: 'developer', child: Text('Pengembang')),
             ],
           ),
         ],
       ),
     ),
     body: Container(
         color: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
         child: Column(
           children: [
             _buildHeader(),
             _buildGenderAgeSection(),
             const SizedBox(height: 10),
             _buildMeasurementCard('Tinggi', 'cm', currentHeight, _heightController, _onHeightChanged, 'assets/images/heighting.png'),
             const SizedBox(height: 10),
             _buildMeasurementCard('Berat', 'kg', currentWeight, _weightController, _onWeightChanged, 'assets/images/weighting.png', isDecimal: true),
             const SizedBox(height: 10),
             _buildCalculateButton(),
             const SizedBox(height: 10),
           ],
         )),

   );
  }

  Widget _buildHeader() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hi $firstName!👋", style: AppTextStyle.appBar(context, fontSize: 23)),
              Text(getGreeting(), style: AppTextStyle.appBar(context, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderAgeSection() {
    return Expanded(
      flex: 6,
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              _buildGenderSelector(),
              const SizedBox(width: 10),
              _buildAgeSelector(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color:  AppColor.buttonColor(context, dark: AppColor.extraLightBlack), borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Expanded(flex: 1, child: Center(child: Text("Gender", style: AppTextStyle.paragraph(context, fontSize: 30, fontWeight: FontWeight.w600, colorLight: AppColor.black87, colorDark: AppColor.darkWhite)))),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  _buildGenderOption('Male', maleSelected, 'assets/images/male.png', 'assets/images/maleBlack.png', () {
                    setState(() {
                      maleSelected = true;
                      femaleSelected = false;
                    });
                  }),
                  const VerticalDivider(color: Colors.grey, thickness: 1, indent: 25, endIndent: 25),
                  _buildGenderOption('Female', femaleSelected, 'assets/images/female.png', 'assets/images/femaleBlack.png', () {
                    setState(() {
                      femaleSelected = true;
                      maleSelected = false;
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(String label, bool isSelected, String selectedImg, String unselectedImg, VoidCallback onTap) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(isSelected ? selectedImg : unselectedImg, height: 60),
            Text(label, style: AppTextStyle.paragraph(context, fontSize: 16, fontWeight: FontWeight.w500, colorLight: AppColor.black87, colorDark: AppColor.darkWhite)),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeSelector() {
    return Expanded(
      flex: 1,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color:  AppColor.buttonColor(context, dark: AppColor.extraLightBlack), borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 2, child: Center(child: Text("Umur", style: AppTextStyle.paragraph(context, fontSize: 30, fontWeight: FontWeight.w600, colorLight: AppColor.black87, colorDark: AppColor.darkWhite)))),
            Expanded(flex: 3, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${currentAge.toStringAsFixed(0)}', style: AppTextStyle.paragraph(context, fontSize: 30, fontWeight: FontWeight.bold, colorLight: AppColor.black54, colorDark: AppColor.white)
                  ),
                  _buildRulerPicker(_ageController, _onAgeChanged),
                ],
              ),
            )),
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
          width: double.infinity,
          decoration: BoxDecoration(color:  AppColor.buttonColor(context, dark: AppColor.extraLightBlack), borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(imagePath, height: 90),
                    Text(title, style: AppTextStyle.paragraph(context, fontSize: 22, fontWeight: FontWeight.w500, colorLight: AppColor.black87, colorDark: AppColor.darkWhite))
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Text('${value.toStringAsFixed(isDecimal ? 1 : 0)} ${title == 'Tinggi' ? 'cm' : unit}', // UBAH: Tambahkan logika unit untuk Tinggi
                      style: AppTextStyle.paragraph(context, fontSize: 30, fontWeight: FontWeight.bold, colorLight: AppColor.black54, colorDark: AppColor.white)
                    ),
                    _buildRulerPicker(controller, onChange, isDecimal: isDecimal, isHeight: title == 'Tinggi'), // UBAH: Kirim flag isHeight
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRulerPicker(RulerPickerController controller, Function(double) onChange, {bool isDecimal = false, bool isHeight = false  }) {
    return RulerPicker(
      controller: controller,
      rulerBackgroundColor: Colors.transparent,
      onBuildRulerScaleText: (index, value) {
        return "";
      },
      ranges: [
        // UBAH: Jika Tinggi (Height), gunakan rentang yang lebih besar (misal 100-220 cm)
        RulerRange(begin: isHeight ? 100 : 1, end: isHeight ? 220 : 200, scale: isDecimal ? 0.1 : 1),
      ],
      scaleLineStyleList: [
        ScaleLineStyle(color: Colors.grey.shade900, width: 2, height: 30, scale: 0),
        ScaleLineStyle(color: Colors.grey.shade700, width: 1.5, height: 25, scale: 5),
        ScaleLineStyle(color: Colors.grey.shade400, width: 1.5, height: 15, scale: -1),
      ],
      onValueChanged: (value) => onChange(value.toDouble()),
      width: 155,
      height: 70,
      rulerMarginTop: 8,
      marker: Container(
        width: 6,
        height: 50,
          decoration: BoxDecoration(color:  AppColor.buttonColor(context, dark: AppColor.red, light: Colors.black.withAlpha(100)), borderRadius: BorderRadius.circular(5))
      ),
    );
  }

  void _onAgeChanged(double value) => setState(() => currentAge = value);
  void _onHeightChanged(double value) => setState(() => currentHeight = value);
  void _onWeightChanged(double value) => setState(() => currentWeight = value);

  Widget _buildCalculateButton() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
              foregroundColor: Colors.black87,
            ),
           

            onPressed: () async { // UBAH: Jadikan async
              final gender = maleSelected ? 'Male' : (femaleSelected ? 'Female' : '');
              final double heightInMeters = currentHeight / 100;
              final bmiValue = currentWeight / (heightInMeters * heightInMeters);
                          
             // SIMPAN RIWAYAT SEBELUM NAVIGASI
             final category = _getBmiCategory(bmiValue);
             await _saveBmiRecord(bmiValue, category);
             // END SIMPAN RIWAYAT

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultScreen(
                    userName: firstName,
                    gender: gender,
                    age: currentAge.toStringAsFixed(0),
                    height: currentHeight.toStringAsFixed(0),
                    weight: currentWeight.toStringAsFixed(1),
                    bmi: bmiValue.toStringAsFixed(1), // Kirim nilai bmiValue
                  ),
                ),
              );
            },

            child: Text('Menghitung', style: AppTextStyle.paragraph(context, colorDark: AppColor.white)),
          ),
        ),
      ),
    );
  }  
}

