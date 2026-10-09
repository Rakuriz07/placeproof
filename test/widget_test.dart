import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:placeproof/main.dart';

// 1x1 transparent PNG
final Uint8List _transparentImage = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([_transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('PlaceProof app smoke test & edit bottom sheet test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const PlaceProofApp());
    await tester.pumpAndSettle();

    expect(find.text('PlaceProof'), findsOneWidget);
    expect(find.text('Kopi Mandja Sanctuary & Atelier'), findsOneWidget);
    expect(find.text('Edit Kunjungan'), findsWidgets);

    // Verify clean status and pill labels
    expect(find.text('Recomended'), findsWidgets);
    expect(find.text('Wishlist'), findsWidgets);
    expect(find.text('Recomended Kunjungi Lagi'), findsNothing);
    expect(find.text('Wishlist Setelah Dikunjungi'), findsNothing);

    // Scroll to make sure Edit Kunjungan button is in view, then tap it
    final editButton = find.text('Edit Kunjungan').first;
    await tester.ensureVisible(editButton);
    await tester.pumpAndSettle();
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    expect(find.text('Edit Kunjungan Tempat'), findsOneWidget);
    expect(find.text('Status Rekomendasi'), findsOneWidget);
    expect(find.text('Simpan Perubahan'), findsOneWidget);

    // Close the sheet
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    // Verify main feed scrolling
    final verticalFeed = find.byWidgetPredicate(
      (widget) => widget is ListView && widget.scrollDirection == Axis.vertical,
    );
    await tester.drag(verticalFeed, const Offset(0, -600));
    await tester.pumpAndSettle();
    expect(find.text('Roastery Blok Timur'), findsOneWidget);

    // Scroll back up
    await tester.drag(verticalFeed, const Offset(0, 600));
    await tester.pumpAndSettle();

    // Tap Wishlist pill
    final wishlistPill = find.widgetWithText(InkWell, 'Wishlist').first;
    await tester.ensureVisible(wishlistPill);
    await tester.pumpAndSettle();
    await tester.tap(wishlistPill, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Verify Wishlist places are displayed
    expect(find.text('Roastery Blok Timur'), findsOneWidget);
  });
}
