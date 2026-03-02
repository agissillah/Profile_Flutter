import 'package:flutter/material.dart';
import 'dart:math' as math;

// Titik awal aplikasi.
// Flutter akan menjalankan widget root `MyApp` dari sini.
void main() {
  runApp(const MyApp());
}

// Widget root aplikasi.
// Bertugas menyiapkan konfigurasi global seperti tema dan halaman awal.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // `MaterialApp` adalah pembungkus utama app berbasis Material Design.
    return MaterialApp(
      // Menghilangkan label DEBUG di kanan atas saat development.
      debugShowCheckedModeBanner: false,
      // Tema global app diambil dari `AppTheme`.
      theme: AppTheme.darkTheme,
      // Halaman pertama yang ditampilkan saat app dibuka.
      home: const AboutPage(),
    );
  }
}

class AppTheme {
  // Kumpulan warna utama agar styling konsisten di semua widget.
  // Semua konstanta di bawah dipakai berulang agar mudah maintenance.
  static const Color bgDeep     = Color(0xFF060A0F);
  static const Color bgCard     = Color(0xFF0E1520);
  static const Color accent     = Color(0xFF3DDC84);
  static const Color accentGlow = Color(0x403DDC84);
  static const Color textPri    = Color(0xFFE8F0FE);
  static const Color textSec    = Color(0xFF8B9AB0);
  static const Color border     = Color(0xFF1E2D3D);

  // Tema gelap aplikasi.
  // Semua widget yang membaca Theme akan mengikuti nilai di sini.
  static final ThemeData darkTheme = ThemeData(
    // Mengaktifkan komponen Material terbaru.
    useMaterial3: true,
    // Menggunakan mode gelap.
    brightness: Brightness.dark,
    // Warna default latar belakang Scaffold.
    scaffoldBackgroundColor: bgDeep,
    // Skema warna yang akan dipakai lintas komponen.
    colorScheme: const ColorScheme.dark(
      primary: accent,
      surface: bgCard,
      onSurface: textPri,
    ),
    // Font global aplikasi.
    fontFamily: 'monospace',
  );
}

// Halaman container utama yang memilih versi desktop/mobile.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder dipakai untuk responsive layout berdasarkan lebar layar.
    // > 800 px: desktop layout, <= 800 px: mobile layout.
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // `constraints.maxWidth` adalah lebar area konten yang tersedia.
          // Nilai ini paling tepat untuk menentukan mode responsive.
          return constraints.maxWidth > 800
              ? const DesktopLayout()
              : const MobileLayout();
        },
      ),
    );
  }
}

// ────────────────────────── DESKTOP ──────────────────────────

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Stack dipakai agar background animasi berada di layer belakang,
    // sedangkan konten utama berada di atasnya.
    return Stack(
      children: [
        const _AnimatedBackground(),
        // ScrollView mencegah overflow saat tinggi layar tidak cukup.
        SingleChildScrollView(
          child: Column(
            children: [
              // Header identitas di bagian atas.
              const _GlassNavbar(),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kartu profil (foto + info ringkas).
                    const _ProfileCard(),
                    const SizedBox(width: 40),
                    // Panel informasi akademik detail.
                    Expanded(child: const _InfoPanel()),
                  ],
                ),
              ),
              const SizedBox(height: 80),
              // Ringkasan statistik di bawah konten utama.
              const _StatsRow(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}

// ────────────────────────── MOBILE ──────────────────────────

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Struktur mobile sama dengan desktop, hanya jarak dan susunan yang disesuaikan.
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
                  children: [
                    // Urutan mobile dibuat vertikal agar nyaman dibaca.
                    const _ProfileCard(isMobile: true),
                    const SizedBox(height: 24),
                    const _InfoPanel(),
                    const SizedBox(height: 24),
                    const _StatsRow(isMobile: true),
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

// ────────────────────────── ANIMATED BACKGROUND ──────────────────────────

class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  // Controller animasi untuk menggerakkan latar belakang.
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    // Durasi 12 detik untuk satu siklus, lalu diulang terus.
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    // Selalu dispose controller untuk mencegah memory leak.
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder akan rebuild CustomPaint setiap nilai animasi berubah.
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _BgPainter(_ctrl.value),
        );
      },
    );
  }
}

