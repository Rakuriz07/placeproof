import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FilterPillItem {
  final String id;
  final String label;
  final Color? dotColor;
  final IconData? icon;

  const FilterPillItem({
    required this.id,
    required this.label,
    this.dotColor,
    this.icon,
  });
}

class QuickFilterPills extends StatelessWidget {
  final String selectedFilterId;
  final ValueChanged<String> onFilterSelected;

  const QuickFilterPills({
    super.key,
    required this.selectedFilterId,
    required this.onFilterSelected,
  });

  static const List<FilterPillItem> defaultFilters = [
    FilterPillItem(id: 'all', label: 'Semua Kunjungan'),
    FilterPillItem(
      id: 'rekomendasi',
      label: 'Recomended',
      dotColor: AppColors.blueDot,
    ),
    FilterPillItem(
      id: 'wishlist_selesai',
      label: 'Wishlist',
      dotColor: AppColors.pinkDot,
    ),
    FilterPillItem(
      id: 'tidak',
      label: 'Tidak Rekomendasi',
      dotColor: AppColors.orangeDot,
    ),
    FilterPillItem(
      id: 'visited',
      label: 'Kunjungan Saya',
      icon: Icons.history_edu_rounded,
    ),
    FilterPillItem(
      id: 'wishlist',
      label: 'Tersimpan',
      icon: Icons.bookmark_border_rounded,
    ),
    FilterPillItem(
      id: 'sound',
      label: '< 50 dB Tenang',
      icon: Icons.volume_down_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: defaultFilters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = defaultFilters[index];
          final isSelected = filter.id == selectedFilterId;

          return InkWell(
            onTap: () => onFilterSelected(filter.id),
            borderRadius: BorderRadius.circular(19),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkButton : Colors.white,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: isSelected ? AppColors.darkButton : const Color(0xFFE5DFDC),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.darkButton.withValues(alpha: 0.22),
                          blurRadius: 8,
                          offset: const Offset(0, 2.5),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter.dotColor != null) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: filter.dotColor,
                        shape: BoxShape.circle,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: filter.dotColor!.withValues(alpha: 0.6),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ] else if (filter.icon != null) ...[
                    Icon(
                      filter.icon,
                      size: 14,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    filter.label,
                    style: AppTypography.label(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
