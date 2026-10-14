import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import '../models/audit_card_data.dart';
import '../theme/app_theme.dart';

class AuditCardWidget extends StatelessWidget {
  final AuditCardData data;
  final VoidCallback? onDirectionsTap;
  final VoidCallback? onEditTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onShareTap;

  const AuditCardWidget({
    super.key,
    required this.data,
    this.onDirectionsTap,
    this.onEditTap,
    this.onBookmarkTap,
    this.onShareTap,
  });

  Color get _containerBg {
    switch (data.status) {
      case AuditStatus.rekomendasiKunjungiLagi:
        return AppColors.cardBlueBg; // Biru
      case AuditStatus.wishlistSetelahKunjungan:
        return AppColors.cardPinkBg; // Merah muda
      case AuditStatus.tidakRekomendasi:
        return AppColors.cardOrangeBg; // Oren
    }
  }

  Color get _borderColor {
    switch (data.status) {
      case AuditStatus.rekomendasiKunjungiLagi:
        return AppColors.cardBlueBorder;
      case AuditStatus.wishlistSetelahKunjungan:
        return AppColors.cardPinkBorder;
      case AuditStatus.tidakRekomendasi:
        return AppColors.cardOrangeBorder;
    }
  }

  Color get _badgeBg {
    switch (data.status) {
      case AuditStatus.rekomendasiKunjungiLagi:
        return AppColors.badgeBlueBg;
      case AuditStatus.wishlistSetelahKunjungan:
        return AppColors.badgePinkBg;
      case AuditStatus.tidakRekomendasi:
        return AppColors.badgeOrangeBg;
    }
  }

  Color get _badgeText {
    switch (data.status) {
      case AuditStatus.rekomendasiKunjungiLagi:
        return AppColors.badgeBlueText;
      case AuditStatus.wishlistSetelahKunjungan:
        return AppColors.badgePinkText;
      case AuditStatus.tidakRekomendasi:
        return AppColors.badgeOrangeText;
    }
  }

  Color get _dotColor {
    switch (data.status) {
      case AuditStatus.rekomendasiKunjungiLagi:
        return AppColors.blueDot;
      case AuditStatus.wishlistSetelahKunjungan:
        return AppColors.pinkDot;
      case AuditStatus.tidakRekomendasi:
        return AppColors.orangeDot;
    }
  }

  IconData get _statusIcon {
    switch (data.status) {
      case AuditStatus.rekomendasiKunjungiLagi:
        return Icons.thumb_up_alt_rounded;
      case AuditStatus.wishlistSetelahKunjungan:
        return Icons.favorite_rounded;
      case AuditStatus.tidakRekomendasi:
        return Icons.do_not_disturb_alt_rounded;
    }
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _badgeBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: _dotColor.withValues(alpha: 0.14),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _statusIcon,
            size: 12,
            color: _dotColor,
          ),
          const SizedBox(width: 5),
          Text(
            data.statusLabel,
            style: AppTypography.label(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _badgeText,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _containerBg,
            Colors.white,
          ],
          stops: const [0.0, 0.45],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _dotColor.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Photos at the very TOP (clean & unobstructed)
          if (data.photos.isNotEmpty) ...[
            _buildPhotoGallery(),
            const SizedBox(height: 14),
          ],

          // 2. Place Name Header Row with Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.placeName,
                  style: AppTypography.headlineSerif(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _buildStatusBadge(),
            ],
          ),

          const SizedBox(height: 4),

