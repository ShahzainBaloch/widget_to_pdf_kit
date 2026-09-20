# widget_to_pdf_kit

High-performance Flutter widget-to-PDF generator. Effortlessly rasterize onscreen or offscreen Flutter widgets into crisp, paginated PDF documents with custom page formats and DPI scaling.

[![pub package](https://img.shields.io/pub/v/widget_to_pdf_kit.svg)](https://pub.dev/packages/widget_to_pdf_kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

---

## ✨ Features

- 📑 **True Flutter Widget Support**: Export your existing Flutter UI (invoices, receipts, charts, cards) directly to PDF without rewriting them in proprietary PDF drawing APIs.
- 🔄 **Multi-Page Synthesis**: Supply a list of widgets (`List<Widget> pages`) to generate paginated, multi-page documents offscreen.
- 📐 **Standard Paper Formats**: Built-in support for ISO A4, US Letter, US Legal, and 80mm POS Thermal Receipts (with portrait & landscape modes).
- 🔍 **High-DPI Retina Scaling**: Configurable `pixelRatio` (e.g. `2.0`, `3.0`) ensures razor-sharp text and graphics for print.
- ⚡ **Cross-Platform**: Works smoothly on iOS, Android, macOS, Windows, Linux, and Web.

---

## 🚀 Getting Started

Add `widget_to_pdf_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  widget_to_pdf_kit: ^1.0.0
```

Import the package:

```dart
import 'package:widget_to_pdf_kit/widget_to_pdf_kit.dart';
```

---

## 💡 Quick Examples

### 1. Export an Onscreen Widget

Wrap your widget with a `RepaintBoundary` and supply its `GlobalKey`:

```dart
final repaintKey = GlobalKey();

// In your build method:
RepaintBoundary(
  key: repaintKey,
  child: InvoiceCard(...),
);

// When user taps "Export":
final Uint8List pdfBytes = await WidgetToPdfKit.fromKey(
  repaintKey,
  format: PdfPageFormat.a4,
  pixelRatio: 2.5,
);
```

### 2. Generate a Multi-Page PDF Offscreen

Synthesize report pages offscreen without displaying them on the user's screen:

```dart
final Uint8List pdfBytes = await WidgetToPdfKit.fromWidgets(
  context,
  pages: [
    ReportSummaryPage(),
    FinancialBreakdownPage(),
    AuditLogPage(),
  ],
  format: PdfPageFormat.a4,
  pixelRatio: 2.0,
);
```

---

## 🛠️ Page Formats

| Format | Dimensions (pt) | Typical Use |
|---|---|---|
| `PdfPageFormat.a4` | `595.28 x 841.89` | Standard international invoices & contracts |
| `PdfPageFormat.letter` | `612.00 x 792.00` | North American business reports |
| `PdfPageFormat.legal` | `612.00 x 1008.00` | Legal notices |
| `PdfPageFormat.receipt80` | `226.77 x 500.00` | 80mm POS thermal receipts |

Toggle orientation easily:
```dart
PdfPageFormat.a4.landscape
PdfPageFormat.letter.portrait
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
Copyright © 2026 [Shahzain Baloch](https://github.com/ShahzainBaloch).
