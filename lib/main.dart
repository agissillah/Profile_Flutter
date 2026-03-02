import 'dart:math' as math;
import 'package:flutter/material.dart';

// Entry point aplikasi Flutter.
void main() {
  // Menjalankan widget root aplikasi.
  runApp(const MyApp());
}

// Widget root untuk konfigurasi global aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp memegang tema, routing, dan halaman awal.
    return MaterialApp(
      // Menyembunyikan banner debug di kanan atas.
      debugShowCheckedModeBanner: false,
      // Tema global aplikasi.
      theme: AppTheme.darkTheme,
      // Halaman pertama saat aplikasi dibuka.
      home: const AboutPage(),
    );
  }
}

// Kumpulan warna dan tema agar styling konsisten di semua widget.
class AppTheme {
  // Warna latar paling gelap.
  static const Color bgDeep = Color(0xFF060A0F);
  // Warna kartu/panel.
  static const Color bgCard = Color(0xFF0E1520);
  // Warna aksen utama.
  static const Color accent = Color(0xFF3DDC84);
  // Warna aksen dengan transparansi untuk glow.
  static const Color accentGlow = Color(0x403DDC84);
  // Warna teks utama.
  static const Color textPri = Color(0xFFE8F0FE);
  // Warna teks sekunder.
  static const Color textSec = Color(0xFF8B9AB0);
  // Warna border halus.
  static const Color border = Color(0xFF1E2D3D);

  // Definisi tema gelap aplikasi.
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgDeep,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      surface: bgCard,
      onSurface: textPri,
    ),
    fontFamily: 'monospace',
  );
}

// Halaman container yang memilih layout desktop atau mobile.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint sederhana untuk responsive layout.
          return constraints.maxWidth > 800
              ? const DesktopLayout()
              : const MobileLayout();
        },
      ),
    );
  }
}

// Layout khusus layar lebar.
class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Latar belakang animasi.
        const _AnimatedBackground(),
        // Konten bisa di-scroll jika tinggi layar tidak cukup.
        SingleChildScrollView(
          child: Column(
            children: [
              // Header halaman.
              const _GlassNavbar(),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    // Kartu profil (kiri).
                    _ProfileCard(),
                    SizedBox(width: 40),
                    // Panel informasi (kanan, fleksibel).
                    Expanded(child: _InfoPanel()),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}

// Layout khusus layar kecil/mobile.
class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _AnimatedBackground(),
        SingleChildScrollView(
          child: Column(
            children: [
              const _GlassNavbar(),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: const [
                    // Di mobile semua komponen ditumpuk vertikal.
                    _ProfileCard(isMobile: true),
                    SizedBox(height: 24),
                    _InfoPanel(),
                  ],
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget background animasi.
class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  // Controller untuk menggerakkan animasi background.
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    // Animasi berulang tiap 12 detik.
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    // Wajib dispose untuk mencegah memory leak.
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild painter setiap nilai animasi berubah.
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return CustomPaint(
          // Mengisi seluruh area parent.
          size: Size.infinite,
          painter: _BgPainter(_ctrl.value),
        );
      },
    );
  }
}

// Painter custom untuk menggambar latar animasi.
class _BgPainter extends CustomPainter {
  // Progress animasi (0..1).
  final double t;
  const _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1: warna latar dasar.
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppTheme.bgDeep,
    );

    // Layer 2: blob aurora dengan posisi dinamis.
    final blobs = [
      _BlobData(
        Offset(
          size.width * (0.15 + 0.08 * math.sin(t * math.pi * 2)),
          size.height * (0.2 + 0.06 * math.cos(t * math.pi * 2)),
        ),
        size.width * 0.45,
        const Color(0x123DDC84),
      ),
      _BlobData(
        Offset(
          size.width * (0.75 + 0.06 * math.cos(t * math.pi * 2 + 1)),
          size.height * (0.6 + 0.07 * math.sin(t * math.pi * 2 + 1)),
        ),
        size.width * 0.4,
        const Color(0x0C1A6B8A),
      ),
      _BlobData(
        Offset(
          size.width * (0.5 + 0.05 * math.sin(t * math.pi * 2 + 2)),
          size.height * (0.85 + 0.04 * math.cos(t * math.pi * 2 + 2)),
        ),
        size.width * 0.35,
        const Color(0x0A3DDC84),
      ),
    ];

    for (final b in blobs) {
      canvas.drawCircle(
        b.center,
        b.radius,
        Paint()
          // Radial gradient agar blob memudar ke luar.
          ..shader = RadialGradient(
            colors: [b.color, Colors.transparent],
          ).createShader(Rect.fromCircle(center: b.center, radius: b.radius)),
      );
    }

    // Layer 3: grid tipis sebagai tekstur visual.
    final gridPaint = Paint()
      ..color = const Color(0x071E2D3D)
      ..strokeWidth = 1;

    const step = 60.0;
    // Garis vertikal.
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    // Garis horizontal.
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_BgPainter oldDelegate) => oldDelegate.t != t;
}

// Model data untuk satu blob aurora.
class _BlobData {
  final Offset center;
  final double radius;
  final Color color;
  const _BlobData(this.center, this.radius, this.color);
}