          // 3. Category & Distance
          Text(
            data.categoryDistance,
            style: AppTypography.body(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),

          // Hasil Noise Meter di kontainer kartu tempat (misal 56 dB)
          if (data.noiseDecibel != null) ...[
            const SizedBox(height: 10),
            _buildNoiseResultContainer(data.noiseDecibel!),
          ],

          const SizedBox(height: 14),

          // 4. Clean Review / Personal Notes Card
          _buildReviewCard(),

          const SizedBox(height: 14),

          // 5. Action Bar (Petunjuk Arah, Bookmark, Edit Kunjungan)
          _buildActionBar(),
        ],
      ),
    );
  }

  String _getSoundCategoryLabel(double db) {
    if (db <= 50) return 'Sangat Tenang (Fokus)';
    if (db <= 65) return 'Tenang (Santai)';
    if (db <= 75) return 'Sedang (Percakapan)';
    return 'Bising (Ramai)';
  }

  Color _getSoundColor(double db) {
    if (db <= 50) return const Color(0xFF10B981);
    if (db <= 65) return const Color(0xFF2563EB);
    if (db <= 75) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  Widget _buildNoiseResultContainer(double db) {
    final color = _getSoundColor(db);
    final label = _getSoundCategoryLabel(db);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: color.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.graphic_eq_rounded,
              size: 15,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${db.toStringAsFixed(0)} dB',
            style: AppTypography.headlineSerif(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '•  $label',
              style: AppTypography.label(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          // Ambient Level Mini Bar
          SizedBox(
            width: 44,
            height: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: ((db - 30) / 70).clamp(0.08, 1.0),
                backgroundColor: color.withValues(alpha: 0.16),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGallery() {
    final photos = data.photos;
    if (photos.isEmpty) return const SizedBox.shrink();

    if (photos.length == 1) {
      return SizedBox(
        height: 160,
        width: double.infinity,
        child: _buildPhotoTile(
          photos[0],
          borderRadius: BorderRadius.circular(14),
          isHero: true,
        ),
      );
    }

    if (photos.length == 2) {
      return SizedBox(
        height: 154,
        child: LayoutGrid(
          columnGap: 8,
          rowGap: 8,
          columnSizes: [1.fr, 1.fr],
          rowSizes: [1.fr],
          children: [
            _buildPhotoTile(
              photos[0],
              borderRadius: BorderRadius.circular(13),
            ),
            _buildPhotoTile(
              photos[1],
              borderRadius: BorderRadius.circular(13),
            ),
          ],
        ),
      );
    }

    // 3 or more photos: Editorial Collage (1 Hero on left, 2 stacked thumbnails on right)
    final extraCount = photos.length > 3 ? '+${photos.length - 2}' : null;

    return SizedBox(
      height: 186,
      child: LayoutGrid(
        columnGap: 8,
        rowGap: 8,
        columnSizes: [1.75.fr, 1.fr],
        rowSizes: [1.fr, 1.fr],
        areas: '''
          hero thumb1
          hero thumb2
        ''',
        children: [
          NamedAreaGridPlacement(
            areaName: 'hero',
            child: _buildPhotoTile(
              photos[0],
              borderRadius: BorderRadius.circular(14),
              isHero: true,
            ),
          ),
          NamedAreaGridPlacement(
            areaName: 'thumb1',
            child: _buildPhotoTile(
              photos[1],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          NamedAreaGridPlacement(
            areaName: 'thumb2',
            child: _buildPhotoTile(
              photos[2],
              borderRadius: BorderRadius.circular(12),
              extraCountBadge: extraCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTile(
    ProofPhotoItem photo, {
    required BorderRadius borderRadius,
    bool isHero = false,
    String? extraCountBadge,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          photo.imageUrl.startsWith('http://') ||
                  photo.imageUrl.startsWith('https://')
              ? Image.network(
                  photo.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFDDD5CE),
                      child: Center(
                        child: Icon(
                          Icons.coffee_rounded,
                          size: isHero ? 32 : 22,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFFEEE8E3),
                      child: const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Image.file(
                  File(photo.imageUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFDDD5CE),
                      child: Center(
                        child: Icon(
                          Icons.image_rounded,
                          size: isHero ? 32 : 22,
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                    );
                  },
                ),
          // Gradient shadow overlay at the bottom for caption readability
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: isHero ? 48 : 36,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.72),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Caption label
          Positioned(
            bottom: 6,
            left: 8,
            right: extraCountBadge != null ? 36 : 8,
            child: Text(
              photo.caption,
              style: AppTypography.label(
                fontSize: isHero ? 11 : 9.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Extra count badge if needed (e.g. +2)
          if (extraCountBadge != null)
            Positioned(
              bottom: 5,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  extraCountBadge,
                  style: AppTypography.label(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E2DE), width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '“${data.reviewSnippet}”',
            style: AppTypography.body(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              data.auditDate,
              style: AppTypography.label(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        // 1. Petunjuk Arah (Left)
        Expanded(
          flex: 5,
          child: ElevatedButton.icon(
            onPressed: onDirectionsTap,
            icon: const Icon(Icons.near_me_rounded, size: 16),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Petunjuk Arah',
                style: AppTypography.label(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkButton,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: AppColors.darkButton.withValues(alpha: 0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 2. Bookmark Button (Center)
        Tooltip(
          message: data.isBookmarked ? 'Tersimpan (Saved)' : 'Simpan Tempat',
          child: InkWell(
            onTap: onBookmarkTap,
            borderRadius: BorderRadius.circular(22),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 44,
              decoration: BoxDecoration(
                color: data.isBookmarked
                    ? const Color(0xFFFDF2F0)
                    : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: data.isBookmarked
                      ? const Color(0xFFF8CDC6)
                      : const Color(0xFFE2DDD9),
                  width: 1.2,
                ),
                boxShadow: data.isBookmarked
                    ? [
                        BoxShadow(
                          color: AppColors.primaryAccent.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Icon(
                data.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                size: 20,
                color: data.isBookmarked
                    ? AppColors.primaryAccent
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 3. Edit Kunjungan (Right)
        Expanded(
          flex: 5,
          child: OutlinedButton(
            onPressed: onEditTap,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: Color(0xFFE2DDD9), width: 1.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Edit Kunjungan',
                style: AppTypography.label(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
