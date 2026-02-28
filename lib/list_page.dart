import 'package:flutter/material.dart';
import 'models.dart';
import 'form_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<Booking> bookingList = [];

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _hapus(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus booking?'),
        content: Text(
          'Yakin hapus booking ${bookingList[index].lapangan} oleh ${bookingList[index].nama}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (ok == true) {
      setState(() => bookingList.removeAt(index));
      _snack('Booking dihapus 🗑️');
    }
  }

  Future<void> _tambah() async {
    final result = await Navigator.push<Booking>(
      context,
      MaterialPageRoute(builder: (_) => const FormPage()),
    );

    if (result != null) {
      setState(() => bookingList.insert(0, result));
      _snack('Booking ditambahkan ✅');
    }
  }

  Future<void> _edit(int index) async {
    final result = await Navigator.push<Booking>(
      context,
      MaterialPageRoute(builder: (_) => FormPage(existing: bookingList[index])),
    );

    if (result != null) {
      setState(() => bookingList[index] = result);
      _snack('Booking diupdate ✨');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Lapangan'), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: _tambah,
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ===== BANNER HEADER =====
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/banner.png',
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      const Positioned(
                        left: 20,
                        bottom: 20,
                        child: Text(
                          'Booking Lapangan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ===== HEADER LIST =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daftar Booking',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Chip(label: Text('${bookingList.length} data')),
                  ],
                ),

                const SizedBox(height: 12),

                // ===== LIST =====
                Expanded(
                  child: bookingList.isEmpty
                      ? const Center(
                          child: Text(
                            'Belum ada booking.\nTekan tombol + untuk menambah.',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          itemCount: bookingList.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final b = bookingList[index];

                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  child: Text(
                                    b.nama.isNotEmpty
                                        ? b.nama[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(
                                  b.lapangan,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(b.nama),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 14),
                                        const SizedBox(width: 4),
                                        Text(b.noHp),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(b.tanggal),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Wrap(
                                  spacing: 6,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _edit(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _hapus(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
