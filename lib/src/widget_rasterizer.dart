import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Utilities for rasterizing onscreen or offscreen Flutter widgets into high-resolution images.
class WidgetRasterizer {
  /// Captures an onscreen widget wrapped in a [RepaintBoundary] identified by [boundaryKey].
  static Future<Uint8List> captureFromKey(
    GlobalKey boundaryKey, {
    double pixelRatio = 2.0,
  }) async {
    final boundary = boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;

    if (boundary == null) {
      throw StateError(
        'The provided GlobalKey did not find a RenderRepaintBoundary. '
        'Ensure the target widget is wrapped in a RepaintBoundary(key: key).',
      );
    }

    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw StateError('Failed to convert rendered widget to PNG byte stream.');
    }

    return byteData.buffer.asUint8List();
  }

  /// Rasterizes an arbitrary offscreen Flutter widget tree with target dimensions without
  /// displaying it visibly to the user.
  static Future<Uint8List> captureOffscreenWidget(
    BuildContext context,
    Widget widget, {
    required Size size,
    double pixelRatio = 2.0,
  }) async {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      throw StateError(
        'WidgetRasterizer requires an active Overlay in the widget tree. '
        'Ensure the context has a Navigator or MaterialApp ancestor.',
      );
    }

    final boundaryKey = GlobalKey();
    final completer = Completer<Uint8List>();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) {
        return Positioned(
          left: -size.width - 2000,
          top: -size.height - 2000,
          width: size.width,
          height: size.height,
          child: Material(
            type: MaterialType.transparency,
            child: RepaintBoundary(
              key: boundaryKey,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: widget,
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    // Wait until rendering pipeline finishes drawing this frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        final bytes = await captureFromKey(boundaryKey, pixelRatio: pixelRatio);
        completer.complete(bytes);
      } catch (e, st) {
        completer.completeError(e, st);
      } finally {
        entry.remove();
      }
    });

    return completer.future;
  }

  /// Rasterizes a sequence of offscreen widgets into a list of PNG image byte arrays.
  static Future<List<Uint8List>> captureOffscreenWidgets(
    BuildContext context,
    List<Widget> pages, {
    required Size size,
    double pixelRatio = 2.0,
  }) async {
    final results = <Uint8List>[];
    for (final page in pages) {
      final img = await captureOffscreenWidget(
        context,
        page,
        size: size,
        pixelRatio: pixelRatio,
      );
      results.add(img);
    }
    return results;
  }
}
