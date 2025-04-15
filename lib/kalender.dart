import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class KalenderPendidikanPage extends StatefulWidget {
  const KalenderPendidikanPage({super.key});

  @override
  State<KalenderPendidikanPage> createState() => _KalenderPendidikanPageState();
}

class _KalenderPendidikanPageState extends State<KalenderPendidikanPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedMonth = DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now());

  final Map<String, List<Map<String, dynamic>>> _kalenderPendidikan = {
    'Juli 2024': [
      {'tanggal': 1, 'keterangan': 'Persiapan Tahun Ajaran Baru', 'type': 'event_sekolah'},
      {'tanggal': 15, 'keterangan': 'Hari Pertama Masuk Sekolah', 'type': 'event_sekolah'},
    ],
    'Agustus 2024': [
      {'tanggal': 17, 'keterangan': 'Hari Kemerdekaan Indonesia', 'type': 'libur_nasional'},
    ],
    'September 2024': [
      {'tanggal': 25, 'keterangan': 'Ujian Tengah Semester (UTS)', 'type': 'event_sekolah'},
    ],
    'Oktober 2024': [
      {'tanggal': 2, 'keterangan': 'Hari Batik Nasional', 'type': 'event_sekolah'},
      {'tanggal': 28, 'keterangan': 'Hari Sumpah Pemuda', 'type': 'event_sekolah'},
    ],
    'November 2024': [
      {'tanggal': 10, 'keterangan': 'Hari Pahlawan', 'type': 'event_sekolah'},
    ],
    'Desember 2024': [
      {'tanggal': 20, 'keterangan': 'Libur Semester Ganjil', 'type': 'event_sekolah'},
      {'tanggal': 25, 'keterangan': 'Hari Natal', 'type': 'libur_nasional'},
    ],
    'Januari 2025': [
      {'tanggal': 1, 'keterangan': 'Tahun Baru 2025', 'type': 'libur_nasional'},
      {'tanggal': 27, 'keterangan': 'Isra Mikraj Nabi Muhammad SAW', 'type': 'hari_besar_islam'},
    ],
    'Februari 2025': [
      {'tanggal': 14, 'keterangan': 'Malam Nisfu Syaban', 'type': 'hari_besar_islam'},
    ],
    'Maret 2025': [
      {'tanggal': 1, 'keterangan': 'Awal Ramadhan', 'type': 'hari_besar_islam'},
      {'tanggal': 29, 'keterangan': 'Hari Nyepi', 'type': 'libur_nasional'},
      {'tanggal': 31, 'keterangan': 'Hari Raya Idul Fitri', 'type': 'hari_besar_islam'},
    ],
    'April 2025': [
      {'tanggal': 1, 'keterangan': 'Hari Raya Idul Fitri', 'type': 'hari_besar_islam'},
      {'tanggal': 18, 'keterangan': 'Wafat Yesus Kristus', 'type': 'libur_nasional'},
    ],
    'Mei 2025': [
      {'tanggal': 1, 'keterangan': 'Hari Buruh', 'type': 'libur_nasional'},
      {'tanggal': 12, 'keterangan': 'Hari Raya Waisak', 'type': 'libur_nasional'},
    ],
    'Juni 2025': [
      {'tanggal': 1, 'keterangan': 'Hari Lahir Pancasila', 'type': 'libur_nasional'},
      {'tanggal': 6, 'keterangan': 'Hari Raya Idul Adha', 'type': 'hari_besar_islam'},
      {'tanggal': 27, 'keterangan': 'Tahun Baru Islam', 'type': 'hari_besar_islam'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Kalender Pendidikan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMonth,
              items: _kalenderPendidikan.keys.map((bulan) {
                return DropdownMenuItem(
                  value: bulan,
                  child: Text(
                    bulan,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value!;
                  _focusedDay = DateFormat('MMMM yyyy', 'id_ID').parse(_selectedMonth);
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TableCalendar(
              firstDay: DateTime(2024, 7, 1),
              lastDay: DateTime(2025, 6, 30),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedMonth = DateFormat('MMMM yyyy', 'id_ID').format(focusedDay);
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _selectedMonth = DateFormat('MMMM yyyy', 'id_ID').format(focusedDay);
                });
              },
              headerVisible: false,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  String monthKey = DateFormat('MMMM yyyy', 'id_ID').format(date);
                  List<Map<String, dynamic>>? eventsForMonth = _kalenderPendidikan[monthKey];

                  Color? markerColor;
                  if (eventsForMonth != null) {
                    for (var event in eventsForMonth) {
                      if (event['tanggal'] == date.day) {
                        markerColor = event['type'] == 'libur_nasional'
                            ? Colors.red
                            : event['type'] == 'hari_besar_islam'
                                ? Colors.green
                                : Colors.blue[900];
                      }
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.all(3),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSameDay(date, today)
                          ? Colors.grey
                          : markerColor ?? Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: markerColor == null ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: _kalenderPendidikan[_selectedMonth]?.map((event) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: event['type'] == 'libur_nasional'
                              ? Colors.red.shade100
                              : event['type'] == 'hari_besar_islam'
                                  ? Colors.green.shade100
                                  : Colors.blue[900]!.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${event['tanggal']} - ${event['keterangan']}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList() ??
                    [const Center(child: Text('Tidak ada keterangan untuk bulan ini.'))],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
