import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'pdf_page_format.dart';

/// Compiles rasterized page images into standard PDF documents.
class PdfDocumentBuilder {
  /// Compiles a list of page PNG/JPEG image bytes into a unified multi-page PDF document.
  static Future<Uint8List> buildPdf({
    required List<Uint8List> pageImages,
    required PdfPageFormat format,
  }) async {
    final pdf = pw.Document();

    for (final imgBytes in pageImages) {
      final image = pw.MemoryImage(imgBytes);
      pdf.addPage(
        pw.Page(
          pageFormat: format.toNativePdfPageFormat(),
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Center(
                child: pw.Image(
                  image,
                  fit: pw.BoxFit.contain,
                ),
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }
}
