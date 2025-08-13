// lib/main.dart
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_client.dart';
import 'data/datasources/detection_remote_datasource.dart';
import 'data/repositories/detection_repository_impl.dart';
import 'domain/usecases/detect_balls.dart';
import 'presentation/bloc/detection_bloc.dart';
import 'presentation/pages/home_page.dart';

/// Default to the hosted API on Render. You can override at build time:
/// flutter run --dart-define=POOL_SERVER_URL=https://your-hosted-url
const String _renderUrl = String.fromEnvironment(
  'POOL_SERVER_URL',
  defaultValue: 'https://pool-detect-server.onrender.com',
);

/// Optional local LAN IP override for quick dev tests on a real device:
/// flutter run --dart-define=POOL_LOCAL_IP=192.168.1.123
const String _localIp = String.fromEnvironment('POOL_LOCAL_IP', defaultValue: '');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final baseUrl = await _getBaseUrl();
  final api = ApiClient(baseUrl: baseUrl, timeoutSeconds: 60); // allow cold-start
  final remote = DetectionRemoteDataSource(api);
  final repo = DetectionRepositoryImpl(remote);
  final usecase = DetectBalls(repo);

  runApp(MyApp(usecase: usecase));
}

Future<String> _getBaseUrl() async {
  // 1) Web always uses the hosted URL
  if (kIsWeb) return _renderUrl;

  // 2) Try local dev targets (only if they respond). If none respond, use Render.
  // Android emulator magic host
  if (Platform.isAndroid) {
    if (await _canConnect('10.0.2.2', 8000)) return 'http://10.0.2.2:8000';
  }

  // iOS simulator host
  if (Platform.isIOS) {
    if (await _canConnect('127.0.0.1', 8000)) return 'http://127.0.0.1:8000';
  }

  // Optional: user-provided LAN IP for local dev on a real device
  if (_localIp.isNotEmpty && await _canConnect(_localIp, 8000)) {
    return 'http://$_localIp:8000';
  }

  // 3) Fallback: hosted API on Render (works for client devices)
  return _renderUrl;
}

Future<bool> _canConnect(String host, int port, {Duration timeout = const Duration(milliseconds: 250)}) async {
  try {
    final socket = await Socket.connect(host, port, timeout: timeout);
    await socket.close();
    return true;
  } catch (_) {
    return false;
  }
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
