import 'dart:io';

import 'package:pool_detect_app/domain/entities/detection.dart';
import 'package:pool_detect_app/domain/repositories/detection_repository.dart';

class DetectBalls {
  final DetectionRepository repo;
  DetectBalls(this.repo);

  Future<({List<Detection> detections, int imageW, int imageH})> call(File image) {
    return repo.detectBalls(image);
  }
}
