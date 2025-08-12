import 'dart:io';

import 'package:pool_detect_app/data/datasources/detection_remote_datasource.dart';
import 'package:pool_detect_app/domain/entities/detection.dart';
import 'package:pool_detect_app/domain/repositories/detection_repository.dart';

class DetectionRepositoryImpl implements DetectionRepository {
  final DetectionRemoteDataSource remote;
  DetectionRepositoryImpl(this.remote);

  @override
  Future<({List<Detection> detections, int imageW, int imageH})> detectBalls(File image) async {
    final result = await remote.detect(image);
    return (detections: List<Detection>.from(result.detections), imageW: result.imageW, imageH: result.imageH);
  }
}
