import 'package:flutter/material.dart';

class MyCustomContainer extends StatelessWidget {
  const MyCustomContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
            ),
            Container(
              decoration: const ShapeDecoration(
                shape: CardScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 120,
                  borderLength: 32,
                  borderWidth: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _OFFSET_X_FACTOR = 0.07;

class CardScannerOverlayShape extends ShapeBorder {
  const CardScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 8.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
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
      // Draw top right corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.right - borderLength,
      //     cutOutRect.top,
      //     cutOutRect.right,
      //     cutOutRect.top + borderLength,
      //     topRight: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw top left corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.left,
      //     cutOutRect.top,
      //     cutOutRect.left + borderLength,
      //     cutOutRect.top + borderLength,
      //     topLeft: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw bottom right corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.right - borderLength,
      //     cutOutRect.bottom - borderLength,
      //     cutOutRect.right,
      //     cutOutRect.bottom,
      //     bottomRight: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
      // // Draw bottom left corner
      // ..drawRRect(
      //   RRect.fromLTRBAndCorners(
      //     cutOutRect.left,
      //     cutOutRect.bottom - borderLength,
      //     cutOutRect.left + borderLength,
      //     cutOutRect.bottom,
      //     bottomLeft: Radius.circular(borderRadius),
      //   ),
      //   borderPaint,
      // )
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
