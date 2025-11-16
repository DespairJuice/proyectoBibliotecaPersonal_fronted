import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:8080'; // Para Android emulator
  // static const String baseUrl = 'http://192.168.1.100:8080';
  static const String baseUrl = 'https://proyectobibliotecapersonal.onrender.com'; // Para producción

  Future<List<dynamic>> listarLibros() async {
    final response = await http.get(Uri.parse(baseUrl));
    developer.log('GET $baseUrl - Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar libros: ${response.statusCode} - ${response.body}');
    }
  }

  Future<List<dynamic>> buscarLibros({String? titulo, String? autor, String? isbn, String? estadoLectura, int? calificacion}) async {
    final queryParameters = <String, String>{};
    if (titulo != null) queryParameters['titulo'] = titulo;
    if (autor != null) queryParameters['autor'] = autor;
    if (isbn != null) queryParameters['isbn'] = isbn;
    if (estadoLectura != null) queryParameters['estadoLectura'] = estadoLectura;
    if (calificacion != null) queryParameters['calificacion'] = calificacion.toString();
    final uri = Uri.parse('$baseUrl/buscar').replace(queryParameters: queryParameters);
    final response = await http.get(uri);
    developer.log('GET $uri - Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al buscar libros: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> obtenerLibro(String isbn) async {
    final response = await http.get(Uri.parse('$baseUrl/$isbn'));
    developer.log('GET $baseUrl/$isbn - Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Libro no encontrado: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> registrarLibro(Map<String, dynamic> libro) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(libro),
    );
    developer.log('POST $baseUrl - Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return {}; // Si no hay body, devolver mapa vacío
      }
    } else {
      throw Exception('Error al registrar libro: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> actualizarLibro(String isbnOriginal, Map<String, dynamic> libro) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$isbnOriginal'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(libro),
    );
    developer.log('PUT $baseUrl/$isbnOriginal - Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return json.decode(response.body);
      } else {
        return {}; // Si no hay body, devolver mapa vacío
      }
    } else if (response.statusCode == 404) {
      throw Exception('Libro no encontrado para actualizar');
    } else {
      throw Exception('Error al actualizar libro: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> eliminarLibro(String isbn) async {
    final response = await http.delete(Uri.parse('$baseUrl/$isbn'));
    developer.log('DELETE $baseUrl/$isbn - Status: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Eliminación exitosa, no hay body esperado
    } else {
      throw Exception('Error al eliminar libro: ${response.statusCode} - ${response.body}');
    }
  }
}
