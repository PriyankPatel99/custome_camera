import 'dart:io';

import 'package:flutter/material.dart';

class CameraViewPage extends StatelessWidget {
  const CameraViewPage({Key? key, required this.path}) : super(key: key);
  final String path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),

            // Container(
            //   decoration: const ShapeDecoration(
            //     shape: CardScannerOverlayShape(
            //       borderColor: Colors.red,
            //       borderRadius: 120,
            //       borderLength: 32,
            //       borderWidth: 8,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
    print(path);
  }
}

const _OFFSET_X_FACTOR = 0.07;

class CardScannerOverlayShape extends ShapeBorder {
  const CardScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 8.0,
    this.overlayColor = Colors.blue,
    this.borderRadius = 12,
    this.borderLength = 32,
    this.cutOutBottomOffset = 0,
  });

  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutBottomOffset;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path _getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return _getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final offsetX = rect.width * _OFFSET_X_FACTOR;
    final cardWidth = rect.width - offsetX * 8;
    final cardHeight = cardWidth * 1;
    final offsetY = (rect.height - cardHeight) / 2;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    // final borderPaint = Paint()
    //   ..color = borderColor
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = borderWidth;

    final boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final cutOutRect = Rect.fromLTWH(
      rect.left + offsetX * 4,
      rect.top + offsetY * 1.5,
      cardWidth,
      cardHeight,
    );
    final cutOutRect1 = Rect.fromLTWH(
      rect.left + offsetX * 4,
      rect.top + offsetY / 1.6,
      cardWidth,
      cardHeight,
    );

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect1,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return CardScannerOverlayShape(
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}
