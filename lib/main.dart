// Mengimpor package Flutter Material Design.
// Package ini menyediakan semua widget UI seperti Text, Column, Card, dll.
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FUNGSI MAIN — Titik awal program
// ─────────────────────────────────────────────────────────────────────────────

// void main() adalah fungsi pertama yang dijalankan saat aplikasi dibuka.
// runApp() memberitahu Flutter widget mana yang menjadi tampilan utama aplikasi.
void main() => runApp(const MyApp());

// Enum ini berfungsi sebagai "penanda halaman" yang dipakai navbar.
// Dengan enum, kita menghindari typo dibanding menulis string manual.
enum AppSection { login, profile }

// Fungsi helper untuk pindah antar section melalui navbar.
// - current: halaman yang sedang aktif saat ini.
// - target: halaman tujuan yang dipilih user.
void _goToSection(BuildContext context, AppSection current, AppSection target) {
  // Jika user menekan menu halaman yang sama, tidak perlu navigasi ulang.
  if (current == target) return;

  // Menentukan widget halaman tujuan berdasarkan nilai enum target.
  Widget page;
  switch (target) {
    case AppSection.login:
      page = const LoginPage();
      break;
    case AppSection.profile:
      page = const ProfilePage();
      break;
  }

  // pushReplacement mengganti halaman saat ini agar stack navigasi tetap rapi.
  // Cocok untuk perpindahan menu utama (mirip tab/section), bukan "drill down".
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => page),
  );
}

