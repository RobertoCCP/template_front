import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/ApiResponse.dart';

class ApiService {
  final String baseUrl =
      "http://127.0.0.1:8000/api"; // Aquí se usa 127.0.0.1 para las pruebas locales en desarrollo.

  Future<ApiResponse> forgetPassword(String emailOrPhone) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/password/forgot'), // Ruta correcta para el olvido de contraseña
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': emailOrPhone}),
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          statusCode: 200,
          message: 'Enlace de recuperación enviado',
        );
      } else {
        return ApiResponse(
          statusCode: response.statusCode,
          message: 'Error al enviar el enlace',
        );
      }
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: 'Error de conexión',
      );
    }
  }
}
