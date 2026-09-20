import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'pdf_document_builder.dart';
import 'pdf_page_format.dart';
import 'widget_rasterizer.dart';

/// Primary interface for converting Flutter widget trees into high-resolution PDF documents.
class WidgetToPdfKit {
  /// Rasterizes a sequence of Flutter widgets (one per PDF page) and compiles them
  /// into a multi-page PDF document.
  static Future<Uint8List> fromWidgets(
    BuildContext context, {
    required List<Widget> pages,
    PdfPageFormat format = PdfPageFormat.a4,
    double pixelRatio = 2.0,
  }) async {
    final imageList = await WidgetRasterizer.captureOffscreenWidgets(
      context,
      pages,
      size: Size(format.width, format.height),
      pixelRatio: pixelRatio,
    );

    return PdfDocumentBuilder.buildPdf(
      pageImages: imageList,
      format: format,
    );
  }

  /// Rasterizes a single Flutter widget into a single-page PDF document.
  static Future<Uint8List> fromWidget(
    BuildContext context, {
    required Widget widget,
    PdfPageFormat format = PdfPageFormat.a4,
    double pixelRatio = 2.0,
  }) async {
    return fromWidgets(
      context,
      pages: [widget],
      format: format,
      pixelRatio: pixelRatio,
    );
  }

  /// Compiles an already-rendered onscreen widget into a single-page PDF document
  /// using its [GlobalKey] (must be attached to a [RepaintBoundary]).
  static Future<Uint8List> fromKey(
    GlobalKey boundaryKey, {
    PdfPageFormat format = PdfPageFormat.a4,
    double pixelRatio = 2.0,
  }) async {
    final image = await WidgetRasterizer.captureFromKey(
      boundaryKey,
      pixelRatio: pixelRatio,
    );

    return PdfDocumentBuilder.buildPdf(
      pageImages: [image],
      format: format,
    );
  }
}
