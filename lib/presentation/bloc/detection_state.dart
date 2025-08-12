import 'package:equatable/equatable.dart';
import 'package:pool_detect_app/domain/entities/detection.dart';

abstract class DetectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetectionInitial extends DetectionState {}

class DetectionLoading extends DetectionState {}

class DetectionSuccess extends DetectionState {
  final String imagePath;
  final List<Detection> detections;
  final int serverImageW;
  final int serverImageH;

  DetectionSuccess({
    required this.imagePath,
    required this.detections,
    required this.serverImageW,
    required this.serverImageH,
  });

  @override
  List<Object?> get props => [imagePath, detections, serverImageW, serverImageH];
}

class DetectionFailure extends DetectionState {
  final String message;
  DetectionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
