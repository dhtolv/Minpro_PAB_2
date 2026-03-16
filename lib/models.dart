class Booking {
  final int? id;
  final String nama;
  final String noHp;
  final String lapangan;
  final String tanggal;

  Booking({
    this.id,
    required this.nama,
    required this.noHp,
    required this.lapangan,
    required this.tanggal,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      nama: map['nama'] ?? '',
      noHp: map['no_hp'] ?? '',
      lapangan: map['lapangan'] ?? '',
      tanggal: map['tanggal'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'no_hp': noHp,
      'lapangan': lapangan,
      'tanggal': tanggal,
    };
  }
}

class Lapangan {
  final String nama;
  final int hargaPerJam;
  final String imagePath;

  Lapangan({
    required this.nama,
    required this.hargaPerJam,
    required this.imagePath,
  });
}

final List<Lapangan> daftarLapangan = [
  Lapangan(
    nama: "Lapangan Sepak Bola",
    hargaPerJam: 180000,
    imagePath: "assets/images/lapbola.jpg",
  ),
  Lapangan(
    nama: "Lapangan Basket",
    hargaPerJam: 70000,
    imagePath: "assets/images/lapbasket.jpg",
  ),
  Lapangan(
    nama: "Lapangan Bulu Tangkis",
    hargaPerJam: 70000,
    imagePath: "assets/images/lapbultang.jpg",
  ),
  Lapangan(
    nama: "Lapangan Padel",
    hargaPerJam: 150000,
    imagePath: "assets/images/lappadel.jpg",
  ),
  Lapangan(
    nama: "Lapangan Voli",
    hargaPerJam: 70000,
    imagePath: "assets/images/lapvoli.jpg",
  ),
];