// Navbar atas dengan gaya glassmorphism.
class _GlassNavbar extends StatelessWidget {
  const _GlassNavbar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          // Transparansi untuk efek kaca.
          color: const Color(0xCC0E1520),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accent.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo kotak berisi inisial.
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.accentGlow,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.accent.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: const Center(
                child: Text(
                  'MA',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Judul/navbar text.
            const Text(
              'Profile Pribadi',
              style: TextStyle(
                color: AppTheme.textPri,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            // Badge status kanan.
            const _NavBadge(label: 'Available'),
          ],
        ),
      ),
    );
  }
}

// Badge status kecil di navbar.
class _NavBadge extends StatelessWidget {
  final String label;
  const _NavBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentGlow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accent.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titik indikator status.
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          // Teks status.
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.accent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Kartu profil (foto, nama, role, info ringkas).
class _ProfileCard extends StatefulWidget {
  // Menentukan ukuran untuk mode mobile/desktop.
  final bool isMobile;
  const _ProfileCard({this.isMobile = false});

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard>
    with SingleTickerProviderStateMixin {
  // Controller animasi glow pada kartu profil.
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    // Animasi bolak-balik agar glow terasa hidup.
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ukuran avatar disesuaikan ukuran layar.
    final avatarRadius = widget.isMobile ? 70.0 : 100.0;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        // Alpha glow berubah mengikuti progress animasi.
        final glow = 0.15 + 0.12 * _pulse.value;

        return Container(
          // Lebar penuh di mobile, fixed di desktop.
          width: widget.isMobile ? double.infinity : 280,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xDD0E1520),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: glow),
                blurRadius: 40,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                // Foto profil dari assets.
                backgroundImage: const AssetImage('assets/profile.jpg'),
                backgroundColor: AppTheme.bgCard,
              ),
              const SizedBox(height: 22),
              const Text(
                'Muhammad\nAghiitsillah',
                // Teks dibagi dua baris agar tetap proporsional.
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textPri,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                // Badge peran/jurusan.
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.accentGlow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppTheme.accent.withValues(alpha: 0.3),
                  ),
                ),
                child: const Text(
                  'Mahasiswa Teknik Informatika',
                  style: TextStyle(
                    color: AppTheme.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              // Pemisah visual.
              const Divider(color: AppTheme.border, thickness: 1),
              const SizedBox(height: 18),
              // Info ringkas identitas.
              const _QuickInfo(
                icon: Icons.badge_outlined,
                label: 'NRP',
                value: '3124521028',
              ),
              const SizedBox(height: 12),
              const _QuickInfo(
                icon: Icons.location_on_outlined,
                label: 'Kampus',
                value: 'PSDKU Lamongan',
              ),
            ],
          ),
        );
      },
    );
  }
}

// Baris item informasi kecil: ikon + label + nilai.
class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Ikon kategori info.
        Icon(icon, color: AppTheme.accent, size: 16),
        const SizedBox(width: 10),
        Text(
          // Label sebelum nilai (contoh: "NRP:").
          '$label: ',
          style: const TextStyle(
            color: AppTheme.textSec,
            fontSize: 13,
          ),
        ),
        Expanded(
          // Expanded memastikan text panjang tetap aman di layout.
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPri,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Panel informasi akademik detail.
class _InfoPanel extends StatelessWidget {
  const _InfoPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kartu utama deskripsi kampus.
        Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xDD0E1520),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Ikon section.
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.accentGlow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.school_outlined,
                      color: AppTheme.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Judul section.
                  const Text(
                    'Informasi Akademik',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Nama institusi.
              const Text(
                'Politeknik Elektronika\nNegeri Surabaya',
                style: TextStyle(
                  color: AppTheme.textPri,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              // Deskripsi singkat institusi.
              const Text(
                'Politeknik Elektronika Negeri Surabaya (PENS) PSDKU Lamongan adalah kampus vokasi negeri di Lamongan, Jawa Timur, '
                'yang menyelenggarakan program studi D3, terutama Teknik Informatika dan Teknologi Multimedia Broadcasting. '
                'Kampus ini fokus pada praktik, berlokasi di Lamongan, dan sering meraih prestasi nasional di bidang teknologi dan kreatif.',
                style: TextStyle(
                  color: AppTheme.textSec,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Grid detail baris pertama.
        Row(
          children: const [
            Expanded(
              child: _DetailTile(
                icon: Icons.account_balance_outlined,
                title: 'Perguruan Tinggi',
                subtitle: 'PENS',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _DetailTile(
                icon: Icons.place_outlined,
                title: 'Lokasi Kampus',
                subtitle: 'Lamongan, Jawa Timur',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Grid detail baris kedua.
        Row(
          children: const [
            Expanded(
              child: _DetailTile(
                icon: Icons.code_outlined,
                title: 'Jurusan',
                subtitle: 'Teknik Informatika',
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _DetailTile(
                icon: Icons.tag_outlined,
                title: 'NRP',
                subtitle: '3124521028',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Tile reusable untuk menampilkan satu data ringkas.
class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _DetailTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xDD0E1520),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Ikon kategori tile.
              Icon(icon, color: AppTheme.accent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  // Judul data.
                  title,
                  style: const TextStyle(
                    color: AppTheme.textSec,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Nilai data.
          Text(
            subtitle,
            style: const TextStyle(
              color: AppTheme.textPri,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
