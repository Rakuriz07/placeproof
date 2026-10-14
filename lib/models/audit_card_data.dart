enum AuditStatus {
  rekomendasiKunjungiLagi, // Biru: Recomended
  wishlistSetelahKunjungan, // Merah muda: Wishlist
  tidakRekomendasi, // Oren: Tidak rekomendasi
}

class ProofPhotoItem {
  final String imageUrl;
  final String caption;

  const ProofPhotoItem({
    required this.imageUrl,
    required this.caption,
  });
}

class AuditCardData {
  final String id;
  final String placeName;
  final String categoryDistance;
  final AuditStatus status;
  final String statusLabel;
  final List<ProofPhotoItem> photos;
  final String reviewSnippet;
  final String auditDate;
  final String auditorHandle;
  final bool isBookmarked;
  final double? noiseDecibel;

  const AuditCardData({
    required this.id,
    required this.placeName,
    required this.categoryDistance,
    required this.status,
    required this.statusLabel,
    this.photos = const [],
    required this.reviewSnippet,
    required this.auditDate,
    required this.auditorHandle,
    this.isBookmarked = false,
    this.noiseDecibel,
  });

  AuditCardData copyWith({
    String? placeName,
    String? categoryDistance,
    AuditStatus? status,
    String? statusLabel,
    List<ProofPhotoItem>? photos,
    String? reviewSnippet,
    String? auditDate,
    String? auditorHandle,
    bool? isBookmarked,
    double? noiseDecibel,
  }) {
    return AuditCardData(
      id: id,
      placeName: placeName ?? this.placeName,
      categoryDistance: categoryDistance ?? this.categoryDistance,
      status: status ?? this.status,
      statusLabel: statusLabel ?? this.statusLabel,
      photos: photos ?? this.photos,
      reviewSnippet: reviewSnippet ?? this.reviewSnippet,
      auditDate: auditDate ?? this.auditDate,
      auditorHandle: auditorHandle ?? this.auditorHandle,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      noiseDecibel: noiseDecibel ?? this.noiseDecibel,
    );
  }
}
