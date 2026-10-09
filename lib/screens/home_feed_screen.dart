import 'package:flutter/material.dart';

import '../data/mock_feed_data.dart';
import '../models/audit_card_data.dart';
import '../theme/app_theme.dart';
import '../widgets/audit_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/quick_filter_pills.dart';
import '../widgets/top_app_bar.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<AuditCardData> _cards = List.from(MockFeedData.sampleCards);
  String _selectedFilterId = 'all';
  int _currentNavIndex = 0;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AuditCardData> get _filteredCards {
    return _cards.where((card) {
      // 1. Text Search Filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = card.placeName.toLowerCase().contains(query);
        final matchCategory = card.categoryDistance.toLowerCase().contains(
          query,
        );
        final matchReview = card.reviewSnippet.toLowerCase().contains(query);
        if (!matchName && !matchCategory && !matchReview) {
          return false;
        }
      }

      // 2. Navigation / Pill Filter
      if (_currentNavIndex == 1) {
        return card.status == AuditStatus.wishlistSetelahKunjungan ||
            card.isBookmarked;
      }

      switch (_selectedFilterId) {
        case 'rekomendasi':
        case 'wajib':
          return card.status == AuditStatus.rekomendasiKunjungiLagi;
        case 'wishlist_selesai':
        case 'pikir':
        case 'wishlist':
          return card.status == AuditStatus.wishlistSetelahKunjungan ||
              card.isBookmarked;
        case 'tidak':
          return card.status == AuditStatus.tidakRekomendasi;
        case 'visited':
          return card.isVisitedByMe;
        case 'sound':
          return card.decibel <= 50;
        case 'all':
        default:
          return true;
      }
    }).toList();
  }

  void _toggleBookmark(int index, AuditCardData card) {
    setState(() {
      final cardIndex = _cards.indexWhere((c) => c.id == card.id);
      if (cardIndex != -1) {
        final current = _cards[cardIndex];
        _cards[cardIndex] = current.copyWith(
          isBookmarked: !current.isBookmarked,
        );
      }
    });

    final isBookmarkedNow = _cards
        .firstWhere((c) => c.id == card.id)
        .isBookmarked;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isBookmarkedNow
              ? 'Tersimpan di Wishlist: ${card.placeName}'
              : 'Dihapus dari Wishlist: ${card.placeName}',
          style: AppTypography.body(fontSize: 13, color: Colors.white),
        ),
        backgroundColor: AppColors.darkButton,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEditAuditSheet(AuditCardData card) {
    final nameController = TextEditingController(text: card.placeName);
    final categoryController = TextEditingController(
      text: card.categoryDistance,
    );
    final reviewController = TextEditingController(text: card.reviewSnippet);
    AuditStatus currentStatus = card.status;
    double currentDecibel = card.decibel.toDouble();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            String getDecibelDesc(int db) {
              if (db <= 50) return 'Sangat Tenang • Akustik Lembut';
              if (db <= 65) return 'Tenang • Suasana Santai';
              if (db <= 75) return 'Sedang • Musik/Percakapan';
              return 'Bising • Loud Echo';
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sheet Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.15,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_note_rounded,
                            color: AppColors.primaryAccent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Edit Kunjungan Tempat',
                                style: AppTypography.headlineSerif(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Perbarui status, catatan, atau tingkat kebisingan',
                                style: AppTypography.label(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // 1. Status Selection Pills
                    Text(
                      'Status Rekomendasi',
                      style: AppTypography.label(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatusOptionPill(
                          title: 'Recomended',
                          status: AuditStatus.rekomendasiKunjungiLagi,
                          color: AppColors.badgeBlueText,
                          bgColor: AppColors.badgeBlueBg,
                          dotColor: AppColors.blueDot,
                          isSelected:
                              currentStatus == AuditStatus.rekomendasiKunjungiLagi,
                          onTap: () {
                            setModalState(
                              () => currentStatus = AuditStatus.rekomendasiKunjungiLagi,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildStatusOptionPill(
                          title: 'Wishlist',
                          status: AuditStatus.wishlistSetelahKunjungan,
                          color: AppColors.badgePinkText,
                          bgColor: AppColors.badgePinkBg,
                          dotColor: AppColors.pinkDot,
                          isSelected: currentStatus == AuditStatus.wishlistSetelahKunjungan,
                          onTap: () {
                            setModalState(
                              () => currentStatus = AuditStatus.wishlistSetelahKunjungan,
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _buildStatusOptionPill(
                          title: 'Tidak Rekomen',
                          status: AuditStatus.tidakRekomendasi,
                          color: AppColors.badgeOrangeText,
                          bgColor: AppColors.badgeOrangeBg,
                          dotColor: AppColors.orangeDot,
                          isSelected:
                              currentStatus == AuditStatus.tidakRekomendasi,
                          onTap: () {
                            setModalState(
                              () =>
                                  currentStatus = AuditStatus.tidakRekomendasi,
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 2. Place Name Field
                    Text(
                      'Nama Tempat',
                      style: AppTypography.label(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      style: AppTypography.body(fontSize: 13.5),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5DFDC),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5DFDC),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 3. Category & Distance Field
                    Text(
                      'Kategori & Area',
                      style: AppTypography.label(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: categoryController,
                      style: AppTypography.body(fontSize: 13.5),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5DFDC),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5DFDC),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 4. Acoustic Sound Slider
                    Row(
                      children: [
                        Text(
                          'Kebisingan: ${currentDecibel.round()} dB',
                          style: AppTypography.label(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            getDecibelDesc(currentDecibel.round()),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.label(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: currentDecibel,
                      min: 40,
                      max: 85,
                      divisions: 9,
                      activeColor: AppColors.primaryAccent,
                      onChanged: (val) {
                        setModalState(() => currentDecibel = val);
                      },
                    ),

                    const SizedBox(height: 10),

                    // 5. Personal Note / Review
                    Text(
                      'Catatan Kunjungan / Ulasan Pribadi',
                      style: AppTypography.label(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: reviewController,
                      maxLines: 3,
                      style: AppTypography.body(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Tuliskan catatan suasana, rekomendasi kursi, dsb...',
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5DFDC),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5DFDC),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 6. Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final newName = nameController.text.trim();
                          final newCategory = categoryController.text.trim();
                          final newReview = reviewController.text.trim();

                          String label;
                          switch (currentStatus) {
                            case AuditStatus.rekomendasiKunjungiLagi:
                              label = 'Recomended';
                              break;
                            case AuditStatus.wishlistSetelahKunjungan:
                              label = 'Wishlist';
                              break;
                            case AuditStatus.tidakRekomendasi:
                              label = 'Tidak Rekomendasi';
                              break;
                          }

                          setState(() {
                            final idx = _cards.indexWhere(
                              (c) => c.id == card.id,
                            );
                            if (idx != -1) {
                              _cards[idx] = _cards[idx].copyWith(
                                placeName: newName.isNotEmpty
                                    ? newName
                                    : card.placeName,
                                categoryDistance: newCategory.isNotEmpty
                                    ? newCategory
                                    : card.categoryDistance,
                                status: currentStatus,
                                statusLabel: label,
                                decibel: currentDecibel.round(),
                                decibelDescription: getDecibelDesc(
                                  currentDecibel.round(),
                                ),
                                reviewSnippet: newReview.isNotEmpty
                                    ? newReview
                                    : card.reviewSnippet,
                              );
                            }
                          });

                          Navigator.pop(sheetContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Kunjungan "${newName.isNotEmpty ? newName : card.placeName}" berhasil diperbarui!',
                                style: AppTypography.body(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: AppColors.darkButton,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkButton,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text(
                          'Simpan Perubahan',
                          style: AppTypography.label(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusOptionPill({
    required String title,
    required AuditStatus status,
    required Color color,
    required Color bgColor,
    required Color dotColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? bgColor : AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : const Color(0xFFE2DDD9),
              width: isSelected ? 1.4 : 0.8,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: dotColor.withValues(alpha: 0.16),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6.5,
                height: 6.5,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  title,
                  style: AppTypography.label(
                    fontSize: 10.5,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? color : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAuditSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_location_alt_rounded,
                      color: AppColors.primaryAccent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catat Kunjungan Baru',
                          style: AppTypography.headlineSerif(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Simpan tempat baru dengan verifikasi suasana & foto',
                          style: AppTypography.label(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildAuditQuickAction(
                icon: Icons.graphic_eq_rounded,
                title: 'Ukur Desibel (Sound Meter)',
                subtitle: 'Kalibrasi kenyamanan audio selama di lokasi',
                color: AppColors.badgeGreenText,
                bg: AppColors.badgeGreenBg,
              ),
              const SizedBox(height: 10),
              _buildAuditQuickAction(
                icon: Icons.camera_alt_outlined,
                title: 'Ambil Foto Suasana & Meja',
                subtitle: 'Unggah bukti visual tempat kerja atau santai',
                color: AppColors.textPrimary,
                bg: const Color(0xFFF0EBE7),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkButton,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Tutup',
                    style: AppTypography.label(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuditQuickAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5DFDC)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.label(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.body(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCards;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            PlaceProofTopBar(
              searchController: _searchController,
              onSearchChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),

            const SizedBox(height: 8),

            // Horizontal Filter Pills
            QuickFilterPills(
              selectedFilterId: _selectedFilterId,
              onFilterSelected: (id) {
                setState(() {
                  _selectedFilterId = id;
                  if (id == 'wishlist_selesai' || id == 'wishlist') {
                    _currentNavIndex = 1; // Otomatis masuk ke navigation wishlist
                  } else {
                    _currentNavIndex = 0; // Kembali ke navigation Home jika filter lain
                  }
                });
              },
            ),

            const SizedBox(height: 8),

            // Stream Feed
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: AppColors.textTertiary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tidak ada tempat yang sesuai',
                              style: AppTypography.headlineSerif(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Coba ubah kata kunci pencarian atau reset filter pill',
                              style: AppTypography.body(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedFilterId = 'all';
                                  _searchQuery = '';
                                  _searchController.clear();
                                });
                              },
                              child: Text(
                                'Reset Semua Filter',
                                style: AppTypography.label(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 20),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final card = filtered[index];
                        return AuditCardWidget(
                          data: card,
                          onDirectionsTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Membuka navigasi ke ${card.placeName}...',
                                  style: AppTypography.body(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.darkButton,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          onEditTap: () => _showEditAuditSheet(card),
                          onBookmarkTap: () => _toggleBookmark(index, card),
                          onShareTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Tautan bukti tempat disalin ke clipboard!',
                                  style: AppTypography.body(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.darkButton,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PlaceProofBottomNav(
        currentIndex: _currentNavIndex,
        onIndexChanged: (idx) {
          setState(() {
            _currentNavIndex = idx;
            if (idx == 1) {
              _selectedFilterId = 'wishlist_selesai';
            } else if (idx == 0) {
              _selectedFilterId = 'all';
            }
          });
        },
        onAddAuditTap: _showAddAuditSheet,
      ),
    );
  }
}
