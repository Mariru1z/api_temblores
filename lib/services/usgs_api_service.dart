// Importamos los paquetes necesarios para realizar solicitudes HTTP y manejar JSON.
import 'dart:convert'; // Para convertir la respuesta JSON en un objeto de Dart.
import 'package:http/http.dart' as http; // Cliente HTTP para hacer solicitudes a la API.
import '../models/earthquake.dart'; // Importamos el modelo que representa un terremoto.

/// Servicio para obtener datos de terremotos desde la API de USGS (United States Geological Survey).
class USGSApiService {
  final String baseUrl = 'https://earthquake.usgs.gov/fdsnws/event/1/'; // URL base de la API de USGS.

  /// Método para obtener una lista de terremotos en un rango de fechas.
  /// 
  /// Parámetros:
  /// - `startTime`: Fecha de inicio del intervalo de búsqueda.
  /// - `endTime`: Fecha de fin del intervalo de búsqueda.
  /// - `minMagnitude`: Magnitud mínima de los terremotos (por defecto es 0.0).
  /// - `limit`: Cantidad máxima de resultados a devolver (por defecto es 20).
  /// - `offset`: Paginación, indica desde qué posición comenzar (por defecto es 1).
  Future<List<Earthquake>> getEarthquakes({
    required DateTime startTime,
    required DateTime endTime,
    double minMagnitude = 0.0,
    int limit = 20,
    int offset = 1,
  }) async {
    // Convertimos las fechas a formato ISO 8601 (requerido por la API).
    String startTimeStr = startTime.toIso8601String();
    String endTimeStr = endTime.toIso8601String();

    // Construimos la URL de la solicitud con los parámetros necesarios.
    final response = await http.get(Uri.parse(
      '${baseUrl}query?format=geojson&starttime=$startTimeStr&endtime=$endTimeStr&minmagnitude=$minMagnitude&limit=$limit&offset=$offset'
    ));

    // Si la respuesta es exitosa (código 200), procesamos los datos.
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body); // Convertimos la respuesta en un mapa de Dart.
      final List<dynamic> features = data['features']; // Extraemos la lista de terremotos de la respuesta.

      // Convertimos cada terremoto del JSON a un objeto Earthquake y devolvemos la lista.
      return features.map((feature) => Earthquake.fromJson(feature)).toList();
    } else {
      // Si la respuesta falla, lanzamos una excepción con el código de error.
      throw Exception('Failed to load earthquakes: ${response.statusCode}');
    }
  }
}