class _BgPainter extends CustomPainter {
  // `t` adalah progress animasi dari 0..1.
  final double t;
  const _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Deep background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppTheme.bgDeep,
    );

    // Blob aurora: lingkaran gradien transparan yang bergerak perlahan
    // menggunakan fungsi sinus/cosinus agar motion terasa halus.
    final blobs = [
      _BlobData(
        Offset(size.width * (0.15 + 0.08 * math.sin(t * math.pi * 2)),
                size.height * (0.2 + 0.06 * math.cos(t * math.pi * 2))),
        size.width * 0.45,
        const Color(0x123DDC84),
      ),
      _BlobData(
        Offset(size.width * (0.75 + 0.06 * math.cos(t * math.pi * 2 + 1)),
                size.height * (0.6 + 0.07 * math.sin(t * math.pi * 2 + 1))),
        size.width * 0.4,
        const Color(0x0C1A6B8A),
      ),
      _BlobData(
        Offset(size.width * (0.5 + 0.05 * math.sin(t * math.pi * 2 + 2)),
                size.height * (0.85 + 0.04 * math.cos(t * math.pi * 2 + 2))),
        size.width * 0.35,
        const Color(0x0A3DDC84),
      ),
    ];

    for (final b in blobs) {
      canvas.drawCircle(
        b.center,
        b.radius,
        Paint()
          ..shader = RadialGradient(
            colors: [b.color, Colors.transparent],
          ).createShader(Rect.fromCircle(center: b.center, radius: b.radius)),
      );
    }

    // Grid tipis untuk memberi tekstur futuristik di background.
    final gridPaint = Paint()
      ..color = const Color(0x071E2D3D)
      ..strokeWidth = 1;

    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_BgPainter old) {
    // Repaint hanya saat progress animasi berubah,
    // agar rendering tetap efisien.
    return old.t != t;
  }
}

class _BlobData {
  // Model data sederhana untuk setiap blob aurora.
  final Offset center;
  final double radius;
  final Color color;
  const _BlobData(this.center, this.radius, this.color);
}

// ────────────────────────── NAVBAR ──────────────────────────

class _GlassNavbar extends StatelessWidget {
  const _GlassNavbar();

  @override
  Widget build(BuildContext context) {
    // Navbar dengan efek kartu gelap semi-transparan.
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
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
            // Logo mark
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
            // Nama utama sebagai branding personal.
            const Text(
              'Muhammad Aghiitsillah',
              style: TextStyle(
                color: AppTheme.textPri,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            // Badge status di sisi kanan navbar.
            _NavBadge(label: 'Available'),
          ],
        ),
      ),
    );
  }
}

class _NavBadge extends StatelessWidget {
  final String label;
  const _NavBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    // Badge status reusable.
    // Label bisa diganti sesuai status lain bila diperlukan.
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
          // Titik status.
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

// ────────────────────────── PROFILE CARD ──────────────────────────

class _ProfileCard extends StatefulWidget {
  // `isMobile` menentukan ukuran komponen agar proporsional di layar kecil.
  final bool isMobile;
  const _ProfileCard({this.isMobile = false});

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard>
    with SingleTickerProviderStateMixin {
  // Controller untuk efek pulse glow pada card.
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    // Animasi bolak-balik (reverse) agar glow terlihat bernapas.
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    // Dispose controller animasi pulse.
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Radius avatar dibedakan desktop vs mobile.
    final double avatarRadius = widget.isMobile ? 70 : 100;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        // Nilai glow berubah mengikuti progress animasi 0..1.
        final glow = 0.15 + 0.12 * _pulse.value;

        return Container(
          // Lebar desktop dibuat fixed agar proporsional terhadap InfoPanel.
          // Mobile menggunakan lebar penuh (`double.infinity`).
          width: widget.isMobile ? double.infinity : 280,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xDD0E1520),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border, width: 1),
            boxShadow: [
              // Efek glow lembut yang intensitasnya berubah mengikuti animasi.
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: glow),
                blurRadius: 40,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Foto profil utama tanpa efek ring.
              CircleAvatar(
                radius: avatarRadius,
                backgroundImage: const AssetImage('assets/profile.jpg'),
                backgroundColor: AppTheme.bgCard,
              ),
              const SizedBox(height: 22),

