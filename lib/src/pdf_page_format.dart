import 'package:pdf/pdf.dart' as pdf_pkg;

/// Page formats and physical dimensions in points (72 points = 1 inch).
class PdfPageFormat {
  final double width;
  final double height;

  const PdfPageFormat(this.width, this.height);

  /// ISO A4 Paper format (210mm x 297mm) -> (595.28 pt x 841.89 pt)
  static const PdfPageFormat a4 = PdfPageFormat(595.28, 841.89);

  /// US Letter Paper format (8.5in x 11in) -> (612.0 pt x 792.0 pt)
  static const PdfPageFormat letter = PdfPageFormat(612.0, 792.0);

  /// US Legal Paper format (8.5in x 14in) -> (612.0 pt x 1008.0 pt)
  static const PdfPageFormat legal = PdfPageFormat(612.0, 1008.0);

  /// Standard POS Thermal Receipt format (80mm width) -> (226.77 pt x 500.0 pt)
  static const PdfPageFormat receipt80 = PdfPageFormat(226.77, 500.0);

  /// Returns landscape orientation for this format.
  PdfPageFormat get landscape =>
      width >= height ? this : PdfPageFormat(height, width);

  /// Returns portrait orientation for this format.
  PdfPageFormat get portrait =>
      height >= width ? this : PdfPageFormat(height, width);

  /// Converts this format into the underlying PDF engine format.
  pdf_pkg.PdfPageFormat toNativePdfPageFormat() {
    return pdf_pkg.PdfPageFormat(width, height);
  }
}
