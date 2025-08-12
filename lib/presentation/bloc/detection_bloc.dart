import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pool_detect_app/domain/usecases/detect_balls.dart';
import 'detection_event.dart';
import 'detection_state.dart';

class DetectionBloc extends Bloc<DetectionEvent, DetectionState> {
  final DetectBalls detectBalls;
  final _picker = ImagePicker();

  DetectionBloc(this.detectBalls) : super(DetectionInitial()) {
    on<PickImagePressed>((event, emit) async {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      add(DetectRequested(File(picked.path)));
    });

    on<DetectRequested>((event, emit) async {
      emit(DetectionLoading());
      try {
        final result = await detectBalls(event.image);
        emit(DetectionSuccess(
          imagePath: event.image.path,
          detections: result.detections,
          serverImageW: result.imageW,
          serverImageH: result.imageH,
        ));
      } catch (e) {
        emit(DetectionFailure(e.toString()));
      }
    });
  }
}