              // Name
              const Text(
                'Muhammad\nAghiitsillah',
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

              // Role badge
              Container(
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
              const Divider(color: AppTheme.border, thickness: 1),
              const SizedBox(height: 18),

              // Quick info rows
              _QuickInfo(icon: Icons.badge_outlined,     label: 'NRP',     value: '3124521028'),
              const SizedBox(height: 12),
              _QuickInfo(icon: Icons.location_on_outlined, label: 'Kampus', value: 'PSDKU Lamongan'),
            ],
          ),
        );
      },
    );
  }
}

class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _QuickInfo({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    // Komponen baris informasi singkat: ikon + label + value.
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 16),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppTheme.textSec,
            fontSize: 13,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPri,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            // Ellipsis mencegah teks panjang merusak layout.
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ────────────────────────── INFO PANEL ──────────────────────────

class _InfoPanel extends StatelessWidget {
  const _InfoPanel();

  @override
  Widget build(BuildContext context) {
    // Panel informasi akademik utama.
    // Isinya dibagi 2 bagian: header deskripsi + grid detail data.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
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
                  // Ikon kategori section.
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
              // Nama institusi utama.
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
                ' Kampus ini fokus pada praktik, berlokasi di Lamongan, dan sering meraih prestasi nasional di bidang teknologi dan kreatif.',
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

        // Detail grid
        // Menampilkan data akademik dalam dua baris tile agar mudah dipindai.
        Row(
          children: [
            Expanded(
              // Tile 1: institusi.
              child: _DetailTile(
                icon: Icons.account_balance_outlined,
                title: 'Perguruan Tinggi',
                subtitle: 'PENS',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              // Tile 2: lokasi kampus.
              child: _DetailTile(
                icon: Icons.place_outlined,
                title: 'Lokasi Kampus',
                subtitle: 'Lamongan, Jawa Timur',
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              // Tile 3: jurusan.
              child: _DetailTile(
                icon: Icons.code_outlined,
                title: 'Jurusan',
                subtitle: 'Teknik Informatika',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              // Tile 4: nomor registrasi mahasiswa.
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
    // Tile kecil reusable untuk menampilkan pasangan judul dan isi.
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
              Icon(icon, color: AppTheme.accent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
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

// ────────────────────────── STATS ROW ──────────────────────────

class _StatsRow extends StatelessWidget {
  final bool isMobile;
  const _StatsRow({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    // Data ringkas yang ditampilkan sebagai statistik di bagian bawah.
    final stats = [
      _StatData(value: '2024', label: 'Tahun\nMasuk'),
      _StatData(value: 'D3', label: 'Jenjang\nPendidikan'),
      _StatData(value: 'TI', label: 'Kode\nJurusan'),
      _StatData(value: 'PENS', label: 'Kode\nKampus'),
    ];

    return Padding(
      // Padding horizontal mengikuti tipe layar.
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xDD0E1520),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          // `asMap().entries` dipakai agar index tersedia,
          // sehingga kita bisa menambahkan separator kecuali pada item terakhir.
          children: stats
              .asMap()
              .entries
              .map((e) {
                final isLast = e.key == stats.length - 1;
                return Expanded(
                  child: Row(
                    children: [
                      // Setiap item statistik mengisi ruang secara merata.
                      Expanded(child: _StatItem(data: e.value)),
                      if (!isLast)
                        // Garis pemisah antar item statistik.
                        Container(
                          width: 1,
                          height: 40,
                          color: AppTheme.border,
                        ),
                    ],
                  ),
                );
              })
              .toList(),
        ),
      ),
    );
  }
}

class _StatData {
  // Model data statistik.
  final String value;
  final String label;
  const _StatData({required this.value, required this.label});
}

class _StatItem extends StatelessWidget {
  final _StatData data;
  const _StatItem({required this.data});

  @override
  Widget build(BuildContext context) {
    // Satu blok statistik: angka/nilai utama + label deskriptif.
    return Column(
      children: [
        Text(
          data.value,
          style: const TextStyle(
            color: AppTheme.accent,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          data.label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.textSec,
            fontSize: 11,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}