import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pool_detect_app/presentation/bloc/detection_bloc.dart';
import 'package:pool_detect_app/presentation/bloc/detection_event.dart';
import 'package:pool_detect_app/presentation/bloc/detection_state.dart';
import 'package:pool_detect_app/presentation/widgets/detection_painter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CueZen – Ball Detection')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<DetectionBloc, DetectionState>(
          builder: (context, state) {
            if (state is DetectionInitial) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.read<DetectionBloc>().add(PickImagePressed()),
                  child: const Text('Pick Image'),
                ),
              );
            }

            if (state is DetectionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DetectionFailure) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<DetectionBloc>().add(PickImagePressed()),
                    child: const Text('Try Again'),
                  )
                ],
              );
            }

            if (state is DetectionSuccess) {
              final imgFile = File(state.imagePath);

              return LayoutBuilder(builder: (context, constraints) {
                final aspect = state.serverImageW / state.serverImageH;

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        width: constraints.maxWidth,
                        child: AspectRatio(
                          aspectRatio: aspect,
                          child: LayoutBuilder(builder: (ctx, box) {
                            final displayW = box.maxWidth;
                            final displayH = box.maxHeight;

                            final scaleX = displayW / state.serverImageW;
                            final scaleY = displayH / state.serverImageH;

                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                // no fit => no stretch/crop as the box already matches aspect
                                Image.file(imgFile),
                                CustomPaint(
                                  painter: DetectionPainter(
                                    detections: state.detections,
                                    scaleX: scaleX,
                                    scaleY: scaleY,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Detections: ${state.detections.length}'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<DetectionBloc>().add(PickImagePressed()),
                        child: const Text('Pick Another Image'),
                      ),
                    ],
                  ),
                );
              });
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
