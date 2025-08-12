import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_client.dart';
import 'data/datasources/detection_remote_datasource.dart';
import 'data/repositories/detection_repository_impl.dart';
import 'domain/usecases/detect_balls.dart';
import 'presentation/bloc/detection_bloc.dart';
import 'presentation/pages/home_page.dart';

void main() {
  // If you test on Android emulator, use 10.0.2.2; on a real device use your machine's LAN IP.
  const baseUrl = 'http://10.0.2.2:8000';

  final api = ApiClient(baseUrl: baseUrl);
  final remote = DetectionRemoteDataSource(api);
  final repo = DetectionRepositoryImpl(remote);
  final usecase = DetectBalls(repo);

  runApp(MyApp(usecase: usecase));
}

class MyApp extends StatelessWidget {
  final DetectBalls usecase;
  const MyApp({super.key, required this.usecase});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CueZen',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => DetectionBloc(usecase),
        child: const HomePage(),
      ),
    );
  }
}
