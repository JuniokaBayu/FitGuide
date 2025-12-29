import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../utility/app_color.dart';
import '../utility/text_style.dart';

// Model Data BMI
class BmiRecord {
  final int originalIndex; // Indeks asli di penyimpanan untuk keperluan hapus
  final DateTime fullDate;
  final String dateStr;
  final String bmi;
  final String category;
  final String height;
  final String weight;

  BmiRecord({
    required this.originalIndex,
    required this.fullDate,
    required this.dateStr,
    required this.bmi,
    required this.category,
    required this.height,
    required this.weight,
  });
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<BmiRecord> _allRecords = [];
  List<BmiRecord> _filteredRecords = [];
  bool _isLoading = true;

  // Variabel Navigasi & Filter
  int _currentPage = 0;
  final int _pageSize = 10;
  DateTime? _selectedFilterDate;

  @override
  void initState() {
    super.initState();
    _loadBmiHistory();
  }

  Future<void> _loadBmiHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList('bmi_history') ?? [];
    
    List<BmiRecord> loaded = [];
    for (int i = 0; i < history.length; i++) {
      final parts = history[i].split('|');
      if (parts.length < 3) continue;

      try {
        final rawDate = DateTime.parse(parts[0]);
        loaded.add(BmiRecord(
          originalIndex: i, 
          fullDate: rawDate,
          dateStr: DateFormat('dd MMM yyyy').format(rawDate),
          bmi: parts[1],
          category: parts[2],
          height: parts.length > 3 ? parts[3] : "-",
          weight: parts.length > 4 ? parts[4] : "-", // Perbaikan label parameter
        ));
      } catch (e) {
        debugPrint("Error parsing data: $e");
      }
    }

    // LOGIKA SORTING TERBARU (Pasti urut terbaru di atas)
    loaded.sort((a, b) {
      // 1. Bandingkan Tanggal
      int dateComp = b.fullDate.compareTo(a.fullDate);
      if (dateComp == 0) {
        // 2. Jika tanggal sama, gunakan urutan masuk (Original Index) yang lebih besar
        return b.originalIndex.compareTo(a.originalIndex);
      }
      return dateComp;
    });

    setState(() {
      _allRecords = loaded;
      _applyFilter();
      _isLoading = false;
    });
  }

  void _applyFilter() {
    if (_selectedFilterDate == null) {
      _filteredRecords = List.from(_allRecords);
    } else {
      _filteredRecords = _allRecords.where((r) =>
          r.fullDate.month == _selectedFilterDate!.month &&
          r.fullDate.year == _selectedFilterDate!.year).toList();
    }
    _currentPage = 0; 
  }

  Future<void> _deleteRecord(BmiRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('bmi_history') ?? [];
    
    if (record.originalIndex < history.length) {
      history.removeAt(record.originalIndex);
      await prefs.setStringList('bmi_history', history);
    }
    
    _loadBmiHistory(); 
  }

  Future<void> _clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bmi_history');
    _loadBmiHistory();
  }

  List<BmiRecord> get _currentPagedRecords {
    int start = _currentPage * _pageSize;
    int end = start + _pageSize;
    if (start >= _filteredRecords.length) return [];
    return _filteredRecords.sublist(
        start, end > _filteredRecords.length ? _filteredRecords.length : end);
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (_filteredRecords.length / _pageSize).ceil();

    return Scaffold(
      backgroundColor: AppColor.background(context, light: AppColor.creamLight, dark: AppColor.darkBlack),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Riwayat NutriFit", style: AppTextStyle.appBar(context)),
        actions: [
          IconButton(icon: const Icon(Icons.filter_alt_outlined), onPressed: _showDatePickerFilter),
          if (_selectedFilterDate != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () => setState(() {
                _selectedFilterDate = null;
                _applyFilter();
              }),
            ),
          IconButton(icon: const Icon(Icons.delete_sweep, color: Colors.red), onPressed: () => _showDeleteConfirmDialog(null)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _filteredRecords.isEmpty
                      ? Center(child: Text("Data tidak ditemukan", style: AppTextStyle.paragraph(context)))
                      : ListView.builder(
                          itemCount: _currentPagedRecords.length,
                          itemBuilder: (context, index) {
                            final record = _currentPagedRecords[index];
                            // Fitur Dismissible (Hapus Geser) telah Dihapus
                            return _buildHistoryCard(record);
                          },
                        ),
                ),
                if (totalPages > 1) _buildPaginationBar(totalPages),
              ],
            ),
    );
  }

  Widget _buildHistoryCard(BmiRecord record) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.buttonColor(context, dark: AppColor.extraLightBlack),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(record.dateStr, style: AppTextStyle.paragraph(context, fontSize: 13, colorLight: AppColor.black54)),
              // Satu-satunya tombol hapus
              GestureDetector(
                onTap: () => _showDeleteConfirmDialog(record), 
                child: const Icon(Icons.close, size: 20, color: Colors.grey)
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn("BMI", record.bmi, isBold: true),
              _buildStatColumn("Tinggi", "${record.height} cm"),
              _buildStatColumn("Berat", "${record.weight} kg"),
            ],
          ),
          const SizedBox(height: 5),
          Text(record.category, style: TextStyle(
            fontSize: 12,
            color: record.category == "Normal" ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold
          )),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {bool isBold = false}) {
    return Column(
      children: [
        Text(label, style: AppTextStyle.paragraph(context, fontSize: 11, colorLight: AppColor.black54)),
        Text(value, style: AppTextStyle.paragraph(context, fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildPaginationBar(int totalPages) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(icon: const Icon(Icons.chevron_left), onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null),
          Text("Halaman ${_currentPage + 1} dari $totalPages", style: AppTextStyle.paragraph(context, fontSize: 14)),
          IconButton(icon: const Icon(Icons.chevron_right), onPressed: _currentPage < totalPages - 1 ? () => setState(() => _currentPage++) : null),
        ],
      ),
    );
  }

  void _showDatePickerFilter() async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _selectedFilterDate = picked;
        _applyFilter();
      });
    }
  }

  void _showDeleteConfirmDialog(BmiRecord? record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(record == null ? "Hapus Semua?" : "Hapus Data?"),
        content: Text(record == null ? "Hapus seluruh riwayat BMI?" : "Data ini akan dihapus secara permanen."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (record == null) {
                _clearAllHistory();
              } else {
                setState(() {
                   _filteredRecords.remove(record);
                   _allRecords.remove(record);
                });
                _deleteRecord(record);
              }
            }, 
            child: const Text("Hapus", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}