// Builder AppBar/navbar yang dipakai bersama oleh banyak halaman.
// Tujuannya agar tampilan dan perilaku menu konsisten di seluruh app.
AppBar buildTopNavbar(
  BuildContext context, {
  required String title,
  required AppSection currentSection,
}) {
  // Breakpoint sederhana: jika lebar < 700, dianggap mode mobile.
  final isMobile = MediaQuery.of(context).size.width < 700;

  // Daftar item menu navbar (label + section tujuan).
  // Menggunakan record type agar deklarasi ringkas namun tetap jelas.
  final navItems = <({String label, AppSection section})>[
    (label: 'Logout', section: AppSection.login),
    (label: 'Profile', section: AppSection.profile),
  ];

  return AppBar(
    title: Text(title),
    centerTitle: true,
    actions: [
      // MODE MOBILE:
      // Semua menu disatukan dalam ikon titik tiga agar hemat ruang horizontal.
      if (isMobile)
        PopupMenuButton<AppSection>(
          icon: const Icon(Icons.more_vert),
          onSelected: (section) => _goToSection(context, currentSection, section),
          itemBuilder: (context) => [
            for (final item in navItems)
              PopupMenuItem<AppSection>(
                value: item.section,
                child: Text(item.label),
              ),
          ],
        )
      // MODE DESKTOP/TABLET LEBAR:
      // Menu ditampilkan langsung sebagai tombol teks di kanan AppBar.
      else
        for (final item in navItems)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () => _goToSection(context, currentSection, item.section),
              child: Text(
                item.label,
                style: TextStyle(
                  // Item aktif diberi warna hijau agar user tahu sedang di halaman mana.
                  color: item.section == currentSection
                      ? Colors.green
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// CLASS MyApp — Konfigurasi Aplikasi
// ─────────────────────────────────────────────────────────────────────────────

// StatelessWidget artinya widget ini tidak punya "state" (data yang berubah).
// MyApp hanya bertugas mengatur tema dan halaman awal — tidak perlu state.
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // super.key dipakai Flutter untuk mengenali widget secara unik

  // build() adalah fungsi wajib di setiap widget.
  // Flutter memanggil fungsi ini untuk menggambar tampilan widget ke layar.
  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah widget root yang mengatur seluruh aplikasi.
    // Di sinilah kita mengatur tema, judul, dan halaman pertama.
    return MaterialApp(
      // Menyembunyikan tulisan "DEBUG" di pojok kanan atas layar.
      debugShowCheckedModeBanner: false,

      // ThemeData mengatur tampilan/gaya visual seluruh aplikasi.
      theme: ThemeData(
        useMaterial3: true,            // Menggunakan gaya Material Design versi 3 (terbaru)
        colorSchemeSeed: Colors.green, // Warna utama aplikasi adalah hijau
        brightness: Brightness.dark,  // Mode tampilan gelap (dark mode)
      ),

      // home adalah halaman pertama yang ditampilkan saat aplikasi dibuka.
      home: const LoginPage(),
    );
  }
}

// Halaman login sederhana: cukup tekan tombol "Masuk" untuk lanjut ke profil.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Halaman login ini sengaja sederhana:
    // belum ada input username/password, hanya tombol masuk ke profile.
    return Scaffold(
      appBar: buildTopNavbar(
        context,
        title: 'Login',
        currentSection: AppSection.login,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 72, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Selamat Datang',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Klik tombol Masuk untuk melihat profile.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Berbeda dengan menu navbar yang memakai pushReplacement,
                    // tombol ini memakai push agar user bisa kembali dengan tombol back.
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Masuk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CLASS ProfilePage — Halaman Utama Profile
// ─────────────────────────────────────────────────────────────────────────────

// ProfilePage adalah halaman utama yang menampilkan semua informasi profil.
// Juga StatelessWidget karena isi halaman ini tidak berubah-ubah.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold adalah kerangka dasar sebuah halaman di Flutter.
    // Ia menyediakan struktur: appBar (header atas) dan body (isi halaman).
    return Scaffold(

      // AppBar adalah bar/header di bagian paling atas halaman.
      appBar: buildTopNavbar(
        context,
        title: 'Profile Pribadi',
        currentSection: AppSection.profile,
      ),

      // body adalah area utama di bawah AppBar tempat konten ditampilkan.
      body: SingleChildScrollView(
        // SingleChildScrollView membuat konten bisa di-scroll ke bawah
        // jika isinya lebih panjang dari layar.
        padding: const EdgeInsets.all(24), // Memberi jarak 24px di semua sisi

        // Center membuat semua konten di dalamnya rata tengah secara horizontal.
        child: Center(
          // Column menyusun widget-widget di dalamnya secara vertikal (atas ke bawah).
          child: Column(
            children: [

              // ── FOTO PROFIL ──────────────────────────────────────────────
              // CircleAvatar menampilkan gambar dalam bentuk lingkaran.
              const CircleAvatar(
                radius: 70, // Ukuran jari-jari lingkaran (semakin besar = semakin lebar)
                backgroundImage: AssetImage('assets/profile.jpg'), // Gambar dari folder assets
              ),

              // SizedBox adalah widget kosong yang berfungsi sebagai jarak/spasi.
              // height: 16 berarti jarak vertikal 16 piksel.
              const SizedBox(height: 16),

              // ── NAMA ─────────────────────────────────────────────────────
              // Text menampilkan tulisan di layar.
              const Text(
                'Muhammad Aghiitsillah',
                style: TextStyle(
                  fontSize: 22,              // Ukuran huruf 22
                  fontWeight: FontWeight.bold // Huruf tebal
                ),
                textAlign: TextAlign.center, // Teks rata tengah
              ),

              const SizedBox(height: 8), // Spasi 8px antara nama dan badge

              // ── BADGE JURUSAN ─────────────────────────────────────────────
              // Chip adalah widget berbentuk kapsul/pill untuk menampilkan label pendek.
              Chip(
                label: const Text('Mahasiswa Teknik Informatika'), // Teks di dalam chip
                backgroundColor: Colors.green.withValues(alpha: 0.2), // Latar belakang hijau transparan
                labelStyle: const TextStyle(color: Colors.green),     // Warna teks hijau
              ),

              const SizedBox(height: 24), // Spasi 24px sebelum kartu-kartu info

              // ── KARTU INFORMASI ───────────────────────────────────────────
              // _InfoCard adalah widget buatan kita sendiri (lihat class di bawah).
              // Setiap _InfoCard menerima 3 data: ikon, label, dan nilai.

              // Kartu kampus
              _InfoCard(icon: Icons.school, label: 'Kampus',  value: 'PENS PSDKU Lamongan'),
              // Kartu lokasi
              _InfoCard(icon: Icons.place,  label: 'Lokasi',  value: 'Lamongan, Jawa Timur'),
              // Kartu jurusan
              _InfoCard(icon: Icons.code,   label: 'Jurusan', value: 'Teknik Informatika'),
              // Kartu NRP
              _InfoCard(icon: Icons.badge,  label: 'NRP',     value: '3124521028'),

            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CLASS _InfoCard — Widget Kartu Informasi (Reusable)
// ─────────────────────────────────────────────────────────────────────────────

// _InfoCard adalah widget khusus yang kita buat sendiri untuk menampilkan
// satu baris informasi dengan format: [ikon] [label] [nilai].
//
// Dengan membuat widget terpisah seperti ini, kita tidak perlu menulis
// kode yang sama berulang-ulang untuk setiap kartu informasi.
// Cukup panggil _InfoCard(...) dengan data yang berbeda.
//
// Nama diawali underscore (_) artinya widget ini bersifat "private" —
// hanya bisa dipakai di dalam file ini saja.
class _InfoCard extends StatelessWidget {
  // Deklarasi variabel yang akan diterima widget ini dari luar.
  final IconData icon;  // Ikon yang ditampilkan di sebelah kiri (contoh: Icons.school)
  final String label;   // Teks kecil di atas (contoh: "Kampus")
  final String value;   // Teks utama di bawah (contoh: "PENS PSDKU Lamongan")

  // Constructor: cara membuat _InfoCard dengan mengisi ketiga data di atas.
  // 'required' artinya ketiga parameter ini wajib diisi, tidak boleh kosong.
  const _InfoCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    // Card adalah widget berbentuk kotak dengan sudut membulat dan bayangan tipis.
    return Card(
      margin: const EdgeInsets.only(bottom: 12), // Jarak 12px di bawah setiap kartu

      // ListTile adalah widget siap pakai untuk menampilkan satu baris berisi:
      // leading (kiri) — title (atas) — subtitle (bawah)
      child: ListTile(
        // leading: widget yang tampil di sisi paling kiri
        leading: Icon(icon, color: Colors.green), // Ikon berwarna hijau

        // title: teks utama (di sini dipakai sebagai label kecil)
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 12,        // Ukuran kecil karena ini hanya label kategori
            color: Colors.grey   // Warna abu-abu agar terlihat sebagai teks sekunder
          ),
        ),

        // subtitle: teks di bawah title (di sini dipakai sebagai nilai utama)
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 15,              // Lebih besar dari label karena ini informasi utama
            fontWeight: FontWeight.w600 // Sedikit tebal agar mudah dibaca
          ),
        ),
      ),
    );
  }
}