
import 'package:pool_detect_app/domain/entities/detection.dart';

class DetectionModel extends Detection {
  const DetectionModel({
    required super.x,
    required super.y,
    required super.r,
    required super.label,
  });

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    return DetectionModel(
      x: json['x'] as int,
      y: json['y'] as int,
      r: json['r'] as int,
      label: json['label'] as String,
    );
  }
}
