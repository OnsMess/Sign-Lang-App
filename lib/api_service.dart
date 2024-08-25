import 'package:dio/dio.dart';

class ApiService {
  final String apiUrl = 'http://10.0.2.2:5000/upload-video';
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
        ));

  Future<String> sendVideoFile(String videoPath) async {
    try {
      FormData formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(videoPath, filename: "video.mp4"),
      });

      final response = await _dio.post(
        apiUrl,
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data['prediction'].toString();
      } else {
        return 'Error: ${response.statusCode} - ${response.statusMessage}';
      }
    } catch (e) {
      return 'Error occurred: $e';
    }
  }
}
