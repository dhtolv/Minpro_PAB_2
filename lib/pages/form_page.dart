import 'package:flutter/material.dart';
import '../models.dart';
import 'pilih_page.dart';
import '../services/booking_service.dart';

class FormPage extends StatefulWidget {
  final Booking? existing;
  const FormPage({super.key, this.existing});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final BookingService service = BookingService();

  late final TextEditingController namaC;
  late final TextEditingController noHpC;
  late final TextEditingController lapanganC;
  late final TextEditingController tanggalC;

  bool get isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    namaC = TextEditingController(text: widget.existing?.nama ?? '');
    noHpC = TextEditingController(text: widget.existing?.noHp ?? '');
    lapanganC = TextEditingController(text: widget.existing?.lapangan ?? '');
    tanggalC = TextEditingController(text: widget.existing?.tanggal ?? '');
  }

  @override
  void dispose() {
    namaC.dispose();
    noHpC.dispose();
    lapanganC.dispose();
    tanggalC.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      final y = picked.year.toString().padLeft(4, '0');
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      setState(() => tanggalC.text = '$y-$m-$d');
    }
  }

  Future<void> _pilihLapangan() async {
    final lap = await Navigator.push<Lapangan>(
      context,
      MaterialPageRoute(builder: (_) => const PilihPage()),
    );

    if (lap != null) {
      setState(() => lapanganC.text = lap.nama);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final booking = Booking(
      id: widget.existing?.id,
      nama: namaC.text.trim(),
      noHp: noHpC.text.trim(),
      lapangan: lapanganC.text.trim(),
      tanggal: tanggalC.text.trim(),
    );

    try {
      if (isEdit) {
        await service.updateBooking(booking);
      } else {
        await service.addBooking(booking);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Booking' : 'Tambah Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    'Form Booking',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: namaC,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pemesan',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: noHpC,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'Contoh: 08xxxxxxxxxx',
                    ),
                    validator: (v) {
                      final value = (v ?? '').trim();
                      if (value.isEmpty) return 'Nomor telepon wajib diisi';
                      if (value.length < 10) return 'Minimal 10 digit';
                      if (!RegExp(r'^[0-9+]+$').hasMatch(value)) {
                        return 'Hanya angka atau +';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: lapanganC,
                    readOnly: true,
                    onTap: _pilihLapangan,
                    decoration: const InputDecoration(
                      labelText: 'Lapangan',
                      hintText: 'Pilih lapangan',
                      prefixIcon: Icon(Icons.sports_soccer),
                      suffixIcon: Icon(Icons.chevron_right),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Lapangan wajib dipilih'
                        : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: tanggalC,
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Booking',
                      hintText: 'Pilih tanggal',
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Tanggal wajib dipilih'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.save),
                    label: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Booking'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
