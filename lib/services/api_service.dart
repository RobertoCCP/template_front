import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../models/producto.dart';
import '../services/ApiResponse.dart';

class ApiService {
  final String forgotPasswordBaseUrl = "http://127.0.0.1:8000/api"; // Para el olvido de contraseña
  final String loginBaseUrl = "http://10.0.2.2:8000/api"; // Para el login en el emulador Android

  Future<ApiResponse> forgetPassword(String emailOrPhone) async {
    try {
      final response = await http.post(
        Uri.parse('$forgotPasswordBaseUrl/password/forgot'),
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

  Future<Usuario> loginCliente(String login, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$loginBaseUrl/login/cliente'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': login,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['error'] == '0' && jsonResponse['datos'] != null) {
          return Usuario.fromJson(jsonResponse['datos'][0]);
        } else {
          throw Exception(jsonResponse['mensaje'] ?? 'Error desconocido');
        }
      } else {
        throw Exception('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<Producto>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$loginBaseUrl/productosBusqueda/$query'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['datos'] != null) {
          List<dynamic> productosJson = jsonResponse['datos'];
          return productosJson.map((json) => Producto.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error en búsqueda: $e');
      return [];
    }
  }
}
