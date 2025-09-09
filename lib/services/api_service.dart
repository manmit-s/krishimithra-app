import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // Production server URL from Render deployment
  static const String baseUrl =
      'https://krishimithra-server-render.onrender.com';

  // Timeout configurations
  static const Duration _connectTimeout = Duration(seconds: 30);
  static const Duration _receiveTimeout = Duration(seconds: 60);

  /// Send text message to Gemini via FastAPI
  static Future<String> sendMessage(String message) async {
    try {
      print('Sending message to: $baseUrl/generate');
      print('Message: $message');

      final response = await http
          .post(
            Uri.parse('$baseUrl/generate'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'prompt': message}),
          )
          .timeout(_receiveTimeout);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'No response from KrishiMithra';
      } else {
        print('Error response: ${response.body}');
        return 'Error: Unable to get response from KrishiMithra. Status: ${response.statusCode}';
      }
    } catch (e) {
      print('Network error: $e');
      return 'Network error: Please check your internet connection and try again. Error: $e';
    }
  }

  /// Send message with image to Gemini via FastAPI
  static Future<String> sendMessageWithImage(
    String message,
    String imagePath,
  ) async {
    try {
      print('=== IMAGE REQUEST DEBUG ===');
      print('Sending image message to: $baseUrl/analyze-image');
      print('Message: $message');
      print('Image path: $imagePath');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/analyze-image'),
      );

      // Add text prompt - always include a prompt
      String promptText = message.isNotEmpty
          ? message
          : "Please analyze this farming image and provide advice";
      request.fields['prompt'] = promptText;
      print('Prompt field: $promptText');

      // Add image file
      var file = await http.MultipartFile.fromPath(
        'file',
        imagePath,
        contentType: MediaType('image', _getImageExtension(imagePath)),
      );
      request.files.add(file);
      print('Image file added: ${file.filename}, size: ${file.length} bytes');

      // Send request
      print('Sending multipart request...');
      var streamedResponse = await request.send().timeout(_receiveTimeout);
      var response = await http.Response.fromStream(streamedResponse);

      print('Image response status: ${response.statusCode}');
      print('Image response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Parsed response data: $data');
        return data['response'] ?? 'No response from KrishiMithra';
      } else {
        print('Image error response: ${response.body}');
        return 'Error: Unable to process image. Status: ${response.statusCode}. Response: ${response.body}';
      }
    } catch (e) {
      print('Image network error: $e');
      return 'Network error: Please check your internet connection and try again. Error: $e';
    }
  }

  /// Helper method to get image extension
  static String _getImageExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  /// Health check endpoint
  static Future<bool> checkServerHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/health'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(_connectTimeout);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
