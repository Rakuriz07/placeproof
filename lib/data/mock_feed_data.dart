import '../models/audit_card_data.dart';

class MockFeedData {
  static final List<AuditCardData> sampleCards = [
    const AuditCardData(
      id: 'card-1',
      placeName: 'Kopi Mandja Sanctuary & Atelier',
      categoryDistance: 'Specialty Coffee & Co-working • 1.2 km (Menteng)',
      status: AuditStatus.rekomendasiKunjungiLagi,
      statusLabel: 'Recomended',
      photos: [
        ProofPhotoItem(
          imageUrl:
              'https://images.unsplash.com/photo-1527192491265-7e15c55b1ed2?w=600&auto=format&fit=crop&q=80',
          caption: 'Sudut Meja',
        ),
        ProofPhotoItem(
          imageUrl:
              'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=600&auto=format&fit=crop&q=80',
          caption: 'Suasana Tenang',
        ),
        ProofPhotoItem(
          imageUrl:
              'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&auto=format&fit=crop&q=80',
          caption: 'Kopi & Hidangan',
        ),
      ],
      reviewSnippet:
          'Suasananya sangat ramah neurodivergent, playlist jazz lofi pelan, staf tidak berisik. Meja kayu solid tinggi pas untuk laptop 4+ jam.',
      auditDate: '14 Des 2024',
      auditorHandle: '@dimasradit',
      isBookmarked: false,
      noiseDecibel: 48.0,
    ),
    const AuditCardData(
      id: 'card-2',
      placeName: 'Roastery Blok Timur',
      categoryDistance: 'Cafe & Eatery • 3.4 km (Senopati)',
      status: AuditStatus.wishlistSetelahKunjungan,
      statusLabel: 'Wishlist',
      photos: [
        ProofPhotoItem(
          imageUrl:
              'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=600&auto=format&fit=crop&q=80',
          caption: 'Area Utama',
        ),
        ProofPhotoItem(
          imageUrl:
              'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&auto=format&fit=crop&q=80',
          caption: 'Kopi & Pastry',
        ),
      ],
      reviewSnippet:
          'Kopi dan makanannya juara 10/10, tapi musik trap beat agak kencang saat jam makan siang. Masuk daftar wishlist untuk dikunjungi kembali saat jam santai.',
      auditDate: '11 Des 2024',
      auditorHandle: '@rendi_craft',
      isBookmarked: true,
      noiseDecibel: 56.0,
    ),
    const AuditCardData(
      id: 'card-3',
      placeName: 'Neon & Bass Cafe Hub',
      categoryDistance: 'Bistro & Coffee • 2.1 km',
      status: AuditStatus.tidakRekomendasi,
      statusLabel: 'Tidak Rekomendasi',
      photos: [],
      reviewSnippet:
          'Echo ruangan parah, musik kencang, tidak ramah sensory overload dan meja goyang.',
      auditDate: '08 Des 2024',
      auditorHandle: '@naomi_wfc',
      isBookmarked: false,
      noiseDecibel: 78.0,
    ),
  ];
}
