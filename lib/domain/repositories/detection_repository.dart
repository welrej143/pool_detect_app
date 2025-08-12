import 'dart:io';

import 'package:pool_detect_app/domain/entities/detection.dart';

abstract class DetectionRepository {
  /// Returns detections plus original image dimensions from server
  Future<({List<Detection> detections, int imageW, int imageH})> detectBalls(File image);
}
