import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class DetectionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickImagePressed extends DetectionEvent {}

class DetectRequested extends DetectionEvent {
  final File image;
  DetectRequested(this.image);

  @override
  List<Object?> get props => [image];
}
