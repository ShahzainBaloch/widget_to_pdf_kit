import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:widget_to_pdf_kit/widget_to_pdf_kit.dart';

void main() {
  test('PdfPageFormat dimensions and conversions', () {
    const a4 = PdfPageFormat.a4;
    expect(a4.width, closeTo(595.28, 0.01));
    expect(a4.height, closeTo(841.89, 0.01));
    expect(a4.portrait.width, lessThan(a4.portrait.height));
    expect(a4.landscape.width, greaterThan(a4.landscape.height));

    const letter = PdfPageFormat.letter;
    expect(letter.width, equals(612.0));
    expect(letter.height, equals(792.0));
  });

  testWidgets('Renders onscreen widget and builds valid PDF file bytes',
      (tester) async {
    final repaintKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RepaintBoundary(
            key: repaintKey,
            child: Container(
              width: 300,
              height: 200,
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text(
                'INVOICE #1024',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final Uint8List? imageBytes = await tester.runAsync(() async {
      return await WidgetRasterizer.captureFromKey(
        repaintKey,
        pixelRatio: 1.0,
      );
    });

    expect(imageBytes, isNotNull);
    expect(imageBytes, isNotEmpty);

    final pdfBytes = await PdfDocumentBuilder.buildPdf(
      pageImages: [imageBytes!],
      format: PdfPageFormat.a4,
    );

    expect(pdfBytes, isNotEmpty);

    // Verify PDF header magic bytes "%PDF-"
    final header = ascii.decode(pdfBytes.sublist(0, 5));
    expect(header, equals('%PDF-'));
  });
}
