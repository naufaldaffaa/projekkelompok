import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  String _selectedDay = DateFormat('EEEE', 'id_ID').format(DateTime.now()); // Default hari ini
  DateTime today = DateTime.now();
  final currentTime = TimeOfDay.now();

  // Jadwal berdasarkan hari
  final Map<String, List<Map<String, dynamic>>> _jadwalPerHari = {
    'Senin': [
      {'mapel': 'Matematika', 'jam': '07:00 - 08:00'},
      {'mapel': 'Bahasa Inggris', 'jam': '08:00 - 09:00'},
      {'mapel': 'Fisika', 'jam': '09:00 - 10:00'},
      {'mapel': 'Kimia', 'jam': '10:00 - 11:00'},
      {'mapel': 'Biologi', 'jam': '11:00 - 12:00'},
    ],
    'Selasa': [
      {'mapel': 'Ekonomi', 'jam': '07:00 - 08:00'},
      {'mapel': 'Geografi', 'jam': '08:00 - 09:00'},
      {'mapel': 'Sejarah', 'jam': '09:00 - 10:00'},
      {'mapel': 'Sosiologi', 'jam': '10:00 - 11:00'},
      {'mapel': 'Kesenian', 'jam': '11:00 - 12:00'},
    ],
    'Rabu': [
      {'mapel': 'Teknologi', 'jam': '07:00 - 08:00'},
      {'mapel': 'Komputer', 'jam': '08:00 - 09:00'},
      {'mapel': 'Matematika Lanjut', 'jam': '09:00 - 10:00'},
      {'mapel': 'Fisika Lanjut', 'jam': '10:00 - 11:00'},
      {'mapel': 'Bahasa Jepang', 'jam': '11:00 - 12:00'},
    ],
    'Kamis': [
      {'mapel': 'Olahraga', 'jam': '07:00 - 08:00'},
      {'mapel': 'Kesehatan', 'jam': '08:00 - 09:00'},
      {'mapel': 'Kimia Lanjut', 'jam': '09:00 - 10:00'},
      {'mapel': 'Biologi Lanjut', 'jam': '10:00 - 11:00'},
      {'mapel': 'Bahasa Jerman', 'jam': '11:00 - 12:00'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final jadwalHariIni = _jadwalPerHari[_selectedDay] ?? [];
    final isToday = _selectedDay == DateFormat('EEEE', 'id_ID').format(today);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          'Jadwal Mengajar',
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
            // Dropdown Pilih Hari
            DropdownButtonFormField<String>(
              value: _selectedDay,
              items: _jadwalPerHari.keys.map((hari) {
                final isTodayOption = hari == DateFormat('EEEE', 'id_ID').format(today);
                return DropdownMenuItem(
                  value: hari,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: hari, // Nama hari tetap hitam
                          style: const TextStyle(color: Colors.black),
                        ),
                        if (isTodayOption)
                          const TextSpan(
                            text: ' (Hari Ini)', // Keterangan "Hari Ini" abu-abu
                            style: TextStyle(color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDay = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // List Jadwal
            Expanded(
              child: ListView.builder(
                itemCount: jadwalHariIni.length,
                itemBuilder: (context, index) {
                  final jadwal = jadwalHariIni[index];
                  final waktu = TimeOfDay(
                    hour: int.parse(jadwal['jam']!.split(':')[0]),
                    minute: int.parse(jadwal['jam']!.split(':')[1].split('-')[0]),
                  );
                  final isCompleted = isToday &&
                      (waktu.hour < currentTime.hour ||
                          (waktu.hour == currentTime.hour && waktu.minute <= currentTime.minute));

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        jadwal['mapel'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(jadwal['jam']),
                      trailing: isToday
                          ? Icon(
                              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isCompleted ? Colors.green : Colors.grey,
                            )
                          : null, // Trailing hanya muncul di hari ini
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
