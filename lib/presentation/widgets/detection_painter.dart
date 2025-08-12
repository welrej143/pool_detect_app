import 'package:flutter/material.dart';
import 'package:pool_detect_app/domain/entities/detection.dart';

class DetectionPainter extends CustomPainter {
  final List<Detection> detections;
  final double scaleX;
  final double scaleY;

  DetectionPainter({
    required this.detections,
    required this.scaleX,
    required this.scaleY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..color = Colors.greenAccent;

    for (final d in detections) {
      final cx = d.x * scaleX;
      final cy = d.y * scaleY;
      final r  = d.r * ((scaleX + scaleY) / 2.0);

      // ring color by label
      ring.color = _ringColor(d.label);

      // circle
      canvas.drawCircle(Offset(cx, cy), r, ring);

      // label pill ABOVE the circle
      final label = d.label;
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      const pad = 4.0;
      final w = tp.width + pad * 2;
      final h = tp.height + pad * 2;

      final pill = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          cx - w / 2,
          (cy - r) - h - 6, // 6px gap above the ring
          w,
          h,
        ),
        const Radius.circular(8),
      );

      // pill background w/ slight tint by type
      final bg = Paint()..color = _pillColor(d.label);
      canvas.drawRRect(pill, bg);

      // text
      tp.paint(canvas, Offset(pill.left + pad, pill.top + pad));
    }
  }

  Color _ringColor(String label) {
    final l = label.toLowerCase();
    if (l == 'cue') return Colors.white;
    if (l.contains('stripe')) return Colors.blueAccent;
    return Colors.greenAccent; // solid / default
  }

  Color _pillColor(String label) {
    final l = label.toLowerCase();
    if (l == 'cue') return Colors.black.withOpacity(0.55);
    if (l.contains('stripe')) return Colors.blueAccent.withOpacity(0.55);
    return Colors.green.withOpacity(0.55);
  }

  @override
  bool shouldRepaint(covariant DetectionPainter old) =>
      old.detections != detections || old.scaleX != scaleX || old.scaleY != scaleY;
}
