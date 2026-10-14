import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class FilterPillItem {
  final String id;
  final String label;
  final Color? activeColor;
  final List<Color>? activeGradient;
  final Color? inactiveIconColor;
  final IconData icon;
  final IconData activeIcon;

  const FilterPillItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.activeColor,
    this.activeGradient,
    this.inactiveIconColor,
  });
}

class QuickFilterPills extends StatelessWidget {
  final String selectedFilterId;
  final ValueChanged<String> onFilterSelected;
  final Map<String, int>? itemCounts;

  const QuickFilterPills({
    super.key,
    required this.selectedFilterId,
    required this.onFilterSelected,
    this.itemCounts,
  });

  static const List<FilterPillItem> defaultFilters = [
    FilterPillItem(
      id: 'all',
      label: 'Semua Kunjungan',
      icon: Icons.explore_outlined,
      activeIcon: Icons.explore_rounded,
      activeColor: AppColors.darkButton,
      activeGradient: [Color(0xFF26201E), Color(0xFF14100F)],
      inactiveIconColor: AppColors.textSecondary,
    ),
    FilterPillItem(
      id: 'rekomendasi',
      label: 'Recomended',
      icon: Icons.thumb_up_alt_outlined,
      activeIcon: Icons.thumb_up_alt_rounded,
      activeColor: AppColors.blueDot,
      activeGradient: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
      inactiveIconColor: Color(0xFF2563EB),
    ),
    FilterPillItem(
      id: 'tidak',
      label: 'No Recomended',
      icon: Icons.thumb_down_alt_outlined,
      activeIcon: Icons.thumb_down_alt_rounded,
      activeColor: AppColors.orangeDot,
      activeGradient: [Color(0xFFEA580C), Color(0xFFC2410C)],
      inactiveIconColor: Color(0xFFEA580C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemCount: defaultFilters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final filter = defaultFilters[index];
          final isSelected = filter.id == selectedFilterId;
          final activeColor = filter.activeColor ?? AppColors.darkButton;
          final gradientColors =
              filter.activeGradient ?? [activeColor, activeColor];
          final glowColor = gradientColors.first;
          final count = itemCounts?[filter.id];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onFilterSelected(filter.id),
              borderRadius: BorderRadius.circular(22),
              splashColor: activeColor.withValues(alpha: 0.15),
              highlightColor: Colors.transparent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.22)
                        : const Color(0xFFE5DFDC),
                    width: isSelected ? 1.2 : 1.1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: glowColor.withValues(alpha: 0.38),
                            blurRadius: 10,
                            offset: const Offset(0, 3.5),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 4,
                            offset: const Offset(0, 1.5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? filter.activeIcon : filter.icon,
                      size: 15.5,
                      color: isSelected
                          ? Colors.white
                          : (filter.inactiveIconColor ??
                                AppColors.textSecondary),
                    ),
                    const SizedBox(width: 6.5),
                    Text(
                      filter.label,
                      style: AppTypography.label(
                        fontSize: 12.5,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (count != null) ...[
                      const SizedBox(width: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6.5,
                          vertical: 1.5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.24)
                              : const Color(0xFFF1ECE8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: AppTypography.label(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
