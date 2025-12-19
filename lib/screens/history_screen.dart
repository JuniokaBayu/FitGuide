import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utility/app_color.dart';
import '../utility/text_style.dart';

class BmiRecord {
  final String date;
  final String bmi;
  final String category;
  final String height; // Tambahan
  final String weight; // Tambahan

  BmiRecord(this.date, this.bmi, this.category, this.height, this.weight);
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<BmiRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBmiHistory();
  }

  Future<void> _loadBmiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList('bmi_history') ?? [];
    
    // 1. Konversi ke List Objek
    List<BmiRecord> loadedRecords = history.map((recordString) {
      final parts = recordString.split('|');
      final rawDate = DateTime.parse(parts[0]);
      final formattedDate = DateFormat('dd MMM yyyy').format(rawDate);
      
      return BmiRecord(
        formattedDate, 
        parts[1], 
        parts[2],
        parts.length > 3 ? parts[3] : "-", // Ambil Tinggi jika ada
        parts.length > 4 ? parts[4] : "-", // Ambil Berat jika ada
      );
    }).toList();

    // 2. Urutkan dari yang terbaru (Descending)
    loadedRecords = loadedRecords.reversed.toList();

    // 3. LIMIT: Hanya ambil 10 data pertama (Terbaru)
    if (loadedRecords.length > 10) {
      loadedRecords = loadedRecords.sublist(0, 10);
    }
    
    setState(() {
      _records = loadedRecords;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
            title: Text("10 Riwayat Terakhir", style: AppTextStyle.appBar(context)),
            floating: true,
            pinned: true,
            elevation: 0,
          ),
          _isLoading
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              : _records.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "Belum ada riwayat BMI tersimpan.",
                          style: AppTextStyle.paragraph(context),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.only(bottom: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final record = _records[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(record.date, style: AppTextStyle.paragraph(context, fontSize: 13, colorLight: AppColor.black54)),
                                        Text(record.category, style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: record.category == "Normal" ? Colors.green : Colors.orange
                                        )),
                                      ],
                                    ),
                                    const Divider(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildInfoColumn("BMI", record.bmi, context),
                                        _buildInfoColumn("Tinggi", "${record.height} cm", context),
                                        _buildInfoColumn("Berat", "${record.weight} kg", context),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          childCount: _records.length,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyle.paragraph(context, fontSize: 12, colorLight: AppColor.black54)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyle.paragraph(context, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}