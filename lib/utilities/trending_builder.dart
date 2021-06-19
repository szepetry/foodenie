import 'package:flutter/material.dart';
import 'dart:math' as math;

class TrendingBuilder extends StatelessWidget {
  final String number;
  final String asset;

  const TrendingBuilder({Key key, @required this.asset, @required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            // alignment: AlignmentDirectional.center,
            // fit: StackFit.expand,
            children: [
              Container(
                height: 100,
                width: 170,
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 100,
                right: 60,
                child: TriangleBuilder(
                  color: Colors.green[800],
                ),
              ),
              Positioned(
                // bottom: 60,
                top: 60,
                right: 10,
                child: Text(
                  number,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ],
          )),
    );
  }
}

class TriangleBuilder extends StatelessWidget {
  const TriangleBuilder({
    Key key,
    this.color,
  }) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ShapesPainter(color), child: Container());
  }
}

class _ShapesPainter extends CustomPainter {
  final Color color;
  _ShapesPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    var path = Path();
    path.lineTo(60, 0);
    path.lineTo(60, -60);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
