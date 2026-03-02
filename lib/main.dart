import 'package:flutter/material.dart';

// Entry point aplikasi Flutter.
void main() {
  runApp(const MyApp());
}

// Root widget aplikasi: mengatur tema global dan halaman awal.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp adalah pembungkus utama aplikasi.
    // Di sini kita atur:
    // 1) debug banner
    // 2) tema global
    // 3) halaman pertama saat aplikasi dibuka
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AboutPage(),
    );
  }
}

// Kumpulan tema aplikasi (dark mode).
class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    // Mengaktifkan gaya Material terbaru.
    useMaterial3: true,
    // Seluruh aplikasi menggunakan mode gelap.
    brightness: Brightness.dark,
    // Skema warna global yang dipakai ulang di semua widget.
    colorScheme: const ColorScheme.dark(
      // Warna aksen utama (hijau) untuk elemen yang ingin ditonjolkan.
      primary: Color(0xFF3DDC84),
      // Warna dasar background komponen.
      surface: Color(0xFF0D1117),
      // Variasi surface untuk memberi depth/kontras.
      surfaceContainerHighest: Color(0xFF161B22),
      // Warna teks/ikon di atas surface gelap.
      onSurface: Color(0xFFE6EDF3),
      // Warna border halus antar komponen.
      outlineVariant: Color(0xFF2D333B),
    ),
    // Warna latar default untuk Scaffold.
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    // Skala tipografi yang dipakai di desktop/mobile layout.
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 46, height: 1.1),
      headlineSmall: TextStyle(fontSize: 34, height: 1.2),
      titleLarge: TextStyle(fontSize: 24),
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
    ),
    // Catatan: konfigurasi Chip/Button dihapus karena belum dipakai di UI saat ini.
  );
}

// Halaman utama yang memilih layout desktop/mobile berdasarkan lebar layar.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold sebagai kerangka layar (background, app structure).
    return Scaffold(
      // LayoutBuilder membaca ukuran aktual area render.
      // Ini dipakai untuk membuat UI responsive tanpa package tambahan.
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint sederhana: >800 desktop, selain itu mobile.
          return constraints.maxWidth > 800
              ? const DesktopLayout()
              : const MobileLayout();
        },
      ),
    );
  }
}

// Tampilan untuk layar lebar (desktop/web besar).
class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil color scheme dari tema aktif agar warna konsisten.
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        // Gradient memberi efek background lebih modern (tidak flat).
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      // SingleChildScrollView mencegah overflow pada layar lebih pendek.
      child: SingleChildScrollView(
        child: Column(
          children: [
            const ModernNavbar(),
            const SizedBox(height: 40),
            Padding(
              // Margin horizontal besar agar konten terasa lega di desktop.
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  // Layer transparan ringan untuk efek kartu di atas gradient.
                  color: colorScheme.surface.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                // Row: kiri foto profil, kanan informasi teks.
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.6),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 118,
                        // Pastikan file asset tersedia di pubspec.yaml.
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                    ),
                    const SizedBox(width: 60),
                    // Expanded membuat area teks mengisi sisa ruang.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Muhammad Aghiitsillah',
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Saya adalah mahasiswa Politeknik Elektronika Negeri Surabaya (PENS) PSDKU Lamongan, program studi D3 Teknik Informatika.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.7,
                              color: colorScheme.onSurface.withValues(alpha: 0.88),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

// Tampilan untuk layar kecil (mobile).
class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Sama seperti desktop: gunakan warna dari tema aktif.
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        // Arah gradient vertikal agar cocok untuk layar portrait.
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const ModernNavbar(),
            const SizedBox(height: 22),
            Padding(
              // Margin lebih kecil agar proporsional di layar sempit.
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                // Padding atas sedikit lebih besar untuk fokus ke avatar.
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 28),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.74),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.6),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 76,
                        backgroundImage: AssetImage('assets/profile.jpg'),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Muhammad Aghiitsillah',
                      // Mobile memakai center alignment agar komposisi seimbang.
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Saya adalah mahasiswa Politeknik Elektronika Negeri Surabaya (PENS) PSDKU Lamongan, program studi D3 Teknik Informatika.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        // Height mengatur jarak antar baris agar tetap nyaman dibaca.
                        height: 1.65,
                        color: colorScheme.onSurface.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

// Header sederhana di bagian atas halaman.
class ModernNavbar extends StatelessWidget {
  const ModernNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    // Navbar mengambil warna yang sama dengan komponen lain.
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        // Container ini bertindak sebagai kartu header transparan.
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Titik hijau sebagai elemen branding kecil.
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            // Nama/brand di navbar.
            Text(
              'Agissillah.',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}