import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  ApiClient({required this.baseUrl});

  Future<http.Response> postMultipart(String path, File file) async {
    final uri = Uri.parse('$baseUrl$path');
    final req = http.MultipartRequest('POST', uri);
    req.files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamed = await req.send();
    return http.Response.fromStream(streamed);
  }
}
